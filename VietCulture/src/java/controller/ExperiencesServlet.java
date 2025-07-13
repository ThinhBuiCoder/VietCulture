package controller;

import dao.ExperienceDAO;
import dao.RegionDAO;
import dao.CityDAO;
import dao.CategoryDAO;
import dao.BookingDAO;
import dao.ReviewDAO;
import model.Experience;
import model.Region;
import model.City;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

    private ExperienceDAO experienceDAO;
    private RegionDAO regionDAO;
    private CityDAO cityDAO;
    private CategoryDAO categoryDAO;
    private BookingDAO bookingDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            experienceDAO = new ExperienceDAO();
            regionDAO = new RegionDAO();
            cityDAO = new CityDAO();
            categoryDAO = new CategoryDAO();
            bookingDAO = new BookingDAO();
            reviewDAO = new ReviewDAO();
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
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Đã xảy ra lỗi không mong đợi.");
            }
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

            if (experience == null || !experience.isActive()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trải nghiệm không tồn tại hoặc đã bị tạm ngừng.");
                return;
            }

            // Process experience data for detail view
            processExperienceForDetail(experience);

            // Load additional data for detail page
            loadDetailPageData(request);

            // Set experience data
            request.setAttribute("experience", experience);

            // Lấy danh sách review động cho trải nghiệm này
            List<model.Review> reviews = reviewDAO.getReviewsByExperienceId(experienceId);
            request.setAttribute("reviews", reviews);

            // Kiểm tra booking để truyền biến hasBooked cho review
            boolean hasBooked = false;
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                model.User user = (model.User) session.getAttribute("user");
                try {
                    hasBooked = bookingDAO.getTotalBookingsByUserAndExperience(user.getUserId(), experience.getExperienceId()) > 0;
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Error checking booking for review", ex);
                }
            }
            request.setAttribute("hasBooked", hasBooked);

            // Thêm dòng này để quyền báo cáo hoạt động đúng
            boolean canReportExperience = hasBooked;
            request.setAttribute("canReportExperience", canReportExperience);

            // Log access
            LOGGER.info("Experience detail accessed - ID: " + experienceId
                    + ", Title: " + experience.getTitle());

            // Forward to detail page
            request.getRequestDispatcher("/view/jsp/home/experience-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID trải nghiệm không hợp lệ.");
        }
    }

    /**
     * Handle experiences list view
     */
    private void handleExperiencesList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        // Lấy parameters từ request
        String categoryParam = request.getParameter("category");
        String regionParam = request.getParameter("region");
        String cityParam = request.getParameter("city");
        String sortParam = request.getParameter("sort");
        String filterParam = request.getParameter("filter");
        String searchParam = request.getParameter("search");
        String pageParam = request.getParameter("page");
        
        // Distance filtering parameters
        String distanceParam = request.getParameter("distance");
        String latParam = request.getParameter("lat");
        String lngParam = request.getParameter("lng");

        // Parse parameters
        Integer categoryId = parseInteger(categoryParam);
        Integer regionId = parseInteger(regionParam);
        Integer cityId = parseInteger(cityParam);
        int currentPage = parseInteger(pageParam, DEFAULT_PAGE);
        
        // Parse distance filtering parameters
        Double maxDistance = parseDouble(distanceParam);
        Double userLat = parseDouble(latParam);
        Double userLng = parseDouble(lngParam);

        // Validate page number
        if (currentPage < 1) {
            currentPage = DEFAULT_PAGE;
        }

        // Calculate pagination
        int offset = (currentPage - 1) * DEFAULT_PAGE_SIZE;

        List<Experience> experiences = new ArrayList<>();
        List<Region> regions = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        int totalExperiences = 0;

        try {
            // Load dropdown data for filters
            regions = regionDAO.getAllRegions();
            categories = categoryDAO.getAllCategories();

            // Get experiences based on filters (including distance)
            experiences = getFilteredExperiencesWithDistance(
                    categoryId, regionId, cityId, sortParam, filterParam,
                    searchParam, userLat, userLng, maxDistance, offset, DEFAULT_PAGE_SIZE
            );

            // Process experiences for list view
            for (Experience experience : experiences) {
                processExperienceForList(experience);
            }

            // Get total count for pagination (including distance)
            totalExperiences = getTotalFilteredExperiencesWithDistance(
                    categoryId, regionId, cityId, filterParam, searchParam,
                    userLat, userLng, maxDistance
            );

            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalExperiences / DEFAULT_PAGE_SIZE);

            // Set pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalExperiences", totalExperiences);
            request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

            // Create pagination URL with all current parameters including distance
            StringBuilder paginationUrl = new StringBuilder("/experiences?");
            appendParam(paginationUrl, "category", categoryParam);
            appendParam(paginationUrl, "region", regionParam);
            appendParam(paginationUrl, "city", cityParam);
            appendParam(paginationUrl, "sort", sortParam);
            appendParam(paginationUrl, "filter", filterParam);
            appendParam(paginationUrl, "search", searchParam);
            appendParam(paginationUrl, "distance", distanceParam);
            appendParam(paginationUrl, "lat", latParam);
            appendParam(paginationUrl, "lng", lngParam);

            request.setAttribute("paginationUrl", paginationUrl.toString());

            LOGGER.info("Loaded " + experiences.size() + " experiences for page " + currentPage);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading experiences list", e);
            // Set empty lists and error message
            experiences = new ArrayList<>();
            regions = new ArrayList<>();
            categories = new ArrayList<>();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu trải nghiệm.");
        }

        // Set attributes for JSP
        request.setAttribute("experiences", experiences);
        request.setAttribute("regions", regions);
        request.setAttribute("categories", categories);

        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/home/experiences.jsp")
                .forward(request, response);
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
        if (experience.getImages() != null && !experience.getImages().trim().isEmpty()) {
            String[] imageArray = experience.getImages().split(",");
            if (imageArray.length > 0) {
                experience.setFirstImage(imageArray[0].trim());
            }
        }

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

        try {
            List<Category> categories = categoryDAO.getAllCategories();
            for (Category category : categories) {
                if (type.equals(category.getName())) {
                    return category.getName();
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting category name for type: " + type, e);
        }
        return type; // Return original type if not found
    }

    /**
     * Get filtered experiences based on search criteria including distance
     */
    private List<Experience> getFilteredExperiencesWithDistance(Integer categoryId, Integer regionId,
            Integer cityId, String sort, String filter, String search,
            Double userLat, Double userLng, Double maxDistance,
            int offset, int limit) throws SQLException {

        try {
            // If we have distance filtering, use the new method
            if (userLat != null && userLng != null && maxDistance != null) {
                return experienceDAO.searchExperiencesWithDistance(categoryId, regionId, cityId,
                        search, sort, userLat, userLng, maxDistance, offset, limit);
            }
            
            // Otherwise use regular filtering
            // Apply filter logic
            if ("popular".equals(filter)) {
                return experienceDAO.getPopularExperiences(offset, limit);
            } else if ("newest".equals(filter)) {
                return experienceDAO.getNewestExperiences(offset, limit);
            } else if ("top-rated".equals(filter)) {
                return experienceDAO.getTopRatedExperiences(offset, limit);
            } else if ("low-price".equals(filter)) {
                return experienceDAO.getLowPriceExperiences(offset, limit);
            } else {
                // General search with filters
                return experienceDAO.searchExperiences(categoryId, regionId, cityId,
                        search, sort, offset, limit);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting filtered experiences with distance", e);
            throw e;
        }
    }

    /**
     * Get total count of filtered experiences for pagination including distance
     */
    private int getTotalFilteredExperiencesWithDistance(Integer categoryId, Integer regionId,
            Integer cityId, String filter, String search,
            Double userLat, Double userLng, Double maxDistance) throws SQLException {

        try {
            // If we have distance filtering, use the new method
            if (userLat != null && userLng != null && maxDistance != null) {
                return experienceDAO.getFilteredExperiencesCountWithDistance(categoryId, regionId, cityId,
                        search, userLat, userLng, maxDistance);
            }
            
            // Otherwise use regular counting
            if ("popular".equals(filter) || "newest".equals(filter) || 
                "top-rated".equals(filter) || "low-price".equals(filter)) {
                // For these filters, we need to count all and apply business logic
                // This is simplified - in a real app you'd have specific count methods
                return experienceDAO.getFilteredExperiencesCount(categoryId, regionId, cityId, search);
            } else {
                return experienceDAO.getFilteredExperiencesCount(categoryId, regionId, cityId, search);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting count of filtered experiences with distance", e);
            throw e;
        }
    }

    /**
     * Parse integer parameter with default value
     */
    private Integer parseInteger(String param) {
        return parseInteger(param, null);
    }

    /**
     * Parse integer parameter with default value
     */
    private Integer parseInteger(String param, Integer defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid integer parameter: " + param);
            return defaultValue;
        }
    }

    /**
     * Parse double parameter with default value
     */
    private Double parseDouble(String param) {
        return parseDouble(param, null);
    }

    /**
     * Parse double parameter with default value
     */
    private Double parseDouble(String param, Double defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(param.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid double parameter: " + param);
            return defaultValue;
        }
    }

    /**
     * Append parameter to query string for pagination
     */
    private void appendParam(StringBuilder queryString, String name, String value) {
        if (value != null && !value.trim().isEmpty()) {
            if (queryString.length() > 0) {
                queryString.append("&");
            }
            try {
                queryString.append(name).append("=")
                        .append(java.net.URLEncoder.encode(value, "UTF-8"));
            } catch (java.io.UnsupportedEncodingException e) {
                queryString.append(name).append("=").append(value);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET to prevent form resubmission
        response.sendRedirect(request.getRequestURI()
                + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
    }
}
