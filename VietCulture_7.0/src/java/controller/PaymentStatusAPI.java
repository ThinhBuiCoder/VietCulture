package controller;

import dao.BookingDAO;
import model.Booking;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * PaymentStatusAPI - API để check trạng thái thanh toán real-time
 * 
 * Endpoint: /api/payment-status
 * Method: GET
 * Parameters: bookingId (required)
 * 
 * Response JSON:
 * {
 *   "status": "PENDING|CONFIRMED|CANCELLED",
 *   "bookingId": 123,
 *   "message": "Status description",
 *   "timestamp": 1640995200000
 * }
 */
@WebServlet("/api/payment-status")
public class PaymentStatusAPI extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentStatusAPI.class.getName());
    private BookingDAO bookingDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            bookingDAO = new BookingDAO();
            objectMapper = new ObjectMapper();
            LOGGER.info("PaymentStatusAPI initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize PaymentStatusAPI", e);
            throw new ServletException("Failed to initialize API", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response headers for JSON API
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Enable CORS if needed
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        String bookingIdParam = request.getParameter("bookingId");
        
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, 
                            "Missing required parameter: bookingId");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            
            // Get booking status from database
            PaymentStatusResult result = getPaymentStatus(bookingId);
            
            if (result.success) {
                sendSuccessResponse(response, result);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, result.errorMessage);
            }

        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid bookingId format: " + bookingIdParam);
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, 
                            "Invalid bookingId format: must be a number");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error checking payment status", e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                            "Database error occurred");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in payment status API", e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                            "Internal server error");
        }
    }

    /**
     * Get payment status from database
     */
    private PaymentStatusResult getPaymentStatus(int bookingId) throws SQLException {
        PaymentStatusResult result = new PaymentStatusResult();
        
        try {
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                result.success = false;
                result.errorMessage = "Booking not found with ID: " + bookingId;
                LOGGER.warning("Booking not found: " + bookingId);
                return result;
            }

            // Map booking status to API response
            result.success = true;
            result.bookingId = bookingId;
            result.status = booking.getStatus();
            result.timestamp = System.currentTimeMillis();
            
            // Set appropriate message based on status
            switch (booking.getStatus()) {
                case "PENDING":
                    result.message = "Đang chờ thanh toán";
                    break;
                case "CONFIRMED":
                    result.message = "Thanh toán thành công";
                    break;
                case "CANCELLED":
                    result.message = "Thanh toán đã bị hủy";
                    break;
                case "EXPIRED":
                    result.message = "Đơn hàng đã hết hạn";
                    break;
                default:
                    result.message = "Trạng thái: " + booking.getStatus();
                    break;
            }

            // Add additional info for confirmed bookings
            if ("CONFIRMED".equals(booking.getStatus())) {
                result.totalPrice = booking.getTotalPrice();
                result.serviceType = determineServiceType(booking);
            }

            LOGGER.info("Payment status retrieved - BookingId: " + bookingId + 
                       ", Status: " + result.status);
            
            return result;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving booking: " + bookingId, e);
            result.success = false;
            result.errorMessage = "Database error occurred while checking booking status";
            throw e;
        }
    }

    /**
     * Determine service type from booking
     */
    private String determineServiceType(Booking booking) {
        if (booking.getExperienceId() != null && booking.getExperienceId() > 0) {
            return "experience";
        } else if (booking.getAccommodationId() != null && booking.getAccommodationId() > 0) {
            return "accommodation";
        }
        return "unknown";
    }

    /**
     * Send successful JSON response
     */
    private void sendSuccessResponse(HttpServletResponse response, PaymentStatusResult result) 
            throws IOException {
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", true);
        jsonResponse.put("status", result.status);
        jsonResponse.put("bookingId", result.bookingId);
        jsonResponse.put("message", result.message);
        jsonResponse.put("timestamp", result.timestamp);
        
        if (result.totalPrice > 0) {
            jsonResponse.put("totalPrice", result.totalPrice);
        }
        
        if (result.serviceType != null) {
            jsonResponse.put("serviceType", result.serviceType);
        }

        response.setStatus(HttpServletResponse.SC_OK);
        String jsonString = objectMapper.writeValueAsString(jsonResponse);
        response.getWriter().write(jsonString);
        
        LOGGER.fine("Success response sent for booking: " + result.bookingId);
    }

    /**
     * Send error JSON response
     */
    private void sendErrorResponse(HttpServletResponse response, int statusCode, String errorMessage) 
            throws IOException {
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", false);
        jsonResponse.put("error", errorMessage);
        jsonResponse.put("timestamp", System.currentTimeMillis());

        response.setStatus(statusCode);
        String jsonString = objectMapper.writeValueAsString(jsonResponse);
        response.getWriter().write(jsonString);
        
        LOGGER.warning("Error response sent: " + errorMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // API chỉ hỗ trợ GET method
        sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, 
                        "Method not allowed. Use GET method.");
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, 
                        "Method not allowed. Use GET method.");
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        sendErrorResponse(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, 
                        "Method not allowed. Use GET method.");
    }

    /**
     * Handle OPTIONS for CORS preflight
     */
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // ==================== INNER CLASSES ====================

    /**
     * Payment status result class
     */
    private static class PaymentStatusResult {
        boolean success = false;
        String errorMessage;
        int bookingId;
        String status;
        String message;
        long timestamp;
        double totalPrice = 0;
        String serviceType;
    }
}

