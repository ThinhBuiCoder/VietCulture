// ChatDAO.java
package dao;

import model.*;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ChatDAO {
    
    private static final Logger LOGGER = Logger.getLogger(ChatDAO.class.getName());
    
    // Tạo hoặc lấy chat room giữa user và host
    public ChatRoom getOrCreateChatRoom(int userId, int hostId, Integer experienceId, Integer accommodationId) {
        ChatRoom room = getChatRoom(userId, hostId, experienceId, accommodationId);
        if (room != null) {
            return room;
        }
        return createChatRoom(userId, hostId, experienceId, accommodationId);
    }
    
    // Lấy chat room hiện có
    public ChatRoom getChatRoom(int userId, int hostId, Integer experienceId, Integer accommodationId) {
        String sql = """
            SELECT cr.*, 
                   u1.fullName as userName, u1.avatar as userAvatar,
                   u2.fullName as hostName, u2.avatar as hostAvatar,
                   e.title as experienceTitle,
                   a.name as accommodationName
            FROM ChatRooms cr
            LEFT JOIN Users u1 ON cr.userId = u1.userId
            LEFT JOIN Users u2 ON cr.hostId = u2.userId
            LEFT JOIN Experiences e ON cr.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON cr.accommodationId = a.accommodationId
            WHERE cr.userId = ? AND cr.hostId = ? 
            AND ((cr.experienceId = ? AND cr.accommodationId IS NULL) 
                 OR (cr.accommodationId = ? AND cr.experienceId IS NULL)
                 OR (cr.experienceId IS NULL AND cr.accommodationId IS NULL))
            """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, hostId);
            if (experienceId != null) {
                ps.setInt(3, experienceId);
                ps.setNull(4, Types.INTEGER);
            } else if (accommodationId != null) {
                ps.setNull(3, Types.INTEGER);
                ps.setInt(4, accommodationId);
            } else {
                ps.setNull(3, Types.INTEGER);
                ps.setNull(4, Types.INTEGER);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapChatRoom(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting chat room", e);
        }
        return null;
    }
    
    // Tạo chat room mới
    public ChatRoom createChatRoom(int userId, int hostId, Integer experienceId, Integer accommodationId) {
        String sql = "INSERT INTO ChatRooms (userId, hostId, experienceId, accommodationId) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, hostId);
            if (experienceId != null) {
                ps.setInt(3, experienceId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            if (accommodationId != null) {
                ps.setInt(4, accommodationId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int chatRoomId = generatedKeys.getInt(1);
                        
                        // Thêm participants
                        addParticipant(chatRoomId, userId);
                        addParticipant(chatRoomId, hostId);
                        
                        LOGGER.info("Created new chat room with ID: " + chatRoomId);
                        return getChatRoomById(chatRoomId);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating chat room", e);
        }
        return null;
    }
    
    // Lấy chat room theo ID
    public ChatRoom getChatRoomById(int chatRoomId) {
        String sql = """
            SELECT cr.*, 
                   u1.fullName as userName, u1.avatar as userAvatar,
                   u2.fullName as hostName, u2.avatar as hostAvatar,
                   e.title as experienceTitle,
                   a.name as accommodationName
            FROM ChatRooms cr
            LEFT JOIN Users u1 ON cr.userId = u1.userId
            LEFT JOIN Users u2 ON cr.hostId = u2.userId
            LEFT JOIN Experiences e ON cr.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON cr.accommodationId = a.accommodationId
            WHERE cr.chatRoomId = ?
            """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, chatRoomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapChatRoom(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting chat room by ID: " + chatRoomId, e);
        }
        return null;
    }
    
    // Lấy danh sách chat rooms của user
    public List<ChatRoom> getChatRoomsByUserId(int userId) {
        String sql = """
            SELECT cr.*, 
                   u1.fullName as userName, u1.avatar as userAvatar,
                   u2.fullName as hostName, u2.avatar as hostAvatar,
                   e.title as experienceTitle,
                   a.name as accommodationName
            FROM ChatRooms cr
            LEFT JOIN Users u1 ON cr.userId = u1.userId
            LEFT JOIN Users u2 ON cr.hostId = u2.userId
            LEFT JOIN Experiences e ON cr.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON cr.accommodationId = a.accommodationId
            WHERE cr.userId = ? OR cr.hostId = ?
            ORDER BY cr.lastMessageAt DESC, cr.createdAt DESC
            """;
        
        List<ChatRoom> chatRooms = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatRoom chatRoom = mapChatRoom(rs);
                    // Populate unread count for this chat room
                    int unreadCount = getUnreadMessageCountInRoom(chatRoom.getChatRoomId(), userId);
                    chatRoom.setUnreadCount(unreadCount);
                    chatRooms.add(chatRoom);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting chat rooms for user: " + userId, e);
        }
        return chatRooms;
    }
    
    // Thêm participant vào chat room
    private void addParticipant(int chatRoomId, int userId) {
        String sql = "INSERT INTO ChatParticipants (chatRoomId, userId) VALUES (?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, chatRoomId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            LOGGER.info("Added participant " + userId + " to chat room " + chatRoomId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding participant to chat room", e);
        }
    }
    
private void updateChatRoomLastMessage(Connection conn, int chatRoomId, String lastMessage) {
    PreparedStatement pstmt = null;
    try {
        // SỬA: Sử dụng tên bảng và cột đúng theo database schema
        String sql = "UPDATE ChatRooms SET lastMessage = ?, lastMessageAt = GETDATE() WHERE chatRoomId = ?";
        pstmt = conn.prepareStatement(sql);
        
        // Giới hạn độ dài message
        String truncatedMessage = lastMessage;
        if (lastMessage.length() > 100) {
            truncatedMessage = lastMessage.substring(0, 100) + "...";
        }
        
        pstmt.setString(1, truncatedMessage);
        pstmt.setInt(2, chatRoomId);
        
        int rowsUpdated = pstmt.executeUpdate();
        LOGGER.info("Chat room " + chatRoomId + " last message updated. Rows affected: " + rowsUpdated);
        
    } catch (SQLException e) {
        LOGGER.severe("Failed to update chat room last message: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                LOGGER.warning("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }
}
public boolean sendMessage(ChatMessage message) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            LOGGER.info("ChatDAO.sendMessage called with:");
            LOGGER.info("  chatRoomId: " + message.getChatRoomId());
            LOGGER.info("  senderId: " + message.getSenderId());
            LOGGER.info("  receiverId: " + message.getReceiverId());
            LOGGER.info("  messageContent: " + message.getMessageContent());
            LOGGER.info("  messageType: " + message.getMessageType());
            
            // Use DBUtils to get connection
            conn = DBUtils.getConnection();
            if (conn == null) {
                LOGGER.severe("Failed to get database connection");
                return false;
            }
            
            // SQL for SQL Server (adjust table/column names as needed)
            String sql = "INSERT INTO ChatMessages (ChatRoomId, SenderId, ReceiverId, MessageContent, MessageType, SentAt, IsRead) " +
                        "VALUES (?, ?, ?, ?, ?, GETDATE(), 0)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, message.getChatRoomId());
            pstmt.setInt(2, message.getSenderId());
            pstmt.setInt(3, message.getReceiverId());
            pstmt.setString(4, message.getMessageContent());
            pstmt.setString(5, message.getMessageType());
            
            LOGGER.info("Executing SQL: " + sql);
            LOGGER.info("Parameters: chatRoomId=" + message.getChatRoomId() + 
                       ", senderId=" + message.getSenderId() + 
                       ", receiverId=" + message.getReceiverId() + 
                       ", messageContent=" + message.getMessageContent() + 
                       ", messageType=" + message.getMessageType());
            
            int rowsAffected = pstmt.executeUpdate();
            LOGGER.info("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                // Update chat room's last message and timestamp
                updateChatRoomLastMessage(conn, message.getChatRoomId(), message.getMessageContent());
                LOGGER.info("Message saved successfully");
                return true;
            } else {
                LOGGER.warning("No rows affected - message not saved");
                return false;
            }
            
        } catch (SQLException e) {
            LOGGER.severe("SQL Exception in sendMessage: " + e.getMessage());
            LOGGER.severe("SQL State: " + e.getSQLState());
            LOGGER.severe("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            LOGGER.severe("Exception in sendMessage: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            // Close resources using DBUtils
            try {
                if (pstmt != null) {
                    pstmt.close();
                    LOGGER.info("PreparedStatement closed");
                }
            } catch (SQLException e) {
                LOGGER.warning("Error closing PreparedStatement: " + e.getMessage());
            }
            
            // Close connection
            DBUtils.closeConnection(conn);
        }
    }    // Lấy tin nhắn trong chat room
   public List<ChatMessage> getMessages(int chatRoomId, int limit, int offset) {
    // SỬA: Đổi ORDER BY từ DESC thành ASC để tin nhắn hiển thị từ cũ đến mới
    String sql = """
        SELECT cm.*, 
               s.fullName as senderName, s.avatar as senderAvatar,
               r.fullName as receiverName
        FROM ChatMessages cm
        LEFT JOIN Users s ON cm.senderId = s.userId
        LEFT JOIN Users r ON cm.receiverId = r.userId
        WHERE cm.chatRoomId = ? AND cm.isDeleted = 0
        ORDER BY cm.sentAt ASC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
    
    List<ChatMessage> messages = new ArrayList<>();
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, chatRoomId);
        ps.setInt(2, offset);
        ps.setInt(3, limit);
        
        LOGGER.info("Getting messages for chatRoomId: " + chatRoomId + 
                   ", limit: " + limit + ", offset: " + offset);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                messages.add(mapChatMessage(rs));
            }
        }
        
        LOGGER.info("Retrieved " + messages.size() + " messages");
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting messages for chat room: " + chatRoomId, e);
    }
    return messages;
}
    
    // Lưu tin nhắn và trả về message ID
    public int saveMessageAndGetId(ChatMessage message) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            LOGGER.info("ChatDAO.saveMessageAndGetId called with:");
            LOGGER.info("  chatRoomId: " + message.getChatRoomId());
            LOGGER.info("  senderId: " + message.getSenderId());
            LOGGER.info("  receiverId: " + message.getReceiverId());
            LOGGER.info("  messageContent: " + message.getMessageContent());
            LOGGER.info("  messageType: " + message.getMessageType());
            
            // Use DBUtils to get connection
            conn = DBUtils.getConnection();
            if (conn == null) {
                LOGGER.severe("Failed to get database connection");
                return -1;
            }
            
            // SQL for SQL Server with RETURN_GENERATED_KEYS
            String sql = "INSERT INTO ChatMessages (ChatRoomId, SenderId, ReceiverId, MessageContent, MessageType, SentAt, IsRead) " +
                        "VALUES (?, ?, ?, ?, ?, GETDATE(), 0)";
            
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, message.getChatRoomId());
            pstmt.setInt(2, message.getSenderId());
            pstmt.setInt(3, message.getReceiverId());
            pstmt.setString(4, message.getMessageContent());
            pstmt.setString(5, message.getMessageType());
            
            LOGGER.info("Executing SQL: " + sql);
            LOGGER.info("Parameters: chatRoomId=" + message.getChatRoomId() + 
                       ", senderId=" + message.getSenderId() + 
                       ", receiverId=" + message.getReceiverId() + 
                       ", messageContent=" + message.getMessageContent() + 
                       ", messageType=" + message.getMessageType());
            
            int rowsAffected = pstmt.executeUpdate();
            LOGGER.info("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                // Get the generated message ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int messageId = generatedKeys.getInt(1);
                        LOGGER.info("Generated message ID: " + messageId);
                        
                        // Update chat room's last message and timestamp
                        updateChatRoomLastMessage(conn, message.getChatRoomId(), message.getMessageContent());
                        LOGGER.info("Message saved successfully with ID: " + messageId);
                        return messageId;
                    } else {
                        LOGGER.warning("No message ID generated");
                        return -1;
                    }
                }
            } else {
                LOGGER.warning("No rows affected - message not saved");
                return -1;
            }
            
        } catch (SQLException e) {
            LOGGER.severe("SQL Exception in saveMessageAndGetId: " + e.getMessage());
            LOGGER.severe("SQL State: " + e.getSQLState());
            LOGGER.severe("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return -1;
        } catch (Exception e) {
            LOGGER.severe("Exception in saveMessageAndGetId: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            // Close resources using DBUtils
            try {
                if (pstmt != null) {
                    pstmt.close();
                    LOGGER.info("PreparedStatement closed");
                }
            } catch (SQLException e) {
                LOGGER.warning("Error closing PreparedStatement: " + e.getMessage());
            }
            
            // Close connection
            DBUtils.closeConnection(conn);
        }
    }

    // Đánh dấu tin nhắn đã đọc
    public boolean markMessagesAsRead(int chatRoomId, int userId) {
        String sql = "UPDATE ChatMessages SET isRead = 1, readAt = GETDATE() WHERE chatRoomId = ? AND receiverId = ? AND isRead = 0";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, chatRoomId);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.info("Marked " + rowsAffected + " messages as read for user " + userId + 
                           " in room " + chatRoomId);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking messages as read", e);
        }
        return false;
    }
    
    // Đếm tin nhắn chưa đọc
    public int getUnreadMessageCount(int userId) {
        String sql = "SELECT COUNT(*) FROM ChatMessages WHERE receiverId = ? AND isRead = 0 AND isDeleted = 0";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting unread message count for user: " + userId, e);
        }
        return 0;
    }
    
    // Đếm tin nhắn chưa đọc trong chat room cụ thể
    public int getUnreadMessageCountInRoom(int chatRoomId, int userId) {
        String sql = "SELECT COUNT(*) FROM ChatMessages WHERE chatRoomId = ? AND receiverId = ? AND isRead = 0 AND isDeleted = 0";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, chatRoomId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting unread message count for room: " + chatRoomId, e);
        }
        return 0;
    }
    
    // Cập nhật last seen
    public void updateLastSeen(int chatRoomId, int userId) {
        String sql = "UPDATE ChatParticipants SET lastSeenAt = GETDATE() WHERE chatRoomId = ? AND userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, chatRoomId);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.fine("Updated last seen for user " + userId + " in room " + chatRoomId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating last seen", e);
        }
    }
    
    // Lấy danh sách hosts (để hiển thị trong dropdown khi tạo chat mới)
    public List<User> getAllHosts() {
        String sql = "SELECT userId, fullName, avatar, businessName FROM Users WHERE role = 'HOST' AND isActive = 1 ORDER BY fullName";
        
        List<User> hosts = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User host = new User();
                host.setUserId(rs.getInt("userId"));
                host.setFullName(rs.getString("fullName"));
                host.setAvatar(rs.getString("avatar"));
                host.setBusinessName(rs.getString("businessName"));
                hosts.add(host);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all hosts", e);
        }
        return hosts;
    }
    
    // Lấy experiences của host cụ thể
    public List<Experience> getExperiencesByHostId(int hostId) {
        String sql = "SELECT experienceId, title, price FROM Experiences WHERE hostId = ? AND isActive = 1 ORDER BY title";
        
        List<Experience> experiences = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience exp = new Experience();
                    exp.setExperienceId(rs.getInt("experienceId"));
                    exp.setTitle(rs.getString("title"));
                    exp.setPrice(rs.getDouble("price"));
                    experiences.add(exp);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting experiences for host: " + hostId, e);
        }
        return experiences;
    }
    
    // Xóa tin nhắn (soft delete)
    public boolean deleteMessage(int messageId, int userId) {
        String sql = "UPDATE ChatMessages SET isDeleted = 1 WHERE messageId = ? AND senderId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, messageId);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.info("Message " + messageId + " deleted by user " + userId);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting message", e);
        }
        return false;
    }
    
    // Cập nhật trạng thái chat room
    public boolean updateChatRoomStatus(int chatRoomId, String status) {
        String sql = "UPDATE ChatRooms SET status = ? WHERE chatRoomId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, chatRoomId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.info("Chat room " + chatRoomId + " status updated to: " + status);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating chat room status", e);
        }
        return false;
    }
    
    // Helper methods - sửa lại để sử dụng Date thay vì LocalDateTime
    private ChatRoom mapChatRoom(ResultSet rs) throws SQLException {
        ChatRoom room = new ChatRoom();
        room.setChatRoomId(rs.getInt("chatRoomId"));
        room.setUserId(rs.getInt("userId"));
        room.setHostId(rs.getInt("hostId"));
        
        int expId = rs.getInt("experienceId");
        room.setExperienceId(rs.wasNull() ? null : expId);
        
        int accId = rs.getInt("accommodationId");
        room.setAccommodationId(rs.wasNull() ? null : accId);
        
        room.setStatus(rs.getString("status"));
        
        // Chuyển đổi Timestamp sang Date
        Timestamp createdAt = rs.getTimestamp("createdAt");
        room.setCreatedAt(createdAt != null ? new java.util.Date(createdAt.getTime()) : null);
        
        Timestamp lastMessageAt = rs.getTimestamp("lastMessageAt");
        room.setLastMessageAt(lastMessageAt != null ? new java.util.Date(lastMessageAt.getTime()) : null);
        
        room.setLastMessage(rs.getString("lastMessage"));
        room.setUserName(rs.getString("userName"));
        room.setHostName(rs.getString("hostName"));
        room.setUserAvatar(rs.getString("userAvatar"));
        room.setHostAvatar(rs.getString("hostAvatar"));
        room.setExperienceTitle(rs.getString("experienceTitle"));
        room.setAccommodationName(rs.getString("accommodationName"));
        
        return room;
    }
    
    private ChatMessage mapChatMessage(ResultSet rs) throws SQLException {
        ChatMessage message = new ChatMessage();
        message.setMessageId(rs.getInt("messageId"));
        message.setChatRoomId(rs.getInt("chatRoomId"));
        message.setSenderId(rs.getInt("senderId"));
        message.setReceiverId(rs.getInt("receiverId"));
        message.setMessageContent(rs.getString("messageContent"));
        message.setMessageType(rs.getString("messageType"));
        message.setAttachmentUrl(rs.getString("attachmentUrl"));
        message.setRead(rs.getBoolean("isRead"));
        message.setDeleted(rs.getBoolean("isDeleted"));
        
        // Chuyển đổi Timestamp sang Date
        Timestamp editedAt = rs.getTimestamp("editedAt");
        message.setEditedAt(editedAt != null ? new java.util.Date(editedAt.getTime()) : null);
        
        Timestamp sentAt = rs.getTimestamp("sentAt");
        message.setSentAt(sentAt != null ? new java.util.Date(sentAt.getTime()) : null);
        
        Timestamp readAt = rs.getTimestamp("readAt");
        message.setReadAt(readAt != null ? new java.util.Date(readAt.getTime()) : null);
        
        message.setSenderName(rs.getString("senderName"));
        message.setSenderAvatar(rs.getString("senderAvatar"));
        message.setReceiverName(rs.getString("receiverName"));
        
        return message;
    }
}