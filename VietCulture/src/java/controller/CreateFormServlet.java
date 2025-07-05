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
import java.io.File;
import java.sql.SQLException;
import java.sql.Time;

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
    
    // Upload directory
    private static final String UPLOAD_DIR = "uploads";

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
     * Xử lý tạo trải nghiệm
     */
private void handleCreateExperience(HttpServletRequest request, HttpServletResponse response, User user) 
        throws ServletException, IOException, SQLException {
    
    try {
        // Validate required fields (theo DB schema)
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location"); // REQUIRED trong DB
        String priceStr = request.getParameter("price");
        String durationStr = request.getParameter("duration");
        String cityIdStr = request.getParameter("cityId");
        String type = request.getParameter("type"); // REQUIRED trong DB
        String maxGroupSizeStr = request.getParameter("groupSize");
        
        LOGGER.info("Creating experience with title: " + title);
        
        // Kiểm tra required fields theo DB
        if (isNullOrEmpty(title) || isNullOrEmpty(description) || 
            isNullOrEmpty(location) || isNullOrEmpty(priceStr) || 
            isNullOrEmpty(durationStr) || isNullOrEmpty(cityIdStr) ||
            isNullOrEmpty(type) || isNullOrEmpty(maxGroupSizeStr)) {
            throw new IllegalArgumentException("Vui lòng điền đầy đủ thông tin bắt buộc");
        }

        // Create Experience object
        Experience experience = new Experience();
        experience.setTitle(title.trim());
        experience.setDescription(description.trim());
        experience.setLocation(location.trim()); // REQUIRED
        experience.setPrice(Double.parseDouble(priceStr));
        experience.setHostId(user.getUserId());
        experience.setCityId(Integer.parseInt(cityIdStr));
        experience.setType(type); // REQUIRED
        experience.setMaxGroupSize(Integer.parseInt(maxGroupSizeStr)); // REQUIRED
        
        // Handle duration (convert hours to TIME format)
        int durationHours = Integer.parseInt(durationStr);
        experience.setDuration(new Time(durationHours, 0, 0));
        
        // Optional fields
        experience.setLanguage(request.getParameter("languages")); // DB field: language
        experience.setIncludedItems(request.getParameter("included")); // DB field: includedItems
        experience.setRequirements(request.getParameter("requirements"));
        
        // Handle difficulty - convert to DB format
        String difficulty = request.getParameter("difficulty");
        if (!isNullOrEmpty(difficulty)) {
            // Convert Vietnamese to English for DB
            switch (difficulty) {
                case "Dễ":
                    experience.setDifficulty("EASY");
                    break;
                case "Trung bình":
                    experience.setDifficulty("MODERATE");
                    break;
                case "Khó":
                    experience.setDifficulty("CHALLENGING");
                    break;
                default:
                    experience.setDifficulty("MODERATE");
            }
        } else {
            experience.setDifficulty("MODERATE"); // Default
        }
        
        // *** THAY ĐỔI CHÍNH: Set isActive = 1 (tự động duyệt) ***
        experience.setActive(true); // isActive = 1 - TỰ ĐỘNG ĐƯỢC DUYỆT
        experience.setAverageRating(0.0); // DEFAULT 0
        experience.setTotalBookings(0); // DEFAULT 0
        // createdAt sẽ tự động set bởi DB (DEFAULT GETDATE())

        // Handle image upload
        List<String> imageUrls = handleImageUpload(request, "experience");
        if (!imageUrls.isEmpty()) {
            experience.setImages(String.join(",", imageUrls));
        }

        // Save to database
        int experienceId = experienceDAO.createExperience(experience);
        
        if (experienceId > 0) {
            LOGGER.info("Experience created successfully with ID: " + experienceId + " - AUTO APPROVED");
            LOGGER.info("Experience details - Title: " + experience.getTitle() + ", isActive: " + experience.isActive());
            HttpSession session = request.getSession();
            // *** THAY ĐỔI MESSAGE ***
            session.setAttribute("success", "Trải nghiệm đã được tạo và xuất bản thành công!");
            response.sendRedirect(request.getContextPath() + "/Travel/create_service");
        } else {
            LOGGER.severe("Failed to create experience");
            throw new RuntimeException("Không thể tạo trải nghiệm");
        }

    } catch (NumberFormatException e) {
        LOGGER.log(Level.WARNING, "Invalid number format in experience creation", e);
        throw new IllegalArgumentException("Dữ liệu số không hợp lệ");
    }
}

    /**
     * Xử lý tạo chỗ lưu trú
     */
    private void handleCreateAccommodation(HttpServletRequest request, HttpServletResponse response, User user) 
        throws ServletException, IOException, SQLException {
    
    try {
        // Validate required fields
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String accommodationType = request.getParameter("accommodationType");
        String cityIdStr = request.getParameter("cityId");
        String address = request.getParameter("address");
        
        LOGGER.info("Creating accommodation with title: " + title);
        
        if (isNullOrEmpty(title) || isNullOrEmpty(description) || 
            isNullOrEmpty(priceStr) || isNullOrEmpty(accommodationType) ||
            isNullOrEmpty(cityIdStr) || isNullOrEmpty(address)) {
            throw new IllegalArgumentException("Vui lòng điền đầy đủ thông tin bắt buộc");
        }

        // Create Accommodation object
        Accommodation accommodation = new Accommodation();
        accommodation.setName(title.trim()); // Note: DAO uses 'name' not 'title'
        accommodation.setDescription(description.trim());
        accommodation.setPricePerNight(Double.parseDouble(priceStr));
        accommodation.setType(accommodationType);
        accommodation.setCityId(Integer.parseInt(cityIdStr));
        accommodation.setHostId(user.getUserId());
        accommodation.setAddress(address.trim());
        
        // Parse number fields with defaults
        String maxGuestsStr = request.getParameter("maxGuests");
        String bedroomsStr = request.getParameter("bedrooms");
        String bathroomsStr = request.getParameter("bathrooms");
        
        // For DAO compatibility, use numberOfRooms instead of separate bedrooms/bathrooms
        int bedrooms = (bedroomsStr != null && !bedroomsStr.isEmpty()) ? Integer.parseInt(bedroomsStr) : 1;
        accommodation.setNumberOfRooms(bedrooms);
        
        accommodation.setAmenities(request.getParameter("amenities"));
        
        // *** THAY ĐỔI CHÍNH: Set isActive = 1 (tự động duyệt) ***
        accommodation.setActive(true); // isActive = 1 - TỰ ĐỘNG ĐƯỢC DUYỆT

        // Handle image upload
        List<String> imageUrls = handleImageUpload(request, "accommodation");
        if (!imageUrls.isEmpty()) {
            accommodation.setImages(String.join(",", imageUrls));
        }

        // Save to database
        int accommodationId = accommodationDAO.createAccommodation(accommodation);
        
        if (accommodationId > 0) {
            LOGGER.info("Accommodation created successfully with ID: " + accommodationId + " - AUTO APPROVED");
            HttpSession session = request.getSession();
            // *** THAY ĐỔI MESSAGE ***
            session.setAttribute("success", "Chỗ lưu trú đã được tạo và xuất bản thành công!");
            response.sendRedirect(request.getContextPath() + "/Travel/create_service");
        } else {
            throw new RuntimeException("Không thể tạo chỗ lưu trú");
        }

    } catch (NumberFormatException e) {
        LOGGER.log(Level.WARNING, "Invalid number format in accommodation creation", e);
        throw new IllegalArgumentException("Dữ liệu số không hợp lệ");
    }
}

    /**
     * Xử lý upload hình ảnh
     */
    private String sanitizeFileName(String fileName) {
    if (fileName == null) return "image";
    
    // Remove đường dẫn nếu có
    fileName = new File(fileName).getName();
    
    // Replace special characters
    fileName = fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    
    // Ensure không quá dài
    if (fileName.length() > 100) {
        String extension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = fileName.substring(dotIndex);
            fileName = fileName.substring(0, 100 - extension.length()) + extension;
        } else {
            fileName = fileName.substring(0, 100);
        }
    }
    
    return fileName;
}

