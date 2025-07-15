package com.chatbot.constants;

import java.util.*;

public class WeatherConstants {

    // === WEATHER DATA FOR 16 CITIES x 12 MONTHS ===
    public static final Map<String, Map<Integer, String>> CITY_MONTH_WEATHER = new HashMap<>();

    static {
        initializeHanoiWeather();
        initializeHaiphongWeather();
        initializeSapaWeather();
        initializeHalongWeather();
        initializeNinhbinhWeather();
        initializeDanangWeather();
        initializeHueWeather();
        initializeHoianWeather();
        initializeNhatrangWeather();
        initializeQuynhonWeather();
        initializeHcmcWeather();
        initializeVungtauWeather();
        initializeCanthoWeather();
        initializePhuquocWeather();
        initializeDalatWeather();
        initializeBentreWeather();
    }

    private static void initializeHanoiWeather() {
        Map<Integer, String> hanoiWeather = new HashMap<>();
        hanoiWeather.put(1, "14-20°C, lạnh, khô ráo, ít mưa. Sương mù nhiều");
        hanoiWeather.put(2, "15-21°C, se lạnh, khô ráo, thời tiết dễ chịu");
        hanoiWeather.put(3, "18-25°C, ấm áp, nắng đẹp, ít mưa");
        hanoiWeather.put(4, "22-28°C, nóng dần, nắng đẹp, thỉnh thoảng có mưa");
        hanoiWeather.put(5, "26-32°C, nóng, bắt đầu mùa mưa");
        hanoiWeather.put(6, "27-33°C, nóng ẩm, mưa nhiều");
        hanoiWeather.put(7, "28-34°C, nóng ẩm, mưa to, đỉnh mùa mưa");
        hanoiWeather.put(8, "27-33°C, nóng ẩm, mưa nhiều");
        hanoiWeather.put(9, "26-31°C, mát dần, mưa giảm");
        hanoiWeather.put(10, "22-28°C, mát mẻ, khô ráo, thời tiết đẹp");
        hanoiWeather.put(11, "18-25°C, mát mẻ, khô ráo, thời tiết lý tưởng");
        hanoiWeather.put(12, "15-21°C, lạnh, khô ráo, sương mù");
        CITY_MONTH_WEATHER.put("hà nội", hanoiWeather);
    }

    private static void initializeHaiphongWeather() {
        Map<Integer, String> haiphongWeather = new HashMap<>();
        haiphongWeather.put(1, "15-21°C, lạnh, khô ráo, sương mù");
        haiphongWeather.put(2, "16-22°C, se lạnh, khô ráo");
        haiphongWeather.put(3, "19-26°C, ấm áp, nắng đẹp");
        haiphongWeather.put(4, "23-29°C, nóng dần, thời tiết dễ chịu");
        haiphongWeather.put(5, "27-33°C, nóng, bắt đầu mùa mưa");
        haiphongWeather.put(6, "28-34°C, nóng ẩm, mưa nhiều");
        haiphongWeather.put(7, "29-35°C, nóng ẩm, mưa to, có thể có bão");
        haiphongWeather.put(8, "28-34°C, nóng ẩm, mưa nhiều");
        haiphongWeather.put(9, "26-32°C, mát dần, mưa giảm");
        haiphongWeather.put(10, "23-29°C, mát mẻ, khô ráo");
        haiphongWeather.put(11, "19-26°C, mát mẻ, khô ráo");
        haiphongWeather.put(12, "16-22°C, lạnh, khô ráo");
        CITY_MONTH_WEATHER.put("hải phòng", haiphongWeather);
    }

