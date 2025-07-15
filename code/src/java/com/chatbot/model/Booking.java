package com.chatbot.model;

import java.util.Date;

public class Booking {
    private int bookingId;
    private int travelerId;
    private Integer experienceId;
    private Integer accommodationId;
    private Date bookingDate;
    private Date startDate;
    private Date endDate;
    private int numberOfGuests;
    private double totalAmount;
    private String status; // PENDING, CONFIRMED, CANCELLED, COMPLETED
    private String paymentStatus; // PENDING, PAID, REFUNDED
    private String paymentMethod;
    private String specialRequests;
    private Date createdAt;
    private Date updatedAt;
    
    // Additional fields for display
    private String travelerName;
    private String experienceTitle;
    private String accommodationName;
    private String hostName;
    
    // Constructor
    public Booking() {}
    
    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public int getTravelerId() { return travelerId; }
    public void setTravelerId(int travelerId) { this.travelerId = travelerId; }
    
    public Integer getExperienceId() { return experienceId; }
    public void setExperienceId(Integer experienceId) { this.experienceId = experienceId; }
    
    public Integer getAccommodationId() { return accommodationId; }
    public void setAccommodationId(Integer accommodationId) { this.accommodationId = accommodationId; }
    
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    
    public int getNumberOfGuests() { return numberOfGuests; }
    public void setNumberOfGuests(int numberOfGuests) { this.numberOfGuests = numberOfGuests; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    // Display fields
    public String getTravelerName() { return travelerName; }
    public void setTravelerName(String travelerName) { this.travelerName = travelerName; }
    
    public String getExperienceTitle() { return experienceTitle; }
    public void setExperienceTitle(String experienceTitle) { this.experienceTitle = experienceTitle; }
    
    public String getAccommodationName() { return accommodationName; }
    public void setAccommodationName(String accommodationName) { this.accommodationName = accommodationName; }
    
    public String getHostName() { return hostName; }
    public void setHostName(String hostName) { this.hostName = hostName; }
    
    // Helper methods
    public String getFormattedAmount() {
        return String.format("%.0f VNĐ", totalAmount);
    }
    
    public String getDisplayStatus() {
        switch (status) {
            case "PENDING": return "Chờ xác nhận";
            case "CONFIRMED": return "Đã xác nhận";
            case "CANCELLED": return "Đã hủy";
            case "COMPLETED": return "Hoàn thành";
            default: return status;
        }
    }
    
    public String getDisplayPaymentStatus() {
        switch (paymentStatus) {
            case "PENDING": return "Chờ thanh toán";
            case "PAID": return "Đã thanh toán";
            case "REFUNDED": return "Đã hoàn tiền";
            default: return paymentStatus;
        }
    }
    
    public boolean isExperienceBooking() { return experienceId != null; }
    public boolean isAccommodationBooking() { return accommodationId != null; }
}