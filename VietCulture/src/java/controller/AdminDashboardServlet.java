package controller;

import dao.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    
    private UserDAO userDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private BookingDAO bookingDAO;
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        experienceDAO = new ExperienceDAO();
        accommodationDAO = new AccommodationDAO();
        bookingDAO = new BookingDAO();
        reviewDAO = new ReviewDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get dashboard statistics
            Map<String, Object> stats = getDashboardStatistics();
            
            // Set attributes for JSP
            stats.forEach(request::setAttribute);
            
            // Get recent activities
            List<Activity> recentActivities = getRecentActivities();
            request.setAttribute("recentActivities", recentActivities);
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("/view/jsp/admin/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading dashboard data", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu dashboard.");
            request.getRequestDispatcher("/view/jsp/admin/dashboard.jsp").forward(request, response);
        }
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
     * Get dashboard statistics
     */
    private Map<String, Object> getDashboardStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // Total users
        int totalUsers = userDAO.getTotalUsersCount();
        stats.put("totalUsers", totalUsers);
        
        // Active experiences
        int activeExperiences = experienceDAO.getActiveExperiencesCount();
        stats.put("activeExperiences", activeExperiences);
        
        // Pending approvals
        int pendingExperiences = experienceDAO.getPendingExperiencesCount();
        int pendingAccommodations = accommodationDAO.getPendingAccommodationsCount();
        int pendingApproval = pendingExperiences + pendingAccommodations;
        stats.put("pendingApproval", pendingApproval);
        stats.put("pendingExperiences", pendingExperiences);
        stats.put("pendingAccommodations", pendingAccommodations);
        
        // Monthly bookings
        int monthlyBookings = bookingDAO.getCurrentMonthBookingsCount();
        stats.put("monthlyBookings", monthlyBookings);
        
        // Weekly bookings data for chart
        List<Integer> weeklyBookings = bookingDAO.getWeeklyBookingsData();
        stats.put("weeklyBookings", weeklyBookings.toString().replaceAll("[\\[\\]]", ""));
        
        // User type counts
        Map<String, Integer> userTypeCounts = userDAO.getUserTypesCounts();
        stats.put("travelerCount", userTypeCounts.getOrDefault("TRAVELER", 0));
        stats.put("hostCount", userTypeCounts.getOrDefault("HOST", 0));
        stats.put("adminCount", userTypeCounts.getOrDefault("ADMIN", 0));
        
        // New complaints
        int newComplaints = getNewComplaintsCount();
        stats.put("newComplaints", newComplaints);
        
        return stats;
    }
    
    /**
     * Get recent activities - Fixed implementation
     */
    private List<Activity> getRecentActivities() throws SQLException {
        List<Activity> activities = new ArrayList<>();
        
        // Sample activities - replace with actual database implementation
        activities.add(new Activity("Đăng ký mới", "User mới đăng ký tài khoản", "success", "info"));
        activities.add(new Activity("Tạo Experience", "Host tạo experience mới", "pending", "warning"));
        activities.add(new Activity("Booking mới", "Traveler đặt tour", "success", "success"));
        activities.add(new Activity("Review mới", "User để lại đánh giá", "success", "info"));
        activities.add(new Activity("Báo cáo vi phạm", "Nội dung bị báo cáo", "warning", "error"));
        
        return activities;
    }
    
    /**
     * Get new complaints count - Fixed implementation
     */
    private int getNewComplaintsCount() throws SQLException {
        // Sample implementation - replace with actual database query
        return 3;
    }
    
    /**
     * Activity class - Enhanced with proper fields and methods
     */
    public static class Activity {
        private String action;
        private String description;
        private java.util.Date createdAt;
        private String status;
        private String type;
        private String userName;
        private String userType;
        private String userAvatar;
        private String icon;
        
        // Constructors
        public Activity() {}
        
        public Activity(String action, String description, String status, String type) {
            this.action = action;
            this.description = description;
            this.status = status;
            this.type = type;
            this.createdAt = new java.util.Date();
            this.icon = getIconForType(type);
        }
        
        public Activity(String action, String description, String status, String type, String userName) {
            this(action, description, status, type);
            this.userName = userName;
        }
        
        /**
         * Get appropriate icon based on activity type
         */
        private String getIconForType(String type) {
            switch (type != null ? type.toLowerCase() : "") {
                case "success": return "fa-check-circle";
                case "warning": return "fa-exclamation-triangle";
                case "error": return "fa-times-circle";
                case "info": return "fa-info-circle";
                default: return "fa-circle";
            }
        }
        
        /**
         * Get CSS class for activity status
         */
        public String getStatusClass() {
            switch (status != null ? status.toLowerCase() : "") {
                case "success": return "text-success";
                case "warning": return "text-warning";
                case "error": return "text-danger";
                case "pending": return "text-warning";
                default: return "text-info";
            }
        }
        
        /**
         * Get time ago string
         */
        public String getTimeAgo() {
            if (createdAt == null) return "Vừa xong";
            
            long diffInMillies = System.currentTimeMillis() - createdAt.getTime();
            long diffInMinutes = diffInMillies / (60 * 1000);
            
            if (diffInMinutes < 1) return "Vừa xong";
            if (diffInMinutes < 60) return diffInMinutes + " phút trước";
            
            long diffInHours = diffInMinutes / 60;
            if (diffInHours < 24) return diffInHours + " giờ trước";
            
            long diffInDays = diffInHours / 24;
            return diffInDays + " ngày trước";
        }
        
        // Getters and setters
        public String getAction() { 
            return action; 
        }
        
        public void setAction(String action) { 
            this.action = action; 
        }
        
        public String getDescription() { 
            return description; 
        }
        
        public void setDescription(String description) { 
            this.description = description; 
        }
        
        public java.util.Date getCreatedAt() { 
            return createdAt; 
        }
        
        public void setCreatedAt(java.util.Date createdAt) { 
            this.createdAt = createdAt; 
        }
        
        public String getStatus() { 
            return status; 
        }
        
        public void setStatus(String status) { 
            this.status = status; 
        }
        
        public String getType() { 
            return type; 
        }
        
        public void setType(String type) { 
            this.type = type;
            this.icon = getIconForType(type);
        }
        
        public String getUserName() { 
            return userName; 
        }
        
        public void setUserName(String userName) { 
            this.userName = userName; 
        }
        
        public String getUserType() { 
            return userType; 
        }
        
        public void setUserType(String userType) { 
            this.userType = userType; 
        }
        
        public String getUserAvatar() { 
            return userAvatar; 
        }
        
        public void setUserAvatar(String userAvatar) { 
            this.userAvatar = userAvatar; 
        }
        
        public String getIcon() { 
            return icon; 
        }
        
        public void setIcon(String icon) { 
            this.icon = icon; 
        }
    }
}