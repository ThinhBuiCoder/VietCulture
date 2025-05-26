package dao;

import model.Host;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class HostDAO {
    private static final Logger LOGGER = Logger.getLogger(HostDAO.class.getName());
    
    /**
     * Get total revenue by host
     */
    public double getTotalRevenue(int hostId) throws SQLException {
        String sql = """
            SELECT ISNULL(SUM(b.totalPrice), 0) as totalRevenue
            FROM Bookings b
            LEFT JOIN Experiences e ON b.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId
            WHERE (e.hostId = ? OR a.hostId = ?) AND b.status = 'COMPLETED'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            ps.setInt(2, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("totalRevenue");
                }
            }
        }
        return 0.0;
    }
    
    /**
     * Get host by user ID
     */
    public Host getHostByUserId(int userId) throws SQLException {
        String sql = """
            SELECT h.userId, h.businessName, h.businessType, h.businessAddress,
                   h.businessDescription, h.taxId, h.skills, h.region,
                   h.averageRating, h.totalExperiences, h.totalRevenue,
                   u.fullName, u.email, u.phone, u.avatar
            FROM Hosts h
            LEFT JOIN Users u ON h.userId = u.userId
            WHERE h.userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapHostFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Create new host
     */
    public boolean createHost(Host host) throws SQLException {
        String sql = """
            INSERT INTO Hosts (userId, businessName, businessType, businessAddress,
                             businessDescription, taxId, skills, region, averageRating,
                             totalExperiences, totalRevenue)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, host.getUserId());
            ps.setString(2, host.getBusinessName());
            ps.setString(3, host.getBusinessType());
            ps.setString(4, host.getBusinessAddress());
            ps.setString(5, host.getBusinessDescription());
            ps.setString(6, host.getTaxId());
            ps.setString(7, host.getSkills());
            ps.setString(8, host.getRegion());
            ps.setDouble(9, host.getAverageRating());
            ps.setInt(10, host.getTotalExperiences());
            ps.setDouble(11, host.getTotalRevenue());
            
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Host created for user ID: " + host.getUserId());
            return rowsAffected > 0;
        }
    }
    
    /**
     * Update host information
     */
    public boolean updateHost(Host host) throws SQLException {
        String sql = """
            UPDATE Hosts 
            SET businessName = ?, businessType = ?, businessAddress = ?,
                businessDescription = ?, taxId = ?, skills = ?, region = ?
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, host.getBusinessName());
            ps.setString(2, host.getBusinessType());
            ps.setString(3, host.getBusinessAddress());
            ps.setString(4, host.getBusinessDescription());
            ps.setString(5, host.getTaxId());
            ps.setString(6, host.getSkills());
            ps.setString(7, host.getRegion());
            ps.setInt(8, host.getUserId());
            
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Host updated for user ID: " + host.getUserId());
            return rowsAffected > 0;
        }
    }
    
    /**
     * Update host statistics
     */
    public boolean updateHostStats(int userId, double averageRating, int totalExperiences, double totalRevenue) throws SQLException {
        String sql = """
            UPDATE Hosts 
            SET averageRating = ?, totalExperiences = ?, totalRevenue = ?
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, averageRating);
            ps.setInt(2, totalExperiences);
            ps.setDouble(3, totalRevenue);
            ps.setInt(4, userId);
            
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Host stats updated for user ID: " + userId);
            return rowsAffected > 0;
        }
    }
    
    /**
     * Get all hosts with pagination
     */
    public List<Host> getAllHosts(int offset, int limit) throws SQLException {
        List<Host> hosts = new ArrayList<>();
        
        String sql = """
            SELECT h.userId, h.businessName, h.businessType, h.businessAddress,
                   h.businessDescription, h.taxId, h.skills, h.region,
                   h.averageRating, h.totalExperiences, h.totalRevenue,
                   u.fullName, u.email, u.phone, u.avatar, u.isActive
            FROM Hosts h
            LEFT JOIN Users u ON h.userId = u.userId
            WHERE u.isActive = 1
            ORDER BY h.totalRevenue DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Host host = mapHostFromResultSet(rs);
                    hosts.add(host);
                }
            }
        }
        return hosts;
    }
    
    /**
     * Search hosts by keyword and region
     */
    public List<Host> searchHosts(String keyword, String region, int offset, int limit) throws SQLException {
        List<Host> hosts = new ArrayList<>();
        
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT h.userId, h.businessName, h.businessType, h.businessAddress,
                   h.businessDescription, h.taxId, h.skills, h.region,
                   h.averageRating, h.totalExperiences, h.totalRevenue,
                   u.fullName, u.email, u.phone, u.avatar, u.isActive
            FROM Hosts h
            LEFT JOIN Users u ON h.userId = u.userId
            WHERE u.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append(" AND (h.businessName LIKE ? OR u.fullName LIKE ? OR h.businessDescription LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        if (region != null && !region.trim().isEmpty()) {
            sqlBuilder.append(" AND h.region = ?");
            parameters.add(region);
        }
        
        sqlBuilder.append(" ORDER BY h.averageRating DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Host host = mapHostFromResultSet(rs);
                    hosts.add(host);
                }
            }
        }
        return hosts;
    }
    
    /**
     * Get hosts count by region
     */
    public int getHostsCountByRegion(String region) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Hosts h
            LEFT JOIN Users u ON h.userId = u.userId
            WHERE u.isActive = 1 AND h.region = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, region);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get total hosts count
     */
    public int getTotalHostsCount() throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Hosts h
            LEFT JOIN Users u ON h.userId = u.userId
            WHERE u.isActive = 1
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get top hosts by rating
     */
    public List<Host> getTopHosts(int limit) throws SQLException {
        List<Host> hosts = new ArrayList<>();
        
        String sql = """
            SELECT TOP(?) h.userId, h.businessName, h.businessType, h.businessAddress,
                   h.businessDescription, h.taxId, h.skills, h.region,
                   h.averageRating, h.totalExperiences, h.totalRevenue,
                   u.fullName, u.email, u.phone, u.avatar
            FROM Hosts h
            LEFT JOIN Users u ON h.userId = u.userId
            WHERE u.isActive = 1 AND h.averageRating > 0
            ORDER BY h.averageRating DESC, h.totalExperiences DESC
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Host host = mapHostFromResultSet(rs);
                    hosts.add(host);
                }
            }
        }
        return hosts;
    }
    
    /**
     * Update host average rating
     */
    public boolean updateHostRating(int userId, double averageRating) throws SQLException {
        String sql = "UPDATE Hosts SET averageRating = ? WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, averageRating);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Increment total experiences count
     */
    public boolean incrementTotalExperiences(int userId) throws SQLException {
        String sql = "UPDATE Hosts SET totalExperiences = totalExperiences + 1 WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Update total revenue
     */
    public boolean updateTotalRevenue(int userId, double totalRevenue) throws SQLException {
        String sql = "UPDATE Hosts SET totalRevenue = ? WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, totalRevenue);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Map ResultSet to Host object
     */
    private Host mapHostFromResultSet(ResultSet rs) throws SQLException {
        Host host = new Host();
        host.setUserId(rs.getInt("userId"));
        host.setBusinessName(rs.getString("businessName"));
        host.setBusinessType(rs.getString("businessType"));
        host.setBusinessAddress(rs.getString("businessAddress"));
        host.setBusinessDescription(rs.getString("businessDescription"));
        host.setTaxId(rs.getString("taxId"));
        host.setSkills(rs.getString("skills"));
        host.setRegion(rs.getString("region"));
        host.setAverageRating(rs.getDouble("averageRating"));
        host.setTotalExperiences(rs.getInt("totalExperiences"));
        host.setTotalRevenue(rs.getDouble("totalRevenue"));
        
        // Set user info if available
        if (rs.getString("fullName") != null) {
            host.setFullName(rs.getString("fullName"));
            host.setEmail(rs.getString("email"));
            host.setPhone(rs.getString("phone"));
            host.setAvatar(rs.getString("avatar"));
        }
        
        return host;
    }
}