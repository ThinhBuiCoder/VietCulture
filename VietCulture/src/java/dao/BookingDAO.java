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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bookingId);

            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Booking status updated: " + bookingId + " -> " + status);
            return rowsAffected > 0;
        }
    }

    // ========== EXPERIENCE BOOKING VALIDATION METHODS ==========
    
    /**
     * Kiểm tra xem trải nghiệm còn slot trống không
     * @param experienceId ID của trải nghiệm
     * @param bookingDate Ngày đặt
     * @param timeSlot Khung giờ (morning/afternoon/evening)
     * @param requestedPeople Số người yêu cầu
     * @return true nếu còn đủ slot
     */
    public boolean isExperienceSlotAvailable(int experienceId, Date bookingDate, String timeSlot, int requestedPeople) throws SQLException {
        // Lấy thông tin trải nghiệm
        ExperienceDAO experienceDAO = new ExperienceDAO();
        Experience experience = experienceDAO.getExperienceById(experienceId);
        
        if (experience == null || !experience.isActive()) {
            return false;
        }
        
        int maxGroupSize = experience.getMaxGroupSize();
        
        // Đếm số người đã đặt trong cùng ngày và khung giờ
        String sql = """
            SELECT ISNULL(SUM(b.numberOfPeople), 0) as bookedPeople
            FROM Bookings b
            WHERE b.experienceId = ? 
            AND CAST(b.bookingDate AS DATE) = CAST(? AS DATE)
            AND JSON_VALUE(b.contactInfo, '$.timeSlot') = ?
            AND b.status IN ('CONFIRMED', 'COMPLETED', 'PENDING')
        """;
        
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            ps.setDate(2, new java.sql.Date(bookingDate.getTime()));
            ps.setString(3, timeSlot);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int bookedPeople = rs.getInt("bookedPeople");
                    int availableSlots = maxGroupSize - bookedPeople;
                    
                    LOGGER.info("Experience " + experienceId + " - Date: " + bookingDate + 
                               " - TimeSlot: " + timeSlot + " - Booked: " + bookedPeople + 
                               " - Max: " + maxGroupSize + " - Available: " + availableSlots);
                    
                    return availableSlots >= requestedPeople;
                }
            }
        }
        
        return false;
    }
    
    /**
     * Kiểm tra người dùng đã đặt trải nghiệm nào trong cùng ngày và khung giờ chưa
     * @param userId ID người dùng
     * @param bookingDate Ngày đặt
     * @param timeSlot Khung giờ
     * @param excludeBookingId ID booking cần loại trừ (khi update)
     * @return true nếu đã có booking trùng lặp
     */
    public boolean hasConflictingExperienceBooking(int userId, Date bookingDate, String timeSlot, Integer excludeBookingId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) as conflictCount
            FROM Bookings b
            INNER JOIN Experiences e ON b.experienceId = e.experienceId
            WHERE b.travelerId = ?
            AND CAST(b.bookingDate AS DATE) = CAST(? AS DATE)
            AND JSON_VALUE(b.contactInfo, '$.timeSlot') = ?
            AND b.status IN ('CONFIRMED', 'COMPLETED', 'PENDING')
        """);
        
        if (excludeBookingId != null) {
            sql.append(" AND b.bookingId != ?");
        }
        
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            ps.setInt(1, userId);
            ps.setDate(2, new java.sql.Date(bookingDate.getTime()));
            ps.setString(3, timeSlot);
            
            if (excludeBookingId != null) {
                ps.setInt(4, excludeBookingId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int conflictCount = rs.getInt("conflictCount");
                    LOGGER.info("User " + userId + " conflict check - Date: " + bookingDate + 
                               " - TimeSlot: " + timeSlot + " - Conflicts: " + conflictCount);
                    return conflictCount > 0;
                }
            }
        }
        
        return false;
    }
    
    /**
     * Kiểm tra người dùng đã đặt trải nghiệm này trong cùng ngày chưa (bất kể khung giờ)
     * @param userId ID người dùng
     * @param experienceId ID trải nghiệm
     * @param bookingDate Ngày đặt
     * @param excludeBookingId ID booking cần loại trừ
     * @return true nếu đã đặt trải nghiệm này trong ngày
     */
    public boolean hasDuplicateExperienceBooking(int userId, int experienceId, Date bookingDate, Integer excludeBookingId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) as duplicateCount
            FROM Bookings b
            WHERE b.travelerId = ?
            AND b.experienceId = ?
            AND CAST(b.bookingDate AS DATE) = CAST(? AS DATE)
            AND b.status IN ('CONFIRMED', 'COMPLETED', 'PENDING')
        """);
        
        if (excludeBookingId != null) {
            sql.append(" AND b.bookingId != ?");
        }
        
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            ps.setInt(1, userId);
            ps.setInt(2, experienceId);
            ps.setDate(3, new java.sql.Date(bookingDate.getTime()));
            
            if (excludeBookingId != null) {
                ps.setInt(4, excludeBookingId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int duplicateCount = rs.getInt("duplicateCount");
                    LOGGER.info("User " + userId + " duplicate check - Experience: " + experienceId + 
                               " - Date: " + bookingDate + " - Duplicates: " + duplicateCount);
                    return duplicateCount > 0;
                }
            }
        }
        
        return false;
    }
    
    /**
     * Lấy danh sách booking trải nghiệm theo ngày và khung giờ
     * @param experienceId ID trải nghiệm
     * @param bookingDate Ngày đặt
     * @param timeSlot Khung giờ
     * @return Danh sách booking
     */
    public List<Booking> getExperienceBookingsByDateAndTimeSlot(int experienceId, Date bookingDate, String timeSlot) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        
        String sql = """
            SELECT b.bookingId, b.experienceId, b.accommodationId, b.travelerId,
                   b.bookingDate, b.bookingTime, b.numberOfPeople, b.totalPrice,
                   b.status, b.specialRequests, b.contactInfo, b.createdAt,
                   e.title as experienceName, u.fullName as travelerName, u.email as travelerEmail
            FROM Bookings b
            INNER JOIN Experiences e ON b.experienceId = e.experienceId
            INNER JOIN Users u ON b.travelerId = u.userId
            WHERE b.experienceId = ?
            AND CAST(b.bookingDate AS DATE) = CAST(? AS DATE)
            AND JSON_VALUE(b.contactInfo, '$.timeSlot') = ?
            AND b.status IN ('CONFIRMED', 'COMPLETED', 'PENDING')
            ORDER BY b.createdAt ASC
        """;
        
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            ps.setDate(2, new java.sql.Date(bookingDate.getTime()));
            ps.setString(3, timeSlot);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapBookingFromResultSet(rs);
                    booking.setTravelerName(rs.getString("travelerName"));
                    booking.setTravelerEmail(rs.getString("travelerEmail"));
                    bookings.add(booking);
                }
            }
        }
        
        return bookings;
    }
    
    /**
     * Lấy thống kê slot đã đặt cho trải nghiệm theo ngày
     * @param experienceId ID trải nghiệm
     * @param bookingDate Ngày đặt
     * @return Map với key là timeSlot và value là số người đã đặt
     */
    public Map<String, Integer> getExperienceBookingStatsByDate(int experienceId, Date bookingDate) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        
        String sql = """
            SELECT JSON_VALUE(b.contactInfo, '$.timeSlot') as timeSlot,
                   SUM(b.numberOfPeople) as bookedPeople
            FROM Bookings b
            WHERE b.experienceId = ?
            AND CAST(b.bookingDate AS DATE) = CAST(? AS DATE)
            AND b.status IN ('CONFIRMED', 'COMPLETED', 'PENDING')
            AND JSON_VALUE(b.contactInfo, '$.timeSlot') IS NOT NULL
            GROUP BY JSON_VALUE(b.contactInfo, '$.timeSlot')
        """;
        
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            ps.setDate(2, new java.sql.Date(bookingDate.getTime()));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String timeSlot = rs.getString("timeSlot");
                    int bookedPeople = rs.getInt("bookedPeople");
                    if (timeSlot != null) {
                        stats.put(timeSlot, bookedPeople);
                    }
                }
            }
        }
        
        // Đảm bảo có tất cả time slots với giá trị 0 nếu chưa có booking
        stats.putIfAbsent("morning", 0);
        stats.putIfAbsent("afternoon", 0);
        stats.putIfAbsent("evening", 0);
        
        return stats;
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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
            case "week" ->
                String.format("""
                SELECT 
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(DAY, -7, GETDATE()) %s) as current_period,
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(DAY, -14, GETDATE()) 
                     AND createdAt < DATEADD(DAY, -7, GETDATE()) %s) as previous_period
                """, aggregateFunction, tableName, condition, aggregateFunction, tableName, condition);
            case "year" ->
                String.format("""
                SELECT 
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(YEAR, -1, GETDATE()) %s) as current_period,
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(YEAR, -2, GETDATE()) 
                     AND createdAt < DATEADD(YEAR, -1, GETDATE()) %s) as previous_period
                """, aggregateFunction, tableName, condition, aggregateFunction, tableName, condition);
            default ->
                String.format("""
                SELECT 
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(MONTH, -1, GETDATE()) %s) as current_period,
                    (SELECT %s FROM %s WHERE createdAt >= DATEADD(MONTH, -2, GETDATE()) 
                     AND createdAt < DATEADD(MONTH, -1, GETDATE()) %s) as previous_period
                """, aggregateFunction, tableName, condition, aggregateFunction, tableName, condition);
        };
    }

    /**
     * Delete booking by ID (for cleaning up failed payments)
     */
    public boolean deleteBooking(int bookingId) throws SQLException {
        String sql = "DELETE FROM Bookings WHERE bookingId = ? AND status = 'PENDING'";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                LOGGER.info("Deleted pending booking: " + bookingId);
                return true;
            } else {
                LOGGER.warning("No pending booking found to delete with ID: " + bookingId);
                return false;
            }
        }
    }

    /**
     * Check if booking exists and is pending
     */
    public boolean isPendingBooking(int bookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE bookingId = ? AND status = 'PENDING'";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Kiểm tra số booking của user cho một experience nhất định
     */
    public int getTotalBookingsByUserAndExperience(int userId, int experienceId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE travelerId = ? AND experienceId = ? AND status = 'COMPLETED'";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, experienceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Kiểm tra số booking của user cho một accommodation nhất định
     */
    public int getTotalBookingsByUserAndAccommodation(int userId, int accommodationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE travelerId = ? AND accommodationId = ? AND status = 'COMPLETED'";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, accommodationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}