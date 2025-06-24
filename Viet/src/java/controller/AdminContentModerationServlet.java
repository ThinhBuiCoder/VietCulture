package controller;

import dao.ExperienceDAO;
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
    "/admin/content/flag"
<<<<<<< HEAD
// BỎ 2 dòng accommodation approval
})
public class AdminContentModerationServlet extends HttpServlet {

=======
    // BỎ 2 dòng accommodation approval
})
public class AdminContentModerationServlet extends HttpServlet {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private static final Logger LOGGER = Logger.getLogger(AdminContentModerationServlet.class.getName());

    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private UserDAO userDAO;
    private ReviewDAO reviewDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            userDAO = new UserDAO();
            reviewDAO = new ReviewDAO();
            gson = new Gson();
            LOGGER.info("AdminContentModerationServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminContentModerationServlet", e);
            throw new ServletException("Initialization failed", e);
        }
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
                handleModerationOverview(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // View specific content detail
                int contentId = Integer.parseInt(pathInfo.substring(1));
                handleContentDetail(request, response, contentId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in content moderation", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu kiểm duyệt.");
            request.getRequestDispatcher("/view/jsp/admin/content/moderation-overview.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid content ID format", e);
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

        String pathInfo = request.getServletPath();

        try {
            switch (pathInfo) {
                case "/admin/content/moderate":
                    handleModerateContent(request, response);
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
     * Handle moderation overview display
     */
    private void handleModerationOverview(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Get filter parameters
        String priority = request.getParameter("priority"); // HIGH, MEDIUM, LOW
        String type = request.getParameter("type"); // experience, accommodation, review
        String status = request.getParameter("status"); // pending, flagged, approved
        int page = getPageFromRequest(request);
        int pageSize = 20;

        // Get moderation statistics
        Map<String, Object> stats = getModerationStatistics();
        stats.forEach(request::setAttribute);

        // Get moderation queue based on filters
        List<ModerationItem> moderationQueue = getModerationQueue(priority, type, status, page, pageSize);
        request.setAttribute("moderationQueue", moderationQueue);

        // Get total count for pagination
        int totalCount = getModerationQueueCount(priority, type, status);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // Set pagination attributes
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);

        // Set current filter values
        request.setAttribute("currentPriority", priority);
        request.setAttribute("currentType", type);
        request.setAttribute("currentStatus", status);

        // Get recent moderation activities
        List<ModerationActivity> recentActivities = getRecentModerationActivities(10);
        request.setAttribute("recentActivities", recentActivities);

        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/content/moderation-overview.jsp").forward(request, response);
    }

    /**
     * Handle content detail view
     */
    private void handleContentDetail(HttpServletRequest request, HttpServletResponse response, int contentId)
            throws SQLException, ServletException, IOException {

        String contentType = request.getParameter("type");
        if (contentType == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Content type is required");
            return;
        }

        Object content = null;
        switch (contentType.toLowerCase()) {
            case "experience":
                content = experienceDAO.getExperienceById(contentId);
                break;
            case "accommodation":
                content = accommodationDAO.getAccommodationById(contentId);
                break;
            case "review":
                content = reviewDAO.getReviewById(contentId);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid content type");
                return;
        }

        if (content == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Content not found");
            return;
        }

        // Get content history and flags
        List<ModerationHistory> history = getModerationHistory(contentType, contentId);
        List<ContentFlag> flags = getContentFlags(contentType, contentId);

        request.setAttribute("content", content);
        request.setAttribute("contentType", contentType);
        request.setAttribute("contentId", contentId);
        request.setAttribute("moderationHistory", history);
        request.setAttribute("contentFlags", flags);

        request.getRequestDispatcher("/view/jsp/admin/content/content-detail.jsp").forward(request, response);
    }

    /**
     * Handle moderate content action
     */
    private void handleModerateContent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType");
        String contentIdStr = request.getParameter("contentId");
        String reason = request.getParameter("reason");
        String notes = request.getParameter("notes");

        if (action == null || contentType == null || contentIdStr == null) {
            sendJsonResponse(response, false, "Thiếu thông tin cần thiết", null);
            return;
        }

        try {
            int contentId = Integer.parseInt(contentIdStr);
            boolean success = false;
            String message = "";

            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            int adminId = admin != null ? admin.getUserId() : 0;

            switch (action.toLowerCase()) {
                case "approve":
                    success = approveContent(contentType, contentId);
                    message = success ? "Đã duyệt nội dung thành công!" : "Có lỗi xảy ra khi duyệt nội dung";
                    break;
                case "reject":
                    success = rejectContent(contentType, contentId, reason);
                    message = success ? "Đã từ chối nội dung!" : "Có lỗi xảy ra khi từ chối nội dung";
                    break;
                case "flag":
                    success = flagContent(contentType, contentId, reason);
                    message = success ? "Đã đánh dấu nội dung vi phạm!" : "Có lỗi xảy ra khi đánh dấu";
                    break;
                case "unflag":
                    success = unflagContent(contentType, contentId);
                    message = success ? "Đã bỏ đánh dấu vi phạm!" : "Có lỗi xảy ra khi bỏ đánh dấu";
                    break;
                default:
                    sendJsonResponse(response, false, "Hành động không hợp lệ", null);
                    return;
            }

            if (success) {
                // Log moderation activity
                logModerationActivity(adminId, contentType, contentId, action, reason, notes);
<<<<<<< HEAD

                LOGGER.info(String.format("Admin %d performed %s on %s ID %d",
                        adminId, action, contentType, contentId));
=======
                
                LOGGER.info(String.format("Admin %d performed %s on %s ID %d", 
                    adminId, action, contentType, contentId));
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            }

            sendJsonResponse(response, success, message, null);

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID nội dung không hợp lệ", null);
        }
    }

    /**
     * Handle flag content action
     */
    private void handleFlagContent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String contentType = request.getParameter("type");
        String contentIdStr = request.getParameter("id");
        String reason = request.getParameter("reason");
        String severity = request.getParameter("severity"); // LOW, MEDIUM, HIGH

        if (contentType == null || contentIdStr == null || reason == null) {
            sendJsonResponse(response, false, "Thiếu thông tin cần thiết", null);
            return;
        }

        try {
            int contentId = Integer.parseInt(contentIdStr);
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            int adminId = admin != null ? admin.getUserId() : 0;

            boolean success = createContentFlag(contentType, contentId, reason, severity, adminId);

            if (success) {
                logModerationActivity(adminId, contentType, contentId, "flag", reason, null);
                sendJsonResponse(response, true, "Đã đánh dấu nội dung vi phạm!", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi đánh dấu nội dung", null);
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
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        try {
            // Experience statistics
            int pendingExperiences = experienceDAO.getPendingExperiencesCount();
            int flaggedExperiences = experienceDAO.getFlaggedExperiencesCount();
            int approvedExperiences = experienceDAO.getApprovedExperiencesCount();

            // Accommodation statistics
            int pendingAccommodations = accommodationDAO.getPendingAccommodationsCount();
            int flaggedAccommodations = accommodationDAO.getFlaggedAccommodationsCount();
            int approvedAccommodations = accommodationDAO.getApprovedAccommodationsCount();

            // Review statistics (if available)
            int pendingReviews = 0;
            int flaggedReviews = 0;
            if (reviewDAO != null) {
                pendingReviews = reviewDAO.getPendingReviewsCount();
                flaggedReviews = reviewDAO.getFlaggedReviewsCount();
            }

            // Total counts
            int totalPending = pendingExperiences + pendingAccommodations + pendingReviews;
            int totalFlagged = flaggedExperiences + flaggedAccommodations + flaggedReviews;
            int totalApproved = approvedExperiences + approvedAccommodations;

            // Set statistics
            stats.put("pendingModerationCount", totalPending);
            stats.put("flaggedContentCount", totalFlagged);
            stats.put("approvedContentCount", totalApproved);
<<<<<<< HEAD

            stats.put("pendingExperiences", pendingExperiences);
            stats.put("pendingAccommodations", pendingAccommodations);
            stats.put("pendingReviews", pendingReviews);

=======
            
            stats.put("pendingExperiences", pendingExperiences);
            stats.put("pendingAccommodations", pendingAccommodations);
            stats.put("pendingReviews", pendingReviews);
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            stats.put("flaggedExperiences", flaggedExperiences);
            stats.put("flaggedAccommodations", flaggedAccommodations);
            stats.put("flaggedReviews", flaggedReviews);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting moderation statistics", e);
            // Set default values
            stats.put("pendingModerationCount", 0);
            stats.put("flaggedContentCount", 0);
            stats.put("approvedContentCount", 0);
        }

        return stats;
    }

    /**
     * Get moderation queue with filters
     */
<<<<<<< HEAD
    private List<ModerationItem> getModerationQueue(String priority, String type, String status, int page, int pageSize)
=======
    private List<ModerationItem> getModerationQueue(String priority, String type, String status, int page, int pageSize) 
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            throws SQLException {
        List<ModerationItem> queue = new ArrayList<>();

        try {
            // Get experiences
            if (type == null || "experience".equals(type)) {
                List<Experience> experiences = getFilteredExperiences(status, page, pageSize);
                for (Experience exp : experiences) {
                    User host = userDAO.getUserById(exp.getHostId());
                    queue.add(new ModerationItem(
<<<<<<< HEAD
                            exp.getExperienceId(),
                            "experience",
                            exp.getTitle(),
                            truncateText(exp.getDescription(), 100),
                            host != null ? host.getFullName() : "Unknown",
                            exp.getCreatedAt(),
                            determinePriority(exp),
                            getViolations(exp),
                            false, // AI detection placeholder
                            0 // AI confidence placeholder
=======
                        exp.getExperienceId(),
                        "experience",
                        exp.getTitle(),
                        truncateText(exp.getDescription(), 100),
                        host != null ? host.getFullName() : "Unknown",
                        exp.getCreatedAt(),
                        determinePriority(exp),
                        getViolations(exp),
                        false, // AI detection placeholder
                        0      // AI confidence placeholder
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                    ));
                }
            }

            // Get accommodations
            if (type == null || "accommodation".equals(type)) {
                List<Accommodation> accommodations = getFilteredAccommodations(status, page, pageSize);
                for (Accommodation acc : accommodations) {
                    User host = userDAO.getUserById(acc.getHostId());
                    queue.add(new ModerationItem(
<<<<<<< HEAD
                            acc.getAccommodationId(),
                            "accommodation",
                            acc.getName(),
                            truncateText(acc.getDescription(), 100),
                            host != null ? host.getFullName() : "Unknown",
                            acc.getCreatedAt(),
                            determinePriority(acc),
                            getViolations(acc),
                            false, // AI detection placeholder
                            0 // AI confidence placeholder
=======
                        acc.getAccommodationId(),
                        "accommodation",
                        acc.getName(),
                        truncateText(acc.getDescription(), 100),
                        host != null ? host.getFullName() : "Unknown",
                        acc.getCreatedAt(),
                        determinePriority(acc),
                        getViolations(acc),
                        false, // AI detection placeholder
                        0      // AI confidence placeholder
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                    ));
                }
            }

            // Sort by priority and date
            queue.sort((a, b) -> {
                int priorityCompare = getPriorityWeight(b.getPriority()) - getPriorityWeight(a.getPriority());
<<<<<<< HEAD
                if (priorityCompare != 0) {
                    return priorityCompare;
                }
=======
                if (priorityCompare != 0) return priorityCompare;
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                return b.getCreatedAt().compareTo(a.getCreatedAt());
            });

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting moderation queue", e);
            throw e;
        }

        return queue;
    }

    /**
     * Get moderation queue count for pagination
     */
    private int getModerationQueueCount(String priority, String type, String status) throws SQLException {
        int count = 0;
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        try {
            if (type == null || "experience".equals(type)) {
                count += getFilteredExperiencesCount(status);
            }
            if (type == null || "accommodation".equals(type)) {
                count += getFilteredAccommodationsCount(status);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting moderation queue count", e);
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        return count;
    }

    /**
     * Get filtered experiences based on status
     */
    private List<Experience> getFilteredExperiences(String status, int page, int pageSize) throws SQLException {
        switch (status != null ? status : "pending") {
            case "flagged":
                return experienceDAO.getFlaggedExperiences(page, pageSize);
            case "approved":
                return experienceDAO.getApprovedExperiences(page, pageSize);
            default:
                return experienceDAO.getPendingExperiences(page, pageSize);
        }
    }

    /**
     * Get filtered accommodations based on status
     */
    private List<Accommodation> getFilteredAccommodations(String status, int page, int pageSize) throws SQLException {
        switch (status != null ? status : "pending") {
            case "flagged":
                return accommodationDAO.getFlaggedAccommodations(page, pageSize);
            case "approved":
                return accommodationDAO.getApprovedAccommodations(page, pageSize);
            default:
                return accommodationDAO.getPendingAccommodations(page, pageSize);
        }
    }

    /**
     * Get filtered count methods
     */
    private int getFilteredExperiencesCount(String status) throws SQLException {
        switch (status != null ? status : "pending") {
            case "flagged":
                return experienceDAO.getFlaggedExperiencesCount();
            case "approved":
                return experienceDAO.getApprovedExperiencesCount();
            default:
                return experienceDAO.getPendingExperiencesCount();
        }
    }

    private int getFilteredAccommodationsCount(String status) throws SQLException {
        switch (status != null ? status : "pending") {
            case "flagged":
                return accommodationDAO.getFlaggedAccommodationsCount();
            case "approved":
                return accommodationDAO.getApprovedAccommodationsCount();
            default:
                return accommodationDAO.getPendingAccommodationsCount();
        }
    }

    /**
     * Content moderation actions
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

    private boolean rejectContent(String contentType, int contentId, String reason) throws SQLException {
        switch (contentType.toLowerCase()) {
            case "experience":
                return experienceDAO.rejectExperience(contentId, reason);
            case "accommodation":
                return accommodationDAO.rejectAccommodation(contentId, reason);
            default:
                return false;
        }
    }

    private boolean flagContent(String contentType, int contentId, String reason) throws SQLException {
        switch (contentType.toLowerCase()) {
            case "experience":
                return experienceDAO.flagExperience(contentId, reason);
            case "accommodation":
                return accommodationDAO.flagAccommodation(contentId, reason);
            default:
                return false;
        }
    }

    private boolean unflagContent(String contentType, int contentId) throws SQLException {
        switch (contentType.toLowerCase()) {
            case "experience":
                return experienceDAO.unflagExperience(contentId);
            case "accommodation":
                return accommodationDAO.unflagAccommodation(contentId);
            default:
                return false;
        }
    }

    /**
     * Helper methods
     */
    private int getPageFromRequest(HttpServletRequest request) {
        try {
            String pageStr = request.getParameter("page");
            return pageStr != null ? Math.max(1, Integer.parseInt(pageStr)) : 1;
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private String truncateText(String text, int maxLength) {
<<<<<<< HEAD
        if (text == null) {
            return "";
        }
=======
        if (text == null) return "";
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        return text.length() > maxLength ? text.substring(0, maxLength) + "..." : text;
    }

    private String determinePriority(Object content) {
        // Simple priority logic - can be enhanced
        return "MEDIUM";
    }

    private List<String> getViolations(Object content) {
        // Placeholder for violation detection
        return new ArrayList<>();
    }

    private int getPriorityWeight(String priority) {
        switch (priority) {
<<<<<<< HEAD
            case "HIGH":
                return 3;
            case "MEDIUM":
                return 2;
            case "LOW":
                return 1;
            default:
                return 0;
=======
            case "HIGH": return 3;
            case "MEDIUM": return 2;
            case "LOW": return 1;
            default: return 0;
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        }
    }

    private List<ModerationActivity> getRecentModerationActivities(int limit) {
        // Placeholder - implement with database
        return new ArrayList<>();
    }

    private List<ModerationHistory> getModerationHistory(String contentType, int contentId) {
        // Placeholder - implement with database
        return new ArrayList<>();
    }

    private List<ContentFlag> getContentFlags(String contentType, int contentId) {
        // Placeholder - implement with database
        return new ArrayList<>();
    }

    private boolean createContentFlag(String contentType, int contentId, String reason, String severity, int adminId) {
        // Placeholder - implement with database
        return true;
    }

    private void logModerationActivity(int adminId, String contentType, int contentId, String action, String reason, String notes) {
        // Placeholder - implement with database logging
<<<<<<< HEAD
        LOGGER.info(String.format("Moderation activity logged: Admin %d, %s %d, Action: %s",
                adminId, contentType, contentId, action));
=======
        LOGGER.info(String.format("Moderation activity logged: Admin %d, %s %d, Action: %s", 
            adminId, contentType, contentId, action));
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
<<<<<<< HEAD
        if (session == null) {
            return false;
        }
=======
        if (session == null) return false;
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b

        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

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
     * Moderation item class
     */
    public static class ModerationItem {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
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

        public ModerationItem(int contentId, String contentType, String title, String contentPreview,
<<<<<<< HEAD
                String authorName, Date createdAt, String priority, List<String> violations,
                boolean aiDetected, int aiConfidence) {
=======
                            String authorName, Date createdAt, String priority, List<String> violations,
                            boolean aiDetected, int aiConfidence) {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
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
        }

        // Getters
<<<<<<< HEAD
        public int getContentId() {
            return contentId;
        }

        public String getContentType() {
            return contentType;
        }

        public String getTitle() {
            return title;
        }

        public String getContentPreview() {
            return contentPreview;
        }

        public String getAuthorName() {
            return authorName;
        }

        public Date getCreatedAt() {
            return createdAt;
        }

        public String getPriority() {
            return priority;
        }

        public List<String> getViolations() {
            return violations;
        }

        public boolean isAiDetected() {
            return aiDetected;
        }

        public int getAiConfidence() {
            return aiConfidence;
        }
=======
        public int getContentId() { return contentId; }
        public String getContentType() { return contentType; }
        public String getTitle() { return title; }
        public String getContentPreview() { return contentPreview; }
        public String getAuthorName() { return authorName; }
        public Date getCreatedAt() { return createdAt; }
        public String getPriority() { return priority; }
        public List<String> getViolations() { return violations; }
        public boolean isAiDetected() { return aiDetected; }
        public int getAiConfidence() { return aiConfidence; }
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    }

    /**
     * Supporting classes for moderation system
     */
    public static class ModerationActivity {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        private int activityId;
        private int adminId;
        private String adminName;
        private String contentType;
        private int contentId;
        private String action;
        private String reason;
        private Date timestamp;

        // Constructor and getters
        public ModerationActivity(int activityId, int adminId, String adminName, String contentType,
<<<<<<< HEAD
                int contentId, String action, String reason, Date timestamp) {
=======
                                int contentId, String action, String reason, Date timestamp) {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            this.activityId = activityId;
            this.adminId = adminId;
            this.adminName = adminName;
            this.contentType = contentType;
            this.contentId = contentId;
            this.action = action;
            this.reason = reason;
            this.timestamp = timestamp;
        }

        // Getters
<<<<<<< HEAD
        public int getActivityId() {
            return activityId;
        }

        public int getAdminId() {
            return adminId;
        }

        public String getAdminName() {
            return adminName;
        }

        public String getContentType() {
            return contentType;
        }

        public int getContentId() {
            return contentId;
        }

        public String getAction() {
            return action;
        }

        public String getReason() {
            return reason;
        }

        public Date getTimestamp() {
            return timestamp;
        }
    }

    public static class ModerationHistory {

=======
        public int getActivityId() { return activityId; }
        public int getAdminId() { return adminId; }
        public String getAdminName() { return adminName; }
        public String getContentType() { return contentType; }
        public int getContentId() { return contentId; }
        public String getAction() { return action; }
        public String getReason() { return reason; }
        public Date getTimestamp() { return timestamp; }
    }

    public static class ModerationHistory {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        private int historyId;
        private String contentType;
        private int contentId;
        private String action;
        private String reason;
        private String adminName;
        private Date timestamp;

        // Constructor and getters
        public ModerationHistory(int historyId, String contentType, int contentId, String action,
<<<<<<< HEAD
                String reason, String adminName, Date timestamp) {
=======
                               String reason, String adminName, Date timestamp) {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            this.historyId = historyId;
            this.contentType = contentType;
            this.contentId = contentId;
            this.action = action;
            this.reason = reason;
            this.adminName = adminName;
            this.timestamp = timestamp;
        }

        // Getters
<<<<<<< HEAD
        public int getHistoryId() {
            return historyId;
        }

        public String getContentType() {
            return contentType;
        }

        public int getContentId() {
            return contentId;
        }

        public String getAction() {
            return action;
        }

        public String getReason() {
            return reason;
        }

        public String getAdminName() {
            return adminName;
        }

        public Date getTimestamp() {
            return timestamp;
        }
    }

    public static class ContentFlag {

=======
        public int getHistoryId() { return historyId; }
        public String getContentType() { return contentType; }
        public int getContentId() { return contentId; }
        public String getAction() { return action; }
        public String getReason() { return reason; }
        public String getAdminName() { return adminName; }
        public Date getTimestamp() { return timestamp; }
    }

    public static class ContentFlag {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        private int flagId;
        private String contentType;
        private int contentId;
        private String reason;
        private String severity;
        private String reporterName;
        private Date reportedAt;
        private boolean resolved;

        // Constructor and getters
        public ContentFlag(int flagId, String contentType, int contentId, String reason,
<<<<<<< HEAD
                String severity, String reporterName, Date reportedAt, boolean resolved) {
=======
                         String severity, String reporterName, Date reportedAt, boolean resolved) {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            this.flagId = flagId;
            this.contentType = contentType;
            this.contentId = contentId;
            this.reason = reason;
            this.severity = severity;
            this.reporterName = reporterName;
            this.reportedAt = reportedAt;
            this.resolved = resolved;
        }

        // Getters
<<<<<<< HEAD
        public int getFlagId() {
            return flagId;
        }

        public String getContentType() {
            return contentType;
        }

        public int getContentId() {
            return contentId;
        }

        public String getReason() {
            return reason;
        }

        public String getSeverity() {
            return severity;
        }

        public String getReporterName() {
            return reporterName;
        }

        public Date getReportedAt() {
            return reportedAt;
        }

        public boolean isResolved() {
            return resolved;
        }
    }
}
=======
        public int getFlagId() { return flagId; }
        public String getContentType() { return contentType; }
        public int getContentId() { return contentId; }
        public String getReason() { return reason; }
        public String getSeverity() { return severity; }
        public String getReporterName() { return reporterName; }
        public Date getReportedAt() { return reportedAt; }
        public boolean isResolved() { return resolved; }
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
