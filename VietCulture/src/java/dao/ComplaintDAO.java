package dao;

import model.Complaint;
import model.User;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ComplaintDAO {
    private static final Logger LOGGER = Logger.getLogger(ComplaintDAO.class.getName());
    
    // SQL Queries
    private static final String GET_ALL_COMPLAINTS = 
        "SELECT c.*, u.fullName as userName, u.email as userEmail, " +
        "b.bookingId, b.bookingDate, b.totalAmount, " +
        "e.title as experienceTitle, a.name as accommodationName, " +
        "admin.fullName as assignedAdminName " +
        "FROM Complaints c " +
        "LEFT JOIN Users u ON c.userId = u.userId " +
        "LEFT JOIN Bookings b ON c.relatedBookingId = b.bookingId " +
        "LEFT JOIN Experiences e ON b.experienceId = e.experienceId " +
        "LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId " +
        "LEFT JOIN Users admin ON c.assignedAdminId = admin.userId " +
        "ORDER BY c.createdAt DESC";
    
    private static final String GET_COMPLAINT_BY_ID = 
        "SELECT c.*, u.fullName as userName, u.email as userEmail, " +
        "b.bookingId, b.bookingDate, b.totalAmount, " +
        "e.title as experienceTitle, a.name as accommodationName, " +
        "admin.fullName as assignedAdminName " +
        "FROM Complaints c " +
        "LEFT JOIN Users u ON c.userId = u.userId " +
        "LEFT JOIN Bookings b ON c.relatedBookingId = b.bookingId " +
        "LEFT JOIN Experiences e ON b.experienceId = e.experienceId " +
        "LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId " +
        "LEFT JOIN Users admin ON c.assignedAdminId = admin.userId " +
        "WHERE c.complaintId = ?";
    
    private static final String GET_COMPLAINTS_BY_STATUS = 
        "SELECT c.*, u.fullName as userName, u.email as userEmail, " +
        "b.bookingId, b.bookingDate, b.totalAmount, " +
        "e.title as experienceTitle, a.name as accommodationName, " +
        "admin.fullName as assignedAdminName " +
        "FROM Complaints c " +
        "LEFT JOIN Users u ON c.userId = u.userId " +
        "LEFT JOIN Bookings b ON c.relatedBookingId = b.bookingId " +
        "LEFT JOIN Experiences e ON b.experienceId = e.experienceId " +
        "LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId " +
        "LEFT JOIN Users admin ON c.assignedAdminId = admin.userId " +
        "WHERE c.status = ? " +
        "ORDER BY c.createdAt DESC";
    
    private static final String CREATE_COMPLAINT = 
        "INSERT INTO Complaints (userId, relatedBookingId, complaintText, status, createdAt) " +
        "VALUES (?, ?, ?, ?, ?)";
    
    private static final String UPDATE_COMPLAINT_STATUS = 
        "UPDATE Complaints SET status = ?, resolvedAt = ?, assignedAdminId = ? WHERE complaintId = ?";
    
    private static final String UPDATE_COMPLAINT_RESOLUTION = 
        "UPDATE Complaints SET status = ?, resolution = ?, resolvedAt = ?, assignedAdminId = ? WHERE complaintId = ?";
    
    private static final String GET_COMPLAINTS_COUNT_BY_STATUS = 
        "SELECT status, COUNT(*) as count FROM Complaints GROUP BY status";
    
    private static final String GET_NEW_COMPLAINTS_COUNT = 
        "SELECT COUNT(*) FROM Complaints WHERE status = 'OPEN'";
    
    private static final String DELETE_COMPLAINT = 
        "DELETE FROM Complaints WHERE complaintId = ?";
    
    private static final String GET_COMPLAINTS_BY_USER = 
        "SELECT c.*, u.fullName as userName, u.email as userEmail, " +
        "b.bookingId, b.bookingDate, b.totalAmount, " +
        "e.title as experienceTitle, a.name as accommodationName, " +
        "admin.fullName as assignedAdminName " +
        "FROM Complaints c " +
        "LEFT JOIN Users u ON c.userId = u.userId " +
        "LEFT JOIN Bookings b ON c.relatedBookingId = b.bookingId " +
        "LEFT JOIN Experiences e ON b.experienceId = e.experienceId " +
        "LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId " +
        "LEFT JOIN Users admin ON c.assignedAdminId = admin.userId " +
        "WHERE c.userId = ? " +
        "ORDER BY c.createdAt DESC";
    
    public List<Complaint> getAllComplaints() throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ALL_COMPLAINTS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                complaints.add(mapResultSetToComplaint(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all complaints", e);
            throw e;
        }
        
        return complaints;
    }
    
    public Complaint getComplaintById(int complaintId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_COMPLAINT_BY_ID)) {
            
            ps.setInt(1, complaintId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToComplaint(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting complaint by ID: " + complaintId, e);
            throw e;
        }
        
        return null;
    }
    
    public List<Complaint> getComplaintsByStatus(String status) throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_COMPLAINTS_BY_STATUS)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting complaints by status: " + status, e);
            throw e;
        }
        
        return complaints;
    }
    
    public boolean createComplaint(Complaint complaint) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(CREATE_COMPLAINT, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, complaint.getUserId());
            ps.setObject(2, complaint.getRelatedBookingId() != null ? complaint.getRelatedBookingId() : null);
            ps.setString(3, complaint.getComplaintText());
            ps.setString(4, complaint.getStatus());
            ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        complaint.setComplaintId(rs.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating complaint", e);
            throw e;
        }
        
        return false;
    }
    
    public boolean updateComplaintStatus(int complaintId, String status, int assignedAdminId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_COMPLAINT_STATUS)) {
            
            ps.setString(1, status);
            ps.setDate(2, "RESOLVED".equals(status) || "CLOSED".equals(status) ? 
                      new java.sql.Date(System.currentTimeMillis()) : null);
            ps.setInt(3, assignedAdminId);
            ps.setInt(4, complaintId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating complaint status", e);
            throw e;
        }
    }
    
    public boolean updateComplaintResolution(int complaintId, String status, String resolution, int assignedAdminId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_COMPLAINT_RESOLUTION)) {
            
            ps.setString(1, status);
            ps.setString(2, resolution);
            ps.setDate(3, "RESOLVED".equals(status) || "CLOSED".equals(status) ? 
                      new java.sql.Date(System.currentTimeMillis()) : null);
            ps.setInt(4, assignedAdminId);
            ps.setInt(5, complaintId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating complaint resolution", e);
            throw e;
        }
    }
    
    public int getNewComplaintsCount() throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_NEW_COMPLAINTS_COUNT);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting new complaints count", e);
            throw e;
        }
        
        return 0;
    }
    
    public java.util.Map<String, Integer> getComplaintsCountByStatus() throws SQLException {
        java.util.Map<String, Integer> statusCounts = new java.util.HashMap<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_COMPLAINTS_COUNT_BY_STATUS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                statusCounts.put(status, count);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting complaints count by status", e);
            throw e;
        }
        
        return statusCounts;
    }
    
    public boolean deleteComplaint(int complaintId) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_COMPLAINT)) {
            
            ps.setInt(1, complaintId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting complaint: " + complaintId, e);
            throw e;
        }
    }
    
    public List<Complaint> getComplaintsByUser(int userId) throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_COMPLAINTS_BY_USER)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting complaints by user: " + userId, e);
            throw e;
        }
        
        return complaints;
    }
    
    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        
        complaint.setComplaintId(rs.getInt("complaintId"));
        complaint.setUserId(rs.getInt("userId"));
        complaint.setRelatedBookingId(rs.getObject("relatedBookingId") != null ? 
                                    rs.getInt("relatedBookingId") : null);
        complaint.setComplaintText(rs.getString("complaintText"));
        complaint.setStatus(rs.getString("status"));
        complaint.setCreatedAt(rs.getDate("createdAt"));
        complaint.setResolvedAt(rs.getDate("resolvedAt"));
        complaint.setAssignedAdminId(rs.getObject("assignedAdminId") != null ? 
                                   rs.getInt("assignedAdminId") : 0);
        
        // Additional display fields
        complaint.setUserName(rs.getString("userName"));
        complaint.setUserEmail(rs.getString("userEmail"));
        complaint.setAssignedAdminName(rs.getString("assignedAdminName"));
        
        // Booking details
        if (rs.getObject("bookingId") != null) {
            String bookingDetails = "Booking #" + rs.getInt("bookingId") + 
                                  " - " + rs.getDate("bookingDate") + 
                                  " - " + rs.getBigDecimal("totalAmount") + " VND";
            complaint.setBookingDetails(bookingDetails);
        }
        
        // Experience or Accommodation title
        String experienceTitle = rs.getString("experienceTitle");
        String accommodationName = rs.getString("accommodationName");
        if (experienceTitle != null) {
            complaint.setRelatedContentTitle(experienceTitle);
        } else if (accommodationName != null) {
            complaint.setRelatedContentTitle(accommodationName);
        }
        
        return complaint;
    }
} 