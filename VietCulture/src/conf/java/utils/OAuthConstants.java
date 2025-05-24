package utils;

/**
 * Enhanced OAuth Configuration Constants
 * Chứa tất cả cấu hình cho Google OAuth và hệ thống authentication
 * 
 * SECURITY NOTE: Sensitive data như Client Secret được load từ environment variables
 */
public class OAuthConstants {
    
    // Google OAuth Configuration - CHỈ PUBLIC DATA
    public static final String GOOGLE_CLIENT_ID = "615494968856-lmpij4au1k1gmcqmlgfrc70q4dghh7l2.apps.googleusercontent.com";
    
    // 🔒 REMOVED: GOOGLE_CLIENT_SECRET - Load from environment instead
    // Lý do: Client Secret không bao giờ được lưu trong source code
    
    // Google OAuth URLs
    public static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
    public static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    
    // OAuth Providers
    public static final String PROVIDER_GOOGLE = "google";
    public static final String PROVIDER_LOCAL = "local";
    public static final String PROVIDER_BOTH = "both";
    public static final String PROVIDER_FACEBOOK = "facebook";
    
    // User Types
    public static final String USER_TYPE_ADMIN = "ADMIN";
    public static final String USER_TYPE_HOST = "HOST";
    public static final String USER_TYPE_TRAVELER = "TRAVELER";
    
    // Session Attributes
    public static final String SESSION_USER = "user";
    public static final String SESSION_USER_ID = "userId";
    public static final String SESSION_USER_TYPE = "userType";
    public static final String SESSION_FULL_NAME = "fullName";
    public static final String SESSION_LOGIN_MESSAGE = "loginMessage";
    public static final String SESSION_AVATAR = "userAvatar";
    public static final String SESSION_EMAIL = "userEmail";
    
    // Session Timeout (in seconds)
    public static final int SESSION_TIMEOUT_DEFAULT = 30 * 60; // 30 minutes
    public static final int SESSION_TIMEOUT_REMEMBER = 7 * 24 * 60 * 60; // 7 days
    public static final int SESSION_TIMEOUT_GOOGLE = 60 * 60; // 1 hour for Google users
    
    // Request Attributes
    public static final String REQUEST_ERROR_MESSAGE = "errorMessage";
    public static final String REQUEST_SUCCESS_MESSAGE = "successMessage";
    public static final String REQUEST_RETURN_URL = "returnUrl";
    public static final String REQUEST_REDIRECT_URL = "redirectUrl";
    
    // Enhanced Error Messages
    public static final String ERROR_INVALID_TOKEN = "Token không hợp lệ";
    public static final String ERROR_GOOGLE_AUTH_FAILED = "Xác thực Google thất bại";
    public static final String ERROR_ACCOUNT_DISABLED = "Tài khoản đã bị vô hiệu hóa";
    public static final String ERROR_CREATE_ACCOUNT_FAILED = "Tạo tài khoản thất bại";
    public static final String ERROR_SYSTEM_ERROR = "Lỗi hệ thống, vui lòng thử lại";
    public static final String ERROR_EMAIL_EXISTS = "Email đã tồn tại trong hệ thống";
    public static final String ERROR_INVALID_CREDENTIALS = "Email hoặc mật khẩu không đúng";
    public static final String ERROR_EMAIL_NOT_VERIFIED = "Email chưa được xác thực";
    public static final String ERROR_ACCESS_DENIED = "Không có quyền truy cập";
    public static final String ERROR_SESSION_EXPIRED = "Phiên đăng nhập đã hết hạn";
    public static final String ERROR_INVALID_REQUEST = "Yêu cầu không hợp lệ";
    public static final String ERROR_GOOGLE_ID_CONFLICT = "Tài khoản Google đã được liên kết với email khác";
    public static final String ERROR_EMAIL_FORMAT_INVALID = "Định dạng email không hợp lệ";
    public static final String ERROR_GOOGLE_TOKEN_EXPIRED = "Token Google đã hết hạn";
    public static final String ERROR_NETWORK_ERROR = "Lỗi kết nối mạng";
    public static final String ERROR_DUPLICATE_ACCOUNT = "Tài khoản đã tồn tại";
    
