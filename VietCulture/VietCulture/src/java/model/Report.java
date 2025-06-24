package model;

import java.sql.Timestamp;

/**
 * Lớp mô hình đại diện cho một báo cáo vi phạm trong hệ thống
 */
public class Report {
    private int reportId;
    private String contentType; // 'experience', 'accommodation', 'review'
    private int contentId;
    private int reporterId;
    private String reason;
    private String description;
    private Timestamp createdAt;
    private String status; // PENDING, RESOLVED, DISMISSED
    private String reporterName; // Trường hiển thị từ JOIN với Users

    // Constructor mặc định
    public Report() {}

    // Constructor với các trường cơ bản
    public Report(String contentType, int contentId, int reporterId, String reason, String description) {
        this.contentType = contentType;
        this.contentId = contentId;
        this.reporterId = reporterId;
        this.reason = reason;
        this.description = description;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.status = "PENDING";
    }

    // Getters và Setters
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public int getContentId() {
        return contentId;
    }

    public void setContentId(int contentId) {
        this.contentId = contentId;
    }

    public int getReporterId() {
        return reporterId;
    }

    public void setReporterId(int reporterId) {
        this.reporterId = reporterId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReporterName() {
        return reporterName;
    }

    public void setReporterName(String reporterName) {
        this.reporterName = reporterName;
    }

    // Phương thức hỗ trợ
    /**
     * Lấy trạng thái báo cáo bằng tiếng Việt
     */
    public String getStatusText() {
        switch (status != null ? status : "") {
            case "PENDING": return "Đang chờ xử lý";
            case "RESOLVED": return "Đã xử lý";
            case "DISMISSED": return "Đã bác bỏ";
            default: return status != null ? status : "Không xác định";
        }
    }

    /**
     * Lấy loại nội dung bằng tiếng Việt
     */
    public String getContentTypeText() {
        switch (contentType != null ? contentType.toLowerCase() : "") {
            case "experience": return "Trải nghiệm";
            case "accommodation": return "Lưu trú";
            case "review": return "Đánh giá";
            default: return contentType != null ? contentType : "Không xác định";
        }
    }

    /**
     * Lấy mô tả ngắn để hiển thị
     */
    public String getShortDescription(int maxLength) {
        if (description == null || description.trim().isEmpty()) {
            return "";
        }
        if (description.length() <= maxLength) {
            return description;
        }
        return description.substring(0, maxLength) + "...";
    }

    @Override
    public String toString() {
        return "Report{" +
                "reportId=" + reportId +
                ", contentType='" + contentType + '\'' +
                ", contentId=" + contentId +
                ", reporterName='" + (reporterName != null ? reporterName : "") + '\'' +
                ", reason='" + (reason != null ? reason : "") + '\'' +
                ", status='" + getStatusText() + '\'' +
                '}';
    }
}