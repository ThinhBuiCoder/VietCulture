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
    
    // Constructors
    public Review() {}
    
    public Review(int travelerId, int rating, String comment) {
        this.travelerId = travelerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = new Date();
        this.isVisible = true;
    }
    
    // Getters and Setters
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
    
    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", experienceId=" + experienceId +
                ", accommodationId=" + accommodationId +
                '}';
    }
}