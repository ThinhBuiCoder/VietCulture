package model;

import java.util.Date;

public class Complaint {
    private int complaintId;
    private int userId;
    private Integer relatedBookingId;
    private String complaintText;
    private String status; // OPEN, IN_PROGRESS, RESOLVED, CLOSED
    private String resolution;
    private Date createdAt;
    private Date resolvedAt;
    private int assignedAdminId;
    
    // Additional fields for display
    private String userName;
    private String userEmail;
    private String assignedAdminName;
    private String bookingDetails;
    private String relatedContentTitle;
    
    // Constructor
    public Complaint() {
        this.status = "OPEN";
        this.createdAt = new Date();
    }
    
    public Complaint(int userId, Integer relatedBookingId, String complaintText) {
        this();
        this.userId = userId;
        this.relatedBookingId = relatedBookingId;
        this.complaintText = complaintText;
    }
    
    // Getters and Setters
    public int getComplaintId() {
        return complaintId;
    }
    
    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Integer getRelatedBookingId() {
        return relatedBookingId;
    }
    
    public void setRelatedBookingId(Integer relatedBookingId) {
        this.relatedBookingId = relatedBookingId;
    }
    
    public String getComplaintText() {
        return complaintText;
    }
    
    public void setComplaintText(String complaintText) {
        this.complaintText = complaintText;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getResolution() {
        return resolution;
    }
    
    public void setResolution(String resolution) {
        this.resolution = resolution;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getResolvedAt() {
        return resolvedAt;
    }
    
    public void setResolvedAt(Date resolvedAt) {
        this.resolvedAt = resolvedAt;
    }
    
    public int getAssignedAdminId() {
        return assignedAdminId;
    }
    
    public void setAssignedAdminId(int assignedAdminId) {
        this.assignedAdminId = assignedAdminId;
    }
    
    // Display fields
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public String getAssignedAdminName() {
        return assignedAdminName;
    }
    
    public void setAssignedAdminName(String assignedAdminName) {
        this.assignedAdminName = assignedAdminName;
    }
    
    public String getBookingDetails() {
        return bookingDetails;
    }
    
    public void setBookingDetails(String bookingDetails) {
        this.bookingDetails = bookingDetails;
    }
    
    public String getRelatedContentTitle() {
        return relatedContentTitle;
    }
    
    public void setRelatedContentTitle(String relatedContentTitle) {
        this.relatedContentTitle = relatedContentTitle;
    }
    
    // Helper methods
    public String getDisplayStatus() {
        switch (status) {
            case "OPEN": return "Chờ xử lý";
            case "IN_PROGRESS": return "Đang xử lý";
            case "RESOLVED": return "Đã giải quyết";
            case "CLOSED": return "Đã đóng";
            default: return status;
        }
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case "OPEN": return "badge bg-warning";
            case "IN_PROGRESS": return "badge bg-info";
            case "RESOLVED": return "badge bg-success";
            case "CLOSED": return "badge bg-secondary";
            default: return "badge bg-light text-dark";
        }
    }
    
    public String getPriorityLevel() {
        // Simple priority based on keywords in complaint text
        String content = complaintText.toLowerCase();
        if (content.contains("khẩn cấp") || content.contains("urgent") || content.contains("gấp")) {
            return "Cao";
        } else if (content.contains("quan trọng") || content.contains("important")) {
            return "Trung bình";
        }
        return "Thấp";
    }
    
    public String getPriorityBadgeClass() {
        String priority = getPriorityLevel();
        switch (priority) {
            case "Cao": return "badge bg-danger";
            case "Trung bình": return "badge bg-warning";
            case "Thấp": return "badge bg-success";
            default: return "badge bg-light text-dark";
        }
    }
    
    public boolean isOpen() {
        return "OPEN".equals(status);
    }
    
    public boolean isInProgress() {
        return "IN_PROGRESS".equals(status);
    }
    
    public boolean isResolved() {
        return "RESOLVED".equals(status);
    }
    
    public boolean isClosed() {
        return "CLOSED".equals(status);
    }
    
    public boolean isAssigned() {
        return assignedAdminId > 0;
    }
    
    public String getTimeSinceCreated() {
        if (createdAt == null) return "";
        
        long diffInMillis = System.currentTimeMillis() - createdAt.getTime();
        long diffInHours = diffInMillis / (60 * 60 * 1000);
        long diffInDays = diffInHours / 24;
        
        if (diffInDays > 0) {
            return diffInDays + " ngày trước";
        } else if (diffInHours > 0) {
            return diffInHours + " giờ trước";
        } else {
            long diffInMinutes = diffInMillis / (60 * 1000);
            return diffInMinutes + " phút trước";
        }
    }
    
    public String getShortComplaintText() {
        if (complaintText == null) return "";
        if (complaintText.length() <= 100) return complaintText;
        return complaintText.substring(0, 97) + "...";
    }
    
    @Override
    public String toString() {
        return "Complaint{" +
                "complaintId=" + complaintId +
                ", userId=" + userId +
                ", relatedBookingId=" + relatedBookingId +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
} 