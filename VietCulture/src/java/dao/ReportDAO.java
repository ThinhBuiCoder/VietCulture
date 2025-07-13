package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import utils.DBUtils;

public class ReportDAO {
    
    // Method test kết nối database
    public boolean testConnection() {
        try (Connection conn = DBUtils.getConnection()) {
            System.out.println("=== TESTING DATABASE CONNECTION ===");
            System.out.println("Connection: " + (conn != null ? "SUCCESS" : "FAILED"));
            if (conn != null) {
                System.out.println("Database: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("URL: " + conn.getMetaData().getURL());
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.out.println("Connection test failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public void addReport(String contentType, int contentId, int reporterId, String reason, String description) {
        String sql = "INSERT INTO Reports (contentType, contentId, reporterId, reason, description, createdAt, status) VALUES (?, ?, ?, ?, ?, GETDATE(), 'PENDING')";
        
        System.out.println("=== REPORT DAO STARTED ===");
        System.out.println("SQL: " + sql);
        System.out.println("Parameters:");
        System.out.println("- contentType: " + contentType);
        System.out.println("- contentId: " + contentId);
        System.out.println("- reporterId: " + reporterId);
        System.out.println("- reason: " + reason);
        System.out.println("- description: " + description);
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            System.out.println("Database connection: " + (conn != null ? "SUCCESS" : "FAILED"));
            
            if (conn == null) {
                System.out.println("ERROR: Database connection is null");
                throw new SQLException("Database connection failed");
            }
            
            ps.setString(1, contentType);
            ps.setInt(2, contentId);
            ps.setInt(3, reporterId);
            ps.setString(4, reason);
            ps.setString(5, description);
            
            System.out.println("Executing SQL update...");
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("=== REPORT INSERTED SUCCESSFULLY ===");
            } else {
                System.out.println("WARNING: No rows were affected");
            }
            
        } catch (SQLException e) {
            System.out.println("=== SQL ERROR ===");
            System.out.println("Error message: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            throw new RuntimeException("Failed to insert report", e);
        } catch (Exception e) {
            System.out.println("=== UNEXPECTED ERROR ===");
            System.out.println("Error message: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error while inserting report", e);
        }
    }
} 