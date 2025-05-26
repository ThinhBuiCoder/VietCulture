package controller;

import dao.UserDAO;
import dao.TravelerDAO;
import dao.HostDAO;
import dao.AdminDAO;
import model.User;
import model.Traveler;
import model.Host;
import model.Admin;
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
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminUserManagement", urlPatterns = {
    "/admin/users",
    "/admin/users/*"
})
public class AdminUserManagementServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminUserManagementServlet.class.getName());
    
    private UserDAO userDAO;
    private TravelerDAO travelerDAO;
    private HostDAO hostDAO;
    private AdminDAO adminDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        travelerDAO = new TravelerDAO();
        hostDAO = new HostDAO();
        adminDAO = new AdminDAO();
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
        String userType = request.getParameter("userType");
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 20;
        
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Use default page = 1
        }
        
        // Get users with filters
        List<User> users = userDAO.getUsersWithFilters(userType, status, search, page, pageSize);
        int totalUsers = userDAO.getTotalUsersWithFilters(userType, status, search);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        
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
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        request.setAttribute("user", user);
        
        // Get additional info based on user type
        if ("HOST".equals(user.getUserType())) {
            Host host = hostDAO.getHostByUserId(userId);
            request.setAttribute("hostInfo", host);
        } else if ("TRAVELER".equals(user.getUserType())) {
            Traveler traveler = travelerDAO.getTravelerByUserId(userId);
            request.setAttribute("travelerInfo", traveler);
        }
        
        request.getRequestDispatcher("/view/jsp/admin/users/user-detail.jsp").forward(request, response);
    }
    
    /**
     * Handle user permissions display
     */
    private void handleUserPermissions(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, ServletException, IOException {
        
        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
        String userType = request.getParameter("userType");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || 
            fullName == null || fullName.trim().isEmpty() ||
            userType == null || userType.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
            request.getRequestDispatcher("/view/jsp/admin/users/user-list.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại trong hệ thống.");
            request.getRequestDispatcher("/view/jsp/admin/users/user-list.jsp").forward(request, response);
            return;
        }
        
        // Create user
        User newUser = new User(email, password, fullName, userType);
        newUser.setPhone(phone);
        newUser.setEmailVerified(true); // Admin created users are auto-verified
        
        int userId = userDAO.createUser(newUser);
        
        if (userId > 0) {
            // Create related record based on user type
            switch (userType) {
                case "TRAVELER":
                    Traveler traveler = new Traveler();
                    traveler.setUserId(userId);
                    travelerDAO.createTraveler(traveler);
                    break;
                case "HOST":
                    Host host = new Host();
                    host.setUserId(userId);
                    hostDAO.createHost(host);
                    break;
                case "ADMIN":
                    Admin admin = new Admin();
                    admin.setUserId(userId);
                    admin.setRole("ADMIN");
                    adminDAO.createAdmin(admin);
                    break;
            }
            
            LOGGER.info("Admin created new user: " + email);
            request.setAttribute("success", "Tạo user mới thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi tạo user.");
        }
        
        // Redirect back to users list
        response.sendRedirect(request.getContextPath() + "/admin/users");
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
        
        boolean success = userDAO.deleteUser(userId);
        
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
        
        String newUserType = request.getParameter("userType");
        String permissions = request.getParameter("permissions");
        
        boolean success = userDAO.updateUserType(userId, newUserType);
        
        if (success) {
            LOGGER.info("Admin updated permissions for user ID: " + userId);
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
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getUserType());
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
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}