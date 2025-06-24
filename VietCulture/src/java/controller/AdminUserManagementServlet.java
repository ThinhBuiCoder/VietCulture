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
    "/admin/users/*"
})
public class AdminUserManagementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminUserManagementServlet.class.getName());

    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Show users list
                handleUsersList(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show user detail
                int userId = Integer.parseInt(pathInfo.substring(1));
                handleUserDetail(request, response, userId);
            } else if (pathInfo.matches("/\\d+/permissions")) {
                // Show user permissions
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleUserPermissions(request, response, userId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in user management", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu.");
            request.getRequestDispatcher("/view/jsp/admin/users/user-list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminAuthenticated(request)) {
            sendJsonResponse(response, false, "Unauthorized", null);
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/create")) {
                // Create new user
                handleCreateUser(request, response);
            } else if (pathInfo.matches("/\\d+/lock")) {
                // Lock user
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleLockUser(request, response, userId);
            } else if (pathInfo.matches("/\\d+/unlock")) {
                // Unlock user
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleUnlockUser(request, response, userId);
            } else if (pathInfo.matches("/\\d+/permissions")) {
                // Update permissions
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleUpdatePermissions(request, response, userId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in user management POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format in POST", e);
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminAuthenticated(request)) {
            sendJsonResponse(response, false, "Unauthorized", null);
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.matches("/\\d+/delete")) {
            try {
                int userId = Integer.parseInt(pathInfo.split("/")[1]);
                handleDeleteUser(request, response, userId);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error deleting user", e);
                sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.SEVERE, "Invalid user ID format in DELETE", e);
                sendJsonResponse(response, false, "ID không hợp lệ", null);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Handle users list display
     */
    private void handleUsersList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Get filter parameters
        String role = request.getParameter("role"); // Changed from userType to role
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 20;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            // Use default page = 1
        }

        // Get users with filters
        List<User> users = userDAO.getUsersWithFilters(role, status, search, page, pageSize);
        int totalUsers = userDAO.getTotalUsersWithFilters(role, status, search);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("currentRole", role);
        request.setAttribute("currentStatus", status);
        request.setAttribute("currentSearch", search);

        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/users/user-list.jsp").forward(request, response);
    }

    /**
     * Handle user detail display
     */
    private void handleUserDetail(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, ServletException, IOException {

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User không tồn tại");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/jsp/admin/users/user-detail.jsp").forward(request, response);
    }

    /**
     * Handle user permissions display
     */
    private void handleUserPermissions(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, ServletException, IOException {

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User không tồn tại");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/jsp/admin/users/user-permissions.jsp").forward(request, response);
    }

    /**
     * Handle create new user
     */
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role"); // Changed from userType to role
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty()
                || fullName == null || fullName.trim().isEmpty()
                || role == null || role.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            sendJsonResponse(response, false, "Vui lòng điền đầy đủ thông tin bắt buộc.", null);
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
        if (password.length() > 100) {
            sendJsonResponse(response, false, "Mật khẩu không được vượt quá 100 ký tự.", null);
            return;
        }

        // Validate role
        if (!role.equals("TRAVELER") && !role.equals("HOST") && !role.equals("ADMIN")) {
            sendJsonResponse(response, false, "Vai trò không hợp lệ.", null);
            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email)) {
            sendJsonResponse(response, false, "Email đã tồn tại trong hệ thống.", null);
            return;
        }

        // Create user
        User newUser = new User();
        newUser.setEmail(email.trim());
        newUser.setFullName(fullName.trim());
        newUser.setRole(role);
        newUser.setPassword(PasswordUtils.hashPasswordWithSalt(password)); // Assumes PasswordUtils exists
        newUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        newUser.setActive(true);
        newUser.setEmailVerified(true); // Admin-created users are auto-verified
        newUser.setCreatedAt(new Date());

        // Set role-specific fields
        if ("TRAVELER".equals(role)) {
            newUser.setPreferences("{\"likes\": []}");
            newUser.setTotalBookings(0);
        } else if ("HOST".equals(role)) {
            newUser.setBusinessName(fullName + "'s Business");
            newUser.setBusinessType("");
            newUser.setAverageRating(0.0);
            newUser.setTotalExperiences(0);
            newUser.setTotalRevenue(0.0);
        } else if ("ADMIN".equals(role)) {
            newUser.setPermissions("{\"manage_users\": true, \"approve_content\": true, \"view_statistics\": true}");
        }

        int userId = userDAO.createUser(newUser);

        if (userId > 0) {
            LOGGER.info("Admin created new user: " + email + ", ID: " + userId);
            sendJsonResponse(response, true, "Tạo user mới thành công!", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi tạo user.", null);
        }
    }

    /**
     * Handle lock user
     */
    private void handleLockUser(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        String reason = request.getParameter("reason");

        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do khóa tài khoản.", null);
            return;
        }

        // Don't allow locking self
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getUserId() == userId) {
            sendJsonResponse(response, false, "Không thể khóa tài khoản của chính mình.", null);
            return;
        }

        boolean success = userDAO.lockUser(userId, reason);

        if (success) {
            LOGGER.info("Admin locked user ID: " + userId + ", reason: " + reason);
            sendJsonResponse(response, true, "Đã khóa tài khoản thành công.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi khóa tài khoản.", null);
        }
    }

    /**
     * Handle unlock user
     */
    private void handleUnlockUser(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        boolean success = userDAO.unlockUser(userId);

        if (success) {
            LOGGER.info("Admin unlocked user ID: " + userId);
            sendJsonResponse(response, true, "Đã mở khóa tài khoản thành công.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi mở khóa tài khoản.", null);
        }
    }

    /**
     * Handle delete user
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        // Don't allow deleting self
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getUserId() == userId) {
            sendJsonResponse(response, false, "Không thể xóa tài khoản của chính mình.", null);
            return;
        }

        boolean success = userDAO.hardDeleteUser(userId); // Changed to hardDeleteUser

        if (success) {
            LOGGER.info("Admin deleted user ID: " + userId);
            sendJsonResponse(response, true, "Đã xóa tài khoản thành công.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa tài khoản.", null);
        }
    }

    /**
     * Handle update permissions
     */
    private void handleUpdatePermissions(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {

        String role = request.getParameter("role"); // Changed from userType to role
        String permissions = request.getParameter("permissions");

        // Validate role
        if (role == null || (!role.equals("TRAVELER") && !role.equals("HOST") && !role.equals("ADMIN"))) {
            sendJsonResponse(response, false, "Vai trò không hợp lệ.", null);
            return;
        }

        // Don't allow changing own role
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getUserId() == userId) {
            sendJsonResponse(response, false, "Không thể thay đổi vai trò của chính mình.", null);
            return;
        }

        boolean success = false;

        // Update role
        success = userDAO.updateUserRole(userId, role);

        // Update permissions if provided (for ADMIN only)
        if ("ADMIN".equals(role) && permissions != null && !permissions.trim().isEmpty()) {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setPermissions(permissions.trim());
                success &= userDAO.updateUser(user);
            }
        }

        if (success) {
            LOGGER.info("Admin updated role/permissions for user ID: " + userId + ", new role: " + role);
            sendJsonResponse(response, true, "Đã cập nhật phân quyền thành công.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi cập nhật phân quyền.", null);
        }
    }

    /**
     * Check if user is authenticated admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole()); // Changed from userType to role
    }

    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        if (data != null) {
            jsonResponse.put("data", data);
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }
}
