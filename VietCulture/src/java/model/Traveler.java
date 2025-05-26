package model;

import java.util.List;
import java.util.ArrayList;

public class Traveler {
    private int userId;
    private String preferences; // JSON string containing preferences
    private int totalBookings;
    
    // Related objects
    private User user;
    private List<Booking> bookings;
    private List<Review> reviews;
    
    // Constructors
    public Traveler() {
        this.bookings = new ArrayList<>();
        this.reviews = new ArrayList<>();
        this.totalBookings = 0;
    }
    
    public Traveler(int userId) {
        this();
        this.userId = userId;
    }
    
    public Traveler(int userId, String preferences) {
        this(userId);
        this.preferences = preferences;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getPreferences() {
        return preferences;
    }
    
    public void setPreferences(String preferences) {
        this.preferences = preferences;
    }
    
    public int getTotalBookings() {
        return totalBookings;
    }
    
    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getUserId();
        }
    }
    
    public List<Booking> getBookings() {
        return bookings;
    }
    
    public void setBookings(List<Booking> bookings) {
        this.bookings = bookings;
    }
    
    public List<Review> getReviews() {
        return reviews;
    }
    
    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }
    
    // Helper methods
    public void addBooking(Booking booking) {
        if (this.bookings == null) {
            this.bookings = new ArrayList<>();
        }
        this.bookings.add(booking);
        this.totalBookings = this.bookings.size();
    }
    
    public void addReview(Review review) {
        if (this.reviews == null) {
            this.reviews = new ArrayList<>();
        }
        this.reviews.add(review);
    }
    
    /**
     * Get preferences as array (assuming comma-separated string)
     */
    public String[] getPreferenceList() {
        if (preferences == null || preferences.trim().isEmpty()) {
            return new String[0];
        }
        // If it's JSON, you might want to parse it properly
        // For now, assuming simple comma-separated values
        return preferences.split(",");
    }
    
    /**
     * Check if traveler has specific preference
     */
    public boolean hasPreference(String preference) {
        if (preferences == null || preferences.trim().isEmpty()) {
            return false;
        }
        return preferences.toLowerCase().contains(preference.toLowerCase());
    }
    
    /**
     * Get traveler level based on total bookings
     */
    public String getTravelerLevel() {
        if (totalBookings >= 20) {
            return "Platinum";
        } else if (totalBookings >= 10) {
            return "Gold";
        } else if (totalBookings >= 5) {
            return "Silver";
        } else {
            return "Bronze";
        }
    }
    
    /**
     * Calculate average rating given by this traveler
     */
    public double getAverageRatingGiven() {
        if (reviews == null || reviews.isEmpty()) {
            return 0.0;
        }
        
        double sum = 0;
        for (Review review : reviews) {
            sum += review.getRating();
        }
        return sum / reviews.size();
    }
    
    @Override
    public String toString() {
        return "Traveler{" +
                "userId=" + userId +
                ", totalBookings=" + totalBookings +
                ", preferences='" + preferences + '\'' +
                ", level='" + getTravelerLevel() + '\'' +
                '}';
    }
}
