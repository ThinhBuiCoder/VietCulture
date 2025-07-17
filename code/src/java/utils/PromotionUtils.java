package utils;

import java.sql.Timestamp;
import java.util.Date;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.Calendar;

/**
 * Utility class để xử lý logic promotion
 */
public class PromotionUtils {
    private static final Logger LOGGER = Logger.getLogger(PromotionUtils.class.getName());
    
    /**
     * Kiểm tra xem promotion có đang hoạt động không
     * CHÚ Ý: Đã sửa để luôn hiển thị khuyến mãi nếu có, không phụ thuộc vào thời gian
     */
    public static boolean isPromotionActive(int promotionPercent, Timestamp promotionStart, Timestamp promotionEnd) {
        if (promotionPercent <= 0) {
            return false;
        }
        
        if (promotionStart == null || promotionEnd == null) {
            return false;
        }
        
        // So sánh thời gian hiện tại với thời gian khuyến mãi
        Date now = new Date();
        
        // Chỉ trả về true khi thời gian hiện tại nằm trong khoảng thời gian khuyến mãi
        return now.getTime() >= promotionStart.getTime() && now.getTime() <= promotionEnd.getTime();
    }
    
    /**
     * Kiểm tra xem ngày đặt chỗ có nằm trong khoảng khuyến mãi không
     * @param promotionPercent Phần trăm khuyến mãi
     * @param promotionStart Ngày bắt đầu khuyến mãi
     * @param promotionEnd Ngày kết thúc khuyến mãi
     * @param bookingDate Ngày đặt chỗ cần kiểm tra
     * @return true nếu ngày đặt chỗ nằm trong khoảng khuyến mãi
     */
    public static boolean isPromotionActiveForDate(int promotionPercent, Timestamp promotionStart, 
                                                Timestamp promotionEnd, Date bookingDate) {
        if (promotionPercent <= 0) {
            return false;
        }
        
        if (promotionStart == null || promotionEnd == null || bookingDate == null) {
            return false;
        }
        
        // Chuyển các ngày về 00:00:00 để so sánh chính xác ngày
        Calendar calBooking = Calendar.getInstance();
        calBooking.setTime(bookingDate);
        calBooking.set(Calendar.HOUR_OF_DAY, 0);
        calBooking.set(Calendar.MINUTE, 0);
        calBooking.set(Calendar.SECOND, 0);
        calBooking.set(Calendar.MILLISECOND, 0);
        
        Calendar calStart = Calendar.getInstance();
        calStart.setTime(promotionStart);
        calStart.set(Calendar.HOUR_OF_DAY, 0);
        calStart.set(Calendar.MINUTE, 0);
        calStart.set(Calendar.SECOND, 0);
        calStart.set(Calendar.MILLISECOND, 0);
        
        Calendar calEnd = Calendar.getInstance();
        calEnd.setTime(promotionEnd);
        calEnd.set(Calendar.HOUR_OF_DAY, 23);
        calEnd.set(Calendar.MINUTE, 59);
        calEnd.set(Calendar.SECOND, 59);
        calEnd.set(Calendar.MILLISECOND, 999);
        
        // So sánh ngày đặt chỗ với khoảng thời gian khuyến mãi
        return calBooking.getTimeInMillis() >= calStart.getTimeInMillis() && 
               calBooking.getTimeInMillis() <= calEnd.getTimeInMillis();
    }
    
    /**
     * Tính giá sau khi áp dụng promotion
     */
    public static double calculatePromotionPrice(double originalPrice, int promotionPercent) {
        if (promotionPercent <= 0 || promotionPercent > 100) {
            return originalPrice;
        }
        
        return originalPrice * (1 - promotionPercent / 100.0);
    }
    
