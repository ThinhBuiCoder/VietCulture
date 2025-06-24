package controller;

import dao.ChatDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/api/hosts")
public class HostApiServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(HostApiServlet.class.getName());
    private ChatDAO chatDAO;
    
    @Override
    public void init() {
        chatDAO = new ChatDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<User> hosts = chatDAO.getAllHosts();
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < hosts.size(); i++) {
                User host = hosts.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"userId\":").append(host.getUserId()).append(",");
                json.append("\"fullName\":\"").append(escapeJson(host.getFullName())).append("\",");
                json.append("\"businessName\":\"").append(escapeJson(host.getBusinessName())).append("\"");
                json.append("}");
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            LOGGER.severe("Error getting hosts: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error getting hosts");
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