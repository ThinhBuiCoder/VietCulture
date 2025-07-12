package com.chatbot.model;

import java.util.Date;

public class Favorite {
    private int favoriteId;
    private int userId;
    private Integer experienceId;
    private Integer accommodationId;
    private Date createdAt;
    
    // Additional fields for display
    private String experienceTitle;
    private String accommodationName;
    private String cityName;
    private double price;
    private float averageRating;
    private String images;
    
    // Constructor
    public Favorite() {}
    
    // Getters and Setters
    public int getFavoriteId() { return favoriteId; }
    public void setFavoriteId(int favoriteId) { this.favoriteId = favoriteId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Integer getExperienceId() { return experienceId; }
    public void setExperienceId(Integer experienceId) { this.experienceId = experienceId; }
    
    public Integer getAccommodationId() { return accommodationId; }
    public void setAccommodationId(Integer accommodationId) { this.accommodationId = accommodationId; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    // Display fields
    public String getExperienceTitle() { return experienceTitle; }
    public void setExperienceTitle(String experienceTitle) { this.experienceTitle = experienceTitle; }
    
    public String getAccommodationName() { return accommodationName; }
    public void setAccommodationName(String accommodationName) { this.accommodationName = accommodationName; }
    
    public String getCityName() { return cityName; }
    public void setCityName(String cityName) { this.cityName = cityName; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public float getAverageRating() { return averageRating; }
    public void setAverageRating(float averageRating) { this.averageRating = averageRating; }
    
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    
    // Helper methods
    public String getDisplayName() {
        if (experienceTitle != null) return experienceTitle;
        if (accommodationName != null) return accommodationName;
        return "Unknown";
    }
    
    public String getFormattedPrice() {
        if (experienceId != null) {
            return String.format("%.0f VNĐ", price);
        } else {
            return String.format("%.0f VNĐ/đêm", price);
        }
    }
    
    public String getType() {
        if (experienceId != null) return "Trải nghiệm";
        if (accommodationId != null) return "Chỗ ở";
        return "Unknown";
    }
    
    public boolean isExperienceFavorite() { return experienceId != null; }
    public boolean isAccommodationFavorite() { return accommodationId != null; }
}