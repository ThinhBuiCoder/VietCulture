package com.chatbot.service;

import com.chatbot.dao.TravelDAO;
import com.chatbot.model.City;
import com.chatbot.model.Experience;
import com.chatbot.model.Accommodation;
import java.util.List;

public class CityService {
    
    private final TravelDAO travelDAO;
    
    public CityService() {
        this.travelDAO = new TravelDAO();
    }
    
    public CityService(TravelDAO travelDAO) {
        this.travelDAO = travelDAO;
    }
    
    /**
     * Handle city selection and provide city information
     */
    public String handleCitySelection(String cityName) {
        try {
            List<City> cities = travelDAO.getAllCities();
            City selectedCity = findCityByName(cities, cityName);
            
            if (selectedCity == null) {
                return "❌ Không tìm thấy thông tin về thành phố này.";
            }
            
            List<Experience> experiences = travelDAO.getExperiencesByCity(selectedCity.getVietnameseName(), 3);
            List<Accommodation> accommodations = travelDAO.getAccommodationsByCity(selectedCity.getVietnameseName(), 2);
            
            return buildCityResponse(selectedCity, experiences, accommodations);
            
        } catch (Exception e) {
            return "❌ Có lỗi khi tải thông tin thành phố. Vui lòng thử lại.";
        }
    }
    
    /**
     * Get all available cities
     */
    public List<City> getAllCities() {
        try {
            return travelDAO.getAllCities();
        } catch (Exception e) {
            return new java.util.ArrayList<>();
        }
    }
    
    private City findCityByName(List<City> cities, String cityName) {
        String normalizedCityName = cityName.toLowerCase();
        
        for (City city : cities) {
            if (normalizedCityName.contains(city.getVietnameseName().toLowerCase()) || 
                normalizedCityName.contains(city.getName().toLowerCase())) {
                return city;
            }
        }
        
        return null;
    }
    
    private String buildCityResponse(City city, List<Experience> experiences, List<Accommodation> accommodations) {
        StringBuilder response = new StringBuilder();
        response.append("🌟 ").append(city.getVietnameseName()).append(" - Điểm đến tuyệt vời!\n\n");
        
        if (!experiences.isEmpty()) {
            response.append("🎯 TRẢI NGHIỆM NỔI BẬT:\n");
            for (Experience exp : experiences) {
                response.append("• ").append(exp.getTitle()).append(" - ").append(exp.getFormattedPrice()).append("\n");
                response.append("  📍 ").append(exp.getLocation()).append("\n");
                response.append("  ⭐ ").append(exp.getAverageRating()).append("/5 (").append(exp.getTotalBookings()).append(" lượt đặt)\n");
                response.append("  🏷️ ").append(exp.getType()).append(" | ").append(exp.getDifficulty()).append("\n");
                response.append("\n");
            }
        }
        
        if (!accommodations.isEmpty()) {
            response.append("🏠 NƠI LƯU TRÚ GỢI Ý:\n");
            for (Accommodation acc : accommodations) {
                response.append("• ").append(acc.getName()).append(" - ").append(acc.getFormattedPrice()).append("\n");
                response.append("  📍 ").append(acc.getAddress()).append("\n");
                response.append("  👥 ").append(acc.getFormattedOccupancy()).append(" | ").append(acc.getType()).append("\n");
                response.append("  ⭐ ").append(acc.getAverageRating()).append("/5 (").append(acc.getTotalBookings()).append(" lượt đặt)\n");
                response.append("\n");
            }
        }
        
        return response.toString();
    }
}