package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Date;
import utils.PasswordUtils;

@WebServlet("/auth/google")
public class GoogleOAuthServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(GoogleOAuthServlet.class.getName());

    // Google OAuth configuration
    private static final String GOOGLE_CLIENT_ID = "261457043485-kueaa5fdmd5l28jokri6k3vtae4cm954.apps.googleusercontent.com";
    private static final String GOOGLE_CLIENT_SECRET = "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";
    private static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/Travel/auth/google";
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    private static final String GOOGLE_TOKENINFO_URL = "https://oauth2.googleapis.com/tokeninfo";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    /**
     * Handle Redirect Method (OAuth Authorization Code Flow)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String error = request.getParameter("error");
        String state = request.getParameter("state");

        LOGGER.info("=== REDIRECT METHOD ===");
        LOGGER.info("Code: " + (code != null ? "có" : "không có"));
        LOGGER.info("Error: " + error);

        // If user cancels login
        if (error != null) {
            LOGGER.warning("User hủy đăng nhập Google: " + error);
            response.sendRedirect(request.getContextPath() + "/login?error=oauth_cancelled");
            return;
        }

        // If no authorization code
        if (code == null) {
            LOGGER.warning("Không nhận được authorization code từ Google");
            response.sendRedirect(request.getContextPath() + "/login?error=oauth_failed");
            return;
        }

        try {
            // Step 1: Exchange code for access token
            LOGGER.info("Bước 1: Đổi authorization code lấy access token...");
            String accessToken = exchangeCodeForToken(code);

            if (accessToken == null) {
                LOGGER.severe("Không thể đổi code lấy access token");
                response.sendRedirect(request.getContextPath() + "/login?error=token_exchange_failed");
                return;
            }
            LOGGER.info("✅ Đã có access token");

            // Step 2: Get user info using access token
            LOGGER.info("Bước 2: Lấy thông tin user từ Google...");
            JsonObject userInfo = getUserInfo(accessToken);

            if (userInfo == null) {
                LOGGER.severe("Không thể lấy thông tin user từ Google");
                response.sendRedirect(request.getContextPath() + "/login?error=userinfo_failed");
                return;
            }
            LOGGER.info("✅ Đã có thông tin user: " + userInfo.get("email").getAsString());

            // Step 3: Process login
            LOGGER.info("Bước 3: Xử lý đăng nhập...");
            processGoogleUserRedirect(userInfo, request, response, state);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi xử lý Google OAuth Redirect", e);
            response.sendRedirect(request.getContextPath() + "/login?error=processing_failed");
        }
    }

    /**
     * Handle JS Token Method (ID Token from JavaScript)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("=== JS TOKEN METHOD ===");

        String idToken = request.getParameter("idToken");
        LOGGER.info("ID Token: " + (idToken != null ? "có (độ dài: " + idToken.length() + ")" : "không có"));

        if (idToken == null || idToken.trim().isEmpty()) {
            LOGGER.warning("❌ ID Token rỗng");
            sendJsonResponse(response, false, "ID Token không hợp lệ", null);
            return;
        }

        try {
            // Step 1: Verify ID Token with Google API
            LOGGER.info("Bước 1: Xác thực ID Token với Google...");
            JsonObject userInfo = verifyIdTokenWithGoogle(idToken);

            if (userInfo == null) {
                LOGGER.warning("❌ Google API không thể xác thực ID Token");
                sendJsonResponse(response, false, "Không thể xác thực ID Token với Google", null);
                return;
            }
            LOGGER.info("✅ ID Token hợp lệ, user: " + userInfo.get("email").getAsString());

            // Step 2: Process user info
            LOGGER.info("Bước 2: Xử lý thông tin user...");
            User user = processGoogleUserFromIdToken(userInfo);

            if (user == null) {
                LOGGER.warning("❌ Không thể xử lý thông tin user");
                sendJsonResponse(response, false, "Không thể xử lý thông tin người dùng", null);
                return;
            }
            LOGGER.info("✅ Đã xử lý user: " + user.getEmail());

            // Step 3: Create session
            LOGGER.info("Bước 3: Tạo session...");
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole()); // Changed from userType to role
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            LOGGER.info("✅ User đăng nhập thành công: " + user.getEmail());

            // Step 4: Return result
            String redirectUrl = determineRedirectUrl(user, request);
            LOGGER.info("✅ Redirect đến: " + redirectUrl);
            sendJsonResponse(response, true, "Đăng nhập thành công", redirectUrl);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi xử lý JS Token", e);
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }

    /**
     * Verify ID Token with Google API
     */
    private JsonObject verifyIdTokenWithGoogle(String idToken) {
        try {
            LOGGER.info("🔍 Gửi ID Token đến Google để xác thực...");

            // Call Google tokeninfo API
            URL url = new URL(GOOGLE_TOKENINFO_URL + "?id_token=" + idToken);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(15000); // 15 seconds timeout
            conn.setReadTimeout(15000);

            int responseCode = conn.getResponseCode();
            LOGGER.info("📡 Google API response code: " + responseCode);

            if (responseCode != 200) {
                try (BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()))) {
                    StringBuilder errorResponse = new StringBuilder();
                    String line;
                    while ((line = errorReader.readLine()) != null) {
                        errorResponse.append(line);
                    }
                    LOGGER.warning("❌ Google API lỗi: " + errorResponse.toString());
                }
                return null;
            }

            // Read response from Google
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }

                String responseBody = response.toString();
                LOGGER.info("📄 Google API response: " + responseBody);

                JsonObject tokenInfo = JsonParser.parseString(responseBody).getAsJsonObject();

                // Check audience (Client ID)
                if (!tokenInfo.has("aud")) {
                    LOGGER.warning("❌ Token không có audience");
                    return null;
                }

                String audience = tokenInfo.get("aud").getAsString();
                if (!GOOGLE_CLIENT_ID.equals(audience)) {
                    LOGGER.warning("❌ Audience không khớp. Mong đợi: " + GOOGLE_CLIENT_ID + ", Nhận được: " + audience);
                    return null;
                }

                // Convert to standard format
                JsonObject userInfo = new JsonObject();

                // Required fields
                if (tokenInfo.has("sub")) {
                    userInfo.addProperty("sub", tokenInfo.get("sub").getAsString());
                }
                if (tokenInfo.has("email")) {
                    userInfo.addProperty("email", tokenInfo.get("email").getAsString());
                }
                if (tokenInfo.has("name")) {
                    userInfo.addProperty("name", tokenInfo.get("name").getAsString());
                }
                if (tokenInfo.has("picture")) {
                    userInfo.addProperty("picture", tokenInfo.get("picture").getAsString());
                }
                if (tokenInfo.has("email_verified")) {
                    userInfo.addProperty("email_verified", tokenInfo.get("email_verified").getAsString().equals("true"));
                }

                LOGGER.info("✅ ID Token đã được Google xác thực thành công");
                return userInfo;
            }

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "❌ Lỗi khi xác thực với Google API", e);
            return null;
        }
    }

    /**
     * Exchange authorization code for access token
     */
    private String exchangeCodeForToken(String code) throws IOException {
        URL url = new URL(GOOGLE_TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        String postData = "code=" + code +
                "&client_id=" + GOOGLE_CLIENT_ID +
                "&client_secret=" + GOOGLE_CLIENT_SECRET +
                "&redirect_uri=" + GOOGLE_REDIRECT_URI +
                "&grant_type=authorization_code";

        try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream())) {
            writer.write(postData);
        }

        if (conn.getResponseCode() != 200) {
            return null;
        }

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            JsonObject json = JsonParser.parseString(response.toString()).getAsJsonObject();
            return json.has("access_token") ? json.get("access_token").getAsString() : null;
        }
    }

    /**
     * Get user info from Google using access token
     */
    private JsonObject getUserInfo(String accessToken) throws IOException {
        URL url = new URL(GOOGLE_USERINFO_URL + "?access_token=" + accessToken);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        if (conn.getResponseCode() != 200) {
            return null;
        }

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            return JsonParser.parseString(response.toString()).getAsJsonObject();
        }
    }

    /**
     * Process user from Redirect Method
     */
    private void processGoogleUserRedirect(JsonObject userInfo, HttpServletRequest request,
                                         HttpServletResponse response, String state) throws IOException, SQLException {

        String email = userInfo.get("email").getAsString().toLowerCase().trim();
        String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email;
        String picture = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;
        boolean emailVerified = userInfo.has("verified_email") ? userInfo.get("verified_email").getAsBoolean() : false;

        User user = handleGoogleLogin(email, name, picture, emailVerified);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole()); // Changed from userType to role
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60);

            LOGGER.info("✅ User đăng nhập thành công (Redirect): " + email);

            // Redirect
            String redirectUrl = state != null && !state.isEmpty() ? state :
                               determineRedirectUrl(user, request);
            response.sendRedirect(redirectUrl);
        } else {
            LOGGER.warning("❌ Không thể xử lý user từ Redirect method");
            response.sendRedirect(request.getContextPath() + "/login?error=google_login_failed");
        }
    }

    /**
     * Process user from JS Token Method
     */
    private User processGoogleUserFromIdToken(JsonObject userInfo) throws SQLException {
        String email = userInfo.get("email").getAsString().toLowerCase().trim();
        String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email;
        String picture = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;
        boolean emailVerified = userInfo.has("email_verified") ? userInfo.get("email_verified").getAsBoolean() : false;

        return handleGoogleLogin(email, name, picture, emailVerified);
    }

    /**
     * Handle Google login (common for both methods)
     */
    private User handleGoogleLogin(String email, String name, String picture, boolean emailVerified) throws SQLException {
        LOGGER.info("🔄 Xử lý đăng nhập cho: " + email);

        // Step 1: Find user by email
        User user = userDAO.getUserByEmail(email);
        if (user != null) {
            LOGGER.info("✅ Tìm thấy user hiện có với email: " + email);
            // Update email verification if Google confirms it
            if (emailVerified && !user.isEmailVerified()) {
                userDAO.verifyEmail(user.getUserId());
                user.setEmailVerified(true);
            }
            return user;
        }

        // Step 2: Create new user
        LOGGER.info("👤 Tạo tài khoản mới cho: " + email);
        user = new User();
        user.setEmail(email);
        user.setFullName(name);
        user.setRole("TRAVELER"); // Default role for Google OAuth users
        user.setActive(true);
        user.setEmailVerified(emailVerified);
        user.setAvatar(picture);
        user.setPreferences("{\"likes\": []}"); // Default for TRAVELER
        user.setTotalBookings(0);
        user.setCreatedAt(new Date());

        // Set a random password (not used for Google login)
        String randomPassword = generateRandomPassword();
        user.setPassword(PasswordUtils.hashPasswordWithSalt(randomPassword));

        int userId = userDAO.createUser(user);
        if (userId > 0) {
            user.setUserId(userId);
            LOGGER.info("✅ Tạo tài khoản mới thành công, ID: " + userId);
            return user;
        } else {
            LOGGER.warning("❌ Không thể tạo tài khoản mới");
            return null;
        }
    }

    /**
     * Generate random password
     */
    private String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /**
     * Determine redirect URL based on user role
     */
    private String determineRedirectUrl(User user, HttpServletRequest request) {
        String contextPath = request.getContextPath();

       switch (user.getRole()) {
            case "ADMIN":
                return contextPath + "/admin/dashboard";
            case "HOST":
                return contextPath + "/host/dashboard";
            case "TRAVELER":
                return contextPath + "/view/jsp/home/home.jsp";
            default:
                return contextPath + "/view/jsp/home/home.jsp";
        }
    }

    /**
     * Send JSON response for AJAX requests
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, String redirectUrl) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", success);
        jsonResponse.addProperty("message", message);
        if (redirectUrl != null) {
            jsonResponse.addProperty("redirectUrl", redirectUrl);
        }

        response.getWriter().write(jsonResponse.toString());
        LOGGER.info("📤 JSON response: " + jsonResponse.toString());
    }
}