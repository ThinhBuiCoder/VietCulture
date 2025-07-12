package com.chatbot.exception;

import java.util.List;
import java.util.ArrayList;

/**
 * Exception for validation errors
 */
public class ValidationException extends ChatbotException {
    
    private final List<ValidationError> validationErrors;
    
    public ValidationException(String message) {
        super(ErrorCode.VALIDATION_ERROR, message);
        this.validationErrors = new ArrayList<>();
    }
    
    public ValidationException(String message, List<ValidationError> validationErrors) {
        super(ErrorCode.VALIDATION_ERROR, message);
        this.validationErrors = validationErrors != null ? validationErrors : new ArrayList<>();
    }
    
    public ValidationException(ValidationError validationError) {
        super(ErrorCode.VALIDATION_ERROR, validationError.getMessage());
        this.validationErrors = new ArrayList<>();
        this.validationErrors.add(validationError);
    }
    
    public List<ValidationError> getValidationErrors() {
        return validationErrors;
    }
    
    public void addValidationError(ValidationError error) {
        this.validationErrors.add(error);
    }
    
    public boolean hasErrors() {
        return !validationErrors.isEmpty();
    }
    
    @Override
    public String getUserFriendlyMessage() {
        if (validationErrors.isEmpty()) {
            return super.getUserFriendlyMessage();
        }
        
        StringBuilder sb = new StringBuilder();
        sb.append("❌ Có lỗi xác thực:\n");
        for (ValidationError error : validationErrors) {
            sb.append("• ").append(error.getMessage()).append("\n");
        }
        return sb.toString().trim();
    }
    
    /**
     * Validation error details
     */
    public static class ValidationError {
        private final String field;
        private final String message;
        private final Object value;
        
        public ValidationError(String field, String message) {
            this(field, message, null);
        }
        
        public ValidationError(String field, String message, Object value) {
            this.field = field;
            this.message = message;
            this.value = value;
        }
        
        public String getField() {
            return field;
        }
        
        public String getMessage() {
            return message;
        }
        
        public Object getValue() {
            return value;
        }
    }
}