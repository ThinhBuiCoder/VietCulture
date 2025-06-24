package model;

import java.util.Date;
<<<<<<< HEAD

public class Booking {

=======
import java.text.SimpleDateFormat;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

/**
 * Enhanced Booking Model with PayOS Integration Support
 * Includes payment tracking, status management, and utility methods
 */
public class Booking {
    // Core booking fields
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private int bookingId;
    private Integer experienceId;
    private Integer accommodationId;
    private int travelerId;
    private Date bookingDate;
    private Date bookingTime;
    private int numberOfPeople;
    private double totalPrice;
    private String status;
    private String specialRequests;
    private String contactInfo;
    private Date createdAt;
<<<<<<< HEAD

    // Additional fields for display
=======
    private Date updatedAt;
    
    // Payment related fields
    private String paymentMethod;
    private String paymentStatus;
    private Long paymentOrderCode;
    private String paymentTransactionId;
    private Date paymentCompletedAt;
    private String paymentGateway;
    private double paidAmount;
    private String paymentReference;
    private String paymentNotes;
    
    // Additional tracking fields
    private String cancellationReason;
    private Date cancelledAt;
    private int cancelledBy;
    private String refundStatus;
    private double refundAmount;
    private Date refundProcessedAt;
    
    // Display fields (not stored in DB)
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private String experienceName;
    private String accommodationName;
    private String travelerName;
    private String travelerEmail;
<<<<<<< HEAD
    private Date checkInDate;
    private Date checkOutDate;

    // Constructors
    public Booking() {
    }

