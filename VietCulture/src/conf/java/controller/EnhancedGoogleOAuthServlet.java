package controller;

import dao.UserDAO;
import model.User;
import utils.PasswordUtils;
import utils.OAuthConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.UUID;
import java.util.Base64;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

// JSON Simple imports
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/auth/google")
public class EnhancedGoogleOAuthServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EnhancedGoogleOAuthServlet.class.getName());
    
    private UserDAO userDAO;
    private final JSONParser jsonParser = new JSONParser();
    
    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
            
            // Validate Google OAuth configuration
            if (!OAuthConstants.isValidGoogleClientId()) {
                throw new ServletException("Invalid Google Client ID configuration");
            }
            
            LOGGER.info("Enhanced GoogleOAuthServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize GoogleOAuthServlet", e);
            throw new ServletException("Failed to initialize Google OAuth", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response headers
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Get parameters
        String idTokenString = request.getParameter("idToken");
        String returnUrl = request.getParameter("returnUrl");
        
        // Get client info for security logging
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");
        
        LOGGER.info(String.format("Google OAuth request from IP: %s, UserAgent: %s", 
                   OAuthConstants.sanitizeForLog(ipAddress), 
                   OAuthConstants.sanitizeForLog(userAgent)));
        
        // Validate input
        if (!validateInput(idTokenString, response)) {
            return;
        }
        
        try {
            // Process OAuth asynchronously for better performance
            CompletableFuture<Void> authFuture = CompletableFuture.runAsync(() -> {
                try {
                    processGoogleAuth(request, response, idTokenString, returnUrl, ipAddress, userAgent);
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Async OAuth processing failed", e);
                    try {
                        sendErrorResponse(response, OAuthConstants.ERROR_SYSTEM_ERROR, 500);
                    } catch (IOException ioException) {
                        LOGGER.log(Level.SEVERE, "Failed to send error response", ioException);
                    }
                }
            });
            
            // Wait with timeout
            authFuture.get(30, TimeUnit.SECONDS);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during Google OAuth processing", e);
            sendErrorResponse(response, OAuthConstants.ERROR_SYSTEM_ERROR + ": " + e.getMessage(), 500);
        }
    }
    
    private boolean validateInput(String idTokenString, HttpServletResponse response) throws IOException {
        if (idTokenString == null || idTokenString.trim().isEmpty()) {
            LOGGER.warning("Missing idToken parameter");
            sendErrorResponse(response, OAuthConstants.ERROR_INVALID_TOKEN, 400);
            return false;
        }
        
        // Basic JWT format validation
        String[] tokenParts = idTokenString.split("\\.");
        if (tokenParts.length != 3) {
            LOGGER.warning("Invalid JWT token format");
            sendErrorResponse(response, OAuthConstants.ERROR_INVALID_TOKEN, 400);
            return false;
        }
        
        return true;
    }
    
    private void processGoogleAuth(HttpServletRequest request, HttpServletResponse response,
                                 String idTokenString, String returnUrl, String ipAddress, String userAgent) 
            throws IOException, SQLException {
        
        // Verify and decode JWT token
        JSONObject payload = verifyGoogleIdToken(idTokenString);
        
        if (payload == null) {
            LOGGER.warning("Google ID token verification failed");
            sendErrorResponse(response, OAuthConstants.ERROR_GOOGLE_AUTH_FAILED, 401);
            return;
        }
        
        // Extract user information
        UserInfo userInfo = extractUserInfo(payload);
        if (!userInfo.isValid()) {
            sendErrorResponse(response, OAuthConstants.ERROR_INVALID_REQUEST, 400);
            return;
        }
        
        LOGGER.info(String.format("Google OAuth success - Email: %s, Name: %s", 
                   userInfo.email, userInfo.name));
        
        // Check if user exists
        User existingUser = userDAO.getUserByEmail(userInfo.email);
        
        if (existingUser != null) {
            handleExistingUser(request, response, existingUser, userInfo, 
                             ipAddress, userAgent, returnUrl);
        } else {
            handleNewUser(request, response, userInfo, ipAddress, userAgent, returnUrl);
        }
    }
    
    /**
     * Enhanced JWT token verification with better security
     */
    private JSONObject verifyGoogleIdToken(String idToken) {
        try {
            String[] parts = idToken.split("\\.");
            if (parts.length != 3) {
                LOGGER.warning("Invalid JWT format");
                return null;
            }
            
            // Decode payload (second part)
            String payload = parts[1];
            
            // Add padding if needed for Base64 decoding
            while (payload.length() % 4 != 0) {
                payload += "=";
            }
            
            byte[] decodedBytes = Base64.getUrlDecoder().decode(payload);
            String decodedPayload = new String(decodedBytes, "UTF-8");
            
            LOGGER.fine("Decoded JWT payload: " + OAuthConstants.sanitizeForLog(decodedPayload));
            
            // Parse JSON using JSON Simple
            JSONObject jsonObject = (JSONObject) jsonParser.parse(decodedPayload);
            
            // Enhanced validation
            if (!validateTokenClaims(jsonObject)) {
                return null;
            }
            
            return jsonObject;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying Google ID token", e);
            return null;
        }
    }
    
    private boolean validateTokenClaims(JSONObject tokenPayload) {
        // Validate audience
        String aud = (String) tokenPayload.get("aud");
        if (!OAuthConstants.GOOGLE_CLIENT_ID.equals(aud)) {
            LOGGER.warning("Invalid audience in token: " + OAuthConstants.sanitizeForLog(aud));
            return false;
        }
        
        // Check expiration
        Long exp = (Long) tokenPayload.get("exp");
        long currentTime = System.currentTimeMillis() / 1000;
        if (exp != null && currentTime > exp) {
            LOGGER.warning("Token expired. Current: " + currentTime + ", Exp: " + exp);
            return false;
        }
        
        // Check issued at time (not too old)
        Long iat = (Long) tokenPayload.get("iat");
        if (iat != null && (currentTime - iat) > 3600) { // Token should not be older than 1 hour
            LOGGER.warning("Token too old. Current: " + currentTime + ", IAT: " + iat);
            return false;
        }
        
        // Validate issuer
        String iss = (String) tokenPayload.get("iss");
        if (!"https://accounts.google.com".equals(iss)) {
            LOGGER.warning("Invalid issuer: " + iss);
            return false;
        }
        
        return true;
    }
    
    private UserInfo extractUserInfo(JSONObject payload) {
        UserInfo userInfo = new UserInfo();
        userInfo.email = (String) payload.get("email");
        userInfo.name = (String) payload.get("name");
        userInfo.picture = (String) payload.get("picture");
        userInfo.googleId = (String) payload.get("sub");
        userInfo.emailVerified = Boolean.TRUE.equals(payload.get("email_verified"));
        userInfo.givenName = (String) payload.get("given_name");
        userInfo.familyName = (String) payload.get("family_name");
        
        return userInfo;
    }
    
    private void handleExistingUser(HttpServletRequest request, HttpServletResponse response, 
                                  User existingUser, UserInfo userInfo, String ipAddress, 
                                  String userAgent, String returnUrl) 
            throws SQLException, IOException {
        
        // Security check: account status
        if (!existingUser.isActive()) {
            LOGGER.warning("Inactive account attempted Google login: " + existingUser.getEmail());
            logOAuthLogin(existingUser.getUserId(), OAuthConstants.PROVIDER_GOOGLE, 
                         userInfo.googleId, existingUser.getEmail(), ipAddress, userAgent, false);
            sendErrorResponse(response, OAuthConstants.ERROR_ACCOUNT_DISABLED, 403);
            return;
        }
        
        // Update or link Google ID
        if (existingUser.getGoogleId() == null || existingUser.getGoogleId().isEmpty()) {
            userDAO.updateGoogleId(existingUser.getUserId(), userInfo.googleId);
            existingUser.setGoogleId(userInfo.googleId);
            LOGGER.info("Linked Google ID to existing user: " + existingUser.getEmail());
        } else if (!userInfo.googleId.equals(existingUser.getGoogleId())) {
            // Google ID mismatch - security concern
            LOGGER.warning("Google ID mismatch for user: " + existingUser.getEmail());
            sendErrorResponse(response, OAuthConstants.ERROR_GOOGLE_ID_CONFLICT, 409);
            return;
        }
        
        // Update user profile from Google data
        updateUserProfileFromGoogle(existingUser, userInfo);
        
        // Log successful login
        logOAuthLogin(existingUser.getUserId(), OAuthConstants.PROVIDER_GOOGLE, 
                     userInfo.googleId, existingUser.getEmail(), ipAddress, userAgent, true);
        
        // Create session and respond
        createUserSession(request, response, existingUser, returnUrl);
    }
    
    private void handleNewUser(HttpServletRequest request, HttpServletResponse response,
                             UserInfo userInfo, String ipAddress, String userAgent, String returnUrl) 
            throws SQLException, IOException {
        
        LOGGER.info("Creating new user from Google: " + userInfo.email);
        
        // Additional validation for new users
        if (!OAuthConstants.isValidEmail(userInfo.email)) {
            sendErrorResponse(response, OAuthConstants.ERROR_EMAIL_FORMAT_INVALID, 400);
            return;
        }
        
        // Create new user object
        User newUser = createUserFromGoogleInfo(userInfo);
        
        try {
            // Create user in database with transaction
            int userId = userDAO.createUser(newUser);
            
            if (userId > 0) {
                newUser.setUserId(userId);
                
                // Create default traveler profile
                userDAO.createTravelerProfile(userId);
                
                // Log successful registration and login
                logOAuthLogin(userId, OAuthConstants.PROVIDER_GOOGLE, userInfo.googleId, 
                             userInfo.email, ipAddress, userAgent, true);
                
                LOGGER.info(String.format("New Google user created: %s (ID: %d)", 
                           userInfo.email, userId));
                
                // Create session and respond
                createUserSession(request, response, newUser, returnUrl);
                
            } else {
                LOGGER.severe("Failed to create user: " + userInfo.email);
                sendErrorResponse(response, OAuthConstants.ERROR_CREATE_ACCOUNT_FAILED, 500);
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate") || e.getMessage().contains("UNIQUE")) {
                sendErrorResponse(response, OAuthConstants.ERROR_EMAIL_EXISTS, 409);
            } else {
                throw e;
            }
        }
    }
    
    private User createUserFromGoogleInfo(UserInfo userInfo) {
        User newUser = new User();
        newUser.setEmail(userInfo.email);
        
        // Use full name or create from email
        String fullName = userInfo.name;
        if (fullName == null || fullName.trim().isEmpty()) {
            fullName = userInfo.email.split("@")[0];
        }
        newUser.setFullName(OAuthConstants.isValidName(fullName) ? fullName.trim() : userInfo.email.split("@")[0]);
        
        newUser.setAvatar(userInfo.picture);
        newUser.setGoogleId(userInfo.googleId);
        newUser.setUserType(OAuthConstants.USER_TYPE_TRAVELER); // Default type
        newUser.setActive(true);
        newUser.setEmailVerified(userInfo.emailVerified);
        newUser.setProvider(OAuthConstants.PROVIDER_GOOGLE);
        
        // Generate secure random password (not used for Google login)
        String randomPassword = UUID.randomUUID().toString() + System.currentTimeMillis();
        newUser.setPassword(PasswordUtils.hashPasswordWithSalt(randomPassword));
        
        return newUser;
    }
    
    private void updateUserProfileFromGoogle(User existingUser, UserInfo userInfo) throws SQLException {
        boolean needsUpdate = false;
        
        // Update avatar if user doesn't have one or it's outdated
        if ((existingUser.getAvatar() == null || existingUser.getAvatar().isEmpty()) && 
            userInfo.picture != null && !userInfo.picture.isEmpty()) {
            userDAO.updateAvatar(existingUser.getUserId(), userInfo.picture);
            existingUser.setAvatar(userInfo.picture);
            needsUpdate = true;
        }
        
        // Set email as verified for Google users
        if (!existingUser.isEmailVerified()) {
            userDAO.verifyEmail(existingUser.getUserId());
            existingUser.setEmailVerified(true);
            needsUpdate = true;
        }
        
        // Update name if more complete from Google
        if (userInfo.name != null && !userInfo.name.trim().isEmpty() && 
            OAuthConstants.isValidName(userInfo.name) &&
            (existingUser.getFullName() == null || existingUser.getFullName().length() < userInfo.name.length())) {
            userDAO.updateFullName(existingUser.getUserId(), userInfo.name.trim());
            existingUser.setFullName(userInfo.name.trim());
            needsUpdate = true;
        }
        
        if (needsUpdate) {
            LOGGER.info("Updated profile for user: " + existingUser.getEmail());
        }
    }
    
    private void createUserSession(HttpServletRequest request, HttpServletResponse response, 
                                 User user, String returnUrl) throws IOException {
        HttpSession session = request.getSession(true);
        
        // Set session attributes using constants
        session.setAttribute(OAuthConstants.SESSION_USER, user);
        session.setAttribute(OAuthConstants.SESSION_USER_ID, user.getUserId());
        session.setAttribute(OAuthConstants.SESSION_USER_TYPE, user.getUserType());
        session.setAttribute(OAuthConstants.SESSION_FULL_NAME, user.getFullName());
        session.setAttribute(OAuthConstants.SESSION_AVATAR, user.getAvatar());
        session.setAttribute(OAuthConstants.SESSION_EMAIL, user.getEmail());
        
        // Set appropriate session timeout
        int timeout = OAuthConstants.getSessionTimeout(OAuthConstants.PROVIDER_GOOGLE, false);
        session.setMaxInactiveInterval(timeout);
        
        LOGGER.info(String.format("Session created for user: %s (ID: %d, Type: %s)", 
                   user.getEmail(), user.getUserId(), user.getUserType()));
        
        // Determine redirect URL
        String redirectUrl = determineRedirectUrl(user, request, returnUrl);
        
        // Send success response using JSON Simple
        sendSuccessResponse(response, user, redirectUrl);
    }
    
    private String determineRedirectUrl(User user, HttpServletRequest request, String returnUrl) {
        String contextPath = request.getContextPath();
        
        // Validate and use return URL if safe
        if (OAuthConstants.isSafeRedirectUrl(returnUrl, contextPath)) {
            return returnUrl;
        }
        
        // Use default based on user type
        return OAuthConstants.getRedirectUrlByUserType(user.getUserType(), contextPath);
    }
    
    private void sendSuccessResponse(HttpServletResponse response, User user, String redirectUrl) throws IOException {
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success", true);
        jsonResponse.put("redirectUrl", redirectUrl);
        jsonResponse.put("message", OAuthConstants.SUCCESS_GOOGLE_LOGIN);
        
        // User information
        JSONObject userInfo = new JSONObject();
        userInfo.put("id", user.getUserId());
        userInfo.put("email", user.getEmail());
        userInfo.put("name", user.getFullName());
        userInfo.put("type", user.getUserType());
        userInfo.put("typeDisplayName", OAuthConstants.getUserTypeDisplayName(user.getUserType()));
        userInfo.put("avatar", user.getAvatar());
        userInfo.put("provider", OAuthConstants.getProviderDisplayName(user.getProvider()));
        jsonResponse.put("user", userInfo);
        
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(jsonResponse.toJSONString());
    }
    
    private void sendErrorResponse(HttpServletResponse response, String message, int status) throws IOException {
        response.setStatus(status);
        
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("success", false);
        errorResponse.put("error", message);
        errorResponse.put("statusCode", status);
        errorResponse.put("timestamp", System.currentTimeMillis());
        
        response.getWriter().write(errorResponse.toJSONString());
    }
    
    private void logOAuthLogin(int userId, String provider, String providerId, 
                              String email, String ipAddress, String userAgent, boolean success) {
        try {
            userDAO.logOAuthLogin(userId, provider, providerId, email, 
                                ipAddress, userAgent, success);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to log OAuth login for user: " + userId, e);
        }
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        // Check for various proxy headers
        String[] headers = {
            "X-Forwarded-For",
            "X-Real-IP", 
            "X-Original-Forwarded-For",
            "Proxy-Client-IP",
            "WL-Proxy-Client-IP"
        };
        
        for (String header : headers) {
            String ip = request.getHeader(header);
            if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
                // X-Forwarded-For can contain multiple IPs, get the first one
                return ip.split(",")[0].trim();
            }
        }
        
        return request.getRemoteAddr() != null ? request.getRemoteAddr() : "unknown";
    }
    
    /**
     * Inner class to hold user information from Google
     */
    private static class UserInfo {
        String email;
        String name;
        String picture;
        String googleId;
        boolean emailVerified;
        String givenName;
        String familyName;
        
        boolean isValid() {
            return email != null && !email.trim().isEmpty() && 
                   googleId != null && !googleId.trim().isEmpty();
        }
    }
}