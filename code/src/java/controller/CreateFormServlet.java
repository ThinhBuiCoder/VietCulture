package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;
import model.Experience;
import model.Accommodation;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import dao.CategoryDAO;
import dao.CityDAO;
import dao.RegionDAO;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.sql.Time;
import utils.FileUploadUtils;

/**
 * Servlet để HIỂN THỊ FORM TẠO DỊCH VỤ và XỬ LÝ TẠO DỊCH VỤ
 * Xử lý cả trải nghiệm và lưu trú trong một servlet duy nhất
 */
@WebServlet(name = "CreateFormServlet", urlPatterns = {
    "/Travel/create_experience",        // Form + xử lý tạo trải nghiệm
    "/Travel/create_accommodation"      // Form + xử lý tạo lưu trú
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CreateFormServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CreateFormServlet.class.getName());
    
    // DAOs for form data and creation
    private CategoryDAO categoryDAO;
    private CityDAO cityDAO;
    private RegionDAO regionDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            categoryDAO = new CategoryDAO();
            cityDAO = new CityDAO();
            regionDAO = new RegionDAO();
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            LOGGER.info("CreateFormServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize CreateFormServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        LOGGER.info("Processing GET request for: " + servletPath);
        
        try {
            // Check authentication
            if (!isHostAuthenticated(request)) {
                LOGGER.info("User not authenticated as HOST, redirecting");
                redirectToCreateService(request, response, "Chỉ có Host mới được phép truy cập trang này.");
                return;
            }

            // Determine service type from URL
            String serviceType = determineServiceType(servletPath, request);
            
            // Validate service type
            if (!isValidServiceType(serviceType)) {
                LOGGER.warning("Invalid service type: " + serviceType);
                redirectToCreateService(request, response, "Loại dịch vụ không hợp lệ.");
                return;
            }

            // Load form data
            loadFormData(request);
            
            // Set page attributes
            setPageAttributes(request, serviceType);
            
            // Get user info
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            request.setAttribute("currentUser", user);
            
            // Forward to FORM JSP - FORM TẠO DỊCH VỤ
            request.getRequestDispatcher("/view/jsp/host/create_service_form.jsp")
                   .forward(request, response);
            
            LOGGER.info("Successfully forwarded to create_service_form.jsp with type: " + serviceType);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing create form request", e);
            handleError(request, response, "Có lỗi xảy ra khi tải trang. Vui lòng thử lại sau.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String serviceType = determineServiceType(servletPath, request);
        
        LOGGER.info("Processing POST request for service type: " + serviceType);
        
        try {
            // Check authentication
            if (!isHostAuthenticated(request)) {
                redirectToCreateService(request, response, "Phiên đăng nhập đã hết hạn.");
                return;
            }

            // Get current user
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            // Handle creation based on service type
            if ("experience".equals(serviceType)) {
                handleCreateExperience(request, response, user);
            } else if ("accommodation".equals(serviceType)) {
                handleCreateAccommodation(request, response, user);
            } else {
                redirectToCreateService(request, response, "Loại dịch vụ không hợp lệ.");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Có lỗi xảy ra khi tạo dịch vụ: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + servletPath);
        }
    }

    /**
     * Xử lý tạo trải nghiệm - CẢI TIẾN VỚI FORM DATA
     */
    private void handleCreateExperience(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        try {
            // Parse form data vào FormData object
            ExperienceFormData formData = parseExperienceForm(request);
            
            // Validate form data
            formData.validate();
            
            if (!formData.isValid()) {
                LOGGER.warning("Experience form validation failed: " + formData.getErrorMessage());
                HttpSession session = request.getSession();
                session.setAttribute("error", formData.getErrorMessage());
                session.setAttribute("formData", formData);
                response.sendRedirect(request.getContextPath() + "/Travel/create_experience");
                return;
            }

            LOGGER.info("Creating experience with title: " + formData.getTitle());
            
            // Create Experience object từ FormData
            Experience experience = createExperienceFromFormData(formData, user);
            
            // Handle image upload
            List<String> imageUrls = handleImageUpload(request, "experience");
            if (!imageUrls.isEmpty()) {
                experience.setImages(String.join(",", imageUrls));
            }

            // Save to database với transaction
            int experienceId = createExperienceWithTransaction(experience);
            
            if (experienceId > 0) {
                LOGGER.info("Experience created successfully with ID: " + experienceId);
                
                // Send notification email - SAFE CALL
                sendExperienceCreatedNotification(user, experience);
                
                HttpSession session = request.getSession();
                session.setAttribute("success", "Trải nghiệm đã được tạo và chờ admin duyệt!");
                response.sendRedirect(request.getContextPath() + "/Travel/create_service");
            } else {
                throw new RuntimeException("Không thể tạo trải nghiệm");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format in experience creation", e);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Dữ liệu số không hợp lệ. Vui lòng kiểm tra lại.");
            response.sendRedirect(request.getContextPath() + "/Travel/create_experience");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating experience", e);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Có lỗi xảy ra khi tạo trải nghiệm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Travel/create_experience");
        }
    }

    /**
     * Xử lý tạo chỗ lưu trú - CẢI TIẾN VỚI FORM DATA
     */
    private void handleCreateAccommodation(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        try {
            // Parse form data vào FormData object
            AccommodationFormData formData = parseAccommodationForm(request);
            
            // Validate form data
            formData.validate();
            
            if (!formData.isValid()) {
                LOGGER.warning("Accommodation form validation failed: " + formData.getErrorMessage());
                HttpSession session = request.getSession();
                session.setAttribute("error", formData.getErrorMessage());
                session.setAttribute("formData", formData);
                response.sendRedirect(request.getContextPath() + "/Travel/create_accommodation");
                return;
            }

            LOGGER.info("Creating accommodation with name: " + formData.getName());
            
            // Create Accommodation object từ FormData
            Accommodation accommodation = createAccommodationFromFormData(formData, user);
            
            // Handle image upload
            List<String> imageUrls = handleImageUpload(request, "accommodation");
            if (!imageUrls.isEmpty()) {
                accommodation.setImages(String.join(",", imageUrls));
            }

            // Save to database với transaction
            int accommodationId = createAccommodationWithTransaction(accommodation);
            
            if (accommodationId > 0) {
                LOGGER.info("Accommodation created successfully with ID: " + accommodationId);
                
                // Send notification email - SAFE CALL
                sendAccommodationCreatedNotification(user, accommodation);
                
                HttpSession session = request.getSession();
                session.setAttribute("success", "Chỗ lưu trú đã được tạo và chờ admin duyệt!");
                response.sendRedirect(request.getContextPath() + "/Travel/create_service");
            } else {
                throw new RuntimeException("Không thể tạo chỗ lưu trú");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format in accommodation creation", e);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Dữ liệu số không hợp lệ. Vui lòng kiểm tra lại.");
            response.sendRedirect(request.getContextPath() + "/Travel/create_accommodation");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating accommodation", e);
            HttpSession session = request.getSession();
            session.setAttribute("error", "Có lỗi xảy ra khi tạo chỗ lưu trú: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Travel/create_accommodation");
        }
    }

    /**
     * Xử lý upload hình ảnh - IMPROVED VERSION
     */
    private List<String> handleImageUpload(HttpServletRequest request, String serviceType) 
            throws IOException, ServletException {
        List<String> imageUrls = new ArrayList<>();
        
        try {
            // Sử dụng FileUploadUtils thay vì tự xử lý upload
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String fileName = null;
                    
                    if ("experience".equals(serviceType)) {
                        fileName = FileUploadUtils.uploadExperienceImage(part, request);
                    } else if ("accommodation".equals(serviceType)) {
                        fileName = FileUploadUtils.uploadAccommodationImage(part, request);
                    }
                    
                    if (fileName != null && !fileName.isEmpty()) {
                        imageUrls.add(fileName);
                        LOGGER.info("Image uploaded successfully: " + fileName);
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error uploading images", e);
        }
        
        return imageUrls;
    }

    /**
     * Check if string is null or empty
     */
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    // ==================== HELPER METHODS ĐỒNG NHẤT VỚI BOOKING ====================
    
    /**
     * Parse Experience form data từ request - FIXED PARAMETER MAPPING
     */
    private ExperienceFormData parseExperienceForm(HttpServletRequest request) {
        ExperienceFormData formData = new ExperienceFormData();
        
        try {
            formData.setTitle(request.getParameter("title"));
            formData.setDescription(request.getParameter("description"));
            formData.setLocation(request.getParameter("location"));
            formData.setType(request.getParameter("type"));
            
            // FIX: Consistent parameter names
            String language = request.getParameter("language");
            if (isNullOrEmpty(language)) {
                language = request.getParameter("languages"); // Fallback
            }
            formData.setLanguage(language);
            
            formData.setIncludedItems(request.getParameter("included"));
            formData.setRequirements(request.getParameter("requirements"));
            
            // Parse number fields
            String cityIdStr = request.getParameter("cityId");
            if (!isNullOrEmpty(cityIdStr)) {
                formData.setCityId(Integer.parseInt(cityIdStr));
            }
            
            String priceStr = request.getParameter("price");
            if (!isNullOrEmpty(priceStr)) {
                formData.setPrice(Double.parseDouble(priceStr));
            }
            
            String maxGroupSizeStr = request.getParameter("groupSize");
            if (isNullOrEmpty(maxGroupSizeStr)) {
                maxGroupSizeStr = request.getParameter("maxGroupSize"); // Alternative name
            }
            if (!isNullOrEmpty(maxGroupSizeStr)) {
                formData.setMaxGroupSize(Integer.parseInt(maxGroupSizeStr));
            }
            
            String durationStr = request.getParameter("duration");
            if (!isNullOrEmpty(durationStr)) {
                formData.setDuration(Integer.parseInt(durationStr));
            }
            
            // Handle difficulty conversion - CONSISTENT MAPPING
            String difficulty = request.getParameter("difficulty");
            if (!isNullOrEmpty(difficulty)) {
                switch (difficulty.toLowerCase()) {
                    case "dễ":
                    case "easy":
                        formData.setDifficulty("EASY");
                        break;
                    case "trung bình":
                    case "moderate":
                        formData.setDifficulty("MODERATE");
                        break;
                    case "khó":
                    case "challenging":
                        formData.setDifficulty("CHALLENGING");
                        break;
                    default:
                        formData.setDifficulty("MODERATE");
                }
            } else {
                formData.setDifficulty("MODERATE");
            }
            
            // Parse promotion fields - WITH NULL CHECKS
            String promotionPercentStr = request.getParameter("promotionPercent");
            if (!isNullOrEmpty(promotionPercentStr)) {
                int promotionPercent = Integer.parseInt(promotionPercentStr);
                if (promotionPercent >= 0 && promotionPercent <= 100) {
                    formData.setPromotionPercent(promotionPercent);
                }
            }
            
            String promotionStartStr = request.getParameter("promotionStart");
            if (!isNullOrEmpty(promotionStartStr)) {
                try {
                    formData.setPromotionStart(java.sql.Timestamp.valueOf(promotionStartStr.replace("T", " ") + ":00"));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Invalid promotion start date: " + promotionStartStr);
                }
            }
            
            String promotionEndStr = request.getParameter("promotionEnd");
            if (!isNullOrEmpty(promotionEndStr)) {
                try {
                    formData.setPromotionEnd(java.sql.Timestamp.valueOf(promotionEndStr.replace("T", " ") + ":00"));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Invalid promotion end date: " + promotionEndStr);
                }
            }
            
        } catch (NumberFormatException e) {
            formData.addError("Dữ liệu số không hợp lệ");
            LOGGER.log(Level.WARNING, "Number format error in experience form", e);
        }
        
        return formData;
    }
    
    /**
     * Parse Accommodation form data từ request - FIXED PARAMETER MAPPING
     */
    private AccommodationFormData parseAccommodationForm(HttpServletRequest request) {
        AccommodationFormData formData = new AccommodationFormData();
        
        try {
            // FIX: Consistent parameter handling
            String name = request.getParameter("title");
            if (isNullOrEmpty(name)) {
                name = request.getParameter("name"); // Alternative
            }
            formData.setName(name);
            
            formData.setDescription(request.getParameter("description"));
            
            String address = request.getParameter("address");
            if (isNullOrEmpty(address)) {
                address = request.getParameter("location"); // Alternative
            }
            formData.setAddress(address);
            
            // FIX: Consistent type parameter
            String type = request.getParameter("accommodationType");
            if (isNullOrEmpty(type)) {
                type = request.getParameter("type"); // Alternative
            }
            formData.setType(type);
            
            formData.setAmenities(request.getParameter("amenities"));
            
            // Parse number fields với error handling
            String cityIdStr = request.getParameter("cityId");
            if (!isNullOrEmpty(cityIdStr)) {
                formData.setCityId(Integer.parseInt(cityIdStr));
            }
            
            String priceStr = request.getParameter("price");
            if (!isNullOrEmpty(priceStr)) {
                formData.setPricePerNight(Double.parseDouble(priceStr));
            }
            
            String maxGuestsStr = request.getParameter("maxGuests");
            if (isNullOrEmpty(maxGuestsStr)) {
                maxGuestsStr = request.getParameter("maxOccupancy"); // Alternative
            }
            if (!isNullOrEmpty(maxGuestsStr)) {
                formData.setMaxOccupancy(Integer.parseInt(maxGuestsStr));
            } else {
                formData.setMaxOccupancy(2); // Default
            }
            
            String bedroomsStr = request.getParameter("bedrooms");
            if (isNullOrEmpty(bedroomsStr)) {
                bedroomsStr = request.getParameter("numberOfRooms"); // Alternative
            }
            if (!isNullOrEmpty(bedroomsStr)) {
                formData.setNumberOfRooms(Integer.parseInt(bedroomsStr));
            } else {
                formData.setNumberOfRooms(1); // Default
            }
            
            // Parse promotion fields - WITH VALIDATION
            String promotionPercentStr = request.getParameter("promotionPercent");
            if (!isNullOrEmpty(promotionPercentStr)) {
                int promotionPercent = Integer.parseInt(promotionPercentStr);
                if (promotionPercent >= 0 && promotionPercent <= 100) {
                    formData.setPromotionPercent(promotionPercent);
                }
            }
            
            String promotionStartStr = request.getParameter("promotionStart");
            if (!isNullOrEmpty(promotionStartStr)) {
                try {
                    formData.setPromotionStart(java.sql.Timestamp.valueOf(promotionStartStr.replace("T", " ") + ":00"));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Invalid promotion start date: " + promotionStartStr);
                }
            }
            
            String promotionEndStr = request.getParameter("promotionEnd");
            if (!isNullOrEmpty(promotionEndStr)) {
                try {
                    formData.setPromotionEnd(java.sql.Timestamp.valueOf(promotionEndStr.replace("T", " ") + ":00"));
                } catch (IllegalArgumentException e) {
                    LOGGER.warning("Invalid promotion end date: " + promotionEndStr);
                }
            }
            
        } catch (NumberFormatException e) {
            formData.addError("Dữ liệu số không hợp lệ");
            LOGGER.log(Level.WARNING, "Number format error in accommodation form", e);
        }
        
        return formData;
    }
    
    /**
     * Tạo Experience object từ FormData
     */
    private Experience createExperienceFromFormData(ExperienceFormData formData, User user) {
        Experience experience = new Experience();
        
        experience.setTitle(formData.getTitle().trim());
        experience.setDescription(formData.getDescription().trim());
        experience.setLocation(formData.getLocation().trim());
        experience.setPrice(formData.getPrice());
        experience.setHostId(user.getUserId());
        experience.setCityId(formData.getCityId());
        experience.setType(formData.getType());
        experience.setMaxGroupSize(formData.getMaxGroupSize());
        
        // Convert duration hours to TIME format
        experience.setDuration(new Time(formData.getDuration(), 0, 0));
        
        // Optional fields
        experience.setLanguage(formData.getLanguage());
        experience.setIncludedItems(formData.getIncludedItems());
        experience.setRequirements(formData.getRequirements());
        experience.setDifficulty(formData.getDifficulty());
        
        // Promotion fields
        experience.setPromotionPercent(formData.getPromotionPercent());
        experience.setPromotionStart(formData.getPromotionStart());
        experience.setPromotionEnd(formData.getPromotionEnd());
        
        // Set default values - QUAN TRỌNG: ĐỒNG NHẤT VỚI BOOKING
        experience.setActive(true); // Host muốn hiện
        experience.setAverageRating(0.0);
        experience.setTotalBookings(0);
        
        return experience;
    }
    
    /**
     * Tạo Accommodation object từ FormData
     */
    private Accommodation createAccommodationFromFormData(AccommodationFormData formData, User user) {
        Accommodation accommodation = new Accommodation();
        
        accommodation.setName(formData.getName().trim());
        accommodation.setDescription(formData.getDescription().trim());
        accommodation.setAddress(formData.getAddress().trim());
        accommodation.setPricePerNight(formData.getPricePerNight());
        accommodation.setType(formData.getType());
        accommodation.setCityId(formData.getCityId());
        accommodation.setHostId(user.getUserId());
        accommodation.setMaxOccupancy(formData.getMaxOccupancy());
        accommodation.setNumberOfRooms(formData.getNumberOfRooms());
        accommodation.setAmenities(formData.getAmenities());
        
        // Promotion fields
        accommodation.setPromotionPercent(formData.getPromotionPercent());
        accommodation.setPromotionStart(formData.getPromotionStart());
        accommodation.setPromotionEnd(formData.getPromotionEnd());
        
        // Set default values - QUAN TRỌNG: ĐỒNG NHẤT VỚI BOOKING
        accommodation.setActive(true); // Host muốn hiện
        accommodation.setAverageRating(0.0);
        accommodation.setTotalBookings(0);
        
        return accommodation;
    }
    
    /**
     * Tạo Experience với transaction - đồng nhất với booking
     */
    private int createExperienceWithTransaction(Experience experience) throws SQLException {
        try {
            return experienceDAO.createExperience(experience);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Transaction failed for experience creation", e);
            throw e;
        }
    }
    
    /**
     * Tạo Accommodation với transaction - đồng nhất với booking
     */
    private int createAccommodationWithTransaction(Accommodation accommodation) throws SQLException {
        try {
            return accommodationDAO.createAccommodation(accommodation);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Transaction failed for accommodation creation", e);
            throw e;
        }
    }
    
    /**
     * Gửi email notification khi tạo experience - SAFE VERSION
     */
    private void sendExperienceCreatedNotification(User user, Experience experience) {
        try {
            // COMMENT OUT until EmailUtils is implemented
            /*
            utils.EmailUtils.sendExperienceCreatedEmail(
                user.getEmail(),
                user.getFullName(),
                experience.getTitle(),
                experience.getPrice(),
                experience.getLocation()
            );
            */
            LOGGER.info("Experience created notification would be sent to: " + user.getEmail());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send experience created notification", e);
            // Không throw exception vì email không critical
        }
    }
    
    /**
     * Gửi email notification khi tạo accommodation - SAFE VERSION
     */
    private void sendAccommodationCreatedNotification(User user, Accommodation accommodation) {
        try {
            // COMMENT OUT until EmailUtils is implemented
            /*
            utils.EmailUtils.sendAccommodationCreatedEmail(
                user.getEmail(),
                user.getFullName(),
                accommodation.getName(),
                accommodation.getPricePerNight(),
                accommodation.getAddress()
            );
            */
            LOGGER.info("Accommodation created notification would be sent to: " + user.getEmail());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send accommodation created notification", e);
            // Không throw exception vì email không critical
        }
    }

    /**
     * Determine service type from URL path and parameters
     */
    private String determineServiceType(String servletPath, HttpServletRequest request) {
        // Check URL path first
        if (servletPath.contains("experience")) {
            return "experience";
        } else if (servletPath.contains("accommodation")) {
            return "accommodation";
        }
        
        // Check request parameter
        String typeParam = request.getParameter("type");
        if (typeParam != null && !typeParam.trim().isEmpty()) {
            return typeParam.trim().toLowerCase();
        }
        
        // Default to experience
        return "experience";
    }

    /**
     * Validate service type
     */
    private boolean isValidServiceType(String serviceType) {
        return "experience".equals(serviceType) || "accommodation".equals(serviceType);
    }

    /**
     * Set page attributes based on service type
     */
    private void setPageAttributes(HttpServletRequest request, String serviceType) {
        request.setAttribute("serviceType", serviceType);
        
        if ("experience".equals(serviceType)) {
            request.setAttribute("pageTitle", "Tạo Trải Nghiệm Mới");
            request.setAttribute("pageDescription", "Chia sẻ trải nghiệm văn hóa độc đáo của bạn");
        } else {
            request.setAttribute("pageTitle", "Tạo Chỗ Lưu Trú Mới");
            request.setAttribute("pageDescription", "Cho thuê nơi ở tuyệt vời cho du khách");
        }
    }

    /**
     * Load form data (regions, cities, categories)
     */
    private void loadFormData(HttpServletRequest request) {
        try {
            request.setAttribute("regions", regionDAO.getAllRegions());
            request.setAttribute("cities", cityDAO.getAllCities());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            
            LOGGER.info("Form data loaded successfully");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error loading form data", e);
            // Set empty lists to prevent JSP errors
            request.setAttribute("regions", new java.util.ArrayList<>());
            request.setAttribute("cities", new java.util.ArrayList<>());
            request.setAttribute("categories", new java.util.ArrayList<>());
        }
    }

    /**
     * Check if user is authenticated and has HOST role
     */
    private boolean isHostAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        return user != null && 
               ("HOST".equals(user.getRole()) || "ADMIN".equals(user.getRole())) && 
               user.isActive();
    }

    /**
     * Redirect to create service page with error message
     */
    private void redirectToCreateService(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("error", errorMessage);
        response.sendRedirect(request.getContextPath() + "/Travel/create_service");
    }

    /**
     * Handle errors by forwarding to error page
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        super.destroy();
        LOGGER.info("CreateFormServlet destroyed");
    }

    // ==================== FORM DATA CLASSES ====================
    // Đồng nhất với BookingFormData pattern
    
    /**
     * Experience Form Data class - đồng nhất với BookingFormData
     */
    public static class ExperienceFormData {
        private String title;
        private String description;
        private String location;
        private Integer cityId;
        private String type;
        private Double price;
        private Integer maxGroupSize;
        private Integer duration; // hours
        private String difficulty;
        private String language;
        private String includedItems;
        private String requirements;
        private String images;
        
        // Promotion fields
        private int promotionPercent;
        private java.sql.Timestamp promotionStart;
        private java.sql.Timestamp promotionEnd;
        
        private List<String> errors = new ArrayList<>();

        public ExperienceFormData() {}

        // Getters and Setters
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }

        public Integer getCityId() { return cityId; }
        public void setCityId(Integer cityId) { this.cityId = cityId; }

        public String getType() { return type; }
        public void setType(String type) { this.type = type; }

        public Double getPrice() { return price; }
        public void setPrice(Double price) { this.price = price; }

        public Integer getMaxGroupSize() { return maxGroupSize; }
        public void setMaxGroupSize(Integer maxGroupSize) { this.maxGroupSize = maxGroupSize; }

        public Integer getDuration() { return duration; }
        public void setDuration(Integer duration) { this.duration = duration; }

        public String getDifficulty() { return difficulty; }
        public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

        public String getLanguage() { return language; }
        public void setLanguage(String language) { this.language = language; }

        public String getIncludedItems() { return includedItems; }
        public void setIncludedItems(String includedItems) { this.includedItems = includedItems; }

        public String getRequirements() { return requirements; }
        public void setRequirements(String requirements) { this.requirements = requirements; }

        public String getImages() { return images; }
        public void setImages(String images) { this.images = images; }

        // Promotion getters and setters
        public int getPromotionPercent() { return promotionPercent; }
        public void setPromotionPercent(int promotionPercent) { this.promotionPercent = promotionPercent; }

        public java.sql.Timestamp getPromotionStart() { return promotionStart; }
        public void setPromotionStart(java.sql.Timestamp promotionStart) { this.promotionStart = promotionStart; }

        public java.sql.Timestamp getPromotionEnd() { return promotionEnd; }
        public void setPromotionEnd(java.sql.Timestamp promotionEnd) { this.promotionEnd = promotionEnd; }

        public List<String> getErrors() { return errors; }
        public void addError(String error) { this.errors.add(error); }
        public boolean isValid() { return errors.isEmpty(); }
        public String getErrorMessage() { return String.join(", ", errors); }

        // Validation methods - ENHANCED
        public void validate() {
            if (isNullOrEmpty(title)) {
                addError("Vui lòng nhập tiêu đề trải nghiệm");
            } else if (title.trim().length() < 5) {
                addError("Tiêu đề phải có ít nhất 5 ký tự");
            } else if (title.trim().length() > 200) {
                addError("Tiêu đề không được quá 200 ký tự");
            }
            
            if (isNullOrEmpty(description)) {
                addError("Vui lòng nhập mô tả chi tiết");
            } else if (description.trim().length() < 20) {
                addError("Mô tả phải có ít nhất 20 ký tự");
            }
            
            if (isNullOrEmpty(location)) {
                addError("Vui lòng nhập địa điểm");
            }
            
            if (cityId == null || cityId <= 0) {
                addError("Vui lòng chọn thành phố");
            }
            
            if (isNullOrEmpty(type)) {
                addError("Vui lòng chọn loại trải nghiệm");
            }
            
            if (price == null || price <= 0) {
                addError("Vui lòng nhập giá hợp lệ");
            } else if (price > 10000000) {
                addError("Giá không được vượt quá 10,000,000 VND");
            }
            
            if (maxGroupSize == null || maxGroupSize <= 0) {
                addError("Vui lòng nhập số lượng khách tối đa");
            } else if (maxGroupSize > 50) {
                addError("Số lượng khách tối đa không được vượt quá 50");
            }
            
            if (duration == null || duration <= 0) {
                addError("Vui lòng nhập thời gian diễn ra");
            } else if (duration > 24) {
                addError("Thời gian diễn ra không được vượt quá 24 giờ");
            }
            
            // Validate promotion dates
            if (promotionStart != null && promotionEnd != null) {
                if (promotionEnd.before(promotionStart)) {
                    addError("Ngày kết thúc khuyến mãi phải sau ngày bắt đầu");
                }
            }
        }

        private boolean isNullOrEmpty(String str) {
            return str == null || str.trim().isEmpty();
        }
    }

    /**
     * Accommodation Form Data class - đồng nhất với BookingFormData
     */
    public static class AccommodationFormData {
        private String name;
        private String description;
        private String address;
        private Integer cityId;
        private String type;
        private Double pricePerNight;
        private Integer numberOfRooms;
        private Integer maxOccupancy;
        private String amenities;
        private String images;
        
        // Promotion fields
        private int promotionPercent;
        private java.sql.Timestamp promotionStart;
        private java.sql.Timestamp promotionEnd;
        
        private List<String> errors = new ArrayList<>();

        public AccommodationFormData() {}

        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }

        public Integer getCityId() { return cityId; }
        public void setCityId(Integer cityId) { this.cityId = cityId; }

        public String getType() { return type; }
        public void setType(String type) { this.type = type; }

        public Double getPricePerNight() { return pricePerNight; }
        public void setPricePerNight(Double pricePerNight) { this.pricePerNight = pricePerNight; }

        public Integer getNumberOfRooms() { return numberOfRooms; }
        public void setNumberOfRooms(Integer numberOfRooms) { this.numberOfRooms = numberOfRooms; }

        public Integer getMaxOccupancy() { return maxOccupancy; }
        public void setMaxOccupancy(Integer maxOccupancy) { this.maxOccupancy = maxOccupancy; }

        public String getAmenities() { return amenities; }
        public void setAmenities(String amenities) { this.amenities = amenities; }

        public String getImages() { return images; }
        public void setImages(String images) { this.images = images; }

        // Promotion getters and setters
        public int getPromotionPercent() { return promotionPercent; }
        public void setPromotionPercent(int promotionPercent) { this.promotionPercent = promotionPercent; }

        public java.sql.Timestamp getPromotionStart() { return promotionStart; }
        public void setPromotionStart(java.sql.Timestamp promotionStart) { this.promotionStart = promotionStart; }

        public java.sql.Timestamp getPromotionEnd() { return promotionEnd; }
        public void setPromotionEnd(java.sql.Timestamp promotionEnd) { this.promotionEnd = promotionEnd; }

        public List<String> getErrors() { return errors; }
        public void addError(String error) { this.errors.add(error); }
        public boolean isValid() { return errors.isEmpty(); }
        public String getErrorMessage() { return String.join(", ", errors); }

        // Validation methods - ENHANCED
        public void validate() {
            if (isNullOrEmpty(name)) {
                addError("Vui lòng nhập tên chỗ lưu trú");
            } else if (name.trim().length() < 5) {
                addError("Tên chỗ lưu trú phải có ít nhất 5 ký tự");
            } else if (name.trim().length() > 200) {
                addError("Tên chỗ lưu trú không được quá 200 ký tự");
            }
            
            if (isNullOrEmpty(description)) {
                addError("Vui lòng nhập mô tả chi tiết");
            } else if (description.trim().length() < 20) {
                addError("Mô tả phải có ít nhất 20 ký tự");
            }
            
            if (isNullOrEmpty(address)) {
                addError("Vui lòng nhập địa chỉ");
            }
            
            if (cityId == null || cityId <= 0) {
                addError("Vui lòng chọn thành phố");
            }
            
            if (isNullOrEmpty(type)) {
                addError("Vui lòng chọn loại chỗ lưu trú");
            }
            
            if (pricePerNight == null || pricePerNight <= 0) {
                addError("Vui lòng nhập giá theo đêm hợp lệ");
            } else if (pricePerNight > 50000000) {
                addError("Giá theo đêm không được vượt quá 50,000,000 VND");
            }
            
            if (numberOfRooms == null || numberOfRooms <= 0) {
                addError("Vui lòng nhập số phòng");
            } else if (numberOfRooms > 20) {
                addError("Số phòng không được vượt quá 20");
            }
            
            if (maxOccupancy == null || maxOccupancy <= 0) {
                addError("Vui lòng nhập số khách tối đa");
            } else if (maxOccupancy > 50) {
                addError("Số khách tối đa không được vượt quá 50");
            }
            
            // Validate promotion dates
            if (promotionStart != null && promotionEnd != null) {
                if (promotionEnd.before(promotionStart)) {
                    addError("Ngày kết thúc khuyến mãi phải sau ngày bắt đầu");
                }
            }
        }

        private boolean isNullOrEmpty(String str) {
            return str == null || str.trim().isEmpty();
        }
    }
}