    // Success Messages
    public static final String SUCCESS_LOGIN = "Đăng nhập thành công";
    public static final String SUCCESS_GOOGLE_LOGIN = "Đăng nhập Google thành công";
    public static final String SUCCESS_ACCOUNT_CREATED = "Tài khoản được tạo thành công";
    public static final String SUCCESS_LOGOUT = "Đăng xuất thành công";
    public static final String SUCCESS_PROFILE_UPDATED = "Cập nhật hồ sơ thành công";
    public static final String SUCCESS_PASSWORD_CHANGED = "Đổi mật khẩu thành công";
    public static final String SUCCESS_EMAIL_VERIFIED = "Email đã được xác thực";
    public static final String SUCCESS_ACCOUNT_LINKED = "Liên kết tài khoản thành công";
    
    // Redirect URLs - PRIVATE (không expose ra ngoài)
    private static final String ADMIN_DASHBOARD = "/admin/dashboard";
    private static final String HOST_DASHBOARD = "/host/dashboard";
    private static final String TRAVELER_HOME = "/";
    private static final String DEFAULT_HOME = "/";
    private static final String LOGIN_PAGE = "/login";
    
    // OAuth Scopes
    public static final String GOOGLE_SCOPE_PROFILE = "profile";
    public static final String GOOGLE_SCOPE_EMAIL = "email";
    public static final String GOOGLE_SCOPE_OPENID = "openid";
    
    // Security Constants
    public static final String CSRF_TOKEN_NAME = "csrfToken";
    public static final String REMEMBER_ME_COOKIE = "rememberMe";
    public static final int REMEMBER_ME_DURATION = 7 * 24 * 60 * 60; // 7 days in seconds
    public static final int MAX_LOGIN_ATTEMPTS = 5;
    public static final int LOGIN_LOCKOUT_DURATION = 15 * 60; // 15 minutes in seconds
    
    // Validation Constants
    public static final int MAX_EMAIL_LENGTH = 100;
    public static final int MAX_NAME_LENGTH = 100;
    public static final int MIN_PASSWORD_LENGTH = 6;
    public static final String EMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    
    // Database Constants
    public static final String DB_OAUTH_LOG_TABLE = "OAuthLogins";
    public static final String DB_USER_TABLE = "Users";
    public static final String DB_TRAVELER_TABLE = "Travelers";
    public static final String DB_HOST_TABLE = "Hosts";
    
    // Environment Variable Names for Sensitive Data
    public static final String ENV_GOOGLE_CLIENT_SECRET = "GOOGLE_CLIENT_SECRET";
    public static final String ENV_DATABASE_PASSWORD = "DB_PASSWORD";
    public static final String ENV_JWT_SECRET = "JWT_SECRET_KEY";
    
    /**
     * 🔒 Get Google Client Secret from environment variables
     * @return Client Secret from environment, null if not found
     */
    public static String getGoogleClientSecret() {
        String secret = System.getenv(ENV_GOOGLE_CLIENT_SECRET);
        if (secret == null || secret.trim().isEmpty()) {
            // Fallback to system properties (for development)
            secret = System.getProperty(ENV_GOOGLE_CLIENT_SECRET);
        }
        return secret;
    }
    
    /**
     * Validate if all required environment variables are set
     * @return true if all required secrets are available
     */
    public static boolean validateEnvironmentSecrets() {
        return getGoogleClientSecret() != null;
    }
    
