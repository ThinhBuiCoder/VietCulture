package controller;

import dao.AccommodationDAO;
import dao.UserDAO;
import dao.CityDAO;
import model.Accommodation;
import model.User;
import model.City;
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

@WebServlet(name = "AdminAccommodationApproval", urlPatterns = {
    "/admin/accommodations/approval",
    "/admin/accommodations/approval/*",
    "/admin/accommodations/*/approve",
    "/admin/accommodations/*/reject",
    "/admin/accommodations/*/revoke",
    "/admin/accommodations/approve-all",
    "/admin/accommodations/*/images",
    "/admin/accommodations/reject-old",
    "/admin/accommodations/export-pending"
})
public class AdminAccommodationApprovalServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminAccommodationApprovalServlet.class.getName());
    
    private AccommodationDAO accommodationDAO;
    private UserDAO userDAO;
    private CityDAO cityDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        accommodationDAO = new AccommodationDAO();
        userDAO = new UserDAO();
        cityDAO = new CityDAO();
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
                // Show accommodations approval list
                handleAccommodationsList(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show accommodation detail
                int accommodationId = Integer.parseInt(pathInfo.substring(1));
                handleAccommodationDetail(request, response, accommodationId);
            } else if (pathInfo.matches("/\\d+/images")) {
                // Get accommodation images (AJAX)
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleGetAccommodationImages(request, response, accommodationId);
            } else if ("/export-pending".equals(pathInfo)) {
                // Export pending accommodations
                handleExportPending(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in accommodation approval", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu.");
            request.getRequestDispatcher("/view/jsp/admin/content/accommodation-approval.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid accommodation ID format", e);
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
            if (pathInfo != null && pathInfo.matches("/\\d+/approve")) {
                // Approve accommodation
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleApproveAccommodation(request, response, accommodationId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/reject")) {
                // Reject accommodation
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleRejectAccommodation(request, response, accommodationId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/revoke")) {
                // Revoke approval
                int accommodationId = Integer.parseInt(pathInfo.split("/")[1]);
                handleRevokeApproval(request, response, accommodationId);
            } else if ("/approve-all".equals(pathInfo)) {
                // Approve all pending accommodations
                handleApproveAll(request, response);
            } else if ("/reject-old".equals(pathInfo)) {
                // Reject old accommodations
                handleRejectOld(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in accommodation approval POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid accommodation ID format in POST", e);
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }
    
    /**
     * Handle accommodations list display
     */
    private void handleAccommodationsList(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        // Get filter parameters
        String filter = request.getParameter("filter"); // pending, approved, rejected, all
        String type = request.getParameter("type"); // HOTEL, HOMESTAY, RESORT
        int page = 1;
        int pageSize = 12;
        
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Get accommodations based on filter
        List<Accommodation> accommodations;
        int totalAccommodations;
        
        switch (filter != null ? filter : "pending") {
            case "approved":
                accommodations = accommodationDAO.getApprovedAccommodations(page, pageSize, type);
                totalAccommodations = accommodationDAO.getApprovedAccommodationsCount(type);
                break;
            case "rejected":
                accommodations = accommodationDAO.getRejectedAccommodations(page, pageSize, type);
                totalAccommodations = accommodationDAO.getRejectedAccommodationsCount(type);
                break;
            case "all":
                accommodations = accommodationDAO.getAllAccommodations(page, pageSize, type);
                totalAccommodations = accommodationDAO.getTotalAccommodationsCount(type);
                break;
            default: // pending
                accommodations = accommodationDAO.getPendingAccommodations(page, pageSize, type);
                totalAccommodations = accommodationDAO.getPendingAccommodationsCount(type);
                break;
        }
        
        // Enrich accommodations with host and city info
        for (Accommodation acc : accommodations) {
            if (acc.getHostId() > 0) {
                User host = userDAO.getUserById(acc.getHostId());
                acc.setHost(host);
            }
            
            if (acc.getCityId() > 0) {
                City city = cityDAO.getCityById(acc.getCityId());
                acc.setCity(city);
            }
        }
        
        int totalPages = (int) Math.ceil((double) totalAccommodations / pageSize);
        
        // Get statistics
        int pendingCount = accommodationDAO.getPendingAccommodationsCount();
        int approvedCount = accommodationDAO.getApprovedAccommodationsCount();
        int rejectedCount = accommodationDAO.getRejectedAccommodationsCount();
        int totalCount = accommodationDAO.getTotalAccommodationsCount();
        
        // Set attributes
        request.setAttribute("accommodations", accommodations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalAccommodations", totalAccommodations);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentFilter", filter != null ? filter : "pending");
        request.setAttribute("currentType", type);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/content/accommodation-approval.jsp").forward(request, response);
    }
    
    /**
     * Handle accommodation detail display
     */
    private void handleAccommodationDetail(HttpServletRequest request, HttpServletResponse response, int accommodationId) 
            throws SQLException, ServletException, IOException {
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Accommodation không tồn tại");
            return;
        }
        
        // Get host info
        if (accommodation.getHostId() > 0) {
            User host = userDAO.getUserById(accommodation.getHostId());
            accommodation.setHost(host);
        }
        
        // Get city info
        if (accommodation.getCityId() > 0) {
            City city = cityDAO.getCityById(accommodation.getCityId());
            accommodation.setCity(city);
        }
        
        request.setAttribute("accommodation", accommodation);
        request.getRequestDispatcher("/view/jsp/admin/content/accommodation-detail.jsp").forward(request, response);
    }
    
    /**
     * Handle get accommodation images (AJAX)
     */
    private void handleGetAccommodationImages(HttpServletRequest request, HttpServletResponse response, int accommodationId) 
            throws SQLException, IOException {
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null) {
            sendJsonResponse(response, false, "Accommodation not found", null);
            return;
        }
        
        String[] images = accommodation.getImageList();
        
        Map<String, Object> data = new HashMap<>();
        data.put("images", images != null ? images : new String[0]);
        
        sendJsonResponse(response, true, "Success", data);
    }
    
    /**
     * Handle approve accommodation
     */
    private void handleApproveAccommodation(HttpServletRequest request, HttpServletResponse response, int accommodationId) 
            throws SQLException, IOException {
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null) {
            sendJsonResponse(response, false, "Accommodation không tồn tại.", null);
            return;
        }
        
        // Check if already approved
        if (accommodation.isActive()) {
            sendJsonResponse(response, false, "Accommodation đã được duyệt rồi.", null);
            return;
        }
        
        boolean success = accommodationDAO.approveAccommodation(accommodationId);
        
        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " approved accommodation ID: " + accommodationId);
            
            sendJsonResponse(response, true, "Accommodation đã được duyệt thành công!", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi duyệt accommodation.", null);
        }
    }
    
    /**
     * Handle reject accommodation
     */
    private void handleRejectAccommodation(HttpServletRequest request, HttpServletResponse response, int accommodationId) 
            throws SQLException, IOException {
        
        String reason = request.getParameter("reason");
        String allowResubmitStr = request.getParameter("allowResubmit");
        String sendNotificationStr = request.getParameter("sendNotification");
        boolean allowResubmit = "on".equals(allowResubmitStr);
        boolean sendNotification = "on".equals(sendNotificationStr);
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do từ chối.", null);
            return;
        }
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null) {
            sendJsonResponse(response, false, "Accommodation không tồn tại.", null);
            return;
        }
        
        boolean success = accommodationDAO.rejectAccommodation(accommodationId, reason.trim(), allowResubmit);
        
        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " rejected accommodation ID: " + accommodationId + ", reason: " + reason);
            
            // TODO: Send notification to host if requested
            if (sendNotification) {
                // notificationService.sendRejectionNotification(accommodation.getHostId(), accommodationId, reason, allowResubmit);
            }
            
            sendJsonResponse(response, true, "Accommodation đã bị từ chối.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi từ chối accommodation.", null);
        }
    }
    
    /**
     * Handle revoke approval
     */
    private void handleRevokeApproval(HttpServletRequest request, HttpServletResponse response, int accommodationId) 
            throws SQLException, IOException {
        
        String reason = request.getParameter("reason");
        String suspendBookingsStr = request.getParameter("suspendBookings");
        boolean suspendBookings = "on".equals(suspendBookingsStr);
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do thu hồi.", null);
            return;
        }
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null) {
            sendJsonResponse(response, false, "Accommodation không tồn tại.", null);
            return;
        }
        
        if (!accommodation.isActive()) {
            sendJsonResponse(response, false, "Accommodation chưa được duyệt.", null);
            return;
        }
        
        boolean success = accommodationDAO.revokeApproval(accommodationId, reason.trim());
        
        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " revoked approval for accommodation ID: " + accommodationId + ", reason: " + reason);
            
            // TODO: Handle booking suspension if requested
            if (suspendBookings) {
                // bookingService.suspendFutureBookings(accommodationId);
            }
            
            sendJsonResponse(response, true, "Đã thu hồi duyệt accommodation.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi thu hồi duyệt.", null);
        }
    }
    
    /**
     * Handle approve all pending accommodations
     */
    private void handleApproveAll(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 1000); // Get up to 1000 pending
        
        if (pendingAccommodations.isEmpty()) {
            sendJsonResponse(response, false, "Không có accommodation nào cần duyệt.", null);
            return;
        }
        
        int approvedCount = 0;
        
        for (Accommodation acc : pendingAccommodations) {
            try {
                if (accommodationDAO.approveAccommodation(acc.getAccommodationId())) {
                    approvedCount++;
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to approve accommodation ID: " + acc.getAccommodationId(), e);
            }
        }
        
        // Log activity
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        String adminEmail = admin != null ? admin.getEmail() : "Unknown";
        LOGGER.info("Admin " + adminEmail + " bulk approved " + approvedCount + " accommodations");
        
        Map<String, Object> data = new HashMap<>();
        data.put("count", approvedCount);
        data.put("total", pendingAccommodations.size());
        
        sendJsonResponse(response, true, "Đã duyệt " + approvedCount + " accommodation thành công!", data);
    }
    
    /**
     * Handle reject old accommodations
     */
    private void handleRejectOld(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        // Get accommodations older than 30 days
        List<Accommodation> oldAccommodations = accommodationDAO.getOldPendingAccommodations(30);
        
        if (oldAccommodations.isEmpty()) {
            sendJsonResponse(response, false, "Không có accommodation cũ nào cần từ chối.", null);
            return;
        }
        
        int rejectedCount = 0;
        String reason = "Tự động từ chối do quá hạn xét duyệt (30 ngày)";
        
        for (Accommodation acc : oldAccommodations) {
            try {
                if (accommodationDAO.rejectAccommodation(acc.getAccommodationId(), reason, false)) {
                    rejectedCount++;
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to reject old accommodation ID: " + acc.getAccommodationId(), e);
            }
        }
        
        // Log activity
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        String adminEmail = admin != null ? admin.getEmail() : "Unknown";
        LOGGER.info("Admin " + adminEmail + " bulk rejected " + rejectedCount + " old accommodations");
        
        Map<String, Object> data = new HashMap<>();
        data.put("count", rejectedCount);
        data.put("total", oldAccommodations.size());
        
        sendJsonResponse(response, true, "Đã từ chối " + rejectedCount + " accommodation cũ!", data);
    }
    
    /**
     * Handle export pending accommodations
     */
    private void handleExportPending(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        // Set response headers for Excel download
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"pending-accommodations.csv\"");
        
        List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 10000);
        
        try (PrintWriter out = response.getWriter()) {
            // CSV Header
            out.println("ID,Name,Type,Host,City,Created Date,Status");
            
            // CSV Data
            for (Accommodation acc : pendingAccommodations) {
                out.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",%s,\"Pending\"%n",
                    acc.getAccommodationId(),
                    acc.getName() != null ? acc.getName().replace("\"", "\"\"") : "",
                    acc.getType() != null ? acc.getType() : "",
                    acc.getHostName() != null ? acc.getHostName().replace("\"", "\"\"") : "",
                    acc.getCityName() != null ? acc.getCityName().replace("\"", "\"\"") : "",
                    acc.getCreatedAt() != null ? acc.getCreatedAt().toString() : ""
                );
            }
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
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) {
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
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error sending JSON response", e);
        }
    }
}