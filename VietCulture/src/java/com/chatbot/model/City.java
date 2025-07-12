package com.chatbot.model;

public class City {
    private int cityId;
    private String name;
    private String vietnameseName;
    private String regionId;
    private String description;
    private String imageUrl;
    private String attractions;
    
    // Constructor
    public City() {}
    
    // Getters and Setters
    public int getCityId() { return cityId; }
    public void setCityId(int cityId) { this.cityId = cityId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getVietnameseName() { return vietnameseName; }
    public void setVietnameseName(String vietnameseName) { this.vietnameseName = vietnameseName; }
    
    public String getRegionId() { return regionId; }
    public void setRegionId(String regionId) { this.regionId = regionId; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String getAttractions() { return attractions; }
    public void setAttractions(String attractions) { this.attractions = attractions; }
    
    // Helper method to get display name
    public String getDisplayName() {
        return vietnameseName != null ? vietnameseName : name;
    }
}