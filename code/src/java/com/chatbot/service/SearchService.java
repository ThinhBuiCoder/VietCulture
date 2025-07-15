package com.chatbot.service;

import com.chatbot.dao.TravelDAO;
import com.chatbot.model.Experience;
import com.chatbot.model.Accommodation;
import com.chatbot.utils.MessageParser;
import com.chatbot.utils.StringUtils;
import com.chatbot.constants.CityConstants;
import com.chatbot.constants.ChatConstants;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

public class SearchService {
    
    private final TravelDAO travelDAO;
    
    public SearchService() {
        this.travelDAO = new TravelDAO();
    }
    
    public SearchService(TravelDAO travelDAO) {
        this.travelDAO = travelDAO;
    }
    
    /**
     * Handle experience search requests
     */
    public String handleExperienceSearch(String message) {
        try {
            String city = MessageParser.extractCityFromMessage(message);
            String type = MessageParser.extractTypeFromMessage(message);
            String region = null;
            if (city == null) region = MessageParser.extractRegionFromMessage(message);
            
            StringBuilder response = new StringBuilder();
            response.append("🔍 KẾT QUẢ TÌM KIẾM TRẢI NGHIỆM:\n\n");
            
            List<Experience> experiences = new ArrayList<>();
            
            // Chuẩn hóa type cho truy vấn
            String normalizedType = mapExperienceType(type);
            String normalizedRegion = mapRegion(region);
            
            // Nếu hỏi về region + type
            if (normalizedType != null && city == null && normalizedRegion != null) {
                // 1. Gọi AI sinh đoạn văn giới thiệu
                String aiIntro = "";
                try {
                    aiIntro = new com.chatbot.GeminiApiClient(com.chatbot.constants.ChatConstants.GEMINI_API_KEY)
                        .generateResponse("Giới thiệu về " + type + " " + region + " Việt Nam");
                } catch (Exception e) {
                    aiIntro = "";
                }
                response = new StringBuilder();
                response.append(aiIntro).append("\n\n");
                // 2. Lấy 3 trải nghiệm thực tế (dùng normalizedType)
                List<Experience> regionTypeExps = getRandomExperiencesByRegionAndType(normalizedRegion, normalizedType, 3);
                if (!regionTypeExps.isEmpty()) {
                    response.append("🌟 Gợi ý trải nghiệm thực tế:\n");
                    appendExperienceList(response, regionTypeExps);
                } else {
                    response.append(getRegionTypeDescription(region, type));
                }
                return response.toString();
            }
            
            // Search by city and type
            if (city != null && normalizedType != null) {
                experiences = travelDAO.getExperiencesByCityAndType(city, normalizedType, 5);
                if (experiences.isEmpty()) {
                    return handleNoExperienceResults(city, type, region);
               }
           } else if (city != null) {
               experiences = travelDAO.getExperiencesByCity(city, 5);
           } else if (normalizedType != null) {
               experiences = travelDAO.getExperiencesByType(normalizedType, 5);
           } else {
               experiences = travelDAO.getAllExperiences(5);
           }
           
           if (experiences.isEmpty()) {
               return String.format(ChatConstants.NO_RESULTS_FOUND, "trải nghiệm");
           }
           
           appendExperienceList(response, experiences);
           return response.toString();
           
       } catch (Exception e) {
           e.printStackTrace();
           return ChatConstants.ERROR_SEARCH_EXPERIENCE;
       }
   }
   
   public List<Experience> getRandomExperiencesByRegionAndType(String region, String type, int limit) {
       List<Experience> all;
       try {
           all = travelDAO.getExperiencesByRegionAndType(mapRegion(region), mapExperienceType(type), 20);
       } catch (Exception e) {
           all = new ArrayList<>();
       }
       Collections.shuffle(all);
       return all.subList(0, Math.min(limit, all.size()));
   }
   
