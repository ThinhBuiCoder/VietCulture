package com.chatbot.service;

import com.chatbot.model.User;
import com.chatbot.model.ChatMessage;
import com.chatbot.utils.IntentClassifier;
import com.chatbot.utils.IntentClassifier.Intent;
import com.chatbot.GeminiApiClient;
import com.chatbot.constants.ChatConstants;
import java.util.List;
import com.chatbot.exception.*;
import com.chatbot.validation.MessageValidator;
import com.chatbot.utils.Logger;
public class ResponseGenerator {
    
    private final WeatherService weatherService;
    private final SearchService searchService;
    private final GuideService guideService;
    private final RecommendationService recommendationService;
    private final CityService cityService;
    private final GeminiApiClient geminiClient;
    
    public ResponseGenerator() {
        this.weatherService = new WeatherService();
        this.searchService = new SearchService();
        this.guideService = new GuideService();
        this.recommendationService = new RecommendationService();
        this.cityService = new CityService();
        this.geminiClient = new GeminiApiClient(ChatConstants.GEMINI_API_KEY);
    }
    
    public ResponseGenerator(WeatherService weatherService, SearchService searchService, 
                           GuideService guideService, RecommendationService recommendationService,
                           CityService cityService, GeminiApiClient geminiClient) {
        this.weatherService = weatherService;
        this.searchService = searchService;
        this.guideService = guideService;
        this.recommendationService = recommendationService;
        this.cityService = cityService;
        this.geminiClient = geminiClient;
    }
    
    /**
     * Generate response based on user message and session context
     */
    public String generateResponse(String userMessage, Object session, List<ChatMessage> chatHistory) {
        try {
            // Lấy thông tin user từ session nếu có
            User currentUser = null;
            Object userObj = null;
            
            // Lấy attribute từ session thông qua reflection để tránh phụ thuộc vào kiểu HttpSession
            try {
                // Gọi session.getAttribute("user") bằng reflection
                java.lang.reflect.Method getAttributeMethod = session.getClass().getMethod("getAttribute", String.class);
                userObj = getAttributeMethod.invoke(session, "user");
                
                // Kiểm tra nếu userObj là kiểu com.chatbot.model.User
                if (userObj instanceof User) {
                    currentUser = (User) userObj;
                }
                // Trường hợp là model.User từ hệ thống chính - giữ currentUser là null
            } catch (Exception e) {
                // Bỏ qua exception, giữ currentUser là null
            }
            
            Intent intent = IntentClassifier.classifyIntent(userMessage);
            return handleIntent(intent, userMessage, currentUser, session);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ChatConstants.ERROR_PROCESSING_MESSAGE;
        }
    }
    
    private String handleIntent(Intent intent, String userMessage, User currentUser, Object session) {
        switch (intent) {
            case PASSWORD_GUIDE:
                return guideService.handlePasswordGuide(userMessage.toLowerCase(), currentUser);
                
            case AVOID_HOT_WEATHER:
                return weatherService.handleAvoidHotWeather();
                
            case MONTHLY_DESTINATION:
                return weatherService.handleWeatherInfo(userMessage);
                
            case CREATE_EXPERIENCE_GUIDE:
                return guideService.handleCreateExperienceGuide();
                
            case ITINERARY_SUGGESTION:
                return recommendationService.handleItinerarySuggestion(userMessage, currentUser);
                
            case PERSONALIZED_RECOMMENDATION:
                return recommendationService.handlePersonalizedRecommendation(userMessage, currentUser);
                
            case CULTURAL_QA:
                return recommendationService.handleCulturalQA(userMessage);
                
            case BOOKING_GUIDE:
                return handleBookingGuide(userMessage, currentUser);
                
            case EXPERIENCE_SEARCH:
                return searchService.handleExperienceSearch(userMessage);
                
            case ACCOMMODATION_SEARCH:
                return searchService.handleAccommodationSearch(userMessage);
                
            case REVIEW_GUIDE:
                return guideService.handleReviewGuide(userMessage, currentUser);
                
            case COMPLAINT_GUIDE:
                return guideService.handleComplaintGuide(userMessage, currentUser);
                
            case CHAT_GUIDE:
                return guideService.handleChatGuide(userMessage, currentUser);
                
            case FAVORITE_GUIDE:
                return guideService.handleFavoriteGuide(userMessage, currentUser);
                
            case TRANSACTION_INFO:
                return guideService.handleTransactionInfo(userMessage, currentUser);
                
            case ACCOUNT_GUIDE:
                return guideService.handleAccountGuide(userMessage, currentUser);
                
            case HOST_MANAGEMENT_GUIDE:
                return guideService.handleHostManagementGuide(userMessage, currentUser);
                
            case SYSTEM_INFO:
                return guideService.handleSystemInfo(userMessage);
                
            case WEATHER_INFO:
                return weatherService.handleWeatherInfo(userMessage);
                
            case BEST_TIME_INFO:
                return weatherService.handleBestTimeInfo(userMessage);
                
            case ACTIVITY_WEATHER_INFO:
                return weatherService.handleActivityWeatherInfo(userMessage);
                
            case CITY_SELECTION:
                String cityName = extractCityFromMessage(userMessage);
                if (cityName != null) {
                    try {
                        // Gọi session.setAttribute("userPreferredCity", cityName) bằng reflection
                        java.lang.reflect.Method setAttributeMethod = session.getClass().getMethod("setAttribute", String.class, Object.class);
                        setAttributeMethod.invoke(session, "userPreferredCity", cityName);
                    } catch (Exception e) {
                        // Bỏ qua nếu không thể set attribute
                    }
                    return cityService.handleCitySelection(cityName);
                }
                return getDefaultResponse(userMessage);
                
            case DEFAULT_RESPONSE:
            default:
                return getDefaultResponse(userMessage);
        }
    }
    
