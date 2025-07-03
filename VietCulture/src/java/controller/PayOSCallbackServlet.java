package controller;

import dao.BookingDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Booking;
import model.Experience;
import model.Accommodation;
import model.User;
import utils.EmailUtils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Enhanced PayOS Callback Servlet để xử lý cả Experience và Accommodation
 * 
 * Features:
 * - Xử lý webhook từ PayOS với multiple service types
 * - Cập nhật trạng thái booking dựa vào loại dịch vụ
 * - Gửi email xác nhận tự động với full details
 * - Logging chi tiết cho troubleshooting
 * - Error handling và retry mechanism
 * - Async processing cho performance
 * - Enhanced email validation và formatting
 */
@WebServlet("/payos-callback")
public class PayOSCallbackServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PayOSCallbackServlet.class.getName());
    
    // DAOs
    private BookingDAO bookingDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    
    // Async executor cho email và logging
    private ExecutorService executorService;
    
    // PayOS webhook response codes
    private static final String SUCCESS_CODE = "00";
    private static final String FAILED_CODE = "01";
    
    // Booking statuses
    private static final String STATUS_CONFIRMED = "CONFIRMED";
    private static final String STATUS_CANCELLED = "CANCELLED";
    private static final String STATUS_PENDING = "PENDING";
    
    // Current request IP for logging
    private ThreadLocal<String> currentRequestIP = new ThreadLocal<>();

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            // Initialize DAOs
            bookingDAO = new BookingDAO();
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            
            // Initialize async executor
            executorService = Executors.newFixedThreadPool(3);
            
            LOGGER.info("Enhanced PayOSCallbackServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize PayOSCallbackServlet", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (executorService != null) {
            executorService.shutdown();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        String clientIP = getClientIP(request);
        currentRequestIP.set(clientIP);
        
        LOGGER.info("PayOS webhook received from IP: " + clientIP);

        try {
            // Đọc webhook body
            String webhookBody = readWebhookBody(request);
            
            if (webhookBody == null || webhookBody.trim().isEmpty()) {
                LOGGER.warning("Empty webhook body received");
                sendResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Empty webhook body");
                return;
            }

            LOGGER.info("PayOS Webhook payload: " + webhookBody);

            // Xử lý webhook
            WebhookProcessResult result = processPaymentWebhook(webhookBody);
            
            if (result.success) {
                LOGGER.info("Webhook processed successfully for booking ID: " + result.bookingId);
                sendResponse(response, HttpServletResponse.SC_OK, "OK");
                
                // Async post-processing
                processPostWebhookActions(result);
                
            } else {
                LOGGER.warning("Failed to process webhook: " + result.errorMessage);
                sendResponse(response, HttpServletResponse.SC_BAD_REQUEST, 
                           "Failed to process webhook: " + result.errorMessage);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing PayOS webhook", e);
            sendResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                       "Internal server error: " + e.getMessage());
        } finally {
            currentRequestIP.remove();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"status\":\"PayOS Callback endpoint is working\",\"timestamp\":\"" 
                                 + new Date() + "\"}");
    }

    /**
     * Đọc webhook body từ request
     */
    private String readWebhookBody(HttpServletRequest request) throws IOException {
        StringBuilder jsonString = new StringBuilder();
        
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                jsonString.append(line);
            }
        }
        
        return jsonString.toString();
    }

    /**
     * Xử lý webhook từ PayOS với enhanced error handling
     */
    private WebhookProcessResult processPaymentWebhook(String webhookBody) {
        WebhookProcessResult result = new WebhookProcessResult();
        
        try {
            // Parse JSON
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(webhookBody);

            // Validate webhook structure
            if (!isValidWebhookStructure(rootNode)) {
                result.errorMessage = "Invalid webhook structure";
                return result;
            }

            // Extract webhook data
            WebhookData webhookData = extractWebhookData(rootNode);
            result.bookingId = webhookData.bookingId;
            result.amount = webhookData.amount;
            result.paymentStatus = webhookData.paymentStatus;

            LOGGER.info("Processing payment webhook - Booking ID: " + webhookData.bookingId 
                       + ", Status: " + webhookData.paymentStatus 
                       + ", Amount: " + webhookData.amount);

            // Validate booking exists
            Booking booking = bookingDAO.getBookingById(webhookData.bookingId);
            if (booking == null) {
                result.errorMessage = "Booking not found: " + webhookData.bookingId;
                return result;
            }

            // Validate amount matches
            if (!validatePaymentAmount(booking, webhookData.amount)) {
                result.errorMessage = "Payment amount mismatch";
                LOGGER.warning("Payment amount mismatch for booking " + webhookData.bookingId 
                             + ": expected " + booking.getTotalPrice() + ", got " + webhookData.amount);
                return result;
            }

            // Update booking status
            boolean updated = updateBookingStatus(booking, webhookData.paymentStatus);
            if (!updated) {
                result.errorMessage = "Failed to update booking status";
                return result;
            }

            // Set result data
            result.success = true;
            result.booking = booking;
            result.serviceType = determineServiceType(booking);
            result.webhookData = webhookData;

            LOGGER.info("Payment webhook processed successfully for booking: " + webhookData.bookingId);
            return result;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing payment webhook", e);
            result.errorMessage = "Processing error: " + e.getMessage();
            return result;
        }
    }

    /**
     * Validate webhook structure
     */
    private boolean isValidWebhookStructure(JsonNode rootNode) {
        return rootNode.has("code") && 
               rootNode.has("data") && 
               rootNode.get("data").has("orderCode");
    }

    /**
     * Extract webhook data from JSON
     */
    private WebhookData extractWebhookData(JsonNode rootNode) {
        WebhookData data = new WebhookData();
        
        String mainCode = rootNode.get("code").asText();
        JsonNode dataNode = rootNode.get("data");
        
        data.bookingId = dataNode.get("orderCode").asInt();
        data.amount = dataNode.has("amount") ? dataNode.get("amount").asDouble() : 0.0;
        data.reference = dataNode.has("reference") ? dataNode.get("reference").asText() : "";
        data.transactionDateTime = dataNode.has("transactionDateTime") ? 
                                   dataNode.get("transactionDateTime").asText() : "";
        
        // Determine payment status
        String dataCode = dataNode.has("code") ? dataNode.get("code").asText() : mainCode;
        String description = dataNode.has("desc") ? dataNode.get("desc").asText() : "No description";
        
        if (SUCCESS_CODE.equals(mainCode) && SUCCESS_CODE.equals(dataCode)) {
            data.paymentStatus = STATUS_CONFIRMED;
            data.statusDescription = "Payment successful";
        } else {
            data.paymentStatus = STATUS_CANCELLED;
            data.statusDescription = "Payment failed: " + description;
        }
        
        return data;
    }

    /**
     * Validate payment amount
     */
    private boolean validatePaymentAmount(Booking booking, double webhookAmount) {
        double bookingAmount = booking.getTotalPrice();
        double tolerance = 1.0; // 1 VND tolerance for rounding
        
        return Math.abs(bookingAmount - webhookAmount) <= tolerance;
    }

    /**
     * Update booking status
     */
    private boolean updateBookingStatus(Booking booking, String newStatus) throws SQLException {
        String oldStatus = booking.getStatus();
        
        // Prevent status downgrade
        if (STATUS_CONFIRMED.equals(oldStatus) && STATUS_CANCELLED.equals(newStatus)) {
            LOGGER.warning("Attempted to cancel already confirmed booking: " + booking.getBookingId());
            return true; // Return true to avoid error, but don't update
        }
        
        // Update status
        boolean updated = bookingDAO.updateBookingStatus(booking.getBookingId(), newStatus);
        
        if (updated) {
            booking.setStatus(newStatus);
            LOGGER.info("Booking status updated: " + booking.getBookingId() 
                       + " from " + oldStatus + " to " + newStatus);
        }
        
        return updated;
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
     * Async post-processing sau khi webhook thành công
     */
    private void processPostWebhookActions(WebhookProcessResult result) {
        if (!result.success || result.booking == null) {
            return;
        }

        // Async email sending
        CompletableFuture.runAsync(() -> {
            try {
                sendPaymentConfirmationEmail(result);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to send payment confirmation email", e);
            }
        }, executorService);

        // Async logging
        CompletableFuture.runAsync(() -> {
            try {
                logPaymentActivity(result);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to log payment activity", e);
            }
        }, executorService);

        // Async notification to host (if needed)
        CompletableFuture.runAsync(() -> {
            try {
                notifyHostOfPayment(result);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to notify host", e);
            }
        }, executorService);
    }

    /**
     * Enhanced email sending với booking details đầy đủ
     */
    private void sendPaymentConfirmationEmail(WebhookProcessResult result) throws SQLException {
        Booking booking = result.booking;
        String serviceType = result.serviceType;
        String serviceName = getServiceName(booking, serviceType);
        
        // Extract contact info từ booking
        String contactEmail = extractContactEmail(booking);
        String contactName = extractContactName(booking);
        
        if (contactEmail == null || contactEmail.trim().isEmpty()) {
            LOGGER.warning("No contact email found for booking: " + booking.getBookingId());
            return;
        }

        // Validate email format
        if (!isValidEmail(contactEmail)) {
            LOGGER.warning("Invalid email format for booking: " + booking.getBookingId() + ", email: " + contactEmail);
            return;
        }

        // Determine email type based on payment status
        if (STATUS_CONFIRMED.equals(result.paymentStatus)) {
            sendSuccessEmail(booking, contactEmail, contactName, serviceName);
            
            // Also send booking confirmation email if needed
            sendBookingConfirmationEmail(booking, contactEmail, contactName, serviceName);
            
        } else if (STATUS_CANCELLED.equals(result.paymentStatus)) {
            sendFailureEmail(booking, contactEmail, contactName, serviceName, result.webhookData.statusDescription);
        }
    }

    /**
     * Gửi email thành công
     */
    private void sendSuccessEmail(Booking booking, String email, String name, String serviceName) {
        try {
            // Format booking details for email
            String bookingDate = formatDate(booking.getBookingDate());
            String bookingTime = formatTime(booking.getBookingTime());
            String totalPrice = formatCurrency(booking.getTotalPrice());
            String paymentMethod = "PayOS Online";
            
            boolean sent = EmailUtils.sendPaymentSuccessEmail(
                email,                           // toEmail
                name,                            // userName
                booking.getBookingId(),          // bookingId
                serviceName,                     // serviceName
                bookingDate,                     // bookingDate
                bookingTime,                     // bookingTime
                booking.getNumberOfPeople(),     // numberOfPeople
                totalPrice,                      // totalPrice (formatted)
                paymentMethod                    // paymentMethod
            );
            
            if (sent) {
                LOGGER.info("Payment success email sent to: " + email + " for booking: " + booking.getBookingId());
            } else {
                LOGGER.warning("Failed to send payment success email to: " + email);
            }
        } catch (Exception e) {
            handleEmailFailure("payment success", booking.getBookingId(), email, e);
        }
    }

    /**
     * Gửi email thất bại
     */
    private void sendFailureEmail(Booking booking, String email, String name, String serviceName, String failureReason) {
        try {
            String totalPrice = formatCurrency(booking.getTotalPrice());
            String paymentMethod = "PayOS Online";
            
            // Use webhook failure reason or default
            String reason = (failureReason != null && !failureReason.isEmpty()) 
                          ? failureReason 
                          : "Thanh toán bị từ chối hoặc hủy bởi hệ thống";
            
            boolean sent = EmailUtils.sendPaymentFailureEmail(
                email,                           // toEmail
                name,                            // userName
                booking.getBookingId(),          // bookingId
                serviceName,                     // serviceName
                totalPrice,                      // totalPrice (formatted)
                reason,                          // failureReason
                paymentMethod                    // paymentMethod
            );
            
            if (sent) {
                LOGGER.info("Payment failure email sent to: " + email + " for booking: " + booking.getBookingId());
            } else {
                LOGGER.warning("Failed to send payment failure email to: " + email);
            }
        } catch (Exception e) {
            handleEmailFailure("payment failure", booking.getBookingId(), email, e);
        }
    }

    /**
     * Send additional booking confirmation email
     */
    private void sendBookingConfirmationEmail(Booking booking, String email, String name, String serviceName) {
        try {
            String bookingDate = formatDate(booking.getBookingDate());
            String bookingTime = formatTime(booking.getBookingTime());
            String totalPrice = formatCurrency(booking.getTotalPrice());
            
            boolean sent = EmailUtils.sendBookingConfirmationEmail(
                email,                           // toEmail
                name,                            // userName
                booking.getBookingId(),          // bookingId
                serviceName,                     // serviceName
                bookingDate,                     // bookingDate
                bookingTime,                     // bookingTime
                booking.getNumberOfPeople(),     // numberOfPeople
                totalPrice                       // totalPrice
            );
            
            if (sent) {
                LOGGER.info("Booking confirmation email sent to: " + email + " for booking: " + booking.getBookingId());
            }
        } catch (Exception e) {
            handleEmailFailure("booking confirmation", booking.getBookingId(), email, e);
        }
    }

    /**
     * Format date for display
     */
    private String formatDate(Date date) {
        if (date == null) return "Chưa xác định";
        
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd/MM/yyyy", new Locale("vi", "VN"));
            return sdf.format(date);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to format date", e);
            return date.toString();
        }
    }

    /**
     * Format time for display
     */
    private String formatTime(Date time) {
        if (time == null) return "Chưa xác định";
        
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            return sdf.format(time);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to format time", e);
            return time.toString();
        }
    }

    /**
     * Format currency for display
     */
    private String formatCurrency(double amount) {
        try {
            NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
            return currencyFormat.format(amount) + " VNĐ";
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to format currency", e);
            return String.valueOf(amount) + " VNĐ";
        }
    }

    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        // Simple email validation regex
        String emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$";
        return email.matches(emailRegex);
    }

    /**
     * Enhanced service name extraction với fallback
     */
    private String getServiceName(Booking booking, String serviceType) throws SQLException {
        try {
            switch (serviceType) {
                case "experience":
                    if (booking.getExperienceId() != null && booking.getExperienceId() > 0) {
                        Experience experience = experienceDAO.getExperienceById(booking.getExperienceId());
                        if (experience != null && experience.getTitle() != null) {
                            return experience.getTitle();
                        }
                    }
                    return "Trải nghiệm VietCulture";
                    
                case "accommodation":
                    if (booking.getAccommodationId() != null && booking.getAccommodationId() > 0) {
                        Accommodation accommodation = accommodationDAO.getAccommodationById(booking.getAccommodationId());
                        if (accommodation != null && accommodation.getName() != null) {
                            return accommodation.getName();
                        }
                    }
                    return "Lưu trú VietCulture";
                    
                default:
                    // Try to determine from booking ID pattern or other info
                    if (booking.getExperienceId() != null && booking.getExperienceId() > 0) {
                        return "Trải nghiệm VietCulture";
                    } else if (booking.getAccommodationId() != null && booking.getAccommodationId() > 0) {
                        return "Lưu trú VietCulture";
                    }
                    break;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to get service name for booking: " + booking.getBookingId(), e);
        }
        
        return "Dịch vụ VietCulture";
    }

    /**
     * Enhanced extract contact email với fallback và null-safe checking
     */
    private String extractContactEmail(Booking booking) {
        if (booking == null) {
            LOGGER.warning("Booking is null when extracting contact email");
            return null;
        }
        
        try {
            // Try to get from contact info JSON first
            String contactInfo = booking.getContactInfo();
            if (contactInfo != null && !contactInfo.trim().isEmpty()) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode contactNode = mapper.readTree(contactInfo);
                
                // Null check for contactNode
                if (contactNode != null) {
                    if (contactNode.has("email")) {
                        JsonNode emailNode = contactNode.get("email");
                        if (emailNode != null && !emailNode.isNull()) {
                            String email = emailNode.asText();
                            if (email != null && isValidEmail(email)) {
                                return email;
                            }
                        }
                    }
                    
                    // Try alternative field names
                    if (contactNode.has("contactEmail")) {
                        JsonNode emailNode = contactNode.get("contactEmail");
                        if (emailNode != null && !emailNode.isNull()) {
                            String email = emailNode.asText();
                            if (email != null && isValidEmail(email)) {
                                return email;
                            }
                        }
                    }
                }
            }
            
            // Fallback: try to get from traveler if available
            if (booking.getTravelerId() > 0) {
                // Note: You would need UserDAO to get traveler email
                // User traveler = userDAO.getUserById(booking.getTravelerId());
                // if (traveler != null && traveler.getEmail() != null && isValidEmail(traveler.getEmail())) {
                //     return traveler.getEmail();
                // }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to extract contact email from booking: " + 
                      (booking != null ? booking.getBookingId() : "null"), e);
        }
        
        return null;
    }

    /**
     * Enhanced extract contact name với fallback và null-safe checking
     */
    private String extractContactName(Booking booking) {
        if (booking == null) {
            LOGGER.warning("Booking is null when extracting contact name");
            return "Khách hàng VietCulture";
        }
        
        try {
            // Try to get from contact info JSON first
            String contactInfo = booking.getContactInfo();
            if (contactInfo != null && !contactInfo.trim().isEmpty()) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode contactNode = mapper.readTree(contactInfo);
                
                // Null check for contactNode
                if (contactNode != null) {
                    if (contactNode.has("name")) {
                        JsonNode nameNode = contactNode.get("name");
                        if (nameNode != null && !nameNode.isNull()) {
                            String name = nameNode.asText();
                            if (name != null && !name.trim().isEmpty()) {
                                return name.trim();
                            }
                        }
                    }
                    
                    // Try alternative field names
                    if (contactNode.has("contactName")) {
                        JsonNode nameNode = contactNode.get("contactName");
                        if (nameNode != null && !nameNode.isNull()) {
                            String name = nameNode.asText();
                            if (name != null && !name.trim().isEmpty()) {
                                return name.trim();
                            }
                        }
                    }
                    
                    if (contactNode.has("fullName")) {
                        JsonNode nameNode = contactNode.get("fullName");
                        if (nameNode != null && !nameNode.isNull()) {
                            String name = nameNode.asText();
                            if (name != null && !name.trim().isEmpty()) {
                                return name.trim();
                            }
                        }
                    }
                }
            }
            
            // Fallback: try to get from traveler if available
            if (booking.getTravelerId() > 0) {
                // Note: You would need UserDAO to get traveler name
                // User traveler = userDAO.getUserById(booking.getTravelerId());
                // if (traveler != null && traveler.getFullName() != null && !traveler.getFullName().trim().isEmpty()) {
                //     return traveler.getFullName().trim();
                // }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to extract contact name from booking: " + 
                      (booking != null ? booking.getBookingId() : "null"), e);
        }
        
        return "Khách hàng VietCulture";
    }

    /**
     * Enhanced payment activity logging
     */
    private void logPaymentActivity(WebhookProcessResult result) {
        try {
            StringBuilder logBuilder = new StringBuilder();
            logBuilder.append("PAYMENT_WEBHOOK_PROCESSED: ");
            logBuilder.append("BookingId=").append(result.bookingId);
            logBuilder.append(", ServiceType=").append(result.serviceType);
            logBuilder.append(", Status=").append(result.paymentStatus);
            logBuilder.append(", Amount=").append(String.format("%.0f", result.amount));
            logBuilder.append(", Reference=").append(result.webhookData.reference);
            logBuilder.append(", DateTime=").append(result.webhookData.transactionDateTime);
            logBuilder.append(", IP=").append(getCurrentRequestIP());
            
            String logMessage = logBuilder.toString();
            LOGGER.info(logMessage);
            
            // Additional structured logging for analytics
            logPaymentMetrics(result);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to log payment activity", e);
        }
    }

    /**
     * Log payment metrics for monitoring
     */
    private void logPaymentMetrics(WebhookProcessResult result) {
        try {
            // Create metrics data
            Map<String, Object> metrics = new HashMap<>();
            metrics.put("event", "payment_webhook_processed");
            metrics.put("booking_id", result.bookingId);
            metrics.put("service_type", result.serviceType);
            metrics.put("payment_status", result.paymentStatus);
            metrics.put("amount", result.amount);
            metrics.put("timestamp", System.currentTimeMillis());
            metrics.put("success", result.success);
            
            // Convert to JSON for structured logging
            ObjectMapper mapper = new ObjectMapper();
            String metricsJson = mapper.writeValueAsString(metrics);
            
            LOGGER.info("PAYMENT_METRICS: " + metricsJson);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to log payment metrics", e);
        }
    }

    /**
     * Get current request IP (helper method)
     */
    private String getCurrentRequestIP() {
        String ip = currentRequestIP.get();
        return (ip != null) ? ip : "webhook-callback";
    }

    /**
     * Enhanced error handling for email failures
     */
    private void handleEmailFailure(String emailType, int bookingId, String email, Exception e) {
        String errorMessage = String.format(
            "Failed to send %s email for booking %d to %s: %s",
            emailType, bookingId, email, e.getMessage()
        );
        
        LOGGER.log(Level.WARNING, errorMessage, e);
        
        // Could implement retry mechanism here
        // Or queue for later processing
        // Or send notification to admin
    }

    /**
     * Notify host về payment (nếu cần)
     */
    private void notifyHostOfPayment(WebhookProcessResult result) {
        try {
            // Implement host notification logic if needed
            // Ví dụ: gửi email cho host, cập nhật dashboard, etc.
            
            LOGGER.info("Host notification completed for booking: " + result.bookingId);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to notify host", e);
        }
    }

    /**
     * Get client IP address
     */
    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIP = request.getHeader("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty()) {
            return xRealIP;
        }
        
        return request.getRemoteAddr();
    }

    /**
     * Send HTTP response
     */
    private void sendResponse(HttpServletResponse response, int statusCode, String message) 
            throws IOException {
        response.setStatus(statusCode);
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(message);
    }

    // ==================== INNER CLASSES ====================

    /**
     * Webhook processing result
     */
    private static class WebhookProcessResult {
        boolean success = false;
        String errorMessage;
        int bookingId;
        double amount;
        String paymentStatus;
        String serviceType;
        Booking booking;
        WebhookData webhookData;
    }

    /**
     * Webhook data từ PayOS
     */
    private static class WebhookData {
        int bookingId;
        double amount;
        String paymentStatus;
        String statusDescription;
        String reference;
        String transactionDateTime;
    }
}