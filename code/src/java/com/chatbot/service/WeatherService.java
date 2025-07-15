package com.chatbot.service;

import com.chatbot.constants.WeatherConstants;
import com.chatbot.constants.CityConstants;
import com.chatbot.utils.MessageParser;
import com.chatbot.utils.StringUtils;
import java.util.*;

public class WeatherService {
    
    /**
     * Handle weather information requests
     */
    public String handleWeatherInfo(String message) {
        String city = MessageParser.extractCityFromMessage(message);
        Integer month = MessageParser.extractMonthNumberFromMessage(message);
        String region = MessageParser.extractRegionFromMessage(message);
        
        // Priority: City + Month > City > Month > Region > fallback
        if (city != null && month != null) {
            return getCityMonthWeather(city, month);
        }
        
        // Monthly destination suggestions
        if (city == null && month != null && containsDestinationQuery(message)) {
            return getMonthlyDestinationSuggestions(month);
        }
        
        if (city != null) {
            return getCityYearWeather(city);
        }
        
        if (region != null && month != null) {
            return getRegionMonthWeather(region, month);
        }
        
        if (region != null) {
            return getRegionWeatherOverview(region);
        }
        
        if (month != null) {
            return getMonthWeatherOverview(month);
        }
        
        return getWeatherHelp();
    }
    
    /**
     * Handle best time information requests
     */
    public String handleBestTimeInfo(String message) {
        String city = MessageParser.extractCityFromMessage(message);
        String region = MessageParser.extractRegionFromMessage(message);
        
        if (city != null) {
            return getCityBestTime(city);
        }
        
        if (region != null) {
            return getRegionBestTime(region);
        }
        
        return getGeneralBestTimeInfo();
    }
    
    /**
     * Handle activity weather information
     */
    public String handleActivityWeatherInfo(String message) {
        String city = MessageParser.extractCityFromMessage(message);
        
        if (city != null) {
            return getCityActivityInfo(city);
        }
        
        return getGeneralActivityInfo();
    }
    
    /**
     * Handle avoid hot weather suggestions
     */
    public String handleAvoidHotWeather() {
        StringBuilder sb = new StringBuilder();
        sb.append("🌤️ Nếu bạn muốn tránh nóng, các điểm đến mát mẻ lý tưởng gồm:");
        sb.append("\n- Đà Lạt: 17-25°C, mát mẻ quanh năm, không khí trong lành, nhiều hoa và cảnh đẹp");
        sb.append("\n- Sa Pa: 18-28°C, mát mẻ, có thể se lạnh về đêm, nhiều cảnh núi non, ruộng bậc thang");
        sb.append("\nBạn cũng có thể cân nhắc các vùng núi cao khác nếu muốn trải nghiệm khí hậu dễ chịu trong mùa hè!");
        return sb.toString();
    }
    
    private String getCityMonthWeather(String city, Integer month) {
        Map<Integer, String> cityWeather = WeatherConstants.CITY_MONTH_WEATHER.get(city);
        if (cityWeather != null && cityWeather.containsKey(month)) {
            return "🌤️ Thời tiết " + StringUtils.capitalize(city) + " tháng " + month + ":\n" + cityWeather.get(month);
        } else {
            return "❌ Xin lỗi, chưa có dữ liệu thời tiết cho " + StringUtils.capitalize(city) + " tháng " + month + ".";
        }
    }
    
    private String getMonthlyDestinationSuggestions(Integer month) {
        List<String> bestCities = CityConstants.BEST_CITIES_BY_MONTH.get(month);
        if (bestCities != null && !bestCities.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            sb.append("🌟 Gợi ý điểm đến tháng ").append(month).append(": ");
            for (int i = 0; i < bestCities.size(); i++) {
                sb.append(StringUtils.capitalize(bestCities.get(i)));
                if (i < bestCities.size() - 1) sb.append(", ");
            }
            return sb.toString();
        } else {
            return "❌ Xin lỗi, chưa có dữ liệu gợi ý điểm đến cho tháng " + month + ".";
        }
    }
    