   /**
    * Handle accommodation search requests
    */
   public String handleAccommodationSearch(String message) {
       try {
           String city = MessageParser.extractCityFromMessage(message);
           String type = MessageParser.extractAccommodationTypeFromMessage(message);
           String priceRange = MessageParser.extractPriceRangeFromMessage(message);
           
           StringBuilder response = new StringBuilder();
           response.append("🏠 KẾT QUẢ TÌM KIẾM CHỖ Ở:\n\n");
           
           List<Accommodation> accommodations = new ArrayList<>();
           
           // Priority: Filter by price first
           if (priceRange != null) {
               return handlePriceRangeSearch(priceRange, city, response);
           }
           
           if (city != null) {
               accommodations = travelDAO.getAccommodationsByCity(city, 5);
           } else if (type != null) {
               accommodations = travelDAO.getAccommodationsByType(type, 5);
           } else {
               accommodations = travelDAO.getAllAccommodations(5);
           }
           
           if (accommodations.isEmpty()) {
               return String.format(ChatConstants.NO_RESULTS_FOUND, "chỗ ở");
           }
           
           appendAccommodationList(response, accommodations);
           return response.toString();
           
       } catch (Exception e) {
           return ChatConstants.ERROR_SEARCH_ACCOMMODATION;
       }
   }
   
   private String mapExperienceType(String type) {
       if (type == null) return null;
       switch (type.toLowerCase()) {
           case "ẩm thực": return "Food";
           case "văn hóa": return "Culture";
           case "phiêu lưu": return "Adventure";
           case "lịch sử": return "History";
           case "thiên nhiên": return "Nature";
           case "nghệ thuật": return "Art";
           default: return type;
       }
   }
   
   private String mapRegion(String region) {
       if (region == null) return null;
       switch (region.toLowerCase()) {
           case "bắc": case "miền bắc": return "North";
           case "trung": case "miền trung": return "Central";
           case "nam": case "miền nam": return "South";
           default: return region;
       }
   }
   
   private String handleNoExperienceResults(String city, String normalizedType, String region) {
       String regionCity = CityConstants.CITY_REGION_MAP.get(city);
       
       // Suggest same type in other cities within region
       if (regionCity != null) {
           try {
               List<Experience> regionTypeExps = travelDAO.getExperiencesByRegionAndType(mapRegion(regionCity), mapExperienceType(normalizedType), 5);
               if (!regionTypeExps.isEmpty()) {
                   StringBuilder response = new StringBuilder();
                   response.append("❗ Hiện chưa có trải nghiệm ").append(normalizedType).append(" tại ").append(StringUtils.capitalize(city)).append(".\n");
                   response.append("👉 Bạn có thể tham khảo trải nghiệm ").append(normalizedType).append(" ở các thành phố khác trong khu vực ").append(regionCity).append(":\n");
                   
                   for (Experience exp : regionTypeExps) {
                       if (!exp.getCityName().equalsIgnoreCase(city)) {
                           response.append("• ").append(exp.getTitle()).append(" - ").append(exp.getCityName()).append(" - ").append(exp.getFormattedPrice()).append("\n");
                       }
                   }
                   return response.toString();
               }
           } catch (Exception e) {
               return ChatConstants.ERROR_SEARCH_EXPERIENCE;
           }
       }
       
       return getTypeDescription(city, normalizedType);
   }
   
   private String getRegionTypeDescription(String region, String normalizedType) {
       if (normalizedType.equals("Văn hóa")) {
           return "🌄 Trải nghiệm văn hóa ở miền " + region + ":\n- Khám phá di tích lịch sử, làng nghề truyền thống, lễ hội dân gian, ẩm thực đặc trưng và giao lưu với người dân địa phương.";
       } else if (normalizedType.equals("Ẩm thực")) {
           return "🍜 Ẩm thực miền " + region + ":\n- Thưởng thức các món ăn đặc sản vùng miền, chợ truyền thống, trải nghiệm nấu ăn cùng người bản địa.";
       } else if (normalizedType.equals("Phiêu lưu")) {
           return "⛰️ Trải nghiệm phiêu lưu miền " + region + ":\n- Trekking, leo núi, khám phá hang động, chèo thuyền, lặn biển...";
       } else {
           return "🌟 Trải nghiệm " + normalizedType + " ở miền " + region + ":\n- Đa dạng hoạt động, hãy hỏi cụ thể hơn hoặc thử thành phố lớn trong vùng!";
       }
   }
   
