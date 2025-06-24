package controller;

import dao.ExperienceDAO;
import dao.RegionDAO;
import dao.CityDAO;
import dao.CategoryDAO;
<<<<<<< HEAD
=======
import dao.FavoriteDAO;
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
import model.Experience;
import model.Region;
import model.City;
import model.Category;
<<<<<<< HEAD
=======
import model.User;
import service.FavoriteService;
import utils.DBUtils;
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
<<<<<<< HEAD
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet({"/experiences", "/experiences/*"})
public class ExperiencesServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ExperiencesServlet.class.getName());

    // Constants
    private static final int DEFAULT_PAGE_SIZE = 12;
    private static final int DEFAULT_PAGE = 1;

=======
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.sql.Time;

@WebServlet({"/experiences", "/experiences/*"})
public class ExperiencesServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ExperiencesServlet.class.getName());
    
    // Hằng số
    private static final int DEFAULT_PAGE_SIZE = 12;
    private static final int DEFAULT_PAGE = 1;
    
    // Các DAO và Service
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private ExperienceDAO experienceDAO;
    private RegionDAO regionDAO;
    private CityDAO cityDAO;
    private CategoryDAO categoryDAO;
<<<<<<< HEAD

=======
    private FavoriteService favoriteService;
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void init() throws ServletException {
        super.init();
        try {
<<<<<<< HEAD
=======
            // Khởi tạo các DAO
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            experienceDAO = new ExperienceDAO();
            regionDAO = new RegionDAO();
            cityDAO = new CityDAO();
            categoryDAO = new CategoryDAO();
<<<<<<< HEAD
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize DAOs", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.length() > 1) {
                // Handle individual experience view: /experiences/{id}
                handleExperienceDetail(request, response, pathInfo);
            } else {
                // Handle experiences list: /experiences
                handleExperiencesList(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in ExperiencesServlet", e);

            // Set error message for user
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi truy xuất dữ liệu. Vui lòng thử lại sau.");
            request.setAttribute("experiences", new ArrayList<Experience>());
            request.setAttribute("regions", new ArrayList<Region>());
            request.setAttribute("categories", new ArrayList<Category>());

            // Forward to JSP with error
            request.getRequestDispatcher("/view/jsp/home/experiences.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in ExperiencesServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Đã xảy ra lỗi không mong đợi.");
        }
    }

    /**
     * Handle experience detail view
     */
    private void handleExperienceDetail(HttpServletRequest request, HttpServletResponse response,
            String pathInfo) throws ServletException, IOException, SQLException {
        try {
            // Extract experience ID from path
            String experienceIdStr = pathInfo.substring(1); // Remove leading "/"
            int experienceId = Integer.parseInt(experienceIdStr);

            // Get experience details
            Experience experience = experienceDAO.getExperienceById(experienceId);

=======
            favoriteService = new FavoriteService();
            
            // Kiểm tra kết nối database
            testDatabaseConnection();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khởi tạo Servlet", e);
            throw new ServletException("Không thể khởi tạo servlet", e);
        }
    }
    
    // Kiểm tra kết nối database
    private void testDatabaseConnection() {
        try (Connection conn = DBUtils.getConnection()) {
            if (conn != null) {
                System.out.println("=== KIỂM TRA KẾT NỐI CSDL ===");
                System.out.println("Kết nối database thành công!");
                
                // Kiểm tra số lượng trải nghiệm
                try (var stmt = conn.createStatement();
                     var rs = stmt.executeQuery("SELECT COUNT(*) FROM Experiences")) {
                    if (rs.next()) {
                        System.out.println("Tổng số trải nghiệm: " + rs.getInt(1));
                    }
                }
                
                System.out.println("=== KẾT THÚC KIỂM TRA KẾT NỐI ===");
            } else {
                System.err.println("Kết nối database thất bại!");
                throw new SQLException("Không thể thiết lập kết nối database");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Cài đặt mã hóa UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.length() > 1) {
                // Xử lý chi tiết trải nghiệm: /experiences/{id}
                handleExperienceDetail(request, response, pathInfo);
            } else {
                // Xử lý danh sách trải nghiệm: /experiences
                handleExperiencesList(request, response);
            }
        } catch (SQLException e) {
            // Log chi tiết lỗi
            LOGGER.log(Level.SEVERE, "Lỗi truy vấn cơ sở dữ liệu", e);
            
            // Đặt thuộc tính lỗi
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi truy xuất dữ liệu: " + e.getMessage());
            request.setAttribute("experiences", new ArrayList<Experience>());
            request.setAttribute("regions", new ArrayList<Region>());
            request.setAttribute("categories", new ArrayList<Category>());
            
            // Chuyển đến trang JSP với thông báo lỗi
            request.getRequestDispatcher("/view/jsp/home/experiences.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi không mong đợi", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Đã xảy ra lỗi không mong đợi.");
        }
    }
    
    /**
     * Xử lý chi tiết trải nghiệm
     */
    private void handleExperienceDetail(HttpServletRequest request, HttpServletResponse response, 
                                       String pathInfo) throws ServletException, IOException, SQLException {
        try {
            // Trích xuất ID trải nghiệm từ đường dẫn
            String experienceIdStr = pathInfo.substring(1); // Loại bỏ dấu "/"
            int experienceId = Integer.parseInt(experienceIdStr);
            
            // Lấy chi tiết trải nghiệm
            Experience experience = experienceDAO.getExperienceById(experienceId);
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            if (experience == null || !experience.isActive()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trải nghiệm không tồn tại hoặc đã bị tạm ngừng.");
                return;
            }
<<<<<<< HEAD

            // Process experience data for detail view
            processExperienceForDetail(experience);

            // Load additional data for detail page
            loadDetailPageData(request);

            // Set experience data
            request.setAttribute("experience", experience);

            // Log access
            LOGGER.info("Experience detail accessed - ID: " + experienceId
                    + ", Title: " + experience.getTitle());

            // Forward to detail page
            request.getRequestDispatcher("/view/jsp/home/experience-detail.jsp")
                    .forward(request, response);

=======
            
            // Xử lý dữ liệu trải nghiệm cho trang chi tiết
            processExperienceForDetail(experience);
            
            // Tải dữ liệu bổ sung cho trang chi tiết
            loadDetailPageData(request);
            
            // Tải dữ liệu yêu thích của người dùng
            loadUserFavoritesData(request);
            
            // Đặt dữ liệu trải nghiệm
            request.setAttribute("experience", experience);
            
            // Ghi log truy cập
            LOGGER.info("Truy cập chi tiết trải nghiệm - ID: " + experienceId + 
                       ", Tiêu đề: " + experience.getTitle());
            
            // Chuyển đến trang chi tiết
            request.getRequestDispatcher("/view/jsp/home/experience-detail.jsp")
                   .forward(request, response);
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID trải nghiệm không hợp lệ.");
        }
    }
<<<<<<< HEAD

    /**
     * Handle experiences list view
     */
    private void handleExperiencesList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

=======
    
    /**
     * Xử lý danh sách trải nghiệm
     */
    private void handleExperiencesList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        // Debug logging
        System.out.println("=== TRẢI NGHIỆM DANH SÁCH DEBUG ===");
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Lấy parameters từ request
        String categoryParam = request.getParameter("category");
        String regionParam = request.getParameter("region");
        String cityParam = request.getParameter("city");
        String sortParam = request.getParameter("sort");
        String filterParam = request.getParameter("filter");
        String searchParam = request.getParameter("search");
        String pageParam = request.getParameter("page");
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Parse parameters
        Integer categoryId = parseInteger(categoryParam);
        Integer regionId = parseInteger(regionParam);
        Integer cityId = parseInteger(cityParam);
        int currentPage = parseInteger(pageParam, DEFAULT_PAGE);
<<<<<<< HEAD

        // Validate page number
        if (currentPage < 1) {
            currentPage = DEFAULT_PAGE;
        }

        // Calculate pagination
        int offset = (currentPage - 1) * DEFAULT_PAGE_SIZE;

=======
        
        // Validate số trang
        if (currentPage < 1) {
            currentPage = DEFAULT_PAGE;
        }
        
        // Tính toán phân trang
        int offset = (currentPage - 1) * DEFAULT_PAGE_SIZE;
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        List<Experience> experiences = new ArrayList<>();
        List<Region> regions = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        int totalExperiences = 0;
<<<<<<< HEAD

        try {
            // Load dropdown data for filters
            regions = regionDAO.getAllRegions();
            categories = categoryDAO.getAllCategories();

            // Get experiences based on filters
            experiences = getFilteredExperiences(
                    categoryId, regionId, cityId, sortParam, filterParam,
                    searchParam, offset, DEFAULT_PAGE_SIZE
            );

            // Process experiences for list view
            for (Experience experience : experiences) {
                processExperienceForList(experience);
            }

            // Get total count for pagination
            totalExperiences = getTotalFilteredExperiences(
                    categoryId, regionId, cityId, filterParam, searchParam
            );

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting experiences data", e);
            // Continue with empty lists - error will be shown in JSP
        }

        int totalPages = (int) Math.ceil((double) totalExperiences / DEFAULT_PAGE_SIZE);

        // Set attributes for JSP
=======
        
        try {
            // Tải dữ liệu dropdown cho bộ lọc
            regions = regionDAO.getAllRegions();
            categories = categoryDAO.getAllCategories();
            
            // Lấy trải nghiệm dựa trên bộ lọc
            experiences = getFilteredExperiences(
                categoryId, regionId, cityId, sortParam, filterParam, 
                searchParam, offset, DEFAULT_PAGE_SIZE
            );
            
            System.out.println("Tìm thấy " + experiences.size() + " trải nghiệm");
            
            // Xử lý trải nghiệm cho danh sách
            for (Experience experience : experiences) {
                processExperienceForList(experience);
            }
            
            // Lấy tổng số để phân trang
            totalExperiences = getTotalFilteredExperiences(
                categoryId, regionId, cityId, filterParam, searchParam
            );
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Lỗi lấy dữ liệu trải nghiệm", e);
            // Tiếp tục với danh sách rỗng - lỗi sẽ được hiển thị trong JSP
        }
        
        int totalPages = (int) Math.ceil((double) totalExperiences / DEFAULT_PAGE_SIZE);
        
        // Tải dữ liệu yêu thích người dùng
        loadUserFavoritesData(request);
        
        // Đặt thuộc tính cho JSP
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        request.setAttribute("experiences", experiences);
        request.setAttribute("regions", regions);
        request.setAttribute("categories", categories);
        request.setAttribute("totalExperiences", totalExperiences);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);
<<<<<<< HEAD

        // Preserve search parameters for pagination
=======
        
        // Lưu các tham số tìm kiếm cho phân trang
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        StringBuilder queryString = new StringBuilder();
        appendParam(queryString, "category", categoryParam);
        appendParam(queryString, "region", regionParam);
        appendParam(queryString, "city", cityParam);
        appendParam(queryString, "sort", sortParam);
        appendParam(queryString, "filter", filterParam);
        appendParam(queryString, "search", searchParam);
<<<<<<< HEAD

        request.setAttribute("queryString", queryString.toString());

        // Set filter parameters back to JSP for form state
=======
        
        request.setAttribute("queryString", queryString.toString());
        
        // Đặt lại các tham số lọc cho JSP
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        request.setAttribute("selectedCategory", categoryParam);
        request.setAttribute("selectedRegion", regionParam);
        request.setAttribute("selectedCity", cityParam);
        request.setAttribute("selectedSort", sortParam);
        request.setAttribute("selectedFilter", filterParam);
        request.setAttribute("searchKeyword", searchParam);
<<<<<<< HEAD

        // Log request info
        LOGGER.info("Experiences page accessed - Filters: category=" + categoryParam
                + ", region=" + regionParam + ", city=" + cityParam
                + ", page=" + currentPage + ", total=" + totalExperiences);

        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/home/experiences.jsp").forward(request, response);
    }

    /**
     * Process experience data for detail view
     */
    private void processExperienceForDetail(Experience experience) throws SQLException {
        // Process images - tách chuỗi images thành mảng
        if (experience.getImages() != null && !experience.getImages().trim().isEmpty()) {
            String[] imageArray = experience.getImages().split(",");
            if (imageArray.length > 0) {
                // Set first image cho detail view
                experience.setFirstImage(imageArray[0].trim());
            }
        }

        // Get category name từ type
        String categoryName = getCategoryNameByType(experience.getType());
        experience.setCategoryName(categoryName);
    }

    /**
     * Process experience data for list view
     */
    private void processExperienceForList(Experience experience) throws SQLException {
        // Process images for list view
=======
        
        // Ghi log thông tin request
        LOGGER.info("Truy cập trang trải nghiệm - Bộ lọc: category=" + categoryParam + 
                   ", region=" + regionParam + ", city=" + cityParam + 
                   ", page=" + currentPage + ", total=" + totalExperiences);
        
        System.out.println("Chuyển đến JSP với " + experiences.size() + " trải nghiệm");
        
        // Chuyển đến JSP
        request.getRequestDispatcher("/view/jsp/home/experiences.jsp").forward(request, response);
    }
    
    /**
     * Tải dữ liệu yêu thích người dùng
     */
   private void loadUserFavoritesData(HttpServletRequest request) {
    System.out.println("=== ENHANCED FAVORITES DEBUG START ===");
    
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");
    
    // Khởi tạo set để lưu ID yêu thích
    Set<Integer> userFavoriteExperienceIds = new HashSet<>();
    Set<Integer> userFavoriteAccommodationIds = new HashSet<>();
    
    // Debug thông tin người dùng
    System.out.println("User: " + (user != null ? user.getFullName() : "null"));
    System.out.println("Role: " + (user != null ? user.getRole() : "null"));
    
    if (user != null && "TRAVELER".equals(user.getRole())) {
        try {
            System.out.println("Đang lấy danh sách yêu thích cho userId: " + user.getUserId());
            
            // Sử dụng dịch vụ để lấy ID các mục yêu thích
            Map<String, Object> favoriteData = favoriteService.getUserFavoriteIds(user.getUserId());
            
            System.out.println("Kết quả favorite data: " + favoriteData);
            
            if (favoriteData != null && Boolean.TRUE.equals(favoriteData.get("success"))) {
                // Ép kiểu an toàn cho các danh sách ID
                @SuppressWarnings("unchecked")
                List<Integer> experienceIds = (List<Integer>) favoriteData.get("experienceIds");
                @SuppressWarnings("unchecked")
                List<Integer> accommodationIds = (List<Integer>) favoriteData.get("accommodationIds");
                
                // Debug thông tin ID
                System.out.println("Experience IDs từ service: " + experienceIds);
                System.out.println("Accommodation IDs từ service: " + accommodationIds);
                
                // Thêm ID vào set
                if (experienceIds != null) {
                    userFavoriteExperienceIds.addAll(experienceIds);
                    System.out.println("Đã thêm " + experienceIds.size() + " experience IDs");
                }
                
                if (accommodationIds != null) {
                    userFavoriteAccommodationIds.addAll(accommodationIds);
                    System.out.println("Đã thêm " + accommodationIds.size() + " accommodation IDs");
                }
            } else {
                System.err.println("Lấy danh sách yêu thích không thành công");
                System.err.println("Chi tiết: " + favoriteData);
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi chi tiết khi lấy danh sách yêu thích:");
            e.printStackTrace();
        }
    } else {
        System.out.println("Không phải TRAVELER hoặc chưa đăng nhập");
    }
    
    // QUAN TRỌNG: Đảm bảo đặt thuộc tính với tên chính xác
    request.setAttribute("userFavoriteExperienceIds", userFavoriteExperienceIds);
    request.setAttribute("userFavoriteAccommodationIds", userFavoriteAccommodationIds);
    
    // Debug thông tin cuối cùng
    System.out.println("Favorite Experience IDs cuối cùng: " + userFavoriteExperienceIds);
    System.out.println("Favorite Accommodation IDs cuối cùng: " + userFavoriteAccommodationIds);
    
    System.out.println("=== KẾT THÚC FAVORITES DEBUG ===");
}
    
    /**
     * Xử lý dữ liệu trải nghiệm cho chi tiết
     */
    private void processExperienceForDetail(Experience experience) throws SQLException {
        // Xử lý hình ảnh - tách chuỗi images thành mảng
        if (experience.getImages() != null && !experience.getImages().trim().isEmpty()) {
            String[] imageArray = experience.getImages().split(",");
            if (imageArray.length > 0) {
                // Đặt hình ảnh đầu tiên cho trang chi tiết
                experience.setFirstImage(imageArray[0].trim());
            }
        }
        
        // Lấy tên danh mục từ type
        String categoryName = getCategoryNameByType(experience.getType());
        experience.setCategoryName(categoryName);
    }
    
    /**
     * Xử lý dữ liệu trải nghiệm cho danh sách
     */
    private void processExperienceForList(Experience experience) throws SQLException {
        // Xử lý hình ảnh cho danh sách
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        if (experience.getImages() != null && !experience.getImages().trim().isEmpty()) {
            String[] imageArray = experience.getImages().split(",");
            if (imageArray.length > 0) {
                experience.setFirstImage(imageArray[0].trim());
            }
        }
<<<<<<< HEAD

        // Get category name
        String categoryName = getCategoryNameByType(experience.getType());
        experience.setCategoryName(categoryName);
    }

    /**
     * Load additional data for detail page
     */
    private void loadDetailPageData(HttpServletRequest request) throws SQLException {
        try {
            // Load regions cho dropdown (nếu cần)
            List<Region> regions = regionDAO.getAllRegions();
            request.setAttribute("regions", regions);

            // Load categories
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error loading additional data for detail page", e);
            throw e;
        }
    }

    /**
     * Get category name từ type
     */
    private String getCategoryNameByType(String type) throws SQLException {
        if (type == null) {
            return null;
        }

=======
        
        // Lấy tên danh mục
        String categoryName = getCategoryNameByType(experience.getType());
        experience.setCategoryName(categoryName);
    }
    
    /**
     * Tải dữ liệu bổ sung cho trang chi tiết
     */
    private void loadDetailPageData(HttpServletRequest request) throws SQLException {
        try {
            // Tải vùng miền cho dropdown (nếu cần)
            List<Region> regions = regionDAO.getAllRegions();
            request.setAttribute("regions", regions);
            
            // Tải danh mục
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Lỗi tải dữ liệu bổ sung cho trang chi tiết", e);
            throw e;
        }
    }
    
    /**
     * Lấy tên danh mục từ type
     */
    private String getCategoryNameByType(String type) throws SQLException {
        if (type == null) return null;
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        try {
            List<Category> categories = categoryDAO.getAllCategories();
            for (Category category : categories) {
                if (type.equals(category.getName())) {
                    return category.getName();
                }
            }
        } catch (SQLException e) {
<<<<<<< HEAD
            LOGGER.log(Level.WARNING, "Error getting category name for type: " + type, e);
        }
        return type; // Return original type if not found
    }

    /**
     * Get filtered experiences based on search criteria
     */
    private List<Experience> getFilteredExperiences(Integer categoryId, Integer regionId,
            Integer cityId, String sort, String filter, String search,
            int offset, int limit) throws SQLException {

        try {
            // Apply filter logic
=======
            LOGGER.log(Level.WARNING, "Lỗi lấy tên danh mục cho type: " + type, e);
        }
        return type; // Trả về type gốc nếu không tìm thấy
    }
    
    /**
     * Lấy trải nghiệm theo bộ lọc
     */
    private List<Experience> getFilteredExperiences(Integer categoryId, Integer regionId, 
            Integer cityId, String sort, String filter, String search, 
            int offset, int limit) throws SQLException {
        
        try {
            // Áp dụng logic lọc
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            if ("popular".equals(filter)) {
                return experienceDAO.getPopularExperiences(offset, limit);
            } else if ("newest".equals(filter)) {
                return experienceDAO.getNewestExperiences(offset, limit);
            } else if ("top-rated".equals(filter)) {
                return experienceDAO.getTopRatedExperiences(offset, limit);
            } else if ("low-price".equals(filter)) {
                return experienceDAO.getLowPriceExperiences(offset, limit);
            } else {
<<<<<<< HEAD
                // General search with filters
                return experienceDAO.searchExperiences(categoryId, regionId, cityId,
                        search, sort, offset, limit);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting filtered experiences", e);
            throw e;
        }
    }

    /**
     * Get total count of filtered experiences for pagination
     */
    private int getTotalFilteredExperiences(Integer categoryId, Integer regionId,
            Integer cityId, String filter, String search) throws SQLException {

=======
                // Tìm kiếm chung với các bộ lọc
                return experienceDAO.searchExperiences(categoryId, regionId, cityId, 
                                                     search, sort, offset, limit);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy trải nghiệm theo bộ lọc", e);
            throw e;
        }
    }
    
    /**
     * Lấy tổng số trải nghiệm cho phân trang
     */
    private int getTotalFilteredExperiences(Integer categoryId, Integer regionId, 
            Integer cityId, String filter, String search) throws SQLException {
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        try {
            if ("popular".equals(filter)) {
                return experienceDAO.getPopularExperiencesCount();
            } else if ("newest".equals(filter)) {
                return experienceDAO.getNewestExperiencesCount();
            } else if ("top-rated".equals(filter)) {
                return experienceDAO.getTopRatedExperiencesCount();
            } else if ("low-price".equals(filter)) {
                return experienceDAO.getLowPriceExperiencesCount();
            } else {
<<<<<<< HEAD
                return experienceDAO.getFilteredExperiencesCount(categoryId, regionId,
                        cityId, search);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting filtered experiences count", e);
            throw e;
        }
    }

    /**
     * Parse integer parameter with default value
=======
                return experienceDAO.getFilteredExperiencesCount(categoryId, regionId, 
                                                               cityId, search);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy số lượng trải nghiệm theo bộ lọc", e);
            throw e;
        }
    }
    
    /**
     * Parse integer parameter
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     */
    private Integer parseInteger(String param) {
        return parseInteger(param, null);
    }
<<<<<<< HEAD

    /**
     * Parse integer parameter with default value
=======
    
    /**
     * Parse integer parameter với giá trị mặc định
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     */
    private Integer parseInteger(String param, Integer defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
<<<<<<< HEAD
            LOGGER.log(Level.WARNING, "Invalid integer parameter: " + param);
            return defaultValue;
        }
    }

    /**
     * Append parameter to query string for pagination
=======
            LOGGER.log(Level.WARNING, "Tham số integer không hợp lệ: " + param);
            return defaultValue;
        }
    }
    
    /**
     * Thêm parameter vào query string cho phân trang
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     */
    private void appendParam(StringBuilder queryString, String name, String value) {
        if (value != null && !value.trim().isEmpty()) {
            if (queryString.length() > 0) {
                queryString.append("&");
            }
            try {
                queryString.append(name).append("=")
<<<<<<< HEAD
                        .append(java.net.URLEncoder.encode(value, "UTF-8"));
=======
                          .append(java.net.URLEncoder.encode(value, "UTF-8"));
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            } catch (java.io.UnsupportedEncodingException e) {
                queryString.append(name).append("=").append(value);
            }
        }
    }
<<<<<<< HEAD

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET to prevent form resubmission
        response.sendRedirect(request.getRequestURI()
                + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
    }
}
=======
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chuyển hướng POST sang GET để tránh gửi lại form
        response.sendRedirect(request.getRequestURI() + 
                            (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