    private String getCityYearWeather(String city) {
        Map<Integer, String> cityWeather = WeatherConstants.CITY_MONTH_WEATHER.get(city);
        if (cityWeather != null) {
            StringBuilder sb = new StringBuilder();
            sb.append("🌤️ Bảng thời tiết 12 tháng tại ").append(StringUtils.capitalize(city)).append(":\n");
            for (int m = 1; m <= 12; m++) {
                sb.append("- Tháng ").append(m).append(": ").append(cityWeather.get(m)).append("\n");
            }
            return sb.toString();
        } else {
            return "❌ Xin lỗi, chưa có dữ liệu thời tiết cho " + StringUtils.capitalize(city) + ".";
        }
    }
    
    private String getRegionMonthWeather(String region, Integer month) {
        Set<String> uniqueCanonical = new HashSet<>();
        StringBuilder sb = new StringBuilder();
        sb.append("🌤️ Thời tiết tháng ").append(month).append(" tại các thành phố miền ").append(region).append(":\n");
        
        for (String c : WeatherConstants.CITY_MONTH_WEATHER.keySet()) {
            String cityRegion = CityConstants.CITY_REGION_MAP.getOrDefault(c, "");
            String canonical = CityConstants.CITY_CANONICAL_NAME.getOrDefault(c, StringUtils.capitalize(c));
            
            if (cityRegion.equals(region) && !uniqueCanonical.contains(canonical)) {
                Map<Integer, String> cityWeather = WeatherConstants.CITY_MONTH_WEATHER.get(c);
                sb.append("- ").append(canonical);
                if (cityWeather != null && cityWeather.containsKey(month)) {
                    sb.append(": ").append(cityWeather.get(month));
                }
                sb.append("\n");
                uniqueCanonical.add(canonical);
            }
        }
        
        if (uniqueCanonical.isEmpty()) {
            sb.append("(Chưa có dữ liệu thành phố thuộc miền này)");
        }
        
        return sb.toString();
    }
    
    private String getRegionWeatherOverview(String region) {
        switch (region) {
            case "bắc":
                return "🌤️ Miền Bắc: 4 mùa rõ rệt.\n- Đông (12-2): Lạnh, sương mù, ít mưa.\n- Xuân (3-4): Ấm áp, mưa phùn nhẹ.\n- Hè (5-8): Nóng ẩm, mưa nhiều.\n- Thu (9-11): Mát mẻ, khô ráo, thời tiết đẹp.";
            case "trung":
                return "🌤️ Miền Trung: 2 mùa rõ rệt.\n- Mùa khô (1-8): Nắng nóng, ít mưa.\n- Mùa mưa (9-12): Mưa nhiều, có thể bão, lũ lụt.";
            case "nam":
                return "🌤️ Miền Nam: 2 mùa rõ rệt.\n- Mùa khô (11-4): Nắng nóng, khô ráo.\n- Mùa mưa (5-10): Mưa nhiều, ẩm ướt.";
            default:
                return "❌ Không xác định được vùng miền.";
        }
    }
    
    private String getMonthWeatherOverview(Integer month) {
        Set<String> uniqueCanonical = new HashSet<>();
        StringBuilder sb = new StringBuilder();
        sb.append("🌤️ Thời tiết tháng ").append(month).append(" tại các thành phố nổi bật:\n");
        
        for (String c : WeatherConstants.CITY_MONTH_WEATHER.keySet()) {
            String canonical = CityConstants.CITY_CANONICAL_NAME.getOrDefault(c, StringUtils.capitalize(c));
            if (!uniqueCanonical.contains(canonical)) {
                Map<Integer, String> cityWeather = WeatherConstants.CITY_MONTH_WEATHER.get(c);
                if (cityWeather != null && cityWeather.containsKey(month)) {
                    sb.append("- ").append(canonical).append(": ").append(cityWeather.get(month)).append("\n");
                    uniqueCanonical.add(canonical);
                }
            }
        }
        
        return sb.toString();
    }
    
