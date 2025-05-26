package dao;

import model.Accommodation;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Logger;
import java.util.logging.Level;

public class AccommodationDAO {
    private static final Logger LOGGER = Logger.getLogger(AccommodationDAO.class.getName());
    
    /**
     * Get accommodation by ID
     */
    public Accommodation getAccommodationById(int accommodationId) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.accommodationId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAccommodation(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get pending accommodations with pagination
     */
    public List<Accommodation> getPendingAccommodations(int page, int pageSize) throws SQLException {
        return getPendingAccommodations(page, pageSize, null);
    }
    
    /**
     * Get pending accommodations with pagination and type filter
     */
    public List<Accommodation> getPendingAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 0
        """);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
        }
        
        sql.append(" ORDER BY a.createdAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(paramIndex++, type);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            return executeAccommodationQuery(ps);
        }
    }
    
    /**
     * Get approved accommodations with pagination
     */
    public List<Accommodation> getApprovedAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
        """);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
        }
        
        sql.append(" ORDER BY a.createdAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(paramIndex++, type);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            return executeAccommodationQuery(ps);
        }
    }
    
    /**
     * Get rejected accommodations with pagination
     */
    public List<Accommodation> getRejectedAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = -1
        """);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
        }
        
        sql.append(" ORDER BY a.createdAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(paramIndex++, type);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            return executeAccommodationQuery(ps);
        }
    }
    
    /**
     * Get all accommodations with pagination
     */
    public List<Accommodation> getAllAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE 1=1
        """);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
        }
        
        sql.append(" ORDER BY a.createdAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(paramIndex++, type);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            return executeAccommodationQuery(ps);
        }
    }
    
    /**
     * Get old pending accommodations
     */
    public List<Accommodation> getOldPendingAccommodations(int daysOld) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 0 AND a.createdAt < DATEADD(DAY, ?, GETDATE())
            ORDER BY a.createdAt ASC
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, -daysOld);
            return executeAccommodationQuery(ps);
        }
    }
    
    /**
     * Approve accommodation
     */
    public boolean approveAccommodation(int accommodationId) throws SQLException {
        String sql = "UPDATE Accommodations SET isActive = 1, approvedAt = GETDATE() WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Reject accommodation
     */
    public boolean rejectAccommodation(int accommodationId, String reason, boolean allowResubmit) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET isActive = -1, rejectionReason = ?, rejectedAt = GETDATE(), allowResubmit = ?
            WHERE accommodationId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reason);
            ps.setBoolean(2, allowResubmit);
            ps.setInt(3, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Revoke approval
     */
    public boolean revokeApproval(int accommodationId, String reason) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET isActive = 0, rejectionReason = ?, revokedAt = GETDATE()
            WHERE accommodationId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reason);
            ps.setInt(2, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Soft delete accommodation
     */
    public boolean softDeleteAccommodation(int accommodationId, String reason) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET isDeleted = 1, deleteReason = ?, deletedAt = GETDATE()
            WHERE accommodationId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reason);
            ps.setInt(2, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Restore accommodation
     */
    public boolean restoreAccommodation(int accommodationId) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET isDeleted = 0, deleteReason = NULL, deletedAt = NULL, restoredAt = GETDATE()
            WHERE accommodationId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Permanent delete accommodation
     */
    public boolean permanentDeleteAccommodation(int accommodationId) throws SQLException {
        String sql = "DELETE FROM Accommodations WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Get pending accommodations count
     */
    public int getPendingAccommodationsCount() throws SQLException {
        return getPendingAccommodationsCount(null);
    }
    
    /**
     * Get pending accommodations count with type filter
     */
    public int getPendingAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE isActive = 0");
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(1, type);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get approved accommodations count
     */
    public int getApprovedAccommodationsCount() throws SQLException {
        return getApprovedAccommodationsCount(null);
    }
    
    /**
     * Get approved accommodations count with type filter
     */
    public int getApprovedAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE isActive = 1");
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(1, type);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get rejected accommodations count
     */
    public int getRejectedAccommodationsCount() throws SQLException {
        return getRejectedAccommodationsCount(null);
    }
    
    /**
     * Get rejected accommodations count with type filter
     */
    public int getRejectedAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE isActive = -1");
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(1, type);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get total accommodations count
     */
    public int getTotalAccommodationsCount() throws SQLException {
        return getTotalAccommodationsCount(null);
    }
    
    /**
     * Get total accommodations count with type filter
     */
    public int getTotalAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE 1=1");
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(1, type);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get active accommodations count
     */
    public int getActiveAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE isActive = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Get accommodations by region
     */
    public Map<String, Integer> getAccommodationsByRegion() throws SQLException {
        Map<String, Integer> regionCounts = new HashMap<>();
        
        String sql = """
            SELECT r.name as regionName, COUNT(a.accommodationId) as count
            FROM Accommodations a
            JOIN Cities c ON a.cityId = c.cityId
            JOIN Regions r ON c.regionId = r.regionId
            WHERE a.isActive = 1
            GROUP BY r.name
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                regionCounts.put(rs.getString("regionName"), rs.getInt("count"));
            }
        }
        
        return regionCounts;
    }
    
    /**
     * Get monthly growth data
     */
    public List<Integer> getMonthlyGrowthData(int months) throws SQLException {
        List<Integer> data = new ArrayList<>();
        
        String sql = """
            SELECT COUNT(*) as count
            FROM Accommodations 
            WHERE createdAt >= DATEADD(MONTH, ?, GETDATE())
            AND createdAt < DATEADD(MONTH, ?, GETDATE())
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = months - 1; i >= 0; i--) {
                ps.setInt(1, -i - 1);
                ps.setInt(2, -i);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        data.add(rs.getInt("count"));
                    } else {
                        data.add(0);
                    }
                }
            }
        }
        
        return data;
    }
    
    /**
     * Get growth percentage
     */
    public double getGrowthPercentage(String period) throws SQLException {
        String sql;
        switch (period) {
            case "week":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(DAY, -7, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(DAY, -14, GETDATE()) 
                         AND createdAt < DATEADD(DAY, -7, GETDATE())) as previous_period
                """;
                break;
            case "year":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(YEAR, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(YEAR, -2, GETDATE()) 
                         AND createdAt < DATEADD(YEAR, -1, GETDATE())) as previous_period
                """;
                break;
            default: // month
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(MONTH, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(MONTH, -2, GETDATE()) 
                         AND createdAt < DATEADD(MONTH, -1, GETDATE())) as previous_period
                """;
        }
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int currentPeriod = rs.getInt("current_period");
                int previousPeriod = rs.getInt("previous_period");
                
                if (previousPeriod == 0) {
                    return currentPeriod > 0 ? 100.0 : 0.0;
                }
                
                return ((double) (currentPeriod - previousPeriod) / previousPeriod) * 100.0;
            }
        }
        
        return 0.0;
    }
    
    /**
     * Execute accommodation query and return list
     */
    private List<Accommodation> executeAccommodationQuery(PreparedStatement ps) throws SQLException {
        List<Accommodation> accommodations = new ArrayList<>();
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                accommodations.add(mapResultSetToAccommodation(rs));
            }
        }
        
        return accommodations;
    }
    
    /**
     * Map ResultSet to Accommodation object
     */
    private Accommodation mapResultSetToAccommodation(ResultSet rs) throws SQLException {
        Accommodation accommodation = new Accommodation();
        
        accommodation.setAccommodationId(rs.getInt("accommodationId"));
        accommodation.setName(rs.getString("name"));
        accommodation.setType(rs.getString("type"));
        accommodation.setDescription(rs.getString("description"));
        accommodation.setAddress(rs.getString("address"));
        accommodation.setCityId(rs.getInt("cityId"));
        accommodation.setHostId(rs.getInt("hostId"));
        accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
        accommodation.setMaxGuests(rs.getInt("maxGuests"));
        accommodation.setBedrooms(rs.getInt("bedrooms"));
        accommodation.setBathrooms(rs.getInt("bathrooms"));
        accommodation.setAmenities(rs.getString("amenities"));
        accommodation.setImages(rs.getString("images"));
        accommodation.setActive(rs.getInt("isActive") == 1);
        accommodation.setCreatedAt(rs.getTimestamp("createdAt"));
        accommodation.setRejectionReason(rs.getString("rejectionReason"));
        
        // Set additional fields from joins
        accommodation.setHostName(rs.getString("hostName"));
        accommodation.setCityName(rs.getString("cityName"));
        
        return accommodation;
    }
}