    public Booking(Integer experienceId, Integer accommodationId, int travelerId,
            Date bookingDate, Date bookingTime, int numberOfPeople,
            double totalPrice, String status, String contactInfo) {
=======
    private String travelerPhone;

    public void setStatusText(String đã_xác_nhận) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    
    // Constants for status values
    public static final class Status {
        public static final String PENDING = "PENDING";
        public static final String PENDING_PAYMENT = "PENDING_PAYMENT";
        public static final String CONFIRMED = "CONFIRMED";
        public static final String COMPLETED = "COMPLETED";
        public static final String CANCELLED = "CANCELLED";
        public static final String REFUNDED = "REFUNDED";
        public static final String EXPIRED = "EXPIRED";
    }
    
    // Constants for payment methods
    public static final class PaymentMethod {
        public static final String CASH = "CASH";
        public static final String PAYOS = "PAYOS";
        public static final String MOMO = "MOMO";
        public static final String ZALOPAY = "ZALOPAY";
        public static final String BANKING = "BANKING";
        public static final String CARD = "CARD";
    }
    
    // Constants for payment status
    public static final class PaymentStatus {
        public static final String PENDING = "PENDING";
        public static final String PROCESSING = "PROCESSING";
        public static final String PAID = "PAID";
        public static final String FAILED = "FAILED";
        public static final String CANCELLED = "CANCELLED";
        public static final String REFUNDED = "REFUNDED";
        public static final String EXPIRED = "EXPIRED";
    }
    
    // Gson instance for JSON operations
    private static final Gson gson = new Gson();
    
    // ==================== CONSTRUCTORS ====================
    
    public Booking() {
        this.createdAt = new Date();
        this.updatedAt = new Date();
        this.status = Status.PENDING;
        this.paymentStatus = PaymentStatus.PENDING;
    }
    
    public Booking(Integer experienceId, Integer accommodationId, int travelerId, 
                   Date bookingDate, Date bookingTime, int numberOfPeople, 
                   double totalPrice, String status, String contactInfo) {
        this();
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        this.experienceId = experienceId;
        this.accommodationId = accommodationId;
        this.travelerId = travelerId;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.numberOfPeople = numberOfPeople;
        this.totalPrice = totalPrice;
        this.status = status;
        this.contactInfo = contactInfo;
    }
<<<<<<< HEAD

    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Integer getExperienceId() {
        return experienceId;
    }

    public void setExperienceId(Integer experienceId) {
        this.experienceId = experienceId;
    }

    public Integer getAccommodationId() {
        return accommodationId;
    }

    public void setAccommodationId(Integer accommodationId) {
        this.accommodationId = accommodationId;
    }

    public int getTravelerId() {
        return travelerId;
    }

    public void setTravelerId(int travelerId) {
        this.travelerId = travelerId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Date getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Date bookingTime) {
        this.bookingTime = bookingTime;
    }

    public int getNumberOfPeople() {
        return numberOfPeople;
    }

    public void setNumberOfPeople(int numberOfPeople) {
        this.numberOfPeople = numberOfPeople;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getExperienceName() {
        return experienceName;
    }

    public void setExperienceName(String experienceName) {
        this.experienceName = experienceName;
    }

    public String getAccommodationName() {
        return accommodationName;
    }

    public void setAccommodationName(String accommodationName) {
        this.accommodationName = accommodationName;
    }

    public String getTravelerName() {
        return travelerName;
    }

    public void setTravelerName(String travelerName) {
        this.travelerName = travelerName;
    }

    public String getTravelerEmail() {
        return travelerEmail;
    }

    public void setTravelerEmail(String travelerEmail) {
        this.travelerEmail = travelerEmail;
    }

    // Helper methods
    public boolean isExperienceBooking() {
        return experienceId != null;
    }

    public boolean isAccommodationBooking() {
        return accommodationId != null;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

=======
    
    // ==================== CORE GETTERS AND SETTERS ====================
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { 
        this.bookingId = bookingId; 
        updateTimestamp();
    }
    
    public Integer getExperienceId() { return experienceId; }
    public void setExperienceId(Integer experienceId) { 
        this.experienceId = experienceId;
        updateTimestamp();
    }
    
    public Integer getAccommodationId() { return accommodationId; }
    public void setAccommodationId(Integer accommodationId) { 
        this.accommodationId = accommodationId;
        updateTimestamp();
    }
    
    public int getTravelerId() { return travelerId; }
    public void setTravelerId(int travelerId) { 
        this.travelerId = travelerId;
        updateTimestamp();
    }
    
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { 
        this.bookingDate = bookingDate;
        updateTimestamp();
    }
    
    public Date getBookingTime() { return bookingTime; }
    public void setBookingTime(Date bookingTime) { 
        this.bookingTime = bookingTime;
        updateTimestamp();
    }
    
    public int getNumberOfPeople() { return numberOfPeople; }
    public void setNumberOfPeople(int numberOfPeople) { 
        this.numberOfPeople = numberOfPeople;
        updateTimestamp();
    }
    
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { 
        this.totalPrice = totalPrice;
        updateTimestamp();
    }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { 
        this.status = status;
        updateTimestamp();
    }
    
    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { 
        this.specialRequests = specialRequests;
        updateTimestamp();
    }
    
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { 
        this.contactInfo = contactInfo;
        updateTimestamp();
    }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    // ==================== PAYMENT GETTERS AND SETTERS ====================
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { 
        this.paymentMethod = paymentMethod;
        updateTimestamp();
    }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { 
        this.paymentStatus = paymentStatus;
        updateTimestamp();
    }
    
    public Long getPaymentOrderCode() { return paymentOrderCode; }
    public void setPaymentOrderCode(Long paymentOrderCode) { 
        this.paymentOrderCode = paymentOrderCode;
        updateTimestamp();
    }
    
    public String getPaymentTransactionId() { return paymentTransactionId; }
    public void setPaymentTransactionId(String paymentTransactionId) { 
        this.paymentTransactionId = paymentTransactionId;
        updateTimestamp();
    }
    
    public Date getPaymentCompletedAt() { return paymentCompletedAt; }
    public void setPaymentCompletedAt(Date paymentCompletedAt) { 
        this.paymentCompletedAt = paymentCompletedAt;
        updateTimestamp();
    }
    
    public String getPaymentGateway() { return paymentGateway; }
    public void setPaymentGateway(String paymentGateway) { 
        this.paymentGateway = paymentGateway;
        updateTimestamp();
    }
    
    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { 
        this.paidAmount = paidAmount;
        updateTimestamp();
    }
    
    public String getPaymentReference() { return paymentReference; }
    public void setPaymentReference(String paymentReference) { 
        this.paymentReference = paymentReference;
        updateTimestamp();
    }
    
    public String getPaymentNotes() { return paymentNotes; }
    public void setPaymentNotes(String paymentNotes) { 
        this.paymentNotes = paymentNotes;
        updateTimestamp();
    }
    
    // ==================== CANCELLATION & REFUND GETTERS AND SETTERS ====================
    
    public String getCancellationReason() { return cancellationReason; }
    public void setCancellationReason(String cancellationReason) { 
        this.cancellationReason = cancellationReason;
        updateTimestamp();
    }
    
    public Date getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(Date cancelledAt) { 
        this.cancelledAt = cancelledAt;
        updateTimestamp();
    }
    
    public int getCancelledBy() { return cancelledBy; }
    public void setCancelledBy(int cancelledBy) { 
        this.cancelledBy = cancelledBy;
        updateTimestamp();
    }
    
    public String getRefundStatus() { return refundStatus; }
    public void setRefundStatus(String refundStatus) { 
        this.refundStatus = refundStatus;
        updateTimestamp();
    }
    
    public double getRefundAmount() { return refundAmount; }
    public void setRefundAmount(double refundAmount) { 
        this.refundAmount = refundAmount;
        updateTimestamp();
    }
    
    public Date getRefundProcessedAt() { return refundProcessedAt; }
    public void setRefundProcessedAt(Date refundProcessedAt) { 
        this.refundProcessedAt = refundProcessedAt;
        updateTimestamp();
    }
    
    // ==================== DISPLAY GETTERS AND SETTERS ====================
    
    public String getExperienceName() { return experienceName; }
    public void setExperienceName(String experienceName) { this.experienceName = experienceName; }
    
    public String getAccommodationName() { return accommodationName; }
    public void setAccommodationName(String accommodationName) { this.accommodationName = accommodationName; }
    
    public String getTravelerName() { return travelerName; }
    public void setTravelerName(String travelerName) { this.travelerName = travelerName; }
    
    public String getTravelerEmail() { return travelerEmail; }
    public void setTravelerEmail(String travelerEmail) { this.travelerEmail = travelerEmail; }
    
    public String getTravelerPhone() { return travelerPhone; }
    public void setTravelerPhone(String travelerPhone) { this.travelerPhone = travelerPhone; }
    
    // ==================== UTILITY METHODS ====================
    
    /**
     * Update the timestamp when booking is modified
     */
    private void updateTimestamp() {
        this.updatedAt = new Date();
    }
    
    /**
     * Check if this is an experience booking
     */
    public boolean isExperienceBooking() {
        return experienceId != null && experienceId > 0;
    }
    
    /**
     * Check if this is an accommodation booking
     */
    public boolean isAccommodationBooking() {
        return accommodationId != null && accommodationId > 0;
    }
    
    /**
     * Get booking type as string
     */
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    public String getBookingType() {
        if (isExperienceBooking()) {
            return "Trải nghiệm";
        } else if (isAccommodationBooking()) {
            return "Lưu trú";
        }
        return "Không xác định";
    }
<<<<<<< HEAD

    public String getStatusText() {
        switch (status) {
            case "PENDING":
                return "Chờ xác nhận";
            case "CONFIRMED":
                return "Đã xác nhận";
            case "COMPLETED":
                return "Hoàn thành";
            case "CANCELLED":
                return "Đã hủy";
            default:
                return status;
        }
    }

    @Override
    public String toString() {
        return "Booking{"
                + "bookingId=" + bookingId
                + ", experienceId=" + experienceId
                + ", accommodationId=" + accommodationId
                + ", travelerId=" + travelerId
                + ", bookingDate=" + bookingDate
                + ", numberOfPeople=" + numberOfPeople
                + ", totalPrice=" + totalPrice
                + ", status='" + status + '\''
                + ", createdAt=" + createdAt
                + '}';
    }
}
=======
    
    /**
     * Get booking type code
     */
    public String getBookingTypeCode() {
        if (isExperienceBooking()) {
            return "EXPERIENCE";
        } else if (isAccommodationBooking()) {
            return "ACCOMMODATION";
        }
        return "UNKNOWN";
    }
    
    /**
     * Get status text in Vietnamese
     */
    public String getStatusText() {
        switch (status != null ? status : "") {
            case Status.PENDING:
                return "Chờ xác nhận";
            case Status.PENDING_PAYMENT:
                return "Chờ thanh toán";
            case Status.CONFIRMED:
                return "Đã xác nhận";
            case Status.COMPLETED:
                return "Hoàn thành";
            case Status.CANCELLED:
                return "Đã hủy";
            case Status.REFUNDED:
                return "Đã hoàn tiền";
            case Status.EXPIRED:
                return "Đã hết hạn";
            default:
                return status != null ? status : "Không xác định";
        }
    }
    
    /**
     * Get payment method text in Vietnamese
     */
    public String getPaymentMethodText() {
        switch (paymentMethod != null ? paymentMethod : "") {
            case PaymentMethod.CASH:
                return "Tiền mặt";
            case PaymentMethod.PAYOS:
                return "PayOS";
            case PaymentMethod.MOMO:
                return "Ví MoMo";
            case PaymentMethod.ZALOPAY:
                return "ZaloPay";
            case PaymentMethod.BANKING:
                return "Internet Banking";
            case PaymentMethod.CARD:
                return "Thẻ tín dụng";
            default:
                return paymentMethod != null ? paymentMethod : "Chưa xác định";
        }
    }
    
    /**
     * Get payment status text in Vietnamese
     */
    public String getPaymentStatusText() {
        switch (paymentStatus != null ? paymentStatus : "") {
            case PaymentStatus.PENDING:
                return "Chờ thanh toán";
            case PaymentStatus.PROCESSING:
                return "Đang xử lý";
            case PaymentStatus.PAID:
                return "Đã thanh toán";
            case PaymentStatus.FAILED:
                return "Thanh toán thất bại";
            case PaymentStatus.CANCELLED:
                return "Đã hủy thanh toán";
            case PaymentStatus.REFUNDED:
                return "Đã hoàn tiền";
            case PaymentStatus.EXPIRED:
                return "Hết hạn thanh toán";
            default:
                return paymentStatus != null ? paymentStatus : "Không xác định";
        }
    }
    
    /**
     * Check if booking can be cancelled
     */
    public boolean canBeCancelled() {
        return Status.PENDING.equals(status) || 
               Status.PENDING_PAYMENT.equals(status) ||
               Status.CONFIRMED.equals(status);
    }
    
    /**
     * Check if booking can be refunded
     */
    public boolean canBeRefunded() {
        return Status.CONFIRMED.equals(status) && 
               PaymentStatus.PAID.equals(paymentStatus) &&
               paidAmount > 0;
    }
    
    /**
     * Check if payment is completed
     */
    public boolean isPaymentCompleted() {
        return PaymentStatus.PAID.equals(paymentStatus);
    }
    
    /**
     * Check if booking is active (not cancelled or expired)
     */
    public boolean isActive() {
        return !Status.CANCELLED.equals(status) && 
               !Status.EXPIRED.equals(status) &&
               !Status.REFUNDED.equals(status);
    }
    
    /**
     * Check if booking requires payment
     */
    public boolean requiresPayment() {
        return !PaymentMethod.CASH.equals(paymentMethod) && 
               !isPaymentCompleted();
    }
    
    // ==================== CONTACT INFO METHODS ====================
    
    /**
     * Parse contact info JSON and get contact name
     */
    public String getContactName() {
        return getContactInfoField("name");
    }
    
    /**
     * Parse contact info JSON and get contact email
     */
    public String getContactEmail() {
        return getContactInfoField("email");
    }
    
    /**
     * Parse contact info JSON and get contact phone
     */
    public String getContactPhone() {
        return getContactInfoField("phone");
    }
    
    /**
     * Get a specific field from contact info JSON
     */
    private String getContactInfoField(String field) {
        try {
            if (contactInfo != null && !contactInfo.trim().isEmpty()) {
                Type mapType = new TypeToken<Map<String, Object>>(){}.getType();
                Map<String, Object> contact = gson.fromJson(contactInfo, mapType);
                Object value = contact.get(field);
                return value != null ? value.toString() : "";
            }
        } catch (Exception e) {
            // Log error but don't throw exception
            System.err.println("Error parsing contact info: " + e.getMessage());
        }
        return "";
    }
    
    /**
     * Update contact info with new values
     */
    public void updateContactInfo(String name, String email, String phone) {
        try {
            Map<String, String> contact = Map.of(
                "name", name != null ? name : "",
                "email", email != null ? email : "",
                "phone", phone != null ? phone : ""
            );
            this.contactInfo = gson.toJson(contact);
            updateTimestamp();
        } catch (Exception e) {
            System.err.println("Error updating contact info: " + e.getMessage());
        }
    }
    
    // ==================== FORMATTING METHODS ====================
    
    /**
     * Format total price as currency
     */
    public String getFormattedTotalPrice() {
        return String.format("%,.0f VNĐ", totalPrice);
    }
    
    /**
     * Format paid amount as currency
     */
    public String getFormattedPaidAmount() {
        return String.format("%,.0f VNĐ", paidAmount);
    }
    
    /**
     * Format refund amount as currency
     */
    public String getFormattedRefundAmount() {
        return String.format("%,.0f VNĐ", refundAmount);
    }
    
    /**
     * Format booking date
     */
    public String getFormattedBookingDate() {
        if (bookingDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            return sdf.format(bookingDate);
        }
        return "";
    }
    
    /**
     * Format booking time
     */
    public String getFormattedBookingTime() {
        if (bookingTime != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            return sdf.format(bookingTime);
        }
        return "";
    }
    
    /**
     * Format created date
     */
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            return sdf.format(createdAt);
        }
        return "";
    }
    
