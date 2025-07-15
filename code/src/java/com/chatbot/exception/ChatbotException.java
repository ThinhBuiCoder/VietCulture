package com.chatbot.exception;

/**
 * Base exception class for chatbot operations
 */
public class ChatbotException extends Exception {
    
    private final ErrorCode errorCode;
    private final String userFriendlyMessage;
    
    public ChatbotException(ErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.userFriendlyMessage = errorCode.getUserFriendlyMessage();
    }
    
    public ChatbotException(ErrorCode errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.userFriendlyMessage = errorCode.getUserFriendlyMessage();
    }
    
    public ChatbotException(ErrorCode errorCode, String message, String userFriendlyMessage) {
        super(message);
        this.errorCode = errorCode;
        this.userFriendlyMessage = userFriendlyMessage;
    }
    
    public ChatbotException(ErrorCode errorCode, String message, String userFriendlyMessage, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.userFriendlyMessage = userFriendlyMessage;
    }
    
    public ErrorCode getErrorCode() {
        return errorCode;
    }
    
    public String getUserFriendlyMessage() {
        return userFriendlyMessage;
    }
}