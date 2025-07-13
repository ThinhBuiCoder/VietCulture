package controller;

import dao.ReportDAO;
import java.io.IOException;
import java.io.PrintWriter;

public class WebTestServlet {
    
    public static String testReportFromWeb() {
        StringBuilder result = new StringBuilder();
        result.append("<html><body>");
        result.append("<h2>Report Test Results</h2>");
        
        try {
            ReportDAO dao = new ReportDAO();
            
            // Test database connection
            boolean dbConnected = dao.testConnection();
            result.append("<p>Database Connection: ").append(dbConnected ? "SUCCESS" : "FAILED").append("</p>");
            
            if (dbConnected) {
                // Test insert report
                result.append("<p>Testing insert report...</p>");
                dao.addReport("experience", 1, 1, "test reason", "test description");
                result.append("<p>Report Insert: SUCCESS</p>");
            }
            
        } catch (Exception e) {
            result.append("<p>Error: ").append(e.getMessage()).append("</p>");
            e.printStackTrace();
        }
        
        result.append("</body></html>");
        return result.toString();
    }
} 