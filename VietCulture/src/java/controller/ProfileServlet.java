package controller;

import dao.UserDAO;
import dao.BookingDAO;
import dao.ExperienceDAO;
import model.User;
import utils.FileUploadUtils;
import utils.PasswordUtils;

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

@WebServlet(urlPatterns = {"/profile", "/profile/update", "/profile/change-password"})
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
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            LOGGER.warning("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get updated user info from database
            User updatedUser = userDAO.getUserById(user.getUserId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
                user = updatedUser;
            }

            // Get statistics
            loadUserStatistics(request, user);

            // Debug upload directory
            debugUploadDirectory(request);

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

        // === THÊM DEBUG LINES ===
        System.out.println("╔════════════════════════════════════════════════════════════════╗");
        System.out.println("║                    PROFILESERVLET DOPOST CALLED               ║");
        System.out.println("╚════════════════════════════════════════════════════════════════╝");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Method: " + request.getMethod());
        System.out.println("Content Type: " + request.getContentType());
        System.out.println("Content Length: " + request.getContentLength());
        System.out.println("================================================================");

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

        // === THÊM DEBUG LINES VÀO ĐẦU METHOD ===
        System.out.println("╔══════════════════════════════════════════════════════════════════╗");
        System.out.println("║                      HANDLE UPDATE PROFILE                      ║");
        System.out.println("╚══════════════════════════════════════════════════════════════════╝");
        System.out.println("Request method: " + request.getMethod());
        System.out.println("Content type: " + request.getContentType());
        System.out.println("Content length: " + request.getContentLength());
        
        // List all parameters
        System.out.println("--- FORM PARAMETERS ---");
        request.getParameterNames().asIterator().forEachRemaining(name -> {
            String value = request.getParameter(name);
            if ("avatarFile".equals(name)) {
                System.out.println("Parameter: " + name + " = [FILE PARAMETER]");
            } else {
                System.out.println("Parameter: " + name + " = " + value);
            }
        });
        
        // Check file upload
        System.out.println("--- FILE UPLOAD CHECK ---");
        try {
            Part avatarPart = request.getPart("avatarFile");
            System.out.println("Avatar part: " + (avatarPart != null ? "EXISTS" : "NULL"));
            if (avatarPart != null) {
                System.out.println("Avatar size: " + avatarPart.getSize());
                System.out.println("Avatar filename: " + avatarPart.getSubmittedFileName());
                System.out.println("Avatar content type: " + avatarPart.getContentType());
            }
        } catch (Exception e) {
            System.out.println("ERROR getting avatar part: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("================================================================");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("User not logged in, redirecting to login");
            LOGGER.warning("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            System.out.println("=== PROFILE UPDATE PROCESSING START ===");
            System.out.println("User ID: " + currentUser.getUserId());
            System.out.println("Current Avatar: " + currentUser.getAvatar());
            LOGGER.info("=== PROFILE UPDATE DEBUG START ===");
            LOGGER.info("User ID: " + currentUser.getUserId());
            LOGGER.info("Current Avatar: " + currentUser.getAvatar());

            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String bio = request.getParameter("bio");

            // Host-specific fields
            String businessName = request.getParameter("businessName");
            String businessType = request.getParameter("businessType");
            String businessAddress = request.getParameter("businessAddress");
            String businessDescription = request.getParameter("businessDescription");
            String taxId = request.getParameter("taxId");
            String skills = request.getParameter("skills");
            String region = request.getParameter("region");

            System.out.println("Form data received - Name: " + fullName + ", Email: " + email);
            LOGGER.info("Form data received - Name: " + fullName + ", Email: " + email);

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty()) {
                System.out.println("Validation failed: fullName is empty");
                request.setAttribute("error", "Họ tên không được để trống");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }
            if (fullName.length() > 100) {
                System.out.println("Validation failed: fullName too long");
                request.setAttribute("error", "Họ tên không được vượt quá 100 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                System.out.println("Validation failed: email is empty");
                request.setAttribute("error", "Email không được để trống");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }
            if (email.length() > 100) {
                System.out.println("Validation failed: email too long");
                request.setAttribute("error", "Email không được vượt quá 100 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Check if email already exists for another user (if changed)
            if (!email.equals(currentUser.getEmail()) && userDAO.emailExistsForOtherUser(email, currentUser.getUserId())) {
                System.out.println("Validation failed: email already exists");
                request.setAttribute("error", "Email này đã được sử dụng");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Validate host-specific fields
            if ("HOST".equals(currentUser.getRole())) {
                if (businessName == null || businessName.trim().isEmpty()) {
                    System.out.println("Validation failed: businessName is empty for HOST");
                    request.setAttribute("error", "Tên doanh nghiệp không được để trống");
                    loadUserStatistics(request, currentUser);
                    request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                    return;
                }
                if (businessName.length() > 100) {
                    System.out.println("Validation failed: businessName too long");
                    request.setAttribute("error", "Tên doanh nghiệp không được vượt quá 100 ký tự");
                    loadUserStatistics(request, currentUser);
                    request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                    return;
                }
            }

            System.out.println("All validations passed, updating user object...");

            // Update user object
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

            // Update host-specific fields
            if ("HOST".equals(currentUser.getRole())) {
                currentUser.setBusinessName(businessName != null ? businessName.trim() : null);
                currentUser.setBusinessType(businessType != null ? businessType.trim() : null);
                currentUser.setBusinessAddress(businessAddress != null ? businessAddress.trim() : null);
                currentUser.setBusinessDescription(businessDescription != null ? businessDescription.trim() : null);
                currentUser.setTaxId(taxId != null ? taxId.trim() : null);
                currentUser.setSkills(skills != null ? skills.trim() : null);
                currentUser.setRegion(region != null ? region.trim() : null);
                System.out.println("Host-specific fields updated");
            }

            // Handle file upload for avatar - ENHANCED DEBUG VERSION
            System.out.println("=== STARTING AVATAR UPLOAD PROCESSING ===");
            Part avatarPart = request.getPart("avatarFile");
            LOGGER.info("=== AVATAR UPLOAD DEBUG ===");
            
            if (avatarPart != null) {
                System.out.println("Avatar part received:");
                System.out.println("- Name: " + avatarPart.getName());
                System.out.println("- Size: " + avatarPart.getSize());
                System.out.println("- Content Type: " + avatarPart.getContentType());
                System.out.println("- Submitted File Name: " + avatarPart.getSubmittedFileName());
                
                LOGGER.info("Avatar part received:");
                LOGGER.info("- Name: " + avatarPart.getName());
                LOGGER.info("- Size: " + avatarPart.getSize());
                LOGGER.info("- Content Type: " + avatarPart.getContentType());
                LOGGER.info("- Submitted File Name: " + avatarPart.getSubmittedFileName());
                
                if (avatarPart.getSize() > 0) {
                    System.out.println("Processing avatar upload, size: " + avatarPart.getSize());
                    LOGGER.info("Processing avatar upload, size: " + avatarPart.getSize());
                    
                    String oldAvatar = currentUser.getAvatar();
                    System.out.println("Old avatar: " + oldAvatar);
                    LOGGER.info("Old avatar: " + oldAvatar);
                    
                    System.out.println("Calling FileUploadUtils.uploadAvatar()...");
                    String fileName = FileUploadUtils.uploadAvatar(avatarPart, request);
                    System.out.println("Upload result: " + fileName);
                    LOGGER.info("Upload result: " + fileName);
                    
                    if (fileName != null) {
                        System.out.println("New avatar uploaded successfully: " + fileName);
                        LOGGER.info("New avatar uploaded successfully: " + fileName);
                        currentUser.setAvatar(fileName);
                        
                        // Delete old avatar if it exists
                        if (oldAvatar != null && !oldAvatar.isEmpty()) {
                            System.out.println("Attempting to delete old avatar: " + oldAvatar);
                            LOGGER.info("Attempting to delete old avatar: " + oldAvatar);
                            boolean deleted = FileUploadUtils.deleteAvatar(request, oldAvatar);
                            System.out.println("Old avatar deletion result: " + deleted);
                            LOGGER.info("Old avatar deletion result: " + deleted);
                        }
                    } else {
                        System.out.println("Avatar upload failed - fileName is null");
                        LOGGER.warning("Avatar upload failed - fileName is null");
                        request.setAttribute("error", "Không thể tải lên ảnh đại diện. Vui lòng kiểm tra định dạng file.");
                        loadUserStatistics(request, currentUser);
                        request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                        return;
                    }
                } else {
                    System.out.println("Avatar part size is 0 - no file selected");
                    LOGGER.info("Avatar part size is 0 - no file selected");
                }
            } else {
                System.out.println("Avatar part is null!");
                LOGGER.warning("Avatar part is null!");
            }
            System.out.println("=== END AVATAR UPLOAD PROCESSING ===");
            LOGGER.info("=== END AVATAR UPLOAD DEBUG ===");

            // Update in database
            System.out.println("Updating user in database...");
            LOGGER.info("Updating user in database...");
            boolean success = userDAO.updateUser(currentUser);
            System.out.println("Database update result: " + success);
            LOGGER.info("Database update result: " + success);

            if (success) {
                // Update session
                session.setAttribute("user", currentUser);
                System.out.println("Session updated with new user data");
                LOGGER.info("Session updated with new user data");
                request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            } else {
                System.out.println("Database update failed");
                LOGGER.warning("Database update failed");
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ");
            }

            System.out.println("=== PROFILE UPDATE PROCESSING END ===");
            LOGGER.info("=== PROFILE UPDATE DEBUG END ===");

        } catch (SQLException e) {
            System.out.println("Database error updating profile: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Database error updating profile: " + e.getMessage(), e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ");
        } catch (Exception e) {
            System.out.println("Unexpected error updating profile: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Unexpected error updating profile: " + e.getMessage(), e);
            request.setAttribute("error", "Có lỗi không mong muốn xảy ra");
        }

        // Reload statistics and forward back to profile
        try {
            loadUserStatistics(request, currentUser);
        } catch (SQLException e) {
            System.out.println("Error loading statistics after update: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Error loading statistics after update: " + e.getMessage(), e);
        }

        System.out.println("Forwarding to profile.jsp...");
        request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== HANDLE CHANGE PASSWORD CALLED ===");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("User not logged in, redirecting to login");
            LOGGER.warning("User not logged in, redirecting to login");
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
                // Update password in user object (hash the new password)
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
            LOGGER.log(Level.SEVERE, "Database error changing password: " + e.getMessage(), e);
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
        } catch (Exception e) {
            System.out.println("Unexpected error changing password: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Unexpected error changing password: " + e.getMessage(), e);
            request.setAttribute("error", "Có lỗi không mong muốn xảy ra");
        }

        // Reload statistics and forward back to profile
        try {
            loadUserStatistics(request, currentUser);
        } catch (SQLException e) {
            System.out.println("Error loading statistics after password change: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Error loading statistics after password change: " + e.getMessage(), e);
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
            LOGGER.log(Level.WARNING, "Error loading user statistics: " + e.getMessage(), e);
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
            System.out.println("Directory is directory: " + uploadDir.isDirectory());
            System.out.println("Directory writable: " + uploadDir.canWrite());
            System.out.println("Directory readable: " + uploadDir.canRead());
            
            LOGGER.info("=== UPLOAD DIRECTORY DEBUG ===");
            LOGGER.info("Webapp path: " + webappPath);
            LOGGER.info("Upload path: " + uploadPath);
            LOGGER.info("Directory exists: " + uploadDir.exists());
            LOGGER.info("Directory is directory: " + uploadDir.isDirectory());
            LOGGER.info("Directory writable: " + uploadDir.canWrite());
            LOGGER.info("Directory readable: " + uploadDir.canRead());
            
            // Try to create directory if it doesn't exist
            if (!uploadDir.exists()) {
                System.out.println("Creating upload directory...");
                LOGGER.info("Creating upload directory...");
                boolean created = uploadDir.mkdirs();
                System.out.println("Directory creation result: " + created);
                LOGGER.info("Directory creation result: " + created);
            }
            
            // List files in directory
            if (uploadDir.exists() && uploadDir.isDirectory()) {
                File[] files = uploadDir.listFiles();
                if (files != null) {
                    System.out.println("Files in directory: " + files.length);
                    LOGGER.info("Files in directory: " + files.length);
                    for (int i = 0; i < Math.min(5, files.length); i++) {
                        System.out.println("- " + files[i].getName() + " (" + files[i].length() + " bytes)");
                        LOGGER.info("- " + files[i].getName() + " (" + files[i].length() + " bytes)");
                    }
                } else {
                    System.out.println("Unable to list files in directory");
                    LOGGER.warning("Unable to list files in directory");
                }
            }
            System.out.println("=== END UPLOAD DIRECTORY DEBUG ===");
            LOGGER.info("=== END UPLOAD DIRECTORY DEBUG ===");
            
        } catch (Exception e) {
            System.out.println("Error debugging upload directory: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.WARNING, "Error debugging upload directory: " + e.getMessage(), e);
        }
    }
}