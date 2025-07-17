package controller;

import dao.ExperienceDAO;
import model.Experience;
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

@WebServlet(name = "AdminExperienceManagement", urlPatterns = {
    "/admin/experiences",
    "/admin/experiences/",
    "/admin/experiences/*"
})
public class AdminExperienceManagementServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminExperienceManagementServlet.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    private ExperienceDAO experienceDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            experienceDAO = new ExperienceDAO();
            gson = new Gson();
            LOGGER.info("AdminExperienceManagementServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminExperienceManagementServlet", e);
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
                // Show experiences list
                handleExperiencesList(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show experience detail
                int experienceId = Integer.parseInt(pathInfo.substring(1));
                handleExperienceDetail(request, response, experienceId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trang không tồn tại");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in experience management", e);
            handleError(request, response, "Có lỗi xảy ra khi truy xuất dữ liệu. Vui lòng thử lại sau.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid experience ID format: " + pathInfo, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID trải nghiệm không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in experience management", e);
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
            LOGGER.warning("Unauthorized access attempt to admin experience management");
            sendJsonResponse(response, false, "Phiên đăng nhập đã hết hạn", null);
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("POST request - PathInfo: " + pathInfo);

        try {
            if (pathInfo != null && pathInfo.matches("/\\d+/toggle-status")) {
                // Toggle experience status (active/inactive)
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleToggleStatus(request, response, experienceId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/approve")) {
                // Approve experience
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleApproveExperience(request, response, experienceId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/reject")) {
                // Reject experience
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleRejectExperience(request, response, experienceId);
            } else {
                LOGGER.warning("Invalid POST path: " + pathInfo);
                sendJsonResponse(response, false, "Đường dẫn không hợp lệ: " + pathInfo, null);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in experience management POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra khi xử lý dữ liệu: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid experience ID format in POST: " + pathInfo, e);
            sendJsonResponse(response, false, "ID trải nghiệm không hợp lệ", null);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in experience management POST", e);
            sendJsonResponse(response, false, "Có lỗi không mong muốn xảy ra: " + e.getMessage(), null);
        }
    }

    /**
     * Handle experiences list display with pagination and filters
     */
    private void handleExperiencesList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Get filter parameters
        String status = sanitizeParameter(request.getParameter("status"));
        String search = sanitizeParameter(request.getParameter("search"));
        
        // Pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        
        // Validate pagination
        if (page < 1) page = 1;
        if (pageSize < 5 || pageSize > 100) pageSize = DEFAULT_PAGE_SIZE;
        
        List<Experience> experiences;
        int totalItems;
        
        // Filter by status
        if ("pending".equals(status)) {
            experiences = experienceDAO.getPendingExperiences(page, pageSize);
            totalItems = experienceDAO.getPendingExperiencesCount();
        } else if ("approved".equals(status)) {
            experiences = experienceDAO.getApprovedExperiences(page, pageSize);
            totalItems = experienceDAO.getApprovedExperiencesCount();
        } else if ("rejected".equals(status)) {
            experiences = experienceDAO.getRejectedExperiences(page, pageSize);
            totalItems = experienceDAO.getRejectedExperiencesCount();
        } else {
            experiences = experienceDAO.getAllExperiences(page, pageSize);
            totalItems = experienceDAO.getTotalExperiencesCount();
        }
        
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        // Set attributes for the JSP
        request.setAttribute("experiences", experiences);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", pageSize);
        
        // Statistics
        Map<String, Integer> stats = new HashMap<>();
        stats.put("pending", experienceDAO.getPendingExperiencesCount());
        stats.put("approved", experienceDAO.getApprovedExperiencesCount());
        stats.put("rejected", experienceDAO.getRejectedExperiencesCount());
        stats.put("total", experienceDAO.getTotalExperiencesCount());
        request.setAttribute("stats", stats);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/experiences/experience-list.jsp").forward(request, response);
    }

    /**
     * Handle experience detail view
     */
    private void handleExperienceDetail(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, ServletException, IOException {
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        
        if (experience == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trải nghiệm không tồn tại");
            return;
        }
        
        request.setAttribute("experience", experience);
        request.getRequestDispatcher("/view/jsp/admin/experiences/experience-detail.jsp").forward(request, response);
    }

    /**
     * Toggle experience status (active/inactive)
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, IOException {
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        
        if (experience == null) {
            sendJsonResponse(response, false, "Trải nghiệm không tồn tại", null);
            return;
        }
        
        boolean newStatus = !experience.isActive();
        boolean success = experienceDAO.updateExperienceStatus(experienceId, newStatus);
        
        if (success) {
            sendJsonResponse(response, true, 
                    "Trạng thái trải nghiệm đã được " + (newStatus ? "hiển thị" : "ẩn") + " thành công", 
                    Map.of("experienceId", experienceId, "isActive", newStatus));
        } else {
            sendJsonResponse(response, false, "Không thể cập nhật trạng thái trải nghiệm", null);
        }
    }
    
    /**
     * Approve experience
     */
    private void handleApproveExperience(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, IOException {
        
        User admin = (User) request.getSession().getAttribute("user");
        boolean success = experienceDAO.approveExperience(experienceId, admin.getUserId());
        
        if (success) {
            sendJsonResponse(response, true, "Đã duyệt trải nghiệm thành công", 
                    Map.of("experienceId", experienceId));
        } else {
            sendJsonResponse(response, false, "Không thể duyệt trải nghiệm", null);
        }
    }
    
    /**
     * Reject experience
     */
    private void handleRejectExperience(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, IOException {
        
        User admin = (User) request.getSession().getAttribute("user");
        String reason = sanitizeParameter(request.getParameter("reason"));
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do từ chối", null);
            return;
        }
        
        boolean success = experienceDAO.rejectExperience(experienceId, admin.getUserId(), reason);
        
        if (success) {
            sendJsonResponse(response, true, "Đã từ chối trải nghiệm thành công", 
                    Map.of("experienceId", experienceId));
        } else {
            sendJsonResponse(response, false, "Không thể từ chối trải nghiệm", null);
        }
    }

    /**
     * Check if the user is authenticated as admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        
        return user != null && "ADMIN".equals(user.getRole());
    }
    
    /**
     * Check if the request is an AJAX request
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWithHeader = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(requestedWithHeader);
    }

    /**
     * Handle errors in the servlet
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
    }

    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", message);
        
        if (data != null) {
            result.put("data", data);
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Sanitize a parameter value
     */
    private String sanitizeParameter(String param) {
        return param == null ? null : param.trim();
    }
    
    /**
     * Get an integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        
        if (paramValue == null || paramValue.trim().isEmpty()) {
            return defaultValue;
        }
        
        try {
            return Integer.parseInt(paramValue);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    public void destroy() {
        LOGGER.info("AdminExperienceManagementServlet destroyed");
    }
} 