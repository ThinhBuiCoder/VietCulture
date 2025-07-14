package controller;

import dao.ExperienceDAO;
import dao.*;
import dao.ComplaintDAO;
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

        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Map<String, Object> stats = getDashboardStatistics();
            stats.forEach(request::setAttribute);

            List<Activity> recentActivities = getRecentActivities();
            request.setAttribute("recentActivities", recentActivities);

            request.getRequestDispatcher("/view/jsp/admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading dashboard data", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu dashboard.");
            request.getRequestDispatcher("/view/jsp/admin/dashboard.jsp").forward(request, response);
        }
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole()); // Updated to role
    }

    private Map<String, Object> getDashboardStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        int totalUsers = userDAO.getTotalUsersCount();
        stats.put("totalUsers", totalUsers);

        int activeExperiences = experienceDAO.getApprovedExperiencesCount(); // Changed to getApproved
        stats.put("activeExperiences", activeExperiences);

        int pendingExperiences = experienceDAO.getPendingExperiencesCount();
        int pendingAccommodations = accommodationDAO.getPendingAccommodationsCount();
        int pendingApproval = pendingExperiences + pendingAccommodations;
        stats.put("pendingApproval", pendingApproval);
        stats.put("pendingExperiences", pendingExperiences);
        stats.put("pendingAccommodations", pendingAccommodations);

        int monthlyBookings = bookingDAO.getCurrentMonthBookingsCount(); // Assumes BookingDAO method
        stats.put("monthlyBookings", monthlyBookings);

        List<Integer> weeklyBookings = bookingDAO.getWeeklyBookingsData(); // Assumes BookingDAO method
        stats.put("weeklyBookings", weeklyBookings.toString().replaceAll("[\\[\\]]", ""));

        Map<String, Integer> userRoleCounts = userDAO.getUserRolesCounts(); // Changed to getUserRolesCounts
        stats.put("travelerCount", userRoleCounts.getOrDefault("TRAVELER", 0));
        stats.put("hostCount", userRoleCounts.getOrDefault("HOST", 0));
        stats.put("adminCount", userRoleCounts.getOrDefault("ADMIN", 0));

        int newComplaints = getNewComplaintsCount();
        stats.put("newComplaints", newComplaints);

        return stats;
    }

    private List<Activity> getRecentActivities() throws SQLException {
        // Placeholder - implement with a UserActions table
        List<Activity> activities = new ArrayList<>();
        activities.add(new Activity("Đăng ký mới", "User mới đăng ký tài khoản", "success", "info"));
        activities.add(new Activity("Tạo Experience", "Host tạo experience mới", "pending", "warning"));
        activities.add(new Activity("Booking mới", "Traveler đặt tour", "success", "success"));
        return activities;
    }

    private int getNewComplaintsCount() throws SQLException {
        ComplaintDAO complaintDAO = new ComplaintDAO();
        return complaintDAO.getNewComplaintsCount();
    }

    public static class Activity {
        private String action;
        private String description;
        private java.util.Date createdAt;
        private String status;
        private String type;
        private String userName;
        private String userRole; // Updated to userRole
        private String userAvatar;
        private String icon;

        public Activity(String action, String description, String status, String type) {
            this.action = action;
            this.description = description;
            this.status = status;
            this.type = type;
            this.createdAt = new java.util.Date();
            this.icon = getIconForType(type);
        }

        private String getIconForType(String type) {
            switch (type != null ? type.toLowerCase() : "") {
                case "success": return "fa-check-circle";
                case "warning": return "fa-exclamation-triangle";
                case "error": return "fa-times-circle";
                case "info": return "fa-info-circle";
                default: return "fa-circle";
            }
        }

        public String getStatusClass() {
            switch (status != null ? status.toLowerCase() : "") {
                case "success": return "text-success";
                case "warning": return "text-warning";
                case "error": return "text-danger";
                case "pending": return "text-warning";
                default: return "text-info";
            }
        }

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
        public String getAction() { return action; }
        public void setAction(String action) { this.action = action; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public java.util.Date getCreatedAt() { return createdAt; }
        public void setCreatedAt(java.util.Date createdAt) { this.createdAt = createdAt; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; this.icon = getIconForType(type); }
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public String getUserRole() { return userRole; } // Updated to userRole
        public void setUserRole(String userRole) { this.userRole = userRole; }
        public String getUserAvatar() { return userAvatar; }
        public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
        public String getIcon() { return icon; }
        public void setIcon(String icon) { this.icon = icon; }
    }
}