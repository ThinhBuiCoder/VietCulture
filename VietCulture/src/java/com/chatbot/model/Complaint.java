package com.chatbot.model;

import java.util.Date;

public class Complaint {
    private int complaintId;
    private int userId;
    private int bookingId;
    private String subject;
    private String description;
    private String evidence;
    private String status; // PENDING, IN_PROGRESS, RESOLVED, CLOSED
    private String resolution;
    private Date createdAt;
    private Date updatedAt;
    private Date resolvedAt;
    private int assignedAdminId;
    
    // Additional fields for display
    private String userName;
    private String assignedAdminName;
    private String bookingDetails;
    
    // Constructor
    public Complaint() {}
    
    // Getters and Setters
    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getEvidence() { return evidence; }
    public void setEvidence(String evidence) { this.evidence = evidence; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getResolution() { return resolution; }
    public void setResolution(String resolution) { this.resolution = resolution; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    public Date getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Date resolvedAt) { this.resolvedAt = resolvedAt; }
    
    public int getAssignedAdminId() { return assignedAdminId; }
    public void setAssignedAdminId(int assignedAdminId) { this.assignedAdminId = assignedAdminId; }
    
    // Display fields
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getAssignedAdminName() { return assignedAdminName; }
    public void setAssignedAdminName(String assignedAdminName) { this.assignedAdminName = assignedAdminName; }
    
    public String getBookingDetails() { return bookingDetails; }
    public void setBookingDetails(String bookingDetails) { this.bookingDetails = bookingDetails; }
    
    // Helper methods
    public String getDisplayStatus() {
        switch (status) {
            case "PENDING": return "Chờ xử lý";
            case "IN_PROGRESS": return "Đang xử lý";
            case "RESOLVED": return "Đã giải quyết";
            case "CLOSED": return "Đã đóng";
            default: return status;
        }
    }
    
    public String getPriorityLevel() {
        // Simple priority based on keywords in subject/description
        String content = (subject + " " + description).toLowerCase();
        if (content.contains("khẩn cấp") || content.contains("urgent") || content.contains("gấp")) {
            return "Cao";
        } else if (content.contains("quan trọng") || content.contains("important")) {
            return "Trung bình";
        }
        return "Thấp";
    }
    
    public boolean isPending() { return "PENDING".equals(status); }
    public boolean isInProgress() { return "IN_PROGRESS".equals(status); }
    public boolean isResolved() { return "RESOLVED".equals(status); }
    public boolean isClosed() { return "CLOSED".equals(status); }
}