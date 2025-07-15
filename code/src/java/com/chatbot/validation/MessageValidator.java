package com.chatbot.validation;

import com.chatbot.exception.ValidationException;
import com.chatbot.exception.ValidationException.ValidationError;
import com.chatbot.exception.ErrorCode;
import com.chatbot.utils.StringUtils;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Validator for user messages and inputs
 */
public class MessageValidator {
    
    private static final int MAX_MESSAGE_LENGTH = 1000;
    private static final int MIN_MESSAGE_LENGTH = 1;
    
    // Patterns for detecting unsafe content
    private static final Pattern SCRIPT_PATTERN = Pattern.compile("(?i)<script[^>]*>.*?</script>");
    private static final Pattern HTML_PATTERN = Pattern.compile("<[^>]+>");
    private static final Pattern SQL_INJECTION_PATTERN = Pattern.compile("(?i)(union|select|insert|update|delete|drop|create|alter|exec|execute)\\s");
    private static final Pattern XSS_PATTERN = Pattern.compile("(?i)(javascript:|vbscript:|onload=|onerror=|onclick=)");
    
    /**
     * Validate user message
     */
    public static void validateMessage(String message) throws ValidationException {
        List<ValidationError> errors = new ArrayList<>();
        
        // Check if message is null or empty
        if (StringUtils.isEmpty(message)) {
            errors.add(new ValidationError("message", "Tin nhắn không được để trống"));
        } else {
            String trimmed = message.trim();
            
            // Check length
            if (trimmed.length() < MIN_MESSAGE_LENGTH) {
                errors.add(new ValidationError("message", "Tin nhắn quá ngắn"));
            }
            
            if (trimmed.length() > MAX_MESSAGE_LENGTH) {
                errors.add(new ValidationError("message", "Tin nhắn quá dài (tối đa " + MAX_MESSAGE_LENGTH + " ký tự)"));
            }
            
            // Check for unsafe content
            if (containsUnsafeContent(trimmed)) {
                errors.add(new ValidationError("message", "Tin nhắn chứa nội dung không an toàn"));
            }
        }
        
        if (!errors.isEmpty()) {
            throw new ValidationException("Validation failed", errors);
        }
    }
    
    /**
     * Validate and sanitize message
     */
    public static String validateAndSanitize(String message) throws ValidationException {
        validateMessage(message);
        return sanitizeMessage(message);
    }
    
    /**
     * Sanitize user message
     */
    public static String sanitizeMessage(String message) {
        if (StringUtils.isEmpty(message)) {
            return message;
        }
        
        String sanitized = message.trim();
        
        // Remove HTML tags
        sanitized = HTML_PATTERN.matcher(sanitized).replaceAll("");
        
        // Remove script tags
        sanitized = SCRIPT_PATTERN.matcher(sanitized).replaceAll("");
        
        // Remove potential XSS content
        sanitized = XSS_PATTERN.matcher(sanitized).replaceAll("");
        
        // Escape special characters
        sanitized = escapeSpecialCharacters(sanitized);
        
        return sanitized;
    }
    
    /**
     * Check if message contains unsafe content
     */
    private static boolean containsUnsafeContent(String message) {
        if (StringUtils.isEmpty(message)) {
            return false;
        }
        
        String lower = message.toLowerCase();
        
        // Check for script tags
        if (SCRIPT_PATTERN.matcher(message).find()) {
            return true;
        }
        
        // Check for SQL injection patterns
        if (SQL_INJECTION_PATTERN.matcher(lower).find()) {
            return true;
        }
        
        // Check for XSS patterns
        if (XSS_PATTERN.matcher(lower).find()) {
            return true;
        }
        
        // Check for other suspicious patterns
        String[] suspiciousPatterns = {
            "eval(", "document.cookie", "document.write", 
            "window.location", "alert(", "confirm(",
            "prompt(", "setTimeout(", "setInterval("
        };
        
        for (String pattern : suspiciousPatterns) {
            if (lower.contains(pattern)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Escape special characters
     */
    private static String escapeSpecialCharacters(String input) {
        if (input == null) {
            return null;
        }
        
        return input
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;")
            .replace("/", "&#x2F;");
    }
    
    /**
     * Validate search criteria
     */
    public static void validateSearchCriteria(String query, Integer limit, Integer offset) throws ValidationException {
        List<ValidationError> errors = new ArrayList<>();
        
        if (!StringUtils.isEmpty(query)) {
            if (query.trim().length() > 100) {
                errors.add(new ValidationError("query", "Từ khóa tìm kiếm quá dài"));
            }
            
            if (containsUnsafeContent(query)) {
                errors.add(new ValidationError("query", "Từ khóa chứa nội dung không an toàn"));
            }
        }
        
        if (limit != null && (limit < 1 || limit > 50)) {
            errors.add(new ValidationError("limit", "Giới hạn phải từ 1 đến 50"));
        }
        
        if (offset != null && offset < 0) {
            errors.add(new ValidationError("offset", "Offset không được âm"));
        }
        
        if (!errors.isEmpty()) {
            throw new ValidationException("Search criteria validation failed", errors);
        }
    }
    
    /**
     * Validate price range
     */
    public static void validatePriceRange(Double minPrice, Double maxPrice) throws ValidationException {
        List<ValidationError> errors = new ArrayList<>();
        
        if (minPrice != null && minPrice < 0) {
            errors.add(new ValidationError("minPrice", "Giá tối thiểu không được âm"));
        }
        
        if (maxPrice != null && maxPrice < 0) {
            errors.add(new ValidationError("maxPrice", "Giá tối đa không được âm"));
        }
        
        if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
            errors.add(new ValidationError("priceRange", "Giá tối thiểu không được lớn hơn giá tối đa"));
        }
        
        if (!errors.isEmpty()) {
            throw new ValidationException("Price range validation failed", errors);
        }
    }
}