    private String getCityBestTime(String city) {
        switch (city) {
            case "hà nội":
                return "🌟 Hà Nội:\n• Tháng 10-4: Mùa đông, lạnh, ít mưa.\n• Tháng 5-9: Mùa hè, nóng ẩm, mưa nhiều.";
            case "hải phòng":
                return "🌟 Hải Phòng:\n• Tháng 10-4: Mùa đông, lạnh, ít mưa.\n• Tháng 5-9: Mùa hè, nóng ẩm, mưa nhiều.\n• Tháng 6-8: Biển Đồ Sơn đẹp nhất.";
            case "sapa":
            case "sa pa":
                return "🌟 Sa Pa:\n• Tháng 3-5: Mùa xuân, hoa nở, khí hậu dễ chịu.\n• Tháng 9-11: Mùa lúa chín vàng, trời trong xanh.\n• Tháng 12-2: Lạnh, có thể có băng tuyết.";
            case "hạ long":
            case "ha long":
                return "🌟 Hạ Long:\n• Tháng 4-10: Thời tiết đẹp, thích hợp du thuyền, tắm biển.\n• Tháng 11-3: Lạnh, có sương mù, ít khách.";
            case "ninh bình":
            case "ninh binh":
                return "🌟 Ninh Bình:\n• Tháng 1-3: Lễ hội, hoa nở.\n• Tháng 4-6: Thời tiết đẹp, mùa lúa chín.\n• Tháng 7-9: Mưa nhiều.";
            case "đà nẵng":
            case "da nang":
                return "🌟 Đà Nẵng:\n• Tháng 2-8: Mùa khô, nắng đẹp, biển xanh.\n• Tháng 9-1: Mùa mưa, có thể có bão.";
            case "huế":
            case "hue":
                return "🌟 Huế:\n• Tháng 1-8: Mùa khô, nắng đẹp, thích hợp tham quan di tích.\n• Tháng 9-12: Mưa nhiều, có thể lũ lụt.";
            case "hội an":
            case "hoi an":
                return "🌟 Hội An:\n• Tháng 2-8: Thời tiết đẹp, ít mưa, thích hợp tham quan phố cổ, biển.\n• Tháng 9-1: Mưa nhiều, lũ lụt có thể xảy ra.";
            case "nha trang":
                return "🌟 Nha Trang:\n• Tháng 1-8: Mùa khô, biển xanh, nắng đẹp.\n• Tháng 9-12: Mưa nhiều, biển động.";
            case "quy nhơn":
            case "quy nhon":
                return "🌟 Quy Nhơn:\n• Tháng 2-8: Mùa khô, biển đẹp, nắng nhiều.\n• Tháng 9-1: Mưa nhiều, biển động.";
            case "đà lạt":
            case "da lat":
                return "🌟 Đà Lạt:\n• Tháng 11-3: Mùa khô, trời se lạnh, nhiều hoa nở.\n• Tháng 4-10: Mùa mưa, không khí mát mẻ, cảnh sắc xanh tươi.";
            case "hồ chí minh":
            case "tp.hcm":
            case "thành phố hồ chí minh":
            case "ho chi minh":
                return "🌟 TP.HCM:\n• Tháng 12-4: Mùa khô, nắng nhiều, ít mưa.\n• Tháng 5-11: Mùa mưa, mưa rào ngắn.";
            case "cần thơ":
            case "can tho":
                return "🌟 Cần Thơ:\n• Tháng 12-4: Mùa khô, nắng đẹp, ít mưa.\n• Tháng 5-11: Mùa mưa, sông nước hữu tình.";
            case "bến tre":
            case "ben tre":
                return "🌟 Bến Tre:\n• Tháng 12-4: Mùa khô, thích hợp du lịch miệt vườn.\n• Tháng 5-11: Mùa mưa, sông nước xanh tươi.";
            case "phú quốc":
            case "phu quoc":
                return "🌟 Phú Quốc:\n• Tháng 11-4: Mùa khô, biển lặng, nắng đẹp.\n• Tháng 5-10: Mùa mưa, biển động, có mưa rào.";
            case "vũng tàu":
            case "vung tau":
                return "🌟 Vũng Tàu:\n• Tháng 12-4: Mùa khô, biển đẹp, nắng nhiều.\n• Tháng 5-11: Mùa mưa, biển động nhẹ.";
            default:
                return "🌞 Hiện tại chỉ hỗ trợ chi tiết cho một số thành phố lớn. Bạn có thể hỏi về Hà Nội, Hải Phòng, Sa Pa, Hạ Long, Ninh Bình, Đà Nẵng, Huế, Hội An, Nha Trang, Quy Nhơn, Đà Lạt, TP.HCM, Cần Thơ, Bến Tre, Phú Quốc, Vũng Tàu...";
        }
    }
    
