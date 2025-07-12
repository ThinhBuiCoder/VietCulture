package com.chatbot.model;

public class Accommodation {
    private int accommodationId;
    private String name;
    private String description;
    private String address;
    private String type;
    private int numberOfRooms;
    private int maxOccupancy;
    private String amenities;
    private double pricePerNight;
    private String images;
    private float averageRating;
    private int totalBookings;
    private String cityName;
    private String hostName;
    private boolean isActive;
    private String adminApprovalStatus;
    
    // Constructor
    public Accommodation() {}
    
    // Getters and Setters
    public int getAccommodationId() { return accommodationId; }
    public void setAccommodationId(int accommodationId) { this.accommodationId = accommodationId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public int getNumberOfRooms() { return numberOfRooms; }
    public void setNumberOfRooms(int numberOfRooms) { this.numberOfRooms = numberOfRooms; }
    
    public int getMaxOccupancy() { return maxOccupancy; }
    public void setMaxOccupancy(int maxOccupancy) { this.maxOccupancy = maxOccupancy; }
    
    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }
    
    public double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }
    
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    
    public float getAverageRating() { return averageRating; }
    public void setAverageRating(float averageRating) { this.averageRating = averageRating; }
    
    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }
    
    public String getCityName() { return cityName; }
    public void setCityName(String cityName) { this.cityName = cityName; }
    
    public String getHostName() { return hostName; }
    public void setHostName(String hostName) { this.hostName = hostName; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public String getAdminApprovalStatus() { return adminApprovalStatus; }
    public void setAdminApprovalStatus(String adminApprovalStatus) { this.adminApprovalStatus = adminApprovalStatus; }
    
    // Helper method to format price
    public String getFormattedPrice() {
        return String.format("%.0f VNĐ/đêm", pricePerNight);
    }
    
    // Helper method to format occupancy
    public String getFormattedOccupancy() {
        return maxOccupancy + " khách";
    }
}
