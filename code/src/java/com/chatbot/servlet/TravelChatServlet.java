package com.chatbot.servlet;

import com.chatbot.manager.ChatSessionManager;
import com.chatbot.service.ResponseGenerator;
import com.chatbot.model.ChatMessage;
import com.chatbot.constants.ChatConstants;
import com.chatbot.utils.StringUtils;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TravelChatServlet", urlPatterns = {"/travel-chat"})
public class TravelChatServlet extends HttpServlet {
    
    private ResponseGenerator responseGenerator;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.responseGenerator = new ResponseGenerator();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/travel-chat.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userMessage = request.getParameter("message");
        HttpSession session = request.getSession();
        
        String aiResponse = processUserMessage(userMessage, session);
        
        // Set response headers
        response.setContentType("text/plain;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Pragma", "no-cache");
        
        // Send response
        response.getWriter().write(aiResponse);
    }
    
    /**
     * Process user message and generate appropriate response
     */
    private String processUserMessage(String userMessage, HttpSession session) {
        try {
            // Handle initialization case
            if (isInitializationRequest(userMessage)) {
                return ChatConstants.WELCOME_MESSAGE;
            }
            
            // Validate and clean user message
            String cleanedMessage = validateAndCleanMessage(userMessage);
            if (cleanedMessage == null) {
                return "❌ Tin nhắn không hợp lệ. Vui lòng thử lại.";
            }
            
            // Get chat history
            List<ChatMessage> chatHistory = ChatSessionManager.getChatHistory(session);
            
            // Generate response - truyền session trực tiếp như là Object
            String aiResponse = responseGenerator.generateResponse(cleanedMessage, session, chatHistory);
            
            // Add conversation to history
            ChatSessionManager.addConversationToHistory(session, cleanedMessage, aiResponse);
            
            return aiResponse;
            
        } catch (Exception e) {
            logError("Error processing user message", e);
            return ChatConstants.ERROR_PROCESSING_MESSAGE;
        }
    }
    
    /**
     * Check if this is an initialization request
     */
    private boolean isInitializationRequest(String userMessage) {
        return StringUtils.isEmpty(userMessage);
    }
    
    /**
     * Validate and clean user message
     */
    private String validateAndCleanMessage(String userMessage) {
        if (StringUtils.isEmpty(userMessage)) {
            return null;
        }
        
        // Basic sanitization
        String cleaned = userMessage.trim();
        
        // Check for reasonable length limits
        if (cleaned.length() > 1000) {
            cleaned = cleaned.substring(0, 1000);
        }
        
        // Remove potentially harmful content
        cleaned = sanitizeInput(cleaned);
        
        return cleaned;
    }
    
    /**
     * Basic input sanitization
     */
    private String sanitizeInput(String input) {
        if (input == null) return null;
        
        // Remove HTML tags and scripts
        input = input.replaceAll("<[^>]*>", "");
        input = input.replaceAll("(?i)script", "");
        input = input.replaceAll("(?i)javascript", "");
        
        return input;
    }
    
    /**
     * Log error with context information
     */
    private void logError(String message, Exception e) {
        // In a real application, use proper logging framework like SLF4J
        System.err.println("[TravelChatServlet] " + message + ": " + e.getMessage());
        e.printStackTrace();
    }
    
    @Override
    public void destroy() {
        // Cleanup resources if needed
        this.responseGenerator = null;
        super.destroy();
    }
}