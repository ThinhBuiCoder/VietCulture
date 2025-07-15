package com.chatbot.servlet;

import com.chatbot.factory.ServiceFactory;
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

@WebServlet(name = "TravelChatServletV2", urlPatterns = {"/travel-chat-v2"})
public class TravelChatServletV2 extends HttpServlet {
    
    private ServiceFactory serviceFactory;
    private ResponseGenerator responseGenerator;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.serviceFactory = ServiceFactory.getInstance();
        this.responseGenerator = serviceFactory.getResponseGenerator();
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
        
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(aiResponse);
    }
    
    private String processUserMessage(String userMessage, HttpSession session) {
        try {
            if (isInitializationRequest(userMessage)) {
                return ChatConstants.WELCOME_MESSAGE;
            }
            
            String cleanedMessage = validateAndCleanMessage(userMessage);
            if (cleanedMessage == null) {
                return "❌ Tin nhắn không hợp lệ. Vui lòng thử lại.";
            }
            
            List<ChatMessage> chatHistory = ChatSessionManager.getChatHistory(session);
            
            // Sử dụng session như là Object thay vì ép kiểu HttpSession
            String aiResponse = responseGenerator.generateResponse(cleanedMessage, session, chatHistory);
            
            ChatSessionManager.addConversationToHistory(session, cleanedMessage, aiResponse);
            
            return aiResponse;
            
        } catch (Exception e) {
            logError("Error processing user message", e);
            return ChatConstants.ERROR_PROCESSING_MESSAGE;
        }
    }
    
    private boolean isInitializationRequest(String userMessage) {
        return StringUtils.isEmpty(userMessage);
    }
    
    private String validateAndCleanMessage(String userMessage) {
        if (StringUtils.isEmpty(userMessage)) {
            return null;
        }
        
        String cleaned = userMessage.trim();
        if (cleaned.length() > 1000) {
            cleaned = cleaned.substring(0, 1000);
        }
        
        return sanitizeInput(cleaned);
    }
    
    private String sanitizeInput(String input) {
        if (input == null) return null;
        
        input = input.replaceAll("<[^>]*>", "");
        input = input.replaceAll("(?i)script", "");
        input = input.replaceAll("(?i)javascript", "");
        
        return input;
    }
    
    private void logError(String message, Exception e) {
        System.err.println("[TravelChatServletV2] " + message + ": " + e.getMessage());
        e.printStackTrace();
    }
    
    @Override
    public void destroy() {
        this.responseGenerator = null;
        this.serviceFactory = null;
        super.destroy();
    }
}