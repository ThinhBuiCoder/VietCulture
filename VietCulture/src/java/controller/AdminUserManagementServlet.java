package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.PasswordUtils;

@WebServlet(name = "AdminUserManagement", urlPatterns = {
    "/admin/users",
    "/admin/users/",
    "/admin/users/*"
})
public class AdminUserManagementServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminUserManagementServlet.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 20;

    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
            gson = new Gson();
            LOGGER.info("AdminUserManagementServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminUserManagementServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            if (isAjaxRequest(request)) {
                sendJsonResponse(response, false, "Phiên đăng nhập đã hết hạn", null);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("GET request - PathInfo: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Show users list
                handleUsersList(request, response);
            } else if (pathInfo.equals("/export")) {
                // Export users to Excel
                handleExportUsers(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show user detail
                int userId = Integer.parseInt(pathInfo.substring(1));
                handleUserDetail(request, response, userId);
            } else if (pathInfo.matches("/\\d+/permissions")) {
                // Show user permissions
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleUserPermissions(request, response, userId);
            } else if (pathInfo.matches("/\\d+/lock")) {
                // Show lock page
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleShowLockPage(request, response, userId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trang không tồn tại");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in user management", e);
            handleError(request, response, "Có lỗi xảy ra khi truy xuất dữ liệu. Vui lòng thử lại sau.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid user ID format: " + pathInfo, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID người dùng không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in user management", e);
            handleError(request, response, "Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding for Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Check admin authentication first
        if (!isAdminAuthenticated(request)) {
            LOGGER.warning("Unauthorized access attempt to admin user management");
            sendJsonResponse(response, false, "Phiên đăng nhập đã hết hạn", null);
            return;
        }

        String pathInfo = request.getPathInfo();
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        LOGGER.info("POST request details:");
        LOGGER.info("- PathInfo: " + pathInfo);
        LOGGER.info("- RequestURI: " + requestURI);
        LOGGER.info("- ContextPath: " + contextPath);
        LOGGER.info("- Method: " + request.getMethod());

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/create")) {
                // Create new user
                handleCreateUser(request, response);
            } else if (pathInfo.matches("/\\d+/lock")) {
                // Lock user
                String[] parts = pathInfo.split("/");
                if (parts.length >= 3) {
                    int userId = Integer.parseInt(parts[1]);
                    LOGGER.info("Locking user ID: " + userId);
                    handleLockUser(request, response, userId);
                } else {
                    LOGGER.warning("Invalid lock URL format: " + pathInfo);
                    sendJsonResponse(response, false, "URL không hợp lệ", null);
                }
            } else if (pathInfo.matches("/\\d+/unlock")) {
                // Unlock user
                String[] parts = pathInfo.split("/");
                if (parts.length >= 3) {
                    int userId = Integer.parseInt(parts[1]);
                    LOGGER.info("Unlocking user ID: " + userId);
                    handleUnlockUser(request, response, userId);
                } else {
                    LOGGER.warning("Invalid unlock URL format: " + pathInfo);
                    sendJsonResponse(response, false, "URL không hợp lệ", null);
                }
            } else if (pathInfo.matches("/\\d+/permissions")) {
                // Update permissions
                String[] parts = pathInfo.split("/");
                if (parts.length >= 3) {
                    int userId = Integer.parseInt(parts[1]);
                    handleUpdatePermissions(request, response, userId);
                } else {
                    LOGGER.warning("Invalid permissions URL format: " + pathInfo);
                    sendJsonResponse(response, false, "URL không hợp lệ", null);
                }
            } else if (pathInfo.matches("/\\d+/verify-email")) {
                // Verify email
                String[] parts = pathInfo.split("/");
                if (parts.length >= 3) {
                    int userId = Integer.parseInt(parts[1]);
                    handleVerifyEmail(request, response, userId);
                } else {
                    sendJsonResponse(response, false, "URL không hợp lệ", null);
                }
            } else if (pathInfo.matches("/\\d+/reset-password")) {
                // Reset password
                String[] parts = pathInfo.split("/");
                if (parts.length >= 3) {
                    int userId = Integer.parseInt(parts[1]);
                    handleResetPassword(request, response, userId);
                } else {
                    sendJsonResponse(response, false, "URL không hợp lệ", null);
                }
            } else {
                LOGGER.warning("Invalid POST path: " + pathInfo);
                sendJsonResponse(response, false, "Đường dẫn không hợp lệ: " + pathInfo, null);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in user management POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra khi xử lý dữ liệu: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid user ID format in POST: " + pathInfo, e);
            sendJsonResponse(response, false, "ID người dùng không hợp lệ", null);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in user management POST", e);
            sendJsonResponse(response, false, "Có lỗi không mong muốn xảy ra: " + e.getMessage(), null);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!isAdminAuthenticated(request)) {
            sendJsonResponse(response, false, "Phiên đăng nhập đã hết hạn", null);
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("DELETE request - PathInfo: " + pathInfo);

        if (pathInfo != null && pathInfo.matches("/\\d+/delete")) {
            try {
                String[] parts = pathInfo.split("/");
                if (parts.length >= 3) {
                    int userId = Integer.parseInt(parts[1]);
                    handleDeleteUser(request, response, userId);
                } else {
                    sendJsonResponse(response, false, "URL không hợp lệ", null);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error deleting user", e);
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa người dùng: " + e.getMessage(), null);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid user ID format in DELETE: " + pathInfo, e);
                sendJsonResponse(response, false, "ID người dùng không hợp lệ", null);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Unexpected error deleting user", e);
                sendJsonResponse(response, false, "Có lỗi không mong muốn xảy ra: " + e.getMessage(), null);
            }
        } else {
            sendJsonResponse(response, false, "Đường dẫn không hợp lệ", null);
        }
    }

    /**
     * Handle users list display with pagination and filters
     */
    private void handleUsersList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Get filter parameters
        String role = sanitizeParameter(request.getParameter("role"));
        String status = sanitizeParameter(request.getParameter("status"));
        String search = sanitizeParameter(request.getParameter("search"));
        
        // Pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        
        // Validate pagination
        if (page < 1) page = 1;
        if (pageSize < 5 || pageSize > 100) pageSize = DEFAULT_PAGE_SIZE;

        try {
            // Get users with filters and pagination
            List<User> users = userDAO.getUsersWithFilters(role, status, search, page, pageSize);
            int totalUsers = userDAO.getTotalUsersWithFilters(role, status, search);
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            // Ensure current page is valid
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
                users = userDAO.getUsersWithFilters(role, status, search, page, pageSize);
            }

            // Set attributes for JSP
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("pageSize", pageSize);
            
            // Current filter values
            request.setAttribute("currentRole", role);
            request.setAttribute("currentStatus", status);
            request.setAttribute("currentSearch", search);

            // Success/Error messages from redirects
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
            if (successMsg != null && !successMsg.isEmpty()) {
                request.setAttribute("successMessage", successMsg);
            }
            if (errorMsg != null && !errorMsg.isEmpty()) {
                request.setAttribute("errorMessage", errorMsg);
            }

            // Forward to JSP
            request.getRequestDispatcher("/view/jsp/admin/users/user-list.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving users list", e);
            throw e;
        }
    }

    /**
     * Handle user detail display
     */
    private void handleUserDetail(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, ServletException, IOException {

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Người dùng không tồn tại");
            return;
        }

        // Get additional user statistics if needed
        try {
            Map<String, Object> userStats = getUserStatistics(userId);
            request.setAttribute("userStats", userStats);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Could not retrieve user statistics for ID: " + userId, e);
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/jsp/admin/users/user-detail.jsp").forward(request, response);
    }

    /**
     * Handle show lock page
     */
    private void handleShowLockPage(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, ServletException, IOException {

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Người dùng không tồn tại");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/jsp/admin/users/user-lock.jsp").forward(request, response);
    }

    /**
     * Handle user permissions display
     */
    private void handleUserPermissions(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, ServletException, IOException {

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Người dùng không tồn tại");
            return;
        }

        // Parse permissions JSON for display
        Map<String, Object> permissionsMap = new HashMap<>();
        if (user.getPermissions() != null && !user.getPermissions().isEmpty()) {
            try {
                permissionsMap = gson.fromJson(user.getPermissions(), Map.class);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Could not parse permissions JSON for user: " + userId, e);
            }
        }

        request.setAttribute("user", user);
        request.setAttribute("permissionsMap", permissionsMap);
        request.getRequestDispatcher("/view/jsp/admin/users/user-permissions.jsp").forward(request, response);
    }

    /**
     * Handle create new user
     */
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        // Get and validate parameters
        String email = sanitizeParameter(request.getParameter("email"));
        String fullName = sanitizeParameter(request.getParameter("fullName"));
        String phone = sanitizeParameter(request.getParameter("phone"));
        String role = sanitizeParameter(request.getParameter("role"));
        String password = request.getParameter("password"); // Don't sanitize password

        // Basic validation
        if (isNullOrEmpty(email) || isNullOrEmpty(fullName) || 
            isNullOrEmpty(role) || isNullOrEmpty(password)) {
            sendJsonResponse(response, false, "Vui lòng điền đầy đủ thông tin bắt buộc.", null);
            return;
        }

        // Validate email format
        if (!isValidEmail(email)) {
            sendJsonResponse(response, false, "Định dạng email không hợp lệ.", null);
            return;
        }

        // Validate lengths
        if (email.length() > 100) {
            sendJsonResponse(response, false, "Email không được vượt quá 100 ký tự.", null);
            return;
        }
        if (fullName.length() > 100) {
            sendJsonResponse(response, false, "Họ tên không được vượt quá 100 ký tự.", null);
            return;
        }
        if (password.length() < 6 || password.length() > 100) {
            sendJsonResponse(response, false, "Mật khẩu phải từ 6-100 ký tự.", null);
            return;
        }

        // Validate phone if provided
        if (phone != null && !phone.isEmpty() && !isValidPhone(phone)) {
            sendJsonResponse(response, false, "Số điện thoại không hợp lệ.", null);
            return;
        }

        // Validate role
        if (!isValidRole(role)) {
            sendJsonResponse(response, false, "Vai trò không hợp lệ.", null);
            return;
        }

        try {
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                sendJsonResponse(response, false, "Email đã tồn tại trong hệ thống.", null);
                return;
            }

            // Create user object
            User newUser = createNewUser(email, fullName, phone, role, password);

            // Save to database
            int userId = userDAO.createUser(newUser);

            if (userId > 0) {
                LOGGER.info("Admin created new user: " + email + ", ID: " + userId + ", Role: " + role);
                sendJsonResponse(response, true, "Tạo người dùng mới thành công!", Map.of("userId", userId));
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi tạo người dùng.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating user: " + email, e);
            if (e.getMessage().contains("Duplicate")) {
                sendJsonResponse(response, false, "Email đã tồn tại trong hệ thống.", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi tạo người dùng: " + e.getMessage(), null);
            }
        }
    }

    /**
     * Handle lock user
     */
    private void handleLockUser(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        LOGGER.info("=== LOCK USER REQUEST ===");
        LOGGER.info("Processing lock request for user ID: " + userId);
        LOGGER.info("Request method: " + request.getMethod());
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Request content type: " + request.getContentType());
        
        String reason = null;
        String contentType = request.getContentType();
        
        // Check if request is JSON or form data
        if (contentType != null && contentType.contains("application/json")) {
            LOGGER.info("Processing JSON request body");
            try {
                // Read JSON request body
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) {
                    sb.append(line);
                }
                String jsonBody = sb.toString();
                LOGGER.info("JSON body: " + jsonBody);
                
                // Parse JSON using Gson
                Map<String, Object> jsonData = gson.fromJson(jsonBody, Map.class);
                if (jsonData != null && jsonData.containsKey("reason")) {
                    reason = (String) jsonData.get("reason");
                    LOGGER.info("Extracted reason from JSON: " + reason);
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error parsing JSON request body", e);
                sendJsonResponse(response, false, "Định dạng JSON không hợp lệ.", null);
                return;
            }
        } else {
            LOGGER.info("Processing form data request");
            reason = request.getParameter("reason");
            LOGGER.info("Extracted reason from form: " + reason);
        }
        
        // Sanitize the reason
        reason = sanitizeParameter(reason);
        LOGGER.info("Final lock reason: " + reason);

        if (isNullOrEmpty(reason)) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do khóa tài khoản.", null);
            return;
        }

        if (reason.length() > 500) {
            sendJsonResponse(response, false, "Lý do khóa không được vượt quá 500 ký tự.", null);
            return;
        }

        // Prevent self-locking
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null && currentUser.getUserId() == userId) {
            sendJsonResponse(response, false, "Không thể khóa tài khoản của chính mình.", null);
            return;
        }

        try {
            // Check if user exists and is not already locked
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                sendJsonResponse(response, false, "Người dùng không tồn tại.", null);
                return;
            }

            if (!targetUser.isActive()) {
                sendJsonResponse(response, false, "Tài khoản đã bị khóa trước đó.", null);
                return;
            }

            boolean success = userDAO.lockUser(userId, reason.trim());
            LOGGER.info("Lock operation result: " + success);

            if (success) {
                String currentUserInfo = currentUser != null ? "ID: " + currentUser.getUserId() : "Unknown";
                LOGGER.info("Admin (" + currentUserInfo + ") locked user ID: " + userId + ", reason: " + reason);
                sendJsonResponse(response, true, "Đã khóa tài khoản thành công.", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi khóa tài khoản.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error locking user ID: " + userId, e);
            throw e;
        }
    }

    /**
     * Handle unlock user
     */
    private void handleUnlockUser(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        LOGGER.info("Processing unlock request for user ID: " + userId);

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        try {
            // Check if user exists and is locked
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                sendJsonResponse(response, false, "Người dùng không tồn tại.", null);
                return;
            }

            if (targetUser.isActive()) {
                sendJsonResponse(response, false, "Tài khoản đang hoạt động bình thường.", null);
                return;
            }

            boolean success = userDAO.unlockUser(userId);

            if (success) {
                String currentUserInfo = currentUser != null ? "ID: " + currentUser.getUserId() : "Unknown";
                LOGGER.info("Admin (" + currentUserInfo + ") unlocked user ID: " + userId);
                sendJsonResponse(response, true, "Đã mở khóa tài khoản thành công.", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi mở khóa tài khoản.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unlocking user ID: " + userId, e);
            throw e;
        }
    }

    /**
     * Handle delete user
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        LOGGER.info("Processing delete request for user ID: " + userId);

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Prevent self-deletion
        if (currentUser != null && currentUser.getUserId() == userId) {
            sendJsonResponse(response, false, "Không thể xóa tài khoản của chính mình.", null);
            return;
        }

        try {
            // Check if user exists
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                sendJsonResponse(response, false, "Người dùng không tồn tại.", null);
                return;
            }

            // Prevent deleting other admins (optional security measure)
            if ("ADMIN".equals(targetUser.getRole()) && !isSuperAdmin(currentUser)) {
                sendJsonResponse(response, false, "Không có quyền xóa tài khoản Admin khác.", null);
                return;
            }

            boolean success = userDAO.hardDeleteUser(userId);

            if (success) {
                String currentUserInfo = currentUser != null ? "ID: " + currentUser.getUserId() : "Unknown";
                LOGGER.info("Admin (" + currentUserInfo + ") deleted user ID: " + userId + " (" + targetUser.getEmail() + ")");
                sendJsonResponse(response, true, "Đã xóa tài khoản thành công.", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa tài khoản.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user ID: " + userId, e);
            throw e;
        }
    }

    /**
     * Handle verify email
     */
    private void handleVerifyEmail(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        LOGGER.info("Processing verify email request for user ID: " + userId);

        try {
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                sendJsonResponse(response, false, "Người dùng không tồn tại.", null);
                return;
            }

            if (targetUser.isEmailVerified()) {
                sendJsonResponse(response, false, "Email đã được xác thực trước đó.", null);
                return;
            }

            // Update email verified status
            targetUser.setEmailVerified(true);
            boolean success = userDAO.updateUser(targetUser);

            if (success) {
                LOGGER.info("Admin verified email for user ID: " + userId);
                sendJsonResponse(response, true, "Đã xác thực email thành công.", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xác thực email.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error verifying email for user ID: " + userId, e);
            throw e;
        }
    }

    /**
     * Handle reset password
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        LOGGER.info("Processing reset password request for user ID: " + userId);

        try {
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                sendJsonResponse(response, false, "Người dùng không tồn tại.", null);
                return;
            }

            // Generate new temporary password
            String newPassword = generateTemporaryPassword();
            String hashedPassword = PasswordUtils.hashPasswordWithSalt(newPassword);

            // Update user password
            targetUser.setPassword(hashedPassword);
            boolean success = userDAO.updateUser(targetUser);

            if (success) {
                LOGGER.info("Admin reset password for user ID: " + userId);
                // TODO: Send email with new password
                sendJsonResponse(response, true, "Đã đặt lại mật khẩu. Mật khẩu mới: " + newPassword, 
                    Map.of("tempPassword", newPassword)); // Remove this in production
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi đặt lại mật khẩu.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error resetting password for user ID: " + userId, e);
            throw e;
        }
    }

    /**
     * Handle update permissions
     */
    private void handleUpdatePermissions(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        String newRole = sanitizeParameter(request.getParameter("newrole"));
        String reason = sanitizeParameter(request.getParameter("reason"));
        String permissions = request.getParameter("permissions"); // Don't sanitize JSON

        // Validate role
        if (!isValidRole(newRole)) {
            sendJsonResponse(response, false, "Vai trò không hợp lệ.", null);
            return;
        }

        if (isNullOrEmpty(reason)) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do thay đổi phân quyền.", null);
            return;
        }

        // Prevent changing own role/permissions
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null && currentUser.getUserId() == userId) {
            sendJsonResponse(response, false, "Không thể thay đổi vai trò của chính mình.", null);
            return;
        }

        try {
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                sendJsonResponse(response, false, "Người dùng không tồn tại.", null);
                return;
            }

            boolean success = true;

            // Update role
            if (!newRole.equals(targetUser.getRole())) {
                success = userDAO.updateUserRole(userId, newRole);
            }

            // Update permissions if provided (for ADMIN role)
            if (success && "ADMIN".equals(newRole) && permissions != null && !permissions.trim().isEmpty()) {
                // Validate JSON format
                try {
                    gson.fromJson(permissions.trim(), Map.class);
                    targetUser.setPermissions(permissions.trim());
                    success = userDAO.updateUser(targetUser);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Invalid permissions JSON format for user: " + userId, e);
                    sendJsonResponse(response, false, "Định dạng quyền hạn không hợp lệ.", null);
                    return;
                }
            }

            if (success) {
                String currentUserInfo = currentUser != null ? "ID: " + currentUser.getUserId() : "Unknown";
                LOGGER.info("Admin (" + currentUserInfo + ") updated role/permissions for user ID: " + userId + ", new role: " + newRole);
                sendJsonResponse(response, true, "Đã cập nhật phân quyền thành công.", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi cập nhật phân quyền.", null);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating permissions for user ID: " + userId, e);
            throw e;
        }
    }

    /**
     * Handle export users to Excel
     */
    private void handleExportUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        // Get current filter parameters
        String role = sanitizeParameter(request.getParameter("role"));
        String status = sanitizeParameter(request.getParameter("status"));
        String search = sanitizeParameter(request.getParameter("search"));

        try {
            // Get all users matching filters (no pagination for export)
            List<User> users = userDAO.getUsersWithFilters(role, status, search, 1, Integer.MAX_VALUE);

            // Set response headers for CSV download
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"users_export_" + 
                new java.text.SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".csv\"");

            PrintWriter writer = response.getWriter();
            writer.println("ID,Email,Full Name,Role,Status,Created Date");
            
            for (User user : users) {
                writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                    user.getUserId(),
                    escapeCSV(user.getEmail()),
                    escapeCSV(user.getFullName()),
                    user.getRole(),
                    user.isActive() ? "Active" : "Inactive",
                    user.getCreatedAt() != null ? user.getCreatedAt().toString() : ""
                );
            }
            
            writer.flush();

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error exporting users", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi xuất dữ liệu");
        }
    }

    // Utility Methods

    /**
     * Create new user object with role-specific defaults
     */
    private User createNewUser(String email, String fullName, String phone, String role, String password) {
        User newUser = new User();
        newUser.setEmail(email.trim());
        newUser.setFullName(fullName.trim());
        newUser.setRole(role);
        newUser.setPassword(PasswordUtils.hashPasswordWithSalt(password));
        newUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        newUser.setActive(true);
        newUser.setEmailVerified(true); // Admin-created users are auto-verified
        newUser.setCreatedAt(new Date());

        // Set role-specific defaults
        switch (role) {
            case "TRAVELER":
                newUser.setPreferences("{\"notifications\": true, \"language\": \"vi\"}");
                newUser.setTotalBookings(0);
                break;
            case "HOST":
                newUser.setBusinessName(fullName.trim() + "'s Business");
                newUser.setBusinessType("General");
                newUser.setAverageRating(0.0);
                newUser.setTotalExperiences(0);
                newUser.setTotalRevenue(0.0);
                break;
            case "ADMIN":
                newUser.setPermissions("{\"manage_users\": true, \"approve_content\": true, \"view_statistics\": true}");
                break;
        }

        return newUser;
    }

    /**
     * Generate temporary password
     */
    private String generateTemporaryPassword() {
        String chars = "ABCDEFGHJKMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
        StringBuilder password = new StringBuilder();
        java.util.Random random = new java.util.Random();
        
        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }

    /**
     * Get user statistics for detail view
     */
    private Map<String, Object> getUserStatistics(int userId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // TODO: Implement based on your business logic
        // Example: booking count, experience count, revenue, etc.
        stats.put("loginCount", 0);
        stats.put("lastLoginDate", null);
        stats.put("bookingCount", 0);
        stats.put("experienceCount", 0);
        
        return stats;
    }

    /**
     * Check if user is authenticated admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            LOGGER.warning("No session found");
            return false;
        }

        User user = (User) session.getAttribute("user");
        boolean isAdmin = user != null && "ADMIN".equals(user.getRole());
        
        if (!isAdmin) {
            LOGGER.warning("User is not admin: " + (user != null ? user.getEmail() : "null"));
        }
        
        return isAdmin;
    }

    /**
     * Check if current user is super admin (can delete other admins)
     */
    private boolean isSuperAdmin(User user) {
        // TODO: Implement super admin logic if needed
        // For now, all admins have equal privileges
        return user != null && "ADMIN".equals(user.getRole());
    }

    /**
     * Check if request is AJAX
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String contentType = request.getContentType();
        String accept = request.getHeader("Accept");
        
        return "XMLHttpRequest".equals(requestedWith) || 
               (contentType != null && contentType.contains("application/json")) ||
               (accept != null && accept.contains("application/json"));
    }

    /**
     * Handle error display
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        
        if (isAjaxRequest(request)) {
            sendJsonResponse(response, false, errorMessage, null);
        } else {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/view/jsp/admin/users/user-list.jsp").forward(request, response);
        }
    }

    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With");

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        jsonResponse.put("timestamp", new Date().getTime());
        
        if (data != null) {
            jsonResponse.put("data", data);
        }

        try (PrintWriter out = response.getWriter()) {
            String jsonString = gson.toJson(jsonResponse);
            LOGGER.info("Sending JSON response: " + jsonString);
            out.print(jsonString);
            out.flush();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending JSON response", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // Validation Methods

    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^[\\d\\+\\-\\s\\(\\)]{8,15}$");
    }

    private boolean isValidRole(String role) {
        return "TRAVELER".equals(role) || "HOST".equals(role) || "ADMIN".equals(role);
    }

    private String sanitizeParameter(String param) {
        if (param == null) return null;
        return param.trim().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String param = request.getParameter(paramName);
            return (param != null && !param.isEmpty()) ? Integer.parseInt(param) : defaultValue;
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid integer parameter " + paramName + ": " + request.getParameter(paramName));
            return defaultValue;
        }
    }

    private String escapeCSV(String value) {
        if (value == null) return "";
        return value.replace("\"", "\"\"");
    }

    @Override
    public void destroy() {
        try {
            // UserDAO typically doesn't have a close() method
            // Clean up any resources if needed
            userDAO = null;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error during servlet cleanup", e);
        }
        super.destroy();
    }
}