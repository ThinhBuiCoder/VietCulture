package com.chatbot.exception;

import com.chatbot.utils.Logger;

/**
 * Central exception handler for the chatbot
 */
public class ExceptionHandler {
    
    private static final Logger logger = Logger.getInstance();
    
    /**
     * Handle ChatbotException and return user-friendly message
     */
    public static String handleChatbotException(ChatbotException e) {
        logException(e);
        return e.getUserFriendlyMessage();
    }
    
    /**
     * Handle general Exception and return user-friendly message
     */
    public static String handleGeneralException(Exception e) {
        logException(e);
        
        // Check if it's a known exception type
        if (e instanceof ValidationException) {
            return handleChatbotException((ValidationException) e);
        }
        
        if (e instanceof ChatbotException) {
            return handleChatbotException((ChatbotException) e);
        }
        
        // Handle specific exception types
        if (e instanceof java.sql.SQLException) {
            return ErrorCode.DATABASE_ERROR.getUserFriendlyMessage();
        }
        
        if (e instanceof java.io.IOException) {
            return ErrorCode.AI_SERVICE_ERROR.getUserFriendlyMessage();
        }
        
        if (e instanceof java.lang.SecurityException) {
            return ErrorCode.PERMISSION_DENIED.getUserFriendlyMessage();
        }
        
        // Default error message
        return ErrorCode.GENERAL_ERROR.getUserFriendlyMessage();
    }
    
    /**
     * Handle database-related exceptions
     */
    public static String handleDatabaseException(Exception e) {
        logException(e);
        
        String message = e.getMessage();
        if (message != null) {
            message = message.toLowerCase();
            
            if (message.contains("connection") || message.contains("timeout")) {
                return "❌ Kết nối cơ sở dữ liệu bị gián đoạn. Vui lòng thử lại sau.";
            }
            
            if (message.contains("duplicate") || message.contains("unique")) {
                return "❌ Dữ liệu đã tồn tại. Vui lòng kiểm tra lại.";
            }
            
            if (message.contains("foreign key") || message.contains("constraint")) {
                return "❌ Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin.";
            }
        }
        
        return ErrorCode.DATABASE_ERROR.getUserFriendlyMessage();
    }
    
    /**
     * Handle search-related exceptions
     */
    public static String handleSearchException(Exception e) {
        logException(e);
        
        if (e instanceof ValidationException) {
            return handleChatbotException((ValidationException) e);
        }
        
        return ErrorCode.SEARCH_ERROR.getUserFriendlyMessage();
    }
    
    /**
     * Handle AI service exceptions
     */
    public static String handleAIServiceException(Exception e) {
        logException(e);
        
        String message = e.getMessage();
        if (message != null) {
            message = message.toLowerCase();
            
            if (message.contains("rate limit") || message.contains("quota")) {
                return "❌ Dịch vụ AI tạm thời quá tải. Vui lòng thử lại sau vài phút.";
            }
            
            if (message.contains("api key") || message.contains("unauthorized")) {
                return "❌ Lỗi xác thực dịch vụ AI. Vui lòng liên hệ hỗ trợ.";
            }
            
            if (message.contains("timeout")) {
                return "❌ Dịch vụ AI phản hồi chậm. Vui lòng thử lại.";
            }
        }
        
        return ErrorCode.AI_SERVICE_ERROR.getUserFriendlyMessage();
    }
    
    /**
     * Create a ChatbotException with appropriate error code
     */
    public static ChatbotException createException(ErrorCode errorCode, String message) {
        return new ChatbotException(errorCode, message);
    }
    
    /**
     * Create a ChatbotException with cause
     */
    public static ChatbotException createException(ErrorCode errorCode, String message, Throwable cause) {
        return new ChatbotException(errorCode, message, cause);
    }
    
    /**
     * Create a ValidationException
     */
    public static ValidationException createValidationException(String message) {
        return new ValidationException(message);
    }
    
    /**
     * Check if exception should be retried
     */
    public static boolean isRetryableException(Exception e) {
        if (e instanceof ChatbotException) {
            ChatbotException ce = (ChatbotException) e;
            ErrorCode code = ce.getErrorCode();
            
            // These errors can potentially be retried
            return code == ErrorCode.DATABASE_ERROR ||
                   code == ErrorCode.AI_SERVICE_ERROR ||
                   code == ErrorCode.WEATHER_SERVICE_ERROR;
        }
        
        // Check for specific exception types that are typically retryable
        return e instanceof java.net.SocketTimeoutException ||
               e instanceof java.net.ConnectException ||
               e instanceof java.io.IOException;
    }
    
    /**
     * Log exception with appropriate level
     */
    private static void logException(Exception e) {
        if (e instanceof ValidationException) {
            logger.warn("Validation error: " + e.getMessage());
        } else if (e instanceof ChatbotException) {
            ChatbotException ce = (ChatbotException) e;
            logger.error("Chatbot error [" + ce.getErrorCode().getCode() + "]: " + e.getMessage(), e);
        } else {
            logger.error("Unexpected error: " + e.getMessage(), e);
        }
    }
}