    /**
     * Format payment completed date
     */
    public String getFormattedPaymentCompletedAt() {
        if (paymentCompletedAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            return sdf.format(paymentCompletedAt);
        }
        return "";
    }
    
    // ==================== PAYMENT OPERATIONS ====================
    
    /**
     * Mark payment as completed
     */
    public void completePayment(String transactionId, String reference, double amount) {
        this.paymentStatus = PaymentStatus.PAID;
        this.paymentTransactionId = transactionId;
        this.paymentReference = reference;
        this.paidAmount = amount;
        this.paymentCompletedAt = new Date();
        this.status = Status.CONFIRMED;
        updateTimestamp();
    }
    
    /**
     * Mark payment as failed
     */
    public void failPayment(String reason) {
        this.paymentStatus = PaymentStatus.FAILED;
        this.paymentNotes = reason;
        updateTimestamp();
    }
    
    /**
     * Cancel the booking
     */
    public void cancel(String reason, int cancelledBy) {
        this.status = Status.CANCELLED;
        this.cancellationReason = reason;
        this.cancelledBy = cancelledBy;
        this.cancelledAt = new Date();
        
        // Cancel payment if not completed
        if (!isPaymentCompleted()) {
            this.paymentStatus = PaymentStatus.CANCELLED;
        }
        
        updateTimestamp();
    }
    
