package model;

import java.util.List;
import java.util.ArrayList;

public class Region {
    private int regionId;
    private String name;
    private String vietnameseName;
    private String description;
    private String imageUrl;
    private String climate;
    private String culture;
    private List<City> cities;
    private int experienceCount; // For display purposes
    
    // Constructors
    public Region() {
        this.cities = new ArrayList<>();
    }
    
    public Region(String name, String vietnameseName, String description) {
        this();
        this.name = name;
        this.vietnameseName = vietnameseName;
        this.description = description;
    }
    
    // Getters and Setters
    public int getRegionId() {
        return regionId;
    }
    
    public void setRegionId(int regionId) {
        this.regionId = regionId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getVietnameseName() {
        return vietnameseName;
    }
    
    public void setVietnameseName(String vietnameseName) {
        this.vietnameseName = vietnameseName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getClimate() {
        return climate;
    }
    
    public void setClimate(String climate) {
        this.climate = climate;
    }
    
    public String getCulture() {
        return culture;
    }
    
    public void setCulture(String culture) {
        this.culture = culture;
    }
    
    public List<City> getCities() {
        return cities;
    }
    
    public void setCities(List<City> cities) {
        this.cities = cities;
    }
    
    public int getExperienceCount() {
        return experienceCount;
    }
    
    public void setExperienceCount(int experienceCount) {
        this.experienceCount = experienceCount;
    }
    
    @Override
    public String toString() {
        return "Region{" +
                "regionId=" + regionId +
                ", name='" + name + '\'' +
                ", vietnameseName='" + vietnameseName + '\'' +
                ", description='" + description + '\'' +
                ", experienceCount=" + experienceCount +
                '}';
    }
}