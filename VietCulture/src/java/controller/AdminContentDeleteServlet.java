package controller;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet xử lý quản lý xóa nội dung cho admin Hỗ trợ xem, xóa mềm, khôi phục
 * và xóa vĩnh viễn nội dung
 */
@WebServlet(name = "AdminContentDeleteServlet", urlPatterns = {
    "/admin/content/delete",
    "/admin/content/delete/*",
    "/admin/content/restore",
    "/admin/content/approve",
    "/admin/content/permanent-delete",
    "/admin/content/bulk-action"
})
public class AdminContentDeleteServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminContentDeleteServlet.class.getName());
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            super.init();
            LOGGER.info("Initializing AdminContentDeleteServlet...");
            gson = new Gson();
            LOGGER.info("AdminContentDeleteServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminContentDeleteServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check
        if (!isAuthorized(request, response)) {
            return;
        }

        // Handle different paths
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            handleMainPage(request, response);
        } else {
            handleSpecificAction(request, response, pathInfo);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check
        if (!isAuthorized(request, response)) {
            return;
        }

        String servletPath = request.getServletPath();

        switch (servletPath) {
            case "/admin/content/delete":
                handleContentDelete(request, response);
                break;
            case "/admin/content/restore":
                handleContentRestore(request, response);
                break;
            case "/admin/content/approve":
                handleContentApprove(request, response);
                break;
            case "/admin/content/bulk-action":
                handleBulkAction(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Invalid action");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) {
            return;
        }

        if ("/admin/content/permanent-delete".equals(request.getServletPath())) {
            handlePermanentDelete(request, response);
        } else {
            sendJsonResponse(response, false, "Invalid delete action");
        }
    }

    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            if (isAjaxRequest(request)) {
                sendJsonResponse(response, false, "Unauthorized access");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return false;
        }

        Object userObj = session.getAttribute("user");
        if (!isAdmin(userObj)) {
            if (isAjaxRequest(request)) {
                sendJsonResponse(response, false, "Access denied");
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            }
            return false;
        }

        return true;
    }

    private void handleMainPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get filter parameters
            String tab = request.getParameter("tab");
            String type = request.getParameter("type");
            String pageParam = request.getParameter("page");

            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int pageSize = 10;

            // Get content list based on filters
            List<Content> contentList = getContentList(tab, type, currentPage, pageSize);
            int totalCount = getTotalContentCount(tab, type);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            // Calculate statistics
            Map<String, Long> stats = calculateStatistics();

            // Set attributes for JSP
            request.setAttribute("contentList", contentList);
            request.setAttribute("flaggedCount", stats.get("flagged"));
            request.setAttribute("pendingCount", stats.get("pending"));
            request.setAttribute("deletedCount", stats.get("deleted"));
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("currentTab", tab != null ? tab : "flagged");
            request.setAttribute("currentType", type);

            // Forward to JSP
            request.getRequestDispatcher("/view/jsp/admin/content/content-delete.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling main page", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading content management page");
        }
    }

    private void handleContentDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Map<String, Object> requestData = parseJsonRequest(request);

            if (requestData == null || requestData.isEmpty()) {
                sendJsonResponse(response, false, "Invalid request data");
                return;
            }

            String contentType = (String) requestData.get("type");
            Double idDouble = (Double) requestData.get("id");
            String reason = (String) requestData.get("reason");
            Boolean sendNotification = (Boolean) requestData.get("sendNotification");

            if (contentType == null || idDouble == null || reason == null || reason.trim().isEmpty()) {
                sendJsonResponse(response, false, "Missing required parameters");
                return;
            }

            Integer contentId = idDouble.intValue();

            // TODO: Implement actual delete logic with database
            // For now, just simulate success
            boolean success = performSoftDelete(contentId, contentType, reason, sendNotification);

            if (success) {
                LOGGER.info(String.format("Content deleted: type=%s, id=%d, reason=%s",
                        contentType, contentId, reason));
                sendJsonResponse(response, true, "Content deleted successfully");
            } else {
                sendJsonResponse(response, false, "Failed to delete content");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting content", e);
            sendJsonResponse(response, false, "Server error occurred");
        }
    }

    private void handleContentRestore(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Map<String, Object> requestData = parseJsonRequest(request);

            if (requestData == null || requestData.isEmpty()) {
                sendJsonResponse(response, false, "Invalid request data");
                return;
            }

            String contentType = (String) requestData.get("type");
            Double idDouble = (Double) requestData.get("id");

            if (contentType == null || idDouble == null) {
                sendJsonResponse(response, false, "Missing required parameters");
                return;
            }

            Integer contentId = idDouble.intValue();

            // TODO: Implement actual restore logic
            boolean success = performRestore(contentId, contentType);

            if (success) {
                LOGGER.info(String.format("Content restored: type=%s, id=%d", contentType, contentId));
                sendJsonResponse(response, true, "Content restored successfully");
            } else {
                sendJsonResponse(response, false, "Failed to restore content");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error restoring content", e);
            sendJsonResponse(response, false, "Server error occurred");
        }
    }

    private void handleContentApprove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Map<String, Object> requestData = parseJsonRequest(request);

            if (requestData == null || requestData.isEmpty()) {
                sendJsonResponse(response, false, "Invalid request data");
                return;
            }

            String contentType = (String) requestData.get("type");
            Double idDouble = (Double) requestData.get("id");

            if (contentType == null || idDouble == null) {
                sendJsonResponse(response, false, "Missing required parameters");
                return;
            }

            Integer contentId = idDouble.intValue();

            // TODO: Implement actual approve logic
            boolean success = performApprove(contentId, contentType);

            if (success) {
                LOGGER.info(String.format("Content approved: type=%s, id=%d", contentType, contentId));
                sendJsonResponse(response, true, "Content approved successfully");
            } else {
                sendJsonResponse(response, false, "Failed to approve content");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error approving content", e);
            sendJsonResponse(response, false, "Server error occurred");
        }
    }

    private void handlePermanentDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Map<String, Object> requestData = parseJsonRequest(request);

            if (requestData == null || requestData.isEmpty()) {
                sendJsonResponse(response, false, "Invalid request data");
                return;
            }

            String contentType = (String) requestData.get("type");
            Double idDouble = (Double) requestData.get("id");

            if (contentType == null || idDouble == null) {
                sendJsonResponse(response, false, "Missing required parameters");
                return;
            }

            Integer contentId = idDouble.intValue();

            // TODO: Implement actual permanent delete logic
            boolean success = performPermanentDelete(contentId, contentType);

            if (success) {
                LOGGER.info(String.format("Content permanently deleted: type=%s, id=%d",
                        contentType, contentId));
                sendJsonResponse(response, true, "Content permanently deleted");
            } else {
                sendJsonResponse(response, false, "Failed to permanently delete content");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error permanently deleting content", e);
            sendJsonResponse(response, false, "Server error occurred");
        }
    }

    private void handleBulkAction(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Map<String, Object> requestData = parseJsonRequest(request);

            if (requestData == null || requestData.isEmpty()) {
                sendJsonResponse(response, false, "Invalid request data");
                return;
            }

            String action = (String) requestData.get("action");
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> items = (List<Map<String, Object>>) requestData.get("items");
            String reason = (String) requestData.get("reason");

            if (action == null || items == null || items.isEmpty()) {
                sendJsonResponse(response, false, "Missing required parameters");
                return;
            }

            int processedCount = 0;

            for (Map<String, Object> item : items) {
                String contentType = (String) item.get("type");
                Double idDouble = (Double) item.get("id");

                if (contentType != null && idDouble != null) {
                    Integer contentId = idDouble.intValue();
                    boolean success = false;

                    switch (action) {
                        case "delete":
                            success = performSoftDelete(contentId, contentType, reason, false);
                            break;
                        case "restore":
                            success = performRestore(contentId, contentType);
                            break;
                        case "approve":
                            success = performApprove(contentId, contentType);
                            break;
                        default:
                            LOGGER.warning("Unknown bulk action: " + action);
                    }

                    if (success) {
                        processedCount++;
                    }
                }
            }

            LOGGER.info(String.format("Bulk action completed: action=%s, processed=%d/%d",
                    action, processedCount, items.size()));

            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("count", processedCount);
            result.addProperty("message", String.format("Processed %d out of %d items",
                    processedCount, items.size()));

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(result));
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing bulk action", e);
            sendJsonResponse(response, false, "Server error occurred");
        }
    }

    private void handleSpecificAction(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        response.setContentType("application/json");
        sendJsonResponse(response, false, "Action not implemented yet: " + pathInfo);
    }

    // Business logic methods - TODO: Replace with actual database operations
    private boolean performSoftDelete(int contentId, String contentType, String reason, Boolean sendNotification) {
        // TODO: Implement actual soft delete logic
        // This should update the database to mark content as deleted
        LOGGER.info(String.format("Performing soft delete: id=%d, type=%s, reason=%s, notify=%s",
                contentId, contentType, reason, sendNotification));
        return true; // Mock success
    }

    private boolean performRestore(int contentId, String contentType) {
        // TODO: Implement actual restore logic
        LOGGER.info(String.format("Performing restore: id=%d, type=%s", contentId, contentType));
        return true; // Mock success
    }

    private boolean performApprove(int contentId, String contentType) {
        // TODO: Implement actual approve logic
        LOGGER.info(String.format("Performing approve: id=%d, type=%s", contentId, contentType));
        return true; // Mock success
    }

    private boolean performPermanentDelete(int contentId, String contentType) {
        // TODO: Implement actual permanent delete logic
        LOGGER.info(String.format("Performing permanent delete: id=%d, type=%s", contentId, contentType));
        return true; // Mock success
    }

    // Helper methods
    private boolean isAdmin(Object userObj) {
        try {
            if (userObj instanceof User) {
                User user = (User) userObj;
                return "ADMIN".equals(user.getRole());
            }
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error checking admin role", e);
            return false;
        }
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(requestedWith);
    }

    private Map<String, Object> parseJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonString = sb.toString();
        if (jsonString.trim().isEmpty()) {
            return new HashMap<>();
        }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> result = gson.fromJson(jsonString, Map.class);
            return result != null ? result : new HashMap<>();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error parsing JSON request: " + jsonString, e);
            return new HashMap<>();
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        JsonObject result = new JsonObject();
        result.addProperty("success", success);
        result.addProperty("message", message);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
        }
    }

    private List<Content> getContentList(String tab, String type, int page, int pageSize) {
        // TODO: Replace with actual database query
        List<Content> contentList = new ArrayList<>();

        // Create mock data based on tab filter
        if ("flagged".equals(tab) || tab == null) {
            contentList.add(new Content(1, "experience", "Trải nghiệm Huế",
                    "Khám phá văn hóa Huế tuyệt vời", "/images/hue.jpg",
                    "Nguyen Van A", new Date(), 2, false, null, false));
            contentList.add(new Content(4, "review", "Review nhà hàng ngon",
                    "Đánh giá về nhà hàng địa phương", "/images/restaurant.jpg",
                    "Le Van C", new Date(), 1, false, null, true));
        } else if ("pending".equals(tab)) {
            contentList.add(new Content(3, "accommodation", "Khách sạn mới",
                    "Khách sạn 4 sao tại Đà Nẵng", "/images/danang.jpg",
                    "Pham Thi D", new Date(), 0, false, null, false));
        } else if ("deleted".equals(tab)) {
            contentList.add(new Content(2, "accommodation", "Khách sạn Sài Gòn",
                    "Khách sạn 5 sao tại trung tâm", "/images/saigon.jpg",
                    "Tran Thi B", new Date(), 0, true, "Vi phạm chính sách", false));
        }

        // Filter by type if specified
        if (type != null && !type.isEmpty()) {
            contentList.removeIf(content -> !type.equals(content.getType()));
        }

        return contentList;
    }

    private int getTotalContentCount(String tab, String type) {
        // TODO: Replace with actual database query
        return getContentList(tab, type, 1, Integer.MAX_VALUE).size();
    }

    private Map<String, Long> calculateStatistics() {
        // TODO: Replace with actual database queries
        Map<String, Long> stats = new HashMap<>();
        stats.put("flagged", 2L);
        stats.put("pending", 1L);
        stats.put("deleted", 1L);
        return stats;
    }

    // Inner Content class for mock data
    public static class Content {

        private int id;
        private String type;
        private String title;
        private String description;
        private String thumbnail;
        private String authorName;
        private Date createdAt;
        private int reportCount;
        private boolean isDeleted;
        private String deleteReason;
        private boolean approved;

        public Content(int id, String type, String title, String description, String thumbnail,
                String authorName, Date createdAt, int reportCount, boolean isDeleted,
                String deleteReason, boolean approved) {
            this.id = id;
            this.type = type;
            this.title = title;
            this.description = description;
            this.thumbnail = thumbnail;
            this.authorName = authorName;
            this.createdAt = createdAt;
            this.reportCount = reportCount;
            this.isDeleted = isDeleted;
            this.deleteReason = deleteReason;
            this.approved = approved;
        }

        // Getters
        public int getId() {
            return id;
        }

        public String getType() {
            return type;
        }

        public String getTitle() {
            return title;
        }

        public String getDescription() {
            return description;
        }

        public String getThumbnail() {
            return thumbnail;
        }

        public String getAuthorName() {
            return authorName;
        }

        public Date getCreatedAt() {
            return createdAt;
        }

        public int getReportCount() {
            return reportCount;
        }

        public boolean isDeleted() {
            return isDeleted;
        }

        public String getDeleteReason() {
            return deleteReason;
        }

        public boolean isApproved() {
            return approved;
        }

        // Setters
        public void setId(int id) {
            this.id = id;
        }

        public void setType(String type) {
            this.type = type;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public void setThumbnail(String thumbnail) {
            this.thumbnail = thumbnail;
        }

        public void setAuthorName(String authorName) {
            this.authorName = authorName;
        }

        public void setCreatedAt(Date createdAt) {
            this.createdAt = createdAt;
        }

        public void setReportCount(int reportCount) {
            this.reportCount = reportCount;
        }

        public void setDeleted(boolean deleted) {
            isDeleted = deleted;
        }

        public void setDeleteReason(String deleteReason) {
            this.deleteReason = deleteReason;
        }

        public void setApproved(boolean approved) {
            this.approved = approved;
        }
    }
}