    private static void initializeSapaWeather() {
        Map<Integer, String> sapaWeather = new HashMap<>();
        sapaWeather.put(1, "3-12°C, rất lạnh, khô ráo, có thể có băng tuyết");
        sapaWeather.put(2, "5-15°C, lạnh, khô ráo, sương mù");
        sapaWeather.put(3, "8-18°C, se lạnh, khô ráo, thời tiết đẹp");
        sapaWeather.put(4, "12-22°C, mát mẻ, khô ráo, lý tưởng");
        sapaWeather.put(5, "16-26°C, ấm áp, bắt đầu mùa mưa");
        sapaWeather.put(6, "18-28°C, ấm, mưa nhiều");
        sapaWeather.put(7, "19-29°C, nóng, mưa to, đường trơn trượt");
        sapaWeather.put(8, "19-28°C, nóng, mưa nhiều");
        sapaWeather.put(9, "17-26°C, mát dần, mưa giảm, thời tiết đẹp");
        sapaWeather.put(10, "13-22°C, mát mẻ, khô ráo, lý tưởng");
        sapaWeather.put(11, "9-18°C, se lạnh, khô ráo, thời tiết đẹp");
        sapaWeather.put(12, "5-14°C, lạnh, khô ráo, sương mù");
        CITY_MONTH_WEATHER.put("sapa", sapaWeather);
        CITY_MONTH_WEATHER.put("sa pa", sapaWeather);
    }

    // Tiếp tục với các thành phố khác...
    private static void initializeHalongWeather() {
        Map<Integer, String> halongWeather = new HashMap<>();
        halongWeather.put(1, "13-19°C, lạnh, khô ráo, sương mù, có thể hủy tour");
        halongWeather.put(2, "14-20°C, se lạnh, khô ráo, thời tiết cải thiện");
        halongWeather.put(3, "17-24°C, ấm áp, nắng đẹp, lý tưởng");
        halongWeather.put(4, "21-27°C, nóng dần, nắng đẹp, rất tốt");
        halongWeather.put(5, "25-31°C, nóng, bắt đầu mùa mưa");
        halongWeather.put(6, "26-32°C, nóng ẩm, mưa nhiều, có thể có bão");
        halongWeather.put(7, "27-33°C, nóng ẩm, mưa to, có thể hủy tour");
        halongWeather.put(8, "26-32°C, nóng ẩm, mưa nhiều");
        halongWeather.put(9, "24-30°C, mát dần, mưa giảm, thời tiết cải thiện");
        halongWeather.put(10, "20-27°C, mát mẻ, khô ráo, lý tưởng");
        halongWeather.put(11, "16-23°C, mát mẻ, khô ráo, rất tốt");
        halongWeather.put(12, "14-20°C, lạnh, khô ráo, sương mù");
        CITY_MONTH_WEATHER.put("hạ long", halongWeather);
        CITY_MONTH_WEATHER.put("ha long", halongWeather);
    }

    private static void initializeNinhbinhWeather() {
        Map<Integer, String> ninhbinhWeather = new HashMap<>();
        ninhbinhWeather.put(1, "14-20°C, lạnh, khô ráo, sương mù");
        ninhbinhWeather.put(2, "15-21°C, se lạnh, khô ráo");
        ninhbinhWeather.put(3, "18-25°C, ấm áp, nắng đẹp, lý tưởng");
        ninhbinhWeather.put(4, "22-28°C, nóng dần, nắng đẹp, rất tốt");
        ninhbinhWeather.put(5, "26-32°C, nóng, bắt đầu mùa mưa");
        ninhbinhWeather.put(6, "27-33°C, nóng ẩm, mưa nhiều");
        ninhbinhWeather.put(7, "28-34°C, nóng ẩm, mưa to");
        ninhbinhWeather.put(8, "27-33°C, nóng ẩm, mưa nhiều");
        ninhbinhWeather.put(9, "26-31°C, mát dần, mưa giảm");
        ninhbinhWeather.put(10, "22-28°C, mát mẻ, khô ráo, lý tưởng");
        ninhbinhWeather.put(11, "18-25°C, mát mẻ, khô ráo, rất tốt");
        ninhbinhWeather.put(12, "15-21°C, lạnh, khô ráo");
        CITY_MONTH_WEATHER.put("ninh bình", ninhbinhWeather);
    }

