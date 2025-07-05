package controller;

import dao.ExperienceDAO;
import dao.AccommodationDAO;
import dao.UserDAO;
import dao.CityDAO;
import model.Experience;
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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet tổng hợp để duyệt cả Experience và Accommodation
 */
@WebServlet(name = "AdminContentApproval", urlPatterns = {
    "/admin/content/approval",
    "/admin/content/approval/*",
    "/admin/content/experience/*/approve",
    "/admin/content/accommodation/*/approve", 
    "/admin/content/experience/*/reject",
    "/admin/content/accommodation/*/reject",
    "/admin/content/experience/*/revoke",
    "/admin/content/accommodation/*/revoke",
    "/admin/content/experience/*/delete",
    "/admin/content/accommodation/*/delete", 
    "/admin/content/approve-all",
    "/admin/content/export-pending"
})
public class AdminContentApprovalServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminContentApprovalServlet.class.getName());

    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private UserDAO userDAO;
    private CityDAO cityDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            userDAO = new UserDAO();
            cityDAO = new CityDAO();
            gson = new Gson();
            LOGGER.info("AdminContentApprovalServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminContentApprovalServlet", e);
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
                handleContentList(request, response);
            } else if (pathInfo.matches("/\\w+/\\d+")) {
                // Pattern: /experience/123 or /accommodation/456
                String[] parts = pathInfo.split("/");
                String contentType = parts[1];
                int contentId = Integer.parseInt(parts[2]);
                handleContentDetail(request, response, contentType, contentId);
            } else if (pathInfo.matches("/\\w+/\\d+/images")) {
                // Pattern: /experience/123/images
                String[] parts = pathInfo.split("/");
                String contentType = parts[1];
                int contentId = Integer.parseInt(parts[2]);
                handleGetContentImages(request, response, contentType, contentId);
            } else if ("/export-pending".equals(pathInfo)) {
                handleExportPending(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in content approval", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu.");
            request.getRequestDispatcher("/view/jsp/admin/content/content-approval.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid content ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }

 
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Debug info
        System.out.println("=== SERVLET DEBUG ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        
        // Set response headers trước khi làm gì khác
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        // Check authentication
        if (!isAdminAuthenticated(request)) {
            System.out.println("Unauthorized access");
            sendJsonResponse(response, false, "Không có quyền truy cập", null);
            return;
        }

        String servletPath = request.getServletPath();
        System.out.println("Processing servlet path: " + servletPath);

        try {
            if (servletPath.endsWith("/approve")) {
                // Extract content type and ID from path
                String[] pathParts = servletPath.split("/");
                String contentType = pathParts[pathParts.length - 2]; // experience hoặc accommodation
                String idStr = pathParts[pathParts.length - 3]; // ID number
                
                int contentId = Integer.parseInt(idStr);
                System.out.println("Approving " + contentType + " ID: " + contentId);
                
                handleApproveContent(request, response, contentType, contentId);
                
            } else if (servletPath.endsWith("/reject")) {
                String[] pathParts = servletPath.split("/");
                String contentType = pathParts[pathParts.length - 2];
                String idStr = pathParts[pathParts.length - 3];
                
                int contentId = Integer.parseInt(idStr);
                System.out.println("Rejecting " + contentType + " ID: " + contentId);
                
                handleRejectContent(request, response, contentType, contentId);
                
            } else if (servletPath.endsWith("/revoke")) {
                String[] pathParts = servletPath.split("/");
                String contentType = pathParts[pathParts.length - 2];
                String idStr = pathParts[pathParts.length - 3];
                
                int contentId = Integer.parseInt(idStr);
                System.out.println("Revoking " + contentType + " ID: " + contentId);
                
                handleRevokeContent(request, response, contentType, contentId);
                
            } else if (servletPath.endsWith("/delete")) {
                String[] pathParts = servletPath.split("/");
                String contentType = pathParts[pathParts.length - 2];
                String idStr = pathParts[pathParts.length - 3];
                
                int contentId = Integer.parseInt(idStr);
                System.out.println("Deleting " + contentType + " ID: " + contentId);
                
                handleDeleteContent(request, response, contentType, contentId);
                
            } else if (servletPath.equals("/admin/content/approve-all")) {
                System.out.println("Approving all");
                handleApproveAll(request, response);
                
            } else if (servletPath.equals("/admin/content/export-pending")) {
                System.out.println("Exporting pending");
                handleExportPending(request, response);
                
            } else {
                System.out.println("Unknown path: " + servletPath);
                sendJsonResponse(response, false, "Path not found: " + servletPath, null);
            }
            
        } catch (Exception e) {
            System.out.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage(), null);
        }
    }

    /**
     * Handle content list display (both experiences and accommodations)
     */
    private void handleContentList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Get filter parameters
        String filter = request.getParameter("filter"); // pending, approved, all
        String contentType = request.getParameter("contentType"); // experience, accommodation, all
        String accommodationType = request.getParameter("type"); // For accommodations: Homestay, Hotel, etc.
        
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

        // Prepare content lists
        List<ContentItem> allContent = new ArrayList<>();
        
        // Get experiences
        if (contentType == null || contentType.equals("all") || contentType.equals("experience")) {
            List<Experience> experiences = getFilteredExperiences(filter, page, pageSize);
            for (Experience exp : experiences) {
                // Enrich with host and city info
                if (exp.getHostId() > 0) {
                    User host = userDAO.getUserById(exp.getHostId());
                    exp.setHost(host);
                }
                if (exp.getCityId() > 0) {
                    City city = cityDAO.getCityById(exp.getCityId());
                    exp.setCity(city);
                }
                allContent.add(new ContentItem(exp));
            }
        }

        // Get accommodations
        if (contentType == null || contentType.equals("all") || contentType.equals("accommodation")) {
            List<Accommodation> accommodations = getFilteredAccommodations(filter, page, pageSize, accommodationType);
            for (Accommodation acc : accommodations) {
                // Enrich with host and city info
                if (acc.getHostId() > 0) {
                    User host = userDAO.getUserById(acc.getHostId());
                    acc.setHost(host);
                }
                if (acc.getCityId() > 0) {
                    City city = cityDAO.getCityById(acc.getCityId());
                    acc.setCity(city);
                }
                allContent.add(new ContentItem(acc));
            }
        }

        // Sort by creation date (newest first)
        allContent.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));

        // Apply pagination to combined results
        int totalContent = allContent.size();
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalContent);
        
        List<ContentItem> paginatedContent = totalContent > 0 ? 
            allContent.subList(startIndex, endIndex) : new ArrayList<>();

        int totalPages = (int) Math.ceil((double) totalContent / pageSize);

        // Get statistics
        Map<String, Integer> stats = getContentStatistics();

        // Set attributes
        request.setAttribute("contentItems", paginatedContent);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalContent", totalContent);
        request.setAttribute("stats", stats);
        request.setAttribute("currentFilter", filter != null ? filter : "pending");
        request.setAttribute("currentContentType", contentType != null ? contentType : "all");
        request.setAttribute("currentAccommodationType", accommodationType);

        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/admin/content/content-approval.jsp").forward(request, response);
    }

    /**
     * Handle content detail display
     */
    private void handleContentDetail(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId)
            throws SQLException, ServletException, IOException {

        if ("experience".equals(contentType)) {
            Experience experience = experienceDAO.getExperienceById(contentId);
            if (experience == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Experience không tồn tại");
                return;
            }

            // Get host and city info
            if (experience.getHostId() > 0) {
                User host = userDAO.getUserById(experience.getHostId());
                experience.setHost(host);
            }
            if (experience.getCityId() > 0) {
                City city = cityDAO.getCityById(experience.getCityId());
                experience.setCity(city);
            }

            request.setAttribute("content", new ContentItem(experience));
            request.setAttribute("contentType", "experience");
            
        } else if ("accommodation".equals(contentType)) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
            if (accommodation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Accommodation không tồn tại");
                return;
            }

            // Get host and city info
            if (accommodation.getHostId() > 0) {
                User host = userDAO.getUserById(accommodation.getHostId());
                accommodation.setHost(host);
            }
            if (accommodation.getCityId() > 0) {
                City city = cityDAO.getCityById(accommodation.getCityId());
                accommodation.setCity(city);
            }

            request.setAttribute("content", new ContentItem(accommodation));
            request.setAttribute("contentType", "accommodation");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Content type không hợp lệ");
            return;
        }

        request.getRequestDispatcher("/view/jsp/admin/content/content-detail.jsp").forward(request, response);
    }

    /**
     * Handle get content images (AJAX)
     */
    private void handleGetContentImages(HttpServletRequest request, HttpServletResponse response, 
                                      String contentType, int contentId)
            throws SQLException, IOException {

        String[] images = null;
        
        if ("experience".equals(contentType)) {
            Experience experience = experienceDAO.getExperienceById(contentId);
            if (experience != null) {
                images = experience.getImageList();
            }
        } else if ("accommodation".equals(contentType)) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
            if (accommodation != null) {
                images = accommodation.getImageList();
            }
        }

        if (images == null) {
            sendJsonResponse(response, false, "Content not found", null);
            return;
        }

        Map<String, Object> data = new HashMap<>();
        data.put("images", images);
        data.put("contentType", contentType);

        sendJsonResponse(response, true, "Success", data);
    }

    /**
     * Handle approve content - FIXED LOGIC
     */
