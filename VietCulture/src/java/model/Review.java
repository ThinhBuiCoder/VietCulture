package model;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Lớp mô hình đại diện cho một đánh giá (review) trong hệ thống
 */
public class Review {

    private int reviewId;
    private Integer experienceId; // Nullable, liên kết với trải nghiệm
    private Integer accommodationId; // Nullable, liên kết với chỗ ở
    private int travelerId;
    private int rating; // Điểm đánh giá từ 1-5
    private String comment;
    private String photos; // Danh sách URL ảnh, phân tách bằng dấu phẩy
    private Date createdAt;
    private boolean isVisible;
    private int reportCount = 0; // Số lần bị báo cáo
    private boolean isFlagged = false; // Trạng thái bị đánh dấu
    private boolean isDeleted = false; // Trạng thái bị xóa mềm
    private String deleteReason; // Lý do xóa
    private Timestamp deletedAt; // Thời gian xóa

    // Các đối tượng liên quan
    private Experience experience;
    private Accommodation accommodation;
    private User traveler;

    // Các trường hiển thị (lấy từ truy vấn JOIN)
    private String travelerName;
    private String travelerAvatar;
    private String experienceName;
    private String accommodationName;

    // Constructor mặc định
    public Review() {
    }

    // Constructor với các trường cơ bản
    public Review(int travelerId, int rating, String comment) {
        this.travelerId = travelerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = new Date();
        this.isVisible = true;
    }

    // Getters và Setters
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

    public void setVisible(boolean isVisible) {
        this.isVisible = isVisible;
    }

    public int getReportCount() {
        return reportCount;
    }

    public void setReportCount(int reportCount) {
        this.reportCount = reportCount;
    }

    public boolean isFlagged() {
        return isFlagged;
    }

    public void setFlagged(boolean isFlagged) {
        this.isFlagged = isFlagged;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
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

    public Experience getExperience() {
        return experience;
    }

    public void setExperience(Experience experience) {
        this.experience = experience;
        if (experience != null) {
            this.experienceId = experience.getExperienceId();
            this.experienceName = experience.getTitle();
        }
    }

    public Accommodation getAccommodation() {
        return accommodation;
    }

    public void setAccommodation(Accommodation accommodation) {
        this.accommodation = accommodation;
        if (accommodation != null) {
            this.accommodationId = accommodation.getAccommodationId();
            this.accommodationName = accommodation.getName();
        }
    }

    public User getTraveler() {
        return traveler;
    }

    public void setTraveler(User traveler) {
        this.traveler = traveler;
        if (traveler != null) {
            this.travelerId = traveler.getUserId();
            this.travelerName = traveler.getFullName();
            this.travelerAvatar = traveler.getAvatar();
        }
    }

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

    // Các phương thức hỗ trợ
    /**
     * Kiểm tra xem review có bị báo cáo hay không
     */
    public boolean isReported() {
        return reportCount > 0;
    }

    /**
     * Lấy trạng thái review cho admin
     */
    public String getStatusForAdmin() {
        if (isDeleted) {
            return "Đã xóa";
        }
        if (isFlagged) {
            return "Bị đánh dấu";
        }
        if (reportCount > 0) {
            return "Bị báo cáo";
        }
        if (!isVisible) {
            return "Chờ duyệt";
        }
        return "Hiển thị";
    }

    /**
     * Lấy loại review (Experience hoặc Accommodation)
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
     * Lấy loại review bằng tiếng Việt
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
     * Lấy tên mục được đánh giá (tên trải nghiệm hoặc chỗ ở)
     */
    public String getReviewItemName() {
        if (experienceName != null) {
            return experienceName;
        } else if (accommodationName != null) {
            return accommodationName;
        }
        return "Mục không xác định";
    }

    /**
     * Lấy biểu tượng ngôi sao cho điểm đánh giá
     */
    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            stars.append(i <= rating ? "★" : "☆");
        }
        return stars.toString();
    }

    /**
     * Lấy mô tả văn bản cho điểm đánh giá
     */
    public String getRatingText() {
        switch (rating) {
            case 5:
                return "Xuất sắc";
            case 4:
                return "Tốt";
            case 3:
                return "Trung bình";
            case 2:
                return "Kém";
            case 1:
                return "Rất kém";
            default:
                return "Chưa đánh giá";
        }
    }

    /**
     * Lấy danh sách URL ảnh
     */
    public String[] getPhotoList() {
        if (photos == null || photos.trim().isEmpty()) {
            return new String[0];
        }
        return photos.split(",");
    }

    /**
     * Kiểm tra xem review có ảnh hay không
     */
    public boolean hasPhotos() {
        return photos != null && !photos.trim().isEmpty();
    }

    /**
     * Lấy bình luận ngắn để hiển thị xem trước
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
     * Kiểm tra xem review có phải cho trải nghiệm
     */
    public boolean isExperienceReview() {
        return experienceId != null;
    }

    /**
     * Kiểm tra xem review có phải cho chỗ ở
     */
    public boolean isAccommodationReview() {
        return accommodationId != null;
    }

    /**
     * Lấy lớp CSS cho màu sắc của điểm đánh giá
     */
    public String getRatingColorClass() {
        if (rating >= 4) {
            return "text-success"; // Xanh cho đánh giá tốt
        } else if (rating == 3) {
            return "text-warning"; // Vàng cho đánh giá trung bình
        } else {
            return "text-danger"; // Đỏ cho đánh giá kém
        }
    }

    @Override
    public String toString() {
        return "Review{"
                + "reviewId=" + reviewId
                + ", rating=" + rating
                + ", comment='" + (comment != null ? getShortComment(50) : "") + '\''
                + ", experienceId=" + experienceId
                + ", accommodationId=" + accommodationId
                + ", travelerName='" + (travelerName != null ? travelerName : "") + '\''
                + ", reviewType='" + getReviewTypeText() + '\''
                + ", isVisible=" + isVisible
                + ", isDeleted=" + isDeleted
                + '}';
    }
}
