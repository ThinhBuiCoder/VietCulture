package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Experience;
import model.Accommodation;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import dao.CityDAO;
import dao.CategoryDAO;
import dao.RegionDAO;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.List;
import java.sql.SQLException;

/**
 * Servlet quản lý dịch vụ của Host
 * URL: /host/experiences/manage, /host/services/manage, /host/services/edit/*
 */
@WebServlet(name = "ManageServicesServlet", urlPatterns = {
    "/host/experiences/manage",
    "/host/services/manage",
    "/host/services/edit/*",
    "/host/experiences/edit/*",    // Thêm pattern cho experiences
    "/host/accommodations/edit/*", // Thêm pattern cho accommodations
  
    "/host/services/delete/*"
})
public class ManageServicesServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ManageServicesServlet.class.getName());
    
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private CityDAO cityDAO;
    private CategoryDAO categoryDAO;
    private RegionDAO regionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            cityDAO = new CityDAO();
            categoryDAO = new CategoryDAO();
            regionDAO = new RegionDAO();
            LOGGER.info("ManageServicesServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ManageServicesServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        LOGGER.info("=== DEBUG MANAGE SERVLET ===");
        LOGGER.info("Servlet Path: " + servletPath);
        LOGGER.info("Path Info: " + pathInfo);
        LOGGER.info("Full URL: " + request.getRequestURL());
        
        try {
            // Check authentication
            if (!isHostAuthenticated(request)) {
                LOGGER.info("User not authenticated, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/Travel/login");
                return;
            }

            User currentUser = getCurrentUser(request);
            LOGGER.info("Current user: " + currentUser.getUserId());
            
            // ✅ SỬA LOGIC ROUTING ĐỂ XỬ LÝ CÁC SERVLET PATH KHÁC NHAU
            if ("/host/services/manage".equals(servletPath) || "/host/experiences/manage".equals(servletPath)) {
                // Main management page
                LOGGER.info("Handling main management page");
                handleManagementPage(request, response, currentUser);
            } 
            else if ("/host/services/edit".equals(servletPath)) {
                // Edit service page với pattern: /host/services/edit/experience/1
                LOGGER.info("Handling edit page for services pattern, pathInfo: " + pathInfo);
                handleEditPage(request, response, currentUser, pathInfo);
            }
            else if ("/host/experiences/edit".equals(servletPath)) {
                // Edit experience page với pattern: /host/experiences/edit/1
                LOGGER.info("Handling edit page for experiences pattern, pathInfo: " + pathInfo);
                handleExperienceEditPage(request, response, currentUser, pathInfo);
            }
            else if ("/host/accommodations/edit".equals(servletPath)) {
                // Edit accommodation page với pattern: /host/accommodations/edit/1
                LOGGER.info("Handling edit page for accommodations pattern, pathInfo: " + pathInfo);
                handleAccommodationEditPage(request, response, currentUser, pathInfo);
            }
            else {
                LOGGER.warning("No handler found for servlet path: " + servletPath + ", pathInfo: " + pathInfo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ManageServicesServlet doGet", e);
            handleError(request, response, "Có lỗi xảy ra khi tải trang quản lý dịch vụ: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        try {
            if (!isHostAuthenticated(request)) {
                response.sendRedirect(request.getContextPath() + "/Travel/login");
                return;
            }

            User currentUser = getCurrentUser(request);
            
            // Xử lý POST requests dựa trên servlet path và path info
            if ("/host/services/edit".equals(servletPath) && pathInfo != null && pathInfo.startsWith("/")) {
                handleUpdateService(request, response, currentUser, pathInfo);
            }
            else if ("/host/experiences/edit".equals(servletPath)) {
                handleUpdateExperienceService(request, response, currentUser, pathInfo);
            }
            else if ("/host/accommodations/edit".equals(servletPath)) {
                handleUpdateAccommodationService(request, response, currentUser, pathInfo);
            }
            else if (pathInfo != null) {
                if (pathInfo.startsWith("/edit/")) {
                    handleUpdateService(request, response, currentUser, pathInfo);
                } else if (pathInfo.startsWith("/toggle/")) {
                    handleToggleService(request, response, currentUser, pathInfo);
                } else if (pathInfo.startsWith("/delete/")) {
                    handleDeleteService(request, response, currentUser, pathInfo);
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ManageServicesServlet doPost", e);
            setErrorMessage(request, "Có lỗi xảy ra khi xử lý yêu cầu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
        }
    }

    /**
     * Handle main management page
     */
    private void handleManagementPage(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException, SQLException {
        
        // Get filter parameters
        String serviceType = request.getParameter("type");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sort");
        
        // Default values
        if (serviceType == null || serviceType.isEmpty()) serviceType = "all";
        if (status == null || status.isEmpty()) status = "all";
        if (sortBy == null || sortBy.isEmpty()) sortBy = "newest";
        
        // Get services
        List<Experience> experiences = null;
        List<Accommodation> accommodations = null;
        
        if ("experience".equals(serviceType) || "all".equals(serviceType)) {
            experiences = experienceDAO.getExperiencesByHostId(user.getUserId());
            experiences = filterExperiences(experiences, status);
            experiences = sortExperiences(experiences, sortBy);
        }
        
        if ("accommodation".equals(serviceType) || "all".equals(serviceType)) {
            accommodations = accommodationDAO.getAccommodationsByHostId(user.getUserId());
            accommodations = filterAccommodations(accommodations, status);
            accommodations = sortAccommodations(accommodations, sortBy);
        }
        
        // Set attributes
        request.setAttribute("experiences", experiences);
        request.setAttribute("accommodations", accommodations);
        request.setAttribute("currentUser", user);
        request.setAttribute("selectedType", serviceType);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedSort", sortBy);
        
        // Statistics
        setStatistics(request, user);
        
        LOGGER.info("Forwarding to manage_services.jsp");
        request.getRequestDispatcher("/view/jsp/host/manage_services.jsp").forward(request, response);
    }

    /**
     * Handle edit page cho pattern /host/services/edit/experience/1
     */
    private void handleEditPage(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        LOGGER.info("Processing edit request for path: " + pathInfo);
        
        if (pathInfo == null || pathInfo.length() <= 1) {
            LOGGER.warning("Path info is null or empty");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing path information");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        LOGGER.info("Path parts: " + java.util.Arrays.toString(pathParts));
        
        // Với pattern /host/services/edit/experience/1, pathInfo sẽ là "/experience/1"
        if (pathParts.length < 3) {
            LOGGER.warning("Invalid path format: " + pathInfo + " - expected /type/id");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid URL format");
            return;
        }
        
        String serviceType = pathParts[1]; // experience hoặc accommodation
        String serviceIdStr = pathParts[2]; // 1
        
        processEditRequest(request, response, user, serviceType, serviceIdStr);
    }

    /**
     * Handle edit page cho pattern /host/experiences/edit/1
     */
    private void handleExperienceEditPage(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        LOGGER.info("Processing experience edit request for path: " + pathInfo);
        
        if (pathInfo == null || pathInfo.length() <= 1) {
            LOGGER.warning("Path info is null or empty");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing experience ID");
            return;
        }
        
        // Với pattern /host/experiences/edit/1, pathInfo sẽ là "/1"
        String serviceIdStr = pathInfo.substring(1); // Bỏ dấu "/" đầu tiên
        
        processEditRequest(request, response, user, "experience", serviceIdStr);
    }

    /**
     * Handle edit page cho pattern /host/accommodations/edit/1
     */
    private void handleAccommodationEditPage(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        LOGGER.info("Processing accommodation edit request for path: " + pathInfo);
        
        if (pathInfo == null || pathInfo.length() <= 1) {
            LOGGER.warning("Path info is null or empty");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing accommodation ID");
            return;
        }
        
        // Với pattern /host/accommodations/edit/1, pathInfo sẽ là "/1"
        String serviceIdStr = pathInfo.substring(1); // Bỏ dấu "/" đầu tiên
        
        processEditRequest(request, response, user, "accommodation", serviceIdStr);
    }

    /**
     * Xử lý chung cho tất cả edit requests
     */
    private void processEditRequest(HttpServletRequest request, HttpServletResponse response, User user, 
                                   String serviceType, String serviceIdStr)
            throws ServletException, IOException, SQLException {
        
        int serviceId;
        
        try {
            serviceId = Integer.parseInt(serviceIdStr);
            LOGGER.info("Parsed service ID: " + serviceId + ", type: " + serviceType);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid service ID: " + serviceIdStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID");
            return;
        }
        
        try {
            // Load form data
            LOGGER.info("Loading form data...");
            request.setAttribute("regions", regionDAO.getAllRegions());
            request.setAttribute("cities", cityDAO.getAllCities());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            
            if ("experience".equals(serviceType)) {
                LOGGER.info("Loading experience with ID: " + serviceId);
                Experience experience = experienceDAO.getExperienceById(serviceId);
                if (experience == null) {
                    LOGGER.warning("Experience not found: " + serviceId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Experience not found");
                    return;
                }
                if (experience.getHostId() != user.getUserId()) {
                    LOGGER.warning("Access denied for experience " + serviceId + " by user " + user.getUserId());
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                request.setAttribute("experience", experience);
                request.setAttribute("serviceType", "experience");
                LOGGER.info("Experience loaded successfully: " + experience.getTitle());
            } 
            else if ("accommodation".equals(serviceType)) {
                LOGGER.info("Loading accommodation with ID: " + serviceId);
                Accommodation accommodation = accommodationDAO.getAccommodationById(serviceId);
                if (accommodation == null) {
                    LOGGER.warning("Accommodation not found: " + serviceId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Accommodation not found");
                    return;
                }
                if (accommodation.getHostId() != user.getUserId()) {
                    LOGGER.warning("Access denied for accommodation " + serviceId + " by user " + user.getUserId());
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                request.setAttribute("accommodation", accommodation);
                request.setAttribute("serviceType", "accommodation");
                LOGGER.info("Accommodation loaded successfully: " + accommodation.getName());
            } 
            else {
                LOGGER.warning("Invalid service type: " + serviceType);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid service type");
                return;
            }
            
            request.setAttribute("currentUser", user);
            request.setAttribute("isEdit", true);
            
            LOGGER.info("Forwarding to edit form JSP");
            request.getRequestDispatcher("/view/jsp/host/edit_service_form.jsp").forward(request, response);
                   
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in edit page", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }

    /**
     * Handle service update cho pattern /host/services/edit/*
     */
    private void handleUpdateService(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 3) {
            setErrorMessage(request, "Invalid URL format for update");
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
        
        String serviceType = pathParts[1];
        int serviceId = Integer.parseInt(pathParts[2]);
        
        boolean success = updateServiceByType(request, user, serviceType, serviceId);
        
        if (success) {
            setSuccessMessage(request, "Cập nhật dịch vụ thành công!");
        } else {
            setErrorMessage(request, "Không thể cập nhật dịch vụ.");
        }
        
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
    }

    /**
     * Handle update cho experience pattern /host/experiences/edit/*
     */
    private void handleUpdateExperienceService(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        if (pathInfo == null || pathInfo.length() <= 1) {
            setErrorMessage(request, "Missing experience ID");
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
        
        int serviceId = Integer.parseInt(pathInfo.substring(1));
        boolean success = updateServiceByType(request, user, "experience", serviceId);
        
        if (success) {
            setSuccessMessage(request, "Cập nhật trải nghiệm thành công!");
        } else {
            setErrorMessage(request, "Không thể cập nhật trải nghiệm.");
        }
        
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
    }

    /**
     * Handle update cho accommodation pattern /host/accommodations/edit/*
     */
    private void handleUpdateAccommodationService(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        if (pathInfo == null || pathInfo.length() <= 1) {
            setErrorMessage(request, "Missing accommodation ID");
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
        
        int serviceId = Integer.parseInt(pathInfo.substring(1));
        boolean success = updateServiceByType(request, user, "accommodation", serviceId);
        
        if (success) {
            setSuccessMessage(request, "Cập nhật lưu trú thành công!");
        } else {
            setErrorMessage(request, "Không thể cập nhật lưu trú.");
        }
        
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
    }

    /**
     * Method chung để update service theo type
     */
    private boolean updateServiceByType(HttpServletRequest request, User user, String serviceType, int serviceId)
            throws SQLException {
        
        if ("experience".equals(serviceType)) {
            return updateExperience(request, user, serviceId);
        } else if ("accommodation".equals(serviceType)) {
            return updateAccommodation(request, user, serviceId);
        }
        return false;
    }

    /**
     * Handle toggle active/inactive
     */
   /**
 * Handle toggle active/inactive - ✅ SỬA LẠI
 */
private void handleToggleService(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
        throws ServletException, IOException, SQLException {
    
    LOGGER.info("=== DEBUG TOGGLE SERVICE ===");
    LOGGER.info("Path Info: " + pathInfo);
    LOGGER.info("Request URI: " + request.getRequestURI());
    LOGGER.info("Servlet Path: " + request.getServletPath());
    
    String[] pathParts = pathInfo.split("/");
    LOGGER.info("Path parts: " + java.util.Arrays.toString(pathParts));
    LOGGER.info("Path parts length: " + pathParts.length);
    
    // ✅ KIỂM TRA CẢ 2 TRƯỜNG HỢP: 3 parts và 4 parts
    String serviceType;
    int serviceId;
    
    if (pathParts.length == 4) {
        // Format: /toggle/experience/1 -> ["", "toggle", "experience", "1"]
        serviceType = pathParts[2];
        try {
            serviceId = Integer.parseInt(pathParts[3]);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid service ID in 4-part format: " + pathParts[3]);
            setErrorMessage(request, "ID dịch vụ không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
    } else if (pathParts.length == 3) {
        // Format: /experience/1 -> ["", "experience", "1"] 
        serviceType = pathParts[1];
        try {
            serviceId = Integer.parseInt(pathParts[2]);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid service ID in 3-part format: " + pathParts[2]);
            setErrorMessage(request, "ID dịch vụ không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
    } else {
        LOGGER.warning("Invalid URL format for toggle. Expected /toggle/type/id or /type/id, got: " + pathInfo);
        setErrorMessage(request, "URL không hợp lệ cho toggle");
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
        return;
    }
    
    LOGGER.info("Parsed - Service Type: " + serviceType + ", Service ID: " + serviceId);
    
    boolean success = false;
    String actionMessage = "";
    
    try {
        if ("experience".equals(serviceType)) {
            LOGGER.info("Processing experience toggle for ID: " + serviceId);
            Experience experience = experienceDAO.getExperienceById(serviceId);
            
            if (experience == null) {
                LOGGER.warning("Experience not found: " + serviceId);
                setErrorMessage(request, "Không tìm thấy trải nghiệm");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            if (experience.getHostId() != user.getUserId()) {
                LOGGER.warning("Access denied for experience " + serviceId + " by user " + user.getUserId());
                setErrorMessage(request, "Bạn không có quyền thay đổi dịch vụ này");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            boolean oldStatus = experience.isActive();
            experience.setActive(!oldStatus);
            success = experienceDAO.updateExperience(experience);
            
            if (success) {
                actionMessage = oldStatus ? "Đã ẩn trải nghiệm thành công!" : "Đã hiển thị trải nghiệm thành công!";
                LOGGER.info("Experience " + serviceId + " status changed from " + oldStatus + " to " + !oldStatus);
            }
            
        } else if ("accommodation".equals(serviceType)) {
            LOGGER.info("Processing accommodation toggle for ID: " + serviceId);
            Accommodation accommodation = accommodationDAO.getAccommodationById(serviceId);
            
            if (accommodation == null) {
                LOGGER.warning("Accommodation not found: " + serviceId);
                setErrorMessage(request, "Không tìm thấy lưu trú");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            if (accommodation.getHostId() != user.getUserId()) {
                LOGGER.warning("Access denied for accommodation " + serviceId + " by user " + user.getUserId());
                setErrorMessage(request, "Bạn không có quyền thay đổi dịch vụ này");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            boolean oldStatus = accommodation.isActive();
            accommodation.setActive(!oldStatus);
            success = accommodationDAO.updateAccommodation(accommodation);
            
            if (success) {
                actionMessage = oldStatus ? "Đã ẩn lưu trú thành công!" : "Đã hiển thị lưu trú thành công!";
                LOGGER.info("Accommodation " + serviceId + " status changed from " + oldStatus + " to " + !oldStatus);
            }
            
        } else {
            LOGGER.warning("Invalid service type: " + serviceType);
            setErrorMessage(request, "Loại dịch vụ không hợp lệ: " + serviceType);
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Database error in toggle service", e);
        setErrorMessage(request, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
        return;
    }
    
    // Set result message
    if (success) {
        setSuccessMessage(request, actionMessage);
        LOGGER.info("Toggle service successful: " + actionMessage);
    } else {
        setErrorMessage(request, "Không thể cập nhật trạng thái dịch vụ. Vui lòng thử lại.");
        LOGGER.warning("Toggle service failed for " + serviceType + " ID: " + serviceId);
    }
    
    response.sendRedirect(request.getContextPath() + "/host/services/manage");
}

    /**
     * Handle delete service
     */
    private void handleDeleteService(HttpServletRequest request, HttpServletResponse response, User user, String pathInfo)
            throws ServletException, IOException, SQLException {
        
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 4) {
            setErrorMessage(request, "Invalid URL format for delete");
            response.sendRedirect(request.getContextPath() + "/host/services/manage");
            return;
        }
        
        String serviceType = pathParts[2];
        int serviceId = Integer.parseInt(pathParts[3]);
        
        boolean success = false;
        
        if ("experience".equals(serviceType)) {
            Experience experience = experienceDAO.getExperienceById(serviceId);
            if (experience != null && experience.getHostId() == user.getUserId()) {
                success = experienceDAO.deleteExperience(serviceId);
            }
        } else if ("accommodation".equals(serviceType)) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(serviceId);
            if (accommodation != null && accommodation.getHostId() == user.getUserId()) {
                success = accommodationDAO.deleteAccommodation(serviceId);
            }
        }
        
        if (success) {
            setSuccessMessage(request, "Xóa dịch vụ thành công!");
        } else {
            setErrorMessage(request, "Không thể xóa dịch vụ.");
        }
        
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
    }

    // Helper methods
    private boolean updateExperience(HttpServletRequest request, User user, int experienceId) throws SQLException {
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null || experience.getHostId() != user.getUserId()) {
            return false;
        }
        
        // Update fields
        experience.setTitle(request.getParameter("title"));
        experience.setDescription(request.getParameter("description"));
        experience.setLocation(request.getParameter("location"));
        experience.setPrice(Double.parseDouble(request.getParameter("price")));
        experience.setCityId(Integer.parseInt(request.getParameter("cityId")));
        experience.setType(request.getParameter("type"));
        experience.setMaxGroupSize(Integer.parseInt(request.getParameter("groupSize")));
        // Add other fields as needed
        
        return experienceDAO.updateExperience(experience);
    }
    
    private boolean updateAccommodation(HttpServletRequest request, User user, int accommodationId) throws SQLException {
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null || accommodation.getHostId() != user.getUserId()) {
            return false;
        }
        
        // Update fields
        accommodation.setName(request.getParameter("title"));
        accommodation.setDescription(request.getParameter("description"));
        accommodation.setPricePerNight(Double.parseDouble(request.getParameter("price")));
        accommodation.setCityId(Integer.parseInt(request.getParameter("cityId")));
        accommodation.setType(request.getParameter("accommodationType"));
        // Add other fields as needed
        
        return accommodationDAO.updateAccommodation(accommodation);
    }

    private List<Experience> filterExperiences(List<Experience> experiences, String status) {
        if ("all".equals(status)) return experiences;
        return experiences.stream()
                .filter(e -> "active".equals(status) ? e.isActive() : !e.isActive())
                .collect(java.util.stream.Collectors.toList());
    }
    
    private List<Accommodation> filterAccommodations(List<Accommodation> accommodations, String status) {
        if ("all".equals(status)) return accommodations;
        return accommodations.stream()
                .filter(a -> "active".equals(status) ? a.isActive() : !a.isActive())
                .collect(java.util.stream.Collectors.toList());
    }
    
    private List<Experience> sortExperiences(List<Experience> experiences, String sortBy) {
        switch (sortBy) {
            case "price_asc":
                experiences.sort((a, b) -> Double.compare(a.getPrice(), b.getPrice()));
                break;
            case "price_desc":
                experiences.sort((a, b) -> Double.compare(b.getPrice(), a.getPrice()));
                break;
            case "oldest":
                experiences.sort((a, b) -> a.getCreatedAt().compareTo(b.getCreatedAt()));
                break;
            default: // newest
                experiences.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
        }
        return experiences;
    }
    
    private List<Accommodation> sortAccommodations(List<Accommodation> accommodations, String sortBy) {
        switch (sortBy) {
            case "price_asc":
                accommodations.sort((a, b) -> Double.compare(a.getPricePerNight(), b.getPricePerNight()));
                break;
            case "price_desc":
                accommodations.sort((a, b) -> Double.compare(b.getPricePerNight(), a.getPricePerNight()));
                break;
            // Add date sorting if accommodation has createdAt field
        }
        return accommodations;
    }

    private void setStatistics(HttpServletRequest request, User user) throws SQLException {
        int totalExperiences = experienceDAO.countExperiencesByHostId(user.getUserId());
        int activeExperiences = experienceDAO.countActiveExperiencesByHostId(user.getUserId());
        int totalAccommodations = accommodationDAO.countAccommodationsByHostId(user.getUserId());
        int activeAccommodations = accommodationDAO.countActiveAccommodationsByHostId(user.getUserId());
        
        request.setAttribute("totalExperiences", totalExperiences);
        request.setAttribute("activeExperiences", activeExperiences);
        request.setAttribute("totalAccommodations", totalAccommodations);
        request.setAttribute("activeAccommodations", activeAccommodations);
    }

    private boolean isHostAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        return user != null && 
               ("HOST".equals(user.getRole()) || "ADMIN".equals(user.getRole())) && 
               user.isActive();
    }
    
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (User) session.getAttribute("user");
    }
    
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("success", message);
    }
    
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("error", message);
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
    }
}