private void handleApproveContent(HttpServletRequest request, HttpServletResponse response, 
                                String contentType, int contentId) throws IOException {
    
    LOGGER.info("=== APPROVE CONTENT START ===");
    LOGGER.info("Content Type: " + contentType + ", ID: " + contentId);
    
    try {
        boolean success = false;
        String message = "";

        if ("experience".equals(contentType)) {
            LOGGER.info("Processing experience approval...");
            
            Experience experience = experienceDAO.getExperienceById(contentId);
            if (experience == null) {
                LOGGER.warning("Experience not found: " + contentId);
                sendJsonResponse(response, false, "Experience không tồn tại.", null);
                return;
            }
            
            LOGGER.info("Experience found, isActive: " + experience.isActive());
            
            if (experience.isActive()) {
                LOGGER.info("Experience already approved");
                sendJsonResponse(response, false, "Experience đã được duyệt rồi.", null);
                return;
            }
            
            LOGGER.info("Calling experienceDAO.approveExperience...");
            success = experienceDAO.approveExperience(contentId);
            message = success ? "Experience đã được duyệt thành công!" : "Có lỗi xảy ra khi duyệt experience.";
            
        } else if ("accommodation".equals(contentType)) {
            LOGGER.info("Processing accommodation approval...");
            
            Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
            if (accommodation == null) {
                LOGGER.warning("Accommodation not found: " + contentId);
                sendJsonResponse(response, false, "Accommodation không tồn tại.", null);
                return;
            }
            
            LOGGER.info("Accommodation found, isActive: " + accommodation.isActive());
            
            if (accommodation.isActive()) {
                LOGGER.info("Accommodation already approved");
                sendJsonResponse(response, false, "Accommodation đã được duyệt rồi.", null);
                return;
            }
            
            LOGGER.info("Calling accommodationDAO.approveAccommodation...");
            success = accommodationDAO.approveAccommodation(contentId);
            message = success ? "Accommodation đã được duyệt thành công!" : "Có lỗi xảy ra khi duyệt accommodation.";
            
        } else {
            LOGGER.warning("Invalid content type: " + contentType);
            sendJsonResponse(response, false, "Content type không hợp lệ.", null);
            return;
        }

        LOGGER.info("Approval result: " + success + " - " + message);

        if (success) {
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " approved " + contentType + " ID: " + contentId);
        }

        LOGGER.info("Sending success response...");
        sendJsonResponse(response, success, message, null);
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Database error in handleApproveContent", e);
        sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Unexpected error in handleApproveContent", e);
        sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
    }
    
    LOGGER.info("=== APPROVE CONTENT END ===");
}
    /**
     * Handle reject content - FIXED LOGIC
     */
    private void handleRejectContent(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId)
            throws SQLException, IOException {

        String reason = request.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Lý do từ chối không được để trống.", null);
            return;
        }

        boolean allowResubmit = "on".equals(request.getParameter("allowResubmit"));
        boolean success = false;
        String message = "";

        if ("experience".equals(contentType)) {
            Experience experience = experienceDAO.getExperienceById(contentId);
            if (experience == null) {
                sendJsonResponse(response, false, "Experience không tồn tại.", null);
                return;
            }
            // Từ chối: đảm bảo isActive = 0 (về trạng thái pending/rejected)
            success = experienceDAO.rejectExperience(contentId, reason, allowResubmit);
            message = success ? "Experience đã bị từ chối!" : "Có lỗi xảy ra khi từ chối experience.";
            
        } else if ("accommodation".equals(contentType)) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
            if (accommodation == null) {
                sendJsonResponse(response, false, "Accommodation không tồn tại.", null);
                return;
            }
            // Từ chối: đảm bảo isActive = 0 (về trạng thái pending/rejected)
            success = accommodationDAO.rejectAccommodation(contentId, reason);
            message = success ? "Accommodation đã bị từ chối!" : "Có lỗi xảy ra khi từ chối accommodation.";
        } else {
            sendJsonResponse(response, false, "Content type không hợp lệ.", null);
            return;
        }

        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " rejected " + contentType + " ID: " + contentId + " - Reason: " + reason);
        }

        sendJsonResponse(response, success, message, null);
    }

    /**
     * Handle revoke approval - FIXED LOGIC
     */
    private void handleRevokeContent(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId)
            throws SQLException, IOException {

        String reason = request.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) {
            sendJsonResponse(response, false, "Lý do thu hồi không được để trống.", null);
            return;
        }

        boolean success = false;
        String message = "";

        if ("experience".equals(contentType)) {
            Experience experience = experienceDAO.getExperienceById(contentId);
            if (experience == null) {
                sendJsonResponse(response, false, "Experience không tồn tại.", null);
                return;
            }
            // Kiểm tra nếu chưa được duyệt thì không thể thu hồi
            if (!experience.isActive()) {
                sendJsonResponse(response, false, "Experience chưa được duyệt nên không thể thu hồi.", null);
                return;
            }
            // Thu hồi: chuyển từ isActive = 1 về isActive = 0
            success = experienceDAO.revokeApproval(contentId, reason);
            message = success ? "Đã thu hồi duyệt experience!" : "Có lỗi xảy ra khi thu hồi duyệt.";
            
        } else if ("accommodation".equals(contentType)) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
            if (accommodation == null) {
                sendJsonResponse(response, false, "Accommodation không tồn tại.", null);
                return;
            }
            // Kiểm tra nếu chưa được duyệt thì không thể thu hồi
            if (!accommodation.isActive()) {
                sendJsonResponse(response, false, "Accommodation chưa được duyệt nên không thể thu hồi.", null);
                return;
            }
            // Thu hồi: chuyển từ isActive = 1 về isActive = 0
            success = accommodationDAO.softDeleteAccommodation(contentId, reason);
            message = success ? "Đã thu hồi duyệt accommodation!" : "Có lỗi xảy ra khi thu hồi duyệt.";
        } else {
            sendJsonResponse(response, false, "Content type không hợp lệ.", null);
            return;
        }

        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " revoked " + contentType + " ID: " + contentId + " - Reason: " + reason);
        }

        sendJsonResponse(response, success, message, null);
    }

    /**
     * Handle delete content
     */
    private void handleDeleteContent(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId)
            throws SQLException, IOException {

        boolean success = false;
        String message = "";

        if ("experience".equals(contentType)) {
            success = experienceDAO.deleteExperience(contentId);
            message = success ? "Experience đã bị xóa." : "Có lỗi xảy ra khi xóa experience.";
            
        } else if ("accommodation".equals(contentType)) {
            success = accommodationDAO.deleteAccommodation(contentId);
            message = success ? "Accommodation đã bị xóa." : "Có lỗi xảy ra khi xóa accommodation.";
        } else {
            sendJsonResponse(response, false, "Content type không hợp lệ.", null);
            return;
        }

        if (success) {
            // Log activity
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " deleted " + contentType + " ID: " + contentId);
        }

        sendJsonResponse(response, success, message, null);
    }

    /**
     * Handle approve all pending content - FIXED LOGIC
     */
    private void handleApproveAll(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String contentTypeParam = request.getParameter("contentType");
        int approvedCount = 0;
        int totalCount = 0;

        // Duyệt tất cả experience đang pending (isActive = 0)
        if (contentTypeParam == null || contentTypeParam.equals("all") || contentTypeParam.equals("experience")) {
            List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 1000);
            totalCount += pendingExperiences.size();

            for (Experience exp : pendingExperiences) {
                try {
                    // Chỉ duyệt những cái chưa được duyệt (isActive = 0)
                    if (!exp.isActive() && experienceDAO.approveExperience(exp.getExperienceId())) {
                        approvedCount++;
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Failed to approve experience ID: " + exp.getExperienceId(), e);
                }
            }
        }

        // Duyệt tất cả accommodation đang pending (isActive = 0)
        if (contentTypeParam == null || contentTypeParam.equals("all") || contentTypeParam.equals("accommodation")) {
            List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 1000);
            totalCount += pendingAccommodations.size();

            for (Accommodation acc : pendingAccommodations) {
                try {
                    // Chỉ duyệt những cái chưa được duyệt (isActive = 0)
                    if (!acc.isActive() && accommodationDAO.approveAccommodation(acc.getAccommodationId())) {
                        approvedCount++;
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Failed to approve accommodation ID: " + acc.getAccommodationId(), e);
                }
            }
        }

        if (totalCount == 0) {
            sendJsonResponse(response, false, "Không có nội dung nào cần duyệt.", null);
            return;
        }

        // Log activity
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        String adminEmail = admin != null ? admin.getEmail() : "Unknown";
        LOGGER.info("Admin " + adminEmail + " bulk approved " + approvedCount + " content items");

        Map<String, Object> data = new HashMap<>();
        data.put("count", approvedCount);
        data.put("total", totalCount);

        sendJsonResponse(response, true, "Đã duyệt " + approvedCount + "/" + totalCount + " nội dung thành công!", data);
    }

    /**
     * Handle export pending content
     */
    private void handleExportPending(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        // Set response headers for CSV download
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"pending-content.csv\"");

        try (PrintWriter out = response.getWriter()) {
            // CSV Header
            out.println("Type,ID,Title/Name,Host,City,Created Date,Status");

            // Export pending experiences (isActive = 0)
            List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 10000);
            for (Experience exp : pendingExperiences) {
                out.printf("Experience,%d,\"%s\",\"%s\",\"%s\",%s,\"Pending\"%n",
                    exp.getExperienceId(),
                    exp.getTitle() != null ? exp.getTitle().replace("\"", "\"\"") : "",
                    exp.getHostName() != null ? exp.getHostName().replace("\"", "\"\"") : "",
                    exp.getCityName() != null ? exp.getCityName().replace("\"", "\"\"") : "",
                    exp.getCreatedAt() != null ? exp.getCreatedAt().toString() : ""
                );
            }

            // Export pending accommodations (isActive = 0)
            List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 10000);
            for (Accommodation acc : pendingAccommodations) {
                out.printf("Accommodation,%d,\"%s\",\"%s\",\"%s\",%s,\"Pending\"%n",
                    acc.getAccommodationId(),
                    acc.getName() != null ? acc.getName().replace("\"", "\"\"") : "",
                    acc.getHostName() != null ? acc.getHostName().replace("\"", "\"\"") : "",
                    acc.getCityName() != null ? acc.getCityName().replace("\"", "\"\"") : "",
                    acc.getCreatedAt() != null ? acc.getCreatedAt().toString() : ""
                );
            }
        }
    }

    // Helper methods
    
    /**
     * Get filtered experiences based on approval status - FIXED LOGIC
     */
    private List<Experience> getFilteredExperiences(String filter, int page, int pageSize) throws SQLException {
        switch (filter != null ? filter : "pending") {
            case "approved":
                // Lấy những experience đã được duyệt (isActive = 1)
                return experienceDAO.getApprovedExperiences(page, pageSize);
            case "all":
                // Lấy tất cả experience
                return experienceDAO.getAllExperiences(page, pageSize);
            default: // pending
                // Lấy những experience đang chờ duyệt (isActive = 0)
                return experienceDAO.getPendingExperiences(page, pageSize);
        }
    }

    /**
     * Get filtered accommodations based on approval status - FIXED LOGIC
     */
    private List<Accommodation> getFilteredAccommodations(String filter, int page, int pageSize, String type) throws SQLException {
        switch (filter != null ? filter : "pending") {
            case "approved":
                // Lấy những accommodation đã được duyệt (isActive = 1)
                return accommodationDAO.getApprovedAccommodations(page, pageSize, type);
            case "all":
                // Lấy tất cả accommodation
                return accommodationDAO.getAllAccommodations(page, pageSize, type);
            default: // pending
                // Lấy những accommodation đang chờ duyệt (isActive = 0)
                return accommodationDAO.getPendingAccommodations(page, pageSize, type);
        }
    }

    /**
     * Get content statistics - FIXED LOGIC
     */
    private Map<String, Integer> getContentStatistics() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        
        // Experience stats
        stats.put("experiencePending", experienceDAO.getPendingExperiencesCount()); // isActive = 0
        stats.put("experienceApproved", experienceDAO.getApprovedExperiencesCount()); // isActive = 1
        stats.put("experienceTotal", experienceDAO.getTotalExperiencesCount());
        
        // Accommodation stats
        stats.put("accommodationPending", accommodationDAO.getPendingAccommodationsCount()); // isActive = 0
        stats.put("accommodationApproved", accommodationDAO.getApprovedAccommodationsCount()); // isActive = 1
        stats.put("accommodationTotal", accommodationDAO.getTotalAccommodationsCount());
        
        // Combined stats
        stats.put("totalPending", stats.get("experiencePending") + stats.get("accommodationPending"));
        stats.put("totalApproved", stats.get("experienceApproved") + stats.get("accommodationApproved"));
        stats.put("totalAll", stats.get("experienceTotal") + stats.get("accommodationTotal"));
        
        return stats;
    }

    /**
     * Check if user is authenticated admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    /**
     * Send JSON response
     */
   private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) {
        try {
            System.out.println("=== SENDING RESPONSE ===");
            System.out.println("Success: " + success);
            System.out.println("Message: " + message);
            
            // Clear any existing response
            response.reset();
            
            // Set headers
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache");
            
            // Create JSON
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", success);
            jsonResponse.put("message", message != null ? message : "");
            if (data != null) {
                jsonResponse.put("data", data);
            }

            // Convert to JSON string
            String jsonString = gson.toJson(jsonResponse);
            System.out.println("JSON: " + jsonString);
            
            // Send response
            PrintWriter out = response.getWriter();
            out.print(jsonString);
            out.flush();
            
            System.out.println("Response sent successfully");
            
        } catch (Exception e) {
            System.out.println("Error in sendJsonResponse: " + e.getMessage());
            e.printStackTrace();
        }
    }