    /**
     * Validate Google Client ID configuration
     * @return true if client ID is properly configured
     */
    public static boolean isValidGoogleClientId() {
        return GOOGLE_CLIENT_ID != null && 
               !GOOGLE_CLIENT_ID.trim().isEmpty() &&
               GOOGLE_CLIENT_ID.endsWith(".apps.googleusercontent.com") &&
               !GOOGLE_CLIENT_ID.contains("your-client-id") &&
               !GOOGLE_CLIENT_ID.contains("example");
    }
    
    /**
     * Get redirect URL based on user type with enhanced logic
     * @param userType User type (ADMIN, HOST, TRAVELER)
     * @param contextPath Application context path
     * @return Appropriate redirect URL
     */
    public static String getRedirectUrlByUserType(String userType, String contextPath) {
        if (userType == null || contextPath == null) {
            return DEFAULT_HOME;
        }
        
        switch (userType.toUpperCase().trim()) {
            case USER_TYPE_ADMIN:
                return contextPath + ADMIN_DASHBOARD;
            case USER_TYPE_HOST:
                return contextPath + HOST_DASHBOARD;
            case USER_TYPE_TRAVELER:
                return contextPath + TRAVELER_HOME;
            default:
                return contextPath + DEFAULT_HOME;
        }
    }
    
    /**
     * Get login page URL
     * @param contextPath Application context path
     * @return Login page URL
     */
    public static String getLoginUrl(String contextPath) {
        return (contextPath != null ? contextPath : "") + LOGIN_PAGE;
    }
    
    /**
     * Validate user type
     * @param userType User type to validate
     * @return true if valid user type
     */
    public static boolean isValidUserType(String userType) {
        if (userType == null) return false;
        
        String type = userType.toUpperCase().trim();
        return USER_TYPE_ADMIN.equals(type) || 
               USER_TYPE_HOST.equals(type) || 
               USER_TYPE_TRAVELER.equals(type);
    }
    
    /**
     * Validate OAuth provider
     * @param provider Provider to validate
     * @return true if valid provider
     */
    public static boolean isValidProvider(String provider) {
        if (provider == null) return false;
        
        String prov = provider.toLowerCase().trim();
        return PROVIDER_GOOGLE.equals(prov) || 
               PROVIDER_LOCAL.equals(prov) || 
               PROVIDER_BOTH.equals(prov) ||
               PROVIDER_FACEBOOK.equals(prov);
    }
    
    /**
     * Validate email format
     * @param email Email to validate
     * @return true if valid email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String trimmedEmail = email.trim();
        return trimmedEmail.length() <= MAX_EMAIL_LENGTH && 
               trimmedEmail.matches(EMAIL_REGEX);
    }
    
    /**
     * Validate full name
     * @param name Name to validate
     * @return true if valid name
     */
    public static boolean isValidName(String name) {
        if (name == null) return false;
        
        String trimmedName = name.trim();
        return !trimmedName.isEmpty() && 
               trimmedName.length() <= MAX_NAME_LENGTH &&
               !trimmedName.matches(".*[<>\"'&].*"); // Basic XSS prevention
    }
    
    /**
     * Get Google OAuth scopes as space-separated string
     * @return OAuth scopes
     */
    public static String getGoogleScopes() {
        return String.join(" ", GOOGLE_SCOPE_OPENID, GOOGLE_SCOPE_PROFILE, GOOGLE_SCOPE_EMAIL);
    }
    
    /**
     * Check if user has admin privileges
     * @param userType User type to check
     * @return true if user is admin
     */
    public static boolean isAdmin(String userType) {
        return USER_TYPE_ADMIN.equals(userType);
    }
    
    /**
     * Check if user has host privileges
     * @param userType User type to check
     * @return true if user is host or admin
     */
    public static boolean isHost(String userType) {
        return USER_TYPE_HOST.equals(userType) || USER_TYPE_ADMIN.equals(userType);
    }
    
    /**
     * Check if user has traveler privileges
     * @param userType User type to check
     * @return true if user is traveler, host, or admin
     */
    public static boolean isTraveler(String userType) {
        return USER_TYPE_TRAVELER.equals(userType) || 
               USER_TYPE_HOST.equals(userType) || 
               USER_TYPE_ADMIN.equals(userType);
    }
    
