package model;

public class Host {
    private int userId;
    private String businessName;
    private String businessType;
    private String businessAddress;
    private String businessDescription;
    private String taxId;
    private String skills;
    private String region;
    private double averageRating;
    private int totalExperiences;
    private double totalRevenue;
    
    // Additional fields from User table
    private String fullName;
    private String email;
    private String phone;
    private String avatar;
    
    // Constructors
    public Host() {}
    
    public Host(int userId, String businessName, String businessType, 
                String businessAddress, String businessDescription, 
                String taxId, String skills, String region) {
        this.userId = userId;
        this.businessName = businessName;
        this.businessType = businessType;
        this.businessAddress = businessAddress;
        this.businessDescription = businessDescription;
        this.taxId = taxId;
        this.skills = skills;
        this.region = region;
        this.averageRating = 0.0;
        this.totalExperiences = 0;
        this.totalRevenue = 0.0;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
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
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAvatar() {
        return avatar;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    
    // Helper methods
    public String getBusinessTypeText() {
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
        if (skills == null || skills.trim().isEmpty()) {
            return new String[0];
        }
        return skills.split(",");
    }
    
    public boolean hasSkills() {
        return skills != null && !skills.trim().isEmpty();
    }
    
    public String getFormattedRevenue() {
        if (totalRevenue >= 1_000_000) {
            return String.format("%.1fM VNĐ", totalRevenue / 1_000_000);
        } else if (totalRevenue >= 1_000) {
            return String.format("%.0fK VNĐ", totalRevenue / 1_000);
        } else {
            return String.format("%.0f VNĐ", totalRevenue);
        }
    }
    
    public String getRatingText() {
        if (averageRating == 0) {
            return "Chưa có đánh giá";
        }
        return String.format("%.1f/5", averageRating);
    }
    
    public boolean isNewHost() {
        return totalExperiences == 0 && averageRating == 0;
    }
    
    public boolean isTopRated() {
        return averageRating >= 4.5 && totalExperiences >= 5;
    }
    
    @Override
    public String toString() {
        return "Host{" +
                "userId=" + userId +
                ", businessName='" + businessName + '\'' +
                ", businessType='" + businessType + '\'' +
                ", region='" + region + '\'' +
                ", averageRating=" + averageRating +
                ", totalExperiences=" + totalExperiences +
                ", totalRevenue=" + totalRevenue +
                ", fullName='" + fullName + '\'' +
                '}';
    }
}