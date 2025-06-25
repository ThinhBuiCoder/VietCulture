package dao;

import model.Accommodation;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

public class AccommodationDAO {
    private static final Logger LOGGER = Logger.getLogger(AccommodationDAO.class.getName());

    /**
     * Get accommodation by ID
     */
public Accommodation getAccommodationById(int accommodationId) throws SQLException {
    String sql = """
        SELECT a.accommodationId, a.hostId, a.name, a.description, a.cityId, a.address,
               a.type, a.numberOfRooms, a.amenities, a.pricePerNight, a.images,
               a.createdAt, a.isActive, a.averageRating, a.totalBookings,
               u.fullName as hostName, c.vietnameseName as cityName
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
                return mapAccommodationFromResultSet(rs);
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting accommodation by ID: " + accommodationId, e);
        return null; // Return null instead of throwing
    }
    return null;
}
    /**
     * Get approved accommodations with pagination and type filter
     */
public List<Accommodation> getApprovedAccommodations(int page, int pageSize, String type) throws SQLException {
    List<Accommodation> accommodations = new ArrayList<>();
    StringBuilder sql = new StringBuilder("""
        SELECT a.accommodationId, a.hostId, a.name, a.description, a.cityId, a.address,
               a.type, a.numberOfRooms, a.amenities, a.pricePerNight, a.images,
               a.createdAt, a.isActive, a.averageRating, a.totalBookings,
               u.fullName as hostName, c.vietnameseName as cityName
        FROM Accommodations a
        LEFT JOIN Users u ON a.hostId = u.userId
        LEFT JOIN Cities c ON a.cityId = c.cityId
        WHERE a.isActive = 1
    """);
    
    List<Object> parameters = new ArrayList<>();
    
    if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
        sql.append(" AND a.type = ?");
        parameters.add(type);
    }
    
    sql.append(" ORDER BY a.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    parameters.add((page - 1) * pageSize);
    parameters.add(pageSize);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                accommodations.add(mapAccommodationFromResultSet(rs));
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting approved accommodations", e);
        throw e;
    }
    
    return accommodations;
}

    /**
     * Get approved accommodations with pagination (overload without type)
     */
    public List<Accommodation> getApprovedAccommodations(int page, int pageSize) throws SQLException {
        return getApprovedAccommodations(page, pageSize, null);
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
    List<Accommodation> accommodations = new ArrayList<>();
    StringBuilder sql = new StringBuilder("""
        SELECT a.accommodationId, a.hostId, a.name, a.description, a.cityId, a.address,
               a.type, a.numberOfRooms, a.amenities, a.pricePerNight, a.images,
               a.createdAt, a.isActive, a.averageRating, a.totalBookings,
               u.fullName as hostName, c.vietnameseName as cityName
        FROM Accommodations a
        LEFT JOIN Users u ON a.hostId = u.userId
        LEFT JOIN Cities c ON a.cityId = c.cityId
        WHERE a.isActive = 0
    """);
    
    List<Object> parameters = new ArrayList<>();
    
    if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
        sql.append(" AND a.type = ?");
        parameters.add(type);
    }
    
    sql.append(" ORDER BY a.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    parameters.add((page - 1) * pageSize);
    parameters.add(pageSize);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                accommodations.add(mapAccommodationFromResultSet(rs));
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting pending accommodations", e);
        throw e;
    }
    
    return accommodations;
}
    /**
     * Get accommodations with advanced filtering and search
     */
    public List<Accommodation> searchAccommodations(String type, int regionId, int cityId, 
                                                   String sortBy, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        // Add filters
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        // Add sorting
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "price-asc":
                    sql.append(" ORDER BY a.pricePerNight ASC");
                    break;
                case "price-desc":
                    sql.append(" ORDER BY a.pricePerNight DESC");
                    break;
                case "rating":
                    sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
                    break;
                case "newest":
                    sql.append(" ORDER BY a.createdAt DESC");
                    break;
                default:
                    sql.append(" ORDER BY a.createdAt DESC");
            }
        } else {
            sql.append(" ORDER BY a.createdAt DESC");
        }

        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get search results count
     */
    public int getSearchAccommodationsCount(String type, int regionId, int cityId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) 
            FROM Accommodations a
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
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
     * Get popular accommodations (high booking count and rating)
     */
    public List<Accommodation> getPopularAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            AND a.totalBookings >= 5 AND a.averageRating >= 4.0
            ORDER BY a.totalBookings DESC, a.averageRating DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get newest accommodations
     */
    public List<Accommodation> getNewestAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get top-rated accommodations
     */
    public List<Accommodation> getTopRatedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            AND a.averageRating > 0
            ORDER BY a.averageRating DESC, a.totalBookings DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get low-price accommodations
     */
    public List<Accommodation> getLowPriceAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            ORDER BY a.pricePerNight ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get accommodations by multiple criteria with enhanced filtering
     */
    public List<Accommodation> getAccommodationsWithFilters(String type, int regionId, int cityId, 
                                                           String filter, String sortBy, 
                                                           int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        // Apply specific filters
        if ("popular".equals(filter)) {
            sql.append(" AND a.totalBookings >= 5 AND a.averageRating >= 4.0");
        } else if ("top-rated".equals(filter)) {
            sql.append(" AND a.averageRating > 0");
        }

        // Apply type filter
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        // Apply location filters
        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        // Apply sorting
        if ("popular".equals(filter)) {
            sql.append(" ORDER BY a.totalBookings DESC, a.averageRating DESC");
        } else if ("newest".equals(filter)) {
            sql.append(" ORDER BY a.createdAt DESC");
        } else if ("top-rated".equals(filter)) {
            sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
        } else if ("low-price".equals(filter)) {
            sql.append(" ORDER BY a.pricePerNight ASC");
        } else if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "price-asc":
                    sql.append(" ORDER BY a.pricePerNight ASC");
                    break;
                case "price-desc":
                    sql.append(" ORDER BY a.pricePerNight DESC");
                    break;
                case "rating":
                    sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
                    break;
                case "newest":
                    sql.append(" ORDER BY a.createdAt DESC");
                    break;
                default:
                    sql.append(" ORDER BY a.createdAt DESC");
            }
        } else {
            sql.append(" ORDER BY a.createdAt DESC");
        }

        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get count for filtered accommodations
     */
    public int getFilteredAccommodationsCount(String type, int regionId, int cityId, String filter) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) 
            FROM Accommodations a
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        // Apply specific filters
        if ("popular".equals(filter)) {
            sql.append(" AND a.totalBookings >= 5 AND a.averageRating >= 4.0");
        } else if ("top-rated".equals(filter)) {
            sql.append(" AND a.averageRating > 0");
        }

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
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
     * Get reported accommodations
     */
    public List<Accommodation> getReportedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get flagged accommodations
     */
    public List<Accommodation> getFlaggedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get deleted accommodations
     */
    public List<Accommodation> getDeletedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.isActive = 1
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            return executeAccommodationQuery(ps);
        }
    }

    /**
     * Get all accommodations with pagination
     */
public List<Accommodation> getAllAccommodations(int page, int pageSize, String type) throws SQLException {
    List<Accommodation> accommodations = new ArrayList<>();
    StringBuilder sql = new StringBuilder("""
        SELECT a.accommodationId, a.hostId, a.name, a.description, a.cityId, a.address,
               a.type, a.numberOfRooms, a.amenities, a.pricePerNight, a.images,
               a.createdAt, a.isActive, a.averageRating, a.totalBookings,
               u.fullName as hostName, c.vietnameseName as cityName
        FROM Accommodations a
        LEFT JOIN Users u ON a.hostId = u.userId
        LEFT JOIN Cities c ON a.cityId = c.cityId
        WHERE 1=1
    """);
    
    List<Object> parameters = new ArrayList<>();
    
    if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
        sql.append(" AND a.type = ?");
        parameters.add(type);
    }
    
    sql.append(" ORDER BY a.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    parameters.add((page - 1) * pageSize);
    parameters.add(pageSize);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                accommodations.add(mapAccommodationFromResultSet(rs));
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting all accommodations", e);
        throw e;
    }
    
    return accommodations;
}
    /**
     * Soft delete accommodation
     */
public boolean softDeleteAccommodation(int accommodationId, String reason) throws SQLException {
    String sql = "UPDATE Accommodations SET isActive = 0 WHERE accommodationId = ? AND isActive = 1";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setInt(1, accommodationId);
        int rowsAffected = pstmt.executeUpdate();
        
        boolean success = rowsAffected > 0;
        LOGGER.info("Soft delete accommodation " + accommodationId + ": " + (success ? "SUCCESS" : "FAILED") + 
                   " - Reason: " + reason);
        
        return success;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error soft deleting accommodation " + accommodationId, e);
        throw e;
    }
}
    public boolean restoreAccommodation(int accommodationId) throws SQLException {
        String sql = "UPDATE Accommodations SET isActive = 1 WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Accommodation restored - ID: " + accommodationId);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Flag accommodation
     */
    public boolean flagAccommodation(int accommodationId, String reason) throws SQLException {
        String sql = "UPDATE Accommodations SET isActive = 0 WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Accommodation flagged - ID: " + accommodationId + ", Reason: " + reason);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Unflag accommodation
     */
    public boolean unflagAccommodation(int accommodationId) throws SQLException {
        String sql = "UPDATE Accommodations SET isActive = 1 WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Accommodation unflagged - ID: " + accommodationId);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Update report count
     */
    public boolean updateReportCount(int accommodationId, int reportCount) throws SQLException {
        // Since the base schema doesn't have report_count, we'll just log this action
        LOGGER.info("Report count update requested for accommodation ID: " + accommodationId + ", count: " + reportCount);
        return true;
    }

    /**
     * Get reported accommodations count
     */
    public int getReportedAccommodationsCount() throws SQLException {
        // Return 0 since base schema doesn't have report functionality
        return 0;
    }

    /**
     * Get flagged accommodations count
     */
    public int getFlaggedAccommodationsCount() throws SQLException {
        // Return 0 since base schema doesn't have flag functionality
        return 0;
    }

    /**
     * Get deleted accommodations count
     */
    public int getDeletedAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE isActive = 0";
        
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
     * Approve accommodation
     */
public boolean approveAccommodation(int accommodationId) throws SQLException {
    String sql = "UPDATE Accommodations SET isActive = 1 WHERE accommodationId = ? AND isActive = 0";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtils.getConnection();
        if (conn == null) {
            LOGGER.severe("Database connection is null!");
            throw new SQLException("Cannot get database connection");
        }
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, accommodationId);
        
        int rowsAffected = pstmt.executeUpdate();
        boolean success = rowsAffected > 0;
        
        LOGGER.info("Approve accommodation " + accommodationId + ": " + (success ? "SUCCESS" : "FAILED") + 
                   " (rows affected: " + rowsAffected + ")");
        
        return success;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "SQL Error approving accommodation " + accommodationId, e);
        throw e;
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing database resources", e);
        }
    }
}
public boolean rejectAccommodation(int accommodationId, String reason) throws SQLException {
    String sql = "UPDATE Accommodations SET isActive = 0 WHERE accommodationId = ?";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setInt(1, accommodationId);
        int rowsAffected = pstmt.executeUpdate();
        
        boolean success = rowsAffected > 0;
        LOGGER.info("Reject accommodation " + accommodationId + ": " + (success ? "SUCCESS" : "FAILED") + 
                   " - Reason: " + reason);
        
        return success;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error rejecting accommodation " + accommodationId, e);
        throw e;
    }
}
public List<Accommodation> getAccommodationsByHostId(int hostId) throws SQLException {
    List<Accommodation> accommodations = new ArrayList<>();
    String sql = """
        SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
        FROM Accommodations a
        LEFT JOIN Users u ON a.hostId = u.userId
        LEFT JOIN Cities c ON a.cityId = c.cityId
        WHERE a.hostId = ?
        ORDER BY a.createdAt DESC
    """;
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, hostId);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                accommodations.add(mapResultSetToAccommodation(rs));
            }
        }
    }
    return accommodations;
}

/**
 * Đếm tổng số accommodation theo hostId
 */
public int countAccommodationsByHostId(int hostId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Accommodations WHERE hostId = ?";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, hostId);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    }
    return 0;
}

/**
 * Đếm số accommodation đang hoạt động theo hostId
 */
public int countActiveAccommodationsByHostId(int hostId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Accommodations WHERE hostId = ? AND isActive = 1";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, hostId);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    }
    return 0;
}

/**
 * Lấy accommodations theo city
 */
public List<Accommodation> getAccommodationsByCity(int cityId, int page, int pageSize, String type) throws SQLException {
    StringBuilder sql = new StringBuilder("""
        SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
        FROM Accommodations a
        LEFT JOIN Users u ON a.hostId = u.userId
        LEFT JOIN Cities c ON a.cityId = c.cityId
        WHERE a.cityId = ? AND a.isActive = 1
    """);
    
    List<Object> parameters = new ArrayList<>();
    parameters.add(cityId);
    
    if (type != null && !type.trim().isEmpty()) {
        sql.append(" AND a.type = ?");
        parameters.add(type);
    }
    
    sql.append(" ORDER BY a.createdAt DESC");
    sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    parameters.add((page - 1) * pageSize);
    parameters.add(pageSize);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
        }
        
        return executeAccommodationQuery(ps);
    }
}

/**
 * Lấy accommodations theo region
 */
public List<Accommodation> getAccommodationsByRegion(int regionId, int page, int pageSize, String type) throws SQLException {
    StringBuilder sql = new StringBuilder("""
        SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
        FROM Accommodations a
        LEFT JOIN Users u ON a.hostId = u.userId
        LEFT JOIN Cities c ON a.cityId = c.cityId
        LEFT JOIN Regions r ON c.regionId = r.regionId
        WHERE r.regionId = ? AND a.isActive = 1
    """);
    
    List<Object> parameters = new ArrayList<>();
    parameters.add(regionId);
    
    if (type != null && !type.trim().isEmpty()) {
        sql.append(" AND a.type = ?");
        parameters.add(type);
    }
    
    sql.append(" ORDER BY a.createdAt DESC");
    sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    parameters.add((page - 1) * pageSize);
    parameters.add(pageSize);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
        }
        
        return executeAccommodationQuery(ps);
    }
}

/**
 * Đếm accommodations theo city
 */
public int getAccommodationsCountByCity(int cityId, String type) throws SQLException {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE cityId = ? AND isActive = 1");
    
    List<Object> parameters = new ArrayList<>();
    parameters.add(cityId);
    
    if (type != null && !type.trim().isEmpty()) {
        sql.append(" AND type = ?");
        parameters.add(type);
    }
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
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
 * Đếm accommodations theo region
 */
public int getAccommodationsCountByRegion(int regionId, String type) throws SQLException {
    StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*) FROM Accommodations a
        LEFT JOIN Cities c ON a.cityId = c.cityId
        LEFT JOIN Regions r ON c.regionId = r.regionId
        WHERE r.regionId = ? AND a.isActive = 1
    """);
    
