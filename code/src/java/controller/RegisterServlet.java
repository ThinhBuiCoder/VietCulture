package controller;

import dao.UserDAO;
import model.User;
import utils.PasswordUtils;
import utils.EmailUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * RegisterServlet with OTP-based email verification
 * Simple and user-friendly registration flow:
 * 1. User submits registration form
 * 2. System sends OTP to email
 * 3. User enters OTP to complete registration
 */
@WebServlet(urlPatterns = {"/register", "/verify-otp", "/resend-otp"})
public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(3);

    // Constants
    private static final String CSRF_TOKEN_ATTR = "csrfToken";
    private static final String REGISTER_VIEW = "/view/jsp/home/register.jsp";
    private static final String OTP_VERIFY_VIEW = "/view/jsp/home/verify-otp.jsp";
    private static final String SUCCESS_VIEW = "/view/jsp/home/verification-result.jsp";

    // OTP Settings
    private static final int OTP_EXPIRY_MINUTES = 10;
    private static final int MAX_OTP_ATTEMPTS = 5;
    private static final int MAX_RESEND_ATTEMPTS = 3;

    // Session attributes for OTP flow
    private static final String PENDING_USER_ATTR = "pendingUser";
    private static final String OTP_CODE_ATTR = "otpCode";
    private static final String OTP_EXPIRY_ATTR = "otpExpiry";
    private static final String OTP_ATTEMPTS_ATTR = "otpAttempts";
    private static final String RESEND_ATTEMPTS_ATTR = "resendAttempts";
    private static final String LAST_RESEND_TIME_ATTR = "lastResendTime";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            userDAO = new UserDAO();
            LOGGER.info("🚀 RegisterServlet (OTP) initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Failed to initialize RegisterServlet", e);
            throw new ServletException("Cannot initialize UserDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        LOGGER.info("📥 GET request: " + servletPath);

        try {
            switch (servletPath) {
                case "/register":
                    showRegisterForm(request, response);
                    break;
                case "/verify-otp":
                    showOTPVerificationForm(request, response);
                    break;
                case "/resend-otp":
                    handleResendOTP(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Error in doGet: " + servletPath, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        LOGGER.info("📤 POST request: " + servletPath);

        try {
            switch (servletPath) {
                case "/register":
                    handleRegistrationSubmit(request, response);
                    break;
                case "/verify-otp":
                    handleOTPVerification(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Error in doPost: " + servletPath, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Show registration form
     */
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Generate CSRF token
        String csrfToken = generateCSRFToken();
        HttpSession session = request.getSession(true);
        session.setAttribute(CSRF_TOKEN_ATTR, csrfToken);
        request.setAttribute(CSRF_TOKEN_ATTR, csrfToken);

        // Clear any existing OTP session data
        clearOTPSession(session);

        request.getRequestDispatcher(REGISTER_VIEW).forward(request, response);
    }

    /**
     * Handle registration form submission
     */
    private void handleRegistrationSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("=== 📝 REGISTRATION SUBMISSION STARTED ===");

        try {
            // Validate CSRF token
            if (!validateCSRFToken(request)) {
                setErrorAndForward(request, response, "Phiên làm việc không hợp lệ. Vui lòng thử lại.", REGISTER_VIEW);
                return;
            }

            // Extract and validate form data
            RegistrationData regData = extractRegistrationData(request);
            if (regData == null) {
                setErrorAndForward(request, response, "Dữ liệu không hợp lệ. Vui lòng thử lại.", REGISTER_VIEW);
                return;
            }

            // Validate registration data
            String validationError = validateRegistrationData(regData);
            if (validationError != null) {
                setErrorAndForward(request, response, validationError, REGISTER_VIEW);
                return;
            }

            // Check if email already exists
            if (userDAO.emailExists(regData.email())) {
                setErrorAndForward(request, response,
                    "Email này đã được sử dụng. Vui lòng sử dụng email khác.", REGISTER_VIEW);
                return;
            }

            // Create user object (but don't save to database yet)
            User pendingUser = createUserFromRegistrationData(regData);

            // Generate OTP and verification token
            String otpCode = EmailUtils.generateOTP();
            String verificationToken = PasswordUtils.generateVerificationToken();
            Date otpExpiry = getOTPExpiry();

            LOGGER.info("📧 Generated OTP for " + regData.email() + ": " + otpCode);

            // Store in session
            HttpSession session = request.getSession();
            session.setAttribute(PENDING_USER_ATTR, pendingUser);
            session.setAttribute(OTP_CODE_ATTR, otpCode);
            session.setAttribute(OTP_EXPIRY_ATTR, otpExpiry);
            session.setAttribute(OTP_ATTEMPTS_ATTR, 0);
            session.setAttribute(RESEND_ATTEMPTS_ATTR, 0);
            session.setAttribute("verificationToken", verificationToken);

            // Send OTP email asynchronously
            sendOTPEmailAsync(regData.email(), regData.fullName(), otpCode);

            LOGGER.info("✅ Registration data validated and OTP sent to: " + regData.email());

            // Redirect to OTP verification page
            response.sendRedirect(request.getContextPath() + "/verify-otp");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "❌ Database error during registration", e);
            setErrorAndForward(request, response, "Có lỗi hệ thống. Vui lòng thử lại sau.", REGISTER_VIEW);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Unexpected error during registration", e);
            setErrorAndForward(request, response, "Có lỗi không mong muốn. Vui lòng thử lại.", REGISTER_VIEW);
        }
    }

    /**
     * Show OTP verification form
     */
    private void showOTPVerificationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(PENDING_USER_ATTR) == null) {
            // No pending registration, redirect to register page
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        User pendingUser = (User) session.getAttribute(PENDING_USER_ATTR);
        Date otpExpiry = (Date) session.getAttribute(OTP_EXPIRY_ATTR);
        Integer attempts = (Integer) session.getAttribute(OTP_ATTEMPTS_ATTR);
        Integer resendAttempts = (Integer) session.getAttribute(RESEND_ATTEMPTS_ATTR);

        // Check if OTP has expired
        if (otpExpiry != null && otpExpiry.before(new Date())) {
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
            request.setAttribute("otpExpired", true);
        }

        // Set form data
        request.setAttribute("userEmail", pendingUser.getEmail());
        request.setAttribute("userName", pendingUser.getFullName());
        request.setAttribute("otpAttempts", attempts != null ? attempts : 0);
        request.setAttribute("maxOtpAttempts", MAX_OTP_ATTEMPTS);
        request.setAttribute("resendAttempts", resendAttempts != null ? resendAttempts : 0);
        request.setAttribute("maxResendAttempts", MAX_RESEND_ATTEMPTS);
        request.setAttribute("otpExpiryMinutes", OTP_EXPIRY_MINUTES);

        // Calculate remaining time
        if (otpExpiry != null && otpExpiry.after(new Date())) {
            long remainingTime = (otpExpiry.getTime() - System.currentTimeMillis()) / 1000;
            request.setAttribute("remainingTime", remainingTime);
        }

        request.getRequestDispatcher(OTP_VERIFY_VIEW).forward(request, response);
    }

    /**
     * Handle OTP verification
     */
    private void handleOTPVerification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("=== 🔐 OTP VERIFICATION STARTED ===");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(PENDING_USER_ATTR) == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        try {
            User pendingUser = (User) session.getAttribute(PENDING_USER_ATTR);
            String storedOTP = (String) session.getAttribute(OTP_CODE_ATTR);
            String verificationToken = (String) session.getAttribute("verificationToken");
            Date otpExpiry = (Date) session.getAttribute(OTP_EXPIRY_ATTR);
            Integer attempts = (Integer) session.getAttribute(OTP_ATTEMPTS_ATTR);

            // Get submitted OTP
            String submittedOTP = request.getParameter("otpCode");
            if (submittedOTP != null) {
                submittedOTP = submittedOTP.trim().replaceAll("\\s+", "");
            }

            LOGGER.info("🔍 OTP verification attempt for: " + pendingUser.getEmail());

            // Validate OTP input
            if (submittedOTP == null || submittedOTP.isEmpty()) {
                setOTPError(request, response, session, "Vui lòng nhập mã OTP.");
                return;
            }

            if (!submittedOTP.matches("\\d{6}")) {
                setOTPError(request, response, session, "Mã OTP phải là 6 chữ số.");
                return;
            }

            // Check attempts limit
            attempts = attempts != null ? attempts : 0;
            if (attempts >= MAX_OTP_ATTEMPTS) {
                clearOTPSession(session);
                response.sendRedirect(request.getContextPath() + "/register?error=max_attempts");
                return;
            }

            // Check OTP expiry
            if (otpExpiry == null || otpExpiry.before(new Date())) {
                setOTPError(request, response, session, "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
                request.setAttribute("otpExpired", true);
                return;
            }

            // Verify OTP
            if (!submittedOTP.equals(storedOTP)) {
                attempts++;
                session.setAttribute(OTP_ATTEMPTS_ATTR, attempts);

                int remainingAttempts = MAX_OTP_ATTEMPTS - attempts;
                String errorMsg = "Mã OTP không đúng.";

                if (remainingAttempts > 0) {
                    errorMsg += " Bạn còn " + remainingAttempts + " lần thử.";
                } else {
                    errorMsg = "Bạn đã nhập sai mã OTP quá nhiều lần. Vui lòng đăng ký lại.";
                }

                LOGGER.warning("❌ Invalid OTP for " + pendingUser.getEmail() +
                              ". Attempts: " + attempts + "/" + MAX_OTP_ATTEMPTS);

                if (remainingAttempts <= 0) {
                    clearOTPSession(session);
                    response.sendRedirect(request.getContextPath() + "/register?error=max_attempts");
                    return;
                }

                setOTPError(request, response, session, errorMsg);
                return;
            }

            // OTP is correct - save user to database
            LOGGER.info("✅ OTP verification successful for: " + pendingUser.getEmail());

            // Set verification token and expiry
            pendingUser.setVerificationToken(verificationToken);
            pendingUser.setTokenExpiry(otpExpiry);

            int userId = userDAO.createUser(pendingUser);
            if (userId <= 0) {
                LOGGER.severe("❌ Failed to save user to database: " + pendingUser.getEmail());
                setOTPError(request, response, session, "Có lỗi xảy ra khi tạo tài khoản. Vui lòng thử lại.");
                return;
            }

            // Verify email
            boolean verified = userDAO.verifyEmail(userId);
            if (!verified) {
                LOGGER.severe("❌ Failed to verify email for user ID: " + userId);
                setOTPError(request, response, session, "Có lỗi xảy ra khi xác minh email. Vui lòng thử lại.");
                return;
            }

            pendingUser.setUserId(userId);
            LOGGER.info("✅ User created and email verified successfully with ID: " + userId);

            // Send welcome email asynchronously
            sendWelcomeEmailAsync(pendingUser.getEmail(), pendingUser.getFullName());

            // Clear OTP session data
            clearOTPSession(session);

            // Set success data
            session.setAttribute("registeredUser", pendingUser);

            LOGGER.info("🎉 Registration completed successfully for: " + pendingUser.getEmail());

            // Forward to success page
            request.setAttribute("success", true);
            request.getRequestDispatcher(SUCCESS_VIEW).forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "❌ Database error during OTP verification", e);
            setOTPError(request, response, session, "Có lỗi hệ thống. Vui lòng thử lại sau.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Unexpected error during OTP verification", e);
            setOTPError(request, response, session, "Có lỗi không mong muốn. Vui lòng thử lại.");
        }
    }

    /**
     * Handle resend OTP request
     */
    private void handleResendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("=== 🔄 RESEND OTP REQUEST ===");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(PENDING_USER_ATTR) == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        try {
            User pendingUser = (User) session.getAttribute(PENDING_USER_ATTR);
            Integer resendAttempts = (Integer) session.getAttribute(RESEND_ATTEMPTS_ATTR);
            Date lastResendTime = (Date) session.getAttribute(LAST_RESEND_TIME_ATTR);

            resendAttempts = resendAttempts != null ? resendAttempts : 0;

            // Check resend attempts limit
            if (resendAttempts >= MAX_RESEND_ATTEMPTS) {
                clearOTPSession(session);
                response.sendRedirect(request.getContextPath() + "/register?error=max_resends");
                return;
            }

            // Check resend cooldown (30 seconds)
            if (lastResendTime != null) {
                long timeSinceLastResend = System.currentTimeMillis() - lastResendTime.getTime();
                if (timeSinceLastResend < 30000) { // 30 seconds
                    long remainingCooldown = (30000 - timeSinceLastResend) / 1000;
                    setOTPError(request, response, session,
                        "Vui lòng đợi " + remainingCooldown + " giây trước khi yêu cầu gửi lại mã.");
                    return;
                }
            }

            // Generate new OTP and verification token
            String newOTPCode = EmailUtils.generateOTP();
            String newVerificationToken = PasswordUtils.generateVerificationToken();
            Date newOTPExpiry = getOTPExpiry();

            // Update session
            session.setAttribute(OTP_CODE_ATTR, newOTPCode);
            session.setAttribute(OTP_EXPIRY_ATTR, newOTPExpiry);
            session.setAttribute(OTP_ATTEMPTS_ATTR, 0); // Reset attempts
            session.setAttribute(RESEND_ATTEMPTS_ATTR, resendAttempts + 1);
            session.setAttribute(LAST_RESEND_TIME_ATTR, new Date());
            session.setAttribute("verificationToken", newVerificationToken);

            // Send new OTP email
            sendOTPEmailAsync(pendingUser.getEmail(), pendingUser.getFullName(), newOTPCode);

            LOGGER.info("✅ New OTP sent to: " + pendingUser.getEmail() +
                       " (Resend attempt: " + (resendAttempts + 1) + ")");

            // Redirect back to OTP verification with success message
            response.sendRedirect(request.getContextPath() + "/verify-otp?resent=true");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Error during OTP resend", e);
            setOTPError(request, response, session, "Có lỗi khi gửi lại mã OTP. Vui lòng thử lại.");
        }
    }

    /**
     * Send OTP email asynchronously
     */
    private void sendOTPEmailAsync(String email, String userName, String otpCode) {
        emailExecutor.submit(() -> {
            try {
                boolean result = EmailUtils.sendRegistrationOTP(email, userName, otpCode);
                if (result) {
                    LOGGER.info("✅ OTP email sent successfully to: " + email);
                } else {
                    LOGGER.severe("❌ Failed to send OTP email to: " + email);
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "❌ Exception sending OTP email to: " + email, e);
            }
        });
    }

    /**
     * Send welcome email asynchronously
     */
    private void sendWelcomeEmailAsync(String email, String userName) {
        emailExecutor.submit(() -> {
            try {
                boolean result = EmailUtils.sendWelcomeEmail(email, userName);
                if (result) {
                    LOGGER.info("✅ Welcome email sent successfully to: " + email);
                } else {
                    LOGGER.warning("⚠️ Failed to send welcome email to: " + email);
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "❌ Exception sending welcome email to: " + email, e);
            }
        });
    }

    /**
     * Validation and utility methods
     */
    private boolean validateCSRFToken(HttpServletRequest request) {
        try {
            String submittedToken = request.getParameter(CSRF_TOKEN_ATTR);
            HttpSession session = request.getSession(false);

            if (session == null) return false;

            String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
            boolean isValid = submittedToken != null && sessionToken != null &&
                             submittedToken.equals(sessionToken);

            if (isValid) {
                session.removeAttribute(CSRF_TOKEN_ATTR); // Use once
            }

            return isValid;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "❌ CSRF validation error", e);
            return false;
        }
    }

    private RegistrationData extractRegistrationData(HttpServletRequest request) {
        try {
            String fullName = sanitizeInput(request.getParameter("fullName"));
            String email = sanitizeInput(request.getParameter("email"));
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String role = sanitizeInput(request.getParameter("role"));
            boolean agreeTerms = "on".equals(request.getParameter("agreeTerms"));

            if (email != null) email = email.toLowerCase().trim();
            if (fullName != null) fullName = fullName.trim();

            return new RegistrationData(fullName, email, password, confirmPassword, role, agreeTerms);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "❌ Error extracting registration data", e);
            return null;
        }
    }

    private String validateRegistrationData(RegistrationData data) {
        // Full name validation
        if (data.fullName() == null || data.fullName().length() < 2) {
            return "Họ tên phải có ít nhất 2 ký tự.";
        }
        if (data.fullName().length() > 100) {
            return "Họ tên không được vượt quá 100 ký tự.";
        }
        if (!data.fullName().matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
            return "Họ tên chỉ được chứa chữ cái và khoảng trắng.";
        }

        // Email validation
        if (data.email() == null || !isValidEmail(data.email())) {
            return "Vui lòng nhập địa chỉ email hợp lệ.";
        }
        if (data.email().length() > 100) {
            return "Địa chỉ email quá dài.";
        }

        // Password validation
        if (data.password() == null || data.password().length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự.";
        }
        if (data.password().length() > 100) {
            return "Mật khẩu quá dài.";
        }
        if (!data.password().equals(data.confirmPassword())) {
            return "Mật khẩu xác nhận không khớp.";
        }

        // Role validation
        if (data.role() == null ||
            (!data.role().equals("TRAVELER") && !data.role().equals("HOST"))) {
            return "Vui lòng chọn vai trò tham gia.";
        }

        // Terms validation
        if (!data.agreeTerms()) {
            return "Bạn phải đồng ý với điều khoản sử dụng.";
        }

        return null; // Valid
    }

    private User createUserFromRegistrationData(RegistrationData data) {
        User user = new User();
        user.setEmail(data.email());
        user.setFullName(data.fullName());
        user.setRole(data.role());
        user.setPassword(PasswordUtils.hashPasswordWithSalt(data.password()));
        user.setActive(true);
        user.setEmailVerified(false); // Will be verified after OTP
        user.setCreatedAt(new Date());

        // Set role-specific defaults
        if ("TRAVELER".equals(data.role())) {
            user.setPreferences("{\"likes\": []}"); // Default empty preferences
            user.setTotalBookings(0);
        } else if ("HOST".equals(data.role())) {
            user.setBusinessName(data.fullName() + "'s Business");
            user.setBusinessType(""); // To be set later
            user.setAverageRating(0.0);
            user.setTotalExperiences(0);
            user.setTotalRevenue(0.0);
        }

        return user;
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    }

    private String sanitizeInput(String input) {
        if (input == null) return null;
        return input.trim()
                   .replaceAll("<script[^>]*>.*?</script>", "")
                   .replaceAll("<.*?>", "");
    }

    private String generateCSRFToken() {
        return PasswordUtils.generateVerificationToken();
    }

    private Date getOTPExpiry() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, OTP_EXPIRY_MINUTES);
        return cal.getTime();
    }

    private void clearOTPSession(HttpSession session) {
        session.removeAttribute(PENDING_USER_ATTR);
        session.removeAttribute(OTP_CODE_ATTR);
        session.removeAttribute(OTP_EXPIRY_ATTR);
        session.removeAttribute(OTP_ATTEMPTS_ATTR);
        session.removeAttribute(RESEND_ATTEMPTS_ATTR);
        session.removeAttribute(LAST_RESEND_TIME_ATTR);
        session.removeAttribute("verificationToken");
    }

    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response,
                                   String errorMessage, String viewPath) throws ServletException, IOException {
        request.setAttribute("error", errorMessage);

        // Generate new CSRF token
        String csrfToken = generateCSRFToken();
        HttpSession session = request.getSession(true);
        session.setAttribute(CSRF_TOKEN_ATTR, csrfToken);
        request.setAttribute(CSRF_TOKEN_ATTR, csrfToken);

        request.getRequestDispatcher(viewPath).forward(request, response);
    }

    private void setOTPError(HttpServletRequest request, HttpServletResponse response,
                            HttpSession session, String errorMessage) throws ServletException, IOException {

        User pendingUser = (User) session.getAttribute(PENDING_USER_ATTR);
        Date otpExpiry = (Date) session.getAttribute(OTP_EXPIRY_ATTR);
        Integer attempts = (Integer) session.getAttribute(OTP_ATTEMPTS_ATTR);
        Integer resendAttempts = (Integer) session.getAttribute(RESEND_ATTEMPTS_ATTR);

        request.setAttribute("error", errorMessage);
        request.setAttribute("userEmail", pendingUser.getEmail());
        request.setAttribute("userName", pendingUser.getFullName());
        request.setAttribute("otpAttempts", attempts != null ? attempts : 0);
        request.setAttribute("maxOtpAttempts", MAX_OTP_ATTEMPTS);
        request.setAttribute("resendAttempts", resendAttempts != null ? resendAttempts : 0);
        request.setAttribute("maxResendAttempts", MAX_RESEND_ATTEMPTS);
        request.setAttribute("otpExpiryMinutes", OTP_EXPIRY_MINUTES);

        if (otpExpiry != null && otpExpiry.after(new Date())) {
            long remainingTime = (otpExpiry.getTime() - System.currentTimeMillis()) / 1000;
            request.setAttribute("remainingTime", remainingTime);
        }

        request.getRequestDispatcher(OTP_VERIFY_VIEW).forward(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("🔄 Shutting down RegisterServlet...");

        emailExecutor.shutdown();
        try {
            if (!emailExecutor.awaitTermination(30, TimeUnit.SECONDS)) {
                emailExecutor.shutdownNow();
            }
        } catch (InterruptedException e) {
            emailExecutor.shutdownNow();
            Thread.currentThread().interrupt();
        }

        LOGGER.info("✅ RegisterServlet destroyed successfully");
    }

    /**
     * Record for registration data
     */
    private record RegistrationData(
        String fullName,
        String email,
        String password,
        String confirmPassword,
        String role,
        boolean agreeTerms
    ) {}
}