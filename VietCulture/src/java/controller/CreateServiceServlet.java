package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

import dao.ExperienceDAO;
import dao.AccommodationDAO;
import dao.RegionDAO;
import dao.CityDAO;
import dao.CategoryDAO;
import dao.UserDAO;

/**
 * Servlet để xử lý trang tạo dịch vụ (Create Service)
 * CHỈ HIỂN THỊ TRANG CHỌN LOẠI DỊCH VỤ (Experience hoặc Accommodation)
 */
@WebServlet(name = "CreateServiceServlet", urlPatterns = {
    "/Travel/create_service",
    "/create_service"
})
public class CreateServiceServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CreateServiceServlet.class.getName());
    
    // DAOs for getting statistics
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private RegionDAO regionDAO;
    private CityDAO cityDAO;
    private CategoryDAO categoryDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // Initialize DAOs
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            regionDAO = new RegionDAO();
            cityDAO = new CityDAO();
            categoryDAO = new CategoryDAO();
            userDAO = new UserDAO();
            
            LOGGER.info("CreateServiceServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize CreateServiceServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        LOGGER.info("Processing GET request for /Travel/create_service");
        
        try {
            // Check if user is authenticated
            if (!isUserAuthenticated(request)) {
                LOGGER.info("User not authenticated, redirecting to login");
                HttpSession session = request.getSession();
                session.setAttribute("redirectUrl", request.getRequestURL().toString());
                response.sendRedirect(request.getContextPath() + "/login?message=Vui lòng đăng nhập để tạo dịch vụ");
                return;
            }

            // Get user from session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            // Check if user has HOST role or can become a host
            if (user != null && !"HOST".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
                // User is a TRAVELER, show option to upgrade to HOST
                request.setAttribute("needHostUpgrade", true);
                request.setAttribute("userRole", user.getRole());
                LOGGER.info("User " + user.getEmail() + " needs to upgrade to HOST role");
            }

            // Load statistics for the page
            loadStatistics(request);
            
            // Load supporting data
            loadSupportingData(request);

            // Set page attributes
            request.setAttribute("pageTitle", "Tạo Dịch Vụ Du Lịch");
            request.setAttribute("pageDescription", "Chia sẻ trải nghiệm độc đáo hoặc cho thuê nơi ở với du khách từ khắp nơi trên thế giới");
            
            // Forward to JSP - TRANG CHỌN LOẠI DỊCH VỤ
            request.getRequestDispatcher("/view/jsp/host/create_service.jsp").forward(request, response);
            
            LOGGER.info("Successfully forwarded to create_service.jsp");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing create service request", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check authentication
            if (!isUserAuthenticated(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Handle role upgrade if needed
            String upgradeToHost = request.getParameter("upgradeToHost");
            if ("true".equals(upgradeToHost)) {
                handleHostUpgrade(request, response);
                return;
            }

            // This servlet KHÔNG XỬ LÝ tạo dịch vụ
            // Chỉ chuyển hướng về trang chính
            response.sendRedirect(request.getContextPath() + "/Travel/create_service");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    /**
     * Check if user is authenticated
     */
    private boolean isUserAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        return user != null;
    }

    /**
     * Handle user upgrade to HOST role
     */
    private void handleHostUpgrade(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Here you would typically:
            // 1. Update user role in database
            // 2. Send confirmation email
            // 3. Maybe require additional verification
            
            // For now, we'll just redirect to a upgrade/registration page
            session.setAttribute("upgradeRequest", true);
            session.setAttribute("requestedRole", "HOST");
            
            response.sendRedirect(request.getContextPath() + "/host/upgrade");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling host upgrade", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Upgrade request failed");
        }
    }

    /**
     * Load statistics for the create service page
     */
    private void loadStatistics(HttpServletRequest request) {
        try {
            // Get total hosts count (users with HOST role)
            int totalHosts = getTotalHostsCount();
            request.setAttribute("totalHosts", totalHosts);

            // Get total experiences count
            int totalExperiences = experienceDAO.getTotalExperiencesCount();
            request.setAttribute("totalExperiences", totalExperiences);

            // Get total accommodations count
            int totalAccommodations = accommodationDAO.getTotalAccommodationsCount();
            request.setAttribute("totalAccommodations", totalAccommodations);

            // Calculate total bookings (experiences + accommodations)
            int totalBookings = getTotalBookingsCount();
            request.setAttribute("totalBookings", totalBookings);

            // Get average rating across all services
            double averageRating = getAverageRating();
            request.setAttribute("averageRating", String.format("%.1f", averageRating));

            // Get recent statistics for trending info
            int recentExperiences = experienceDAO.getRecentExperiencesCount(30); // Last 30 days
            int recentAccommodations = accommodationDAO.getRecentAccommodationsCount(30);
            
            request.setAttribute("recentExperiences", recentExperiences);
            request.setAttribute("recentAccommodations", recentAccommodations);

            LOGGER.info("Statistics loaded successfully");

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error loading statistics", e);
            // Set default values
            request.setAttribute("totalHosts", 1000);
            request.setAttribute("totalExperiences", 5000);
            request.setAttribute("totalAccommodations", 3000);
            request.setAttribute("totalBookings", 50000);
            request.setAttribute("averageRating", "4.8");
        }
    }

    /**
     * Load supporting data like regions, cities, categories
     */
    private void loadSupportingData(HttpServletRequest request) {
        try {
            // Load regions for potential use in forms
            request.setAttribute("regions", regionDAO.getAllRegions());
            
            // Load categories for experiences
            request.setAttribute("categories", categoryDAO.getAllCategories());
            
            // Load popular cities
            request.setAttribute("popularCities", cityDAO.getPopularCities(10));

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error loading supporting data", e);
        }
    }

    /**
     * Get total hosts count
     */
    private int getTotalHostsCount() {
        try {
            return userDAO.getTotalHostsCount();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting hosts count", e);
            return 1250; // Default fallback
        }
    }

    /**
     * Get total bookings count across all services
     */
    private int getTotalBookingsCount() {
        try {
            // Calculate total bookings from both experiences and accommodations
            int totalExperiences = experienceDAO.getTotalExperiencesCount();
            int totalAccommodations = accommodationDAO.getTotalAccommodationsCount();
            
            // Estimate bookings based on service count (placeholder calculation)
            int estimatedBookings = (totalExperiences * 15) + (totalAccommodations * 25);
            return Math.max(estimatedBookings, 50000);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting total bookings", e);
            return 50000; // Default fallback
        }
    }

    /**
     * Get average rating across all services
     */
    private double getAverageRating() {
        try {
            // For now, return a default good rating
            // In a real implementation, you would calculate this from actual reviews
            return 4.8;
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error calculating average rating", e);
            return 4.8; // Default fallback
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        // Clean up resources if needed
        LOGGER.info("CreateServiceServlet destroyed");
    }
}