package com.chatbot.dao;

import com.chatbot.model.Notification;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    // Thêm notification mới
    public boolean addNotification(Notification notification) {
        String sql = "INSERT INTO Notifications (userId, contentType, contentId, title, message, type, isRead, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, notification.getUserId());
            ps.setString(2, notification.getContentType());
            ps.setInt(3, notification.getContentId());
            ps.setString(4, notification.getTitle());
            ps.setString(5, notification.getMessage());
            ps.setString(6, notification.getType());
            ps.setBoolean(7, notification.isRead());
            ps.setTimestamp(8, new Timestamp(notification.getCreatedAt().getTime()));
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        notification.setNotificationId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách notification theo userId (mới nhất lên đầu)
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE userId = ? ORDER BY createdAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notificationId"));
                    n.setUserId(rs.getInt("userId"));
                    n.setContentType(rs.getString("contentType"));
                    n.setContentId(rs.getInt("contentId"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setType(rs.getString("type"));
                    n.setRead(rs.getBoolean("isRead"));
                    n.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đánh dấu đã đọc notification
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE Notifications SET isRead = 1 WHERE notificationId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
