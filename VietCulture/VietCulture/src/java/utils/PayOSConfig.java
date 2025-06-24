package utils;

/**
 * PayOS Configuration - Fixed Endpoints
 */
public class PayOSConfig {
    
    // ==================== PAYOS CREDENTIALS ====================
    public static final String CLIENT_ID = "c8808ca8-6183-4cc4-bd68-e1f278f5fe7d";
    public static final String API_KEY = "2202e203-d95a-4f6b-bf8f-db1a3bcec1c0"; 
    public static final String CHECKSUM_KEY = "d6e0e013bffc980473af930350d0237df45a7be90cdb40b2aa3c1af7aa884c7b";
    
    // ==================== API ENDPOINTS ====================
    // ✅ Fixed endpoints based on PayOS documentation
    public static final String PAYOS_API_BASE_URL = "https://api-merchant.payos.vn";
    public static final String PAYOS_SANDBOX_URL = "https://api-merchant.payos.vn"; // Same for sandbox
    
    public static final String CREATE_PAYMENT_ENDPOINT = "/v2/payment-requests";
    public static final String GET_PAYMENT_ENDPOINT = "/v2/payment-requests/";
    
    // ==================== ENVIRONMENT SETTINGS ====================
    public static final boolean IS_SANDBOX = true;
    public static final boolean ENABLE_MOCK_MODE = false; // ✅ DISABLED FOR REAL PAYOS
    public static final boolean ENABLE_URL_FAILOVER = true; // Enable fallback URLs
    
    // ==================== PAYMENT SETTINGS ====================
    public static final int DEFAULT_EXPIRY_MINUTES = 15;
    public static final int MIN_AMOUNT = 1000;
    public static final int MAX_AMOUNT = 500000000;
    
    // ==================== TIMEOUT SETTINGS ====================
    public static final int CONNECTION_TIMEOUT_MS = 30000; // Increased to 30 seconds
    public static final int READ_TIMEOUT_MS = 30000;
    
    // ==================== URL MANAGEMENT ====================
    
    /**
     * Get PayOS API base URL
     */
    public static String getApiBaseUrl() {
        if (ENABLE_MOCK_MODE) {
            return "http://localhost:8080/mock-payos";
        }
        // Always use the main endpoint
        return PAYOS_API_BASE_URL;
    }
    
    /**
     * Get alternative URLs for failover
     */
    public static String[] getAlternativeUrls() {
        return new String[] {
            "https://api-merchant.payos.vn",
            "https://api.payos.vn",
            "https://merchant-api.payos.vn",
            "https://sandbox.payos.vn/api"
        };
    }
    
    // ==================== CONFIGURATION VALIDATION ====================
    
    /**
     * Check if PayOS is configured
     */
    public static boolean isConfigured() {
        if (ENABLE_MOCK_MODE) {
            return true; // Mock mode is always configured
        }
        
        return CLIENT_ID != null && !CLIENT_ID.trim().isEmpty() &&
               API_KEY != null && !API_KEY.trim().isEmpty() &&
               CHECKSUM_KEY != null && !CHECKSUM_KEY.trim().isEmpty();
    }
    
    /**
     * Test network connectivity to PayOS
     */
    public static boolean testPayOSConnectivity() {
        String[] urlsToTest = {
            "https://api-merchant.payos.vn",
            "https://api.payos.vn",
            "https://payos.vn"
        };
        
        for (String testUrl : urlsToTest) {
            try {
                System.out.println("Testing connectivity to: " + testUrl);
                java.net.URL url = new java.net.URL(testUrl);
                java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
                connection.setRequestMethod("HEAD");
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(5000);
                connection.setRequestProperty("User-Agent", "VietCulture/1.0");
                
                int responseCode = connection.getResponseCode();
                connection.disconnect();
                
                if (responseCode < 500) { // Accept any non-server error
                    System.out.println("✅ " + testUrl + " is accessible (HTTP " + responseCode + ")");
                    return true;
                } else {
                    System.out.println("⚠️ " + testUrl + " returned HTTP " + responseCode);
                }
            } catch (Exception e) {
                System.out.println("❌ " + testUrl + " failed: " + e.getMessage());
            }
        }
        return false;
    }
    
