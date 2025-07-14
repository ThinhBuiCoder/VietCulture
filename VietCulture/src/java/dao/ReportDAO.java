package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import utils.DBUtils;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;
import model.Report;

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

    // Lấy danh sách report theo trạng thái
    public List<Report> getReportsByStatus(String status) throws SQLException {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM Reports WHERE adminApprovalStatus = ? ORDER BY createdAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        }
        return reports;
    }

    // Lấy chi tiết report theo id
    public Report getReportById(int reportId) throws SQLException {
        String sql = "SELECT * FROM Reports WHERE reportId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReport(rs);
                }
            }
        }
        return null;
    }

    // Duyệt báo cáo
    public boolean approveReport(int reportId, int adminId, String notes) throws SQLException {
        String sql = "UPDATE Reports SET adminApprovalStatus = 'APPROVED', adminApprovedBy = ?, adminApprovedAt = GETDATE(), adminNotes = ? WHERE reportId = ? AND adminApprovalStatus = 'PENDING'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, notes);
            ps.setInt(3, reportId);
            return ps.executeUpdate() > 0;
        }
    }

    // Từ chối báo cáo
    public boolean rejectReport(int reportId, int adminId, String reason, String notes) throws SQLException {
        String sql = "UPDATE Reports SET adminApprovalStatus = 'REJECTED', adminApprovedBy = ?, adminApprovedAt = GETDATE(), adminRejectReason = ?, adminNotes = ? WHERE reportId = ? AND adminApprovalStatus = 'PENDING'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, reason);
            ps.setString(3, notes);
            ps.setInt(4, reportId);
            return ps.executeUpdate() > 0;
        }
    }

    // Hàm hỗ trợ chuyển ResultSet sang Report
    private Report mapResultSetToReport(ResultSet rs) throws SQLException {
        Report report = new Report();
        report.setReportId(rs.getInt("reportId"));
        report.setContentType(rs.getString("contentType"));
        report.setContentId(rs.getInt("contentId"));
        report.setReporterId(rs.getInt("reporterId"));
        report.setReason(rs.getString("reason"));
        report.setDescription(rs.getString("description"));
        report.setCreatedAt(rs.getTimestamp("createdAt"));
        report.setStatus(rs.getString("status"));
        // KHÔNG set reporterName nếu không join Users
        // Các trường admin
        report.setAdminApprovalStatus(rs.getString("adminApprovalStatus"));
        report.setAdminApprovedBy(rs.getInt("adminApprovedBy"));
        report.setAdminApprovedAt(rs.getTimestamp("adminApprovedAt"));
        report.setAdminRejectReason(rs.getString("adminRejectReason"));
        report.setAdminNotes(rs.getString("adminNotes"));
        return report;
    }
} 