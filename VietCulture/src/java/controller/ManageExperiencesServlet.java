package controller;

import dao.ExperienceDAO;
import model.Experience;
import model.User;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "manage_experiences", urlPatterns = {
    "/host/experiences/manage",
    "/host/experiences/filter"
})
public class ManageExperiencesServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManageExperiencesServlet.class.getName());
    private static final int PAGE_SIZE = 12;

    private ExperienceDAO experienceDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            super.init();
            experienceDAO = new ExperienceDAO();
            gson = new Gson();
            LOGGER.info("ManageExperiencesServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ManageExperiencesServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isHostAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getServletPath();
        try {
            switch (pathInfo) {
                case "/host/experiences/manage":
                    handleManageExperiences(request, response);
                    break;
                case "/host/experiences/filter":
                    handleFilterExperiences(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid endpoint");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving experiences", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách trải nghiệm.");
            request.getRequestDispatcher("/view/jsp/host/experiences/manage_experiences.jsp").forward(request, response);
        }
    }

    /**
     * Handle the main manage experiences page
     */
    private void handleManageExperiences(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int hostId = user.getUserId();

        // Get pagination parameters
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * PAGE_SIZE;

        // Get list of experiences based on host ID with pagination
        List<Experience> experiences = experienceDAO.getExperiencesByHost(hostId, offset, PAGE_SIZE);
        request.setAttribute("experiences", experiences);

        // Get total count for pagination
        int totalExperiences = experienceDAO.getTotalExperiencesByHost(hostId);
        int totalPages = (int) Math.ceil((double) totalExperiences / PAGE_SIZE);
        
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Get summary statistics
        Map<String, Object> stats = getExperienceStatistics(hostId);
        stats.forEach(request::setAttribute);

        // Forward to JSP
        request.getRequestDispatcher("/view/jsp/host/experiences/manage_experiences.jsp").forward(request, response);
    }

    /**
     * Handle AJAX filter for experiences
     */
    private void handleFilterExperiences(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int hostId = user.getUserId();

        Map<String, Object> responseData = new HashMap<>();

        // Get pagination parameters
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * PAGE_SIZE;

        // Get filtered experiences with pagination
        List<Experience> experiences = experienceDAO.getExperiencesByHost(hostId, offset, PAGE_SIZE);
        responseData.put("experiences", experiences);

        // Get total count for pagination
        int totalExperiences = experienceDAO.getTotalExperiencesByHost(hostId);
        int totalPages = (int) Math.ceil((double) totalExperiences / PAGE_SIZE);
        
        responseData.put("currentPage", page);
        responseData.put("totalPages", totalPages);

        // Get updated statistics
        Map<String, Object> stats = getExperienceStatistics(hostId);
        responseData.put("statistics", stats);

        responseData.put("success", true);

        sendJsonResponse(response, responseData);
    }

    /**
     * Get experience statistics for the host
     */
    private Map<String, Object> getExperienceStatistics(int hostId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        // Total experiences
        int totalExperiences = experienceDAO.getTotalExperiencesByHost(hostId);
        stats.put("totalExperiences", totalExperiences);

        // Count by status
        int activeExperiences = experienceDAO.getActiveExperiencesCount();
        int pendingExperiences = experienceDAO.getPendingExperiencesCount();
        int inactiveExperiences = totalExperiences - activeExperiences - pendingExperiences;

        stats.put("activeExperiences", activeExperiences);
        stats.put("pendingExperiences", pendingExperiences);
        stats.put("inactiveExperiences", inactiveExperiences);

        return stats;
    }

    /**
     * Check if user is authenticated host
     */
    private boolean isHostAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        User user = (User) session.getAttribute("user");
        return user != null && "HOST".equals(user.getRole());
    }

    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(data));
            out.flush();
        }
    }
}