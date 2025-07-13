package controller;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ReportServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("=== REPORT SERVLET STARTED ===");
            
            // Test database connection first
            ReportDAO dao = new ReportDAO();
            boolean dbConnected = dao.testConnection();
            if (!dbConnected) {
                System.out.println("ERROR: Database connection failed");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }
            
            String contentType = request.getParameter("contentType");
            String contentIdStr = request.getParameter("contentId");
            String reason = request.getParameter("reason");
            String description = request.getParameter("description");

            System.out.println("Raw parameters:");
            System.out.println("- contentType: " + contentType);
            System.out.println("- contentId: " + contentIdStr);
            System.out.println("- reason: " + reason);
            System.out.println("- description: " + description);

            // Validate parameters
            if (contentType == null || contentIdStr == null || reason == null) {
                System.out.println("ERROR: Missing required parameters");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int contentId = Integer.parseInt(contentIdStr);

            // Lấy reporterId từ session
            Integer reporterId = null;
            Object userObj = request.getSession().getAttribute("user");
            System.out.println("Session user object: " + userObj);
            
            if (userObj != null && userObj instanceof model.User) {
                reporterId = ((model.User) userObj).getUserId();
                System.out.println("Extracted reporterId: " + reporterId);
            } else {
                System.out.println("ERROR: User not found in session or wrong type");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            if (reporterId == null) {
                System.out.println("ERROR: reporterId is null");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            System.out.println("=== CALLING DAO ===");
            System.out.println("Insert report: " + contentType + ", " + contentId + ", " + reporterId + ", " + reason + ", " + description);

            dao.addReport(contentType, contentId, reporterId, reason, description);

            System.out.println("=== REPORT SAVED SUCCESSFULLY ===");
            response.setStatus(HttpServletResponse.SC_OK);
            
        } catch (NumberFormatException e) {
            System.out.println("ERROR: Invalid contentId format: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("ERROR in ReportServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
} 