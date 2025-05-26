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
    "/admin/content/delete",
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
                case "/admin/content/delete":
                    handleDeleteContent(request, response);
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

    private void handleModerationOverview(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Map<String, Object> stats = getModerationStatistics();
        stats.forEach(request::setAttribute);

        List<ModerationItem> moderationQueue = getModerationQueue();
        request.setAttribute("moderationQueue", moderationQueue);

        String priority = request.getParameter("priority");
        String type = request.getParameter("type");
        request.setAttribute("currentPriority", priority);
        request.setAttribute("currentType", type);

        request.getRequestDispatcher("/view/jsp/admin/content/moderation-overview.jsp").forward(request, response);
    }

    private void handleModerateContent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType");
        String contentIdStr = request.getParameter("contentId");

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
                case "delete":
                    success = deleteContent(contentType, contentId);
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

    private void handleDeleteContent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String contentType = request.getParameter("type");
        String contentIdStr = request.getParameter("id");

        try {
            int contentId = Integer.parseInt(contentIdStr);
            boolean success = deleteContent(contentType, contentId);

            if (success) {
                sendJsonResponse(response, true, "Đã xóa nội dung!", null);
            } else {
                sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa nội dung", null);
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }

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

    private Map<String, Object> getModerationStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        int pendingExperiences = experienceDAO.getPendingExperiencesCount();
        int pendingAccommodations = accommodationDAO.getPendingAccommodationsCount();
        int pendingModerationCount = pendingExperiences + pendingAccommodations;
        stats.put("pendingModerationCount", pendingModerationCount);
        stats.put("pendingExperiences", pendingExperiences);
        stats.put("pendingAccommodations", pendingAccommodations);
        return stats;
    }

    private List<ModerationItem> getModerationQueue() throws SQLException {
        List<ModerationItem> queue = new ArrayList<>();
        List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 10);
        List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 10);

        for (Experience exp : pendingExperiences) {
            User host = userDAO.getUserById(exp.getHostId());
            queue.add(new ModerationItem(
                exp.getExperienceId(),
                "experience",
                exp.getTitle(),
                exp.getDescription().length() > 50 ? exp.getDescription().substring(0, 50) + "..." : exp.getDescription(),
                host != null ? host.getFullName() : "Unknown",
                exp.getCreatedAt(),
                "MEDIUM",
                new ArrayList<>(),
                false,
                0
            ));
        }

        for (Accommodation acc : pendingAccommodations) {
            User host = userDAO.getUserById(acc.getHostId());
            queue.add(new ModerationItem(
                acc.getAccommodationId(),
                "accommodation",
                acc.getName(),
                acc.getDescription().length() > 50 ? acc.getDescription().substring(0, 50) + "..." : acc.getDescription(),
                host != null ? host.getFullName() : "Unknown",
                acc.getCreatedAt(),
                "MEDIUM",
                new ArrayList<>(),
                false,
                0
            ));
        }

        return queue;
    }

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

    private boolean deleteContent(String contentType, int contentId) throws SQLException {
        switch (contentType.toLowerCase()) {
            case "experience":
                return experienceDAO.deleteExperience(contentId);
            case "accommodation":
                return accommodationDAO.deleteAccommodation(contentId);
            default:
                return false;
        }
    }

    private boolean flagContent(String contentType, int contentId) throws SQLException {
        // Placeholder - implement with a FlaggedContent table
        return true;
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole()); // Updated to role
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
        }

        // Getters
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
    }
}