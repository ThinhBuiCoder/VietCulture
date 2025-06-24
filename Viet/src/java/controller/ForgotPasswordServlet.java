package controller;

import dao.UserDAO;
import model.User;
import utils.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
<<<<<<< HEAD

    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private UserDAO userDAO;

    // OTP expiry time in minutes
    private static final int OTP_EXPIRY_MINUTES = 10;

    // Rate limiting: max attempts per IP
    private static final int MAX_ATTEMPTS_PER_HOUR = 5;

    // Email pattern for validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    // Password pattern for validation
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
            "^(?=.*[a-zA-Z])(?=.*\\d).{6,}$" // At least 6 chars with letter and number
    );

=======
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private UserDAO userDAO;
    
    // OTP expiry time in minutes
    private static final int OTP_EXPIRY_MINUTES = 10;
    
    // Rate limiting: max attempts per IP
    private static final int MAX_ATTEMPTS_PER_HOUR = 5;
    
    // Email pattern for validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );
    
    // Password pattern for validation
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-zA-Z])(?=.*\\d).{6,}$" // At least 6 chars with letter and number
    );
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
<<<<<<< HEAD

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Clear any existing session data
        HttpSession session = request.getSession();
        clearForgotPasswordSession(session);

        request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

=======
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Clear any existing session data
        HttpSession session = request.getSession();
        clearForgotPasswordSession(session);
        
        request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Basic input validation
        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/jsp/home/forgot-password.jsp");
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Rate limiting check
        if (!checkRateLimit(request)) {
            request.setAttribute("error", "Bạn đã thực hiện quá nhiều yêu cầu. Vui lòng thử lại sau 1 giờ.");
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        switch (action) {
            case "sendOTP":
                handleSendOTP(request, response);
                break;
            case "verifyOTP":
                handleVerifyOTP(request, response);
                break;
            case "resetPassword":
                handleResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/view/jsp/home/forgot-password.jsp");
                break;
        }
    }
<<<<<<< HEAD

    /**
     * Handle sending OTP to user's email
     */
    private void handleSendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

=======
    
    /**
     * Handle sending OTP to user's email
     */
    private void handleSendOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Input validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email.");
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

        email = email.toLowerCase().trim();

=======
        
        email = email.toLowerCase().trim();
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Email format validation
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("error", "Định dạng email không hợp lệ.");
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Email length validation
        if (email.length() > 254) {
            request.setAttribute("error", "Email quá dài.");
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

        String clientIP = getClientIP(request);
        LOGGER.info("Password reset attempt from IP: " + clientIP + " for email: " + email);

        try {
            // Check if user exists
            User user = userDAO.getUserByEmail(email);

            // Always show the same message for security (prevent email enumeration)
            String successMessage = "Nếu email này tồn tại trong hệ thống, bạn sẽ nhận được mã OTP trong ít phút.";

            if (user != null) {
                // Generate OTP
                String otpCode = EmailUtils.generateOTP();

                // Send OTP email
                boolean emailSent = EmailUtils.sendPasswordResetOTP(email, user.getFullName(), otpCode);

=======
        
        String clientIP = getClientIP(request);
        LOGGER.info("Password reset attempt from IP: " + clientIP + " for email: " + email);
        
        try {
            // Check if user exists
            User user = userDAO.getUserByEmail(email);
            
            // Always show the same message for security (prevent email enumeration)
            String successMessage = "Nếu email này tồn tại trong hệ thống, bạn sẽ nhận được mã OTP trong ít phút.";
            
            if (user != null) {
                // Generate OTP
                String otpCode = EmailUtils.generateOTP();
                
                // Send OTP email
                boolean emailSent = EmailUtils.sendPasswordResetOTP(email, user.getFullName(), otpCode);
                
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                if (emailSent) {
                    // Store OTP data in session
                    HttpSession session = request.getSession();
                    session.setAttribute("forgotPasswordEmail", email);
                    session.setAttribute("otpCode", otpCode);
                    session.setAttribute("otpExpiry", LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));
                    session.setAttribute("otpAttempts", 0); // Track failed attempts
<<<<<<< HEAD

=======
                    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                    LOGGER.info("Password reset OTP sent successfully to: " + email);
                } else {
                    LOGGER.severe("Failed to send password reset OTP to: " + email);
                    // Don't reveal the failure to prevent information disclosure
                }
            }
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            // Always show success message and OTP form
            request.setAttribute("success", successMessage);
            request.setAttribute("showOtpForm", true);
            request.setAttribute("email", email);
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during forgot password for: " + email, e);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during forgot password for: " + email, e);
            request.setAttribute("error", "Có lỗi không xác định xảy ra. Vui lòng thử lại sau.");
        }
<<<<<<< HEAD

        request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
    }

    /**
     * Handle OTP verification
     */
    private void handleVerifyOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String enteredOTP = request.getParameter("otp");

