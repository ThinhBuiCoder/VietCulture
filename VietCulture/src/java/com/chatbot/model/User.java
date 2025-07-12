package com.chatbot.model;

import java.util.Date;

public class User {
    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String role; // TRAVELER, HOST, ADMIN
    private String profileImage;
    private Date createdAt;
    private Date updatedAt;
    private boolean isActive;
    private String status;
    private String preferences;
    
    // Constructor
    public User() {}
    
    public User(int userId, String fullName, String email, String role) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
    }
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPreferences() { return preferences; }
    public void setPreferences(String preferences) { this.preferences = preferences; }
    public String[] getPreferenceList() {
        if (preferences == null || preferences.trim().isEmpty()) return new String[0];
        return preferences.split(",");
    }
    
    // Helper methods
    public boolean isTraveler() { return "TRAVELER".equals(role); }
    public boolean isHost() { return "HOST".equals(role); }
    public boolean isAdmin() { return "ADMIN".equals(role); }
    
    public String getDisplayRole() {
        switch (role) {
            case "TRAVELER": return "Du khách";
            case "HOST": return "Host";
            case "ADMIN": return "Quản trị viên";
            default: return role;
        }
    }
}