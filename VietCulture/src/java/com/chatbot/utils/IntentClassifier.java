package com.chatbot.utils;

public class IntentClassifier {
    
    public enum Intent {
        WEATHER_INFO,
        BEST_TIME_INFO,
        ACTIVITY_WEATHER_INFO,
        EXPERIENCE_SEARCH,
        ACCOMMODATION_SEARCH,
        BOOKING_GUIDE,
        REVIEW_GUIDE,
        COMPLAINT_GUIDE,
        CHAT_GUIDE,
        FAVORITE_GUIDE,
        TRANSACTION_INFO,
        ACCOUNT_GUIDE,
        HOST_MANAGEMENT_GUIDE,
        SYSTEM_INFO,
        PASSWORD_GUIDE,
        CREATE_EXPERIENCE_GUIDE,
        PERSONALIZED_RECOMMENDATION,
        ITINERARY_SUGGESTION,
        CULTURAL_QA,
        AVOID_HOT_WEATHER,
        MONTHLY_DESTINATION,
        CITY_SELECTION,
        DEFAULT_RESPONSE
    }
    
    /**
     * Classify user intent based on message content
     */
    public static Intent classifyIntent(String message) {
        String normalizedMessage = message.toLowerCase().trim();
        String noAccent = removeAccents(normalizedMessage);
        // Ưu tiên nhận diện intent EXPERIENCE_SEARCH nếu có city và type
        String city = MessageParser.extractCityFromMessage(normalizedMessage);
        String type = MessageParser.extractTypeFromMessage(normalizedMessage);
        if (city != null && type != null) {
            return Intent.EXPERIENCE_SEARCH;
        }
        // Ưu tiên nhận diện intent thời tiết nếu có city và month
        Integer monthNum = MessageParser.extractMonthNumberFromMessage(normalizedMessage);
        if (city != null && monthNum != null) {
            return Intent.WEATHER_INFO;
        }
        
        // Priority order matters!
        
        // Highest priority: Password change
        if (containsPasswordIntent(normalizedMessage, noAccent)) {
            return Intent.PASSWORD_GUIDE;
        }
        
        // Hot weather avoidance
        if (containsAvoidHotWeatherIntent(normalizedMessage)) {
            return Intent.AVOID_HOT_WEATHER;
        }
        
        // Monthly destination suggestions
        if (monthNum != null && containsDestinationSuggestionIntent(normalizedMessage)) {
            return Intent.MONTHLY_DESTINATION;
        }
        
        // Create experience guide
        if (containsCreateExperienceIntent(normalizedMessage)) {
            return Intent.CREATE_EXPERIENCE_GUIDE;
        }
        
        // Itinerary suggestions
        if (containsItinerarySuggestionIntent(normalizedMessage)) {
            return Intent.ITINERARY_SUGGESTION;
        }
        
        // Personalized recommendations
        if (containsPersonalizedRecommendationIntent(normalizedMessage)) {
            return Intent.PERSONALIZED_RECOMMENDATION;
        }
        
        // Cultural Q&A
        if (containsCulturalQAIntent(normalizedMessage)) {
            return Intent.CULTURAL_QA;
        }
        
        // Booking operations
        if (containsBookingIntent(normalizedMessage)) {
            return Intent.BOOKING_GUIDE;
        }
        
        // Search operations
        if (containsExperienceSearchIntent(normalizedMessage)) {
            return Intent.EXPERIENCE_SEARCH;
        }
        
        if (containsAccommodationSearchIntent(normalizedMessage)) {
            return Intent.ACCOMMODATION_SEARCH;
        }
        
        // Guide operations
        if (containsReviewIntent(normalizedMessage)) {
            return Intent.REVIEW_GUIDE;
        }
        
        if (containsComplaintIntent(normalizedMessage)) {
            return Intent.COMPLAINT_GUIDE;
        }
        
        if (containsChatIntent(normalizedMessage)) {
            return Intent.CHAT_GUIDE;
        }
        
        if (containsFavoriteIntent(normalizedMessage)) {
            return Intent.FAVORITE_GUIDE;
        }
        
        if (containsTransactionIntent(normalizedMessage)) {
            return Intent.TRANSACTION_INFO;
        }
        
        if (containsAccountIntent(normalizedMessage)) {
            return Intent.ACCOUNT_GUIDE;
        }
        
        if (containsHostManagementIntent(normalizedMessage)) {
            return Intent.HOST_MANAGEMENT_GUIDE;
        }
        
        if (containsSystemInfoIntent(normalizedMessage)) {
            return Intent.SYSTEM_INFO;
        }
        
        // Weather and time related
        if (containsWeatherIntent(normalizedMessage)) {
            return Intent.WEATHER_INFO;
        }
        
        if (containsBestTimeIntent(normalizedMessage)) {
            return Intent.BEST_TIME_INFO;
        }
        
        if (containsActivityWeatherIntent(normalizedMessage)) {
            return Intent.ACTIVITY_WEATHER_INFO;
        }
        
        // City selection
        if (MessageParser.extractCityFromMessage(normalizedMessage) != null) {
            return Intent.CITY_SELECTION;
        }
        
        return Intent.DEFAULT_RESPONSE;
    }
    
