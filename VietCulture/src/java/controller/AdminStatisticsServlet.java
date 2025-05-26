package controller;

import dao.*;
import model.*;
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
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminStatistics", urlPatterns = {
    "/admin/statistics/users",
    "/admin/statistics/content", 
    "/admin/statistics/bookings",
    "/admin/statistics/refresh",
    "/admin/statistics/export"
})
public class AdminStatisticsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminStatisticsServlet.class.getName());
    
    private UserDAO userDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private BookingDAO bookingDAO;
    private ReviewDAO reviewDAO;
    private RegionDAO regionDAO;
    private CityDAO cityDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        experienceDAO = new ExperienceDAO();
        accommodationDAO = new AccommodationDAO();
        bookingDAO = new BookingDAO();
        reviewDAO = new ReviewDAO();
        regionDAO = new RegionDAO();
        cityDAO = new CityDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getServletPath();
        String period = request.getParameter("period");
        if (period == null) period = "month";
        
        try {
            switch (pathInfo) {
                case "/admin/statistics/users":
                    handleUserStatistics(request, response, period);
                    break;
                case "/admin/statistics/content":
                    handleContentStatistics(request, response, period);
                    break;
                case "/admin/statistics/bookings":
                    handleBookingStatistics(request, response, period);
                    break;
                case "/admin/statistics/refresh":
                    handleRefreshStatistics(request, response);
                    break;
                case "/admin/statistics/export":
                    handleExportStatistics(request, response, period);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in statistics", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu thống kê.");
            request.getRequestDispatcher("/view/jsp/admin/statistics/user-stats.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle user statistics
     */
    private void handleUserStatistics(HttpServletRequest request, HttpServletResponse response, String period) 
            throws SQLException, ServletException, IOException {
        
        // Get basic statistics
        Map<String, Object> stats = getUserStatisticsData(period);
        stats.forEach(request::setAttribute);
        
        // Get user growth data for charts
        List<String> monthLabels = getMonthLabels(12);
        List<Integer> travelerData = userDAO.getTravelerGrowthData(12);
        List<Integer> hostData = userDAO.getHostGrowthData(12);
        
        request.setAttribute("monthLabels", gson.toJson(monthLabels));
        request.setAttribute("travelerData", travelerData.toString().replaceAll("[\\[\\]]", ""));
        request.setAttribute("hostData", hostData.toString().replaceAll("[\\[\\]]", ""));
        
        // Get regional statistics
        Map<String, Integer> regionalStats = getRegionalStatistics();
        request.setAttribute("northUsers", regionalStats.getOrDefault("North", 0));
        request.setAttribute("centralUsers", regionalStats.getOrDefault("Central", 0));
        request.setAttribute("southUsers", regionalStats.getOrDefault("South", 0));
        
        // Get top cities
        List<CityDAO.CityStats> topCities = getTopCities();
        request.setAttribute("topCities", topCities);
        
        // Get recent activities
        List<Activity> recentActivities = getRecentUserActivities();
        request.setAttribute("recentActivities", recentActivities);
        
        // System health data
        Map<String, Object> systemHealth = getSystemHealthData();
        systemHealth.forEach(request::setAttribute);
        
        request.getRequestDispatcher("/view/jsp/admin/statistics/user-stats.jsp").forward(request, response);
    }
    
    /**
     * Handle content statistics
     */
    private void handleContentStatistics(HttpServletRequest request, HttpServletResponse response, String period) 
            throws SQLException, ServletException, IOException {
        
        // Get content statistics
        Map<String, Object> stats = getContentStatisticsData(period);
        stats.forEach(request::setAttribute);
        
        // Get content growth data
        List<Integer> experienceGrowthData = experienceDAO.getMonthlyGrowthData(12);
        List<Integer> accommodationGrowthData = accommodationDAO.getMonthlyGrowthData(12);
        
        request.setAttribute("experienceGrowthData", experienceGrowthData.toString().replaceAll("[\\[\\]]", ""));
        request.setAttribute("accommodationGrowthData", accommodationGrowthData.toString().replaceAll("[\\[\\]]", ""));
        
        // Regional content distribution
        Map<String, Integer> regionalExperiences = getRegionalExperiences();
        Map<String, Integer> regionalAccommodations = getRegionalAccommodations();
        
        request.setAttribute("northExperiences", regionalExperiences.getOrDefault("North", 0));
        request.setAttribute("centralExperiences", regionalExperiences.getOrDefault("Central", 0));
        request.setAttribute("southExperiences", regionalExperiences.getOrDefault("South", 0));
        
        request.setAttribute("northAccommodations", regionalAccommodations.getOrDefault("North", 0));
        request.setAttribute("centralAccommodations", regionalAccommodations.getOrDefault("Central", 0));
        request.setAttribute("southAccommodations", regionalAccommodations.getOrDefault("South", 0));
        
        request.getRequestDispatcher("/view/jsp/admin/statistics/content-stats.jsp").forward(request, response);
    }
    
    /**
     * Handle booking statistics
     */
    private void handleBookingStatistics(HttpServletRequest request, HttpServletResponse response, String period) 
            throws SQLException, ServletException, IOException {
        
        // Get booking statistics
        Map<String, Object> stats = getBookingStatisticsData(period);
        stats.forEach(request::setAttribute);
        
        // Get booking trends
        List<Integer> bookingTrends = bookingDAO.getMonthlyBookingTrends(12);
        List<Double> revenueTrends = bookingDAO.getMonthlyRevenueTrends(12);
        
        request.setAttribute("bookingTrends", bookingTrends.toString().replaceAll("[\\[\\]]", ""));
        request.setAttribute("revenueTrends", revenueTrends.toString().replaceAll("[\\[\\]]", ""));
        
        request.getRequestDispatcher("/view/jsp/admin/statistics/booking-stats.jsp").forward(request, response);
    }
    
    /**
     * Handle refresh statistics (AJAX)
     */
    private void handleRefreshStatistics(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        Map<String, Object> refreshData = new HashMap<>();
        
        // Get system health
        Map<String, Object> systemHealth = getSystemHealthData();
        refreshData.put("systemHealth", systemHealth);
        
        // Check for new activities
        int newActivities = getNewActivitiesCount();
        refreshData.put("newActivities", newActivities);
        
        refreshData.put("success", true);
        
        sendJsonResponse(response, refreshData);
    }
    
    /**
     * Handle export statistics
     */
    private void handleExportStatistics(HttpServletRequest request, HttpServletResponse response, String period) 
            throws SQLException, IOException {
        
        String format = request.getParameter("format");
        if (format == null) format = "excel";
        
        // Set response headers for download
        if ("pdf".equals(format)) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"statistics-report.pdf\"");
        } else {
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=\"statistics-report.xlsx\"");
        }
        
        // Generate and send report
        generateStatisticsReport(response, period, format);
    }
    
    /**
     * Get user statistics data
     */
    private Map<String, Object> getUserStatisticsData(String period) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Total users
        int totalUsers = userDAO.getTotalUsersCount();
        stats.put("totalUsers", totalUsers);
        
        // User growth
        double userGrowth = userDAO.getUserGrowthPercentage(period);
        stats.put("userGrowth", Math.round(userGrowth * 10.0) / 10.0);
        
        // User type counts
        Map<String, Integer> userTypeCounts = userDAO.getUserTypesCounts();
        stats.put("travelerCount", userTypeCounts.getOrDefault("TRAVELER", 0));
        stats.put("hostCount", userTypeCounts.getOrDefault("HOST", 0));
        stats.put("adminCount", userTypeCounts.getOrDefault("ADMIN", 0));
        
        // Percentages
        if (totalUsers > 0) {
            stats.put("travelerPercentage", Math.round(((double) userTypeCounts.getOrDefault("TRAVELER", 0) / totalUsers) * 100));
            stats.put("hostPercentage", Math.round(((double) userTypeCounts.getOrDefault("HOST", 0) / totalUsers) * 100));
            stats.put("adminPercentage", Math.round(((double) userTypeCounts.getOrDefault("ADMIN", 0) / totalUsers) * 100));
        }
        
        return stats;
    }
    
    /**
     * Get content statistics data
     */
    private Map<String, Object> getContentStatisticsData(String period) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Total experiences and accommodations
        int totalExperiences = experienceDAO.getTotalExperiencesCount();
        int totalAccommodations = accommodationDAO.getTotalAccommodationsCount();
        
        stats.put("totalExperiences", totalExperiences);
        stats.put("totalAccommodations", totalAccommodations);
        
        // Growth percentages
        double experienceGrowth = experienceDAO.getGrowthPercentage(period);
        double accommodationGrowth = accommodationDAO.getGrowthPercentage(period);
        
        stats.put("experienceGrowth", Math.round(experienceGrowth * 10.0) / 10.0);
        stats.put("accommodationGrowth", Math.round(accommodationGrowth * 10.0) / 10.0);
        
        return stats;
    }
    
    /**
     * Get booking statistics data
     */
    private Map<String, Object> getBookingStatisticsData(String period) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Total bookings and revenue
        int totalBookings = bookingDAO.getTotalBookingsCount();
        double totalRevenue = bookingDAO.getTotalRevenue();
        
        stats.put("totalBookings", totalBookings);
        stats.put("totalRevenue", Math.round(totalRevenue / 1000)); // Convert to K
        
        // Growth percentages
        double bookingGrowth = bookingDAO.getBookingGrowthPercentage(period);
        double revenueGrowth = bookingDAO.getRevenueGrowthPercentage(period);
        
        stats.put("bookingGrowth", Math.round(bookingGrowth * 10.0) / 10.0);
        stats.put("revenueGrowth", Math.round(revenueGrowth * 10.0) / 10.0);
        
        // Performance metrics
        double averageRating = reviewDAO.getAverageRating();
        double conversionRate = calculateConversionRate();
        double returnRate = calculateReturnRate();
        int avgResponseTime = calculateAverageResponseTime();
        
        stats.put("averageRating", Math.round(averageRating * 10.0) / 10.0);
        stats.put("conversionRate", Math.round(conversionRate * 10.0) / 10.0);
        stats.put("returnRate", Math.round(returnRate * 10.0) / 10.0);
        stats.put("avgResponseTime", avgResponseTime);
        
        return stats;
    }
    
    /**
     * Get regional statistics
     */
    private Map<String, Integer> getRegionalStatistics() throws SQLException {
        return userDAO.getUsersByRegion();
    }
    
    /**
     * Get regional experiences
     */
    private Map<String, Integer> getRegionalExperiences() throws SQLException {
        return experienceDAO.getExperiencesByRegion();
    }
    
    /**
     * Get regional accommodations
     */
    private Map<String, Integer> getRegionalAccommodations() throws SQLException {
        return accommodationDAO.getAccommodationsByRegion();
    }
    
    /**
     * Get top cities
     */
    private List<CityDAO.CityStats> getTopCities() throws SQLException {
        return cityDAO.getTopCitiesWithStats(10);
    }
    
    /**
     * Get recent user activities
     */
    private List<Activity> getRecentUserActivities() throws SQLException {
        // This would be implemented based on your Activity/Log system
        List<Activity> activities = new ArrayList<>();
        
        // Sample data - replace with actual implementation
        activities.add(new Activity("Đăng ký mới", "User mới đăng ký", "success", "info"));
        activities.add(new Activity("Tạo Experience", "Host tạo experience mới", "pending", "warning"));
        activities.add(new Activity("Booking mới", "Traveler đặt tour", "success", "success"));
        
        return activities;
    }
    
    /**
     * Get system health data
     */
    private Map<String, Object> getSystemHealthData() {
        Map<String, Object> health = new HashMap<>();
        
        // Sample system health data - replace with actual monitoring
        health.put("serverUptime", 98);
        health.put("apiCallsToday", 15420);
        health.put("lastBackup", new Date());
        
        return health;
    }
    
    /**
     * Get month labels for charts
     */
    private List<String> getMonthLabels(int months) {
        List<String> labels = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("MMM");
        
        for (int i = months - 1; i >= 0; i--) {
            cal.add(Calendar.MONTH, -i);
            labels.add(sdf.format(cal.getTime()));
            cal.add(Calendar.MONTH, i); // Reset
        }
        
        return labels;
    }
    
    /**
     * Calculate conversion rate
     */
    private double calculateConversionRate() throws SQLException {
        // This would calculate actual conversion rate
        return 12.5; // Sample value
    }
    
    /**
     * Calculate return rate
     */
    private double calculateReturnRate() throws SQLException {
        // This would calculate actual return customer rate
        return 35.8; // Sample value
    }
    
    /**
     * Calculate average response time
     */
    private int calculateAverageResponseTime() throws SQLException {
        // This would calculate actual average response time
        return 2; // Sample value in hours
    }
    
    /**
     * Get new activities count
     */
    private int getNewActivitiesCount() throws SQLException {
        // This would check for new activities since last check
        return 0;
    }
    
    /**
     * Generate statistics report
     */
    private void generateStatisticsReport(HttpServletResponse response, String period, String format) 
            throws SQLException, IOException {
        
        // This would generate actual Excel/PDF report
        PrintWriter out = response.getWriter();
        out.println("Statistics Report for period: " + period);
        out.println("Format: " + format);
        out.println("Generated at: " + new Date());
        // Add actual report generation logic here
    }
    
    /**
     * Check if user is authenticated admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getUserType());
    }
    
    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
    
    /**
     * Inner class for Activity
     */
    public static class Activity {
        private String action;
        private String description;
        private String status;
        private String type;
        private Date createdAt;
        private String userName;
        private String userType;
        private String userAvatar;
        private String icon;
        
        public Activity(String action, String description, String status, String type) {
            this.action = action;
            this.description = description;
            this.status = status;
            this.type = type;
            this.createdAt = new Date();
            this.icon = getIconForType(type);
        }
        
        private String getIconForType(String type) {
            switch (type) {
                case "success": return "fa-check-circle";
                case "warning": return "fa-exclamation-triangle";
                case "error": return "fa-times-circle";
                case "info": return "fa-info-circle";
                default: return "fa-circle";
            }
        }
        
        // Getters and setters
        public String getAction() { return action; }
        public void setAction(String action) { this.action = action; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        
        public Date getCreatedAt() { return createdAt; }
        public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
        
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        
        public String getUserType() { return userType; }
        public void setUserType(String userType) { this.userType = userType; }
        
        public String getUserAvatar() { return userAvatar; }
        public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
        
        public String getIcon() { return icon; }
        public void setIcon(String icon) { this.icon = icon; }
    }
    
    /**
     * Inner class for City Statistics
     */
    public static class CityStats {
        private String name;
        private String vietnameseName;
        private int experienceCount;
        private int accommodationCount;
        private double percentage;
        
        // Constructors, getters, setters
        public CityStats() {}
        
        public CityStats(String name, String vietnameseName, int experienceCount, int accommodationCount) {
            this.name = name;
            this.vietnameseName = vietnameseName;
            this.experienceCount = experienceCount;
            this.accommodationCount = accommodationCount;
        }
        
        // Getters and setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getVietnameseName() { return vietnameseName; }
        public void setVietnameseName(String vietnameseName) { this.vietnameseName = vietnameseName; }
        
        public int getExperienceCount() { return experienceCount; }
        public void setExperienceCount(int experienceCount) { this.experienceCount = experienceCount; }
        
        public int getAccommodationCount() { return accommodationCount; }
        public void setAccommodationCount(int accommodationCount) { this.accommodationCount = accommodationCount; }
        
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }
}