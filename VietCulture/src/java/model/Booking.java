package model;

import java.util.Date;

public class Booking {

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

    // Additional fields for display
    private String experienceName;
    private String accommodationName;
    private String travelerName;
    private String travelerEmail;
    private Date checkInDate;
    private Date checkOutDate;

    // Constructors
    public Booking() {
    }

    public Booking(Integer experienceId, Integer accommodationId, int travelerId,
            Date bookingDate, Date bookingTime, int numberOfPeople,
            double totalPrice, String status, String contactInfo) {
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

    public String getBookingType() {
        if (isExperienceBooking()) {
            return "Trải nghiệm";
        } else if (isAccommodationBooking()) {
            return "Lưu trú";
        }
        return "Không xác định";
    }

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