    private static boolean containsPasswordIntent(String normalizedMessage, String noAccent) {
        return normalizedMessage.contains("mật khẩu") ||
               normalizedMessage.contains("pass") ||
               noAccent.contains("mat khau") ||
               noAccent.contains("pass");
    }
    
    private static boolean containsAvoidHotWeatherIntent(String normalizedMessage) {
        return normalizedMessage.contains("tránh nóng") ||
               normalizedMessage.contains("trời nóng") ||
               normalizedMessage.contains("hè đi đâu") ||
               normalizedMessage.contains("du lịch hè") ||
               normalizedMessage.contains("mát mẻ") ||
               normalizedMessage.contains("đi đâu mát");
    }
    
    private static boolean containsDestinationSuggestionIntent(String normalizedMessage) {
        return normalizedMessage.contains("nên đi đâu") ||
               normalizedMessage.contains("du lịch ở đâu") ||
               normalizedMessage.contains("gợi ý") ||
               normalizedMessage.contains("đi đâu") ||
               normalizedMessage.contains("du lịch tháng") ||
               normalizedMessage.contains("nơi nào") ||
               normalizedMessage.contains("địa điểm nào");
    }
    
    private static boolean containsCreateExperienceIntent(String normalizedMessage) {
        return normalizedMessage.contains("cách tạo trải nghiệm") ||
               normalizedMessage.contains("hướng dẫn tạo trải nghiệm") ||
               normalizedMessage.contains("tạo trải nghiệm") ||
               normalizedMessage.contains("đăng trải nghiệm") ||
               normalizedMessage.contains("tạo mới trải nghiệm") ||
               normalizedMessage.contains("làm sao để tạo trải nghiệm") ||
               normalizedMessage.contains("how to create experience") ||
               normalizedMessage.contains("add experience") ||
               normalizedMessage.contains("create experience");
    }
    
    private static boolean containsItinerarySuggestionIntent(String normalizedMessage) {
        return normalizedMessage.contains("lịch trình") ||
               normalizedMessage.contains("tour gợi ý") ||
               normalizedMessage.contains("gợi ý tour") ||
               normalizedMessage.contains("gợi ý lịch trình") ||
               normalizedMessage.contains("tour theo sở thích") ||
               normalizedMessage.contains("tư vấn lịch trình") ||
               normalizedMessage.contains("tư vấn tour");
    }
    
    private static boolean containsPersonalizedRecommendationIntent(String normalizedMessage) {
        return normalizedMessage.contains("gợi ý cá nhân") ||
               normalizedMessage.contains("cá nhân hóa") ||
               normalizedMessage.contains("dựa trên lịch sử") ||
               normalizedMessage.contains("gợi ý cho tôi") ||
               normalizedMessage.contains("gợi ý trải nghiệm của tôi") ||
               normalizedMessage.contains("gợi ý chỗ ở của tôi");
    }
    
    private static boolean containsCulturalQAIntent(String normalizedMessage) {
        return normalizedMessage.contains("văn hóa") ||
               normalizedMessage.contains("ẩm thực") ||
               normalizedMessage.contains("sự kiện") ||
               normalizedMessage.contains("lễ hội") ||
               normalizedMessage.contains("phong tục") ||
               normalizedMessage.contains("đặc sản") ||
               normalizedMessage.contains("món ăn") ||
               normalizedMessage.contains("truyền thống");
    }
    
    private static boolean containsBookingIntent(String normalizedMessage) {
        return (normalizedMessage.contains("đặt") || normalizedMessage.contains("tham gia") || 
                normalizedMessage.contains("mua vé") || normalizedMessage.contains("book") || 
                normalizedMessage.contains("tham dự") || normalizedMessage.contains("đăng ký")) &&
               (normalizedMessage.contains("trải nghiệm") || normalizedMessage.contains("chỗ ở") || 
                normalizedMessage.contains("lưu trú") || normalizedMessage.contains("homestay") || 
                normalizedMessage.contains("khách sạn") || normalizedMessage.contains("resort") || 
                normalizedMessage.contains("accommodation"));
    }
    
