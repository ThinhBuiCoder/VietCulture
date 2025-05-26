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
        String sql = "UPDATE Accommodations SET isActive = 1 WHERE accommodationId = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Accommodation approved - ID: " + accommodationId);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Delete accommodation (hard delete)
     */
    public boolean deleteAccommodation(int accommodationId) throws SQLException {
        String sql = "DELETE FROM Accommodations WHERE accommodationId = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Accommodation deleted - ID: " + accommodationId);
            }
            return rowsAffected > 0;
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
            ps.setTimestamp(11, accommodation.getCreatedAt() != null ? new Timestamp(accommodation.getCreatedAt().getTime()) : new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(12, accommodation.isActive());
            ps.setDouble(13, accommodation.getAverageRating());
            ps.setInt(14, accommodation.getTotalBookings());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int accommodationId = generatedKeys.getInt(1);
                        accommodation.setAccommodationId(accommodationId);
                        LOGGER.info("Accommodation created successfully with ID: " + accommodationId);
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
        accommodation.setCreatedAt(rs.getTimestamp("createdAt"));
        accommodation.setActive(rs.getBoolean("isActive"));
        accommodation.setAverageRating(rs.getDouble("averageRating"));
        accommodation.setTotalBookings(rs.getInt("totalBookings"));

        // Set additional fields from joins
        accommodation.setHostName(rs.getString("hostName"));
        accommodation.setCityName(rs.getString("cityName"));

        return accommodation;
    }
}