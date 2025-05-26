package model;

import java.util.Date;

public class Experience {
    private int experienceId;
    private int hostId;
    private String title;
    private String description;
    private String location;
    private int cityId;
    private String type;
    private double price;
    private int maxGroupSize;
    private Date duration;
    private String difficulty;
    private String language;
    private String includedItems;
    private String requirements;
    private Date createdAt;
    private boolean isActive;
    private String images;
    private double averageRating;
    private int totalBookings;
    
    // Additional fields for display
    private String cityName;
    private String hostName;
    
    // Constructors
    public Experience() {}
    
    public Experience(int hostId, String title, String description, String location, 
                     int cityId, String type, double price, int maxGroupSize, 
                     Date duration, String difficulty, String language) {
        this.hostId = hostId;
        this.title = title;
        this.description = description;
        this.location = location;
        this.cityId = cityId;
        this.type = type;
        this.price = price;
        this.maxGroupSize = maxGroupSize;
        this.duration = duration;
        this.difficulty = difficulty;
        this.language = language;
        this.isActive = false; // Default to inactive until approved
        this.averageRating = 0.0;
        this.totalBookings = 0;
    }
    
    // Getters and Setters
    public int getExperienceId() {
        return experienceId;
    }
    
    public void setExperienceId(int experienceId) {
        this.experienceId = experienceId;
    }
    
    public int getHostId() {
        return hostId;
    }
    
    public void setHostId(int hostId) {
        this.hostId = hostId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public int getCityId() {
        return cityId;
    }
    
    public void setCityId(int cityId) {
        this.cityId = cityId;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public int getMaxGroupSize() {
        return maxGroupSize;
    }
    
    public void setMaxGroupSize(int maxGroupSize) {
        this.maxGroupSize = maxGroupSize;
    }
    
    public Date getDuration() {
        return duration;
    }
    
    public void setDuration(Date duration) {
        this.duration = duration;
    }
    
    public String getDifficulty() {
        return difficulty;
    }
    
    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }
    
    public String getLanguage() {
        return language;
    }
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    public String getIncludedItems() {
        return includedItems;
    }
    
    public void setIncludedItems(String includedItems) {
        this.includedItems = includedItems;
    }
    
    public String getRequirements() {
        return requirements;
    }
    
    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public String getImages() {
        return images;
    }
    
    public void setImages(String images) {
        this.images = images;
    }
    
    public double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }
    
    public int getTotalBookings() {
        return totalBookings;
    }
    
    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }
    
    public String getCityName() {
        return cityName;
    }
    
    public void setCityName(String cityName) {
        this.cityName = cityName;
    }
    
    public String getHostName() {
        return hostName;
    }
    
    public void setHostName(String hostName) {
        this.hostName = hostName;
    }
    
    // Helper methods
    public String getDifficultyText() {
        switch (difficulty) {
            case "EASY":
                return "Dễ";
            case "MODERATE":
                return "Trung bình";
            case "CHALLENGING":
                return "Khó";
            default:
                return difficulty;
        }
    }
    
    public String getTypeText() {
        switch (type) {
            case "Food":
                return "Ẩm thực";
            case "Culture":
                return "Văn hóa";
            case "Adventure":
                return "Phiêu lưu";
            case "History":
                return "Lịch sử";
            default:
                return type;
        }
    }
    
    public String getStatusText() {
        return isActive ? "Đang hoạt động" : "Chờ duyệt";
    }
    
    public String[] getImageList() {
        if (images == null || images.trim().isEmpty()) {
            return new String[0];
        }
        return images.split(",");
    }
    
    public String getFirstImage() {
        String[] imageList = getImageList();
        return imageList.length > 0 ? imageList[0].trim() : null;
    }
    
    public boolean hasImages() {
        return images != null && !images.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "Experience{" +
                "experienceId=" + experienceId +
                ", hostId=" + hostId +
                ", title='" + title + '\'' +
                ", location='" + location + '\'' +
                ", type='" + type + '\'' +
                ", price=" + price +
                ", maxGroupSize=" + maxGroupSize +
                ", difficulty='" + difficulty + '\'' +
                ", isActive=" + isActive +
                ", averageRating=" + averageRating +
                ", totalBookings=" + totalBookings +
                '}';
    }

    public void setHost(User host) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setCity(City city) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}