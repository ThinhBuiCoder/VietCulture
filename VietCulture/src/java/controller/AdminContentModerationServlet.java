package controller;

import dao.*;
import model.*;
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
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminContentModeration", urlPatterns = {
    "/admin/content/moderation",
    "/admin/content/moderation/*",
    "/admin/content/moderate",
    "/admin/content/approve",
    "/admin/content/reject",
    "/admin/content/flag"
})
public class AdminContentModerationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminContentModerationServlet.class.getName());
    
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private UserDAO userDAO;
    private ReviewDAO reviewDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
        accommodationDAO = new AccommodationDAO();
        userDAO = new UserDAO();
        reviewDAO = new ReviewDAO();
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
                // Show content moderation overview
                handleModerationOverview(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in content moderation", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu kiểm duyệt.");
            request.getRequestDispatcher("/view/jsp/admin/content/moderation-overview.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdminAuthenticated(request)) {
            sendJsonResponse(response, false, "Unauthorized", null);
            return;
        }
        
        String pathInfo = request.getServletPath();
        
        try {
            switch (pathInfo) {
                case "/admin/content/moderate":
                    handleModerateContent(request, response);
                    break;
                case "/admin/content/approve":
                    handleApproveContent(request, response);
                    break;
                case "/admin/content/reject":
                    handleRejectContent(request, response);
                    break;
                case "/admin/content/flag":
                    handleFlagContent(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in content moderation POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        }
    }
    
    /**
     * Handle moderation overview
     */
    private void handleModerationOverview(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        // Get moderation statistics
        Map<String, Object> stats = getModerationStatistics();
        stats.forEach(request::setAttribute);
        
        // Get pending moderation queue
        List<ModerationItem> moderationQueue = getModerationQueue();
        request.setAttribute("moderationQueue", moderationQueue);
        
        // Get filter parameters
        String priority = request.getParameter("priority");
        String type = request.getParameter("type");
        request.setAttribute("currentPriority", priority);
        request.setAttribute("currentType", type);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/content/moderation-overview.jsp").forward(request, response);
    }
    
    /**
     * Handle moderate content
     */
    private void handleModerateContent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType");
        String contentIdStr = request.getParameter("contentId");
        String reason = request.getParameter("reason");
        
        if (action == null || contentType == null || contentIdStr == null) {
            sendJsonResponse(response, false, "Thiếu thông tin cần thiết", null);
            return;
        }
        
        try {
            int contentId = Integer.parseInt(contentIdStr);
            boolean success = false;
            
            switch (action) {
                case "approve":
                    success = approveContent(contentType, contentId);
                    break;
                case "reject":
                    if (reason == null || reason.trim().isEmpty()) {
                        sendJsonResponse(response, false, "Vui lòng nhập lý do từ chối", null);
                        return;
                    }
                    success = rejectContent(contentType, contentId, reason);
                    break;
                case "request_edit":
                    if (reason == null || reason.trim().isEmpty()) {
                        sendJsonResponse(response, false, "Vui lòng nhập yêu cầu chỉnh sửa", null);
                        return;
                    }
                    success = requestEditContent(contentType, contentId, reason);
                    break;
                default:
                    sendJsonResponse(response, false, "Hành động không hợp lệ", null);
                    return;
            }
            
            if (success) {
                sendJsonResponse(response, true, "Đã xử lý thành công!", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xử lý", null);
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID nội dung không hợp lệ", null);
        }
    }
    
    /**
     * Handle approve content
     */
    private void handleApproveContent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String contentType = request.getParameter("type");
        String contentIdStr = request.getParameter("id");
        
        try {
            int contentId = Integer.parseInt(contentIdStr);
            boolean success = approveContent(contentType, contentId);
            
            if (success) {
                sendJsonResponse(response, true, "Đã duyệt nội dung thành công!", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi duyệt nội dung", null);
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }
    
    /**
     * Handle reject content
     */
    private void handleRejectContent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String contentType = request.getParameter("type");
        String contentIdStr = request.getParameter("id");
        String reason = request.getParameter("reason");
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do từ chối", null);
            return;
        }
        
        try {
            int contentId = Integer.parseInt(contentIdStr);
            boolean success = rejectContent(contentType, contentId, reason);
            
            if (success) {
                sendJsonResponse(response, true, "Đã từ chối nội dung!", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi từ chối nội dung", null);
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }
    
    /**
     * Handle flag content
     */
    private void handleFlagContent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String contentType = request.getParameter("type");
        String contentIdStr = request.getParameter("id");
        
        try {
            int contentId = Integer.parseInt(contentIdStr);
            boolean success = flagContent(contentType, contentId);
            
            if (success) {
                sendJsonResponse(response, true, "Đã đánh dấu nội dung!", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi đánh dấu", null);
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }
    
    /**
     * Get moderation statistics
     */
    private Map<String, Object> getModerationStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Pending moderation count
        int pendingExperiences = experienceDAO.getPendingExperiencesCount();
        int pendingAccommodations = accommodationDAO.getPendingAccommodationsCount();
        int pendingModerationCount = pendingExperiences + pendingAccommodations;
        
        stats.put("pendingModerationCount", pendingModerationCount);
        stats.put("aiDetectedCount", 15); // Sample data
        stats.put("userReportedCount", 8); // Sample data
        stats.put("todayProcessedCount", 32); // Sample data
        
        return stats;
    }
    
    /**
     * Get moderation queue
     */
    private List<ModerationItem> getModerationQueue() throws SQLException {
        List<ModerationItem> queue = new ArrayList<>();
        
        // Sample moderation items - replace with actual implementation
        queue.add(new ModerationItem(1, "experience", "Amazing Hanoi Food Tour", 
            "Experience về ẩm thực Hà Nội...", "John Doe", new Date(), "HIGH", 
            Arrays.asList("Spam", "Inappropriate"), true, 85));
            
        queue.add(new ModerationItem(2, "accommodation", "Luxury Villa in Da Nang", 
            "Villa sang trọng với view biển...", "Jane Smith", new Date(), "MEDIUM", 
            Arrays.asList("Fake Info"), false, 0));
        
        return queue;
    }
    
    /**
     * Approve content
     */
    private boolean approveContent(String contentType, int contentId) throws SQLException {
        switch (contentType.toLowerCase()) {
            case "experience":
                return experienceDAO.approveExperience(contentId);
            case "accommodation":
                return accommodationDAO.approveAccommodation(contentId);
            default:
                return false;
        }
    }
    
    /**
     * Reject content
     */
    private boolean rejectContent(String contentType, int contentId, String reason) throws SQLException {
        switch (contentType.toLowerCase()) {
            case "experience":
                return experienceDAO.rejectExperience(contentId, reason, true);
            case "accommodation":
                return accommodationDAO.rejectAccommodation(contentId, reason, true);
            default:
                return false;
        }
    }
    
    /**
     * Request edit content
     */
    private boolean requestEditContent(String contentType, int contentId, String editRequest) throws SQLException {
        // Implementation for requesting content edit
        return true; // Sample implementation
    }
    
    /**
     * Flag content
     */
    private boolean flagContent(String contentType, int contentId) throws SQLException {
        // Implementation for flagging content
        return true; // Sample implementation
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
    
    /**
     * Inner class for moderation items
     */
    public static class ModerationItem {
        private int contentId;
        private String contentType;
        private String title;
        private String contentPreview;
        private String authorName;
        private Date createdAt;
        private String priority;
        private List<String> violations;
        private boolean aiDetected;
        private int aiConfidence;
        private String thumbnail;
        private int reportCount;
        private String severity;
        private String aiAnalysis;
        private List<Report> recentReports;
        
        public ModerationItem(int contentId, String contentType, String title, String contentPreview, 
                            String authorName, Date createdAt, String priority, List<String> violations, 
                            boolean aiDetected, int aiConfidence) {
            this.contentId = contentId;
            this.contentType = contentType;
            this.title = title;
            this.contentPreview = contentPreview;
            this.authorName = authorName;
            this.createdAt = createdAt;
            this.priority = priority;
            this.violations = violations;
            this.aiDetected = aiDetected;
            this.aiConfidence = aiConfidence;
            this.severity = determineSeverity();
            this.reportCount = 0;
            this.recentReports = new ArrayList<>();
        }
        
        private String determineSeverity() {
            if (aiConfidence > 90) return "CRITICAL";
            if (aiConfidence > 70) return "HIGH";
            if (aiConfidence > 50) return "MEDIUM";
            return "LOW";
        }
        
        // Getters and setters
        public int getContentId() { return contentId; }
        public void setContentId(int contentId) { this.contentId = contentId; }
        
        public String getContentType() { return contentType; }
        public void setContentType(String contentType) { this.contentType = contentType; }
        
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        
        public String getContentPreview() { return contentPreview; }
        public void setContentPreview(String contentPreview) { this.contentPreview = contentPreview; }
        
        public String getAuthorName() { return authorName; }
        public void setAuthorName(String authorName) { this.authorName = authorName; }
        
        public Date getCreatedAt() { return createdAt; }
        public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
        
        public String getPriority() { return priority; }
        public void setPriority(String priority) { this.priority = priority; }
        
        public List<String> getViolations() { return violations; }
        public void setViolations(List<String> violations) { this.violations = violations; }
        
        public boolean isAiDetected() { return aiDetected; }
        public void setAiDetected(boolean aiDetected) { this.aiDetected = aiDetected; }
        
        public int getAiConfidence() { return aiConfidence; }
        public void setAiConfidence(int aiConfidence) { this.aiConfidence = aiConfidence; }
        
        public String getThumbnail() { return thumbnail; }
        public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }
        
        public int getReportCount() { return reportCount; }
        public void setReportCount(int reportCount) { this.reportCount = reportCount; }
        
        public String getSeverity() { return severity; }
        public void setSeverity(String severity) { this.severity = severity; }
        
        public String getAiAnalysis() { return aiAnalysis; }
        public void setAiAnalysis(String aiAnalysis) { this.aiAnalysis = aiAnalysis; }
        
        public List<Report> getRecentReports() { return recentReports; }
        public void setRecentReports(List<Report> recentReports) { this.recentReports = recentReports; }
    }
    
    /**
     * Inner class for reports
     */
    public static class Report {
        private String reason;
        private String description;
        private String reporterName;
        private Date createdAt;
        
        public Report(String reason, String description, String reporterName, Date createdAt) {
            this.reason = reason;
            this.description = description;
            this.reporterName = reporterName;
            this.createdAt = createdAt;
        }
        
        // Getters and setters
        public String getReason() { return reason; }
        public void setReason(String reason) { this.reason = reason; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public String getReporterName() { return reporterName; }
        public void setReporterName(String reporterName) { this.reporterName = reporterName; }
        
        public Date getCreatedAt() { return createdAt; }
        public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    }
}