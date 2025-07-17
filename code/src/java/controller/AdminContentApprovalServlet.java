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
 * Complete Servlet quản lý duyệt nội dung với logic adminApprovalStatus
 * adminApprovalStatus: PENDING, APPROVED, REJECTED
 * isActive: 1 (host hiện), 0 (host ẩn)  
 * Hiển thị công khai: adminApprovalStatus = 'APPROVED' AND isActive = 1
 */
@WebServlet(name = "AdminContentApproval", urlPatterns = {
    "/admin/content/approval",
    "/admin/content/approval/*",
    "/admin/content/detail"
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
        LOGGER.info("GET request - PathInfo: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleContentList(request, response);
            } else if (pathInfo.equals("/detail")) {
                // Handle: /admin/content/detail?type=experience&id=123
                handleDetailWithParams(request, response);
            } else if (pathInfo.equals("/export-pending")) {
                handleExportPending(request, response);
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
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in doGet", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu.");
            request.getRequestDispatcher("/view/jsp/admin/content/content-approval.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid content ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }

    /**
     * Handle detail with URL parameters: /admin/content/detail?type=experience&id=123
     */
    private void handleDetailWithParams(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String contentType = request.getParameter("type");
        String idParam = request.getParameter("id");
        
        LOGGER.info("Detail with params - Type: " + contentType + ", ID: " + idParam);
        
        if (contentType == null || idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số type hoặc id");
            return;
        }
        
        try {
            int contentId = Integer.parseInt(idParam);
            handleContentDetail(request, response, contentType, contentId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("=== ADMIN CONTENT APPROVAL POST REQUEST ===");
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Path Info: " + request.getPathInfo());
        
        // Check authentication FIRST
        if (!isAdminAuthenticated(request)) {
            LOGGER.warning("Unauthorized access attempt");
            sendJsonResponse(response, false, "Không có quyền truy cập", null);
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("Processing POST path info: " + pathInfo);

        try {
            if (pathInfo == null) {
                sendJsonResponse(response, false, "Path info is null", null);
                return;
            }

            // Route based on path patterns
            if (pathInfo.equals("/approve-all")) {
                LOGGER.info("Handling approve-all request");
                handleApproveAll(request, response);
                
            } else if (pathInfo.equals("/export-pending")) {
                LOGGER.info("Handling export-pending request");
                handleExportPending(request, response);
                
            } else if (pathInfo.matches("/\\w+/\\d+/approve")) {
                // Pattern: /experience/123/approve
                String[] parts = pathInfo.split("/");
                if (parts.length >= 4) {
                    String contentType = parts[1]; // experience or accommodation
                    int contentId = Integer.parseInt(parts[2]); // ID
                    
                    LOGGER.info("Approving " + contentType + " ID: " + contentId);
                    handleApproveContent(request, response, contentType, contentId);
                } else {
                    sendJsonResponse(response, false, "Invalid approve URL format", null);
                }
                
            } else if (pathInfo.matches("/\\w+/\\d+/reject")) {
                // Pattern: /experience/123/reject
                String[] parts = pathInfo.split("/");
                if (parts.length >= 4) {
                    String contentType = parts[1];
                    int contentId = Integer.parseInt(parts[2]);
                    
                    LOGGER.info("Rejecting " + contentType + " ID: " + contentId);
                    handleRejectContent(request, response, contentType, contentId);
                } else {
                    sendJsonResponse(response, false, "Invalid reject URL format", null);
                }
                
            } else if (pathInfo.matches("/\\w+/\\d+/revoke")) {
                // Pattern: /experience/123/revoke
                String[] parts = pathInfo.split("/");
                if (parts.length >= 4) {
                    String contentType = parts[1];
                    int contentId = Integer.parseInt(parts[2]);
                    
                    LOGGER.info("Revoking " + contentType + " ID: " + contentId);
                    handleRevokeContent(request, response, contentType, contentId);
                } else {
                    sendJsonResponse(response, false, "Invalid revoke URL format", null);
                }
                
            } else if (pathInfo.matches("/\\w+/\\d+/delete")) {
                // Pattern: /experience/123/delete
                String[] parts = pathInfo.split("/");
                if (parts.length >= 4) {
                    String contentType = parts[1];
                    int contentId = Integer.parseInt(parts[2]);
                    
                    LOGGER.info("Deleting " + contentType + " ID: " + contentId);
                    handleDeleteContent(request, response, contentType, contentId);
                } else {
                    sendJsonResponse(response, false, "Invalid delete URL format", null);
                }
                
            } else {
                LOGGER.warning("Unknown path: " + pathInfo);
                sendJsonResponse(response, false, "Path not found: " + pathInfo, null);
            }
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid content ID format", e);
            sendJsonResponse(response, false, "ID không hợp lệ: " + e.getMessage(), null);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doPost", e);
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }

    /**
     * Handle approve content - DUYỆT NỘI DUNG
     */
    private void handleApproveContent(HttpServletRequest request, HttpServletResponse response, 
                                    String contentType, int contentId) throws IOException {
        
        LOGGER.info("=== APPROVE CONTENT START ===");
        LOGGER.info("Content Type: " + contentType + ", ID: " + contentId);
        
        try {
            // Validate inputs
            if (!isValidContentType(contentType)) {
                sendJsonResponse(response, false, "Content type không hợp lệ: " + contentType, null);
                return;
            }
            
            if (contentId <= 0) {
                sendJsonResponse(response, false, "ID không hợp lệ: " + contentId, null);
                return;
            }
            
            // Get admin info
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            if (admin == null) {
                sendJsonResponse(response, false, "Phiên đăng nhập hết hạn", null);
                return;
            }
            
            int adminUserId = admin.getUserId();
            boolean success = false;
            String message = "";

            if ("experience".equals(contentType)) {
                Experience experience = experienceDAO.getExperienceById(contentId);
                if (experience == null) {
                    sendJsonResponse(response, false, "Experience không tồn tại", null);
                    return;
                }
                
                if ("APPROVED".equals(experience.getAdminApprovalStatus())) {
                    sendJsonResponse(response, false, "Experience đã được duyệt rồi", null);
                    return;
                }
                
                success = experienceDAO.approveExperience(contentId, adminUserId);
                message = success ? "Experience đã được duyệt thành công!" : "Có lỗi xảy ra khi duyệt experience";
                
            } else if ("accommodation".equals(contentType)) {
                Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
                if (accommodation == null) {
                    sendJsonResponse(response, false, "Accommodation không tồn tại", null);
                    return;
                }
                
                if ("APPROVED".equals(accommodation.getAdminApprovalStatus())) {
                    sendJsonResponse(response, false, "Accommodation đã được duyệt rồi", null);
                    return;
                }
                
                success = accommodationDAO.approveAccommodation(contentId, adminUserId);
                message = success ? "Accommodation đã được duyệt thành công!" : "Có lỗi xảy ra khi duyệt accommodation";
            }

            LOGGER.info("Approval result: " + success + " - " + message);

            if (success) {
                String adminEmail = admin.getEmail();
                LOGGER.info("Admin " + adminEmail + " approved " + contentType + " ID: " + contentId);
            }

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
     * Handle reject content - TỪ CHỐI NỘI DUNG
     */
    private void handleRejectContent(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId) throws IOException {

        try {
            LOGGER.info("=== HANDLING REJECT CONTENT ===");
            LOGGER.info("ContentType: " + contentType + ", ContentId: " + contentId);

            // Lấy lý do từ chối từ request
            String reason = request.getParameter("reason");
            LOGGER.info("Raw reason parameter: " + reason);

            // Kiểm tra reason có trống không
            if (reason == null || reason.trim().isEmpty()) {
                LOGGER.warning("Reject reason is empty");
                sendJsonResponse(response, false, "Lý do từ chối không được để trống", null);
                return;
            }

            // Get admin info
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            if (admin == null) {
                LOGGER.warning("Admin user not found in session");
                sendJsonResponse(response, false, "Phiên đăng nhập hết hạn", null);
                return;
            }
            int adminUserId = admin.getUserId();
            LOGGER.info("Admin UserId: " + adminUserId);

            boolean success = false;
            String message = "";

            // Xử lý reject cho experience
            if ("experience".equals(contentType)) {
                Experience experience = experienceDAO.getExperienceById(contentId);
                if (experience == null) {
                    LOGGER.warning("Experience not found with ID: " + contentId);
                    sendJsonResponse(response, false, "Experience không tồn tại", null);
                    return;
                }
                
                LOGGER.info("Processing reject for Experience ID: " + contentId + " with reason: " + reason);
                success = experienceDAO.rejectExperience(contentId, adminUserId, reason);
                message = success ? "Experience đã bị từ chối!" : "Có lỗi xảy ra khi từ chối experience";
                LOGGER.info("Experience reject result: " + success);
                
            } else if ("accommodation".equals(contentType)) {
                Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
                if (accommodation == null) {
                    LOGGER.warning("Accommodation not found with ID: " + contentId);
                    sendJsonResponse(response, false, "Accommodation không tồn tại", null);
                    return;
                }
                
                LOGGER.info("Processing reject for Accommodation ID: " + contentId + " with reason: " + reason);
                success = accommodationDAO.rejectAccommodation(contentId, adminUserId, reason);
                message = success ? "Accommodation đã bị từ chối!" : "Có lỗi xảy ra khi từ chối accommodation";
                LOGGER.info("Accommodation reject result: " + success);
            } else {
                LOGGER.warning("Invalid content type: " + contentType);
                sendJsonResponse(response, false, "Content type không hợp lệ", null);
                return;
            }

            if (success) {
                String adminEmail = admin.getEmail();
                LOGGER.info("Admin " + adminEmail + " rejected " + contentType + " ID: " + contentId + " - Reason: " + reason);
            }

            sendJsonResponse(response, success, message, null);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in handleRejectContent", e);
            sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in handleRejectContent", e);
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }

    /**
     * Handle revoke approval - THU HỒI DUYỆT
     */
    private void handleRevokeContent(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId) throws IOException {

        try {
            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                sendJsonResponse(response, false, "Lý do thu hồi không được để trống", null);
                return;
            }

            // Get admin info
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            int adminUserId = admin.getUserId();

            boolean success = false;
            String message = "";

            if ("experience".equals(contentType)) {
                Experience experience = experienceDAO.getExperienceById(contentId);
                if (experience == null) {
                    sendJsonResponse(response, false, "Experience không tồn tại", null);
                    return;
                }
                
                if (!"APPROVED".equals(experience.getAdminApprovalStatus())) {
                    sendJsonResponse(response, false, "Experience chưa được duyệt nên không thể thu hồi", null);
                    return;
                }
                
                success = experienceDAO.revokeApproval(contentId, adminUserId, reason);
                message = success ? "Đã thu hồi duyệt experience!" : "Có lỗi xảy ra khi thu hồi duyệt";
                
            } else if ("accommodation".equals(contentType)) {
                Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
                if (accommodation == null) {
                    sendJsonResponse(response, false, "Accommodation không tồn tại", null);
                    return;
                }
                
                if (!"APPROVED".equals(accommodation.getAdminApprovalStatus())) {
                    sendJsonResponse(response, false, "Accommodation chưa được duyệt nên không thể thu hồi", null);
                    return;
                }
                
                success = accommodationDAO.revokeApproval(contentId, adminUserId, reason);
                message = success ? "Đã thu hồi duyệt accommodation!" : "Có lỗi xảy ra khi thu hồi duyệt";
            } else {
                sendJsonResponse(response, false, "Content type không hợp lệ", null);
                return;
            }

            if (success) {
                String adminEmail = admin.getEmail();
                LOGGER.info("Admin " + adminEmail + " revoked " + contentType + " ID: " + contentId + " - Reason: " + reason);
            }

            sendJsonResponse(response, success, message, null);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in handleRevokeContent", e);
            sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
        }
    }

    /**
     * Handle delete content - XÓA VĨNH VIỄN
     */
    private void handleDeleteContent(HttpServletRequest request, HttpServletResponse response, 
                                   String contentType, int contentId) throws IOException {

        try {
            boolean success = false;
            String message = "";

            if ("experience".equals(contentType)) {
                success = experienceDAO.deleteExperience(contentId);
                message = success ? "Experience đã bị xóa vĩnh viễn" : "Có lỗi xảy ra khi xóa experience";
                
            } else if ("accommodation".equals(contentType)) {
                success = accommodationDAO.deleteAccommodation(contentId);
                message = success ? "Accommodation đã bị xóa vĩnh viễn" : "Có lỗi xảy ra khi xóa accommodation";
            } else {
                sendJsonResponse(response, false, "Content type không hợp lệ", null);
                return;
            }

            if (success) {
                // Log activity
                HttpSession session = request.getSession();
                User admin = (User) session.getAttribute("user");
                String adminEmail = admin.getEmail();
                LOGGER.info("Admin " + adminEmail + " permanently deleted " + contentType + " ID: " + contentId);
            }

            sendJsonResponse(response, success, message, null);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in handleDeleteContent", e);
            sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
        }
    }

    /**
     * Handle approve all pending content - DUYỆT TẤT CẢ
     */
    private void handleApproveAll(HttpServletRequest request, HttpServletResponse response) throws IOException {

        try {
            String contentTypeParam = request.getParameter("contentType");
            int approvedCount = 0;
            int totalCount = 0;

            // Get admin info
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            int adminUserId = admin.getUserId();

            // Approve all pending experiences
            if (contentTypeParam == null || contentTypeParam.equals("all") || contentTypeParam.equals("experience")) {
                List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 1000);
                totalCount += pendingExperiences.size();

                for (Experience exp : pendingExperiences) {
                    try {
                        if ("PENDING".equals(exp.getAdminApprovalStatus()) && 
                            experienceDAO.approveExperience(exp.getExperienceId(), adminUserId)) {
                            approvedCount++;
                        }
                    } catch (SQLException e) {
                        LOGGER.log(Level.WARNING, "Failed to approve experience ID: " + exp.getExperienceId(), e);
                    }
                }
            }

            // Approve all pending accommodations
            if (contentTypeParam == null || contentTypeParam.equals("all") || contentTypeParam.equals("accommodation")) {
                List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 1000);
                totalCount += pendingAccommodations.size();

                for (Accommodation acc : pendingAccommodations) {
                    try {
                        if ("PENDING".equals(acc.getAdminApprovalStatus()) && 
                            accommodationDAO.approveAccommodation(acc.getAccommodationId(), adminUserId)) {
                            approvedCount++;
                        }
                    } catch (SQLException e) {
                        LOGGER.log(Level.WARNING, "Failed to approve accommodation ID: " + acc.getAccommodationId(), e);
                    }
                }
            }

            if (totalCount == 0) {
                sendJsonResponse(response, false, "Không có nội dung nào chờ duyệt", null);
                return;
            }

            // Log activity
            String adminEmail = admin.getEmail();
            LOGGER.info("Admin " + adminEmail + " bulk approved " + approvedCount + " content items");

            Map<String, Object> data = new HashMap<>();
            data.put("count", approvedCount);
            data.put("total", totalCount);

            sendJsonResponse(response, true, "Đã duyệt " + approvedCount + "/" + totalCount + " nội dung thành công!", data);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in handleApproveAll", e);
            sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
        }
    }

    /**
     * Handle export pending content - XUẤT DANH SÁCH CHỜ DUYỆT
     */
    private void handleExportPending(HttpServletRequest request, HttpServletResponse response) throws IOException {

        LOGGER.info("=== EXPORT PENDING START ===");
        
        try {
            // Set response headers for CSV download
            response.reset();
            response.setContentType("text/csv; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"pending-content-" + 
                              System.currentTimeMillis() + ".csv\"");
            response.setHeader("Cache-Control", "no-cache");

            try (PrintWriter out = response.getWriter()) {
                // CSV Header with BOM for Excel UTF-8 support
                out.print('\ufeff'); // UTF-8 BOM
                out.println("Type,ID,Title/Name,Host,City,Created Date,Status,Price,Location,Admin Status");

                // Export pending experiences
                List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 10000);
                for (Experience exp : pendingExperiences) {
                    enrichExperienceData(exp);
                    
                    out.printf("Experience,%d,\"%s\",\"%s\",\"%s\",%s,\"Pending\",%.0f,\"%s\",\"%s\"%n",
                        exp.getExperienceId(),
                        sanitizeForCsv(exp.getTitle()),
                        sanitizeForCsv(exp.getHostName()),
                        sanitizeForCsv(exp.getCityName()),
                        exp.getCreatedAt() != null ? exp.getCreatedAt().toString() : "",
                        exp.getPrice(),
                        sanitizeForCsv(exp.getLocation()),
                        exp.getAdminApprovalStatus()
                    );
                }

                // Export pending accommodations
                List<Accommodation> pendingAccommodations = accommodationDAO.getPendingAccommodations(1, 10000);
                for (Accommodation acc : pendingAccommodations) {
                    enrichAccommodationData(acc);
                    
                    out.printf("Accommodation,%d,\"%s\",\"%s\",\"%s\",%s,\"Pending\",%.0f,\"%s\",\"%s\"%n",
                        acc.getAccommodationId(),
                        sanitizeForCsv(acc.getName()),
                        sanitizeForCsv(acc.getHostName()),
                        sanitizeForCsv(acc.getCityName()),
                        acc.getCreatedAt() != null ? acc.getCreatedAt().toString() : "",
                        acc.getPricePerNight(),
                        sanitizeForCsv(acc.getAddress()),
                        acc.getAdminApprovalStatus()
                    );
                }
                
                out.flush();
                LOGGER.info("CSV export completed successfully");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in handleExportPending", e);
            if (!response.isCommitted()) {
                response.reset();
                sendJsonResponse(response, false, "Lỗi cơ sở dữ liệu: " + e.getMessage(), null);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in handleExportPending", e);
            if (!response.isCommitted()) {
                response.reset();
                sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
            }
        }
        
        LOGGER.info("=== EXPORT PENDING END ===");
    }

    /**
     * Handle content list display
     */
    private void handleContentList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String filter = request.getParameter("filter");
        String contentType = request.getParameter("contentType");
        String accommodationType = request.getParameter("type");
        
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
                enrichExperienceData(exp);
                allContent.add(new ContentItem(exp));
            }
        }

        // Get accommodations
        if (contentType == null || contentType.equals("all") || contentType.equals("accommodation")) {
            List<Accommodation> accommodations = getFilteredAccommodations(filter, page, pageSize, accommodationType);
            for (Accommodation acc : accommodations) {
                enrichAccommodationData(acc);
                allContent.add(new ContentItem(acc));
            }
        }

        // Sort by creation date (newest first)
        allContent.sort((a, b) -> {
            if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
            if (a.getCreatedAt() == null) return 1;
            if (b.getCreatedAt() == null) return -1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });

        // Apply pagination
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
        
        LOGGER.info("=== HANDLE CONTENT DETAIL ===");
        LOGGER.info("Content Type: " + contentType + ", ID: " + contentId);
        
        try {
            if ("experience".equals(contentType)) {
                Experience experience = experienceDAO.getExperienceById(contentId);
                if (experience == null) {
                    LOGGER.warning("Experience not found with ID: " + contentId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Experience không tồn tại");
                    return;
                }
                
                enrichExperienceData(experience);
                
                // Set both attributes for compatibility
                request.setAttribute("content", experience);
                request.setAttribute("contentItem", new ContentItem(experience));
                request.setAttribute("contentType", "experience");
                
                LOGGER.info("Experience found: " + experience.getTitle());
                
            } else if ("accommodation".equals(contentType)) {
                Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
                if (accommodation == null) {
                    LOGGER.warning("Accommodation not found with ID: " + contentId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Accommodation không tồn tại");
                    return;
                }
                
                enrichAccommodationData(accommodation);
                
                // Set both attributes for compatibility
                request.setAttribute("content", accommodation);
                request.setAttribute("contentItem", new ContentItem(accommodation));
                request.setAttribute("contentType", "accommodation");
                
                LOGGER.info("Accommodation found: " + accommodation.getName());
                
            } else {
                LOGGER.warning("Invalid content type: " + contentType);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Content type không hợp lệ");
                return;
            }
            
            LOGGER.info("Forwarding to JSP...");
            request.getRequestDispatcher("/view/jsp/admin/content/content-detail.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting content detail", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }

    /**
     * Handle get content images
     */
    private void handleGetContentImages(HttpServletRequest request, HttpServletResponse response, 
                                      String contentType, int contentId)
            throws SQLException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<String> images = new ArrayList<>();
            
            if ("experience".equals(contentType)) {
                Experience experience = experienceDAO.getExperienceById(contentId);
                if (experience != null && experience.getImages() != null) {
                    String[] imageArray = experience.getImages().split(",");
                    for (String img : imageArray) {
                        if (!img.trim().isEmpty()) {
                            images.add("/view/assets/images/experiences/" + img.trim());
                        }
                    }
                }
            } else if ("accommodation".equals(contentType)) {
                Accommodation accommodation = accommodationDAO.getAccommodationById(contentId);
                if (accommodation != null && accommodation.getImages() != null) {
                    String[] imageArray = accommodation.getImages().split(",");
                    for (String img : imageArray) {
                        if (!img.trim().isEmpty()) {
                            images.add("/view/assets/images/accommodations/" + img.trim());
                        }
                    }
                }
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("images", images);
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            out.flush();
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting content images", e);
            sendJsonResponse(response, false, "Lỗi hệ thống", null);
        }
    }

    /**
     * Get filtered experiences based on adminApprovalStatus
     */
    private List<Experience> getFilteredExperiences(String filter, int page, int pageSize) throws SQLException {
        switch (filter != null ? filter : "pending") {
            case "approved":
                return experienceDAO.getApprovedExperiences(page, pageSize);
            case "rejected":
                return experienceDAO.getRejectedExperiences(page, pageSize);
            case "all":
                return experienceDAO.getAllExperiences(page, pageSize);
            default: // pending
                return experienceDAO.getPendingExperiences(page, pageSize);
        }
    }

    /**
     * Get filtered accommodations based on adminApprovalStatus
     */
    private List<Accommodation> getFilteredAccommodations(String filter, int page, int pageSize, String type) throws SQLException {
        switch (filter != null ? filter : "pending") {
            case "approved":
                return accommodationDAO.getApprovedAccommodations(page, pageSize);
            case "rejected":
                return accommodationDAO.getRejectedAccommodations(page, pageSize);
            case "all":
                return accommodationDAO.getAllAccommodations(page, pageSize);
            default: // pending
                return accommodationDAO.getPendingAccommodations(page, pageSize);
        }
    }

    /**
     * Get content statistics
     */
    private Map<String, Integer> getContentStatistics() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        
        try {
            // Experience stats
            stats.put("experiencePending", experienceDAO.getPendingExperiencesCount());
            stats.put("experienceApproved", experienceDAO.getApprovedExperiencesCount());
            stats.put("experienceRejected", experienceDAO.getRejectedExperiencesCount());
            stats.put("experienceTotal", experienceDAO.getTotalExperiencesCount());
            
            // Accommodation stats
            stats.put("accommodationPending", accommodationDAO.getPendingAccommodationsCount());
            stats.put("accommodationApproved", accommodationDAO.getApprovedAccommodationsCount());
            stats.put("accommodationRejected", accommodationDAO.getRejectedAccommodationsCount());
            stats.put("accommodationTotal", accommodationDAO.getTotalAccommodationsCount());
            
            // Combined stats
            stats.put("totalPending", stats.get("experiencePending") + stats.get("accommodationPending"));
            stats.put("totalApproved", stats.get("experienceApproved") + stats.get("accommodationApproved"));
            stats.put("totalRejected", stats.get("experienceRejected") + stats.get("accommodationRejected"));
            stats.put("totalAll", stats.get("experienceTotal") + stats.get("accommodationTotal"));
            
            // Hidden content stats (approved but host hidden)
            stats.put("experienceHidden", experienceDAO.getApprovedButHiddenCount());
            stats.put("accommodationHidden", accommodationDAO.getApprovedButHiddenCount());
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting content statistics", e);
            // Return default stats
            stats.put("experiencePending", 0);
            stats.put("experienceApproved", 0);
            stats.put("experienceRejected", 0);
            stats.put("experienceTotal", 0);
            stats.put("accommodationPending", 0);
            stats.put("accommodationApproved", 0);
            stats.put("accommodationRejected", 0);
            stats.put("accommodationTotal", 0);
            stats.put("totalPending", 0);
            stats.put("totalApproved", 0);
            stats.put("totalRejected", 0);
            stats.put("totalAll", 0);
            stats.put("experienceHidden", 0);
            stats.put("accommodationHidden", 0);
        }
        
        return stats;
    }

    // ==================== HELPER METHODS ====================

    /**
     * Enrich experience data with host and city information
     */
    private void enrichExperienceData(Experience exp) {
        try {
            if (exp.getHostName() == null && exp.getHostId() > 0) {
                User host = userDAO.getUserById(exp.getHostId());
                if (host != null) {
                    exp.setHostName(host.getFullName());
                }
            }
            
            if (exp.getCityName() == null && exp.getCityId() > 0) {
                City city = cityDAO.getCityById(exp.getCityId());
                if (city != null) {
                    exp.setCityName(city.getVietnameseName() != null ? 
                                 city.getVietnameseName() : city.getName());
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error enriching experience data for ID: " + exp.getExperienceId(), e);
        }
    }

    /**
     * Enrich accommodation data with host and city information
     */
    private void enrichAccommodationData(Accommodation acc) {
        try {
            if (acc.getHostName() == null && acc.getHostId() > 0) {
                User host = userDAO.getUserById(acc.getHostId());
                if (host != null) {
                    acc.setHostName(host.getFullName());
                }
            }
            
            if (acc.getCityName() == null && acc.getCityId() > 0) {
                City city = cityDAO.getCityById(acc.getCityId());
                if (city != null) {
                    acc.setCityName(city.getVietnameseName() != null ? 
                                  city.getVietnameseName() : city.getName());
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error enriching accommodation data for ID: " + acc.getAccommodationId(), e);
        }
    }

    /**
     * Validate content type
     */
    private boolean isValidContentType(String contentType) {
        return "experience".equals(contentType) || "accommodation".equals(contentType);
    }

    /**
     * Sanitize string for CSV output
     */
    private String sanitizeForCsv(String input) {
        if (input == null) return "";
        return input.replace("\"", "\"\"").replace("\n", " ").replace("\r", " ");
    }

    /**
     * Check if user is authenticated admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                LOGGER.warning("No session found");
                return false;
            }

            User user = (User) session.getAttribute("user");
            if (user == null) {
                LOGGER.warning("No user found in session");
                return false;
            }
            
            boolean isAdmin = "ADMIN".equals(user.getRole());
            boolean isActive = user.isActive();
            
            LOGGER.info("User authentication check - Role: " + user.getRole() + 
                       ", Active: " + isActive + ", IsAdmin: " + isAdmin);
            
            return isAdmin && isActive;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking admin authentication", e);
            return false;
        }
    }

    /**
     * Send JSON response with proper error handling
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) {
        try {
            LOGGER.info("=== SENDING JSON RESPONSE ===");
            LOGGER.info("Success: " + success + ", Message: " + message);
            
            // Check if response is already committed
            if (response.isCommitted()) {
                LOGGER.warning("Response already committed, cannot send JSON");
                return;
            }
            
            // Set response properties
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            
            // Build JSON response
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", success);
            jsonResponse.put("message", message != null ? message : "");
            jsonResponse.put("timestamp", System.currentTimeMillis());
            
            if (data != null) {
                jsonResponse.put("data", data);
            }

            String jsonString = gson.toJson(jsonResponse);
            LOGGER.info("JSON Response: " + jsonString);
            
            // Write response
            try (PrintWriter out = response.getWriter()) {
                out.print(jsonString);
                out.flush();
            }
            
            LOGGER.info("JSON response sent successfully");
            
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error sending JSON response", e);
            // Try to send a basic error response
            try {
                if (!response.isCommitted()) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json");
                    response.getWriter().print("{\"success\":false,\"message\":\"Internal server error\"}");
                }
            } catch (IOException ioException) {
                LOGGER.log(Level.SEVERE, "Failed to send error response", ioException);
            }
        }
    }

    // ==================== CONTENT ITEM WRAPPER CLASS ====================

    /**
     * Wrapper class for unified content handling with adminApprovalStatus
     */
    public static class ContentItem {
        private String type;
        private Object content;
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
        
        // Admin approval fields
        private String adminApprovalStatus;
        private Integer adminApprovedBy;
        private java.util.Date adminApprovedAt;
        private String adminRejectReason;

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
            
            // Admin approval status mapping
            this.adminApprovalStatus = experience.getAdminApprovalStatus();
            this.adminApprovedBy = experience.getAdminApprovedBy();
            this.adminApprovedAt = experience.getAdminApprovedAt();
            this.adminRejectReason = experience.getAdminRejectReason();
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
            
            // Admin approval status mapping
            this.adminApprovalStatus = accommodation.getAdminApprovalStatus();
            this.adminApprovedBy = accommodation.getAdminApprovedBy();
            this.adminApprovedAt = accommodation.getAdminApprovedAt();
            this.adminRejectReason = accommodation.getAdminRejectReason();
        }

        // Status helper methods
        public String getStatusDisplay() {
            switch (adminApprovalStatus != null ? adminApprovalStatus : "PENDING") {
                case "PENDING":
                    return "Chờ duyệt";
                case "APPROVED":
                    return isActive ? "Đang hiển thị" : "Đã ẩn bởi host";
                case "REJECTED":
                    return "Bị từ chối";
                default:
                    return "Không xác định";
            }
        }

        public String getStatusClass() {
            switch (adminApprovalStatus != null ? adminApprovalStatus : "PENDING") {
                case "PENDING":
                    return "badge-warning";
                case "APPROVED":
                    return isActive ? "badge-success" : "badge-secondary";
                case "REJECTED":
                    return "badge-danger";
                default:
                    return "badge-light";
            }
        }

        public boolean canApprove() {
            return "PENDING".equals(adminApprovalStatus);
        }

        public boolean canReject() {
            return "PENDING".equals(adminApprovalStatus);
        }

        public boolean canRevoke() {
            return "APPROVED".equals(adminApprovalStatus);
        }

        public String getAdminStatusInfo() {
            if ("APPROVED".equals(adminApprovalStatus) && adminApprovedAt != null) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                return "Đã duyệt lúc " + sdf.format(adminApprovedAt);
            } else if ("REJECTED".equals(adminApprovalStatus) && adminRejectReason != null) {
                return "Bị từ chối: " + adminRejectReason;
            }
            return "";
        }

        // Utility methods
        public String[] getImageList() {
            if (images != null && !images.trim().isEmpty()) {
                return images.split(",");
            }
            return new String[0];
        }

        public String getFormattedPrice() {
            return String.format("%,.0f VNĐ", price);
        }

        public String getFirstImageUrl() {
            String[] imageList = getImageList();
            if (imageList.length > 0) {
                String imageName = imageList[0].trim();
                return "/view/assets/images/" + type + "s/" + imageName;
            }
            return "/view/assets/images/default-content.jpg";
        }

        public String getTypeDisplayName() {
            return "experience".equals(type) ? "Trải nghiệm" : "Lưu trú";
        }

        // Getters for all fields
        public String getType() { return type; }
        public Object getContent() { return content; }
        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public String getHostName() { return hostName; }
        public String getCityName() { return cityName; }
        public java.util.Date getCreatedAt() { return createdAt; }
        public boolean isActive() { return isActive; }
        public boolean getActive() { return isActive; }
        public String getImages() { return images; }
        public double getPrice() { return price; }
        public String getLocation() { return location; }
        public int getHostId() { return hostId; }
        public int getCityId() { return cityId; }
        public String getAdminApprovalStatus() { return adminApprovalStatus; }
        public Integer getAdminApprovedBy() { return adminApprovedBy; }
        public java.util.Date getAdminApprovedAt() { return adminApprovedAt; }
        public String getAdminRejectReason() { return adminRejectReason; }
    }

    @Override
    public void destroy() {
        super.destroy();
        LOGGER.info("AdminContentApprovalServlet destroyed");
    }
}