package controller;

import dao.ComplaintDAO;
import dao.BookingDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Complaint;
import model.User;
import model.Booking;
import model.Experience;
import model.Accommodation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.chatbot.service.NotificationService;

@WebServlet(name = "AdminComplaintServlet", urlPatterns = {"/admin/complaints", "/admin/complaints/*"})
public class AdminComplaintServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminComplaintServlet.class.getName());
    
    private ComplaintDAO complaintDAO;
    private NotificationService notificationService;
    private BookingDAO bookingDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    
    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        notificationService = new NotificationService();
        bookingDAO = new BookingDAO();
        experienceDAO = new ExperienceDAO();
        accommodationDAO = new AccommodationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        
        try {
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                // View complaint detail
                int complaintId = Integer.parseInt(pathInfo.substring(1));
                viewComplaintDetail(request, response, complaintId);
            } else if ("api".equals(action)) {
                // API endpoints
                handleApiRequest(request, response);
            } else {
                // List complaints
                listComplaints(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in AdminComplaintServlet", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid complaint ID", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khiếu nại không hợp lệ");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Không có quyền truy cập");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "update-status":
                    updateComplaintStatus(request, response, currentUser);
                    break;
                case "assign":
                    assignComplaint(request, response, currentUser);
                    break;
                case "resolve":
                    resolveComplaint(request, response, currentUser);
                    break;
                case "delete":
                    deleteComplaint(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in AdminComplaintServlet POST", e);
            sendJsonError(response, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        }
    }
    
    private void listComplaints(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");
        
        List<Complaint> complaints;
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            complaints = complaintDAO.getComplaintsByStatus(statusFilter);
        } else {
            complaints = complaintDAO.getAllComplaints();
        }
        
        // Apply search filter if provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String query = searchQuery.toLowerCase();
            complaints = complaints.stream()
                .filter(c -> c.getUserName() != null && c.getUserName().toLowerCase().contains(query) ||
                           c.getComplaintText() != null && c.getComplaintText().toLowerCase().contains(query))
                .toList();
        }
        
        // Get statistics
        Map<String, Integer> statusCounts = complaintDAO.getComplaintsCountByStatus();
        int newComplaintsCount = complaintDAO.getNewComplaintsCount();
        
        request.setAttribute("complaints", complaints);
        request.setAttribute("statusCounts", statusCounts);
        request.setAttribute("newComplaints", newComplaintsCount);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchQuery", searchQuery);
        
        request.getRequestDispatcher("/view/jsp/admin/complaints/complaint-list.jsp").forward(request, response);
    }
    
    private void viewComplaintDetail(HttpServletRequest request, HttpServletResponse response, int complaintId)
            throws ServletException, IOException, SQLException {
        
        Complaint complaint = complaintDAO.getComplaintById(complaintId);
        
        if (complaint == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khiếu nại");
            return;
        }
        
        request.setAttribute("complaint", complaint);
        request.getRequestDispatcher("/view/jsp/admin/complaints/complaint-detail.jsp").forward(request, response);
    }
    
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String apiAction = request.getParameter("apiAction");
        
        switch (apiAction) {
            case "statistics":
                getComplaintStatistics(response);
                break;
            case "count":
                getComplaintCount(response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "API action không hợp lệ");
        }
    }
    
    private void updateComplaintStatus(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        String newStatus = request.getParameter("status");
        String resolution = request.getParameter("resolution");
        
        boolean success = complaintDAO.updateComplaintResolution(complaintId, newStatus, resolution, currentUser.getUserId());

        // Gửi thông báo cho host nếu khiếu nại được giải quyết
        if (success && "RESOLVED".equalsIgnoreCase(newStatus)) {
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            int hostId = -1;
            String relatedTitle = "";
            if (complaint != null) {
                if (complaint.getRelatedBookingId() != null) {
                    Booking booking = bookingDAO.getBookingById(complaint.getRelatedBookingId());
                    if (booking != null) {
                        if (booking.getExperienceId() != null) {
                            Experience exp = experienceDAO.getExperienceById(booking.getExperienceId());
                            if (exp != null) {
                                hostId = exp.getHostId();
                                relatedTitle = exp.getTitle();
                            }
                        } else if (booking.getAccommodationId() != null) {
                            Accommodation acc = accommodationDAO.getAccommodationById(booking.getAccommodationId());
                            if (acc != null) {
                                hostId = acc.getHostId();
                                relatedTitle = acc.getName();
                            }
                        }
                    }
                }
                // Nếu có trường hostId trực tiếp trong complaint (mở rộng tương lai)
                // else if (complaint.getHostId() != null) { hostId = complaint.getHostId(); }
                if (relatedTitle.isEmpty() && complaint.getRelatedContentTitle() != null) {
                    relatedTitle = complaint.getRelatedContentTitle();
                }
                if (relatedTitle.isEmpty()) {
                    relatedTitle = "Bài đăng của bạn";
                }
            }
            if (hostId > 0) {
                String title = "Khiếu nại đã được giải quyết";
                String message = "Khiếu nại liên quan đến '" + relatedTitle + "' đã được admin xử lý. Vui lòng kiểm tra chi tiết.";
                String contentType = null;
                int contentId = 0;
                if (complaint != null && complaint.getRelatedBookingId() != null) {
                    Booking booking = bookingDAO.getBookingById(complaint.getRelatedBookingId());
                    if (booking != null) {
                        if (booking.getExperienceId() != null) {
                            contentType = "experience";
                            contentId = booking.getExperienceId();
                        } else if (booking.getAccommodationId() != null) {
                            contentType = "accommodation";
                            contentId = booking.getAccommodationId();
                        }
                    }
                }
                notificationService.notifyUser(hostId, title, message, "complaint", contentType, contentId);
            }
        }
        
        String result = "{\"success\":" + success + ",\"message\":\"" + 
                       (success ? "Cập nhật trạng thái thành công" : "Cập nhật trạng thái thất bại") + "\"}";
        
        sendJsonResponse(response, result);
    }
    
    private void assignComplaint(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        
        boolean success = complaintDAO.updateComplaintStatus(complaintId, "IN_PROGRESS", currentUser.getUserId());
        
        String result = "{\"success\":" + success + ",\"message\":\"" + 
                       (success ? "Đã nhận xử lý khiếu nại" : "Không thể nhận xử lý khiếu nại") + "\"}";
        
        sendJsonResponse(response, result);
    }
    
    private void resolveComplaint(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        String resolution = request.getParameter("resolution");
        
        boolean success = complaintDAO.updateComplaintResolution(complaintId, "RESOLVED", resolution, currentUser.getUserId());
        
        String result = "{\"success\":" + success + ",\"message\":\"" + 
                       (success ? "Đã giải quyết khiếu nại" : "Không thể giải quyết khiếu nại") + "\"}";
        
        sendJsonResponse(response, result);
    }
    
    private void deleteComplaint(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        int complaintId = Integer.parseInt(request.getParameter("complaintId"));
        
        boolean success = complaintDAO.deleteComplaint(complaintId);
        
        String result = "{\"success\":" + success + ",\"message\":\"" + 
                       (success ? "Đã xóa khiếu nại" : "Không thể xóa khiếu nại") + "\"}";
        
        sendJsonResponse(response, result);
    }
    
    private void getComplaintStatistics(HttpServletResponse response) throws SQLException, IOException {
        Map<String, Integer> statistics = complaintDAO.getComplaintsCountByStatus();
        
        StringBuilder json = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, Integer> entry : statistics.entrySet()) {
            if (!first) json.append(",");
            json.append("\"").append(entry.getKey()).append("\":").append(entry.getValue());
            first = false;
        }
        json.append("}");
        
        sendJsonResponse(response, json.toString());
    }
    
    private void getComplaintCount(HttpServletResponse response) throws SQLException, IOException {
        int newCount = complaintDAO.getNewComplaintsCount();
        
        String result = "{\"newComplaints\":" + newCount + "}";
        sendJsonResponse(response, result);
    }
    
    private void sendJsonResponse(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
    
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        String error = "{\"success\":false,\"message\":\"" + message + "\"}";
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        sendJsonResponse(response, error);
    }
} 