package com.chatbot.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/ws/chat-room")
public class ChatWebSocketEndpoint {
    private static final Set<Session> sessions = new CopyOnWriteArraySet<>();

    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        boolean isRead = isReadMessage(message);
        for (Session s : sessions) {
            if (s.isOpen()) {
                // Nếu là thông điệp 'read', không gửi lại cho chính sender
                if (isRead && s.equals(session)) continue;
                s.getBasicRemote().sendText(message);
            }
        }
    }

    private boolean isReadMessage(String message) {
        // Đơn giản kiểm tra message có chứa '"type":"read"'
        return message != null && message.contains("\"type\":\"read\"");
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        sessions.remove(session);
    }
} 