=======
        
        request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
    }
    
    /**
     * Handle OTP verification
     */
    private void handleVerifyOTP(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String enteredOTP = request.getParameter("otp");
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        HttpSession session = request.getSession();
        String sessionEmail = (String) session.getAttribute("forgotPasswordEmail");
        String sessionOTP = (String) session.getAttribute("otpCode");
        LocalDateTime otpExpiry = (LocalDateTime) session.getAttribute("otpExpiry");
        Integer otpAttempts = (Integer) session.getAttribute("otpAttempts");
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Initialize attempts if null
        if (otpAttempts == null) {
            otpAttempts = 0;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Validate session data
        if (sessionEmail == null || sessionOTP == null || otpExpiry == null) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            clearForgotPasswordSession(session);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Validate email matches
        if (!sessionEmail.equals(email)) {
            request.setAttribute("error", "Email không hợp lệ.");
            clearForgotPasswordSession(session);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Check for too many failed attempts
        if (otpAttempts >= 3) {
            request.setAttribute("error", "Bạn đã nhập sai mã OTP quá nhiều lần. Vui lòng yêu cầu mã mới.");
            clearForgotPasswordSession(session);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Validate OTP input
        if (enteredOTP == null || enteredOTP.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã OTP.");
            request.setAttribute("showOtpForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

        enteredOTP = enteredOTP.trim();

=======
        
        enteredOTP = enteredOTP.trim();
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Validate OTP format (6 digits)
        if (!enteredOTP.matches("\\d{6}")) {
            otpAttempts++;
            session.setAttribute("otpAttempts", otpAttempts);
            request.setAttribute("error", "Mã OTP phải là 6 chữ số.");
            request.setAttribute("showOtpForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Check OTP expiry
        if (LocalDateTime.now().isAfter(otpExpiry)) {
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
            clearForgotPasswordSession(session);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Verify OTP
        if (!sessionOTP.equals(enteredOTP)) {
            otpAttempts++;
            session.setAttribute("otpAttempts", otpAttempts);
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            String errorMsg = "Mã OTP không đúng. ";
            if (otpAttempts >= 3) {
                errorMsg += "Bạn đã nhập sai quá nhiều lần. Vui lòng yêu cầu mã mới.";
                clearForgotPasswordSession(session);
            } else {
                errorMsg += "Còn lại " + (3 - otpAttempts) + " lần thử.";
                request.setAttribute("showOtpForm", true);
                request.setAttribute("email", email);
            }
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // OTP verified successfully
        session.setAttribute("otpVerified", true);
        session.setAttribute("otpVerifiedTime", LocalDateTime.now());
        session.removeAttribute("otpCode"); // Remove OTP after successful verification
        session.removeAttribute("otpAttempts");
<<<<<<< HEAD

        request.setAttribute("success", "Mã OTP chính xác. Vui lòng nhập mật khẩu mới.");
        request.setAttribute("showPasswordForm", true);
        request.setAttribute("email", email);

        LOGGER.info("OTP verified successfully for: " + email);

        request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
    }

    /**
     * Handle password reset
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

=======
        
        request.setAttribute("success", "Mã OTP chính xác. Vui lòng nhập mật khẩu mới.");
        request.setAttribute("showPasswordForm", true);
        request.setAttribute("email", email);
        
        LOGGER.info("OTP verified successfully for: " + email);
        
        request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
    }
    
    /**
     * Handle password reset
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        HttpSession session = request.getSession();
        String sessionEmail = (String) session.getAttribute("forgotPasswordEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        LocalDateTime otpVerifiedTime = (LocalDateTime) session.getAttribute("otpVerifiedTime");
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Validate session
        if (sessionEmail == null || !Boolean.TRUE.equals(otpVerified) || !sessionEmail.equals(email)) {
            request.setAttribute("error", "Phiên làm việc không hợp lệ. Vui lòng thử lại.");
            clearForgotPasswordSession(session);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Check if OTP verification is still valid (5 minutes window)
        if (otpVerifiedTime == null || LocalDateTime.now().isAfter(otpVerifiedTime.plusMinutes(5))) {
            request.setAttribute("error", "Phiên xác thực đã hết hạn. Vui lòng thử lại.");
            clearForgotPasswordSession(session);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

        // Validate passwords
        if (newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
=======
        
        // Validate passwords
        if (newPassword == null || newPassword.trim().isEmpty() || 
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu mới.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

        newPassword = newPassword.trim();
        confirmPassword = confirmPassword.trim();

=======
        
        newPassword = newPassword.trim();
        confirmPassword = confirmPassword.trim();
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Password length validation
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Password strength validation
        if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
            request.setAttribute("error", "Mật khẩu phải chứa ít nhất 1 chữ cái và 1 chữ số.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Password length limit
        if (newPassword.length() > 128) {
            request.setAttribute("error", "Mật khẩu không được quá 128 ký tự.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Password confirmation validation
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        try {
            // Double-check user exists before updating
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Người dùng không tồn tại.");
                clearForgotPasswordSession(session);
                request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
                return;
            }
<<<<<<< HEAD

            // Update password
            boolean updated = userDAO.updatePassword(email, newPassword);

            if (updated) {
                // Clear session data
                clearForgotPasswordSession(session);

                LOGGER.info("Password reset successfully for: " + email);

=======
            
            // Update password
            boolean updated = userDAO.updatePassword(email, newPassword);
            
            if (updated) {
                // Clear session data
                clearForgotPasswordSession(session);
                
                LOGGER.info("Password reset successfully for: " + email);
                
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                // Send confirmation email (optional)
                try {
                    EmailUtils.sendPasswordResetConfirmation(email, user.getFullName());
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Failed to send password reset confirmation to: " + email, e);
                    // Don't fail the entire process if confirmation email fails
                }
<<<<<<< HEAD

                // Redirect to login with success message
                response.sendRedirect(request.getContextPath() + "/view/jsp/home/login.jsp?success=passwordReset");

=======
                
                // Redirect to login with success message
                response.sendRedirect(request.getContextPath() + "/view/jsp/home/login.jsp?success=passwordReset");
                
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            } else {
                request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                request.setAttribute("showPasswordForm", true);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
            }
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during password reset for: " + email, e);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during password reset for: " + email, e);
            request.setAttribute("error", "Có lỗi không xác định xảy ra. Vui lòng thử lại sau.");
            request.setAttribute("showPasswordForm", true);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/view/jsp/home/forgot-password.jsp").forward(request, response);
        }
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Clear all forgot password related session attributes
     */
    private void clearForgotPasswordSession(HttpSession session) {
        session.removeAttribute("forgotPasswordEmail");
        session.removeAttribute("otpCode");
        session.removeAttribute("otpExpiry");
        session.removeAttribute("otpVerified");
        session.removeAttribute("otpVerifiedTime");
        session.removeAttribute("otpAttempts");
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Get client IP address
     */
    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        String xRealIP = request.getHeader("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty()) {
            return xRealIP.trim();
        }
<<<<<<< HEAD

        return request.getRemoteAddr();
    }

    /**
     * Simple rate limiting check In production, use Redis or a proper rate
     * limiting solution
=======
        
        return request.getRemoteAddr();
    }
    
    /**
     * Simple rate limiting check
     * In production, use Redis or a proper rate limiting solution
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     */
    private boolean checkRateLimit(HttpServletRequest request) {
        // This is a basic implementation
        // In production, implement proper rate limiting with Redis or database
        String clientIP = getClientIP(request);
<<<<<<< HEAD

        // For now, just log the IP for monitoring
        LOGGER.info("Request from IP: " + clientIP);

=======
        
        // For now, just log the IP for monitoring
        LOGGER.info("Request from IP: " + clientIP);
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Always return true for this basic implementation
        // Implement actual rate limiting based on your infrastructure
        return true;
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