    /**
     * Process refund
     */
    public void processRefund(double amount, String status) {
        this.refundAmount = amount;
        this.refundStatus = status;
        this.refundProcessedAt = new Date();
        
        if (amount >= paidAmount) {
            this.status = Status.REFUNDED;
            this.paymentStatus = PaymentStatus.REFUNDED;
        }
        
        updateTimestamp();
    }
    
    // ==================== VALIDATION METHODS ====================
    
    /**
     * Validate booking data
     */
    public boolean isValid() {
        return (experienceId != null || accommodationId != null) &&
               travelerId > 0 &&
               bookingDate != null &&
               numberOfPeople > 0 &&
               totalPrice > 0 &&
               contactInfo != null && !contactInfo.trim().isEmpty();
    }
    
    /**
     * Get validation errors
     */
    public String getValidationErrors() {
        StringBuilder errors = new StringBuilder();
        
        if (experienceId == null && accommodationId == null) {
            errors.append("Phải có ít nhất một dịch vụ được đặt. ");
        }
        if (travelerId <= 0) {
            errors.append("ID khách hàng không hợp lệ. ");
        }
        if (bookingDate == null) {
            errors.append("Ngày đặt chỗ không được để trống. ");
        }
        if (numberOfPeople <= 0) {
            errors.append("Số người phải lớn hơn 0. ");
        }
        if (totalPrice <= 0) {
            errors.append("Tổng giá phải lớn hơn 0. ");
        }
        if (contactInfo == null || contactInfo.trim().isEmpty()) {
            errors.append("Thông tin liên hệ không được để trống. ");
        }
        
        return errors.toString().trim();
    }
    
