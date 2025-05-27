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

@WebServlet("/auth/google")
public class GoogleOAuthServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(GoogleOAuthServlet.class.getName());
    
    // Cấu hình Google OAuth
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
     * Xử lý Redirect Method (OAuth Authorization Code Flow)
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
        
        // Nếu user hủy đăng nhập
        if (error != null) {
            LOGGER.warning("User hủy đăng nhập Google: " + error);
            response.sendRedirect(request.getContextPath() + "/login?error=oauth_cancelled");
            return;
        }
        
        // Nếu không có authorization code
        if (code == null) {
            LOGGER.warning("Không nhận được authorization code từ Google");
            response.sendRedirect(request.getContextPath() + "/login?error=oauth_failed");
            return;
        }
        
        try {
            // Bước 1: Đổi code lấy access token
            LOGGER.info("Bước 1: Đổi authorization code lấy access token...");
            String accessToken = exchangeCodeForToken(code);
            
            if (accessToken == null) {
                LOGGER.severe("Không thể đổi code lấy access token");
                response.sendRedirect(request.getContextPath() + "/login?error=token_exchange_failed");
                return;
            }
            LOGGER.info("✅ Đã có access token");
            
            // Bước 2: Dùng access token lấy thông tin user
            LOGGER.info("Bước 2: Lấy thông tin user từ Google...");
            JsonObject userInfo = getUserInfo(accessToken);
            
            if (userInfo == null) {
                LOGGER.severe("Không thể lấy thông tin user từ Google");
                response.sendRedirect(request.getContextPath() + "/login?error=userinfo_failed");
                return;
            }
            LOGGER.info("✅ Đã có thông tin user: " + userInfo.get("email").getAsString());
            
            // Bước 3: Xử lý đăng nhập
            LOGGER.info("Bước 3: Xử lý đăng nhập...");
            processGoogleUserRedirect(userInfo, request, response, state);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi xử lý Google OAuth Redirect", e);
            response.sendRedirect(request.getContextPath() + "/login?error=processing_failed");
        }
    }
    
    /**
     * Xử lý JS Token Method (ID Token từ JavaScript)
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
            // Bước 1: Xác thực ID Token bằng Google API
            LOGGER.info("Bước 1: Xác thực ID Token với Google...");
            JsonObject userInfo = verifyIdTokenWithGoogle(idToken);
            
            if (userInfo == null) {
                LOGGER.warning("❌ Google API không thể xác thực ID Token");
                sendJsonResponse(response, false, "Không thể xác thực ID Token với Google", null);
                return;
            }
            LOGGER.info("✅ ID Token hợp lệ, user: " + userInfo.get("email").getAsString());
            
            // Bước 2: Xử lý thông tin user
            LOGGER.info("Bước 2: Xử lý thông tin user...");
            User user = processGoogleUserFromIdToken(userInfo);
            
            if (user == null) {
                LOGGER.warning("❌ Không thể xử lý thông tin user");
                sendJsonResponse(response, false, "Không thể xử lý thông tin người dùng", null);
                return;
            }
            LOGGER.info("✅ Đã xử lý user: " + user.getEmail());
            
            // Bước 3: Tạo session
            LOGGER.info("Bước 3: Tạo session...");
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 phút
            
            LOGGER.info("✅ User đăng nhập thành công: " + user.getEmail());
            
            // Bước 4: Trả về kết quả
            String redirectUrl = determineRedirectUrl(user, request);
            LOGGER.info("✅ Redirect đến: " + redirectUrl);
            sendJsonResponse(response, true, "Đăng nhập thành công", redirectUrl);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi xử lý JS Token", e);
            sendJsonResponse(response, false, "Lỗi hệ thống: " + e.getMessage(), null);
        }
    }
    
    /**
     * Xác thực ID Token bằng Google API (ĐÁNG TIN CẬY)
     */
    private JsonObject verifyIdTokenWithGoogle(String idToken) {
        try {
            LOGGER.info("🔍 Gửi ID Token đến Google để xác thực...");
            
            // Gọi Google tokeninfo API
            URL url = new URL(GOOGLE_TOKENINFO_URL + "?id_token=" + idToken);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(15000); // 15 giây timeout
            conn.setReadTimeout(15000);
            
            int responseCode = conn.getResponseCode();
            LOGGER.info("📡 Google API response code: " + responseCode);
            
            if (responseCode != 200) {
                // Đọc lỗi từ Google
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
            
            // Đọc response từ Google
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                
                String responseBody = response.toString();
                LOGGER.info("📄 Google API response: " + responseBody);
                
                JsonObject tokenInfo = JsonParser.parseString(responseBody).getAsJsonObject();
                
                // Kiểm tra audience (Client ID)
                if (!tokenInfo.has("aud")) {
                    LOGGER.warning("❌ Token không có audience");
                    return null;
                }
                
                String audience = tokenInfo.get("aud").getAsString();
                if (!GOOGLE_CLIENT_ID.equals(audience)) {
                    LOGGER.warning("❌ Audience không khớp. Mong đợi: " + GOOGLE_CLIENT_ID + ", Nhận được: " + audience);
                    return null;
                }
                
                // Chuyển đổi thành format chuẩn
                JsonObject userInfo = new JsonObject();
                
                // Các trường bắt buộc
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
     * Đổi authorization code lấy access token
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
     * Lấy thông tin user từ Google bằng access token
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
     * Xử lý user từ Redirect Method
     */
    private void processGoogleUserRedirect(JsonObject userInfo, HttpServletRequest request, 
                                         HttpServletResponse response, String state) throws IOException, SQLException {
        
        String googleId = userInfo.get("id").getAsString();
        String email = userInfo.get("email").getAsString().toLowerCase().trim();
        String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email;
        String picture = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;
        boolean emailVerified = userInfo.has("verified_email") ? userInfo.get("verified_email").getAsBoolean() : false;
        
        User user = handleGoogleLogin(googleId, email, name, picture, emailVerified);
        
        if (user != null) {
            // Tạo session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userType", user.getUserType());
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
     * Xử lý user từ JS Token Method
     */
    private User processGoogleUserFromIdToken(JsonObject userInfo) throws SQLException {
        String googleId = userInfo.get("sub").getAsString(); // 'sub' trong ID token
        String email = userInfo.get("email").getAsString().toLowerCase().trim();
        String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email;
        String picture = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;
        boolean emailVerified = userInfo.has("email_verified") ? userInfo.get("email_verified").getAsBoolean() : false;
        
        return handleGoogleLogin(googleId, email, name, picture, emailVerified);
    }
    
    /**
     * Xử lý đăng nhập Google (chung cho cả 2 method)
     */
    private User handleGoogleLogin(String googleId, String email, String name, String picture, boolean emailVerified) throws SQLException {
        LOGGER.info("🔄 Xử lý đăng nhập cho: " + email);
        
        // Bước 1: Tìm user theo Google ID
        User user = userDAO.getUserByGoogleId(googleId);
        if (user != null) {
            LOGGER.info("✅ Tìm thấy user hiện có với Google ID");
            return user;
        }
        
        // Bước 2: Tìm user theo email
        user = userDAO.getUserByEmail(email);
        if (user != null) {
            LOGGER.info("🔗 Tìm thấy user với email, liên kết tài khoản Google...");
            if (userDAO.linkGoogleAccount(email, googleId)) {
                user.setGoogleId(googleId);
                user.setProvider("both");
                LOGGER.info("✅ Đã liên kết tài khoản Google");
                return user;
            } else {
                LOGGER.warning("❌ Không thể liên kết tài khoản Google");
                return null;
            }
        }
        
        // Bước 3: Tạo user mới
        LOGGER.info("👤 Tạo tài khoản mới cho: " + email);
        user = new User();
        user.setEmail(email);
        user.setFullName(name);
        user.setGoogleId(googleId);
        user.setProvider("google");
        user.setActive(true);
        user.setEmailVerified(emailVerified);
        user.setUserType("TRAVELER");
        user.setAvatar(picture);
        
        // Tạo mật khẩu ngẫu nhiên (user Google không dùng)
        String randomPassword = generateRandomPassword();
        user.setPassword(utils.PasswordUtils.hashPasswordWithSalt(randomPassword));
        
        int userId = userDAO.createUser(user);
        if (userId > 0) {
            user.setUserId(userId);
            userDAO.createTravelerProfile(userId);
            LOGGER.info("✅ Tạo tài khoản mới thành công, ID: " + userId);
            return user;
        } else {
            LOGGER.warning("❌ Không thể tạo tài khoản mới");
            return null;
        }
    }
    
    /**
     * Tạo mật khẩu ngẫu nhiên
     */
    private String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
    
    /**
     * Xác định URL redirect dựa trên loại user
     */
    private String determineRedirectUrl(User user, HttpServletRequest request) {
        String contextPath = request.getContextPath();
        
        switch (user.getUserType()) {
            case "ADMIN":
                return contextPath + "/admin/dashboard";
            case "HOST":
                return contextPath + "/host/dashboard";
            case "TRAVELER":
                return contextPath + "/view/jsp/home/home.jsp";
            default:
                return contextPath + "/home";
        }
    }
    
    /**
     * Gửi JSON response cho AJAX requests
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