    private static void initializeDanangWeather() {
        Map<Integer, String> danangWeather = new HashMap<>();
        danangWeather.put(1, "18-24°C, mát mẻ, khô ráo, có thể mưa phùn");
        danangWeather.put(2, "19-26°C, ấm áp, khô ráo, thời tiết cải thiện");
        danangWeather.put(3, "21-28°C, nóng dần, nắng đẹp, lý tưởng");
        danangWeather.put(4, "24-31°C, nóng, nắng đẹp, rất tốt");
        danangWeather.put(5, "26-33°C, nóng, nắng đẹp, tốt cho tắm biển");
        danangWeather.put(6, "27-34°C, nóng, nắng đẹp, đỉnh mùa du lịch");
        danangWeather.put(7, "27-35°C, rất nóng, nắng gắt, tốt cho biển");
        danangWeather.put(8, "26-34°C, nóng, nắng đẹp, cuối mùa khô");
        danangWeather.put(9, "25-32°C, nóng, bắt đầu mùa mưa");
        danangWeather.put(10, "22-29°C, mát dần, mưa nhiều, có thể có bão");
        danangWeather.put(11, "20-26°C, mát mẻ, mưa nhiều, có thể lũ");
        danangWeather.put(12, "18-24°C, mát mẻ, mưa, thời tiết không ổn định");
        CITY_MONTH_WEATHER.put("đà nẵng", danangWeather);
    }

    private static void initializeHueWeather() {
        Map<Integer, String> hueWeather = new HashMap<>();
        hueWeather.put(1, "15-22°C, lạnh, mưa phùn, ẩm ướt");
        hueWeather.put(2, "16-24°C, se lạnh, mưa ít, thời tiết cải thiện");
        hueWeather.put(3, "19-27°C, ấm áp, khô ráo, thời tiết đẹp");
        hueWeather.put(4, "23-30°C, nóng dần, nắng đẹp, lý tưởng");
        hueWeather.put(5, "25-32°C, nóng, nắng đẹp, rất tốt");
        hueWeather.put(6, "26-33°C, nóng, nắng đẹp, tốt");
        hueWeather.put(7, "26-34°C, nóng, nắng đẹp, đỉnh mùa khô");
        hueWeather.put(8, "25-33°C, nóng, nắng đẹp, cuối mùa khô");
        hueWeather.put(9, "24-31°C, nóng, bắt đầu mùa mưa");
        hueWeather.put(10, "21-28°C, mát dần, mưa nhiều, có thể lũ");
        hueWeather.put(11, "18-25°C, mát mẻ, mưa to, có thể lũ lụt");
        hueWeather.put(12, "16-23°C, lạnh, mưa nhiều, ẩm ướt");
        CITY_MONTH_WEATHER.put("huế", hueWeather);
    }

    private static void initializeHoianWeather() {
        Map<Integer, String> hoianWeather = new HashMap<>();
        hoianWeather.put(1, "18-25°C, mát mẻ, khô ráo, thời tiết ổn định");
        hoianWeather.put(2, "19-26°C, ấm áp, khô ráo, thời tiết đẹp");
        hoianWeather.put(3, "21-28°C, nóng dần, nắng đẹp, hoa nở rộ");
        hoianWeather.put(4, "24-31°C, nóng, nắng đẹp, lý tưởng");
        hoianWeather.put(5, "26-33°C, nóng, nắng đẹp, tốt cho tắm biển");
        hoianWeather.put(6, "27-34°C, nóng, nắng đẹp, đỉnh mùa du lịch");
        hoianWeather.put(7, "27-35°C, rất nóng, nắng gắt, tốt cho biển");
        hoianWeather.put(8, "26-34°C, nóng, nắng đẹp, cuối mùa khô");
        hoianWeather.put(9, "25-32°C, nóng, bắt đầu mùa mưa, có thể bão");
        hoianWeather.put(10, "22-29°C, mát dần, mưa nhiều, có thể lũ nhẹ");
        hoianWeather.put(11, "20-26°C, mát mẻ, mưa nhiều, có thể lũ");
        hoianWeather.put(12, "18-24°C, mát mẻ, mưa, thời tiết không ổn định");
        CITY_MONTH_WEATHER.put("hội an", hoianWeather);
    }

