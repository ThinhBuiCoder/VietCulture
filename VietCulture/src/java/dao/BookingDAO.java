package dao;

import model.Booking;
import model.Experience;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

public class BookingDAO {
    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());
    
    // ========== BOOKING OPERATIONS ==========
    
    /**
     * Get total bookings count by user (traveler)
     */
    public int getTotalBookingsByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE travelerId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get bookings by user with pagination
     */
    public List<Booking> getBookingsByUser(int userId, int offset, int limit) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        
        String sql = """
            SELECT b.bookingId, b.experienceId, b.accommodationId, b.travelerId,
                   b.bookingDate, b.bookingTime, b.numberOfPeople, b.totalPrice,
                   b.status, b.specialRequests, b.contactInfo, b.createdAt,
                   e.title as experienceName, a.name as accommodationName
            FROM Bookings b
            LEFT JOIN Experiences e ON b.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId
            WHERE b.travelerId = ?
            ORDER BY b.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapBookingFromResultSet(rs);
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
    
    /**
     * Get booking by ID
     */
    public Booking getBookingById(int bookingId) throws SQLException {
        String sql = """
            SELECT b.bookingId, b.experienceId, b.accommodationId, b.travelerId,
                   b.bookingDate, b.bookingTime, b.numberOfPeople, b.totalPrice,
                   b.status, b.specialRequests, b.contactInfo, b.createdAt,
                   e.title as experienceName, a.name as accommodationName
            FROM Bookings b
            LEFT JOIN Experiences e ON b.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId
            WHERE b.bookingId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBookingFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Create new booking
     */
    public int createBooking(Booking booking) throws SQLException {
        String sql = """
            INSERT INTO Bookings (experienceId, accommodationId, travelerId, bookingDate, 
                                bookingTime, numberOfPeople, totalPrice, status, 
                                specialRequests, contactInfo)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setObject(1, booking.getExperienceId());
            ps.setObject(2, booking.getAccommodationId());
            ps.setInt(3, booking.getTravelerId());
            ps.setDate(4, new java.sql.Date(booking.getBookingDate().getTime()));
            ps.setTime(5, new java.sql.Time(booking.getBookingTime().getTime()));
            ps.setInt(6, booking.getNumberOfPeople());
            ps.setDouble(7, booking.getTotalPrice());
            ps.setString(8, booking.getStatus());
            ps.setString(9, booking.getSpecialRequests());
            ps.setString(10, booking.getContactInfo());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int bookingId = generatedKeys.getInt(1);
                        booking.setBookingId(bookingId);
                        return bookingId;
                    }
                }
            }
        }
        return 0;
    }
    
    /**
     * Update booking status
     */
    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE Bookings SET status = ? WHERE bookingId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Booking status updated: " + bookingId + " -> " + status);
            return rowsAffected > 0;
        }
    }
    
    /**
     * Get bookings by host (for host dashboard)
     */
    public List<Booking> getBookingsByHost(int hostId, int offset, int limit) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        
        String sql = """
            SELECT b.bookingId, b.experienceId, b.accommodationId, b.travelerId,
                   b.bookingDate, b.bookingTime, b.numberOfPeople, b.totalPrice,
                   b.status, b.specialRequests, b.contactInfo, b.createdAt,
                   e.title as experienceName, a.name as accommodationName,
                   u.fullName as travelerName, u.email as travelerEmail
            FROM Bookings b
            LEFT JOIN Experiences e ON b.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId
            LEFT JOIN Users u ON b.travelerId = u.userId
            WHERE (e.hostId = ? OR a.hostId = ?)
            ORDER BY b.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            ps.setInt(2, hostId);
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapBookingFromResultSet(rs);
                    // Add traveler info if available
                    if (rs.getString("travelerName") != null) {
                        booking.setTravelerName(rs.getString("travelerName"));
                        booking.setTravelerEmail(rs.getString("travelerEmail"));
                    }
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
    
    /**
     * Get total bookings count by host
     */
    public int getTotalBookingsByHost(int hostId) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Bookings b
            LEFT JOIN Experiences e ON b.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON b.accommodationId = a.accommodationId
            WHERE (e.hostId = ? OR a.hostId = ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            ps.setInt(2, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get revenue by host
     */
    public double getRevenueByHost(int hostId) throws SQLException {
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
    
    // ========== ADMIN STATISTICS ==========
    
    /**
     * Get current month bookings count
     */
    public int getCurrentMonthBookingsCount() throws SQLException {
        String sql = """
            SELECT COUNT(*) 
            FROM Bookings 
            WHERE createdAt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        """;
        
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
     * Get weekly bookings data for dashboard chart
     */
    public List<Integer> getWeeklyBookingsData() throws SQLException {
        List<Integer> data = new ArrayList<>();
        
        String sql = """
            SELECT COUNT(*) as count
            FROM Bookings 
            WHERE createdAt >= DATEADD(DAY, ?, GETDATE())
            AND createdAt < DATEADD(DAY, ?, GETDATE())
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 6; i >= 0; i--) {
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
     * Get total bookings count
     */
    public int getTotalBookingsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings";
        
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
     * Get total revenue
     */
    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT ISNULL(SUM(totalPrice), 0) FROM Bookings WHERE status = 'COMPLETED'";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }
    
    /**
     * Get booking growth percentage
     */
    public double getBookingGrowthPercentage(String period) throws SQLException {
        String sql = getGrowthSQL(period, "Bookings", "COUNT(*)");
        
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
     * Get revenue growth percentage
     */
    public double getRevenueGrowthPercentage(String period) throws SQLException {
        String sql = getGrowthSQL(period, "Bookings", "ISNULL(SUM(totalPrice), 0)", "AND status = 'COMPLETED'");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                double currentPeriod = rs.getDouble("current_period");
                double previousPeriod = rs.getDouble("previous_period");
                
                if (previousPeriod == 0) {
                    return currentPeriod > 0 ? 100.0 : 0.0;
                }
                
                return ((currentPeriod - previousPeriod) / previousPeriod) * 100.0;
            }
        }
        
        return 0.0;
    }
    
    /**
     * Get monthly booking trends
     */
    public List<Integer> getMonthlyBookingTrends(int months) throws SQLException {
        List<Integer> data = new ArrayList<>();
        
        String sql = """
            SELECT COUNT(*) as count
            FROM Bookings 
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
     * Get monthly revenue trends
     */
    public List<Double> getMonthlyRevenueTrends(int months) throws SQLException {
        List<Double> data = new ArrayList<>();
        
        String sql = """
            SELECT ISNULL(SUM(totalPrice), 0) as revenue
            FROM Bookings 
            WHERE createdAt >= DATEADD(MONTH, ?, GETDATE())
            AND createdAt < DATEADD(MONTH, ?, GETDATE())
            AND status = 'COMPLETED'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = months - 1; i >= 0; i--) {
                ps.setInt(1, -i - 1);
                ps.setInt(2, -i);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        data.add(rs.getDouble("revenue"));
                    } else {
                        data.add(0.0);
                    }
                }
            }
        }
        
        return data;
    }
    
    // ========== HELPER METHODS ==========
    
    /**
     * Map ResultSet to Booking object
     */
    private Booking mapBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("bookingId"));
        booking.setExperienceId(rs.getObject("experienceId") != null ? rs.getInt("experienceId") : null);
        booking.setAccommodationId(rs.getObject("accommodationId") != null ? rs.getInt("accommodationId") : null);
        booking.setTravelerId(rs.getInt("travelerId"));
        booking.setBookingDate(rs.getDate("bookingDate"));
        booking.setBookingTime(rs.getTime("bookingTime"));
        booking.setNumberOfPeople(rs.getInt("numberOfPeople"));
        booking.setTotalPrice(rs.getDouble("totalPrice"));
        booking.setStatus(rs.getString("status"));
        booking.setSpecialRequests(rs.getString("specialRequests"));
        booking.setContactInfo(rs.getString("contactInfo"));
        booking.setCreatedAt(rs.getDate("createdAt"));
        
        // Set experience or accommodation name if available
        if (rs.getString("experienceName") != null) {
            booking.setExperienceName(rs.getString("experienceName"));
        }
        if (rs.getString("accommodationName") != null) {
            booking.setAccommodationName(rs.getString("accommodationName"));
        }
        
        return booking;
    }
    
    /**
     * Generate growth SQL based on period
     */
    private String getGrowthSQL(String period, String tableName, String aggregateFunction, String... additionalConditions) {
        String condition = additionalConditions.length > 0 ? additionalConditions[0] : "";
        
        return switch (period) {
            case "week" -> String.format("""
                SELECT 
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(DAY, -7, GETDATE()) %s) as current_period,
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(DAY, -14, GETDATE()) 
                     AND createdAt < DATEADD(DAY, -7, GETDATE()) %s) as previous_period
                """, aggregateFunction, tableName, condition, aggregateFunction, tableName, condition);
            case "year" -> String.format("""
                SELECT 
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(YEAR, -1, GETDATE()) %s) as current_period,
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(YEAR, -2, GETDATE()) 
                     AND createdAt < DATEADD(YEAR, -1, GETDATE()) %s) as previous_period
                """, aggregateFunction, tableName, condition, aggregateFunction, tableName, condition);
            default -> String.format("""
                SELECT 
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(MONTH, -1, GETDATE()) %s) as current_period,
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(MONTH, -2, GETDATE()) 
                     AND createdAt < DATEADD(MONTH, -1, GETDATE()) %s) as previous_period
                """, aggregateFunction, tableName, condition, aggregateFunction, tableName, condition);
        };
    }

    public void deleteBooking(int bookingId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    /**
     * Check if a user has a COMPLETED booking for a specific experience.
     */
    public boolean hasUserCompletedExperienceBooking(int userId, int experienceId) throws SQLException {
        String sql = """
            SELECT COUNT(*) 
            FROM Bookings 
            WHERE travelerId = ? 
            AND experienceId = ? 
            AND status = 'COMPLETED'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, experienceId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Check if a user has booked a specific experience (any status).
     */
    public boolean hasUserBookedExperience(int userId, int experienceId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE travelerId = ? AND experienceId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, experienceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}