private List<String> handleImageUpload(HttpServletRequest request, String serviceType) 
        throws IOException, ServletException {
    List<String> imageUrls = new ArrayList<>();
    
    try {
        // *** SỬA: Dùng đường dẫn giống ImageServlet ***
        String subDir = serviceType + "s"; // "experiences" hoặc "accommodations"
        String uploadPath = getServletContext().getRealPath("/") + File.separator + 
                           "view" + File.separator + "assets" + File.separator + 
                           "images" + File.separator + subDir;
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            LOGGER.info("Created upload directory: " + uploadPath + " (success: " + created + ")");
        }

        // Process image files
        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = getFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Validate file type
                    if (isValidImageFile(fileName)) {
                        // Generate unique filename
                        String uniqueFileName = System.currentTimeMillis() + "_" + sanitizeFileName(fileName);
                        String filePath = uploadPath + File.separator + uniqueFileName;
                        
                        // Save file
                        part.write(filePath);
                        
                        // *** SỬA: Store chỉ tên file (không có path) ***
                        imageUrls.add(uniqueFileName);
                        
                        LOGGER.info("Image uploaded successfully: " + filePath);
                    } else {
                        LOGGER.warning("Invalid image file type: " + fileName);
                    }
                }
            }
        }
    } catch (Exception e) {
        LOGGER.log(Level.WARNING, "Error uploading images", e);
    }
    
    return imageUrls;
}


    /**
     * Validate image file type
     */
    private boolean isValidImageFile(String fileName) {
        String lowerFileName = fileName.toLowerCase();
        return lowerFileName.endsWith(".jpg") || 
               lowerFileName.endsWith(".jpeg") || 
               lowerFileName.endsWith(".png") || 
               lowerFileName.endsWith(".gif");
    }

    /**
     * Extract filename from Part
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    /**
     * Check if string is null or empty
     */
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
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
}