    private String getRegionBestTime(String region) {
        switch (region) {
            case "bắc":
                return "🌄 Miền Bắc (Hà Nội, Hải Phòng, Sa Pa, Hạ Long, Ninh Bình):\n• Tháng 10-4: Mùa đông, lạnh, ít mưa.\n• Tháng 5-9: Mùa hè, nóng ẩm, mưa nhiều.";
            case "trung":
                return "🌅 Miền Trung (Đà Nẵng, Huế, Hội An, Nha Trang, Quy Nhơn):\n• Tháng 2-8: Mùa khô, nắng nhiều, biển đẹp.\n• Tháng 9-1: Mùa mưa, có thể có bão, lũ lụt.";
            case "nam":
                return "🌴 Miền Nam (Đà Lạt, TP.HCM, Cần Thơ, Bến Tre, Phú Quốc, Vũng Tàu):\n• Tháng 12-4: Mùa khô, nắng đẹp, ít mưa.\n• Tháng 5-11: Mùa mưa, mưa rào, không khí mát.";
            default:
                return "🌞 Hiện tại chỉ hỗ trợ chi tiết cho miền Bắc, Trung, Nam. Bạn có thể hỏi về các vùng này hoặc thành phố cụ thể.";
        }
    }
    
    private String getCityActivityInfo(String city) {
        StringBuilder sb = new StringBuilder();
        sb.append("🌤️ HOẠT ĐỘNG NỔI BẬT Ở ").append(StringUtils.capitalize(city)).append(":\n\n");
        
        switch (city) {
            case "đà nẵng":
            case "da nang":
                sb.append("🌊 Biển: Có nhiều bãi biển đẹp như Mỹ Khê, Non Nước, Nam Ô. Thời gian lý tưởng: tháng 4-9.\n");
                sb.append("🌧️ Tắm biển: Nước trong xanh, bãi cát dài, thích hợp cho các hoạt động thể thao nước.\n");
                sb.append("👣 Trekking/Leo núi: Bà Nà Hills, Ngũ Hành Sơn, bán đảo Sơn Trà.\n");
                sb.append("📸 Chụp ảnh: Cầu Rồng, Cầu Tình Yêu, Bà Nà Hills, biển Mỹ Khê.\n");
                sb.append("🎉 Lễ hội: Lễ hội pháo hoa quốc tế, lễ hội cầu ngư, lễ hội Quán Thế Âm.\n");
                break;
            case "hội an":
            case "hoi an":
                sb.append("🌊 Biển: Bãi biển An Bàng, Cửa Đại. Thời gian lý tưởng: tháng 4-9.\n");
                sb.append("🌧️ Tắm biển: Biển sạch, yên tĩnh, thích hợp nghỉ dưỡng.\n");
                sb.append("👣 Trekking/Leo núi: Gần các làng quê, đồng ruộng, thích hợp đạp xe, đi bộ.\n");
                sb.append("📸 Chụp ảnh: Phố cổ, chùa Cầu, sông Hoài, đèn lồng.\n");
                sb.append("🎉 Lễ hội: Đêm phố cổ, lễ hội đèn lồng, lễ hội Cầu Bông.\n");
                break;
            case "hà nội":
                sb.append("🌊 Biển: Không có biển, có thể tham quan Hồ Tây, Hồ Gươm.\n");
                sb.append("👣 Trekking/Leo núi: Gần Tam Đảo, Ba Vì, thích hợp đi cuối tuần.\n");
                sb.append("📸 Chụp ảnh: Phố cổ, Hồ Gươm, Văn Miếu, cầu Long Biên.\n");
                sb.append("🎉 Lễ hội: Lễ hội Đoan Ngọ, lễ hội chùa Hương, lễ hội Tết.\n");
                break;
            case "phú quốc":
            case "phu quoc":
                sb.append("🌊 Biển: Bãi Sao, Bãi Dài, Bãi Khem. Thời gian lý tưởng: tháng 11-4.\n");
                sb.append("🌧️ Tắm biển: Biển xanh, cát trắng, nhiều hoạt động lặn ngắm san hô.\n");
                sb.append("👣 Trekking/Leo núi: Rừng nguyên sinh, suối Tranh, suối Đá Bàn.\n");
                sb.append("📸 Chụp ảnh: Sunset Sanato, làng chài Hàm Ninh, Dinh Cậu.\n");
                sb.append("🎉 Lễ hội: Lễ hội Dinh Cậu, lễ hội Nghinh Ông.\n");
                break;
            default:
                sb.append("(Hiện tại chỉ hỗ trợ chi tiết cho Hà Nội, Đà Nẵng, Hội An, Phú Quốc. Các thành phố khác sẽ được cập nhật sau!)\n");
        }
        
        sb.append("\n💡 Lưu ý: Đặt phòng/booking trước, kiểm tra thời tiết và lịch lễ hội để có trải nghiệm tốt nhất!");
        return sb.toString();
    }
    
