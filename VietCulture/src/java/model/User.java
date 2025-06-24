package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class User {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    private int userId;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private Date dateOfBirth;
    private String gender;
    private String avatar;
    private String bio;
    private Date createdAt;
    private boolean isActive;
    private String role; // TRAVELER, HOST, ADMIN
    private String preferences; // For TRAVELER role (JSON string)
    private int totalBookings; // For TRAVELER role
    private String businessName; // For HOST role
    private String businessType; // For HOST role
    private String businessAddress; // For HOST role
    private String businessDescription; // For HOST role
    private String taxId; // For HOST role
    private String skills; // For HOST role
    private String region; // For HOST role
    private double averageRating; // For HOST role
    private int totalExperiences; // For HOST role
    private double totalRevenue; // For HOST role
    private String permissions; // For ADMIN role
    private boolean emailVerified;
    private String verificationToken;
    private Date tokenExpiry;

    // Related objects
    private List<Booking> bookings; // For TRAVELER role
    private List<Review> reviews; // For TRAVELER role
    private List<AdminAction> adminActions; // For ADMIN role
    private List<Experience> experiences; // For HOST role
    private List<Accommodation> accommodations; // For HOST role

    // Constructors
    public User() {
        this.bookings = new ArrayList<>();
        this.reviews = new ArrayList<>();
        this.adminActions = new ArrayList<>();
        this.experiences = new ArrayList<>();
        this.accommodations = new ArrayList<>();
        this.isActive = true;
        this.totalBookings = 0;
        this.averageRating = 0.0;
        this.totalExperiences = 0;
        this.totalRevenue = 0.0;
        this.emailVerified = false;
    }

    public User(int userId, String email, String role) {
        this();
        this.userId = userId;
        this.email = email;
        this.role = role;
    }

    // Getters and Setters
<<<<<<< HEAD
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
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

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getBusinessAddress() {
        return businessAddress;
    }

    public void setBusinessAddress(String businessAddress) {
        this.businessAddress = businessAddress;
    }

    public String getBusinessDescription() {
        return businessDescription;
    }

    public void setBusinessDescription(String businessDescription) {
        this.businessDescription = businessDescription;
    }

    public String getTaxId() {
        return taxId;
    }

    public void setTaxId(String taxId) {
        this.taxId = taxId;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getTotalExperiences() {
        return totalExperiences;
    }

    public void setTotalExperiences(int totalExperiences) {
        this.totalExperiences = totalExperiences;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public String getPermissions() {
        return permissions;
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public Date getTokenExpiry() {
        return tokenExpiry;
    }

    public void setTokenExpiry(Date tokenExpiry) {
        this.tokenExpiry = tokenExpiry;
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

    public List<AdminAction> getAdminActions() {
        return adminActions;
    }

    public void setAdminActions(List<AdminAction> adminActions) {
        this.adminActions = adminActions;
    }

    public List<Experience> getExperiences() {
        return experiences;
    }

    public void setExperiences(List<Experience> experiences) {
        this.experiences = experiences;
    }

    public List<Accommodation> getAccommodations() {
        return accommodations;
    }

    public void setAccommodations(List<Accommodation> accommodations) {
        this.accommodations = accommodations;
    }
=======
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getPreferences() { return preferences; }
    public void setPreferences(String preferences) { this.preferences = preferences; }

    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getBusinessType() { return businessType; }
    public void setBusinessType(String businessType) { this.businessType = businessType; }

    public String getBusinessAddress() { return businessAddress; }
    public void setBusinessAddress(String businessAddress) { this.businessAddress = businessAddress; }

    public String getBusinessDescription() { return businessDescription; }
    public void setBusinessDescription(String businessDescription) { this.businessDescription = businessDescription; }

    public String getTaxId() { return taxId; }
    public void setTaxId(String taxId) { this.taxId = taxId; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }

    public int getTotalExperiences() { return totalExperiences; }
    public void setTotalExperiences(int totalExperiences) { this.totalExperiences = totalExperiences; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public String getPermissions() { return permissions; }
    public void setPermissions(String permissions) { this.permissions = permissions; }

    public boolean isEmailVerified() { return emailVerified; }
    public void setEmailVerified(boolean emailVerified) { this.emailVerified = emailVerified; }

    public String getVerificationToken() { return verificationToken; }
    public void setVerificationToken(String verificationToken) { this.verificationToken = verificationToken; }

    public Date getTokenExpiry() { return tokenExpiry; }
    public void setTokenExpiry(Date tokenExpiry) { this.tokenExpiry = tokenExpiry; }

    public List<Booking> getBookings() { return bookings; }
    public void setBookings(List<Booking> bookings) { this.bookings = bookings; }

    public List<Review> getReviews() { return reviews; }
    public void setReviews(List<Review> reviews) { this.reviews = reviews; }

    public List<AdminAction> getAdminActions() { return adminActions; }
    public void setAdminActions(List<AdminAction> adminActions) { this.adminActions = adminActions; }

    public List<Experience> getExperiences() { return experiences; }
    public void setExperiences(List<Experience> experiences) { this.experiences = experiences; }

    public List<Accommodation> getAccommodations() { return accommodations; }
    public void setAccommodations(List<Accommodation> accommodations) { this.accommodations = accommodations; }
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b

    // Helper methods for TRAVELER role
    public void addBooking(Booking booking) {
        if ("TRAVELER".equals(role)) {
            if (this.bookings == null) {
                this.bookings = new ArrayList<>();
            }
            this.bookings.add(booking);
            this.totalBookings = this.bookings.size();
        }
    }

    public void addReview(Review review) {
        if ("TRAVELER".equals(role)) {
            if (this.reviews == null) {
                this.reviews = new ArrayList<>();
            }
            this.reviews.add(review);
        }
    }

    public String[] getPreferenceList() {
        if (!"TRAVELER".equals(role) || preferences == null || preferences.trim().isEmpty()) {
            return new String[0];
        }
        return preferences.split(",");
    }

    public boolean hasPreference(String preference) {
        if (!"TRAVELER".equals(role) || preferences == null || preferences.trim().isEmpty()) {
            return false;
        }
        return preferences.toLowerCase().contains(preference.toLowerCase());
    }

    public String getTravelerLevel() {
        if (!"TRAVELER".equals(role)) {
            return "N/A";
        }
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

    public double getAverageRatingGiven() {
        if (!"TRAVELER".equals(role) || reviews == null || reviews.isEmpty()) {
            return 0.0;
        }
        double sum = 0;
        for (Review review : reviews) {
            sum += review.getRating();
        }
        return sum / reviews.size();
    }

    // Helper methods for HOST role
    public String getBusinessTypeText() {
        if (!"HOST".equals(role) || businessType == null) {
            return "";
        }
        switch (businessType) {
            case "Travel":
                return "Công ty du lịch";
            case "Homestay":
                return "Homestay";
            case "Hotel":
                return "Khách sạn";
            case "Restaurant":
                return "Nhà hàng";
            case "Tour Guide":
                return "Hướng dẫn viên";
            default:
                return businessType;
        }
    }

    public String getRegionText() {
        if (!"HOST".equals(role) || region == null) {
            return "";
        }
        switch (region) {
            case "North":
                return "Miền Bắc";
            case "Central":
                return "Miền Trung";
            case "South":
                return "Miền Nam";
            default:
                return region;
        }
    }

    public String[] getSkillList() {
        if (!"HOST".equals(role) || skills == null || skills.trim().isEmpty()) {
            return new String[0];
        }
        return skills.split(",");
    }

    public boolean hasSkills() {
        return "HOST".equals(role) && skills != null && !skills.trim().isEmpty();
    }

    public String getFormattedRevenue() {
        if (!"HOST".equals(role)) {
            return "0 VNĐ";
        }
        if (totalRevenue >= 1_000_000) {
            return String.format("%.1fM VNĐ", totalRevenue / 1_000_000);
        } else if (totalRevenue >= 1_000) {
            return String.format("%.0fK VNĐ", totalRevenue / 1_000);
        } else {
            return String.format("%.0f VNĐ", totalRevenue);
        }
    }

    public String getRatingText() {
        if (!"HOST".equals(role) || averageRating == 0) {
            return "Chưa có đánh giá";
        }
        return String.format("%.1f/5", averageRating);
    }

    public boolean isNewHost() {
        return "HOST".equals(role) && totalExperiences == 0 && averageRating == 0;
    }

    public boolean isTopRated() {
        return "HOST".equals(role) && averageRating >= 4.5 && totalExperiences >= 5;
    }

    public void addExperience(Experience experience) {
        if ("HOST".equals(role)) {
            if (this.experiences == null) {
                this.experiences = new ArrayList<>();
            }
            this.experiences.add(experience);
            this.totalExperiences = this.experiences.size();
        }
    }

    public void addAccommodation(Accommodation accommodation) {
        if ("HOST".equals(role)) {
            if (this.accommodations == null) {
                this.accommodations = new ArrayList<>();
            }
            this.accommodations.add(accommodation);
        }
    }

    // Helper methods for ADMIN role
    public boolean hasPermission(String permission) {
        if (!"ADMIN".equals(role)) {
            return false;
        }
        if ("SUPER_ADMIN".equals(permissions)) {
            return true;
        }
        if (permissions == null || permissions.trim().isEmpty()) {
            return false;
        }
        return permissions.toLowerCase().contains(permission.toLowerCase());
    }

    public String getRoleText() {
        if (!"ADMIN".equals(role)) {
            return "";
        }
        switch (permissions) {
            case "SUPER_ADMIN":
                return "Quản trị viên cấp cao";
            case "ADMIN":
                return "Quản trị viên";
            case "MODERATOR":
                return "Điều hành viên";
            default:
                return permissions;
        }
    }

    public boolean isSuperAdmin() {
        return "ADMIN".equals(role) && "SUPER_ADMIN".equals(permissions);
    }

    public boolean canManageUsers() {
        return "ADMIN".equals(role) && (isSuperAdmin() || hasPermission("manage_users"));
    }

    public boolean canApproveContent() {
        return "ADMIN".equals(role) && (isSuperAdmin() || hasPermission("approve_content"));
    }

    public boolean canViewStatistics() {
        return "ADMIN".equals(role) && (isSuperAdmin() || hasPermission("view_statistics"));
    }

    public boolean canManageSettings() {
        return "ADMIN".equals(role) && (isSuperAdmin() || hasPermission("manage_settings"));
    }

    public void addAdminAction(AdminAction action) {
        if ("ADMIN".equals(role)) {
            if (this.adminActions == null) {
                this.adminActions = new ArrayList<>();
            }
            this.adminActions.add(action);
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("User{")
<<<<<<< HEAD
                .append("userId=").append(userId)
                .append(", email='").append(email).append('\'')
                .append(", fullName='").append(fullName).append('\'')
                .append(", role='").append(role).append('\'');

        if ("TRAVELER".equals(role)) {
            sb.append(", totalBookings=").append(totalBookings)
                    .append(", preferences='").append(preferences).append('\'')
                    .append(", level='").append(getTravelerLevel()).append('\'');
        } else if ("HOST".equals(role)) {
            sb.append(", businessName='").append(businessName).append('\'')
                    .append(", businessType='").append(businessType).append('\'')
                    .append(", region='").append(region).append('\'')
                    .append(", averageRating=").append(averageRating)
                    .append(", totalExperiences=").append(totalExperiences)
                    .append(", totalRevenue=").append(totalRevenue);
=======
          .append("userId=").append(userId)
          .append(", email='").append(email).append('\'')
          .append(", fullName='").append(fullName).append('\'')
          .append(", role='").append(role).append('\'');
        
        if ("TRAVELER".equals(role)) {
            sb.append(", totalBookings=").append(totalBookings)
              .append(", preferences='").append(preferences).append('\'')
              .append(", level='").append(getTravelerLevel()).append('\'');
        } else if ("HOST".equals(role)) {
            sb.append(", businessName='").append(businessName).append('\'')
              .append(", businessType='").append(businessType).append('\'')
              .append(", region='").append(region).append('\'')
              .append(", averageRating=").append(averageRating)
              .append(", totalExperiences=").append(totalExperiences)
              .append(", totalRevenue=").append(totalRevenue);
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        } else if ("ADMIN".equals(role)) {
            sb.append(", permissions='").append(permissions).append('\'');
        }
        sb.append('}');
        return sb.toString();
    }

    public boolean isAdmin() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // Inner class for admin actions
    public static class AdminAction {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        private String action;
        private String description;
        private String targetType; // USER, EXPERIENCE, ACCOMMODATION, etc.
        private int targetId;
        private Date timestamp;

        public AdminAction() {
            this.timestamp = new Date();
        }

        public AdminAction(String action, String description, String targetType, int targetId) {
            this();
            this.action = action;
            this.description = description;
            this.targetType = targetType;
            this.targetId = targetId;
        }

        // Getters and setters
<<<<<<< HEAD
        public String getAction() {
            return action;
        }

        public void setAction(String action) {
            this.action = action;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getTargetType() {
            return targetType;
        }

        public void setTargetType(String targetType) {
            this.targetType = targetType;
        }

        public int getTargetId() {
            return targetId;
        }

        public void setTargetId(int targetId) {
            this.targetId = targetId;
        }

        public Date getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(Date timestamp) {
            this.timestamp = timestamp;
        }
    }
}
=======
        public String getAction() { return action; }
        public void setAction(String action) { this.action = action; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public String getTargetType() { return targetType; }
        public void setTargetType(String targetType) { this.targetType = targetType; }

        public int getTargetId() { return targetId; }
        public void setTargetId(int targetId) { this.targetId = targetId; }

        public Date getTimestamp() { return timestamp; }
        public void setTimestamp(Date timestamp) { this.timestamp = timestamp; }
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