    // ==================== OBJECT METHODS ====================
    
    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", experienceId=" + experienceId +
                ", accommodationId=" + accommodationId +
                ", travelerId=" + travelerId +
                ", bookingDate=" + bookingDate +
                ", numberOfPeople=" + numberOfPeople +
                ", totalPrice=" + totalPrice +
                ", status='" + status + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", paymentOrderCode=" + paymentOrderCode +
                ", createdAt=" + createdAt +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Booking booking = (Booking) obj;
        return bookingId == booking.bookingId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(bookingId);
    }
    
    /**
     * Create a copy of this booking
     */
    public Booking copy() {
        Booking copy = new Booking();
        
        // Copy all fields
        copy.bookingId = this.bookingId;
        copy.experienceId = this.experienceId;
        copy.accommodationId = this.accommodationId;
        copy.travelerId = this.travelerId;
        copy.bookingDate = this.bookingDate != null ? new Date(this.bookingDate.getTime()) : null;
        copy.bookingTime = this.bookingTime != null ? new Date(this.bookingTime.getTime()) : null;
        copy.numberOfPeople = this.numberOfPeople;
        copy.totalPrice = this.totalPrice;
        copy.status = this.status;
        copy.specialRequests = this.specialRequests;
        copy.contactInfo = this.contactInfo;
        copy.createdAt = this.createdAt != null ? new Date(this.createdAt.getTime()) : null;
        copy.updatedAt = this.updatedAt != null ? new Date(this.updatedAt.getTime()) : null;
        
        // Copy payment fields
        copy.paymentMethod = this.paymentMethod;
        copy.paymentStatus = this.paymentStatus;
        copy.paymentOrderCode = this.paymentOrderCode;
        copy.paymentTransactionId = this.paymentTransactionId;
        copy.paymentCompletedAt = this.paymentCompletedAt != null ? new Date(this.paymentCompletedAt.getTime()) : null;
        copy.paymentGateway = this.paymentGateway;
        copy.paidAmount = this.paidAmount;
        copy.paymentReference = this.paymentReference;
        copy.paymentNotes = this.paymentNotes;
        
        // Copy cancellation fields
        copy.cancellationReason = this.cancellationReason;
        copy.cancelledAt = this.cancelledAt != null ? new Date(this.cancelledAt.getTime()) : null;
        copy.cancelledBy = this.cancelledBy;
        copy.refundStatus = this.refundStatus;
        copy.refundAmount = this.refundAmount;
        copy.refundProcessedAt = this.refundProcessedAt != null ? new Date(this.refundProcessedAt.getTime()) : null;
        
        // Copy display fields
        copy.experienceName = this.experienceName;
        copy.accommodationName = this.accommodationName;
        copy.travelerName = this.travelerName;
        copy.travelerEmail = this.travelerEmail;
        copy.travelerPhone = this.travelerPhone;
        
        return copy;
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
