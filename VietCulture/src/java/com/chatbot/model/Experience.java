package com.chatbot.model;

public class Experience {
    private int experienceId;
    private String title;
    private String description;
    private String location;
    private String type;
    private double price;
    private int maxGroupSize;
    private String duration;
    private String difficulty;
    private String language;
    private String includedItems;
    private String requirements;
    private String images;
    private float averageRating;
    private int totalBookings;
    private String cityName;
    private String hostName;
    private boolean isActive;
    private String adminApprovalStatus;
    
    // Constructor
    public Experience() {}
    
    // Getters and Setters
    public int getExperienceId() { return experienceId; }
    public void setExperienceId(int experienceId) { this.experienceId = experienceId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public int getMaxGroupSize() { return maxGroupSize; }
    public void setMaxGroupSize(int maxGroupSize) { this.maxGroupSize = maxGroupSize; }
    
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
    
    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }
    
    public String getIncludedItems() { return includedItems; }
    public void setIncludedItems(String includedItems) { this.includedItems = includedItems; }
    
    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }
    
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
        return String.format("%.0f VNĐ", price);
    }
    
    // Helper method to format duration
    public String getFormattedDuration() {
        if (duration == null) return "";
        return duration.replace(":", " giờ ") + " phút";
    }
}