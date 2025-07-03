package model;

import java.util.Date;

public class ChatRoom {
    private int chatRoomId;
    private int userId;
    private int hostId;
    private Integer experienceId; // nullable
    private Integer accommodationId; // nullable
    private String status;
    private Date createdAt;
    private Date lastMessageAt;
    private String lastMessage;
    
    // User và Host info
    private String userName;
    private String hostName;
    private String userAvatar;
    private String hostAvatar;
    private String experienceTitle;
    private String accommodationName;
    
    // Constructors
    public ChatRoom() {}
    
    public ChatRoom(int userId, int hostId, Integer experienceId, Integer accommodationId) {
        this.userId = userId;
        this.hostId = hostId;
        this.experienceId = experienceId;
        this.accommodationId = accommodationId;
        this.status = "ACTIVE";
        this.createdAt = new Date();
    }
    
    // Getters and Setters
    public int getChatRoomId() { return chatRoomId; }
    public void setChatRoomId(int chatRoomId) { this.chatRoomId = chatRoomId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getHostId() { return hostId; }
    public void setHostId(int hostId) { this.hostId = hostId; }
    
    public Integer getExperienceId() { return experienceId; }
    public void setExperienceId(Integer experienceId) { this.experienceId = experienceId; }
    
    public Integer getAccommodationId() { return accommodationId; }
    public void setAccommodationId(Integer accommodationId) { this.accommodationId = accommodationId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(Date lastMessageAt) { this.lastMessageAt = lastMessageAt; }
    
    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getHostName() { return hostName; }
    public void setHostName(String hostName) { this.hostName = hostName; }
    
    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
    
    public String getHostAvatar() { return hostAvatar; }
    public void setHostAvatar(String hostAvatar) { this.hostAvatar = hostAvatar; }
    
    public String getExperienceTitle() { return experienceTitle; }
    public void setExperienceTitle(String experienceTitle) { this.experienceTitle = experienceTitle; }
    
    public String getAccommodationName() { return accommodationName; }
    public void setAccommodationName(String accommodationName) { this.accommodationName = accommodationName; }
}