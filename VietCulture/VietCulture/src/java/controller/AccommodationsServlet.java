package controller;

import dao.AccommodationDAO;
import dao.RegionDAO;
import model.Accommodation;
import model.Region;

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

@WebServlet(name = "AccommodationsServlet", urlPatterns = {"/accommodations", "/accommodations/*"})
public class AccommodationsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AccommodationsServlet.class.getName());
    
    private AccommodationDAO accommodationDAO;
    private RegionDAO regionDAO;
    
    private static final int DEFAULT_PAGE_SIZE = 12;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.accommodationDAO = new AccommodationDAO();
            this.regionDAO = new RegionDAO();
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
                // Handle individual accommodation view: /accommodations/{id}
                handleAccommodationDetail(request, response, pathInfo);
            } else {
                // Handle accommodations list: /accommodations
                handleAccommodationsList(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in AccommodationsServlet", e);
            
            // Set error message for user
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi truy xuất dữ liệu. Vui lòng thử lại sau.");
            request.setAttribute("accommodations", new ArrayList<Accommodation>());
            request.setAttribute("regions", new ArrayList<Region>());
            
            // Forward to JSP with error
            request.getRequestDispatcher("/view/jsp/home/accommodations.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in AccommodationsServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Đã xảy ra lỗi không mong đợi.");
        }
    }
    
    /**
     * Handle accommodation detail view
     */
    private void handleAccommodationDetail(HttpServletRequest request, HttpServletResponse response, 
                                         String pathInfo) throws ServletException, IOException, SQLException {
        try {
            // Extract accommodation ID from path
            String accommodationIdStr = pathInfo.substring(1); // Remove leading "/"
            int accommodationId = Integer.parseInt(accommodationIdStr);
            
            // Get accommodation details
            Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
            
            if (accommodation == null || !accommodation.isActive()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Chỗ lưu trú không tồn tại hoặc đã bị tạm ngừng.");
                return;
            }
            
            // Set accommodation data
            request.setAttribute("accommodation", accommodation);
            
            // Forward to detail page - Updated path to match project structure
            request.getRequestDispatcher("/view/jsp/home/accommodation-detail.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID chỗ lưu trú không hợp lệ.");
        }
    }
    
    /**
     * Handle accommodations list view
     */
    private void handleAccommodationsList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        // Get search and filter parameters
        String typeFilter = request.getParameter("type");
        String regionFilter = request.getParameter("region");
        String cityFilter = request.getParameter("city");
        String sortBy = request.getParameter("sort");
        String filter = request.getParameter("filter");
        
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        
        // Validate page parameters
        if (page < 1) page = 1;
        if (pageSize < 1 || pageSize > 50) pageSize = DEFAULT_PAGE_SIZE;
        
        List<Accommodation> accommodations = new ArrayList<>();
        List<Region> regions = new ArrayList<>();
        int totalAccommodations = 0;
        
        try {
            // Get accommodations based on filters
            accommodations = getFilteredAccommodations(typeFilter, regionFilter, cityFilter, 
                                                     filter, sortBy, page, pageSize);
            
            // Get total count for pagination
            totalAccommodations = getTotalAccommodationsCount(typeFilter, regionFilter, cityFilter, filter);
            
            // Get regions and cities for dropdowns
            regions = regionDAO.getAllRegionsWithCities();
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting accommodations data", e);
            // Continue with empty lists - error will be shown in JSP
        }
        
        // Calculate pagination
        int totalPages = totalAccommodations > 0 ? (int) Math.ceil((double) totalAccommodations / pageSize) : 1;
        
        // Build query string for pagination
        String queryString = buildQueryString(request);
        
        // Set attributes for JSP
        request.setAttribute("accommodations", accommodations);
        request.setAttribute("regions", regions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalAccommodations", totalAccommodations);
        request.setAttribute("queryString", queryString);
        
        // Set filter parameters back to JSP for form state
        request.setAttribute("selectedType", typeFilter);
        request.setAttribute("selectedRegion", regionFilter);
        request.setAttribute("selectedCity", cityFilter);
        request.setAttribute("selectedSort", sortBy);
        request.setAttribute("selectedFilter", filter);
        
        // Forward to accommodations list page
        request.getRequestDispatcher("/view/jsp/home/accommodations.jsp")
               .forward(request, response);
    }
    
    /**
     * Get filtered accommodations based on parameters
     */
    private List<Accommodation> getFilteredAccommodations(String type, String region, String city, 
                                                         String filter, String sortBy, 
                                                         int page, int pageSize) throws SQLException {
        
        // Convert string parameters to integers
        int regionId = getIntFromString(region);
        int cityId = getIntFromString(city);
        
        List<Accommodation> accommodations;
        
        // Apply specific filters
        switch (filter != null ? filter : "") {
            case "popular":
                accommodations = getPopularAccommodations(page, pageSize);
                break;
            case "newest":
                accommodations = getNewestAccommodations(page, pageSize);
                break;
            case "top-rated":
                accommodations = getTopRatedAccommodations(page, pageSize);
                break;
            case "low-price":
                accommodations = getLowPriceAccommodations(page, pageSize);
                break;
            case "homestay":
                accommodations = accommodationDAO.getApprovedAccommodations(page, pageSize, "Homestay");
                break;
            default:
                // General search with filters
                accommodations = searchAccommodations(type, regionId, cityId, page, pageSize);
                break;
        }
        
        // Apply sorting if specified and not already applied by filter
        if (sortBy != null && !sortBy.trim().isEmpty() && 
            (filter == null || filter.trim().isEmpty())) {
            accommodations = sortAccommodations(accommodations, sortBy);
        }
        
        return accommodations;
    }
    
    /**
     * Search accommodations with basic filters
     */
    private List<Accommodation> searchAccommodations(String type, int regionId, int cityId, 
                                                    int page, int pageSize) throws SQLException {
        
        // Enhanced search logic with region and city filters
        if (cityId > 0) {
            // Search by city (most specific)
            return accommodationDAO.getAccommodationsByCity(cityId, page, pageSize, type);
        } else if (regionId > 0) {
            // Search by region
            return accommodationDAO.getAccommodationsByRegion(regionId, page, pageSize, type);
        } else if (type != null && !type.trim().isEmpty()) {
            // Search by type only
            return accommodationDAO.getApprovedAccommodations(page, pageSize, type);
        } else {
            // Get all approved accommodations
            return accommodationDAO.getApprovedAccommodations(page, pageSize, null);
        }
    }
    
    /**
     * Get popular accommodations (based on bookings and ratings)
     */
    private List<Accommodation> getPopularAccommodations(int page, int pageSize) throws SQLException {
        // Get accommodations with high ratings and bookings
        List<Accommodation> accommodations = accommodationDAO.getApprovedAccommodations(1, 100, null);
        return accommodations.stream()
                .filter(a -> a.getTotalBookings() >= 5 && a.getAverageRating() >= 4.0)
                .sorted((a1, a2) -> {
                    // Sort by combination of bookings and rating
                    double score1 = a1.getTotalBookings() * 0.7 + a1.getAverageRating() * 0.3;
                    double score2 = a2.getTotalBookings() * 0.7 + a2.getAverageRating() * 0.3;
                    return Double.compare(score2, score1);
                })
                .skip((page - 1) * pageSize)
                .limit(pageSize)
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Get newest accommodations
     */
    private List<Accommodation> getNewestAccommodations(int page, int pageSize) throws SQLException {
        List<Accommodation> accommodations = accommodationDAO.getApprovedAccommodations(1, 100, null);
        return accommodations.stream()
                .sorted((a1, a2) -> a2.getCreatedAt().compareTo(a1.getCreatedAt()))
                .skip((page - 1) * pageSize)
                .limit(pageSize)
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Get top-rated accommodations
     */
    private List<Accommodation> getTopRatedAccommodations(int page, int pageSize) throws SQLException {
        List<Accommodation> accommodations = accommodationDAO.getApprovedAccommodations(1, 100, null);
        return accommodations.stream()
                .filter(a -> a.getAverageRating() > 0)
                .sorted((a1, a2) -> {
                    int ratingCompare = Double.compare(a2.getAverageRating(), a1.getAverageRating());
                    return ratingCompare != 0 ? ratingCompare : 
                           Integer.compare(a2.getTotalBookings(), a1.getTotalBookings());
                })
                .skip((page - 1) * pageSize)
                .limit(pageSize)
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Get low-price accommodations
     */
    private List<Accommodation> getLowPriceAccommodations(int page, int pageSize) throws SQLException {
        List<Accommodation> accommodations = accommodationDAO.getApprovedAccommodations(1, 100, null);
        return accommodations.stream()
                .sorted((a1, a2) -> Double.compare(a1.getPricePerNight(), a2.getPricePerNight()))
                .skip((page - 1) * pageSize)
                .limit(pageSize)
                .collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * Sort accommodations based on sort criteria
     */
    private List<Accommodation> sortAccommodations(List<Accommodation> accommodations, String sortBy) {
        if (accommodations == null || accommodations.isEmpty()) {
            return accommodations;
        }
        
        List<Accommodation> sortedList = new ArrayList<>(accommodations);
        
        switch (sortBy) {
            case "price-asc":
                sortedList.sort((a1, a2) -> Double.compare(a1.getPricePerNight(), a2.getPricePerNight()));
                break;
            case "price-desc":
                sortedList.sort((a1, a2) -> Double.compare(a2.getPricePerNight(), a1.getPricePerNight()));
                break;
            case "rating":
                sortedList.sort((a1, a2) -> Double.compare(a2.getAverageRating(), a1.getAverageRating()));
                break;
            case "newest":
                sortedList.sort((a1, a2) -> a2.getCreatedAt().compareTo(a1.getCreatedAt()));
                break;
            default:
                // No sorting
                break;
        }
        
        return sortedList;
    }
    
    /**
     * Get total accommodations count with enhanced filtering
     */
    private int getTotalAccommodationsCount(String type, String region, String city, String filter) throws SQLException {
        try {
            int regionId = getIntFromString(region);
            int cityId = getIntFromString(city);
            
            // Count based on specific filters
            switch (filter != null ? filter : "") {
                case "popular":
                    // Count popular accommodations (would need custom DAO method)
                    return getPopularAccommodations(1, Integer.MAX_VALUE).size();
                case "newest":
                case "top-rated":
                case "low-price":
                case "homestay":
                    // For these filters, we need to count all and then filter
                    return getFilteredAccommodations(type, region, city, filter, null, 1, Integer.MAX_VALUE).size();
                default:
                    // Standard count based on search criteria
                    if (cityId > 0) {
                        return accommodationDAO.getAccommodationsCountByCity(cityId, type);
                    } else if (regionId > 0) {
                        return accommodationDAO.getAccommodationsCountByRegion(regionId, type);
                    } else if (type != null && !type.trim().isEmpty()) {
                        return accommodationDAO.getApprovedAccommodationsCount(type);
                    } else {
                        return accommodationDAO.getApprovedAccommodationsCount();
                    }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting accommodations count", e);
            return 0;
        }
    }
    
    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid integer parameter: " + paramName + " = " + paramValue);
            }
        }
        return defaultValue;
    }
    
    /**
     * Convert string to integer safely
     */
    private int getIntFromString(String str) {
        if (str != null && !str.trim().isEmpty()) {
            try {
                return Integer.parseInt(str.trim());
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        return 0;
    }
    
    /**
     * Build query string for pagination links
     */
    private String buildQueryString(HttpServletRequest request) {
        StringBuilder queryString = new StringBuilder();
        
        String[] params = {"type", "region", "city", "sort", "filter"};
        
        for (String param : params) {
            String value = request.getParameter(param);
            if (value != null && !value.trim().isEmpty()) {
                if (queryString.length() > 0) {
                    queryString.append("&");
                }
                try {
                    queryString.append(param).append("=")
                              .append(java.net.URLEncoder.encode(value, "UTF-8"));
                } catch (java.io.UnsupportedEncodingException e) {
                    queryString.append(param).append("=").append(value);
                }
            }
        }
        
        return queryString.toString();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect POST requests to GET to avoid duplicate submissions
        response.sendRedirect(request.getRequestURI() + 
                            (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
    }
}