/**
     * Wrapper class to unify Experience and Accommodation for display
     */
    public static class ContentItem {
        private String type; // "experience" or "accommodation"
        private Object content; // Experience or Accommodation object
        private int id;
        private String title;
        private String description;
        private String hostName;
        private String cityName;
        private java.util.Date createdAt;
        private boolean isActive;
        private String images;
        private double price;
        private String location;
        private int hostId;
        private int cityId;

        public ContentItem(Experience experience) {
            this.type = "experience";
            this.content = experience;
            this.id = experience.getExperienceId();
            this.title = experience.getTitle();
            this.description = experience.getDescription();
            this.hostName = experience.getHostName();
            this.cityName = experience.getCityName();
            this.createdAt = experience.getCreatedAt();
            this.isActive = experience.isActive();
            this.images = experience.getImages();
            this.price = experience.getPrice();
            this.location = experience.getLocation();
            this.hostId = experience.getHostId();
            this.cityId = experience.getCityId();
        }

        public ContentItem(Accommodation accommodation) {
            this.type = "accommodation";
            this.content = accommodation;
            this.id = accommodation.getAccommodationId();
            this.title = accommodation.getName();
            this.description = accommodation.getDescription();
            this.hostName = accommodation.getHostName();
            this.cityName = accommodation.getCityName();
            this.createdAt = accommodation.getCreatedAt();
            this.isActive = accommodation.isActive();
            this.images = accommodation.getImages();
            this.price = accommodation.getPricePerNight();
            this.location = accommodation.getAddress();
            this.hostId = accommodation.getHostId();
            this.cityId = accommodation.getCityId();
        }

        // Getters
        public String getType() { return type; }
        public Object getContent() { return content; }
        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public String getHostName() { return hostName; }
        public String getCityName() { return cityName; }
        public java.util.Date getCreatedAt() { return createdAt; }
        public boolean isActive() { return isActive; }
        public boolean getActive() { return isActive; } // JSP compatibility
        public String getImages() { return images; }
        public double getPrice() { return price; }
        public String getLocation() { return location; }
        public int getHostId() { return hostId; }
        public int getCityId() { return cityId; }

        public Experience getExperience() {
            return "experience".equals(type) ? (Experience) content : null;
        }

        public Accommodation getAccommodation() {
            return "accommodation".equals(type) ? (Accommodation) content : null;
        }

        public String[] getImageList() {
            if (images != null && !images.trim().isEmpty()) {
                return images.split(",");
            }
            return new String[0];
        }
    }
}