// ==================== ENHANCED BOOKING DAO EXTENSION ====================

/**
 * Additional methods for BookingDAO to support payment status checking
 */
/*
// Add these methods to your existing BookingDAO class:

public Booking getBookingById(int bookingId) throws SQLException {
    String sql = "SELECT * FROM bookings WHERE booking_id = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, bookingId);
        
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return mapResultSetToBooking(rs);
            }
        }
    }
    
    return null;
}

public boolean updateBookingStatus(int bookingId, String newStatus) throws SQLException {
    String sql = "UPDATE bookings SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, newStatus);
        stmt.setInt(2, bookingId);
        
        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;
    }
}

public List<Booking> getBookingsByStatus(String status) throws SQLException {
    String sql = "SELECT * FROM bookings WHERE status = ? ORDER BY created_at DESC";
    List<Booking> bookings = new ArrayList<>();
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, status);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        }
    }
    
    return bookings;
}

public List<Booking> getExpiredPendingBookings(int minutesOld) throws SQLException {
    String sql = "SELECT * FROM bookings WHERE status = 'PENDING' AND " +
                 "created_at < DATE_SUB(NOW(), INTERVAL ? MINUTE)";
    List<Booking> bookings = new ArrayList<>();
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, minutesOld);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        }
    }
    
    return bookings;
}

private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
    Booking booking = new Booking();
    
    booking.setBookingId(rs.getInt("booking_id"));
    booking.setExperienceId(rs.getObject("experience_id", Integer.class));
    booking.setAccommodationId(rs.getObject("accommodation_id", Integer.class));
    booking.setTravelerId(rs.getInt("traveler_id"));
    booking.setBookingDate(rs.getDate("booking_date"));
    booking.setBookingTime(rs.getTime("booking_time"));
    booking.setCheckInDate(rs.getDate("check_in_date"));
    booking.setCheckOutDate(rs.getDate("check_out_date"));
    booking.setNumberOfPeople(rs.getInt("number_of_people"));
    booking.setTotalPrice(rs.getDouble("total_price"));
    booking.setStatus(rs.getString("status"));
    booking.setContactInfo(rs.getString("contact_info"));
    booking.setSpecialRequests(rs.getString("special_requests"));
    booking.setCreatedAt(rs.getTimestamp("created_at"));
    booking.setUpdatedAt(rs.getTimestamp("updated_at"));
    
    return booking;
}
*/