    private String handleBookingGuide(String userMessage, User currentUser) {
        String lower = userMessage.toLowerCase();
        
        if (lower.contains("đặt nhiều trải nghiệm") || lower.contains("đặt nhiều chỗ ở") ||
            lower.contains("đặt nhiều cùng lúc") || lower.contains("đặt nhiều booking") ||
            lower.contains("đặt nhiều dịch vụ")) {
            return "🔎 QUY ĐỊNH ĐẶT NHIỀU TRẢI NGHIỆM/CHỖ Ở:\n\n" +
                   "• Bạn có thể đặt nhiều trải nghiệm khác nhau, miễn là mỗi trải nghiệm còn slot trống và bạn không có các trải nghiệm khác trùng khung giờ/ngày đó.\n" +
                   "• Với lưu trú, bạn có thể đặt nhiều chỗ ở nếu còn phòng, nhưng hãy chắc chắn rằng bạn thực sự muốn lưu trú ở nhiều nơi cùng thời gian.\n" +
                   "• Hệ thống sẽ kiểm tra điều kiện trùng lặp thời gian khi bạn đặt.\n" +
                   "\n💡 Nếu cần hỗ trợ, hãy liên hệ host hoặc admin qua chức năng chat!";
        }
        
        if ((lower.contains("đặt") || lower.contains("tham gia") || lower.contains("mua vé") || 
             lower.contains("book") || lower.contains("tham dự") || lower.contains("đăng ký")) &&
            (lower.contains("trải nghiệm") || lower.contains("chỗ ở") || lower.contains("lưu trú") || 
             lower.contains("homestay") || lower.contains("khách sạn") || lower.contains("resort") || 
             lower.contains("accommodation"))) {
            return "📝 HƯỚNG DẪN ĐẶT TRẢI NGHIỆM/CHỖ Ở:\n\n" +
                   "1️⃣ Chọn trải nghiệm hoặc chỗ ở bạn muốn đặt trên hệ thống VietCulture.\n" +
                   "2️⃣ Nhấn nút 'Đặt chỗ' hoặc 'Đặt trải nghiệm'.\n" +
                   "3️⃣ Điền thông tin liên hệ, chọn ngày, số lượng người.\n" +
                   "4️⃣ Xác nhận đặt chỗ và thanh toán (nếu có).\n" +
                   "5️⃣ Kiểm tra email hoặc mục 'Quản lý booking' để xem trạng thái đặt chỗ.\n\n" +
                   "💡 Nếu cần hỗ trợ, hãy liên hệ host hoặc admin qua chức năng chat!";
        }
        
        return guideService.handleBookingGuide(userMessage, currentUser);
    }
    
    private String getDefaultResponse(String userMessage) {
        try {
            String aiReply = geminiClient.generateResponse(userMessage);
            if (aiReply != null && !aiReply.trim().isEmpty()) {
                return aiReply;
            }
        } catch (Exception e) {
            // Log error if needed
        }
        
        return "🤔 Tôi hiểu bạn muốn tìm hiểu về du lịch Việt Nam!\n\n" +
               "Hãy cho tôi biết cụ thể hơn:\n" +
               "• Bạn muốn đi đâu? (Hà Nội, Đà Nẵng, Hội An, Phú Quốc...)\n" +
               "• Thích loại hình gì? (Ẩm thực, Văn hóa, Phiêu lưu, Lịch sử)\n" +
               "• Ngân sách như thế nào?\n" +
               "• Đi bao nhiêu ngày?\n\n" +
               "Tôi sẽ tư vấn phù hợp nhất! 😊";
    }
    
    private String extractCityFromMessage(String message) {
        // Delegate to MessageParser utility
        return com.chatbot.utils.MessageParser.extractCityFromMessage(message);
    }
}