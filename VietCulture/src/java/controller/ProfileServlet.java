package controller;

import dao.UserDAO;
import dao.BookingDAO;
import dao.ExperienceDAO;
import model.User;
import utils.FileUploadUtils;
import utils.PasswordUtils;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.List;
import java.util.ArrayList;
import model.Booking;

@WebServlet(urlPatterns = {"/profile", "/profile/update", "/profile/change-password", "/profile/bookings", "/profile/booking-detail"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());

    private UserDAO userDAO;
    private BookingDAO bookingDAO;
    private ExperienceDAO experienceDAO;

    @Override
    public void init() throws ServletException {
        System.out.println("************************************************");
        System.out.println("*** PROFILESERVLET INIT CALLED - DEPLOYED! ***");
        System.out.println("************************************************");
        userDAO = new UserDAO();
        bookingDAO = new BookingDAO();
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== PROFILESERVLET DOGET CALLED ===");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        // Check if user is logged in
        if (sessionUser == null) {
            System.out.println("User not logged in, redirecting to login");
            LOGGER.warning("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy userId từ URL nếu có
        String userIdParam = request.getParameter("userId");
        int profileUserId = sessionUser.getUserId();
        if (userIdParam != null) {
            try {
                profileUserId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                // Nếu lỗi thì vẫn dùng user đang đăng nhập
            }
        }

        String servletPath = request.getServletPath();
        if ("/profile/bookings".equals(servletPath)) {
            try {
                User profileUser = userDAO.getUserById(profileUserId);
                if (profileUser == null) {
                    request.setAttribute("error", "Không tìm thấy người dùng này!");
                    request.getRequestDispatcher("/view/jsp/home/booking-history.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("profileUser", profileUser);
                // Lấy toàn bộ lịch sử booking (không phân trang)
                List<Booking> bookingHistory = bookingDAO.getBookingsByUser(profileUser.getUserId(), 0, Integer.MAX_VALUE);
                request.setAttribute("bookingHistory", bookingHistory);
                request.getRequestDispatcher("/view/jsp/home/booking-history.jsp").forward(request, response);
                return;
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi tải lịch sử đặt chỗ!");
                request.getRequestDispatcher("/view/jsp/home/booking-history.jsp").forward(request, response);
                return;
            }
        }
        if ("/profile/booking-detail".equals(servletPath)) {
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam == null) {
                request.setAttribute("error", "Thiếu mã booking!");
                request.getRequestDispatcher("/view/jsp/home/booking-detail.jsp").forward(request, response);
                return;
            }
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                Booking booking = bookingDAO.getBookingById(bookingId);
                if (booking == null) {
                    request.setAttribute("error", "Không tìm thấy booking này!");
                    request.getRequestDispatcher("/view/jsp/home/booking-detail.jsp").forward(request, response);
                    return;
                }
                // Lấy user đặt booking
                User profileUser = userDAO.getUserById(booking.getTravelerId());
                request.setAttribute("profileUser", profileUser);
                request.setAttribute("booking", booking);
                // Parse contactInfo JSON nếu có
                String contactInfo = booking.getContactInfo();
                String contactName = "";
                String contactEmail = "";
                String contactPhone = "";
                if (contactInfo != null && contactInfo.trim().startsWith("{")) {
                    try {
                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode node = mapper.readTree(contactInfo);
                        contactName = node.has("contactName") ? node.get("contactName").asText("") : "";
                        contactEmail = node.has("contactEmail") ? node.get("contactEmail").asText("") : "";
                        contactPhone = node.has("contactPhone") ? node.get("contactPhone").asText("") : "";
                    } catch (Exception e) {
                        // ignore parse error
                    }
                }
                request.setAttribute("contactName", contactName);
                request.setAttribute("contactEmail", contactEmail);
                request.setAttribute("contactPhone", contactPhone);
                request.getRequestDispatcher("/view/jsp/home/booking-detail.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi tải chi tiết booking!");
                request.getRequestDispatcher("/view/jsp/home/booking-detail.jsp").forward(request, response);
                return;
            }
        }

        try {
            // Lấy user cần xem profile
            User profileUser = userDAO.getUserById(profileUserId);
            if (profileUser == null) {
                request.setAttribute("error", "Không tìm thấy người dùng này!");
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }
            request.setAttribute("profileUser", profileUser);

            // Get statistics cho user đang xem
            loadUserStatistics(request, profileUser);

            // Lấy lịch sử đặt chỗ (10 booking gần nhất)
            try {
                List<Booking> bookingHistory = bookingDAO.getBookingsByUser(profileUser.getUserId(), 0, 10);
                request.setAttribute("bookingHistory", bookingHistory);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Không thể lấy lịch sử đặt chỗ", e);
                request.setAttribute("bookingHistory", new ArrayList<Booking>());
            }

            // Debug upload directory (chỉ cho chính mình)
            if (profileUser.getUserId() == sessionUser.getUserId()) {
                debugUploadDirectory(request);
            }

            // Forward to profile page
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);

        } catch (SQLException e) {
            System.out.println("Database error loading profile: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Database error loading profile: " + e.getMessage(), e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải thông tin profile");
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("╔════════════════════════════════════════════════════════════════╗");
        System.out.println("║                    PROFILESERVLET DOPOST CALLED               ║");
        System.out.println("╚════════════════════════════════════════════════════════════════╝");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Servlet Path: " + request.getServletPath());

        String pathInfo = request.getServletPath();
        System.out.println("Processing POST request for: " + pathInfo);
        LOGGER.info("Processing POST request for: " + pathInfo);

        switch (pathInfo) {
            case "/profile/update":
                System.out.println("=== CALLING handleUpdateProfile ===");
                handleUpdateProfile(request, response);
                break;
            case "/profile/change-password":
                System.out.println("=== CALLING handleChangePassword ===");
                handleChangePassword(request, response);
                break;
            default:
                System.out.println("=== INVALID PATH: " + pathInfo + " ===");
                LOGGER.warning("Invalid path: " + pathInfo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("╔══════════════════════════════════════════════════════════════════╗");
        System.out.println("║                      HANDLE UPDATE PROFILE                      ║");
        System.out.println("╚══════════════════════════════════════════════════════════════════╝");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            System.out.println("=== PROFILE UPDATE PROCESSING START ===");
            System.out.println("User ID: " + currentUser.getUserId());
            System.out.println("User Role: " + currentUser.getRole());

            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String bio = request.getParameter("bio");

            System.out.println("Basic form data - Name: " + fullName + ", Email: " + email);

            // Validate required basic fields
            if (!validateBasicFields(request, response, currentUser, fullName, email)) {
                return;
            }

            // Check email uniqueness
            if (!email.equals(currentUser.getEmail()) && userDAO.emailExistsForOtherUser(email, currentUser.getUserId())) {
                System.out.println("Validation failed: email already exists");
                request.setAttribute("error", "Email này đã được sử dụng");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Update basic user fields
            updateBasicUserFields(currentUser, fullName, email, phone, gender, bio, dateOfBirthStr);

            // Handle host-specific fields if user is HOST
            if ("HOST".equals(currentUser.getRole())) {
                if (!handleHostSpecificFields(request, response, currentUser)) {
                    return;
                }
            }

            // Handle avatar upload
            handleAvatarUpload(request, currentUser);

            // Update in database
            System.out.println("Updating user in database...");
            boolean success = userDAO.updateUser(currentUser);
            System.out.println("Database update result: " + success);

            if (success) {
                // Refresh user data from database to ensure consistency
                User updatedUser = userDAO.getUserByEmail(currentUser.getEmail());
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                    System.out.println("Session updated with fresh user data from database");
                }
                request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            } else {
                System.out.println("Database update failed");
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ");
            }

        } catch (SQLException e) {
            System.out.println("Database error updating profile: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Database error updating profile", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ");
        } catch (Exception e) {
            System.out.println("Unexpected error updating profile: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Unexpected error updating profile", e);
            request.setAttribute("error", "Có lỗi không mong muốn xảy ra");
        }

        // Reload statistics and forward back to profile
        try {
            loadUserStatistics(request, currentUser);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error loading statistics after update", e);
        }

        request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
    }

    private boolean validateBasicFields(HttpServletRequest request, HttpServletResponse response, 
                                      User currentUser, String fullName, String email) 
            throws ServletException, IOException {
        
        if (fullName == null || fullName.trim().isEmpty()) {
            System.out.println("Validation failed: fullName is empty");
            request.setAttribute("error", "Họ tên không được để trống");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        if (fullName.length() > 100) {
            System.out.println("Validation failed: fullName too long");
            request.setAttribute("error", "Họ tên không được vượt quá 100 ký tự");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        if (email == null || email.trim().isEmpty()) {
            System.out.println("Validation failed: email is empty");
            request.setAttribute("error", "Email không được để trống");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        if (email.length() > 100) {
            System.out.println("Validation failed: email too long");
            request.setAttribute("error", "Email không được vượt quá 100 ký tự");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        return true;
    }

    private void updateBasicUserFields(User currentUser, String fullName, String email, 
                                     String phone, String gender, String bio, String dateOfBirthStr) {
        
        currentUser.setFullName(fullName.trim());
        currentUser.setEmail(email.trim());
        currentUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        currentUser.setGender(gender);
        currentUser.setBio(bio != null && !bio.trim().isEmpty() ? bio.trim() : null);

        // Parse date of birth
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dateOfBirth = sdf.parse(dateOfBirthStr);
                currentUser.setDateOfBirth(dateOfBirth);
                System.out.println("Date of birth parsed successfully: " + dateOfBirth);
            } catch (ParseException e) {
                System.out.println("Invalid date format: " + dateOfBirthStr);
                LOGGER.log(Level.WARNING, "Invalid date format: " + dateOfBirthStr, e);
            }
        }
    }

   private boolean handleHostSpecificFields(HttpServletRequest request, HttpServletResponse response, 
                                           User currentUser) throws ServletException, IOException {
        
        System.out.println("=== PROCESSING HOST-SPECIFIC FIELDS ===");
        
        // Get host-specific form data (removed businessType and taxId)
        String businessName = request.getParameter("businessName");
        String businessAddress = request.getParameter("businessAddress");
        String businessDescription = request.getParameter("businessDescription");
        String skills = request.getParameter("skills");
        String region = request.getParameter("region");

        System.out.println("Host fields - Business Name: " + businessName + ", Region: " + region);

        // Validate required host fields
        if (businessName == null || businessName.trim().isEmpty()) {
            System.out.println("Validation failed: businessName is empty for HOST");
            request.setAttribute("error", "Tên doanh nghiệp không được để trống");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        if (businessName.length() > 100) {
            System.out.println("Validation failed: businessName too long");
            request.setAttribute("error", "Tên doanh nghiệp không được vượt quá 100 ký tự");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        if (region == null || region.trim().isEmpty()) {
            System.out.println("Validation failed: region is empty for HOST");
            request.setAttribute("error", "Khu vực hoạt động không được để trống");
            try {
                loadUserStatistics(request, currentUser);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading statistics", e);
            }
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
            return false;
        }

        // Update host-specific fields (removed businessType and taxId)
        currentUser.setBusinessName(businessName.trim());
        currentUser.setBusinessAddress(businessAddress != null && !businessAddress.trim().isEmpty() ? businessAddress.trim() : null);
        currentUser.setBusinessDescription(businessDescription != null && !businessDescription.trim().isEmpty() ? businessDescription.trim() : null);
        currentUser.setSkills(skills != null && !skills.trim().isEmpty() ? skills.trim() : null);
        currentUser.setRegion(region.trim());

        // Set businessType and taxId to null to ensure they're not accidentally set
        currentUser.setBusinessType(null);
        currentUser.setTaxId(null);

        System.out.println("Host-specific fields updated successfully");
        return true;
    }
    
    private void handleAvatarUpload(HttpServletRequest request, User currentUser) {
        System.out.println("=== STARTING AVATAR UPLOAD PROCESSING ===");
        
        try {
            Part avatarPart = request.getPart("avatarFile");
            
            if (avatarPart != null && avatarPart.getSize() > 0) {
                System.out.println("Processing avatar upload, size: " + avatarPart.getSize());
                
                String oldAvatar = currentUser.getAvatar();
                System.out.println("Old avatar: " + oldAvatar);
                
                String fileName = FileUploadUtils.uploadAvatar(avatarPart, request);
                System.out.println("Upload result: " + fileName);
                
                if (fileName != null) {
                    System.out.println("New avatar uploaded successfully: " + fileName);
                    currentUser.setAvatar(fileName);
                    
                    // Delete old avatar if it exists
                    if (oldAvatar != null && !oldAvatar.isEmpty()) {
                        System.out.println("Attempting to delete old avatar: " + oldAvatar);
                        boolean deleted = FileUploadUtils.deleteAvatar(request, oldAvatar);
                        System.out.println("Old avatar deletion result: " + deleted);
                    }
                } else {
                    System.out.println("Avatar upload failed - fileName is null");
                }
            } else {
                System.out.println("No avatar file uploaded");
            }
        } catch (Exception e) {
            System.out.println("Error processing avatar upload: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.WARNING, "Error processing avatar upload", e);
        }
        
        System.out.println("=== END AVATAR UPLOAD PROCESSING ===");
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== HANDLE CHANGE PASSWORD CALLED ===");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate inputs
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                System.out.println("Current password is empty");
                request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (newPassword == null || newPassword.length() < 6) {
                System.out.println("New password too short");
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (newPassword.length() > 100) {
                System.out.println("New password too long");
                request.setAttribute("error", "Mật khẩu mới không được vượt quá 100 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                System.out.println("Password confirmation mismatch");
                request.setAttribute("error", "Mật khẩu xác nhận không khớp");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Verify current password
            if (!PasswordUtils.verifyPassword(currentPassword, currentUser.getPassword())) {
                System.out.println("Current password verification failed");
                request.setAttribute("error", "Mật khẩu hiện tại không đúng");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Update password
            System.out.println("Updating password in database...");
            boolean success = userDAO.updatePassword(currentUser.getUserId(), newPassword);

            if (success) {
                // Update password in user object
                currentUser.setPassword(PasswordUtils.hashPasswordWithSalt(newPassword));
                session.setAttribute("user", currentUser);
                System.out.println("Password updated successfully");
                request.setAttribute("message", "Đổi mật khẩu thành công!");
            } else {
                System.out.println("Password update failed");
                request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
            }

        } catch (SQLException e) {
            System.out.println("Database error changing password: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Database error changing password", e);
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
        } catch (Exception e) {
            System.out.println("Unexpected error changing password: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Unexpected error changing password", e);
            request.setAttribute("error", "Có lỗi không mong muốn xảy ra");
        }

        // Reload statistics and forward back to profile
        try {
            loadUserStatistics(request, currentUser);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error loading statistics after password change", e);
        }

        request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
    }

    private void loadUserStatistics(HttpServletRequest request, User user) throws SQLException {
        try {
            // Get user statistics using UserDAO
            UserDAO.UserStats stats = userDAO.getUserStats(user.getUserId());
            request.setAttribute("totalBookings", stats.getTotalBookings());
            request.setAttribute("totalExperiences", stats.getTotalExperiences());
            request.setAttribute("totalRevenue", String.format("%,.0f", stats.getTotalRevenue()));

        } catch (SQLException e) {
            System.out.println("Error loading user statistics: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Error loading user statistics", e);
            // Set default values if error occurs
            request.setAttribute("totalBookings", 0);
            request.setAttribute("totalExperiences", 0);
            request.setAttribute("totalRevenue", "0");
        }
    }

    /**
     * Debug method to check upload directory
     */
    private void debugUploadDirectory(HttpServletRequest request) {
        try {
            String webappPath = request.getServletContext().getRealPath("/");
            String uploadPath = webappPath + "view" + File.separator + "assets" + File.separator + "images" + File.separator + "avatars";
            File uploadDir = new File(uploadPath);
            
            System.out.println("=== UPLOAD DIRECTORY DEBUG ===");
            System.out.println("Webapp path: " + webappPath);
            System.out.println("Upload path: " + uploadPath);
            System.out.println("Directory exists: " + uploadDir.exists());
            
            // Try to create directory if it doesn't exist
            if (!uploadDir.exists()) {
                System.out.println("Creating upload directory...");
                boolean created = uploadDir.mkdirs();
                System.out.println("Directory creation result: " + created);
            }
            
        } catch (Exception e) {
            System.out.println("Error debugging upload directory: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Error debugging upload directory", e);
        }
    }
}