package com.chatbot.exception;

/**
 * Enumeration of error codes with user-friendly messages
 */
public enum ErrorCode {
    
    // General errors
    GENERAL_ERROR("GEN001", "❌ Có lỗi xảy ra. Vui lòng thử lại sau."),
    INVALID_INPUT("GEN002", "❌ Dữ liệu đầu vào không hợp lệ."),
    AUTHENTICATION_REQUIRED("GEN003", "🔐 Vui lòng đăng nhập để tiếp tục."),
    PERMISSION_DENIED("GEN004", "🚫 Bạn không có quyền thực hiện thao tác này."),
    
    // Search errors
    SEARCH_ERROR("SEA001", "❌ Có lỗi khi tìm kiếm. Vui lòng thử lại."),
    NO_RESULTS_FOUND("SEA002", "❌ Không tìm thấy kết quả phù hợp."),
    INVALID_SEARCH_CRITERIA("SEA003", "❌ Tiêu chí tìm kiếm không hợp lệ."),
    
    // Database errors
    DATABASE_ERROR("DB001", "❌ Có lỗi kết nối cơ sở dữ liệu. Vui lòng thử lại sau."),
    DATA_NOT_FOUND("DB002", "❌ Không tìm thấy dữ liệu yêu cầu."),
    DATA_INTEGRITY_ERROR("DB003", "❌ Dữ liệu không nhất quán. Vui lòng liên hệ hỗ trợ."),
    
    // External service errors
    AI_SERVICE_ERROR("EXT001", "❌ Dịch vụ AI tạm thời không khả dụng. Vui lòng thử lại sau."),
    WEATHER_SERVICE_ERROR("EXT002", "❌ Không thể lấy thông tin thời tiết. Vui lòng thử lại sau."),
    
    // Business logic errors
    BOOKING_ERROR("BIZ001", "❌ Có lỗi khi xử lý đặt chỗ. Vui lòng kiểm tra lại thông tin."),
    PAYMENT_ERROR("BIZ002", "❌ Có lỗi trong quá trình thanh toán. Vui lòng thử lại."),
    REVIEW_ERROR("BIZ003", "❌ Có lỗi khi xử lý đánh giá. Vui lòng thử lại."),
    
    // Session errors
    SESSION_EXPIRED("SES001", "🔒 Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại."),
    SESSION_INVALID("SES002", "🔒 Phiên làm việc không hợp lệ."),
    
    // Validation errors
    VALIDATION_ERROR("VAL001", "❌ Dữ liệu không hợp lệ."),
    MESSAGE_TOO_LONG("VAL002", "❌ Tin nhắn quá dài. Vui lòng rút gọn lại."),
    MESSAGE_EMPTY("VAL003", "❌ Tin nhắn không được để trống."),
    UNSAFE_CONTENT("VAL004", "❌ Nội dung không an toàn đã được phát hiện.");
    
    private final String code;
    private final String userFriendlyMessage;
    
    ErrorCode(String code, String userFriendlyMessage) {
        this.code = code;
        this.userFriendlyMessage = userFriendlyMessage;
    }
    
    public String getCode() {
        return code;
    }
    
    public String getUserFriendlyMessage() {
        return userFriendlyMessage;
    }
}