package controller;

import dao.ChatDAO;
import model.ChatMessage;
import model.ChatRoom;
import model.User;
import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

@ServerEndpoint("/ws/chat/{roomId}")
public class ChatEndpoint {
    
    private static final Logger LOGGER = Logger.getLogger(ChatEndpoint.class.getName());
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();
    private static final Map<String, Integer> sessionRooms = new ConcurrentHashMap<>();
    private static final ChatDAO chatDAO = new ChatDAO();
    private static final Gson gson = new Gson();
    
    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") String roomIdStr) {
        try {
            int roomId = Integer.parseInt(roomIdStr);
            String sessionId = session.getId();
            
            // Lưu session và room mapping
            sessions.put(sessionId, session);
            sessionRooms.put(sessionId, roomId);
            
            LOGGER.info("WebSocket connection opened for room " + roomId + ", session: " + sessionId);
            
            // Gửi thông báo kết nối thành công
            JsonObject response = new JsonObject();
            response.addProperty("type", "connection");
            response.addProperty("status", "connected");
            response.addProperty("roomId", roomId);
            
            session.getBasicRemote().sendText(response.toString());
            
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid room ID: " + roomIdStr);
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Invalid room ID"));
            } catch (IOException ex) {
                LOGGER.severe("Error closing session: " + ex.getMessage());
            }
        } catch (IOException e) {
            LOGGER.severe("Error sending connection message: " + e.getMessage());
        }
    }
    
    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            String sessionId = session.getId();
            Integer roomId = sessionRooms.get(sessionId);
            
            if (roomId == null) {
                LOGGER.warning("Session not found in room mapping: " + sessionId);
                return;
            }
            
            // Parse message JSON
            JsonObject messageObj = gson.fromJson(message, JsonObject.class);
            String type = messageObj.get("type").getAsString();
            
            if ("message".equals(type)) {
                handleChatMessage(messageObj, session, roomId);
            } else if ("typing".equals(type)) {
                handleTypingIndicator(messageObj, session, roomId);
            } else if ("read".equals(type)) {
                handleReadReceipt(messageObj, session, roomId);
            }
            
        } catch (Exception e) {
            LOGGER.severe("Error processing message: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @OnClose
    public void onClose(Session session) {
        String sessionId = session.getId();
        sessions.remove(sessionId);
        sessionRooms.remove(sessionId);
        
        LOGGER.info("WebSocket connection closed for session: " + sessionId);
    }
    
    @OnError
    public void onError(Session session, Throwable throwable) {
        LOGGER.severe("WebSocket error for session " + session.getId() + ": " + throwable.getMessage());
        throwable.printStackTrace();
    }
    
    private void handleChatMessage(JsonObject messageObj, Session senderSession, int roomId) {
        try {
            String content = messageObj.get("content").getAsString();
            int senderId = messageObj.get("senderId").getAsInt();
            String senderName = messageObj.get("senderName").getAsString();
            int receiverId = messageObj.get("receiverId").getAsInt();
            
            // Lưu tin nhắn vào database
            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setChatRoomId(roomId);
            chatMessage.setSenderId(senderId);
            chatMessage.setReceiverId(receiverId);
            chatMessage.setMessageContent(content);
            chatMessage.setMessageType("TEXT");
            chatMessage.setSentAt(new Date());
            
            int messageId = chatDAO.saveMessageAndGetId(chatMessage);
            if (messageId == -1) {
                LOGGER.severe("Failed to save message to database");
                return;
            }
            
            chatMessage.setMessageId(messageId);
            
            // Tạo response message
            JsonObject response = new JsonObject();
            response.addProperty("type", "message");
            response.addProperty("messageId", messageId);
            response.addProperty("roomId", roomId);
            response.addProperty("senderId", senderId);
            response.addProperty("senderName", senderName);
            response.addProperty("content", content);
            response.addProperty("timestamp", chatMessage.getSentAt().getTime());
            response.addProperty("senderAvatar", chatMessage.getSenderAvatar());
            
            // Broadcast tin nhắn đến tất cả session trong cùng room
            broadcastToRoom(roomId, response.toString(), senderSession.getId());
            
            LOGGER.info("Message broadcasted to room " + roomId + ": " + content);
            
        } catch (Exception e) {
            LOGGER.severe("Error handling chat message: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void handleTypingIndicator(JsonObject messageObj, Session senderSession, int roomId) {
        try {
            int senderId = messageObj.get("senderId").getAsInt();
            String senderName = messageObj.get("senderName").getAsString();
            boolean isTyping = messageObj.get("isTyping").getAsBoolean();
            
            JsonObject response = new JsonObject();
            response.addProperty("type", "typing");
            response.addProperty("senderId", senderId);
            response.addProperty("senderName", senderName);
            response.addProperty("isTyping", isTyping);
            
            broadcastToRoom(roomId, response.toString(), senderSession.getId());
            
        } catch (Exception e) {
            LOGGER.severe("Error handling typing indicator: " + e.getMessage());
        }
    }
    
    private void handleReadReceipt(JsonObject messageObj, Session senderSession, int roomId) {
        try {
            int userId = messageObj.get("userId").getAsInt();
            
            // Cập nhật trạng thái đã đọc trong database
            chatDAO.markMessagesAsRead(roomId, userId);
            
            JsonObject response = new JsonObject();
            response.addProperty("type", "read");
            response.addProperty("userId", userId);
            response.addProperty("roomId", roomId);
            
            broadcastToRoom(roomId, response.toString(), null);
            
        } catch (Exception e) {
            LOGGER.severe("Error handling read receipt: " + e.getMessage());
        }
    }
    
    private void broadcastToRoom(int roomId, String message, String excludeSessionId) {
        sessions.forEach((sessionId, session) -> {
            Integer sessionRoomId = sessionRooms.get(sessionId);
            if (sessionRoomId != null && sessionRoomId.equals(roomId) && 
                (excludeSessionId == null || !sessionId.equals(excludeSessionId))) {
                
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                    }
                } catch (IOException e) {
                    LOGGER.severe("Error broadcasting message to session " + sessionId + ": " + e.getMessage());
                }
            }
        });
    }
    
    // Phương thức utility để gửi tin nhắn từ servlet
    public static void sendMessageToRoom(int roomId, String message) {
        sessions.forEach((sessionId, session) -> {
            Integer sessionRoomId = sessionRooms.get(sessionId);
            if (sessionRoomId != null && sessionRoomId.equals(roomId)) {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                    }
                } catch (IOException e) {
                    LOGGER.severe("Error sending message to session " + sessionId + ": " + e.getMessage());
                }
            }
        });
    }
} 