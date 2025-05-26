package controller;

import dao.ExperienceDAO;
import dao.UserDAO;
import dao.CityDAO;
import model.Experience;
import model.User;
import model.City;
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
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminExperienceApproval", urlPatterns = {
    "/admin/experiences/approval",
    "/admin/experiences/approval/*",
    "/admin/experiences/*/approve",
    "/admin/experiences/*/delete",
    "/admin/experiences/approve-all",
    "/admin/experiences/*/images"
})
public class AdminExperienceApprovalServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminExperienceApprovalServlet.class.getName());

    private ExperienceDAO experienceDAO;
    private UserDAO userDAO;
    private CityDAO cityDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
        userDAO = new UserDAO();
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

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleExperiencesList(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                int experienceId = Integer.parseInt(pathInfo.substring(1));
                handleExperienceDetail(request, response, experienceId);
            } else if (pathInfo.matches("/\\d+/images")) {
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleGetExperienceImages(request, response, experienceId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in experience approval", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu.");
            request.getRequestDispatcher("/view/jsp/admin/content/experience-approval.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid experience ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminAuthenticated(request)) {
            sendJsonResponse(response, false, "Unauthorized", null);
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.matches("/\\d+/approve")) {
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleApproveExperience(request, response, experienceId);
            } else if (pathInfo != null && pathInfo.matches("/\\d+/delete")) {
                int experienceId = Integer.parseInt(pathInfo.split("/")[1]);
                handleDeleteExperience(request, response, experienceId);
            } else if ("/approve-all".equals(pathInfo)) {
                handleApproveAll(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in experience approval POST", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid experience ID format in POST", e);
            sendJsonResponse(response, false, "ID không hợp lệ", null);
        }
    }

    private void handleExperiencesList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String filter = request.getParameter("filter"); // pending, approved, all
        int page = 1;
        int pageSize = 12;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<Experience> experiences;
        int totalExperiences;

        switch (filter != null ? filter : "pending") {
            case "approved":
                experiences = experienceDAO.getApprovedExperiences(page, pageSize);
                totalExperiences = experienceDAO.getApprovedExperiencesCount();
                break;
            case "all":
                experiences = experienceDAO.getAllExperiences(page, pageSize);
                totalExperiences = experienceDAO.getTotalExperiencesCount();
                break;
            default: // pending
                experiences = experienceDAO.getPendingExperiences(page, pageSize);
                totalExperiences = experienceDAO.getPendingExperiencesCount();
                break;
        }

        for (Experience exp : experiences) {
            if (exp.getHostId() > 0) {
                User host = userDAO.getUserById(exp.getHostId());
                exp.setHost(host);
            }
            if (exp.getCityId() > 0) {
                City city = cityDAO.getCityById(exp.getCityId());
                exp.setCity(city);
            }
        }

        int totalPages = (int) Math.ceil((double) totalExperiences / pageSize);

        int pendingCount = experienceDAO.getPendingExperiencesCount();
        int approvedCount = experienceDAO.getApprovedExperiencesCount();
        int totalCount = experienceDAO.getTotalExperiencesCount();

        request.setAttribute("experiences", experiences);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalExperiences", totalExperiences);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentFilter", filter != null ? filter : "pending");

        request.getRequestDispatcher("/view/jsp/admin/content/experience-approval.jsp").forward(request, response);
    }

    private void handleExperienceDetail(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, ServletException, IOException {

        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Experience không tồn tại");
            return;
        }

        if (experience.getHostId() > 0) {
            User host = userDAO.getUserById(experience.getHostId());
            experience.setHost(host);
        }

        if (experience.getCityId() > 0) {
            City city = cityDAO.getCityById(experience.getCityId());
            experience.setCity(city);
        }

        request.setAttribute("experience", experience);
        request.getRequestDispatcher("/view/jsp/admin/content/experience-detail.jsp").forward(request, response);
    }

    private void handleGetExperienceImages(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, IOException {

        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience not found", null);
            return;
        }

        String[] images = experience.getImageList();

        Map<String, Object> data = new HashMap<>();
        data.put("images", images != null ? images : new String[0]);

        sendJsonResponse(response, true, "Success", data);
    }

    private void handleApproveExperience(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, IOException {

        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience không tồn tại.", null);
            return;
        }

        if (experience.isActive()) {
            sendJsonResponse(response, false, "Experience đã được duyệt rồi.", null);
            return;
        }

        boolean success = experienceDAO.approveExperience(experienceId);

        if (success) {
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " approved experience ID: " + experienceId);
            sendJsonResponse(response, true, "Experience đã được duyệt thành công!", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi duyệt experience.", null);
        }
    }

    private void handleDeleteExperience(HttpServletRequest request, HttpServletResponse response, int experienceId)
            throws SQLException, IOException {

        Experience experience = experienceDAO.getExperienceById(experienceId);
        if (experience == null) {
            sendJsonResponse(response, false, "Experience không tồn tại.", null);
            return;
        }

        boolean success = experienceDAO.deleteExperience(experienceId);

        if (success) {
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            String adminEmail = admin != null ? admin.getEmail() : "Unknown";
            LOGGER.info("Admin " + adminEmail + " deleted experience ID: " + experienceId);
            sendJsonResponse(response, true, "Experience đã bị xóa.", null);
        } else {
            sendJsonResponse(response, false, "Có lỗi xảy ra khi xóa experience.", null);
        }
    }

    private void handleApproveAll(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        List<Experience> pendingExperiences = experienceDAO.getPendingExperiences(1, 1000);

        if (pendingExperiences.isEmpty()) {
            sendJsonResponse(response, false, "Không có experience nào cần duyệt.", null);
            return;
        }

        int approvedCount = 0;

        for (Experience exp : pendingExperiences) {
            try {
                if (experienceDAO.approveExperience(exp.getExperienceId())) {
                    approvedCount++;
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to approve experience ID: " + exp.getExperienceId(), e);
            }
        }

        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        String adminEmail = admin != null ? admin.getEmail() : "Unknown";
        LOGGER.info("Admin " + adminEmail + " bulk approved " + approvedCount + " experiences");

        Map<String, Object> data = new HashMap<>();
        data.put("count", approvedCount);
        data.put("total", pendingExperiences.size());

        sendJsonResponse(response, true, "Đã duyệt " + approvedCount + " experiences thành công!", data);
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole()); // Updated to role
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        if (data != null) {
            jsonResponse.put("data", data);
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error sending JSON response", e);
        }
    }
}