// ✅ TẠO SERVLET MỚI RIÊNG CHO TOGGLE
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Experience;
import model.Accommodation;
import dao.ExperienceDAO;
import dao.AccommodationDAO;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.sql.SQLException;

@WebServlet(name = "ToggleServiceServlet", urlPatterns = {"/host/toggle-service"})
public class ToggleServiceServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ToggleServiceServlet.class.getName());
    
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            LOGGER.info("ToggleServiceServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ToggleServiceServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String serviceType = request.getParameter("serviceType");
        String serviceIdStr = request.getParameter("serviceId");
        
        LOGGER.info("=== TOGGLE SERVICE REQUEST ===");
        LOGGER.info("Service Type: " + serviceType);
        LOGGER.info("Service ID: " + serviceIdStr);
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Context Path: " + request.getContextPath());
        
        try {
            // Check authentication
            if (!isHostAuthenticated(request)) {
                LOGGER.warning("User not authenticated");
                response.sendRedirect(request.getContextPath() + "/Travel/login");
                return;
            }

            User currentUser = getCurrentUser(request);
            LOGGER.info("Current user: " + currentUser.getUserId());
            
            // Validate parameters
            if (serviceType == null || serviceIdStr == null) {
                LOGGER.warning("Missing parameters - serviceType: " + serviceType + ", serviceId: " + serviceIdStr);
                setErrorMessage(request, "Thiếu thông tin dịch vụ");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            int serviceId;
            try {
                serviceId = Integer.parseInt(serviceIdStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid service ID: " + serviceIdStr);
                setErrorMessage(request, "ID dịch vụ không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            boolean success = false;
            String message = "";
            
            if ("experience".equals(serviceType)) {
                success = toggleExperience(currentUser, serviceId);
                message = success ? "Cập nhật trạng thái trải nghiệm thành công!" : "Không thể cập nhật trạng thái trải nghiệm";
            } 
            else if ("accommodation".equals(serviceType)) {
                success = toggleAccommodation(currentUser, serviceId);
                message = success ? "Cập nhật trạng thái lưu trú thành công!" : "Không thể cập nhật trạng thái lưu trú";
            } 
            else {
                LOGGER.warning("Invalid service type: " + serviceType);
                setErrorMessage(request, "Loại dịch vụ không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/host/services/manage");
                return;
            }
            
            if (success) {
                setSuccessMessage(request, message);
                LOGGER.info("Toggle successful: " + message);
            } else {
                setErrorMessage(request, message);
                LOGGER.warning("Toggle failed: " + message);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in toggle service", e);
            setErrorMessage(request, "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/host/services/manage");
    }
    
    private boolean toggleExperience(User user, int experienceId) throws SQLException {
        LOGGER.info("Toggling experience ID: " + experienceId);
        
        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            LOGGER.warning("Experience not found: " + experienceId);
            return false;
        }
        
        if (experience.getHostId() != user.getUserId()) {
            LOGGER.warning("Access denied for experience " + experienceId + " by user " + user.getUserId());
            return false;
        }
        
        boolean oldStatus = experience.isActive();
        boolean newStatus = !oldStatus;
        
        // ✅ SỬA LẠI: SỬ DỤNG PHƯƠNG THỨC updateExperience TRỰC TIẾP
        experience.setActive(newStatus);
        boolean success = experienceDAO.updateExperience(experience);
        if (success) {
            LOGGER.info("Experience " + experienceId + " visibility changed from " + oldStatus + " to " + newStatus);
        } else {
            LOGGER.warning("Failed to toggle experience " + experienceId);
        }
        
        return success;
    }
    
    private boolean toggleAccommodation(User user, int accommodationId) throws SQLException {
        LOGGER.info("Toggling accommodation ID: " + accommodationId);
        
        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
        if (accommodation == null) {
            LOGGER.warning("Accommodation not found: " + accommodationId);
            return false;
        }
        
        if (accommodation.getHostId() != user.getUserId()) {
            LOGGER.warning("Access denied for accommodation " + accommodationId + " by user " + user.getUserId());
            return false;
        }
        
        boolean oldStatus = accommodation.isActive();
        boolean newStatus = !oldStatus;
        
        // ✅ SỬA LẠI: SỬ DỤNG PHƯƠNG THỨC updateAccommodation TRỰC TIẾP
        accommodation.setActive(newStatus);
        boolean success = accommodationDAO.updateAccommodation(accommodation);
        if (success) {
            LOGGER.info("Accommodation " + accommodationId + " visibility changed from " + oldStatus + " to " + newStatus);
        } else {
            LOGGER.warning("Failed to toggle accommodation " + accommodationId);
        }
        
        return success;
    }
    
    private boolean isHostAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        return user != null && 
               ("HOST".equals(user.getRole()) || "ADMIN".equals(user.getRole())) && 
               user.isActive();
    }
    
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (User) session.getAttribute("user");
    }
    
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("success", message);
    }
    
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("error", message);
    }
}