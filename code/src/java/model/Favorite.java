package model;

import java.time.LocalDateTime;
import java.util.Date;

public class Favorite {
    private Integer favoriteId;
    private Integer userId;
    private Integer experienceId;
    private Integer accommodationId;
    private LocalDateTime createdAt;
    
    // Related objects
    private Experience experience;
    private Accommodation accommodation;
    private String type; // "experience" hoặc "accommodation"
    
    // Default constructor
    public Favorite() {}
    
    // Constructor for experience
    public Favorite(Integer userId, Integer experienceId) {
        this.userId = userId;
        this.experienceId = experienceId;
        this.type = "experience";
        this.createdAt = LocalDateTime.now();
    }
    
    // Constructor for accommodation
    public Favorite(Integer userId, Integer accommodationId, boolean isAccommodation) {
        this.userId = userId;
        this.accommodationId = accommodationId;
        this.type = "accommodation";
        this.createdAt = LocalDateTime.now();
    }
    
    // Helper method to get created date as Date object for JSP compatibility
    public Date getCreatedDate() {
        if (createdAt != null) {
            return java.sql.Timestamp.valueOf(createdAt);
        }
        return null;
    }
    
    // Getters and Setters
    public Integer getFavoriteId() {
        return favoriteId;
    }
    
    public void setFavoriteId(Integer favoriteId) {
        this.favoriteId = favoriteId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getExperienceId() {
        return experienceId;
    }
    
    public void setExperienceId(Integer experienceId) {
        this.experienceId = experienceId;
        if (experienceId != null) {
            this.type = "experience";
        }
    }
    
    public Integer getAccommodationId() {
        return accommodationId;
    }
    
    public void setAccommodationId(Integer accommodationId) {
        this.accommodationId = accommodationId;
        if (accommodationId != null) {
            this.type = "accommodation";
        }
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Experience getExperience() {
        return experience;
    }
    
    public void setExperience(Experience experience) {
        this.experience = experience;
        if (experience != null) {
            this.experienceId = experience.getExperienceId();
            this.type = "experience";
        }
    }
    
    public Accommodation getAccommodation() {
        return accommodation;
    }
    
    public void setAccommodation(Accommodation accommodation) {
        this.accommodation = accommodation;
        if (accommodation != null) {
            this.accommodationId = accommodation.getAccommodationId();
            this.type = "accommodation";
        }
    }
    
    public String getType() {
        if (type == null) {
            if (experienceId != null) {
                type = "experience";
            } else if (accommodationId != null) {
                type = "accommodation";
            }
        }
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    // Helper methods
    public String getItemName() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getTitle();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getName();
        }
        return "";
    }
    
    public String getItemLocation() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getCityName() != null ? experience.getCityName() : experience.getLocation();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getCityName() != null ? accommodation.getCityName() : accommodation.getAddress();
        }
        return "";
    }
    
    public Double getItemPrice() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getPrice();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getPricePerNight();
        }
        return 0.0;
    }
    
    public String getItemFirstImage() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getFirstImage();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getFirstImage();
        }
        return null;
    }
    
    public Double getItemRating() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getAverageRating();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getAverageRating();
        }
        return 0.0;
    }
    
    public Integer getItemBookings() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getTotalBookings();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getTotalBookings();
        }
        return 0;
    }
    
    public String getItemHost() {
        if ("experience".equals(getType()) && experience != null) {
            return experience.getHostName();
        } else if ("accommodation".equals(getType()) && accommodation != null) {
            return accommodation.getHostName();
        }
        return "";
    }
    
    public String getTypeText() {
        switch (getType()) {
            case "experience":
                return "Trải nghiệm";
            case "accommodation":
                return "Lưu trú";
            default:
                return "";
        }
    }
    
    public String getItemUrl() {
        if ("experience".equals(getType()) && experienceId != null) {
            return "/experiences/" + experienceId;
        } else if ("accommodation".equals(getType()) && accommodationId != null) {
            return "/accommodations/" + accommodationId;
        }
        return "#";
    }
    
    @Override
    public String toString() {
        return "Favorite{" +
                "favoriteId=" + favoriteId +
                ", userId=" + userId +
                ", experienceId=" + experienceId +
                ", accommodationId=" + accommodationId +
                ", type='" + type + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Favorite favorite = (Favorite) obj;
        
        if (favoriteId != null && favorite.favoriteId != null) {
            return favoriteId.equals(favorite.favoriteId);
        }
        
        return userId != null && userId.equals(favorite.userId) &&
               experienceId != null && experienceId.equals(favorite.experienceId) &&
               accommodationId != null && accommodationId.equals(favorite.accommodationId);
    }
    
    @Override
    public int hashCode() {
        if (favoriteId != null) {
            return favoriteId.hashCode();
        }
        
        int result = userId != null ? userId.hashCode() : 0;
        result = 31 * result + (experienceId != null ? experienceId.hashCode() : 0);
        result = 31 * result + (accommodationId != null ? accommodationId.hashCode() : 0);
        return result;
    }
}