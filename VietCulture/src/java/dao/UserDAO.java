package dao;

import model.User;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    
    /**
     * Login user with email verification check
     */
    public User login(String email, String password) throws SQLException {
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified, 
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE email = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = mapUserFromResultSet(rs);
                    String storedPassword = user.getPassword();
                    
                    // Verify password using PasswordUtils
                    if (utils.PasswordUtils.verifyPassword(password, storedPassword)) {
                        return user;
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * Get user by ID
     */
    public User getUserById(int userId) throws SQLException {
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified,
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Create new user with email verification fields and Google OAuth support
     */
    public int createUser(User user) throws SQLException {
        String sql = """
            INSERT INTO Users (email, password, fullName, phone, dateOfBirth, gender, 
                              avatar, bio, isActive, userType, emailVerified, verificationToken, 
                              tokenExpiry, googleId, provider)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());
            ps.setDate(5, user.getDateOfBirth() != null ? new java.sql.Date(user.getDateOfBirth().getTime()) : null);
            ps.setString(6, user.getGender());
            ps.setString(7, user.getAvatar());
            ps.setString(8, user.getBio());
            ps.setBoolean(9, user.isActive());
            ps.setString(10, user.getUserType());
            ps.setBoolean(11, user.isEmailVerified());
            ps.setString(12, user.getVerificationToken());
            ps.setTimestamp(13, user.getTokenExpiry() != null ? new java.sql.Timestamp(user.getTokenExpiry().getTime()) : null);
            ps.setString(14, user.getGoogleId());
            ps.setString(15, user.getProvider() != null ? user.getProvider() : "local");
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int userId = generatedKeys.getInt(1);
                        user.setUserId(userId);
                        LOGGER.info("User created successfully with ID: " + userId);
                        return userId;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating user: " + user.getEmail(), e);
            throw e;
        }
        return 0;
    }
    
    /**
     * Get user by email
     */
    public User getUserByEmail(String email) throws SQLException {
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified, 
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE email = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get user by Google ID
     */
    public User getUserByGoogleId(String googleId) throws SQLException {
        if (googleId == null || googleId.trim().isEmpty()) {
            return null;
        }
        
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified, 
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE googleId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, googleId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get user by verification token
     */
    public User getUserByVerificationToken(String token) throws SQLException {
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified, 
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE verificationToken = ? AND emailVerified = 0
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Update Google ID for existing user
     */
    public boolean updateGoogleId(int userId, String googleId) throws SQLException {
        String sql = """
            UPDATE Users 
            SET googleId = ?, provider = CASE 
                WHEN provider = 'local' THEN 'both'
                WHEN provider IS NULL THEN 'google'
                ELSE provider
            END
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, googleId);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Google ID updated for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Link Google account to existing local account
     */
    public boolean linkGoogleAccount(String email, String googleId) throws SQLException {
        String sql = """
            UPDATE Users 
            SET googleId = ?, provider = 'both'
            WHERE email = ? AND (provider = 'local' OR provider IS NULL)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, googleId);
            ps.setString(2, email);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Google account linked for email: " + email);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Create traveler profile for new user
     */
    public boolean createTravelerProfile(int userId) throws SQLException {
        String sql = "INSERT INTO Travelers (userId, preferences) VALUES (?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, "{\"likes\": []}"); // Default empty preferences
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Traveler profile created for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Create host profile for new user
     */
    public boolean createHostProfile(int userId, String businessName, String businessType) throws SQLException {
        String sql = """
            INSERT INTO Hosts (userId, businessName, businessType, averageRating, totalExperiences, totalRevenue)
            VALUES (?, ?, ?, 0, 0, 0)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, businessName);
            ps.setString(3, businessType);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Host profile created for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Check if email exists and return provider info
     */
    public String getEmailProvider(String email) throws SQLException {
        String sql = "SELECT provider FROM Users WHERE email = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("provider");
                }
            }
        }
        return null;
    }
    
    /**
     * Verify user email
     */
    public boolean verifyEmail(int userId) throws SQLException {
        String sql = """
            UPDATE Users 
            SET emailVerified = 1, verificationToken = NULL, tokenExpiry = NULL
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Email verified for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Update verification token
     */
    public boolean updateVerificationToken(int userId, String token, java.util.Date expiry) throws SQLException {
        String sql = """
            UPDATE Users 
            SET verificationToken = ?, tokenExpiry = ?
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            ps.setTimestamp(2, new java.sql.Timestamp(expiry.getTime()));
            ps.setInt(3, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Verification token updated for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Update user information
     */
    public boolean updateUser(User user) throws SQLException {
        String sql = """
            UPDATE Users 
            SET email = ?, fullName = ?, phone = ?, dateOfBirth = ?, gender = ?, 
                avatar = ?, bio = ?, isActive = ?
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhone());
            ps.setDate(4, user.getDateOfBirth() != null ? new java.sql.Date(user.getDateOfBirth().getTime()) : null);
            ps.setString(5, user.getGender());
            ps.setString(6, user.getAvatar());
            ps.setString(7, user.getBio());
            ps.setBoolean(8, user.isActive());
            ps.setInt(9, user.getUserId());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User updated successfully: " + user.getUserId());
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Update user password with hashing
     */
    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE Users SET password = ? WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Hash the new password
            String hashedPassword = utils.PasswordUtils.hashPasswordWithSalt(newPassword);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Password updated for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Update user avatar only
     */
    public boolean updateAvatar(int userId, String avatarUrl) throws SQLException {
        String sql = "UPDATE Users SET avatar = ? WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Avatar updated for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Check if email exists
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    /**
     * Check if email exists for different user (for update validation)
     */
    public boolean emailExistsForOtherUser(String email, int currentUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ? AND userId != ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setInt(2, currentUserId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    /**
     * Get all users by type
     */
    public List<User> getUsersByType(String userType) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified,
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE userType = ?
            ORDER BY createdAt DESC
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userType);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUserFromResultSet(rs));
                }
            }
        }
        return users;
    }
    
    /**
     * Update user status (active/inactive)
     */
    public boolean updateUserStatus(int userId, boolean isActive) throws SQLException {
        String sql = "UPDATE Users SET isActive = ? WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User status updated for user ID: " + userId + ", Active: " + isActive);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Get user statistics
     */
    public UserStats getUserStats(int userId) throws SQLException {
        UserStats stats = new UserStats();
        
        String sql = """
            SELECT 
                (SELECT COUNT(*) FROM Bookings WHERE travelerId = ?) as totalBookings,
                (SELECT COUNT(*) FROM Experiences WHERE hostId = ?) as totalExperiences,
                (SELECT ISNULL(SUM(totalPrice), 0) FROM Bookings b 
                 JOIN Experiences e ON b.experienceId = e.experienceId 
                 WHERE e.hostId = ? AND b.status = 'COMPLETED') as totalRevenue
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalBookings(rs.getInt("totalBookings"));
                    stats.setTotalExperiences(rs.getInt("totalExperiences"));
                    stats.setTotalRevenue(rs.getDouble("totalRevenue"));
                }
            }
        }
        return stats;
    }
    
    /**
     * Delete user (soft delete by setting inactive)
     */
    public boolean deleteUser(int userId) throws SQLException {
        return updateUserStatus(userId, false);
    }
    
    /**
     * Search users by keyword
     */
    public List<User> searchUsers(String keyword, String userType) throws SQLException {
        List<User> users = new ArrayList<>();
        
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, userType, emailVerified,
                   verificationToken, tokenExpiry, googleId, provider
            FROM Users 
            WHERE (fullName LIKE ? OR email LIKE ?)
        """);
        
        if (userType != null && !userType.isEmpty()) {
            sqlBuilder.append(" AND userType = ?");
        }
        
        sqlBuilder.append(" ORDER BY createdAt DESC");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            if (userType != null && !userType.isEmpty()) {
                ps.setString(3, userType);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUserFromResultSet(rs));
                }
            }
        }
        return users;
    }
    
    /**
     * Get total users count
     */
    public int getTotalUsersCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE isActive = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Get users count by type
     */
    public int getUsersCountByType(String userType) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE userType = ? AND isActive = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userType);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get users count by provider (local, google, both)
     */
    public int getUsersCountByProvider(String provider) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE provider = ? AND isActive = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, provider);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Log OAuth login attempt
     */
    public boolean logOAuthLogin(int userId, String provider, String providerId, 
                                String email, String ipAddress, String userAgent, boolean isSuccessful) throws SQLException {
        String sql = """
            INSERT INTO OAuthLogins (userId, provider, providerId, email, ipAddress, userAgent, isSuccessful)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, provider);
            ps.setString(3, providerId);
            ps.setString(4, email);
            ps.setString(5, ipAddress);
            ps.setString(6, userAgent);
            ps.setBoolean(7, isSuccessful);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("OAuth login logged for user: " + email + ", provider: " + provider);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Map ResultSet to User object with all fields including OAuth
     */
    private User mapUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("userId"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("fullName"));
        user.setPhone(rs.getString("phone"));
        user.setDateOfBirth(rs.getDate("dateOfBirth"));
        user.setGender(rs.getString("gender"));
        user.setAvatar(rs.getString("avatar"));
        user.setBio(rs.getString("bio"));
        user.setCreatedAt(rs.getDate("createdAt"));
        user.setActive(rs.getBoolean("isActive"));
        user.setUserType(rs.getString("userType"));
        
        // Email verification fields
        user.setEmailVerified(rs.getBoolean("emailVerified"));
        user.setVerificationToken(rs.getString("verificationToken"));
        
        Timestamp tokenExpiry = rs.getTimestamp("tokenExpiry");
        if (tokenExpiry != null) {
            user.setTokenExpiry(new java.util.Date(tokenExpiry.getTime()));
        }
        
        // Google OAuth fields - handle null values properly
        user.setGoogleId(rs.getString("googleId"));
        String provider = rs.getString("provider");
        user.setProvider(provider != null ? provider : "local");
        
        return user;
    }

    public void updateFullName(int userId, String trim) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


