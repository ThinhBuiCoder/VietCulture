package model;

import java.sql.Timestamp;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 * Lớp mô hình đại diện cho một trải nghiệm du lịch
 * Đã cập nhật với logic adminApprovalStatus mới
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
    private boolean isActive = true; // Host hiện/ẩn (1 = hiện, 0 = ẩn)
    private String images;
    private double averageRating;
    private int totalBookings;
    private int reportCount = 0;
    private boolean isDeleted = false;
    private String deleteReason;
    private Timestamp deletedAt;
    private boolean isFlagged = false;
    private String flagReason;
    private String firstImage;
    private String categoryName;

    // ===== TRƯỜNG MỚI CHO ADMIN APPROVAL =====
    private String adminApprovalStatus = "PENDING"; // PENDING, APPROVED, REJECTED
    private Integer adminApprovedBy; // User ID của admin duyệt
    private Date adminApprovedAt; // Thời gian duyệt
    private String adminRejectReason; // Lý do từ chối
    private String adminNotes; // Ghi chú của admin

    // Các trường bổ sung để hiển thị
    private String cityName;
    private String hostName;

    // Promotion fields
    private int promotionPercent;
    private java.sql.Timestamp promotionStart;
    private java.sql.Timestamp promotionEnd;

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
        this.isActive = true; // Host muốn hiện (mặc định)
        this.adminApprovalStatus = "PENDING"; // Chờ admin duyệt
        this.averageRating = 0.0;
        this.totalBookings = 0;
    }

    // ===== GETTERS VÀ SETTERS CHO ADMIN APPROVAL =====
    
    public String getAdminApprovalStatus() {
        return adminApprovalStatus;
    }
    
    public void setAdminApprovalStatus(String adminApprovalStatus) {
        this.adminApprovalStatus = adminApprovalStatus;
    }
    
    public Integer getAdminApprovedBy() {
        return adminApprovedBy;
    }
    
    public void setAdminApprovedBy(Integer adminApprovedBy) {
        this.adminApprovedBy = adminApprovedBy;
    }
    
    public Date getAdminApprovedAt() {
        return adminApprovedAt;
    }
    
    public void setAdminApprovedAt(Date adminApprovedAt) {
        this.adminApprovedAt = adminApprovedAt;
    }
    
    public String getAdminRejectReason() {
        return adminRejectReason;
    }
    
    public void setAdminRejectReason(String adminRejectReason) {
        this.adminRejectReason = adminRejectReason;
    }
    
    public String getAdminNotes() {
        return adminNotes;
    }
    
    public void setAdminNotes(String adminNotes) {
        this.adminNotes = adminNotes;
    }

    // ===== UTILITY METHODS =====
    
    /**
     * Kiểm tra có được hiển thị công khai không
     */
    public boolean isPubliclyVisible() {
        return "APPROVED".equals(adminApprovalStatus) && isActive;
    }
    
    /**
     * Kiểm tra admin đã duyệt chưa
     */
    public boolean isAdminApproved() {
        return "APPROVED".equals(adminApprovalStatus);
    }
    
    /**
     * Kiểm tra đang chờ admin duyệt
     */
    public boolean isPendingApproval() {
        return "PENDING".equals(adminApprovalStatus);
    }
    
    /**
     * Kiểm tra admin đã từ chối
     */
    public boolean isAdminRejected() {
        return "REJECTED".equals(adminApprovalStatus);
    }
    
    /**
     * Lấy trạng thái hiển thị chi tiết cho host
     */
    public String getDetailedStatus() {
        switch (adminApprovalStatus != null ? adminApprovalStatus : "PENDING") {
            case "PENDING":
                return "Chờ admin duyệt";
            case "APPROVED":
                return isActive ? "Đang hiển thị công khai" : "Đã ẩn bởi host";
            case "REJECTED":
                return "Bị admin từ chối" + (adminRejectReason != null ? " - " + adminRejectReason : "");
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Lấy CSS class cho trạng thái
     */
    public String getStatusCssClass() {
        switch (adminApprovalStatus != null ? adminApprovalStatus : "PENDING") {
            case "PENDING":
                return "badge-warning";
            case "APPROVED":
                return isActive ? "badge-success" : "badge-secondary";
            case "REJECTED":
                return "badge-danger";
            default:
                return "badge-light";
        }
    }
    
    /**
     * Kiểm tra host có thể chỉnh sửa không
     */
    public boolean canHostEdit() {
        // Host có thể chỉnh sửa khi đang pending hoặc bị reject
        return "PENDING".equals(adminApprovalStatus) || "REJECTED".equals(adminApprovalStatus);
    }
    
    /**
     * Kiểm tra host có thể ẩn/hiện không  
     */
    public boolean canHostToggleVisibility() {
        // Host chỉ có thể ẩn/hiện khi admin đã approve
        return "APPROVED".equals(adminApprovalStatus);
    }
    
    /**
     * Lấy thông tin admin duyệt (để hiển thị)
     */
    public String getApprovalInfo() {
        if ("APPROVED".equals(adminApprovalStatus) && adminApprovedAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            return "Đã duyệt lúc " + sdf.format(adminApprovedAt);
        }
        return null;
    }

    /**
     * Lấy trạng thái hiển thị ngắn gọn cho admin
     */
    public String getStatusForAdmin() {
        if (isDeleted) return "Đã xóa";
        if (isFlagged) return "Bị đánh dấu";
        if (reportCount > 0) return "Bị báo cáo";
        
        switch (adminApprovalStatus != null ? adminApprovalStatus : "PENDING") {
            case "PENDING":
                return "Chờ duyệt";
            case "APPROVED":
                return isActive ? "Hoạt động" : "Đã ẩn";
            case "REJECTED":
                return "Bị từ chối";
            default:
                return "Không xác định";
        }
    }

    // ===== GETTERS VÀ SETTERS CŨ =====

    public void setFirstImage(String firstImage) {
        this.firstImage = firstImage;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

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

    public boolean isReported() {
        return reportCount > 0;
    }

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
        return getDetailedStatus();
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
                ", adminApprovalStatus='" + adminApprovalStatus + '\'' +
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

    public void setCategoryId(int parseInt) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    // Promotion getters and setters
    public int getPromotionPercent() {
        return promotionPercent;
    }

    public void setPromotionPercent(int promotionPercent) {
        this.promotionPercent = promotionPercent;
    }

    public java.sql.Timestamp getPromotionStart() {
        return promotionStart;
    }

    public void setPromotionStart(java.sql.Timestamp promotionStart) {
        this.promotionStart = promotionStart;
    }

    public java.sql.Timestamp getPromotionEnd() {
        return promotionEnd;
    }

    public void setPromotionEnd(java.sql.Timestamp promotionEnd) {
        this.promotionEnd = promotionEnd;
    }
}