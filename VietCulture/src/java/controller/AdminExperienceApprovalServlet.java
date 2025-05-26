package controller;

import dao.ExperienceDAO;
import dao.UserDAO;
import dao.CityDAO;
import model.Experience;
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

@WebServlet(name = "AdminExperienceApproval", urlPatterns = {
    "/admin/experiences/approval",
    "/admin/experiences/approval/*",
    "/admin/experiences/*/approve",
    "/admin/experiences/*/reject",
    "/admin/experiences/*/revoke",
    "/admin/experiences/approve-all",
    "/admin/experiences/*/images"
})
public class AdminExperienceApprovalServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminExperienceApprovalServlet.class.getName());
    
    private ExperienceDAO experienceDAO;
    private UserDAO userDAO;
    private CityDAO cityDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
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
                // Show experiences approval list
                handleExperiencesList(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Show experience detail
                int experienceId = Integer.parseInt(pathInfo.substring(1));
                handleExperienceDetail(request, response, experienceId);
            } else if (pathInfo.matches("/\\d+/images")) {
                // Get experience images (AJAX)
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleGetExperienceImages(request, response, experienceId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in experience approval", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu.");
            request.getRequestDispatcher("/view/jsp/admin/content/experience-approval.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid experience ID format", e);
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
                // Approve experience
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleApproveExperience(request, response, experienceId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/reject")) {
                // Reject experience
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleRejectExperience(request, response, experienceId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/revoke")) {
                // Revoke approval
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleRevokeApproval(request, response, experienceId);
            } else if ("/approve-all".equals(pathInfo)) {
                // Approve all pending experiences
                handleApproveAll(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in experience approval POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid experience ID format in POST", e);
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }
    
    /**
     * Handle experiences list display
     */
    private void handleExperiencesList(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        // Get filter parameters
        String filter = request.getParameter("filter"); // pending, approved, rejected, all
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
        
        // Get experiences based on filter
        List<Experience> experiences;
        int totalExperiences;
        
        switch (filter != null ? filter : "pending") {
            case "approved":
                experiences = experienceDAO.getApprovedExperiences(page, pageSize);
                totalExperiences = experienceDAO.getApprovedExperiencesCount();
                break;
            case "rejected":
                experiences = experienceDAO.getRejectedExperiences(page, pageSize);
                totalExperiences = experienceDAO.getRejectedExperiencesCount();
                break;
            case "all":
                experiences = experienceDAO.getAllExperiences(page, pageSize);
                totalExperiences = experienceDAO.getTotalExperiencesCount();
                break;
            default: // pending
                experiences = experienceDAO.getPendingExperiences(page, pageSize);
                totalExperiences = experienceDAO.getPendingExperiencesCount();
                break;
        }
        
        // Enrich experiences with host and city info
        for (Experience exp : experiences) {
            if (exp.getHostId() > 0) {
                User host = userDAO.getUserById(exp.getHostId());
                exp.setHost(host);
            }
            
            if (exp.getCityId() > 0) {
                City city = cityDAO.getCityById(exp.getCityId());
                exp.setCity(city);
            }
        }
        
        int totalPages = (int) Math.ceil((double) totalExperiences / pageSize);
        
        // Get statistics
        int pendingCount = experienceDAO.getPendingExperiencesCount();
        int approvedCount = experienceDAO.getApprovedExperiencesCount();
        int rejectedCount = experienceDAO.getRejectedExperiencesCount();
        int totalCount = experienceDAO.getTotalExperiencesCount();
        
        // Set attributes
        request.setAttribute("experiences", experiences);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalExperiences", totalExperiences);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentFilter", filter != null ? filter : "pending");
        
        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/content/experience-approval.jsp").forward(request, response);
    }
    
    /**
     * Handle experience detail display
     */
    private void handleExperienceDetail(HttpServletRequest request, HttpServletResponse response, int experienceId) 
            throws SQLException, ServletException, IOException {
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Experience không tồn tại");
            return;
        }
        
        // Get host info
        if (experience.getHostId() > 0) {
            User host = userDAO.getUserById(experience.getHostId());
            experience.setHost(host);
        }
        
        // Get city info
        if (experience.getCityId() > 0) {
            City city = cityDAO.getCityById(experience.getCityId());
            experience.setCity(city);
        }
        
        request.setAttribute("experience", experience);
        request.getRequestDispatcher("/view/jsp/admin/content/experience-detail.jsp").forward(request, response);
    }
    
    /**
     * Handle get experience images (AJAX)
     */
    private void handleGetExperienceImages(HttpServletRequest request, HttpServletResponse response, int experienceId) 
            throws SQLException, IOException {
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience not found", null);
            return;
        }
        
        String[] images = experience.getImageList();
        
        Map<String, Object> data = new HashMap<>();
        data.put("images", images != null ? images : new String[0]);
        
        sendJsonResponse(response, true, "Success", data);
    }
    
    /**
     * Handle approve experience
     */
    private void handleApproveExperience(HttpServletRequest request, HttpServletResponse response, int experienceId) 
            throws SQLException, IOException {
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience không tồn tại.", null);
            return;
        }
        
        // Check if already approved
        if (experience.isActive()) {
            sendJsonResponse(response, false, "Experience đã được duyệt rồi.", null);
            return;
        }
        
        boolean success = experienceDAO.approveExperience(experienceId);
        
        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " approved experience ID: " + experienceId);
            
            // TODO: Send notification to host
            // notificationService.sendApprovalNotification(experience.getHostId(), experienceId);
            
            sendJsonResponse(response, true, "Experience đã được duyệt thành công!", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi duyệt experience.", null);
        }
    }
    
    /**
     * Handle reject experience
     */
    private void handleRejectExperience(HttpServletRequest request, HttpServletResponse response, int experienceId) 
            throws SQLException, IOException {
        
        String reason = request.getParameter("reason");
        String allowResubmitStr = request.getParameter("allowResubmit");
        boolean allowResubmit = "on".equals(allowResubmitStr);
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do từ chối.", null);
            return;
        }
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience không tồn tại.", null);
            return;
        }
        
        boolean success = experienceDAO.rejectExperience(experienceId, reason.trim(), allowResubmit);
        
        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " rejected experience ID: " + experienceId + ", reason: " + reason);
            
            // TODO: Send notification to host
            // notificationService.sendRejectionNotification(experience.getHostId(), experienceId, reason, allowResubmit);
            
            sendJsonResponse(response, true, "Experience đã bị từ chối.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi từ chối experience.", null);
        }
    }
    
    /**
     * Handle revoke approval
     */
    private void handleRevokeApproval(HttpServletRequest request, HttpServletResponse response, int experienceId) 
            throws SQLException, IOException {
        
        String reason = request.getParameter("reason");
        
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do thu hồi.", null);
            return;
        }
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience không tồn tại.", null);
            return;
        }
        
        if (!experience.isActive()) {
            sendJsonResponse(response, false, "Experience chưa được duyệt.", null);
            return;
        }
        
        boolean success = experienceDAO.revokeApproval(experienceId, reason.trim());
        
        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " revoked approval for experience ID: " + experienceId + ", reason: " + reason);
            
            // TODO: Send notification to host
            // notificationService.sendRevocationNotification(experience.getHostId(), experienceId, reason);
            
            sendJsonResponse(response, true, "Đã thu hồi duyệt experience.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi thu hồi duyệt.", null);
        }
    }
    
    /**
     * Handle approve all pending experiences
     */
    private void handleApproveAll(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 1000); // Get up to 1000 pending
        
        if (pendingExperiences.isEmpty()) {
            sendJsonResponse(response, false, "Không có experience nào cần duyệt.", null);
            return;
        }
        
        int approvedCount = 0;
        
        for (Experience exp : pendingExperiences) {
            try {
                if (experienceDAO.approveExperience(exp.getExperienceId())) {
                    approvedCount++;
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to approve experience ID: " + exp.getExperienceId(), e);
            }
        }
        
        // Log activity
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        String adminEmail = admin != null ? admin.getEmail() : "Unknown";
        LOGGER.info("Admin " + adminEmail + " bulk approved " + approvedCount + " experiences");
        
        Map<String, Object> data = new HashMap<>();
        data.put("count", approvedCount);
        data.put("total", pendingExperiences.size());
        
        sendJsonResponse(response, true, "Đã duyệt " + approvedCount + " experiences thành công!", data);
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