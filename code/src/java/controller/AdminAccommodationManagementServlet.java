package controller;

import dao.AccommodationDAO;
import model.Accommodation;
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

@WebServlet(name = "AdminAccommodationManagement", urlPatterns = {
    "/admin/accommodations",
    "/admin/accommodations/",
    "/admin/accommodations/*"
})
public class AdminAccommodationManagementServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminAccommodationManagementServlet.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    private AccommodationDAO accommodationDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            accommodationDAO = new AccommodationDAO();
            gson = new Gson();
            LOGGER.info("AdminAccommodationManagementServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminAccommodationManagementServlet", e);
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
                // Show accommodations list
                handleAccommodationsList(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show accommodation detail
                int accommodationId = Integer.parseInt(pathInfo.substring(1));
                handleAccommodationDetail(request, response, accommodationId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trang không tồn tại");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in accommodation management", e);
            handleError(request, response, "Có lỗi xảy ra khi truy xuất dữ liệu. Vui lòng thử lại sau.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid accommodation ID format: " + pathInfo, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID lưu trú không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in accommodation management", e);
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
            LOGGER.warning("Unauthorized access attempt to admin accommodation management");
            sendJsonResponse(response, false, "Phiên đăng nhập đã hết hạn", null);
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("POST request - PathInfo: " + pathInfo);

        try {
            if (pathInfo != null && pathInfo.matches("/\\d+/toggle-status")) {
                // Toggle accommodation status (active/inactive)
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleToggleStatus(request, response, accommodationId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/approve")) {
                // Approve accommodation
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleApproveAccommodation(request, response, accommodationId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/reject")) {
                // Reject accommodation
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleRejectAccommodation(request, response, accommodationId);
            } else {
                LOGGER.warning("Invalid POST path: " + pathInfo);
                sendJsonResponse(response, false, "Đường dẫn không hợp lệ: " + pathInfo, null);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in accommodation management POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra khi xử lý dữ liệu: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid accommodation ID format in POST: " + pathInfo, e);
            sendJsonResponse(response, false, "ID lưu trú không hợp lệ", null);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in accommodation management POST", e);
            sendJsonResponse(response, false, "Có lỗi không mong muốn xảy ra: " + e.getMessage(), null);
        }
    }

    /**
     * Handle accommodations list display with pagination and filters
     */
    private void handleAccommodationsList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Get filter parameters
        String status = sanitizeParameter(request.getParameter("status"));
        String type = sanitizeParameter(request.getParameter("type"));
        
        // Pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        
        // Validate pagination
        if (page < 1) page = 1;
        if (pageSize < 5 || pageSize > 100) pageSize = DEFAULT_PAGE_SIZE;
        
        List<Accommodation> accommodations;
        int totalItems;
        
        // Filter by status
        if ("pending".equals(status)) {
            accommodations = type == null || type.isEmpty() ? 
                             accommodationDAO.getPendingAccommodations(page, pageSize) :
                             accommodationDAO.getPendingAccommodations(page, pageSize, type);
            totalItems = type == null || type.isEmpty() ?
                         accommodationDAO.getPendingAccommodationsCount() :
                         accommodationDAO.getPendingAccommodationsCount(type);
        } else if ("approved".equals(status)) {
            accommodations = type == null || type.isEmpty() ?
                             accommodationDAO.getApprovedAccommodations(page, pageSize) :
                             accommodationDAO.getApprovedAccommodations(page, pageSize, type);
            totalItems = type == null || type.isEmpty() ?
                         accommodationDAO.getApprovedAccommodationsCount() :
                         accommodationDAO.getApprovedAccommodationsCount(type);
        } else if ("rejected".equals(status)) {
            accommodations = accommodationDAO.getRejectedAccommodations(page, pageSize);
            totalItems = accommodationDAO.getRejectedAccommodationsCount();
        } else {
            accommodations = type == null || type.isEmpty() ?
                             accommodationDAO.getAllAccommodations(page, pageSize) :
                             accommodationDAO.getAllAccommodations(page, pageSize, type);
            totalItems = type == null || type.isEmpty() ?
                         accommodationDAO.getTotalAccommodationsCount() :
                         accommodationDAO.getTotalAccommodationsCount(type);
        }
        
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        // Set attributes for the JSP
        request.setAttribute("accommodations", accommodations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("selectedType", type);
        
        // Statistics
        Map<String, Integer> stats = new HashMap<>();
        stats.put("pending", accommodationDAO.getPendingAccommodationsCount());
        stats.put("approved", accommodationDAO.getApprovedAccommodationsCount());
        stats.put("rejected", accommodationDAO.getRejectedAccommodationsCount());
        stats.put("total", accommodationDAO.getTotalAccommodationsCount());
        stats.put("active", accommodationDAO.getActiveAccommodationsCount());
        request.setAttribute("stats", stats);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/accommodations/accommodation-list.jsp").forward(request, response);
    }

    /**
     * Handle accommodation detail view
     */
    private void handleAccommodationDetail(HttpServletRequest request, HttpServletResponse response, int accommodationId)
            throws SQLException, ServletException, IOException {
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        
        if (accommodation == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Lưu trú không tồn tại");
            return;
        }
        
        request.setAttribute("accommodation", accommodation);
        request.getRequestDispatcher("/view/jsp/admin/accommodations/accommodation-detail.jsp").forward(request, response);
    }

    /**
     * Toggle accommodation status (active/inactive)
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, int accommodationId)
            throws SQLException, IOException {
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        
        if (accommodation == null) {
            sendJsonResponse(response, false, "Lưu trú không tồn tại", null);
            return;
        }
        
        boolean newStatus = !accommodation.isActive();
        boolean success = accommodationDAO.updateAccommodationStatus(accommodationId, newStatus);
        
        if (success) {
            sendJsonResponse(response, true, 
                    "Trạng thái lưu trú đã được " + (newStatus ? "hiển thị" : "ẩn") + " thành công", 
                    Map.of("accommodationId", accommodationId, "isActive", newStatus));
        } else {
            sendJsonResponse(response, false, "Không thể cập nhật trạng thái lưu trú", null);
        }
    }
    
    /**
     * Approve accommodation
     */
    private void handleApproveAccommodation(HttpServletRequest request, HttpServletResponse response, int accommodationId)
            throws SQLException, IOException {
        
        User admin = (User) request.getSession().getAttribute("user");
        boolean success = accommodationDAO.approveAccommodation(accommodationId, admin.getUserId());
        
        if (success) {
            sendJsonResponse(response, true, "Đã duyệt lưu trú thành công", 
                    Map.of("accommodationId", accommodationId));
        } else {
            sendJsonResponse(response, false, "Không thể duyệt lưu trú", null);
        }
    }
    
    /**
     * Reject accommodation
     */
    private void handleRejectAccommodation(HttpServletRequest request, HttpServletResponse response, int accommodationId)
            throws SQLException, IOException {
        
        User admin = (User) request.getSession().getAttribute("user");
        String reason = sanitizeParameter(request.getParameter("reason"));
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do từ chối", null);
            return;
        }
        
        boolean success = accommodationDAO.rejectAccommodation(accommodationId, admin.getUserId(), reason);
        
        if (success) {
            sendJsonResponse(response, true, "Đã từ chối lưu trú thành công", 
                    Map.of("accommodationId", accommodationId));
        } else {
            sendJsonResponse(response, false, "Không thể từ chối lưu trú", null);
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
        LOGGER.info("AdminAccommodationManagementServlet destroyed");
    }
} 