    private static void initializeNhatrangWeather() {
        Map<Integer, String> nhatrangWeather = new HashMap<>();
        nhatrangWeather.put(1, "21-28°C, nóng, nắng đẹp, khô ráo, lý tưởng");
        nhatrangWeather.put(2, "22-29°C, nóng, nắng đẹp, khô ráo, rất tốt");
        nhatrangWeather.put(3, "24-31°C, nóng, nắng đẹp, khô ráo, lý tưởng");
        nhatrangWeather.put(4, "26-32°C, nóng, nắng đẹp, khô ráo, tốt");
        nhatrangWeather.put(5, "27-33°C, nóng, nắng đẹp, khô ráo, tốt");
        nhatrangWeather.put(6, "27-33°C, nóng, nắng đẹp, khô ráo, tốt");
        nhatrangWeather.put(7, "26-32°C, nóng, nắng đẹp, khô ráo, tốt");
        nhatrangWeather.put(8, "26-32°C, nóng, nắng đẹp, khô ráo, tốt");
        nhatrangWeather.put(9, "25-31°C, nóng, nắng đẹp, mưa ít, tốt");
        nhatrangWeather.put(10, "23-29°C, mát dần, mưa nhiều, gió mùa");
        nhatrangWeather.put(11, "21-27°C, mát mẻ, mưa nhiều, mùa mưa");
        nhatrangWeather.put(12, "20-26°C, mát mẻ, mưa, cuối mùa mưa");
        CITY_MONTH_WEATHER.put("nha trang", nhatrangWeather);
    }

    private static void initializeQuynhonWeather() {
        Map<Integer, String> quynhonWeather = new HashMap<>();
        quynhonWeather.put(1, "20-27°C, nóng, nắng đẹp, khô ráo, lý tưởng");
        quynhonWeather.put(2, "21-28°C, nóng, nắng đẹp, khô ráo, rất tốt");
        quynhonWeather.put(3, "23-30°C, nóng, nắng đẹp, khô ráo, lý tưởng");
        quynhonWeather.put(4, "25-31°C, nóng, nắng đẹp, khô ráo, tốt");
        quynhonWeather.put(5, "26-32°C, nóng, nắng đẹp, khô ráo, tốt");
        quynhonWeather.put(6, "27-33°C, nóng, nắng đẹp, khô ráo, tốt");
        quynhonWeather.put(7, "27-33°C, nóng, nắng đẹp, khô ráo, tốt");
        quynhonWeather.put(8, "26-32°C, nóng, nắng đẹp, khô ráo, tốt");
        quynhonWeather.put(9, "25-31°C, nóng, nắng đẹp, mưa ít, tốt");
        quynhonWeather.put(10, "23-29°C, mát dần, mưa nhiều hơn");
        quynhonWeather.put(11, "21-27°C, mát mẻ, mưa nhiều");
        quynhonWeather.put(12, "20-26°C, mát mẻ, mưa, cuối mùa mưa");
        CITY_MONTH_WEATHER.put("quy nhon", quynhonWeather);
    }

    private static void initializeHcmcWeather() {
        Map<Integer, String> hcmcWeather = new HashMap<>();
        hcmcWeather.put(1, "21-32°C, nóng, khô ráo, nắng đẹp, lý tưởng");
        hcmcWeather.put(2, "22-33°C, nóng, khô ráo, nắng đẹp, rất tốt");
        hcmcWeather.put(3, "24-34°C, nóng, khô ráo, nắng đẹp, tốt");
        hcmcWeather.put(4, "26-35°C, rất nóng, khô ráo, nắng gắt");
        hcmcWeather.put(5, "26-34°C, nóng, bắt đầu mùa mưa, mưa chiều");
        hcmcWeather.put(6, "25-33°C, nóng, mưa nhiều, mưa to chiều");
        hcmcWeather.put(7, "24-32°C, nóng, mưa nhiều, đỉnh mùa mưa");
        hcmcWeather.put(8, "24-32°C, nóng, mưa nhiều, mưa to");
        hcmcWeather.put(9, "24-32°C, nóng, mưa nhiều, mưa dông");
        hcmcWeather.put(10, "24-32°C, nóng, mưa giảm, thời tiết cải thiện");
        hcmcWeather.put(11, "23-32°C, nóng, khô dần, thời tiết đẹp");
        hcmcWeather.put(12, "22-31°C, nóng, khô ráo, nắng đẹp, tốt");
        CITY_MONTH_WEATHER.put("tp hồ chí minh", hcmcWeather);
    }

