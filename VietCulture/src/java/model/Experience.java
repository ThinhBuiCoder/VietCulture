package model;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Lớp mô hình đại diện cho một trải nghiệm du lịch
 */
public class Experience {
    private int experienceId;
    private int hostId;
    private String title;
    private String description;
    private String location;
    private int cityId;
    private String type;
    private double price;
    private int maxGroupSize;
    private Date duration;
    private String difficulty;
    private String language;
    private String includedItems;
    private String requirements;
    private Date createdAt;
    private boolean isActive;
    private String images;
    private double averageRating;
    private int totalBookings;
    private int reportCount = 0;
    private boolean isDeleted = false;
    private String deleteReason;
    private Timestamp deletedAt;
    private boolean isFlagged = false;
    private String flagReason;

    // Các trường bổ sung để hiển thị
    private String cityName;
    private String hostName;

    // Constructor mặc định
    public Experience() {}

    // Constructor với các trường bắt buộc
    public Experience(int hostId, String title, String description, String location, 
                     int cityId, String type, double price, int maxGroupSize, 
                     Date duration, String difficulty, String language) {
        this.hostId = hostId;
        this.title = title;
        this.description = description;
        this.location = location;
        this.cityId = cityId;
        this.type = type;
        this.price = price;
        this.maxGroupSize = maxGroupSize;
        this.duration = duration;
        this.difficulty = difficulty;
        this.language = language;
        this.isActive = false; // Mặc định chưa được duyệt
        this.averageRating = 0.0;
        this.totalBookings = 0;
    }

    // Getters và Setters cho các trường liên quan đến báo cáo và xóa
    public int getReportCount() {
        return reportCount;
    }

    public void setReportCount(int reportCount) {
        this.reportCount = reportCount;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        this.isDeleted = deleted;
    }

    public String getDeleteReason() {
        return deleteReason;
    }

    public void setDeleteReason(String deleteReason) {
        this.deleteReason = deleteReason;
    }

    public Timestamp getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Timestamp deletedAt) {
        this.deletedAt = deletedAt;
    }

    public boolean isFlagged() {
        return isFlagged;
    }

    public void setFlagged(boolean flagged) {
        this.isFlagged = flagged;
    }

    public String getFlagReason() {
        return flagReason;
    }

    public void setFlagReason(String flagReason) {
        this.flagReason = flagReason;
    }

    // Các phương thức hỗ trợ
    public boolean isReported() {
        return reportCount > 0;
    }

    public String getStatusForAdmin() {
        if (isDeleted) return "Đã xóa";
        if (isFlagged) return "Bị đánh dấu";
        if (reportCount > 0) return "Bị báo cáo";
        if (!isActive) return "Chờ duyệt";
        return "Hoạt động";
    }

    // Getters và Setters cho các trường khác
    public int getExperienceId() {
        return experienceId;
    }

    public void setExperienceId(int experienceId) {
        this.experienceId = experienceId;
    }

    public int getHostId() {
        return hostId;
    }

    public void setHostId(int hostId) {
        this.hostId = hostId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getMaxGroupSize() {
        return maxGroupSize;
    }

    public void setMaxGroupSize(int maxGroupSize) {
        this.maxGroupSize = maxGroupSize;
    }

    public Date getDuration() {
        return duration;
    }

    public void setDuration(Date duration) {
        this.duration = duration;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getIncludedItems() {
        return includedItems;
    }

    public void setIncludedItems(String includedItems) {
        this.includedItems = includedItems;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
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
        this.isActive = active;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    // Các phương thức hỗ trợ hiển thị văn bản
    public String getDifficultyText() {
        switch (difficulty != null ? difficulty : "") {
            case "EASY":
                return "Dễ";
            case "MODERATE":
                return "Trung bình";
            case "CHALLENGING":
                return "Khó";
            default:
                return difficulty != null ? difficulty : "";
        }
    }

    public String getTypeText() {
        switch (type != null ? type : "") {
            case "Food":
                return "Ẩm thực";
            case "Culture":
                return "Văn hóa";
            case "Adventure":
                return "Phiêu lưu";
            case "History":
                return "Lịch sử";
            default:
                return type != null ? type : "";
        }
    }

    public String getStatusText() {
        return isActive ? "Đang hoạt động" : "Chờ duyệt";
    }

    public String[] getImageList() {
        if (images == null || images.trim().isEmpty()) {
            return new String[0];
        }
        return images.split(",");
    }

    public String getFirstImage() {
        String[] imageList = getImageList();
        return imageList.length > 0 ? imageList[0].trim() : null;
    }

    public boolean hasImages() {
        return images != null && !images.trim().isEmpty();
    }

    @Override
    public String toString() {
        return "Experience{" +
                "experienceId=" + experienceId +
                ", hostId=" + hostId +
                ", title='" + title + '\'' +
                ", location='" + location + '\'' +
                ", type='" + type + '\'' +
                ", price=" + price +
                ", maxGroupSize=" + maxGroupSize +
                ", difficulty='" + difficulty + '\'' +
                ", isActive=" + isActive +
                ", averageRating=" + averageRating +
                ", totalBookings=" + totalBookings +
                '}';
    }

    public void setHost(User host) {
        this.hostId = host.getUserId();
        this.hostName = host.getFullName();
    }

    public void setCity(City city) {
        this.cityId = city.getCityId();
        this.cityName = city.getVietnameseName();
    }
}