    /**
     * Check if general network is accessible
     */
    public static boolean isNetworkAccessible() {
        if (ENABLE_MOCK_MODE) {
            return true;
        }
        
        // Simple network check
        try {
            java.net.URL url = new java.net.URL("https://google.com");
            java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
            connection.setRequestMethod("HEAD");
            connection.setConnectTimeout(3000);
            connection.setReadTimeout(3000);
            int responseCode = connection.getResponseCode();
            connection.disconnect();
            return responseCode == 200;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Get detailed configuration status
     */
    public static String getConfigurationStatus() {
        if (ENABLE_MOCK_MODE) {
            return "🧪 MOCK MODE ENABLED\n" +
                   "✅ Credentials: Not required in mock mode\n" +
                   "✅ Network: Mock server accessible\n" +
                   "Environment: MOCK\n" +
                   "API URL: Mock Server";
        }
        
        StringBuilder status = new StringBuilder();
        status.append("=== PayOS Configuration Status ===\n");
        status.append(isConfigured() ? "✅ Credentials: Valid" : "❌ Credentials: Invalid").append("\n");
        status.append("✅ Client ID: ").append(CLIENT_ID != null ? CLIENT_ID.substring(0, 8) + "..." : "null").append("\n");
        status.append("✅ API Key: ").append(API_KEY != null ? API_KEY.substring(0, 8) + "..." : "null").append("\n");
        status.append(isNetworkAccessible() ? "✅ Network: Accessible" : "❌ Network: Inaccessible").append("\n");
        status.append("Environment: ").append(IS_SANDBOX ? "SANDBOX" : "PRODUCTION").append("\n");
        status.append("API URL: ").append(getApiBaseUrl()).append("\n");
        status.append("Failover: ").append(ENABLE_URL_FAILOVER ? "Enabled" : "Disabled").append("\n");
        
        // Test PayOS connectivity
        status.append("\n=== PayOS Connectivity Test ===\n");
        boolean payosConnected = testPayOSConnectivity();
        status.append("PayOS Accessible: ").append(payosConnected ? "✅ OK" : "❌ FAILED").append("\n");
        
        return status.toString();
    }
    
    /**
     * Validate configuration and throw exception if invalid
     */
    public static void validateConfiguration() throws IllegalStateException {
        if (ENABLE_MOCK_MODE) {
            System.out.println("[PayOS Config] ⚠️  MOCK MODE ENABLED - Using fake PayOS for testing");
            System.out.println("[PayOS Config] 🔧 Set ENABLE_MOCK_MODE = false for real PayOS");
            return;
        }
        
        if (!isConfigured()) {
            throw new IllegalStateException("PayOS credentials incomplete. Check CLIENT_ID, API_KEY, and CHECKSUM_KEY.");
        }
        
        System.out.println("[PayOS Config] Configuration validated successfully");
        System.out.println("[PayOS Config] Environment: " + (IS_SANDBOX ? "SANDBOX" : "PRODUCTION"));
        System.out.println("[PayOS Config] Base URL: " + getApiBaseUrl());
        
        // Test connectivity but don't fail on network issues
        System.out.println("[PayOS Config] Testing connectivity...");
        if (!testPayOSConnectivity()) {
            System.out.println("[PayOS Config] ⚠️ PayOS connectivity issues detected, but continuing...");
        } else {
            System.out.println("[PayOS Config] ✅ PayOS connectivity OK");
        }
    }
    
    // ==================== UTILITY METHODS ====================
    
    /**
     * Get payment expiry timestamp
     */
    public static int getPaymentExpiry(int minutes) {
        return (int) (System.currentTimeMillis() / 1000) + (minutes * 60);
    }
    
    /**
     * Get default payment expiry (15 minutes from now)
     */
    public static int getDefaultPaymentExpiry() {
        return getPaymentExpiry(DEFAULT_EXPIRY_MINUTES);
    }
    
    /**
     * Check if amount is valid for PayOS
     */
    public static boolean isValidAmount(int amount) {
        return amount >= MIN_AMOUNT && amount <= MAX_AMOUNT;
    }
    
    /**
     * Format double amount to integer (VND)
     */
    public static int formatAmount(double amount) {
        return (int) Math.round(amount);
    }
    
    /**
     * Generate order description for experience booking
     */
    public static String generateExperienceOrderDescription(int bookingId, String experienceTitle) {
        String title = experienceTitle != null ? experienceTitle : "Trải nghiệm";
        if (title.length() > 50) {
            title = title.substring(0, 47) + "...";
        }
        return String.format("VietCulture #%d - %s", bookingId, title);
    }
    
    /**
     * Generate order description for accommodation booking
     */
    public static String generateAccommodationOrderDescription(int bookingId, String accommodationName) {
        String name = accommodationName != null ? accommodationName : "Lưu trú";
        if (name.length() > 50) {
            name = name.substring(0, 47) + "...";
        }
        return String.format("VietCulture #%d - %s", bookingId, name);
    }
    
    // ==================== PAYMENT STATUS CONSTANTS ====================
    
    public static final class PaymentStatus {
        public static final String PENDING = "PENDING";
        public static final String PROCESSING = "PROCESSING";
        public static final String PAID = "PAID";
        public static final String COMPLETED = "COMPLETED";
        public static final String CANCELLED = "CANCELLED";
        public static final String EXPIRED = "EXPIRED";
        public static final String FAILED = "FAILED";
        
        private PaymentStatus() {
            throw new IllegalStateException("Utility class");
        }
    }
    
    /**
     * Get user-friendly status message
     */
    public static String getStatusMessage(String status) {
        switch (status != null ? status : "") {
            case PaymentStatus.PENDING:
                return "Đang chờ thanh toán";
            case PaymentStatus.PROCESSING:
                return "Đang xử lý thanh toán";
            case PaymentStatus.PAID:
            case PaymentStatus.COMPLETED:
                return "Thanh toán thành công";
            case PaymentStatus.CANCELLED:
                return "Thanh toán đã bị hủy";
            case PaymentStatus.EXPIRED:
                return "Thanh toán đã hết hạn";
            case PaymentStatus.FAILED:
                return "Thanh toán thất bại";
            default:
                return "Trạng thái không xác định: " + status;
        }
    }
    
    /**
     * Format amount to VND string
     */
    public static String formatVND(int amount) {
        return String.format("%,d VNĐ", amount);
    }
    
    /**
     * Format double amount to VND string
     */
    public static String formatVND(double amount) {
        return formatVND((int) Math.round(amount));
    }
    
    /**
     * Check if status indicates payment is complete
     */
    public static boolean isPaymentComplete(String status) {
        return PaymentStatus.PAID.equals(status) || PaymentStatus.COMPLETED.equals(status);
    }
    
    /**
     * Check if status indicates payment is final (no more changes expected)
     */
    public static boolean isPaymentFinal(String status) {
        return isPaymentComplete(status) || 
               PaymentStatus.CANCELLED.equals(status) || 
               PaymentStatus.EXPIRED.equals(status) ||
               PaymentStatus.FAILED.equals(status);
    }
    
    // ==================== STATIC INITIALIZATION ====================
    
    static {
        if (ENABLE_MOCK_MODE) {
            System.out.println("[PayOS Config] 🧪 MOCK MODE ENABLED - PayOS calls will be simulated");
            System.out.println("[PayOS Config] 🔧 Set ENABLE_MOCK_MODE = false for real PayOS integration");
        } else {
            System.out.println("[PayOS Config] 🚀 PayOS Integration Mode: " + (IS_SANDBOX ? "SANDBOX" : "PRODUCTION"));
            System.out.println("[PayOS Config] 📡 API Endpoint: " + PAYOS_API_BASE_URL);
        }
    }
    
    // ==================== CONSTRUCTOR ====================
    
    private PayOSConfig() {
        throw new IllegalStateException("Utility class - cannot be instantiated");
    }
}