    private static void initializeVungtauWeather() {
        Map<Integer, String> vungtauWeather = new HashMap<>();
        vungtauWeather.put(1, "22-30°C, nóng, khô ráo, nắng đẹp, lý tưởng");
        vungtauWeather.put(2, "23-31°C, nóng, khô ráo, nắng đẹp, rất tốt");
        vungtauWeather.put(3, "25-32°C, nóng, khô ráo, nắng đẹp, tốt");
        vungtauWeather.put(4, "27-33°C, nóng, khô ráo, nắng gắt");
        vungtauWeather.put(5, "27-33°C, nóng, bắt đầu mùa mưa");
        vungtauWeather.put(6, "26-32°C, nóng, mưa nhiều, mưa chiều");
        vungtauWeather.put(7, "25-31°C, nóng, mưa nhiều, mưa to");
        vungtauWeather.put(8, "25-31°C, nóng, mưa nhiều, mưa dông");
        vungtauWeather.put(9, "25-31°C, nóng, mưa nhiều, gió mùa");
        vungtauWeather.put(10, "25-31°C, nóng, mưa giảm, thời tiết cải thiện");
        vungtauWeather.put(11, "24-31°C, nóng, khô dần, thời tiết đẹp");
        vungtauWeather.put(12, "23-30°C, nóng, khô ráo, nắng đẹp, tốt");
        CITY_MONTH_WEATHER.put("vũng tàu", vungtauWeather);
    }

    private static void initializeCanthoWeather() {
        Map<Integer, String> canthoWeather = new HashMap<>();
        canthoWeather.put(1, "21-32°C, nóng, khô ráo, nắng đẹp, lý tưởng");
        canthoWeather.put(2, "22-33°C, nóng, khô ráo, nắng đẹp, rất tốt");
        canthoWeather.put(3, "24-34°C, nóng, khô ráo, nắng đẹp, tốt");
        canthoWeather.put(4, "26-35°C, rất nóng, khô ráo, nắng gắt");
        canthoWeather.put(5, "26-34°C, nóng, bắt đầu mùa mưa");
        canthoWeather.put(6, "25-33°C, nóng, mưa nhiều, lũ bắt đầu");
        canthoWeather.put(7, "24-32°C, nóng, mưa nhiều, đỉnh mùa lũ");
        canthoWeather.put(8, "24-32°C, nóng, mưa nhiều, lũ cao");
        canthoWeather.put(9, "24-32°C, nóng, mưa nhiều, lũ lụt");
        canthoWeather.put(10, "24-32°C, nóng, mưa giảm, lũ rút");
        canthoWeather.put(11, "23-32°C, nóng, khô dần, thời tiết đẹp");
        canthoWeather.put(12, "22-31°C, nóng, khô ráo, nắng đẹp, tốt");
        CITY_MONTH_WEATHER.put("cần thơ", canthoWeather);
    }

