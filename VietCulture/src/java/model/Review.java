package model;

import java.util.Date;

public class Review {
    private int reviewId;
    private Integer experienceId; // Nullable
    private Integer accommodationId; // Nullable
    private int travelerId;
    private int rating; // 1-5
    private String comment;
    private String photos; // Comma-separated photo URLs
    private Date createdAt;
    private boolean isVisible;
    
    // Related objects
    private Experience experience;
    private Accommodation accommodation;
    private User traveler;
    
    // ===== THÊM CÁC FIELD DISPLAY NÀY =====
    // Additional fields for display (được lấy từ JOIN query)
    private String travelerName;
    private String travelerAvatar;
    private String experienceName;
    private String accommodationName;
    
    // Constructors
    public Review() {}
    
    public Review(int travelerId, int rating, String comment) {
        this.travelerId = travelerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = new Date();
        this.isVisible = true;
    }
    
    // Getters and Setters (existing ones)
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
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
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public String getPhotos() {
        return photos;
    }
    
    public void setPhotos(String photos) {
        this.photos = photos;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public boolean isVisible() {
        return isVisible;
    }
    
    public void setVisible(boolean visible) {
        isVisible = visible;
    }
    
    public Experience getExperience() {
        return experience;
    }
    
    public void setExperience(Experience experience) {
        this.experience = experience;
        if (experience != null) {
            this.experienceId = experience.getExperienceId();
        }
    }
    
    public Accommodation getAccommodation() {
        return accommodation;
    }
    
    public void setAccommodation(Accommodation accommodation) {
        this.accommodation = accommodation;
        if (accommodation != null) {
            this.accommodationId = accommodation.getAccommodationId();
        }
    }
    
    public User getTraveler() {
        return traveler;
    }
    
    public void setTraveler(User traveler) {
        this.traveler = traveler;
        if (traveler != null) {
            this.travelerId = traveler.getUserId();
        }
    }
    
    // ===== THÊM CÁC GETTER/SETTER CHO DISPLAY FIELDS =====
    
    public String getTravelerName() {
        return travelerName;
    }
    
    public void setTravelerName(String travelerName) {
        this.travelerName = travelerName;
    }
    
    public String getTravelerAvatar() {
        return travelerAvatar;
    }
    
    public void setTravelerAvatar(String travelerAvatar) {
        this.travelerAvatar = travelerAvatar;
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
    
    // ===== HELPER METHODS =====
    
    /**
     * Get review type (Experience or Accommodation)
     */
    public String getReviewType() {
        if (experienceId != null) {
            return "Experience";
        } else if (accommodationId != null) {
            return "Accommodation";
        }
        return "Unknown";
    }
    
    /**
     * Get review type in Vietnamese
     */
    public String getReviewTypeText() {
        if (experienceId != null) {
            return "Trải nghiệm";
        } else if (accommodationId != null) {
            return "Lưu trú";
        }
        return "Không xác định";
    }
    
    /**
     * Get review item name (experience or accommodation name)
     */
    public String getReviewItemName() {
        if (experienceName != null) {
            return experienceName;
        } else if (accommodationName != null) {
            return accommodationName;
        }
        return "Unknown Item";
    }
    
    /**
     * Get rating stars as string
     */
    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    /**
     * Get rating text
     */
    public String getRatingText() {
        switch (rating) {
            case 5: return "Xuất sắc";
            case 4: return "Tốt";
            case 3: return "Trung bình";
            case 2: return "Kém";
            case 1: return "Rất kém";
            default: return "Chưa đánh giá";
        }
    }
    
    /**
     * Get photos as array
     */
    public String[] getPhotoList() {
        if (photos == null || photos.trim().isEmpty()) {
            return new String[0];
        }
        return photos.split(",");
    }
    
    /**
     * Check if review has photos
     */
    public boolean hasPhotos() {
        return photos != null && !photos.trim().isEmpty();
    }
    
    /**
     * Get short comment (for preview)
     */
    public String getShortComment(int maxLength) {
        if (comment == null || comment.trim().isEmpty()) {
            return "";
        }
        
        if (comment.length() <= maxLength) {
            return comment;
        }
        
        return comment.substring(0, maxLength) + "...";
    }
    
    /**
     * Check if review is for experience
     */
    public boolean isExperienceReview() {
        return experienceId != null;
    }
    
    /**
     * Check if review is for accommodation
     */
    public boolean isAccommodationReview() {
        return accommodationId != null;
    }
    
    /**
     * Get CSS class for rating color
     */
    public String getRatingColorClass() {
        if (rating >= 4) {
            return "text-success"; // Green for good ratings
        } else if (rating >= 3) {
            return "text-warning"; // Yellow for average ratings
        } else {
            return "text-danger"; // Red for poor ratings
        }
    }
    
    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", experienceId=" + experienceId +
                ", accommodationId=" + accommodationId +
                ", travelerName='" + travelerName + '\'' +
                ", reviewType='" + getReviewType() + '\'' +
                '}';
    }
}