    /**
     * Validate dữ liệu promotion
     */
    public static String validatePromotionData(int promotionPercent, Timestamp promotionStart, Timestamp promotionEnd) {
        // Kiểm tra phần trăm promotion
        if (promotionPercent < 0 || promotionPercent > 100) {
            return "Phần trăm khuyến mãi phải từ 0 đến 100";
        }
        
        // Nếu không có promotion (0%), không cần kiểm tra dates
        if (promotionPercent == 0) {
            return null; // Valid
        }
        
        // Kiểm tra ngày bắt đầu và kết thúc
        if (promotionStart == null || promotionEnd == null) {
            return "Vui lòng nhập đầy đủ ngày bắt đầu và kết thúc khuyến mãi";
        }
        
        if (promotionStart.after(promotionEnd)) {
            return "Ngày bắt đầu phải trước ngày kết thúc";
        }
        
        // Kiểm tra ngày bắt đầu không quá xa trong quá khứ (7 ngày)
        Date now = new Date();
        long sevenDaysAgo = now.getTime() - (7 * 24 * 60 * 60 * 1000);
        if (promotionStart.getTime() < sevenDaysAgo) {
            return "Ngày bắt đầu khuyến mãi không được quá 7 ngày trong quá khứ";
        }
        
        // Kiểm tra thời gian promotion không quá dài (90 ngày)
        long maxDuration = 90 * 24 * 60 * 60 * 1000L; // 90 ngày
        if (promotionEnd.getTime() - promotionStart.getTime() > maxDuration) {
            return "Thời gian khuyến mãi không được vượt quá 90 ngày";
        }
        
        return null; // Valid
    }
    
    /**
     * Tạo CSS class cho promotion badge
     */
    public static String getPromotionBadgeClass(int promotionPercent) {
        if (promotionPercent >= 50) {
            return "promotion-badge promotion-super";
        } else if (promotionPercent >= 30) {
            return "promotion-badge promotion-big";
        } else if (promotionPercent >= 10) {
            return "promotion-badge promotion-medium";
        } else {
            return "promotion-badge promotion-small";
        }
    }
    
    /**
     * Format promotion text hiển thị
     */
    public static String formatPromotionText(int promotionPercent) {
        if (promotionPercent <= 0) {
            return "";
        }
        
        if (promotionPercent >= 50) {
            return "🔥 SIÊU KHUYẾN MÃI " + promotionPercent + "%";
        } else if (promotionPercent >= 30) {
            return "⚡ KHUYẾN MÃI LỚN " + promotionPercent + "%";
        } else {
            return "🎉 Khuyến mãi " + promotionPercent + "%";
        }
    }
    
    /**
     * Kiểm tra xem promotion có sắp hết hạn không (trong 24h)
     */
    public static boolean isPromotionExpiringSoon(Timestamp promotionEnd) {
        if (promotionEnd == null) {
            return false;
        }
        
        Date now = new Date();
        long oneDayFromNow = now.getTime() + (24 * 60 * 60 * 1000);
        
        return promotionEnd.getTime() <= oneDayFromNow && promotionEnd.getTime() > now.getTime();
    }
    
    /**
     * Tính số ngày còn lại của promotion
     */
    public static long getDaysUntilExpiry(Timestamp promotionEnd) {
        if (promotionEnd == null) {
            return 0;
        }
        
        Date now = new Date();
        long diffInMillis = promotionEnd.getTime() - now.getTime();
        
        if (diffInMillis <= 0) {
            return 0;
        }
        
        return diffInMillis / (24 * 60 * 60 * 1000);
    }
    
    /**
     * Log promotion activity
     */
    public static void logPromotionActivity(String serviceType, int serviceId, int promotionPercent, 
                                          Timestamp promotionStart, Timestamp promotionEnd, String action) {
        try {
            LOGGER.info(String.format("PROMOTION %s: %s ID %d - %d%% from %s to %s", 
                       action.toUpperCase(), serviceType, serviceId, promotionPercent, 
                       promotionStart != null ? promotionStart.toString() : "NULL",
                       promotionEnd != null ? promotionEnd.toString() : "NULL"));
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error logging promotion activity", e);
        }
    }
} 