    List<Object> parameters = new ArrayList<>();
    parameters.add(regionId);
    
    if (type != null && !type.trim().isEmpty()) {
        sql.append(" AND a.type = ?");
        parameters.add(type);
    }
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            ps.setObject(i + 1, parameters.get(i));
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
 * Đếm accommodations gần đây
 */
public int getRecentAccommodationsCount(int days) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(DAY, ?, GETDATE())";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, -days);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    }
    return 0;
}
    /**
     * Delete accommodation (hard delete)
     */
public boolean deleteAccommodation(int accommodationId) throws SQLException {
    String sql = "DELETE FROM Accommodations WHERE accommodationId = ?";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setInt(1, accommodationId);
        int rowsAffected = pstmt.executeUpdate();
        
        boolean success = rowsAffected > 0;
        LOGGER.info("Delete accommodation " + accommodationId + ": " + (success ? "SUCCESS" : "FAILED"));
        
        return success;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error deleting accommodation " + accommodationId, e);
        throw e;
    }
}
    /**
     * Create new accommodation
     */
public int createAccommodation(Accommodation accommodation) throws SQLException {
    String sql = """
        INSERT INTO Accommodations (hostId, name, description, cityId, address, type, 
                                   numberOfRooms, amenities, pricePerNight, images, createdAt, 
                                   isActive, averageRating, totalBookings)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, accommodation.getHostId());
        ps.setString(2, accommodation.getName());
        ps.setString(3, accommodation.getDescription());
        ps.setInt(4, accommodation.getCityId());
        ps.setString(5, accommodation.getAddress());
        ps.setString(6, accommodation.getType());
        ps.setInt(7, accommodation.getNumberOfRooms());
        ps.setString(8, accommodation.getAmenities());
        ps.setDouble(9, accommodation.getPricePerNight());
        ps.setString(10, accommodation.getImages());
        ps.setDate(11, accommodation.getCreatedAt() != null ? 
                   new java.sql.Date(accommodation.getCreatedAt().getTime()) : 
                   new java.sql.Date(System.currentTimeMillis()));
        // *** QUAN TRỌNG: Sử dụng giá trị isActive từ object ***
        ps.setBoolean(12, accommodation.isActive()); // Sẽ là true nếu set ở servlet
        ps.setDouble(13, accommodation.getAverageRating());
        ps.setInt(14, accommodation.getTotalBookings());

        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int accommodationId = generatedKeys.getInt(1);
                    accommodation.setAccommodationId(accommodationId);
                    LOGGER.info("Accommodation created with ID: " + accommodationId + 
                               ", isActive: " + accommodation.isActive());
                    return accommodationId;
                }
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error creating accommodation: " + accommodation.getName(), e);
        throw e;
    }
    return 0;
}
    

    /**
     * Update accommodation
     */
    public boolean updateAccommodation(Accommodation accommodation) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET name = ?, description = ?, cityId = ?, address = ?, type = ?, 
                numberOfRooms = ?, amenities = ?, pricePerNight = ?, images = ?, 
                averageRating = ?, totalBookings = ?
            WHERE accommodationId = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accommodation.getName());
            ps.setString(2, accommodation.getDescription());
            ps.setInt(3, accommodation.getCityId());
            ps.setString(4, accommodation.getAddress());
            ps.setString(5, accommodation.getType());
            ps.setInt(6, accommodation.getNumberOfRooms());
            ps.setString(7, accommodation.getAmenities());
            ps.setDouble(8, accommodation.getPricePerNight());
            ps.setString(9, accommodation.getImages());
            ps.setDouble(10, accommodation.getAverageRating());
            ps.setInt(11, accommodation.getTotalBookings());
            ps.setInt(12, accommodation.getAccommodationId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Accommodation updated successfully: " + accommodation.getAccommodationId());
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Get pending accommodations count
     */
   public int getPendingAccommodationsCount() throws SQLException {
    String sql = "SELECT COUNT(*) FROM Accommodations WHERE isActive = 0";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting pending accommodations count", e);
        return 0;
    }
}
/**
 * Get pending accommodations count with type filter
 */
public int getPendingAccommodationsCount(String type) throws SQLException {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE isActive = 0");
    
    if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
        sql.append(" AND type = ?");
    }
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            ps.setString(1, type);
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting pending accommodations count with type filter", e);
        return 0;
    }
}
private Accommodation mapAccommodationFromResultSet(ResultSet rs) throws SQLException {
    Accommodation accommodation = new Accommodation();
    
    try {
        accommodation.setAccommodationId(rs.getInt("accommodationId"));
        accommodation.setHostId(rs.getInt("hostId"));
        accommodation.setName(rs.getString("name"));
        accommodation.setDescription(rs.getString("description"));
        accommodation.setCityId(rs.getInt("cityId"));
        accommodation.setAddress(rs.getString("address"));
        accommodation.setType(rs.getString("type"));
        accommodation.setNumberOfRooms(rs.getInt("numberOfRooms"));
        accommodation.setAmenities(rs.getString("amenities"));
        accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
        accommodation.setImages(rs.getString("images"));
        accommodation.setCreatedAt(rs.getDate("createdAt"));
        accommodation.setActive(rs.getBoolean("isActive"));
        accommodation.setAverageRating(rs.getDouble("averageRating"));
        accommodation.setTotalBookings(rs.getInt("totalBookings"));
        
        // Set joined fields
        accommodation.setHostName(rs.getString("hostName"));
        accommodation.setCityName(rs.getString("cityName"));
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error mapping accommodation from ResultSet", e);
        throw e;
    }
    
    return accommodation;
}
private int getAccommodationCount(String sql) throws SQLException {
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting accommodation count", e);
        return 0; // Return 0 instead of throwing to prevent servlet crash
    }
}
    /**
     * Get approved accommodations count
     */
public int getApprovedAccommodationsCount() throws SQLException {
    String sql = "SELECT COUNT(*) FROM Accommodations WHERE isActive = 1";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting approved accommodations count", e);
        return 0;
    }
}
/**
 * Get approved accommodations count with type filter
 */
public int getApprovedAccommodationsCount(String type) throws SQLException {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE isActive = 1");
    
    if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
        sql.append(" AND type = ?");
    }
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            ps.setString(1, type);
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting approved accommodations count with type filter", e);
        return 0;
    }
}

    /**
     * Get total accommodations count
     */
public int getTotalAccommodationsCount() throws SQLException {
    String sql = "SELECT COUNT(*) FROM Accommodations";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting total accommodations count", e);
        return 0; // Return 0 instead of throwing to prevent servlet crash
    }
}

/**
 * Get total accommodations count with type filter
 */
public int getTotalAccommodationsCount(String type) throws SQLException {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations");
    
    if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
        sql.append(" WHERE type = ?");
    }
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            ps.setString(1, type);
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting total accommodations count with type filter", e);
        return 0;
    }
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
     * Map ResultSet to Accommodation object - Updated for database schema
     */
    private Accommodation mapResultSetToAccommodation(ResultSet rs) throws SQLException {
        Accommodation accommodation = new Accommodation();
        
        // Set basic fields
        accommodation.setAccommodationId(rs.getInt("accommodationId"));
        accommodation.setHostId(rs.getInt("hostId"));
        accommodation.setName(rs.getString("name"));
        accommodation.setDescription(rs.getString("description"));
        accommodation.setCityId(rs.getInt("cityId"));
        accommodation.setAddress(rs.getString("address"));
        accommodation.setType(rs.getString("type"));
        accommodation.setNumberOfRooms(rs.getInt("numberOfRooms"));
        accommodation.setAmenities(rs.getString("amenities"));
        accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
        accommodation.setImages(rs.getString("images"));
        accommodation.setCreatedAt(rs.getDate("createdAt"));
        accommodation.setActive(rs.getBoolean("isActive"));
        accommodation.setAverageRating(rs.getDouble("averageRating"));
        accommodation.setTotalBookings(rs.getInt("totalBookings"));

        // Try to set additional fields from joins if available
        try {
            String hostName = rs.getString("hostName");
            if (hostName != null) {
                accommodation.setHostName(hostName);
            }
        } catch (SQLException e) {
            // hostName field not available in this query
        }
        
        try {
            String cityName = rs.getString("cityName");
            if (cityName != null) {
                accommodation.setCityName(cityName);
            }
        } catch (SQLException e) {
            // cityName field not available in this query
        }

        try {
            String cityVietnameseName = rs.getString("cityVietnameseName");
            if (cityVietnameseName != null) {
                // You can add this to your Accommodation model if needed
                // accommodation.setCityVietnameseName(cityVietnameseName);
            }
        } catch (SQLException e) {
            // cityVietnameseName field not available in this query
        }

        // Set default values for extended fields since base schema doesn't have them
        accommodation.setReportCount(0);
        accommodation.setDeleted(false);
        accommodation.setFlagged(false);

        return accommodation;
    }



}