public boolean updatePassword(String email, String newPassword) throws SQLException {
    // Tìm user dựa trên email
    User user = getUserByEmail(email);
    if (user == null) {
        LOGGER.log(Level.WARNING, "Không tìm thấy người dùng với email: " + email);
        return false;
    }
    
    // Cập nhật mật khẩu sử dụng phương thức đã có
    return updatePassword(user.getUserId(), newPassword);
}    
    /**
     * Inner class for user statistics
     */
    public static class UserStats {
        private int totalBookings;
        private int totalExperiences;
        private double totalRevenue;
        
        // Default constructor
        public UserStats() {}
        
        // Constructor with parameters
        public UserStats(int totalBookings, int totalExperiences, double totalRevenue) {
            this.totalBookings = totalBookings;
            this.totalExperiences = totalExperiences;
            this.totalRevenue = totalRevenue;
        }
        
        // Getters and setters
        public int getTotalBookings() {
            return totalBookings;
        }
        
        public void setTotalBookings(int totalBookings) {
            this.totalBookings = totalBookings;
        }
        
        public int getTotalExperiences() {
            return totalExperiences;
        }
        
        public void setTotalExperiences(int totalExperiences) {
            this.totalExperiences = totalExperiences;
        }
        
        public double getTotalRevenue() {
            return totalRevenue;
        }
        
        public void setTotalRevenue(double totalRevenue) {
            this.totalRevenue = totalRevenue;
        }
        
        @Override
        public String toString() {
            return "UserStats{" +
                    "totalBookings=" + totalBookings +
                    ", totalExperiences=" + totalExperiences +
                    ", totalRevenue=" + totalRevenue +
                    '}';
        }
    }
}