   private String getTypeDescription(String city, String normalizedType) {
       if (normalizedType.equals("Văn hóa")) {
           return "🏛️ " + StringUtils.capitalize(city) + " nổi bật với các di tích lịch sử, kiến trúc đặc sắc, lễ hội truyền thống và văn hóa địa phương phong phú.";
       } else if (normalizedType.equals("Ẩm thực")) {
           return "🍜 Ẩm thực " + StringUtils.capitalize(city) + ": Đặc sản địa phương, chợ truyền thống, món ăn đường phố hấp dẫn.";
       } else if (normalizedType.equals("Phiêu lưu")) {
           return "⛰️ " + StringUtils.capitalize(city) + ": Trekking, khám phá thiên nhiên, các hoạt động ngoài trời hấp dẫn.";
       } else {
           return "🌟 " + StringUtils.capitalize(city) + ": Đa dạng hoạt động, hãy hỏi cụ thể hơn hoặc thử loại hình khác!";
       }
   }
   
   private String handlePriceRangeSearch(String priceRange, String city, StringBuilder response) {
       double min = 0, max = Double.MAX_VALUE;
       
       if (priceRange.endsWith("+")) {
           min = Double.parseDouble(priceRange.replace("+", ""));
       } else {
           String[] parts = priceRange.split("-");
           if (parts.length == 2) {
               min = Double.parseDouble(parts[0]);
               max = Double.parseDouble(parts[1]);
           }
       }
       
       List<Accommodation> accommodations;
       try {
           accommodations = travelDAO.getAccommodationsByPriceRangeAndCity(min, max, city, 5);
       } catch (Exception e) {
           response.append(ChatConstants.ERROR_SEARCH_ACCOMMODATION);
           return response.toString();
       }
       
       if (accommodations.isEmpty()) {
           response.append("❌ Không tìm thấy chỗ ở phù hợp với mức giá này. Vui lòng thử khoảng giá khác hoặc thành phố khác.\n");
           return response.toString();
       }
       
       appendAccommodationList(response, accommodations);
       return response.toString();
   }
   
   private void appendExperienceList(StringBuilder response, List<Experience> experiences) {
       for (Experience exp : experiences) {
           response.append("🎯 ").append(exp.getTitle()).append("\n");
           response.append("💰 ").append(exp.getFormattedPrice()).append("\n");
           response.append("📍 ").append(exp.getLocation()).append("\n");
           response.append("⭐ ").append(exp.getAverageRating()).append("/5 (").append(exp.getTotalBookings()).append(" lượt đặt)\n");
           response.append("🏷️ ").append(exp.getType()).append(" | ").append(exp.getDifficulty()).append("\n");
           response.append("⏱️ ").append(exp.getDuration()).append(" | 👥 ").append(exp.getMaxGroupSize()).append(" người\n");
           response.append("📝 ").append(exp.getDescription()).append("\n\n");
       }
   }
   
   private void appendAccommodationList(StringBuilder response, List<Accommodation> accommodations) {
       for (Accommodation acc : accommodations) {
           response.append("🏨 ").append(acc.getName()).append("\n");
           response.append("💰 ").append(acc.getFormattedPrice()).append("/đêm\n");
           response.append("📍 ").append(acc.getAddress()).append("\n");
           response.append("⭐ ").append(acc.getAverageRating()).append("/5 (").append(acc.getTotalBookings()).append(" lượt đặt)\n");
           response.append("👥 ").append(acc.getFormattedOccupancy()).append(" | ").append(acc.getType()).append("\n");
           response.append("📝 ").append(acc.getDescription()).append("\n\n");
       }
   }
}