    /**
     * Get user type display name in Vietnamese
     * @param userType User type
     * @return Display name
     */
    public static String getUserTypeDisplayName(String userType) {
        if (userType == null) return "Không xác định";
        
        switch (userType.toUpperCase().trim()) {
            case USER_TYPE_ADMIN:
                return "Quản trị viên";
            case USER_TYPE_HOST:
                return "Chủ nhà";
            case USER_TYPE_TRAVELER:
                return "Du khách";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Get provider display name in Vietnamese
     * @param provider OAuth provider
     * @return Display name
     */
    public static String getProviderDisplayName(String provider) {
        if (provider == null) return "Không xác định";
        
        switch (provider.toLowerCase().trim()) {
            case PROVIDER_GOOGLE:
                return "Google";
            case PROVIDER_LOCAL:
                return "Tài khoản nội bộ";
            case PROVIDER_BOTH:
                return "Tài khoản liên kết";
            case PROVIDER_FACEBOOK:
                return "Facebook";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Get appropriate session timeout based on provider
     * @param provider OAuth provider
     * @param rememberMe Whether user chose remember me
     * @return Session timeout in seconds
     */
    public static int getSessionTimeout(String provider, boolean rememberMe) {
        if (rememberMe) {
            return SESSION_TIMEOUT_REMEMBER;
        }
        
        if (PROVIDER_GOOGLE.equals(provider)) {
            return SESSION_TIMEOUT_GOOGLE;
        }
        
        return SESSION_TIMEOUT_DEFAULT;
    }
    
    /**
     * Check if URL is safe for redirect
     * @param url URL to check
     * @param contextPath Application context path
     * @return true if URL is safe
     */
    public static boolean isSafeRedirectUrl(String url, String contextPath) {
        if (url == null || url.trim().isEmpty()) {
            return false;
        }
        
        String trimmedUrl = url.trim();
        
        // Must be relative URL
        if (!trimmedUrl.startsWith("/")) {
            return false;
        }
        
        // Prevent protocol-relative URLs
        if (trimmedUrl.startsWith("//")) {
            return false;
        }
        
        // Prevent data URLs and javascript URLs
        if (trimmedUrl.toLowerCase().contains("javascript:") || 
            trimmedUrl.toLowerCase().contains("data:")) {
            return false;
        }
        
        // If context path is provided, URL should start with it or be root
        if (contextPath != null && !contextPath.isEmpty()) {
            return trimmedUrl.equals("/") || trimmedUrl.startsWith(contextPath + "/");
        }
        
        return true;
    }
    
    /**
     * Sanitize string for logging (remove sensitive data)
     * @param input Input string
     * @return Sanitized string
     */
    public static String sanitizeForLog(String input) {
        if (input == null) return "null";
        
        // Remove potential sensitive patterns
        return input.replaceAll("(?i)(password|token|secret|key)=[^&\\s]*", "$1=***")
                   .replaceAll("Bearer [A-Za-z0-9\\-_]+", "Bearer ***")
                   .replaceAll("GOCSPX-[A-Za-z0-9_-]+", "GOCSPX-***"); // Google Client Secret pattern
    }
    
    /**
     * Get error message for HTTP status code
     * @param statusCode HTTP status code
     * @return Appropriate error message
     */
    public static String getErrorMessageForStatus(int statusCode) {
        switch (statusCode) {
            case 400:
                return ERROR_INVALID_REQUEST;
            case 401:
                return ERROR_INVALID_CREDENTIALS;
            case 403:
                return ERROR_ACCESS_DENIED;
            case 409:
                return ERROR_DUPLICATE_ACCOUNT;
            case 500:
                return ERROR_SYSTEM_ERROR;
            default:
                return ERROR_SYSTEM_ERROR;
        }
    }
}