package com.chatbot.constants;

import java.util.*;

public class CityConstants {
    
    // Danh sách thành phố nên đi theo từng tháng
    public static final Map<Integer, List<String>> BEST_CITIES_BY_MONTH = new HashMap<>();
    
    // Mapping thành phố -> miền
    public static final Map<String, String> CITY_REGION_MAP = new HashMap<>();
    
    // Map alias -> tên chuẩn hóa
    public static final Map<String, String> CITY_CANONICAL_NAME = new HashMap<>();
    
    static {
        initializeBestCitiesByMonth();
        initializeCityRegionMap();
        initializeCityCanonicalNames();
    }
    
    private static void initializeBestCitiesByMonth() {
        BEST_CITIES_BY_MONTH.put(1, Arrays.asList("Nha Trang", "Quy Nhơn", "TP.HCM", "Vũng Tàu", "Cần Thơ", "Phú Quốc", "Đà Lạt", "Bến Tre"));
        BEST_CITIES_BY_MONTH.put(2, Arrays.asList("Nha Trang", "Quy Nhơn", "TP.HCM", "Vũng Tàu", "Cần Thơ", "Phú Quốc", "Đà Lạt", "Bến Tre"));
        BEST_CITIES_BY_MONTH.put(3, Arrays.asList("Tất cả các địa điểm"));
        BEST_CITIES_BY_MONTH.put(4, Arrays.asList("Tất cả các địa điểm"));
        BEST_CITIES_BY_MONTH.put(5, Arrays.asList("Đà Nẵng", "Hội An", "Huế", "Nha Trang", "Quy Nhơn", "Đà Lạt", "Sa Pa"));
        BEST_CITIES_BY_MONTH.put(6, Arrays.asList("Đà Nẵng", "Hội An", "Huế", "Nha Trang", "Quy Nhơn", "Đà Lạt", "Sa Pa"));
        BEST_CITIES_BY_MONTH.put(7, Arrays.asList("Đà Nẵng", "Hội An", "Huế", "Nha Trang", "Quy Nhơn", "Đà Lạt", "Sa Pa"));
        BEST_CITIES_BY_MONTH.put(8, Arrays.asList("Đà Nẵng", "Hội An", "Huế", "Nha Trang", "Quy Nhơn", "Đà Lạt", "Sa Pa"));
        BEST_CITIES_BY_MONTH.put(9, Arrays.asList("Sapa", "Hạ Long", "Nha Trang", "Quy Nhơn"));
        BEST_CITIES_BY_MONTH.put(10, Arrays.asList("Hà Nội", "Hải Phòng", "Sapa", "Hạ Long", "Ninh Bình", "Nha Trang", "Quy Nhơn"));
        BEST_CITIES_BY_MONTH.put(11, Arrays.asList("Hà Nội", "Hải Phòng", "Sapa", "Hạ Long", "Ninh Bình", "Nha Trang", "Quy Nhơn"));
        BEST_CITIES_BY_MONTH.put(12, Arrays.asList("Nha Trang", "Quy Nhơn", "TP.HCM", "Vũng Tàu", "Cần Thơ", "Phú Quốc", "Đà Lạt", "Bến Tre"));
    }
    