    private String getGeneralBestTimeInfo() {
        return "🌞 THỜI GIAN TỐT NHẤT ĐỂ ĐI DU LỊCH VIỆT NAM:\n\n" +
               "🌟 Hà Nội:\n• Tháng 10-4: Mùa đông, lạnh, ít mưa.\n• Tháng 5-9: Mùa hè, nóng ẩm, mưa nhiều.\n\n" +
               "🌟 Đà Nẵng:\n• Tháng 2-8: Mùa khô, nắng đẹp, biển xanh.\n• Tháng 9-1: Mùa mưa, có thể có bão.\n\n" +
               "🌟 Hội An:\n• Tháng 2-8: Thời tiết đẹp, ít mưa, thích hợp tham quan phố cổ, biển.\n• Tháng 9-1: Mưa nhiều, lũ lụt có thể xảy ra.\n\n" +
               "🌟 Phú Quốc:\n• Tháng 11-4: Mùa khô, biển lặng, nắng đẹp.\n• Tháng 5-10: Mùa mưa, biển động, có mưa rào.";
    }
    
    private String getGeneralActivityInfo() {
        return "🌤️ HOẠT ĐỘNG THEO THỜI TIẾT:\n\n" +
               "🌊 Biển:\n" +
               "• Hà Nội: Không có biển, nên đi các khu vui chơi nước như Hồ Tây, Hồ Gươm.\n" +
               "• Đà Nẵng: Có nhiều bãi biển như Mỹ Khê, Non Nước. Tốt nhất đi từ tháng 4 đến tháng 9.\n" +
               "• Hội An: Bãi biển An Bàng, Cửa Đại. Tốt nhất đi từ tháng 4 đến tháng 9.\n" +
               "• Phú Quốc: Bãi Sao, Bãi Dài. Tốt nhất đi từ tháng 11 đến tháng 4.\n\n" +
               "👣 Trekking/Leo núi:\n" +
               "• Hà Nội: Gần Tam Đảo, Ba Vì.\n" +
               "• Đà Nẵng: Bà Nà Hills, Ngũ Hành Sơn, bán đảo Sơn Trà.\n" +
               "• Hội An: Làng quê, đồng ruộng.\n" +
               "• Phú Quốc: Rừng nguyên sinh, suối Tranh.\n\n" +
               "📸 Chụp ảnh:\n" +
               "• Hà Nội: Phố cổ, Hồ Gươm, Văn Miếu.\n" +
               "• Đà Nẵng: Cầu Rồng, Bà Nà Hills, biển Mỹ Khê.\n" +
               "• Hội An: Phố cổ, chùa Cầu, sông Hoài.\n" +
               "• Phú Quốc: Sunset Sanato, làng chài Hàm Ninh.\n\n" +
               "🎉 Lễ hội:\n" +
               "• Hà Nội: Lễ hội Đoan Ngọ, chùa Hương.\n" +
               "• Đà Nẵng: Lễ hội pháo hoa quốc tế.\n" +
               "• Hội An: Đêm phố cổ, lễ hội đèn lồng.\n" +
               "• Phú Quốc: Lễ hội Dinh Cậu.\n\n" +
               "💡 Lưu ý: Đặt phòng/booking trước, kiểm tra thời tiết và lịch lễ hội để có trải nghiệm tốt nhất!";
    }
    
    private String getWeatherHelp() {
        return "❓ Bạn muốn hỏi thời tiết ở thành phố nào/tháng nào? Ví dụ: 'thời tiết Đà Nẵng tháng 7', 'Hà Nội tháng 3', 'tháng 8 ở Huế', 'thời tiết miền Nam tháng 12'...";
    }
    
    private boolean containsDestinationQuery(String message) {
        return message.toLowerCase().contains("nên đi đâu") ||
               message.toLowerCase().contains("du lịch ở đâu") ||
               message.toLowerCase().contains("gợi ý điểm đến") ||
               message.toLowerCase().contains("đi đâu");
    }
}