    private static boolean containsExperienceSearchIntent(String normalizedMessage) {
        return normalizedMessage.contains("tìm") || normalizedMessage.contains("search") || 
               normalizedMessage.contains("trải nghiệm") || normalizedMessage.contains("experience");
    }
    
    private static boolean containsAccommodationSearchIntent(String normalizedMessage) {
        return normalizedMessage.contains("chỗ ở") || normalizedMessage.contains("khách sạn") || 
               normalizedMessage.contains("homestay") || normalizedMessage.contains("resort") ||
               normalizedMessage.contains("accommodation") || normalizedMessage.contains("lưu trú");
    }
    
    private static boolean containsReviewIntent(String normalizedMessage) {
        return normalizedMessage.contains("đánh giá") || normalizedMessage.contains("review") || 
               normalizedMessage.contains("rating");
    }
    
    private static boolean containsComplaintIntent(String normalizedMessage) {
        return normalizedMessage.contains("khiếu nại") || normalizedMessage.contains("complaint");
    }
    
    private static boolean containsChatIntent(String normalizedMessage) {
        return normalizedMessage.contains("chat") || normalizedMessage.contains("nhắn tin");
    }
    
    private static boolean containsFavoriteIntent(String normalizedMessage) {
        return normalizedMessage.contains("yêu thích") || normalizedMessage.contains("favorite");
    }
    
    private static boolean containsTransactionIntent(String normalizedMessage) {
        return normalizedMessage.contains("giao dịch") || normalizedMessage.contains("transaction") ||
               normalizedMessage.contains("rút tiền") || normalizedMessage.contains("nạp tiền");
    }
    
    private static boolean containsAccountIntent(String normalizedMessage) {
        return normalizedMessage.contains("tài khoản") || normalizedMessage.contains("account") ||
               normalizedMessage.contains("profile");
    }
    
    private static boolean containsHostManagementIntent(String normalizedMessage) {
        return normalizedMessage.contains("quản lý") || normalizedMessage.contains("manage") ||
               normalizedMessage.contains("tạo") || normalizedMessage.contains("create");
    }
    
    private static boolean containsSystemInfoIntent(String normalizedMessage) {
        return normalizedMessage.contains("hệ thống") || normalizedMessage.contains("system") ||
               normalizedMessage.contains("vietculture") || normalizedMessage.contains("platform");
    }
    
    private static boolean containsWeatherIntent(String normalizedMessage) {
        return normalizedMessage.contains("thời tiết") || normalizedMessage.contains("weather") ||
               normalizedMessage.contains("khí hậu") || normalizedMessage.contains("mưa") ||
               normalizedMessage.contains("nắng") || normalizedMessage.contains("lạnh") ||
               normalizedMessage.contains("nóng") || normalizedMessage.contains("bão") ||
               normalizedMessage.contains("sương mù") || normalizedMessage.contains("lũ");
    }
    
    private static boolean containsBestTimeIntent(String normalizedMessage) {
        return normalizedMessage.contains("thời gian") || normalizedMessage.contains("khi nào") ||
               normalizedMessage.contains("tháng nào") || normalizedMessage.contains("mùa") ||
               normalizedMessage.contains("nên đi") || normalizedMessage.contains("không nên") ||
               normalizedMessage.contains("lý tưởng") || normalizedMessage.contains("tránh");
    }
    
    private static boolean containsActivityWeatherIntent(String normalizedMessage) {
        return normalizedMessage.contains("biển") || normalizedMessage.contains("tắm") ||
               normalizedMessage.contains("trekking") || normalizedMessage.contains("leo núi") ||
               normalizedMessage.contains("chụp ảnh") || normalizedMessage.contains("festival") ||
               normalizedMessage.contains("lễ hội") || normalizedMessage.contains("du lịch");
    }
    
    /**
     * Remove Vietnamese accents for better matching
     */
    private static String removeAccents(String text) {
        return text
            .replace("đ", "d").replace("Đ", "D")
            .replaceAll("[áàảãạâấầẩẫậăắằẳẵặ]", "a")
            .replaceAll("[éèẻẽẹêếềểễệ]", "e")
            .replaceAll("[íìỉĩị]", "i")
            .replaceAll("[óòỏõọôốồổỗộơớờởỡợ]", "o")
            .replaceAll("[úùủũụưứừửữự]", "u")
            .replaceAll("[ýỳỷỹỵ]", "y");
    }
}