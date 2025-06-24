package dao;

import model.Booking;
import utils.DatabaseUtils;

import java.sql.*;
import java.time.LocalDateTime;

/**
 * Data Access Object cho Booking.
 */
public class BookingDAO {

    /**
     * Thêm đơn đặt mới và trả về bookingID vừa tạo.
     */
    public int addBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (customerName, email, phone, tourName, amount, paymentStatus, createdAt) "
<<<<<<< HEAD
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

=======
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
            stmt.setString(1, booking.getCustomerName());
            stmt.setString(2, booking.getEmail());
            stmt.setString(3, booking.getPhone());
            stmt.setString(4, booking.getTourName());
            stmt.setBigDecimal(5, booking.getAmount());
            stmt.setString(6, booking.getPaymentStatus());
            stmt.setTimestamp(7, Timestamp.valueOf(booking.getCreatedAt()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.err.println("Lỗi khi thêm booking: " + ex.getMessage());
        }
        return -1;
    }

    /**
     * Cập nhật trạng thái thanh toán cho đơn hàng.
     */
    public boolean updatePaymentStatus(int bookingID, String status) {
        String sql = "UPDATE Bookings SET paymentStatus = ? WHERE bookingID = ?";
<<<<<<< HEAD

        try (Connection conn = DatabaseUtils.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, bookingID);

=======
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, bookingID);
            
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.err.println("Lỗi khi cập nhật trạng thái thanh toán: " + ex.getMessage());
            return false;
        }
    }

    /**
     * Lấy thông tin booking theo ID.
     */
    public Booking getBookingById(int bookingID) {
        String sql = "SELECT * FROM Bookings WHERE bookingID = ?";
<<<<<<< HEAD

        try (Connection conn = DatabaseUtils.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

=======
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
            stmt.setInt(1, bookingID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingID(rs.getInt("bookingID"));
                    booking.setCustomerName(rs.getString("customerName"));
                    booking.setEmail(rs.getString("email"));
                    booking.setPhone(rs.getString("phone"));
                    booking.setTourName(rs.getString("tourName"));
                    booking.setAmount(rs.getBigDecimal("amount"));
                    booking.setPaymentStatus(rs.getString("paymentStatus"));
                    booking.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    return booking;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
