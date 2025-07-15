package com.chatbot.constants;

public class ChatConstants {
    
    // API Keys
    public static final String GEMINI_API_KEY = "AIzaSyCC2rV9GppeSioqn-9U8KQvZODcQRVn0vI";
    
    // Chat settings
    public static final int MAX_CHAT_HISTORY = 10;
    public static final int DEFAULT_RESULTS_LIMIT = 5;
    
    // Welcome message
    public static final String WELCOME_MESSAGE = 
        "🌟 Xin chào! Tôi là trợ lý AI của VietCulture - nền tảng du lịch cộng đồng!\n\n" +
        "Tôi có thể giúp bạn:\n" +
        "🔍 Tìm kiếm trải nghiệm & chỗ ở\n" +
        "📅 Đặt chỗ & quản lý booking\n" +
        "⭐ Đánh giá & khiếu nại\n" +
        "💬 Chat với host/admin\n" +
        "❤️ Quản lý danh sách yêu thích\n" +
        "💰 Giao dịch tài chính\n" +
        "👤 Quản lý tài khoản\n\n" +
        "Bạn cần hỗ trợ gì?";
    
    // Error messages
    public static final String ERROR_PROCESSING_MESSAGE = "❌ Có lỗi xảy ra khi xử lý tin nhắn. Vui lòng thử lại.";
    public static final String ERROR_SEARCH_EXPERIENCE = "❌ Có lỗi khi tìm kiếm trải nghiệm. Vui lòng thử lại.";
    public static final String ERROR_SEARCH_ACCOMMODATION = "❌ Có lỗi khi tìm kiếm chỗ ở. Vui lòng thử lại.";
    public static final String ERROR_CHECK_BOOKING = "❌ Có lỗi khi kiểm tra trạng thái booking.";
    public static final String ERROR_VIEW_REVIEWS = "❌ Có lỗi khi xem đánh giá.";
    
    // Response patterns
    public static final String NO_RESULTS_FOUND = "❌ Không tìm thấy %s phù hợp. Vui lòng thử từ khóa khác.";
    public static final String LOGIN_REQUIRED = "🔐 Để %s:\n1. Đăng nhập vào tài khoản\n2. %s\n\nHoặc liên hệ hỗ trợ nếu cần hỗ trợ thêm.";
}