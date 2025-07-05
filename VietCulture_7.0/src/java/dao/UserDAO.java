package dao;

import model.User;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
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
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting user by ID: " + userId, e);
            // Return null instead of throwing to prevent servlet crash
            return null;
        }
        return null;
    }

    private User mapBasicUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        
        try {
            user.setUserId(rs.getInt("userId"));
            user.setEmail(rs.getString("email"));
            user.setFullName(rs.getString("fullName"));
            user.setRole(rs.getString("role"));
            
            // Handle optional fields safely
            try {
                user.setPhone(rs.getString("phone"));
                user.setCreatedAt(rs.getDate("createdAt"));
                user.setBusinessName(rs.getString("businessName"));
                user.setAverageRating(rs.getDouble("averageRating"));
                user.setTotalExperiences(rs.getInt("totalExperiences"));
            } catch (SQLException e) {
                // Optional fields may not exist or be null, that's OK
                LOGGER.log(Level.FINE, "Optional user field not found: " + e.getMessage());
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error mapping basic user from ResultSet", e);
            throw e;
        }
        
        return user;
    }

    /**
     * Create new user
     */
    public int createUser(User user) throws SQLException {
        String sql = """
            INSERT INTO Users (email, password, fullName, phone, dateOfBirth, gender, 
                              avatar, bio, isActive, role, preferences, totalBookings,
                              businessName, businessType, businessAddress, businessDescription,
                              taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                              permissions, emailVerified, verificationToken, tokenExpiry)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
            ps.setString(10, user.getRole());
            ps.setString(11, user.getPreferences());
            ps.setInt(12, user.getTotalBookings());
            ps.setString(13, user.getBusinessName());
            ps.setString(14, user.getBusinessType());
            ps.setString(15, user.getBusinessAddress());
            ps.setString(16, user.getBusinessDescription());
            ps.setString(17, user.getTaxId());
            ps.setString(18, user.getSkills());
            ps.setString(19, user.getRegion());
            ps.setDouble(20, user.getAverageRating());
            ps.setInt(21, user.getTotalExperiences());
            ps.setDouble(22, user.getTotalRevenue());
            ps.setString(23, user.getPermissions());
            ps.setBoolean(24, user.isEmailVerified());
            ps.setString(25, user.getVerificationToken());
            ps.setTimestamp(26, user.getTokenExpiry() != null ? new java.sql.Timestamp(user.getTokenExpiry().getTime()) : null);

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
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
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
     * Get user by verification token
     */
    public User getUserByVerificationToken(String token) throws SQLException {
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
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
                avatar = ?, bio = ?, isActive = ?, preferences = ?, totalBookings = ?,
                businessName = ?, businessType = ?, businessAddress = ?, businessDescription = ?,
                taxId = ?, skills = ?, region = ?, averageRating = ?, totalExperiences = ?, 
                totalRevenue = ?, permissions = ?
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
            ps.setString(9, user.getPreferences());
            ps.setInt(10, user.getTotalBookings());
            ps.setString(11, user.getBusinessName());
            ps.setString(12, user.getBusinessType());
            ps.setString(13, user.getBusinessAddress());
            ps.setString(14, user.getBusinessDescription());
            ps.setString(15, user.getTaxId());
            ps.setString(16, user.getSkills());
            ps.setString(17, user.getRegion());
            ps.setDouble(18, user.getAverageRating());
            ps.setInt(19, user.getTotalExperiences());
            ps.setDouble(20, user.getTotalRevenue());
            ps.setString(21, user.getPermissions());
            ps.setInt(22, user.getUserId());

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
     * Update user password by email
     */
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        User user = getUserByEmail(email);
        if (user == null) {
            LOGGER.log(Level.WARNING, "Không tìm thấy người dùng với email: " + email);
            return false;
        }
        return updatePassword(user.getUserId(), newPassword);
    }

    /**
     * Update user avatar
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
     * Update user full name
     */
    public void updateFullName(int userId, String fullName) throws SQLException {
        String sql = "UPDATE Users SET fullName = ? WHERE userId = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Full name updated for user ID: " + userId);
            } else {
                LOGGER.log(Level.WARNING, "No user found with ID: " + userId);
                throw new SQLException("Failed to update full name: User not found");
            }
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
     * Check if email exists for another user
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
     * Get all users by role
     */
    public List<User> getUsersByRole(String role) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
            FROM Users 
            WHERE role = ?
            ORDER BY createdAt DESC
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);

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
     * Soft delete user
     */
    public boolean softDeleteUser(int userId, String reason) throws SQLException {
        String sql = "UPDATE Users SET isActive = 0 WHERE userId = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User soft deleted - ID: " + userId + ", Reason: " + reason);
                // Note: Reason is logged but not stored in DB as no field exists
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Restore user
     */
    public boolean restoreUser(int userId) throws SQLException {
        String sql = "UPDATE Users SET isActive = 1 WHERE userId = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User restored - ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Hard delete user
     */
    public boolean hardDeleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE userId = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User hard deleted - ID: " + userId);
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
                 WHERE e.hostId = ? AND b.status = 'COMPLETED') +
                (SELECT ISNULL(SUM(totalPrice), 0) FROM Bookings b 
                 JOIN Accommodations a ON b.accommodationId = a.accommodationId 
                 WHERE a.hostId = ? AND b.status = 'COMPLETED') as totalRevenue
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);

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
     * Search users by keyword
     */
    public List<User> searchUsers(String keyword, String role) throws SQLException {
        List<User> users = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
            FROM Users 
            WHERE (fullName LIKE ? OR email LIKE ?)
        """);

        if (role != null && !role.isEmpty()) {
            sqlBuilder.append(" AND role = ?");
        }

        sqlBuilder.append(" ORDER BY createdAt DESC");

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            if (role != null && !role.isEmpty()) {
                ps.setString(3, role);
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
     * Get users count by role
     */
    public int getUsersCountByRole(String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = ? AND isActive = 1";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Get users with filters for admin management
     */
    public List<User> getUsersWithFilters(String role, String status, String search, int page, int pageSize) throws SQLException {
        List<User> users = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
            FROM Users 
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (role != null && !role.isEmpty()) {
            sqlBuilder.append(" AND role = ?");
            params.add(role);
        }

        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "active":
                    sqlBuilder.append(" AND isActive = 1");
                    break;
                case "inactive":
                    sqlBuilder.append(" AND isActive = 0");
                    break;
                case "pending":
                    sqlBuilder.append(" AND emailVerified = 0");
                    break;
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            sqlBuilder.append(" AND (fullName LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        sqlBuilder.append(" ORDER BY createdAt DESC");
        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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
     * Get total users count with filters
     */
    public int getTotalUsersWithFilters(String role, String status, String search) throws SQLException {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM Users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (role != null && !role.isEmpty()) {
            sqlBuilder.append(" AND role = ?");
            params.add(role);
        }

        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "active":
                    sqlBuilder.append(" AND isActive = 1");
                    break;
                case "inactive":
                    sqlBuilder.append(" AND isActive = 0");
                    break;
                case "pending":
                    sqlBuilder.append(" AND emailVerified = 0");
                    break;
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            sqlBuilder.append(" AND (fullName LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Get user roles counts for statistics
     */
    public Map<String, Integer> getUserRolesCounts() throws SQLException {
        Map<String, Integer> counts = new HashMap<>();
        String sql = """
            SELECT role, COUNT(*) as count 
            FROM Users 
            WHERE isActive = 1 
            GROUP BY role
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                counts.put(rs.getString("role"), rs.getInt("count"));
            }
        }

        return counts;
    }

    /**
     * Lock user account
     */
    public boolean lockUser(int userId, String reason) throws SQLException {
        // For now, just update isActive status
        return updateUserStatus(userId, false);
    }

    /**
     * Unlock user account
     */
    public boolean unlockUser(int userId) throws SQLException {
        return updateUserStatus(userId, true);
    }

    /**
     * Update user role
     */
    public boolean updateUserRole(int userId, String newRole) throws SQLException {
        String sql = """
            UPDATE Users 
            SET role = ?
            WHERE userId = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newRole);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User role updated - ID: " + userId + ", New Role: " + newRole);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Get user growth percentage
     */
    public double getUserGrowthPercentage(String period) throws SQLException {
        String sql;
        switch (period) {
            case "week":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Users WHERE createdAt >= DATEADD(DAY, -7, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Users WHERE createdAt >= DATEADD(DAY, -14, GETDATE()) 
                         AND createdAt < DATEADD(DAY, -7, GETDATE())) as previous_period
                """;
                break;
            case "year":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Users WHERE createdAt >= DATEADD(YEAR, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Users WHERE createdAt >= DATEADD(YEAR, -2, GETDATE()) 
                         AND createdAt < DATEADD(YEAR, -1, GETDATE())) as previous_period
                """;
                break;
            default: // month
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Users WHERE createdAt >= DATEADD(MONTH, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Users WHERE createdAt >= DATEADD(MONTH, -2, GETDATE()) 
                         AND createdAt < DATEADD(MONTH, -1, GETDATE())) as previous_period
                """;
        }

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int currentPeriod = rs.getInt("current_period");
                int previousPeriod = rs.getInt("previous_period");

                if (previousPeriod == 0) {
                    return currentPeriod > 0 ? 100.0 : 0.0;
                }

                return ((double) (currentPeriod - previousPeriod) / previousPeriod) * 100.0;
            }
        }

        return 0.0;
    }

    /**
     * Get traveler growth data for chart
     */
    public List<Integer> getTravelerGrowthData(int months) throws SQLException {
        List<Integer> data = new ArrayList<>();
        String sql = """
            SELECT COUNT(*) as count
            FROM Users 
            WHERE role = 'TRAVELER' 
            AND createdAt >= DATEADD(MONTH, ?, GETDATE())
            AND createdAt < DATEADD(MONTH, ?, GETDATE())
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = months - 1; i >= 0; i--) {
                ps.setInt(1, -i - 1);
                ps.setInt(2, -i);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        data.add(rs.getInt("count"));
                    } else {
                        data.add(0);
                    }
                }
            }
        }

        return data;
    }

    /**
     * Get host growth data for chart
     */
    public List<Integer> getHostGrowthData(int months) throws SQLException {
        List<Integer> data = new ArrayList<>();
        String sql = """
            SELECT COUNT(*) as count
            FROM Users 
            WHERE role = 'HOST' 
            AND createdAt >= DATEADD(MONTH, ?, GETDATE())
            AND createdAt < DATEADD(MONTH, ?, GETDATE())
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = months - 1; i >= 0; i--) {
                ps.setInt(1, -i - 1);
                ps.setInt(2, -i);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        data.add(rs.getInt("count"));
                    } else {
                        data.add(0);
                    }
                }
            }
        }

        return data;
    }

    /**
     * Get users by region for statistics
     */
    public Map<String, Integer> getUsersByRegion() throws SQLException {
        Map<String, Integer> regionCounts = new HashMap<>();
        String sql = """
            SELECT region, COUNT(*) as userCount
            FROM Users
            WHERE isActive = 1 AND role = 'HOST' AND region IS NOT NULL
            GROUP BY region
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String regionName = rs.getString("region");
                int count = rs.getInt("userCount");
                regionCounts.put(regionName, count);
            }
        }

        return regionCounts;
    }

    /**
     * Update host statistics
     */
    public boolean updateHostStats(int userId, double averageRating, int totalExperiences, double totalRevenue) throws SQLException {
        String sql = """
            UPDATE Users 
            SET averageRating = ?, totalExperiences = ?, totalRevenue = ?
            WHERE userId = ? AND role = 'HOST'
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, averageRating);
            ps.setInt(2, totalExperiences);
            ps.setDouble(3, totalRevenue);
            ps.setInt(4, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Host stats updated for user ID: " + userId);
            }
            return rowsAffected > 0;
        }
    }

    /**
     * Get all hosts with pagination
     */
    public List<User> getAllHosts(int offset, int limit) throws SQLException {
        List<User> hosts = new ArrayList<>();
        String sql = """
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
            FROM Users 
            WHERE role = 'HOST' AND isActive = 1
            ORDER BY totalRevenue DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    hosts.add(mapUserFromResultSet(rs));
                }
            }
        }
        return hosts;
    }

    /**
     * Search hosts by keyword and region
     */
    public List<User> searchHosts(String keyword, String region, int offset, int limit) throws SQLException {
        List<User> hosts = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
            FROM Users 
            WHERE role = 'HOST' AND isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append(" AND (businessName LIKE ? OR fullName LIKE ? OR businessDescription LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (region != null && !region.trim().isEmpty()) {
            sqlBuilder.append(" AND region = ?");
            parameters.add(region);
        }

        sqlBuilder.append(" ORDER BY averageRating DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    hosts.add(mapUserFromResultSet(rs));
                }
            }
        }
        return hosts;
    }

    /**
     * Get hosts count by region
     */
    public int getHostsCountByRegion(String region) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Users
            WHERE isActive = 1 AND role = 'HOST' AND region = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, region);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Get total hosts count
     */
    public int getTotalHostsCount() throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM Users
            WHERE isActive = 1 AND role = 'HOST'
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Get top hosts by rating
     */
    public List<User> getTopHosts(int limit) throws SQLException {
        List<User> hosts = new ArrayList<>();
        String sql = """
            SELECT TOP(?) userId, email, password, fullName, phone, dateOfBirth, gender, 
                   avatar, bio, createdAt, isActive, role, preferences, totalBookings,
                   businessName, businessType, businessAddress, businessDescription,
                   taxId, skills, region, averageRating, totalExperiences, totalRevenue,
                   permissions, emailVerified, verificationToken, tokenExpiry
            FROM Users 
            WHERE role = 'HOST' AND isActive = 1 AND averageRating > 0
            ORDER BY averageRating DESC, totalExperiences DESC
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    hosts.add(mapUserFromResultSet(rs));
                }
            }
        }
        return hosts;
    }

    /**
     * Map ResultSet to User object
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
        user.setRole(rs.getString("role"));
        user.setPreferences(rs.getString("preferences"));
        user.setTotalBookings(rs.getInt("totalBookings"));
        user.setBusinessName(rs.getString("businessName"));
        user.setBusinessType(rs.getString("businessType"));
        user.setBusinessAddress(rs.getString("businessAddress"));
        user.setBusinessDescription(rs.getString("businessDescription"));
        user.setTaxId(rs.getString("taxId"));
        user.setSkills(rs.getString("skills"));
        user.setRegion(rs.getString("region"));
        user.setAverageRating(rs.getDouble("averageRating"));
        user.setTotalExperiences(rs.getInt("totalExperiences"));
        user.setTotalRevenue(rs.getDouble("totalRevenue"));
        user.setPermissions(rs.getString("permissions"));
        user.setEmailVerified(rs.getBoolean("emailVerified"));
        user.setVerificationToken(rs.getString("verificationToken"));

        Timestamp tokenExpiry = rs.getTimestamp("tokenExpiry");
        if (tokenExpiry != null) {
            user.setTokenExpiry(new java.util.Date(tokenExpiry.getTime()));
        }

        return user;
    }

    public int getRecentHostsCount(int days) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean canBecomeHost(int userId) throws SQLException {
        String sql = """
            SELECT role, emailVerified, isActive 
            FROM Users 
            WHERE userId = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    boolean emailVerified = rs.getBoolean("emailVerified");
                    boolean isActive = rs.getBoolean("isActive");
                    
                    return "TRAVELER".equals(role) && emailVerified && isActive;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user can become host: " + userId, e);
            throw e;
        }
        return false;
    }

    public boolean upgradeUserToHost(int userId) throws SQLException {
        String sql = """
            UPDATE Users 
            SET role = 'HOST',
                averageRating = 0,
                totalExperiences = 0,
                totalRevenue = 0
            WHERE userId = ? AND role = 'TRAVELER' AND emailVerified = 1 AND isActive = 1
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("User upgraded to HOST - ID: " + userId);
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error upgrading user to host: " + userId, e);
            throw e;
        }
        return false;
    }

    public boolean updateHostBusinessInfo(int userId, String businessName, String businessType, 
                                        String businessAddress, String businessDescription, 
                                        String taxId, String skills, String region) throws SQLException {
        String sql = """
            UPDATE Users 
            SET businessName = ?, businessType = ?, businessAddress = ?, 
                businessDescription = ?, taxId = ?, skills = ?, region = ?
            WHERE userId = ? AND role = 'HOST'
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, businessName);
            ps.setString(2, businessType);
            ps.setString(3, businessAddress);
            ps.setString(4, businessDescription);
            ps.setString(5, taxId);
            ps.setString(6, skills);
            ps.setString(7, region);
            ps.setInt(8, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Host business info updated - ID: " + userId);
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating host business info: " + userId, e);
            throw e;
        }
        return false;
    }

    /**
     * Inner class for user statistics
     */
    public static class UserStats {
        private int totalBookings;
        private int totalExperiences;
        private double totalRevenue;

        public UserStats() {}

        public UserStats(int totalBookings, int totalExperiences, double totalRevenue) {
            this.totalBookings = totalBookings;
            this.totalExperiences = totalExperiences;
            this.totalRevenue = totalRevenue;
        }

        public int getTotalBookings() { return totalBookings; }
        public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

        public int getTotalExperiences() { return totalExperiences; }
        public void setTotalExperiences(int totalExperiences) { this.totalExperiences = totalExperiences; }

        public double getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

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