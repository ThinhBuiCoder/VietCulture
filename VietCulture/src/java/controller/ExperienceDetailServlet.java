package controller;

import dao.ExperienceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Experience;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/Travel/experiences/*")
public class ExperienceDetailServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ExperienceDetailServlet.class.getName());
    private ExperienceDAO experienceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ExperienceDetailServlet doGet called");
        String pathInfo = request.getPathInfo();
        LOGGER.info("Path info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            LOGGER.warning("No experience ID provided");
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Vui lòng cung cấp ID trải nghiệm");
            return;
        }

        try {
            String[] pathParts = pathInfo.split("/");
            int experienceId = Integer.parseInt(pathParts[1]);
            LOGGER.info("Getting experience with ID: " + experienceId);
            
            Experience experience = experienceDAO.getExperienceById(experienceId);

            if (experience == null) {
                LOGGER.warning("Experience not found with ID: " + experienceId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy trải nghiệm");
                return;
            }

            LOGGER.info("Experience found, forwarding to detail.jsp");
            request.setAttribute("experience", experience);
            request.getRequestDispatcher("/view/jsp/experiences/detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid experience ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID trải nghiệm không hợp lệ");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving experience", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy thông tin trải nghiệm");
        }
    }
}