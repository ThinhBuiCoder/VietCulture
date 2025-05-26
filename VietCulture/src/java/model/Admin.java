package model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Admin {
    private int userId;
    private String role; // SUPER_ADMIN, ADMIN, MODERATOR
    private String permissions; // JSON string containing permissions
    
    // Related objects
    private User user;
    private List<AdminAction> actions;
    
    // Constructors
    public Admin() {
        this.actions = new ArrayList<>();
    }
    
    public Admin(int userId, String role) {
        this();
        this.userId = userId;
        this.role = role;
    }
    
    public Admin(int userId, String role, String permissions) {
        this(userId, role);
        this.permissions = permissions;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getPermissions() {
        return permissions;
    }
    
    public void setPermissions(String permissions) {
        this.permissions = permissions;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getUserId();
        }
    }
    
    public List<AdminAction> getActions() {
        return actions;
    }
    
    public void setActions(List<AdminAction> actions) {
        this.actions = actions;
    }
    
    // Helper methods
    
    /**
     * Check if admin has specific permission
     */
    public boolean hasPermission(String permission) {
        if ("SUPER_ADMIN".equals(role)) {
            return true; // Super admin has all permissions
        }
        
        if (permissions == null || permissions.trim().isEmpty()) {
            return false;
        }
        
        // Simple check - in production, you'd parse JSON properly
        return permissions.toLowerCase().contains(permission.toLowerCase());
    }
    
    /**
     * Get role display text
     */
    public String getRoleText() {
        switch (role) {
            case "SUPER_ADMIN":
                return "Quản trị viên cấp cao";
            case "ADMIN":
                return "Quản trị viên";
            case "MODERATOR":
                return "Điều hành viên";
            default:
                return role;
        }
    }
    
    /**
     * Check if this is a super admin
     */
    public boolean isSuperAdmin() {
        return "SUPER_ADMIN".equals(role);
    }
    
    /**
     * Check if can manage users
     */
    public boolean canManageUsers() {
        return isSuperAdmin() || hasPermission("manage_users");
    }
    
    /**
     * Check if can approve content
     */
    public boolean canApproveContent() {
        return isSuperAdmin() || hasPermission("approve_content");
    }
    
    /**
     * Check if can view statistics
     */
    public boolean canViewStatistics() {
        return isSuperAdmin() || hasPermission("view_statistics");
    }
    
    /**
     * Check if can manage system settings
     */
    public boolean canManageSettings() {
        return isSuperAdmin() || hasPermission("manage_settings");
    }
    
    /**
     * Add action to history
     */
    public void addAction(AdminAction action) {
        if (this.actions == null) {
            this.actions = new ArrayList<>();
        }
        this.actions.add(action);
    }
    
    @Override
    public String toString() {
        return "Admin{" +
                "userId=" + userId +
                ", role='" + role + '\'' +
                ", permissions='" + permissions + '\'' +
                '}';
    }
    
    // Inner class for admin actions
    public static class AdminAction {
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