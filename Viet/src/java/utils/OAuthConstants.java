package utils;

public class OAuthConstants {
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Google OAuth Configuration
    public static final String GOOGLE_CLIENT_ID = "106009165959-sbaj5qlt77p65jj33qp62kjle5ggchff.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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"; // Bạn cần lấy từ Google Console
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/Travel/auth/google";
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // OAuth URLs
    public static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
    public static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    public static final String GOOGLE_REVOKE_URL = "https://oauth2.googleapis.com/revoke";
<<<<<<< HEAD

    // OAuth Scopes
    public static final String GOOGLE_SCOPE = "email profile openid";

=======
    
    // OAuth Scopes
    public static final String GOOGLE_SCOPE = "email profile openid";
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Session Keys
    public static final String SESSION_USER = "user";
    public static final String SESSION_USER_ID = "userId";
    public static final String SESSION_USER_TYPE = "userType";
    public static final String SESSION_FULL_NAME = "fullName";
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Error Messages
    public static final String ERROR_INVALID_CREDENTIALS = "Email hoặc mật khẩu không đúng.";
    public static final String ERROR_ACCOUNT_DISABLED = "Tài khoản đã bị vô hiệu hóa.";
    public static final String ERROR_EMAIL_NOT_VERIFIED = "Email chưa được xác thực.";
    public static final String ERROR_OAUTH_CANCELLED = "Đăng nhập Google đã bị hủy.";
    public static final String ERROR_OAUTH_FAILED = "Đăng nhập Google thất bại.";
    public static final String ERROR_TOKEN_EXCHANGE_FAILED = "Không thể trao đổi mã xác thực.";
    public static final String ERROR_USERINFO_FAILED = "Không thể lấy thông tin người dùng.";
    public static final String ERROR_PROCESSING_FAILED = "Có lỗi xảy ra khi xử lý đăng nhập.";
    public static final String ERROR_GOOGLE_LOGIN_FAILED = "Đăng nhập Google thất bại.";
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Success Messages
    public static final String SUCCESS_ACCOUNT_CREATED = "Tài khoản đã được tạo thành công!";
    public static final String SUCCESS_LOGIN = "Đăng nhập thành công!";
    public static final String SUCCESS_LOGOUT = "Đăng xuất thành công!";
    public static final String SUCCESS_EMAIL_VERIFIED = "Email đã được xác thực thành công!";
    public static final String SUCCESS_PASSWORD_RESET = "Mật khẩu đã được đặt lại!";
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Validation Constants
    public static final int MIN_PASSWORD_LENGTH = 8;
    public static final int MAX_PASSWORD_LENGTH = 100;
    public static final int MAX_EMAIL_LENGTH = 255;
    public static final int MAX_NAME_LENGTH = 100;
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Default Values
    public static final String DEFAULT_USER_TYPE = "TRAVELER";
    public static final String DEFAULT_PROVIDER = "local";
    public static final String GOOGLE_PROVIDER = "google";
    public static final String COMBINED_PROVIDER = "both";
<<<<<<< HEAD

    // Session Timeout (in seconds)
    public static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes
    public static final int REMEMBER_ME_TIMEOUT = 7 * 24 * 60 * 60; // 7 days

    // OAuth State Parameter Length
    public static final int OAUTH_STATE_LENGTH = 32;

    // Token Expiry (in milliseconds)
    public static final long ID_TOKEN_EXPIRY = 3600 * 1000; // 1 hour
    public static final long ACCESS_TOKEN_EXPIRY = 3600 * 1000; // 1 hour

    private OAuthConstants() {
        // Utility class - prevent instantiation
    }

=======
    
    // Session Timeout (in seconds)
    public static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes
    public static final int REMEMBER_ME_TIMEOUT = 7 * 24 * 60 * 60; // 7 days
    
    // OAuth State Parameter Length
    public static final int OAUTH_STATE_LENGTH = 32;
    
    // Token Expiry (in milliseconds)
    public static final long ID_TOKEN_EXPIRY = 3600 * 1000; // 1 hour
    public static final long ACCESS_TOKEN_EXPIRY = 3600 * 1000; // 1 hour
    
    private OAuthConstants() {
        // Utility class - prevent instantiation
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Generate Google OAuth URL
     */
    public static String generateGoogleOAuthUrl(String state) {
        StringBuilder url = new StringBuilder(GOOGLE_AUTH_URL);
        url.append("?scope=").append(GOOGLE_SCOPE.replace(" ", "%20"));
        url.append("&redirect_uri=").append(GOOGLE_REDIRECT_URI);
        url.append("&response_type=code");
        url.append("&client_id=").append(GOOGLE_CLIENT_ID);
        url.append("&access_type=offline");
        url.append("&prompt=consent");
<<<<<<< HEAD

        if (state != null && !state.isEmpty()) {
            url.append("&state=").append(state);
        }

        return url.toString();
    }
}
=======
        
        if (state != null && !state.isEmpty()) {
            url.append("&state=").append(state);
        }
        
        return url.toString();
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
