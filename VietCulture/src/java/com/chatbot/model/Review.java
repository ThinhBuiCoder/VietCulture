package com.chatbot.model;

import java.util.Date;

public class Review {
    private int reviewId;
    private int bookingId;
    private int reviewerId;
    private Integer experienceId;
    private Integer accommodationId;
    private int rating;
    private String comment;
    private String images;
    private Date createdAt;
    private Date updatedAt;
    private boolean isActive;
    
    // Additional fields for display
    private String reviewerName;
    private String experienceTitle;
    private String accommodationName;
    
    // Constructor
    public Review() {}
    
    // Getters and Setters
    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public int getReviewerId() { return reviewerId; }
    public void setReviewerId(int reviewerId) { this.reviewerId = reviewerId; }
    
    public Integer getExperienceId() { return experienceId; }
    public void setExperienceId(Integer experienceId) { this.experienceId = experienceId; }
    
    public Integer getAccommodationId() { return accommodationId; }
    public void setAccommodationId(Integer accommodationId) { this.accommodationId = accommodationId; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    // Display fields
    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
    
    public String getExperienceTitle() { return experienceTitle; }
    public void setExperienceTitle(String experienceTitle) { this.experienceTitle = experienceTitle; }
    
    public String getAccommodationName() { return accommodationName; }
    public void setAccommodationName(String accommodationName) { this.accommodationName = accommodationName; }
    
    // Helper methods
    public String getStarRating() {
        StringBuilder stars = new StringBuilder();
        for (int i = 0; i < rating; i++) {
            stars.append("⭐");
        }
        return stars.toString();
    }
    
    public String getFormattedRating() {
        return rating + "/5 sao";
    }
    
    public boolean isExperienceReview() { return experienceId != null; }
    public boolean isAccommodationReview() { return accommodationId != null; }
}