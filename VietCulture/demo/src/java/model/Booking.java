package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model đại diện cho đơn đặt tour.
 */
public class Booking {
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    private int bookingID;
    private String customerName;
    private String email;
    private String phone;
    private String tourName;
    private BigDecimal amount;
    private String paymentStatus;
    private LocalDateTime createdAt;

    // Constructors
<<<<<<< HEAD
    public Booking() {
    }

    public Booking(int bookingID, String customerName, String email, String phone,
            String tourName, BigDecimal amount, String paymentStatus, LocalDateTime createdAt) {
=======
    public Booking() {}

    public Booking(int bookingID, String customerName, String email, String phone,
                   String tourName, BigDecimal amount, String paymentStatus, LocalDateTime createdAt) {
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
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
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getCustomerName() {
        return customerName;
    }
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEmail() {
        return email;
    }
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getTourName() {
        return tourName;
    }
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public BigDecimal getAmount() {
        return amount;
    }
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
<<<<<<< HEAD

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
=======
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