    private static void initializeCityRegionMap() {
        // Miền Bắc
        CITY_REGION_MAP.put("hà nội", "bắc");
        CITY_REGION_MAP.put("hải phòng", "bắc");
        CITY_REGION_MAP.put("sapa", "bắc");
        CITY_REGION_MAP.put("sa pa", "bắc");
        CITY_REGION_MAP.put("hạ long", "bắc");
        CITY_REGION_MAP.put("ha long", "bắc");
        CITY_REGION_MAP.put("ninh bình", "bắc");
        CITY_REGION_MAP.put("ninh binh", "bắc");
        
        // Miền Trung
        CITY_REGION_MAP.put("đà nẵng", "trung");
        CITY_REGION_MAP.put("da nang", "trung");
        CITY_REGION_MAP.put("huế", "trung");
        CITY_REGION_MAP.put("hue", "trung");
        CITY_REGION_MAP.put("hội an", "trung");
        CITY_REGION_MAP.put("hoi an", "trung");
        CITY_REGION_MAP.put("nha trang", "trung");
        CITY_REGION_MAP.put("quy nhơn", "trung");
        CITY_REGION_MAP.put("quy nhon", "trung");
        
        // Miền Nam
        CITY_REGION_MAP.put("đà lạt", "nam");
        CITY_REGION_MAP.put("da lat", "nam");
        CITY_REGION_MAP.put("hồ chí minh", "nam");
        CITY_REGION_MAP.put("tp.hcm", "nam");
        CITY_REGION_MAP.put("thành phố hồ chí minh", "nam");
        CITY_REGION_MAP.put("ho chi minh", "nam");
        CITY_REGION_MAP.put("cần thơ", "nam");
        CITY_REGION_MAP.put("can tho", "nam");
        CITY_REGION_MAP.put("bến tre", "nam");
        CITY_REGION_MAP.put("ben tre", "nam");
        CITY_REGION_MAP.put("phú quốc", "nam");
        CITY_REGION_MAP.put("phu quoc", "nam");
        CITY_REGION_MAP.put("vũng tàu", "nam");
        CITY_REGION_MAP.put("vung tau", "nam");
    }
    
    private static void initializeCityCanonicalNames() {
        CITY_CANONICAL_NAME.put("hà nội", "Hà Nội");
        CITY_CANONICAL_NAME.put("hải phòng", "Hải Phòng");
        CITY_CANONICAL_NAME.put("sapa", "Sa Pa");
        CITY_CANONICAL_NAME.put("sa pa", "Sa Pa");
        CITY_CANONICAL_NAME.put("hạ long", "Hạ Long");
        CITY_CANONICAL_NAME.put("ha long", "Hạ Long");
        CITY_CANONICAL_NAME.put("ninh bình", "Ninh Bình");
        CITY_CANONICAL_NAME.put("ninh binh", "Ninh Bình");
        CITY_CANONICAL_NAME.put("đà nẵng", "Đà Nẵng");
        CITY_CANONICAL_NAME.put("da nang", "Đà Nẵng");
        CITY_CANONICAL_NAME.put("huế", "Huế");
        CITY_CANONICAL_NAME.put("hue", "Huế");
        CITY_CANONICAL_NAME.put("hội an", "Hội An");
        CITY_CANONICAL_NAME.put("hoi an", "Hội An");
        CITY_CANONICAL_NAME.put("nha trang", "Nha Trang");
        CITY_CANONICAL_NAME.put("quy nhơn", "Quy Nhơn");
        CITY_CANONICAL_NAME.put("quy nhon", "Quy Nhơn");
        CITY_CANONICAL_NAME.put("đà lạt", "Đà Lạt");
        CITY_CANONICAL_NAME.put("da lat", "Đà Lạt");
        CITY_CANONICAL_NAME.put("hồ chí minh", "TP.HCM");
        CITY_CANONICAL_NAME.put("tp.hcm", "TP.HCM");
        CITY_CANONICAL_NAME.put("thành phố hồ chí minh", "TP.HCM");
        CITY_CANONICAL_NAME.put("ho chi minh", "TP.HCM");
        CITY_CANONICAL_NAME.put("cần thơ", "Cần Thơ");
        CITY_CANONICAL_NAME.put("can tho", "Cần Thơ");
        CITY_CANONICAL_NAME.put("bến tre", "Bến Tre");
        CITY_CANONICAL_NAME.put("ben tre", "Bến Tre");
        CITY_CANONICAL_NAME.put("phú quốc", "Phú Quốc");
        CITY_CANONICAL_NAME.put("phu quoc", "Phú Quốc");
        CITY_CANONICAL_NAME.put("vũng tàu", "Vũng Tàu");
        CITY_CANONICAL_NAME.put("vung tau", "Vũng Tàu");
    }
}