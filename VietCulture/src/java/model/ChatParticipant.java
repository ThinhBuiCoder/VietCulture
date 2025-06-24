package model;

import java.util.Date;

public class ChatParticipant {
    private int participantId;
    private int chatRoomId;
    private int userId;
    private String role;
    private Date joinedAt;
    private Date leftAt;
    private Date lastSeenAt;
    private boolean notificationEnabled;
    
    // User info
    private String userName;
    private String userAvatar;
    private String userEmail;
    
    // Constructors
    public ChatParticipant() {}
    
    public ChatParticipant(int chatRoomId, int userId) {
        this.chatRoomId = chatRoomId;
        this.userId = userId;
        this.role = "MEMBER";
        this.joinedAt = new Date();
        this.notificationEnabled = true;
    }
    
    // Getters and Setters
    public int getParticipantId() { return participantId; }
    public void setParticipantId(int participantId) { this.participantId = participantId; }
    
    public int getChatRoomId() { return chatRoomId; }
    public void setChatRoomId(int chatRoomId) { this.chatRoomId = chatRoomId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public Date getJoinedAt() { return joinedAt; }
    public void setJoinedAt(Date joinedAt) { this.joinedAt = joinedAt; }
    
    public Date getLeftAt() { return leftAt; }
    public void setLeftAt(Date leftAt) { this.leftAt = leftAt; }
    
    public Date getLastSeenAt() { return lastSeenAt; }
    public void setLastSeenAt(Date lastSeenAt) { this.lastSeenAt = lastSeenAt; }
    
    public boolean isNotificationEnabled() { return notificationEnabled; }
    public void setNotificationEnabled(boolean notificationEnabled) { this.notificationEnabled = notificationEnabled; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
}