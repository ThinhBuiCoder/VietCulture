package com.chatbot.utils;

import com.chatbot.constants.CityConstants;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.List;
import java.util.Arrays;

public class MessageParser {
    
    /**
     * Extract city name from user message
     */
    public static String extractCityFromMessage(String message) {
        // Nhận diện city linh hoạt, ưu tiên tên dài, không nhận "đâu" là city
        String[] cities = {
            "thành phố hồ chí minh", "hà nội", "đà nẵng", "hội an", "phú quốc", 
            "sa pa", "hạ long", "ha long", "nha trang", "đà lạt", "da lat", 
            "huế", "hue", "hồ chí minh", "tp.hcm", "ho chi minh", "cần thơ", 
            "can tho", "vũng tàu", "vung tau", "quy nhơn", "quy nhon", 
            "hải phòng", "ninh bình", "ninh binh", "bến tre", "ben tre", "sapa"
        };
        
        // Sắp xếp tên city theo độ dài giảm dần để ưu tiên tên dài
        List<String> cityList = Arrays.asList(cities);
        cityList.sort((a, b) -> Integer.compare(b.length(), a.length()));
        
        String lower = message.toLowerCase();
        for (String city : cityList) {
            if (lower.contains(city)) {
                return city;
            }
        }
        
        // Nhận diện city sau các từ khóa phổ biến
        String[] cityMarkers = {"ở ", "tại ", "thành phố ", "city ", "đến ", "đi ", "du lịch "};
        for (String marker : cityMarkers) {
            int idx = lower.indexOf(marker);
            if (idx != -1) {
                String after = lower.substring(idx + marker.length()).trim();
                for (String city : cityList) {
                    if (after.startsWith(city)) {
                        return city;
                    }
                }
            }
        }
        
        return null;
    }
    
    /**
     * Extract month number from user message
     */
    public static Integer extractMonthNumberFromMessage(String message) {
        message = message.toLowerCase();
        // Dùng regex để match chính xác "tháng 12", "tháng 1"...
        Pattern p = Pattern.compile("tháng\\s*(1[0-2]|[1-9])");
        Matcher m = p.matcher(message);
        if (m.find()) {
            return Integer.parseInt(m.group(1));
        }
        // Check for standalone numbers
        Pattern pattern = Pattern.compile("\\b(\\d{1,2})\\b");
        Matcher matcher = pattern.matcher(message);
        while (matcher.find()) {
            int num = Integer.parseInt(matcher.group(1));
            if (num >= 1 && num <= 12) {
                return num;
            }
        }
        return null;
    }
    
    /**
     * Extract region from user message
     */
    public static String extractRegionFromMessage(String message) {
        message = message.toLowerCase();
        if (message.contains("miền bắc") || message.contains("bắc")) return "bắc";
        if (message.contains("miền trung") || message.contains("trung")) return "trung";
        if (message.contains("miền nam") || message.contains("nam")) return "nam";
        return null;
    }
    
    /**
     * Extract experience type from user message
     */
    public static String extractTypeFromMessage(String message) {
        message = message.toLowerCase();
        
        if (message.matches(".*(ẩm thực|food|ăn uống|món ăn|đặc sản|ăn gì|quán ngon|ăn uống|ẩm\\s*thực).*")) {
            return "Ẩm thực";
        }
        if (message.matches(".*(văn hóa|culture|lễ hội|truyền thống|phong tục|phong\\s*tục).*")) {
            return "Văn hóa";
        }
        if (message.matches(".*(phiêu lưu|adventure|mạo hiểm|khám phá|trải nghiệm mạnh|hoạt động ngoài trời|outdoor).*")) {
            return "Phiêu lưu";
        }
        if (message.matches(".*(lịch sử|history|di tích|cổ kính|bảo tàng).*")) {
            return "Lịch sử";
        }
        if (message.matches(".*(thiên nhiên|nature|cảnh đẹp|phong cảnh|núi rừng|sông nước|biển).*")) {
            return "Thiên nhiên";
        }
        if (message.matches(".*(nghệ thuật|art|tranh|triển lãm|sáng tạo).*")) {
            return "Nghệ thuật";
        }
        
        return null;
    }
    
