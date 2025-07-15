package com.chatbot.service;

import com.chatbot.dao.TravelDAO;
import com.chatbot.model.User;
import com.chatbot.model.Experience;
import com.chatbot.GeminiApiClient;
import com.chatbot.constants.ChatConstants;
import java.util.List;

public class RecommendationService {
    
    private final TravelDAO travelDAO;
    private final GeminiApiClient geminiClient;
    
    public RecommendationService() {
        this.travelDAO = new TravelDAO();
        this.geminiClient = new GeminiApiClient(ChatConstants.GEMINI_API_KEY);
    }
    
    public RecommendationService(TravelDAO travelDAO, GeminiApiClient geminiClient) {
        this.travelDAO = travelDAO;
        this.geminiClient = geminiClient;
    }
    
    /**
     * Handle itinerary suggestion requests
     */
    public String handleItinerarySuggestion(String userMessage, User currentUser) {
        String[] preferences = new String[0];
        if (currentUser != null) {
            try {
                User traveler = (User) currentUser;
                if (traveler.getPreferences() != null) {
                    preferences = traveler.getPreferenceList();
                }
            } catch (Exception ex) {
                // fallback if not User type
            }
        }
        
        List<Experience> recommended = getRecommendedExperiences(preferences);
        
        StringBuilder sb = new StringBuilder();
        sb.append("🗺️ GỢI Ý LỊCH TRÌNH/TƯ VẤN TOUR THEO SỞ THÍCH:\n\n");
        
        if (recommended.isEmpty()) {
            sb.append("Hiện chưa có tour phù hợp với sở thích của bạn. Hãy thử lại sau!");
        } else {
            for (Experience exp : recommended) {
                sb.append("• ").append(exp.getTitle())
                  .append(" (Loại: ").append(exp.getType()).append(") - ")
                  .append(exp.getCityName()).append(" - ")
                  .append(exp.getFormattedPrice()).append("\n");
            }
            sb.append("\nBạn muốn lên lịch trình chi tiết cho thành phố nào? Hãy nhập tên thành phố!");
        }
        
        return sb.toString();
    }
    
    /**
     * Handle personalized recommendation requests
     */
    public String handlePersonalizedRecommendation(String userMessage, User currentUser) {
        if (currentUser != null) {
            List<Experience> recs;
            try {
                recs = travelDAO.getRecommendedExperiences(currentUser.getEmail(), 5);
            } catch (Exception e) {
                recs = new java.util.ArrayList<>();
            }
            StringBuilder sb = new StringBuilder();
            sb.append("🤖 GỢI Ý CÁ NHÂN DỰA TRÊN LỊCH SỬ ĐẶT CHỖ/YÊU THÍCH:\n\n");
            
            if (recs.isEmpty()) {
                sb.append("Bạn chưa có lịch sử đặt chỗ hoặc mục yêu thích nào. Hãy thử đặt trải nghiệm/chỗ ở để nhận gợi ý cá nhân hóa!");
            } else {
                for (Experience exp : recs) {
                    sb.append("• ").append(exp.getTitle())
                      .append(" (Loại: ").append(exp.getType()).append(") - ")
                      .append(exp.getCityName()).append(" - ")
                      .append(exp.getFormattedPrice()).append("\n");
                }
            }
            return sb.toString();
        } else {
            return "Vui lòng đăng nhập để nhận gợi ý cá nhân hóa!";
        }
    }
    
    /**
     * Handle cultural Q&A requests using Gemini AI
     */
    public String handleCulturalQA(String userMessage) {
        try {
            String aiAnswer = geminiClient.generateResponse("Trả lời ngắn gọn, thân thiện về: " + userMessage);
            return aiAnswer;
        } catch (Exception ex) {
            return "Xin lỗi, tôi chưa có thông tin về chủ đề này. Vui lòng thử lại sau!";
        }
    }
    
    private List<Experience> getRecommendedExperiences(String[] preferences) {
        List<Experience> recommended = new java.util.ArrayList<>();
        
        if (preferences.length > 0) {
            for (String pref : preferences) {
                try {
                    List<Experience> exps = travelDAO.getExperiencesByType(pref, 2);
                    recommended.addAll(exps);
                } catch (Exception e) {
                    // Nếu lỗi thì bỏ qua preference này
                }
            }
        } else {
            try {
                recommended = travelDAO.getPopularExperiences(5);
            } catch (Exception e) {
                recommended = new java.util.ArrayList<>();
            }
        }
        
        return recommended;
    }
}