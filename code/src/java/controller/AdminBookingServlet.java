package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminBookingServlet", urlPatterns = {
    "/admin/bookings",
    "/admin/bookings/",
    "/admin/bookings/*"
})
public class AdminBookingServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AdminBookingServlet.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 20;
    
    private BookingDAO bookingDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        try {
            bookingDAO = new BookingDAO();
            gson = new Gson();
            LOGGER.info("AdminBookingServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminBookingServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding for Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
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
                // Show bookings list
                handleBookingsList(request, response);
            } else if (pathInfo.equals("/statistics")) {
                // Get booking statistics
                handleBookingStatistics(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show booking detail
                int bookingId = Integer.parseInt(pathInfo.substring(1));
                handleBookingDetail(request, response, bookingId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trang không tồn tại");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in booking management", e);
            handleError(request, response, "Có lỗi xảy ra khi truy xuất dữ liệu. Vui lòng thử lại sau.");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid booking ID format: " + pathInfo, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID booking không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in booking management", e);
            handleError(request, response, "Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Admin chỉ có quyền xem, không có quyền cập nhật booking
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin không có quyền cập nhật booking");
    }
    
    /**
     * Handle bookings list with pagination and filters
     */
    private void handleBookingsList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        // Get filter parameters
        String statusFilter = sanitizeParameter(request.getParameter("status"));
        String typeFilter = sanitizeParameter(request.getParameter("type"));
        String searchFilter = sanitizeParameter(request.getParameter("search"));
        
        // Pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        
        // Validate pagination
        if (page < 1) page = 1;
        if (pageSize < 5 || pageSize > 100) pageSize = DEFAULT_PAGE_SIZE;
        
        // Calculate offset
        int offset = (page - 1) * pageSize;
        
        try {
            // Get bookings with filters and pagination
            List<Booking> bookings = bookingDAO.getAllBookings(offset, pageSize, statusFilter, typeFilter, searchFilter);
            int totalBookings = bookingDAO.getTotalBookingsCount(statusFilter, typeFilter, searchFilter);
            int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
            
            // Ensure current page is valid
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
                offset = (page - 1) * pageSize;
                bookings = bookingDAO.getAllBookings(offset, pageSize, statusFilter, typeFilter, searchFilter);
            }
            
            // Get booking statistics
            Map<String, Object> statistics = bookingDAO.getBookingStatistics();
            
            // Set attributes for JSP
            request.setAttribute("bookings", bookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("statistics", statistics);
            
            // Current filter values
            request.setAttribute("currentStatus", statusFilter);
            request.setAttribute("currentType", typeFilter);
            request.setAttribute("currentSearch", searchFilter);
            
            // Success/Error messages from redirects
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
            if (successMsg != null) {
                request.setAttribute("successMessage", successMsg);
            }
            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
            }
            
            // Forward to JSP
            request.getRequestDispatcher("/view/jsp/admin/bookings/booking-list.jsp")
                    .forward(request, response);
                    
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving bookings list", e);
            throw e;
        }
    }
    
    /**
     * Handle booking statistics request
     */
    private void handleBookingStatistics(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        if (!isAjaxRequest(request)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "This endpoint only accepts AJAX requests");
            return;
        }
        
        try {
            Map<String, Object> statistics = bookingDAO.getBookingStatistics();
            sendJsonResponse(response, true, "Thống kê booking", statistics);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving booking statistics", e);
            throw e;
        }
    }
    
    /**
     * Handle booking detail view
     */
    private void handleBookingDetail(HttpServletRequest request, HttpServletResponse response, int bookingId)
            throws SQLException, ServletException, IOException {
        
        try {
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking không tồn tại");
                return;
            }
            
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/view/jsp/admin/bookings/booking-detail.jsp")
                    .forward(request, response);
                    
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving booking detail: " + bookingId, e);
            throw e;
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
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = Map.of(
            "success", success,
            "message", message,
            "data", data
        );
        
        gson.toJson(result, response.getWriter());
    }
    
    /**
     * Handle error and forward to error page
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
    }
    
    /**
     * Sanitize input parameter
     */
    private String sanitizeParameter(String param) {
        if (param == null) return null;
        return param.trim().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    }
    
    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String param = request.getParameter(paramName);
            return (param != null && !param.isEmpty()) ? Integer.parseInt(param) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    

    
    @Override
    public void destroy() {
        try {
            bookingDAO = null;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error during servlet cleanup", e);
        }
        super.destroy();
    }
} 