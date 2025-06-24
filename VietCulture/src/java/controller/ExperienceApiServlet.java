package controller;

import dao.ChatDAO;
import model.Experience;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/api/experiences/by-host/*")
public class ExperienceApiServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ExperienceApiServlet.class.getName());
    private ChatDAO chatDAO;
    
    @Override
    public void init() {
        chatDAO = new ChatDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Host ID is required");
            return;
        }
        
        try {
            int hostId = Integer.parseInt(pathInfo.substring(1)); // Remove leading "/"
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            List<Experience> experiences = chatDAO.getExperiencesByHostId(hostId);
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < experiences.size(); i++) {
                Experience exp = experiences.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"experienceId\":").append(exp.getExperienceId()).append(",");
                json.append("\"title\":\"").append(escapeJson(exp.getTitle())).append("\",");
                json.append("\"price\":").append(exp.getPrice());
                json.append("}");
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid host ID");
        } catch (Exception e) {
            LOGGER.severe("Error getting experiences by host: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error getting experiences");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}