package com.chatbot.service;

import com.chatbot.dao.NotificationDAO;
import com.chatbot.model.Notification;
import java.util.Date;
import java.util.List;

public class NotificationService {
    private NotificationDAO notificationDAO = new NotificationDAO();

    // Tạo thông báo mới cho user/host
    public boolean notifyUser(int userId, String title, String message, String type, String contentType, int contentId) {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setContentType(contentType);
        notification.setContentId(contentId);
        notification.setRead(false);
        notification.setCreatedAt(new Date());
        return notificationDAO.addNotification(notification);
    }

    // Lấy danh sách thông báo của user/host
    public List<Notification> getUserNotifications(int userId) {
        return notificationDAO.getNotificationsByUserId(userId);
    }

    // Đánh dấu đã đọc
    public boolean markAsRead(int notificationId) {
        return notificationDAO.markAsRead(notificationId);
    }
} 