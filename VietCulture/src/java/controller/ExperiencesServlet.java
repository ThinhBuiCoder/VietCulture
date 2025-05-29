package controller;

import dao.ExperienceDAO;
import dao.RegionDAO;
import dao.CityDAO;
import dao.CategoryDAO;
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

@WebServlet("/experiences")
public class ExperiencesServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ExperiencesServlet.class.getName());
    
    // Constants
    private static final int DEFAULT_PAGE_SIZE = 12;
    private static final int DEFAULT_PAGE = 1;
    
    private ExperienceDAO experienceDAO;
    private RegionDAO regionDAO;
    private CityDAO cityDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        experienceDAO = new ExperienceDAO();
        regionDAO = new RegionDAO();
        cityDAO = new CityDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy parameters từ request
            String categoryParam = request.getParameter("category");
            String regionParam = request.getParameter("region");
            String cityParam = request.getParameter("city");
            String sortParam = request.getParameter("sort");
            String filterParam = request.getParameter("filter");
            String searchParam = request.getParameter("search");
            String pageParam = request.getParameter("page");
            
            // Parse parameters
            Integer categoryId = parseInteger(categoryParam);
            Integer regionId = parseInteger(regionParam);
            Integer cityId = parseInteger(cityParam);
            int currentPage = parseInteger(pageParam, DEFAULT_PAGE);
            
            // Validate page number
            if (currentPage < 1) {
                currentPage = DEFAULT_PAGE;
            }
            
            // Calculate pagination
            int offset = (currentPage - 1) * DEFAULT_PAGE_SIZE;
            
            // Load dropdown data for filters
            loadFilterData(request);
            
            // Get experiences based on filters
            List<Experience> experiences = getFilteredExperiences(
                categoryId, regionId, cityId, sortParam, filterParam, 
                searchParam, offset, DEFAULT_PAGE_SIZE
            );
            
            // Get total count for pagination
            int totalExperiences = getTotalFilteredExperiences(
                categoryId, regionId, cityId, filterParam, searchParam
            );
            
            int totalPages = (int) Math.ceil((double) totalExperiences / DEFAULT_PAGE_SIZE);
            
            // Set attributes for JSP
            request.setAttribute("experiences", experiences);
            request.setAttribute("totalExperiences", totalExperiences);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);
            
            // Preserve search parameters for pagination
            StringBuilder queryString = new StringBuilder();
            appendParam(queryString, "category", categoryParam);
            appendParam(queryString, "region", regionParam);
            appendParam(queryString, "city", cityParam);
            appendParam(queryString, "sort", sortParam);
            appendParam(queryString, "filter", filterParam);
            appendParam(queryString, "search", searchParam);
            
            request.setAttribute("queryString", queryString.toString());
            
            // Log request info
            LOGGER.info("Experiences page accessed - Filters: category=" + categoryParam + 
                       ", region=" + regionParam + ", city=" + cityParam + 
                       ", page=" + currentPage + ", total=" + totalExperiences);
            
            // Forward to JSP
            request.getRequestDispatcher("/view/jsp/home/experiences.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in ExperiencesServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Đã xảy ra lỗi khi tải danh sách trải nghiệm");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in ExperiencesServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Đã xảy ra lỗi không mong muốn");
        }
    }
    
    /**
     * Load filter data (regions, categories) for dropdowns
     */
    private void loadFilterData(HttpServletRequest request) throws SQLException {
        try {
            // Load regions
            List<Region> regions = regionDAO.getAllRegions();
            request.setAttribute("regions", regions);
            
            // Load categories
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            
            LOGGER.info("Filter data loaded - Regions: " + regions.size() + 
                       ", Categories: " + categories.size());
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error loading filter data", e);
            // Set empty lists to prevent JSP errors
            request.setAttribute("regions", new ArrayList<Region>());
            request.setAttribute("categories", new ArrayList<Category>());
            throw e;
        }
    }
    
    /**
     * Get filtered experiences based on search criteria
     */
    private List<Experience> getFilteredExperiences(Integer categoryId, Integer regionId, 
            Integer cityId, String sort, String filter, String search, 
            int offset, int limit) throws SQLException {
        
        try {
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
            LOGGER.log(Level.SEVERE, "Error getting filtered experiences", e);
            throw e;
        }
    }
    
    /**
     * Get total count of filtered experiences for pagination
     */
    private int getTotalFilteredExperiences(Integer categoryId, Integer regionId, 
            Integer cityId, String filter, String search) throws SQLException {
        
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
     * Append parameter to query string for pagination
     */
    private void appendParam(StringBuilder queryString, String name, String value) {
        if (value != null && !value.trim().isEmpty()) {
            if (queryString.length() > 0) {
                queryString.append("&");
            }
            queryString.append(name).append("=").append(value);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect POST to GET to prevent form resubmission
        doGet(request, response);
    }
}