    /**
     * Extract accommodation type from user message
     */
    public static String extractAccommodationTypeFromMessage(String message) {
        if (message.contains("khách sạn") || message.contains("hotel")) return "Khách sạn";
        if (message.contains("homestay")) return "Homestay";
        if (message.contains("resort")) return "Resort";
        if (message.contains("villa")) return "Villa";
        if (message.contains("căn hộ") || message.contains("apartment")) return "Căn hộ";
        if (message.contains("lưu trú")) return "Lưu trú";
        return null;
    }
    
    /**
     * Extract price range from user message
     */
    public static String extractPriceRangeFromMessage(String message) {
        message = message.replaceAll("[.,]", "");
        
        // Dưới X
        Pattern underPattern = Pattern.compile("(dưới|less than|under) ?(\\d+)(k|nghìn|000|trăm|triệu|m|million)?(\\s*vnd)?(\\s*đ)?(\\s*vnđ)?(\\s*đồng)?");
        Matcher underMatcher = underPattern.matcher(message);
        if (underMatcher.find()) {
            String num = underMatcher.group(2);
            String unit = underMatcher.group(3);
            double value = Double.parseDouble(num);
            value = convertToActualValue(value, unit);
            return "0-" + ((int) value);
        }
        
        // Khoảng X-Y
        Pattern rangePattern = Pattern.compile("(\\d+)(k|nghìn|000|trăm|triệu|m|million)?[ \\~tođến\\-]+(\\d+)(k|nghìn|000|trăm|triệu|m|million)?");
        Matcher rangeMatcher = rangePattern.matcher(message);
        if (rangeMatcher.find()) {
            double v1 = Double.parseDouble(rangeMatcher.group(1));
            String u1 = rangeMatcher.group(2);
            double v2 = Double.parseDouble(rangeMatcher.group(3));
            String u2 = rangeMatcher.group(4);
            
            v1 = convertToActualValue(v1, u1);
            v2 = convertToActualValue(v2, u2);
            
            return ((int) v1) + "-" + ((int) v2);
        }
        
        // Trên X
        Pattern overPattern = Pattern.compile("(trên|hơn|more than|over) ?(\\d+)(k|nghìn|000|trăm|triệu|m|million)?");
        Matcher overMatcher = overPattern.matcher(message);
        if (overMatcher.find()) {
            String num = overMatcher.group(2);
            String unit = overMatcher.group(3);
            double value = Double.parseDouble(num);
            value = convertToActualValue(value, unit);
            return ((int) value) + "+";
        }
        
        return null;
    }
    
    /**
     * Convert price unit to actual value
     */
    private static double convertToActualValue(double value, String unit) {
        if (unit != null) {
            if (unit.equals("k") || unit.equals("nghìn") || unit.equals("000")) {
                value *= 1000;
            } else if (unit.equals("trăm")) {
                value *= 100000;
            } else if (unit.equals("m") || unit.equals("triệu") || unit.equals("million")) {
                value *= 1000000;
            }
        }
        return value;
    }
    
    /**
     * Extract activity type from message
     */
    public static String extractActivityFromMessage(String message) {
        message = message.toLowerCase();
        if (message.matches(".*(biển|tắm biển|bơi|swim|sea|beach).*")) return "biển";
        if (message.matches(".*(trekking|leo núi|hiking|mountain|đi bộ|dã ngoại).*")) return "trekking";
        if (message.matches(".*(chụp ảnh|photo|selfie|ảnh đẹp).*")) return "chụp ảnh";
        if (message.matches(".*(festival|lễ hội|event|sự kiện).*")) return "festival";
        if (message.matches(".*(du lịch|travel|tour).*")) return "du lịch";
        return null;
    }
}