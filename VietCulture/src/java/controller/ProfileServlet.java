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
        userDAO = new UserDAO();
        bookingDAO = new BookingDAO();
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
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

            // Forward to profile page
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error loading profile", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải thông tin profile");
            request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/profile/update":
                handleUpdateProfile(request, response);
                break;
            case "/profile/change-password":
                handleChangePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
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

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên không được để trống");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }
            if (fullName.length() > 100) {
                request.setAttribute("error", "Họ tên không được vượt quá 100 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }
            if (email.length() > 100) {
                request.setAttribute("error", "Email không được vượt quá 100 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Check if email already exists for another user (if changed)
            if (!email.equals(currentUser.getEmail()) && userDAO.emailExistsForOtherUser(email, currentUser.getUserId())) {
                request.setAttribute("error", "Email này đã được sử dụng");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Validate host-specific fields
            if ("HOST".equals(currentUser.getRole())) {
                if (businessName == null || businessName.trim().isEmpty()) {
                    request.setAttribute("error", "Tên doanh nghiệp không được để trống");
                    loadUserStatistics(request, currentUser);
                    request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                    return;
                }
                if (businessName.length() > 100) {
                    request.setAttribute("error", "Tên doanh nghiệp không được vượt quá 100 ký tự");
                    loadUserStatistics(request, currentUser);
                    request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                    return;
                }
            }

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
                } catch (ParseException e) {
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
            }

            // Handle file upload for avatar
            Part avatarPart = request.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String fileName = FileUploadUtils.uploadAvatar(avatarPart, request);
                if (fileName != null) {
                    currentUser.setAvatar(fileName);
                }
            }

            // Update in database
            boolean success = userDAO.updateUser(currentUser);

            if (success) {
                // Update session
                session.setAttribute("user", currentUser);
                request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating profile", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ");
        } catch (Exception e) {
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

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate inputs
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }
            if (newPassword.length() > 100) {
                request.setAttribute("error", "Mật khẩu mới không được vượt quá 100 ký tự");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Verify current password
            if (!PasswordUtils.verifyPassword(currentPassword, currentUser.getPassword())) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng");
                loadUserStatistics(request, currentUser);
                request.getRequestDispatcher("/view/jsp/home/profile.jsp").forward(request, response);
                return;
            }

            // Update password
            boolean success = userDAO.updatePassword(currentUser.getUserId(), newPassword);

            if (success) {
                // Update password in user object (hash the new password)
                currentUser.setPassword(PasswordUtils.hashPasswordWithSalt(newPassword));
                session.setAttribute("user", currentUser);
                request.setAttribute("message", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error changing password", e);
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
        } catch (Exception e) {
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
            LOGGER.log(Level.WARNING, "Error loading user statistics", e);
            // Set default values if error occurs
            request.setAttribute("totalBookings", 0);
            request.setAttribute("totalExperiences", 0);
            request.setAttribute("totalRevenue", "0");
        }
    }
}