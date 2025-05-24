package controller;

import dao.UserDAO;
import model.User;
import utils.OAuthConstants;
import utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@WebServlet("/loginG")
public class LoginGoogleServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginGoogleServlet.class.getName());
    private UserDAO userDAO;
    private final JSONParser jsonParser = new JSONParser();

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
            if (!OAuthConstants.isValidGoogleClientId()) {
                throw new ServletException("Invalid Google Client ID configuration");
            }
            LOGGER.info("LoginGoogleServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize LoginGoogleServlet", e);
            throw new ServletException("Failed to initialize Google OAuth", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response headers
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        // Get parameters
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String error = request.getParameter("error");

        // Get client info for logging
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");

        LOGGER.info(String.format("Google OAuth callback - IP: %s, UserAgent: %s, Code: %s, Error: %s",
                OAuthConstants.sanitizeForLog(ipAddress),
                OAuthConstants.sanitizeForLog(userAgent),
                code != null ? "present" : "null",
                error));

        // Handle errors
        if (error != null) {
            LOGGER.warning("Google OAuth error: " + error);
            redirectToLoginWithError(request, response, OAuthConstants.ERROR_GOOGLE_AUTH_FAILED);
            return;
        }

        if (code == null || code.trim().isEmpty()) {
            LOGGER.warning("Missing authorization code");
            redirectToLoginWithError(request, response, OAuthConstants.ERROR_INVALID_REQUEST);
            return;
        }

        try {
            // Exchange code for tokens
            JSONObject tokenResponse = exchangeCodeForTokens(code, request.getContextPath());
            if (tokenResponse == null) {
                LOGGER.severe("Failed to exchange code for tokens");
                redirectToLoginWithError(request, response, OAuthConstants.ERROR_GOOGLE_AUTH_FAILED);
                return;
            }

            String accessToken = (String) tokenResponse.get("access_token");
            String idToken = (String) tokenResponse.get("id_token");

            if (accessToken == null || idToken == null) {
                LOGGER.severe("Missing tokens in response");
                redirectToLoginWithError(request, response, OAuthConstants.ERROR_INVALID_TOKEN);
                return;
            }

            // Get user info
            UserInfo userInfo = getUserInfo(accessToken);
            if (userInfo == null || !userInfo.isValid()) {
                LOGGER.warning("Failed to retrieve valid user info");
                redirectToLoginWithError(request, response, OAuthConstants.ERROR_INVALID_REQUEST);
                return;
            }

            LOGGER.info(String.format("Google OAuth success - Email: %s, Name: %s",
                    userInfo.email, userInfo.name));

            // Process user
            User existingUser = userDAO.getUserByEmail(userInfo.email);
            if (existingUser != null) {
                handleExistingUser(request, response, existingUser, userInfo, ipAddress, userAgent, state);
            } else {
                handleNewUser(request, response, userInfo, ipAddress, userAgent, state);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing Google OAuth", e);
            redirectToLoginWithError(request, response, OAuthConstants.ERROR_SYSTEM_ERROR);
        }
    }

    private JSONObject exchangeCodeForTokens(String code, String contextPath) {
        try {
            String clientId = OAuthConstants.GOOGLE_CLIENT_ID;
            String clientSecret = OAuthConstants.getGoogleClientSecret();
            String redirectUri = "http://localhost:8080" + contextPath + "/loginG";

            // Prepare request body
            String params = "code=" + URLEncoder.encode(code, "UTF-8") +
                    "&client_id=" + URLEncoder.encode(clientId, "UTF-8") +
                    "&client_secret=" + URLEncoder.encode(clientSecret, "UTF-8") +
                    "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8") +
                    "&grant_type=authorization_code";

            URL url = new URL(OAuthConstants.GOOGLE_TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);

            // Send request
            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes("UTF-8"));
                os.flush();
            }

            // Read response
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            conn.disconnect();

            // Parse JSON response
            return (JSONObject) jsonParser.parse(response.toString());

        } catch (IOException | ParseException e) {
            LOGGER.log(Level.SEVERE, "Error exchanging code for tokens", e);
            return null;
        }
    }

    private UserInfo getUserInfo(String accessToken) {
        try {
            URL url = new URL(OAuthConstants.GOOGLE_USER_INFO_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            // Read response
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            conn.disconnect();

            // Parse JSON response
            JSONObject json = (JSONObject) jsonParser.parse(response.toString());

            UserInfo userInfo = new UserInfo();
            userInfo.email = (String) json.get("email");
            userInfo.name = (String) json.get("name");
            userInfo.picture = (String) json.get("picture");
            userInfo.googleId = (String) json.get("id");
            userInfo.emailVerified = Boolean.parseBoolean(String.valueOf(json.get("verified_email")));
            userInfo.givenName = (String) json.get("given_name");
            userInfo.familyName = (String) json.get("family_name");

            return userInfo;

        } catch (IOException | ParseException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user info", e);
            return null;
        }
    }

    private void handleExistingUser(HttpServletRequest request, HttpServletResponse response,
                                   User existingUser, UserInfo userInfo, String ipAddress,
                                   String userAgent, String returnUrl)
            throws SQLException, IOException {
        if (!existingUser.isActive()) {
            LOGGER.warning("Inactive account attempted Google login: " + existingUser.getEmail());
            logOAuthLogin(existingUser.getUserId(), OAuthConstants.PROVIDER_GOOGLE,
                    userInfo.googleId, existingUser.getEmail(), ipAddress, userAgent, false);
            redirectToLoginWithError(request, response, OAuthConstants.ERROR_ACCOUNT_DISABLED);
            return;
        }

        // Update or link Google ID
        if (existingUser.getGoogleId() == null || existingUser.getGoogleId().isEmpty()) {
            userDAO.updateGoogleId(existingUser.getUserId(), userInfo.googleId);
            existingUser.setGoogleId(userInfo.googleId);
            LOGGER.info("Linked Google ID to existing user: " + existingUser.getEmail());
        } else if (!userInfo.googleId.equals(existingUser.getGoogleId())) {
            LOGGER.warning("Google ID mismatch for user: " + existingUser.getEmail());
            redirectToLoginWithError(request, response, OAuthConstants.ERROR_GOOGLE_ID_CONFLICT);
            return;
        }

        // Update user profile
        updateUserProfileFromGoogle(existingUser, userInfo);

        // Log successful login
        logOAuthLogin(existingUser.getUserId(), OAuthConstants.PROVIDER_GOOGLE,
                userInfo.googleId, existingUser.getEmail(), ipAddress, userAgent, true);

        // Create session and redirect
        createUserSession(request, response, existingUser, returnUrl);
    }

    private void handleNewUser(HttpServletRequest request, HttpServletResponse response,
                              UserInfo userInfo, String ipAddress, String userAgent, String returnUrl)
            throws SQLException, IOException {
        LOGGER.info("Creating new user from Google: " + userInfo.email);

        if (!OAuthConstants.isValidEmail(userInfo.email)) {
            redirectToLoginWithError(request, response, OAuthConstants.ERROR_EMAIL_FORMAT_INVALID);
            return;
        }

        User newUser = createUserFromGoogleInfo(userInfo);

        try {
            int userId = userDAO.createUser(newUser);
            if (userId > 0) {
                newUser.setUserId(userId);
                userDAO.createTravelerProfile(userId);
                logOAuthLogin(userId, OAuthConstants.PROVIDER_GOOGLE, userInfo.googleId,
                        userInfo.email, ipAddress, userAgent, true);
                LOGGER.info(String.format("New Google user created: %s (ID: %d)",
                        userInfo.email, userId));
                createUserSession(request, response, newUser, returnUrl);
            } else {
                LOGGER.severe("Failed to create user: " + userInfo.email);
                redirectToLoginWithError(request, response, OAuthConstants.ERROR_CREATE_ACCOUNT_FAILED);
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate") || e.getMessage().contains("UNIQUE")) {
                redirectToLoginWithError(request, response, OAuthConstants.ERROR_EMAIL_EXISTS);
            } else {
                throw e;
            }
        }
    }

    private User createUserFromGoogleInfo(UserInfo userInfo) {
        User newUser = new User();
        newUser.setEmail(userInfo.email);
        String fullName = userInfo.name != null && !userInfo.name.trim().isEmpty()
                ? userInfo.name
                : userInfo.email.split("@")[0];
        newUser.setFullName(OAuthConstants.isValidName(fullName) ? fullName.trim() : userInfo.email.split("@")[0]);
        newUser.setAvatar(userInfo.picture);
        newUser.setGoogleId(userInfo.googleId);
        newUser.setUserType(OAuthConstants.USER_TYPE_TRAVELER);
        newUser.setActive(true);
        newUser.setEmailVerified(userInfo.emailVerified);
        newUser.setProvider(OAuthConstants.PROVIDER_GOOGLE);
        String randomPassword = UUID.randomUUID().toString() + System.currentTimeMillis();
        newUser.setPassword(PasswordUtils.hashPasswordWithSalt(randomPassword));
        return newUser;
    }

    private void updateUserProfileFromGoogle(User existingUser, UserInfo userInfo) throws SQLException {
        boolean needsUpdate = false;

        if ((existingUser.getAvatar() == null || existingUser.getAvatar().isEmpty()) &&
                userInfo.picture != null && !userInfo.picture.isEmpty()) {
            userDAO.updateAvatar(existingUser.getUserId(), userInfo.picture);
            existingUser.setAvatar(userInfo.picture);
            needsUpdate = true;
        }

        if (!existingUser.isEmailVerified()) {
            userDAO.verifyEmail(existingUser.getUserId());
            existingUser.setEmailVerified(true);
            needsUpdate = true;
        }

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
        session.setAttribute(OAuthConstants.SESSION_USER, user);
        session.setAttribute(OAuthConstants.SESSION_USER_ID, user.getUserId());
        session.setAttribute(OAuthConstants.SESSION_USER_TYPE, user.getUserType());
        session.setAttribute(OAuthConstants.SESSION_FULL_NAME, user.getFullName());
        session.setAttribute(OAuthConstants.SESSION_AVATAR, user.getAvatar());
        session.setAttribute(OAuthConstants.SESSION_EMAIL, user.getEmail());
        int timeout = OAuthConstants.getSessionTimeout(OAuthConstants.PROVIDER_GOOGLE, false);
        session.setMaxInactiveInterval(timeout);

        LOGGER.info(String.format("Session created for user: %s (ID: %d, Type: %s)",
                user.getEmail(), user.getUserId(), user.getUserType()));

        String redirectUrl = determineRedirectUrl(user, request, returnUrl);
        response.sendRedirect(redirectUrl);
    }

    private String determineRedirectUrl(User user, HttpServletRequest request, String returnUrl) {
        String contextPath = request.getContextPath();
        if (OAuthConstants.isSafeRedirectUrl(returnUrl, contextPath)) {
            return returnUrl;
        }
        return OAuthConstants.getRedirectUrlByUserType(user.getUserType(), contextPath);
    }

    private void redirectToLoginWithError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws IOException {
        String loginUrl = OAuthConstants.getLoginUrl(request.getContextPath()) +
                "?error=" + URLEncoder.encode(errorMessage, "UTF-8");
        response.sendRedirect(loginUrl);
    }

    private void logOAuthLogin(int userId, String provider, String providerId,
                              String email, String ipAddress, String userAgent, boolean success) {
        try {
            userDAO.logOAuthLogin(userId, provider, providerId, email, ipAddress, userAgent, success);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to log OAuth login for user: " + userId, e);
        }
    }

    private String getClientIpAddress(HttpServletRequest request) {
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
                return ip.split(",")[0].trim();
            }
        }

        return request.getRemoteAddr() != null ? request.getRemoteAddr() : "unknown";
    }

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