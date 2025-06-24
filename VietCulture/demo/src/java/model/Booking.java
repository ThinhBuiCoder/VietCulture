package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model đại diện cho đơn đặt tour.
 */
public class Booking {

    private int bookingID;
    private String customerName;
    private String email;
    private String phone;
    private String tourName;
    private BigDecimal amount;
    private String paymentStatus;
    private LocalDateTime createdAt;

    // Constructors
    public Booking() {
    }

    public Booking(int bookingID, String customerName, String email, String phone,
            String tourName, BigDecimal amount, String paymentStatus, LocalDateTime createdAt) {
        this.bookingID = bookingID;
        this.customerName = customerName;
        this.email = email;
        this.phone = phone;
        this.tourName = tourName;
        this.amount = amount;
        this.paymentStatus = paymentStatus;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
