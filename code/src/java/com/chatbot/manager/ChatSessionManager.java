package com.chatbot.manager;

import com.chatbot.model.ChatMessage;
import com.chatbot.model.User;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

public class ChatSessionManager {
    
    private static final String CHAT_HISTORY_KEY = "chatHistory";
    private static final String USER_PREFERRED_CITY_KEY = "userPreferredCity";
    private static final String USER_EMAIL_KEY = "userEmail";
    private static final String USER_KEY = "user";
    private static final int MAX_CHAT_HISTORY = 10;
    
    /**
     * Get or create chat history for session
     */
    public static List<ChatMessage> getChatHistory(HttpSession session) {
        List<ChatMessage> chatHistory = (List<ChatMessage>) session.getAttribute(CHAT_HISTORY_KEY);
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
            session.setAttribute(CHAT_HISTORY_KEY, chatHistory);
        }
        return chatHistory;
    }
    
    /**
     * Add message to chat history with size limit
     */
    public static void addMessageToHistory(HttpSession session, ChatMessage message) {
        List<ChatMessage> chatHistory = getChatHistory(session);
        chatHistory.add(message);
        
        // Maintain size limit
        if (chatHistory.size() > MAX_CHAT_HISTORY) {
            chatHistory = new ArrayList<>(chatHistory.subList(chatHistory.size() - MAX_CHAT_HISTORY, chatHistory.size()));
            session.setAttribute(CHAT_HISTORY_KEY, chatHistory);
        }
    }
    
    /**
     * Add user message and AI response to history
     */
    public static void addConversationToHistory(HttpSession session, String userMessage, String aiResponse) {
        addMessageToHistory(session, new ChatMessage(userMessage, "user"));
        addMessageToHistory(session, new ChatMessage(aiResponse, "ai"));
    }
    
    /**
     * Get user preferred city from session
     */
    public static String getUserPreferredCity(HttpSession session) {
        return (String) session.getAttribute(USER_PREFERRED_CITY_KEY);
    }
    
    /**
     * Set user preferred city in session
     */
    public static void setUserPreferredCity(HttpSession session, String city) {
        session.setAttribute(USER_PREFERRED_CITY_KEY, city);
    }
    
    /**
     * Get user email from session
     */
    public static String getUserEmail(HttpSession session) {
        return (String) session.getAttribute(USER_EMAIL_KEY);
    }
    
    /**
     * Set user email in session
     */
    public static void setUserEmail(HttpSession session, String email) {
        session.setAttribute(USER_EMAIL_KEY, email);
    }
    
    /**
     * Get current user from session
     */
    public static User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute(USER_KEY);
    }
    
    /**
     * Set current user in session
     */
    public static void setCurrentUser(HttpSession session, User user) {
        session.setAttribute(USER_KEY, user);
    }
    
    /**
     * Clear all session data
     */
    public static void clearSession(HttpSession session) {
        session.removeAttribute(CHAT_HISTORY_KEY);
        session.removeAttribute(USER_PREFERRED_CITY_KEY);
        session.removeAttribute(USER_EMAIL_KEY);
        session.removeAttribute(USER_KEY);
    }
    
    /**
     * Check if session has valid user
     */
    public static boolean hasValidUser(HttpSession session) {
        User user = getCurrentUser(session);
        return user != null && user.getEmail() != null && !user.getEmail().trim().isEmpty();
    }
}