    private static void initializePhuquocWeather() {
        Map<Integer, String> phuquocWeather = new HashMap<>();
        phuquocWeather.put(1, "23-30°C, nóng, khô ráo, nắng đẹp, lý tưởng");
        phuquocWeather.put(2, "24-31°C, nóng, khô ráo, nắng đẹp, rất tốt");
        phuquocWeather.put(3, "26-32°C, nóng, khô ráo, nắng đẹp, tốt");
        phuquocWeather.put(4, "27-33°C, nóng, khô ráo, nắng gắt");
        phuquocWeather.put(5, "27-32°C, nóng, bắt đầu mùa mưa");
        phuquocWeather.put(6, "26-31°C, nóng, mưa nhiều, mưa to");
        phuquocWeather.put(7, "25-30°C, nóng, mưa nhiều, mưa dông");
        phuquocWeather.put(8, "25-30°C, nóng, mưa nhiều, đỉnh mùa mưa");
        phuquocWeather.put(9, "25-30°C, nóng, mưa nhiều, mưa dông");
        phuquocWeather.put(10, "25-30°C, nóng, mưa giảm, thời tiết cải thiện");
        phuquocWeather.put(11, "24-30°C, nóng, khô dần, thời tiết đẹp");
        phuquocWeather.put(12, "23-29°C, nóng, khô ráo, nắng đẹp, tốt");
        CITY_MONTH_WEATHER.put("phú quốc", phuquocWeather);
    }

    private static void initializeDalatWeather() {
        Map<Integer, String> dalatWeather = new HashMap<>();
        dalatWeather.put(1, "12-24°C, mát mẻ, khô ráo, lạnh về đêm, có thể có sương mù");
        dalatWeather.put(2, "13-25°C, mát mẻ, khô ráo, thời tiết dễ chịu");
        dalatWeather.put(3, "15-26°C, ấm áp, khô ráo, hoa nở rộ, lý tưởng");
        dalatWeather.put(4, "16-27°C, ấm áp, khô ráo, thời tiết đẹp, tốt");
        dalatWeather.put(5, "17-26°C, ấm áp, khô ráo, cuối mùa khô, tốt");
        dalatWeather.put(6, "17-25°C, mát mẻ, bắt đầu mùa mưa, mưa chiều");
        dalatWeather.put(7, "17-25°C, mát mẻ, mưa nhiều, mưa to");
        dalatWeather.put(8, "17-25°C, mát mẻ, mưa nhiều, đỉnh mùa mưa");
        dalatWeather.put(9, "17-25°C, mát mẻ, mưa nhiều, mưa dông");
        dalatWeather.put(10, "16-25°C, mát mẻ, mưa giảm, thời tiết cải thiện");
        dalatWeather.put(11, "15-24°C, mát mẻ, khô dần, thời tiết đẹp");
        dalatWeather.put(12, "13-23°C, mát mẻ, khô ráo, lạnh về đêm, tốt");
        CITY_MONTH_WEATHER.put("đà lạt", dalatWeather);
    }

    private static void initializeBentreWeather() {
        Map<Integer, String> bentreWeather = new HashMap<>();
        bentreWeather.put(1, "22-32°C, nóng, khô ráo, nắng đẹp, lý tưởng");
        bentreWeather.put(2, "23-33°C, nóng, khô ráo, nắng đẹp, rất tốt");
        bentreWeather.put(3, "25-34°C, nóng, khô ráo, nắng đẹp, tốt");
        bentreWeather.put(4, "26-35°C, rất nóng, khô ráo, nắng gắt");
        bentreWeather.put(5, "26-34°C, nóng, bắt đầu mùa mưa, mưa chiều");
        bentreWeather.put(6, "25-33°C, nóng, mưa nhiều, mưa to");
        bentreWeather.put(7, "24-32°C, nóng, mưa nhiều, đỉnh mùa mưa");
        bentreWeather.put(8, "24-32°C, nóng, mưa nhiều, mưa dông");
        bentreWeather.put(9, "24-32°C, nóng, mưa nhiều, lũ lụt");
        bentreWeather.put(10, "24-32°C, nóng, mưa giảm, thời tiết cải thiện");
        bentreWeather.put(11, "23-32°C, nóng, khô dần, thời tiết đẹp");
        bentreWeather.put(12, "22-31°C, nóng, khô ráo, nắng đẹp, tốt");
        CITY_MONTH_WEATHER.put("bến tre", bentreWeather);
    }
}
