package dao;

import model.Experience;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * ExperienceDAO với logic adminApprovalStatus mới
 * adminApprovalStatus: PENDING, APPROVED, REJECTED
 * isActive: 1 (host hiện), 0 (host ẩn)
 * Hiển thị công khai: adminApprovalStatus = 'APPROVED' AND isActive = 1
 */
public class ExperienceDAO {
    private static final Logger LOGGER = Logger.getLogger(ExperienceDAO.class.getName());

    /**
     * Lấy trải nghiệm theo ID
     */
    public Experience getExperienceById(int experienceId) throws SQLException {
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   e.adminApprovalStatus, e.adminApprovedBy, e.adminApprovedAt, 
                   e.adminRejectReason, e.adminNotes,
                   e.promotion_percent, e.promotion_start, e.promotion_end,
                   u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.experienceId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapExperienceFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting experience by ID: " + experienceId, e);
            return null;
        }
        return null;
    }

    /**
     * Tạo trải nghiệm mới - LOGIC MỚI
     * Trải nghiệm sẽ có adminApprovalStatus = 'PENDING' và isActive = true (host muốn hiện)
     */
    public int createExperience(Experience experience) throws SQLException {
        String sql = """
            INSERT INTO Experiences (hostId, title, description, location, cityId, type,
                                   price, maxGroupSize, duration, difficulty, language,
                                   includedItems, requirements, images, isActive, 
                                   adminApprovalStatus, averageRating, totalBookings, promotion_percent, promotion_start, promotion_end)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, experience.getHostId());
            ps.setString(2, experience.getTitle());
            ps.setString(3, experience.getDescription());
            ps.setString(4, experience.getLocation());
            ps.setInt(5, experience.getCityId());
            ps.setString(6, experience.getType());
            ps.setDouble(7, experience.getPrice());
            ps.setInt(8, experience.getMaxGroupSize());
            ps.setTime(9, new java.sql.Time(experience.getDuration().getTime()));
            ps.setString(10, experience.getDifficulty());
            ps.setString(11, experience.getLanguage());
            ps.setString(12, experience.getIncludedItems());
            ps.setString(13, experience.getRequirements());
            ps.setString(14, experience.getImages());
            ps.setBoolean(15, experience.isActive()); // Host muốn hiện/ẩn
            ps.setString(16, "PENDING"); // Chờ admin duyệt
            ps.setDouble(17, 0.0); // averageRating default
            ps.setInt(18, 0); // totalBookings default
            ps.setInt(19, experience.getPromotionPercent());
            ps.setTimestamp(20, experience.getPromotionStart());
            ps.setTimestamp(21, experience.getPromotionEnd());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int experienceId = generatedKeys.getInt(1);
                        experience.setExperienceId(experienceId);
                        
                        LOGGER.info("Experience created with ID: " + experienceId + 
                                   ", adminApprovalStatus: PENDING, isActive: " + experience.isActive());
                        return experienceId;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating experience", e);
            throw e;
        }
        return 0;
    }

    /**
     * ADMIN DUYỆT trải nghiệm
     */
    public boolean approveExperience(int experienceId, int adminUserId) throws SQLException {
        String sql = """
            UPDATE Experiences 
            SET adminApprovalStatus = 'APPROVED',
                adminApprovedBy = ?,
                adminApprovedAt = GETDATE(),
                adminRejectReason = NULL
            WHERE experienceId = ? AND adminApprovalStatus = 'PENDING'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, adminUserId);
            ps.setInt(2, experienceId);
            
            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;
            
            LOGGER.info("Admin approve experience " + experienceId + ": " + 
                       (success ? "SUCCESS" : "FAILED") + " by admin " + adminUserId);
            
            return success;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error approving experience " + experienceId, e);
            throw e;
        }
    }

    /**
     * ADMIN TỪ CHỐI trải nghiệm
     */
    public boolean rejectExperience(int experienceId, int adminUserId, String reason) throws SQLException {
        String sql = """
            UPDATE Experiences 
            SET adminApprovalStatus = 'REJECTED',
                adminApprovedBy = ?,
                adminApprovedAt = GETDATE(),
                adminRejectReason = ?
            WHERE experienceId = ? AND adminApprovalStatus IN ('PENDING', 'APPROVED')
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, adminUserId);
            ps.setString(2, reason);
            ps.setInt(3, experienceId);
            
            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;
            
            LOGGER.info("Admin reject experience " + experienceId + ": " + 
                       (success ? "SUCCESS" : "FAILED") + " - Reason: " + reason);
            
            return success;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error rejecting experience " + experienceId, e);
            throw e;
        }
    }

    /**
     * ADMIN THU HỒI duyệt trải nghiệm
     */
    public boolean revokeApproval(int experienceId, int adminUserId, String reason) throws SQLException {
        String sql = """
            UPDATE Experiences 
            SET adminApprovalStatus = 'PENDING',
                adminApprovedBy = ?,
                adminApprovedAt = GETDATE(),
                adminRejectReason = ?,
                adminNotes = ?
            WHERE experienceId = ? AND adminApprovalStatus = 'APPROVED'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, adminUserId);
            ps.setString(2, reason);
            ps.setString(3, "Revoked: " + reason);
            ps.setInt(4, experienceId);
            
            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;
            
            LOGGER.info("Admin revoke experience " + experienceId + ": " + 
                       (success ? "SUCCESS" : "FAILED") + " - Reason: " + reason);
            
            return success;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error revoking experience " + experienceId, e);
            throw e;
        }
    }

    /**
     * Lấy trải nghiệm CHỜ DUYỆT (cho admin)
     */
    public List<Experience> getPendingExperiences(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'PENDING'
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy trải nghiệm ĐÃ DUYỆT (cho admin)
     */
    public List<Experience> getApprovedExperiences(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED'
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy trải nghiệm BỊ TỪ CHỐI (cho admin)
     */
    public List<Experience> getRejectedExperiences(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'REJECTED'
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy TẤT CẢ trải nghiệm (cho admin)
     */
    public List<Experience> getAllExperiences(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy trải nghiệm HIỂN THỊ CÔNG KHAI (cho user)
     * Điều kiện: adminApprovalStatus = 'APPROVED' AND isActive = 1
     */
    public List<Experience> getPublicExperiences(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy trải nghiệm ĐÃ DUYỆT NHƯNG ẨN bởi host
     */
    public int getApprovedButHiddenCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE adminApprovalStatus = 'APPROVED' AND isActive = 0";
        return getCount(sql);
    }

    /**
     * Lấy trải nghiệm phổ biến (hiển thị công khai + có booking cao)
     */
    public List<Experience> getPopularExperiences(int offset, int limit) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
            AND e.totalBookings >= 5 AND e.averageRating >= 4.0
            ORDER BY e.totalBookings DESC, e.averageRating DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, offset, limit);
    }

    /**
     * Lấy trải nghiệm mới nhất (hiển thị công khai)
     */
    public List<Experience> getNewestExperiences(int offset, int limit) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, offset, limit);
    }

    /**
     * Lấy trải nghiệm được đánh giá cao (hiển thị công khai)
     */
    public List<Experience> getTopRatedExperiences(int offset, int limit) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
            AND e.averageRating > 0
            ORDER BY e.averageRating DESC, e.totalBookings DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, offset, limit);
    }

    /**
     * Lấy trải nghiệm giá thấp (hiển thị công khai)
     */
    public List<Experience> getLowPriceExperiences(int offset, int limit) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
            ORDER BY e.price ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, offset, limit);
    }

    /**
     * Tìm kiếm trải nghiệm nâng cao (chỉ hiển thị công khai)
     */
    public List<Experience> searchExperiences(Integer categoryId, Integer regionId, Integer cityId,
                                             String search, String sort, int offset, int limit) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();

        if (categoryId != null) {
            sql.append(" AND e.type = (SELECT name FROM Categories WHERE categoryId = ?)");
            parameters.add(categoryId);
        }
        if (regionId != null) {
            sql.append(" AND c.regionId = ?");
            parameters.add(regionId);
        }
        if (cityId != null) {
            sql.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Apply sorting
        if ("price-asc".equals(sort)) {
            sql.append(" ORDER BY e.price ASC");
        } else if ("price-desc".equals(sort)) {
            sql.append(" ORDER BY e.price DESC");
        } else if ("rating-desc".equals(sort)) {
            sql.append(" ORDER BY e.averageRating DESC");
        } else {
            sql.append(" ORDER BY e.createdAt DESC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            return executeQuery(ps);
        }
    }

    /**
     * Tìm kiếm đơn giản (chỉ hiển thị công khai)
     */
    public List<Experience> searchExperiences(String keyword, Integer cityId, String type, 
                                            int offset, int limit) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        if (cityId != null) {
            sql.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND e.type = ?");
            parameters.add(type);
        }

        sql.append(" ORDER BY e.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            return executeQuery(ps);
        }
    }

    /**
     * Đếm kết quả tìm kiếm nâng cao
     */
    public int getFilteredExperiencesCount(Integer categoryId, Integer regionId, Integer cityId,
                                          String search) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();

        if (categoryId != null) {
            sql.append(" AND e.type = (SELECT name FROM Categories WHERE categoryId = ?)");
            parameters.add(categoryId);
        }
        if (regionId != null) {
            sql.append(" AND c.regionId = ?");
            parameters.add(regionId);
        }
        if (cityId != null) {
            sql.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        return getCountWithParams(sql.toString(), parameters);
    }

    /**
     * Tìm kiếm trải nghiệm nâng cao với khoảng cách (chỉ hiển thị công khai)
     */
    public List<Experience> searchExperiencesWithDistance(Integer categoryId, Integer regionId, Integer cityId,
                                                         String search, String sort, Double userLat, Double userLng, 
                                                         Double maxDistance, int offset, int limit) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
        """);
        
        // Add distance calculation if coordinates provided
        if (userLat != null && userLng != null) {
            sql.append(", (6371 * acos(cos(radians(?)) * cos(radians(COALESCE(e.latitude, 0))) * ");
            sql.append("cos(radians(COALESCE(e.longitude, 0)) - radians(?)) + ");
            sql.append("sin(radians(?)) * sin(radians(COALESCE(e.latitude, 0))))) AS distance ");
        }
        
        sql.append("""
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();
        
        // Add coordinates for distance calculation
        if (userLat != null && userLng != null) {
            parameters.add(userLat);  // for cos(radians(?))
            parameters.add(userLng);  // for cos(radians(?))  
            parameters.add(userLat);  // for sin(radians(?))
        }

        if (categoryId != null) {
            sql.append(" AND e.type = (SELECT name FROM Categories WHERE categoryId = ?)");
            parameters.add(categoryId);
        }
        if (regionId != null) {
            sql.append(" AND c.regionId = ?");
            parameters.add(regionId);
        }
        if (cityId != null) {
            sql.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        // Add distance filter
        if (userLat != null && userLng != null && maxDistance != null) {
            sql.append(" AND (6371 * acos(cos(radians(?)) * cos(radians(COALESCE(e.latitude, 0))) * ");
            sql.append("cos(radians(COALESCE(e.longitude, 0)) - radians(?)) + ");
            sql.append("sin(radians(?)) * sin(radians(COALESCE(e.latitude, 0))))) <= ?");
            parameters.add(userLat);
            parameters.add(userLng);
            parameters.add(userLat);
            parameters.add(maxDistance);
        }

        // Apply sorting
        if (userLat != null && userLng != null && "distance".equals(sort)) {
            sql.append(" ORDER BY distance ASC");
        } else if ("price-asc".equals(sort)) {
            sql.append(" ORDER BY e.price ASC");
        } else if ("price-desc".equals(sort)) {
            sql.append(" ORDER BY e.price DESC");
        } else if ("rating-desc".equals(sort)) {
            sql.append(" ORDER BY e.averageRating DESC");
        } else {
            sql.append(" ORDER BY e.createdAt DESC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            return executeQuery(ps);
        }
    }

    /**
     * Đếm kết quả tìm kiếm nâng cao với khoảng cách
     */
    public int getFilteredExperiencesCountWithDistance(Integer categoryId, Integer regionId, Integer cityId,
                                                      String search, Double userLat, Double userLng, 
                                                      Double maxDistance) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();

        if (categoryId != null) {
            sql.append(" AND e.type = (SELECT name FROM Categories WHERE categoryId = ?)");
            parameters.add(categoryId);
        }
        if (regionId != null) {
            sql.append(" AND c.regionId = ?");
            parameters.add(regionId);
        }
        if (cityId != null) {
            sql.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        // Add distance filter
        if (userLat != null && userLng != null && maxDistance != null) {
            sql.append(" AND (6371 * acos(cos(radians(?)) * cos(radians(COALESCE(e.latitude, 0))) * ");
            sql.append("cos(radians(COALESCE(e.longitude, 0)) - radians(?)) + ");
            sql.append("sin(radians(?)) * sin(radians(COALESCE(e.latitude, 0))))) <= ?");
            parameters.add(userLat);
            parameters.add(userLng);
            parameters.add(userLat);
            parameters.add(maxDistance);
        }

        return getCountWithParams(sql.toString(), parameters);
    }

    /**
     * CÁC PHƯƠNG THỨC ĐẾM
     */
    public int getPendingExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE adminApprovalStatus = 'PENDING'";
        return getCount(sql);
    }

    public int getApprovedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE adminApprovalStatus = 'APPROVED'";
        return getCount(sql);
    }

    public int getRejectedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE adminApprovalStatus = 'REJECTED'";
        return getCount(sql);
    }

    public int getTotalExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences";
        return getCount(sql);
    }

    public int getPublicExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE adminApprovalStatus = 'APPROVED' AND isActive = 1";
        return getCount(sql);
    }

    public int getPopularExperiencesCount() throws SQLException {
        return getPublicExperiencesCount();
    }

    public int getNewestExperiencesCount() throws SQLException {
        return getPublicExperiencesCount();
    }

    public int getTopRatedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE adminApprovalStatus = 'APPROVED' AND isActive = 1 AND averageRating > 0";
        return getCount(sql);
    }

    public int getLowPriceExperiencesCount() throws SQLException {
        return getPublicExperiencesCount();
    }

    public int getActiveExperiencesCount() throws SQLException {
        return getPublicExperiencesCount();
    }

    /**
     * CÁC PHƯƠNG THỨC CHO HOST
     */
    public List<Experience> getExperiencesByHostId(int hostId) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.hostId = ?
            ORDER BY e.createdAt DESC
        """;
        
        return executeExperienceQuery(sql, hostId);
    }

    public List<Experience> getExperiencesByHost(int hostId, int offset, int limit) throws SQLException {
        String sql = """
            SELECT e.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Experiences e
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Cities c ON e.cityId = c.cityId
            WHERE e.hostId = ?
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        return executeExperienceQuery(sql, hostId, offset, limit);
    }

    public int getTotalExperiencesByHost(int hostId) throws SQLException {
        return countExperiencesByHostId(hostId);
    }

    public int countExperiencesByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE hostId = ?";
        return getCountWithParam(sql, hostId);
    }

    public int countPendingExperiencesByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE hostId = ? AND adminApprovalStatus = 'PENDING'";
        return getCountWithParam(sql, hostId);
    }

    public int countApprovedExperiencesByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE hostId = ? AND adminApprovalStatus = 'APPROVED'";
        return getCountWithParam(sql, hostId);
    }

    public int countActiveExperiencesByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE hostId = ? AND adminApprovalStatus = 'APPROVED' AND isActive = 1";
        return getCountWithParam(sql, hostId);
    }

    /**
     * HOST CẬP NHẬT TRẠNG THÁI ẨN/HIỆN (chỉ khi đã được duyệt)
     */
    public boolean updateExperienceVisibility(int experienceId, int hostId, boolean isActive) throws SQLException {
        String sql = """
            UPDATE Experiences 
            SET isActive = ? 
            WHERE experienceId = ? AND hostId = ? AND adminApprovalStatus = 'APPROVED'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, experienceId);
            ps.setInt(3, hostId);
            
            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;
            
            LOGGER.info("Host " + hostId + " " + (isActive ? "show" : "hide") + 
                       " experience " + experienceId + ": " + (success ? "SUCCESS" : "FAILED"));
            
            return success;
        }
    }

    /**
     * HOST CẬP NHẬT TRẠNG THÁI (legacy method)
     */
    public boolean updateExperienceStatus(int experienceId, boolean isActive) throws SQLException {
        String sql = "UPDATE Experiences SET isActive = ? WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, experienceId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * CẬP NHẬT THÔNG TIN TRẢI NGHIỆM (cho phép cả APPROVED - sẽ reset về PENDING)
     */
    public boolean updateExperience(Experience experience) throws SQLException {
        LOGGER.info("=== DAO UPDATE EXPERIENCE ===");
        LOGGER.info("Experience ID: " + experience.getExperienceId());
        LOGGER.info("Host ID: " + experience.getHostId());
        LOGGER.info("TITLE IN DAO: [" + experience.getTitle() + "] (length: " + (experience.getTitle() != null ? experience.getTitle().length() : "null") + ")");
        LOGGER.info("Price: " + experience.getPrice());
        
        String sql = """
            UPDATE Experiences 
            SET title = ?, description = ?, location = ?, cityId = ?, type = ?,
                price = ?, maxGroupSize = ?, duration = ?, difficulty = ?, language = ?,
                includedItems = ?, requirements = ?, images = ?, promotion_percent = ?, promotion_start = ?, promotion_end = ?
            WHERE experienceId = ? AND hostId = ? 
            AND adminApprovalStatus IN ('PENDING', 'REJECTED', 'APPROVED')
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, experience.getTitle());
            ps.setString(2, experience.getDescription());
            ps.setString(3, experience.getLocation());
            ps.setInt(4, experience.getCityId());
            ps.setString(5, experience.getType());
            ps.setDouble(6, experience.getPrice());
            ps.setInt(7, experience.getMaxGroupSize());
            ps.setTime(8, new java.sql.Time(experience.getDuration().getTime()));
            ps.setString(9, experience.getDifficulty());
            ps.setString(10, experience.getLanguage());
            ps.setString(11, experience.getIncludedItems());
            ps.setString(12, experience.getRequirements());
            ps.setString(13, experience.getImages());
            ps.setInt(14, experience.getPromotionPercent());
            ps.setTimestamp(15, experience.getPromotionStart());
            ps.setTimestamp(16, experience.getPromotionEnd());
            ps.setInt(17, experience.getExperienceId());
            ps.setInt(18, experience.getHostId());
            
            LOGGER.info("Executing SQL update...");
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Rows affected: " + rowsAffected);
            boolean success = rowsAffected > 0;
            
            if (success) {
                LOGGER.info("Update successful! Checking if need to reset approval status...");
                // Reset về PENDING nếu đang bị REJECTED hoặc đã APPROVED
                String resetSql = """
                    UPDATE Experiences 
                    SET adminApprovalStatus = 'PENDING', adminRejectReason = NULL, 
                        adminApprovedBy = NULL, adminApprovedAt = NULL
                    WHERE experienceId = ? AND adminApprovalStatus IN ('REJECTED', 'APPROVED')
                """;
                try (PreparedStatement resetPs = conn.prepareStatement(resetSql)) {
                    resetPs.setInt(1, experience.getExperienceId());
                    int resetRows = resetPs.executeUpdate();
                    if (resetRows > 0) {
                        LOGGER.info("Experience " + experience.getExperienceId() + " reset to PENDING for re-approval");
                    } else {
                        LOGGER.info("No status reset needed for experience " + experience.getExperienceId());
                    }
                }
            } else {
                LOGGER.warning("Update failed! No rows affected. Check WHERE conditions.");
            }
            
            return success;
        }
    }

    /**
     * Cập nhật rating và booking
     */
    public boolean updateExperienceRating(int experienceId, double averageRating) throws SQLException {
        String sql = "UPDATE Experiences SET averageRating = ? WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, averageRating);
            ps.setInt(2, experienceId);
            
            return ps.executeUpdate() > 0;
        }
    }

    public boolean incrementTotalBookings(int experienceId) throws SQLException {
        String sql = "UPDATE Experiences SET totalBookings = totalBookings + 1 WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * XÓA VĨNH VIỄN (ADMIN)
     */
    public boolean deleteExperience(int experienceId) throws SQLException {
        String sql = "DELETE FROM Experiences WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            int rowsAffected = ps.executeUpdate();
            
            boolean success = rowsAffected > 0;
            LOGGER.info("Delete experience " + experienceId + ": " + (success ? "SUCCESS" : "FAILED"));
            
            return success;
        }
    }

    /**
     * CÁC PHƯƠNG THỨC XỬ LÝ BÁO CÁO VÀ ĐÁNH DẤU
     */
    public boolean flagExperience(int experienceId, String reason) throws SQLException {
        // Base schema không có flag fields, log action
        LOGGER.info("Flag experience " + experienceId + " - Reason: " + reason);
        return true;
    }

    public boolean unflagExperience(int experienceId) throws SQLException {
        // Base schema không có flag fields, log action
        LOGGER.info("Unflag experience " + experienceId);
        return true;
    }

    public boolean softDeleteExperience(int experienceId, String reason) throws SQLException {
        // Base schema không có soft delete fields, perform hard delete
        LOGGER.info("Soft delete requested for experience " + experienceId + " - Reason: " + reason);
        return deleteExperience(experienceId);
    }

    public boolean restoreExperience(int experienceId) throws SQLException {
        // Base schema không có soft delete fields, log action
        LOGGER.info("Restore requested for experience " + experienceId);
        return true;
    }

    /**
     * CÁC PHƯƠNG THỨC THỐNG KÊ
     */
    public Map<String, Integer> getExperiencesByRegion() throws SQLException {
        Map<String, Integer> regionCounts = new HashMap<>();
        String sql = """
            SELECT r.name as regionName, COUNT(e.experienceId) as count
            FROM Experiences e
            JOIN Cities c ON e.cityId = c.cityId
            JOIN Regions r ON c.regionId = r.regionId
            WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1
            GROUP BY r.name
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                regionCounts.put(rs.getString("regionName"), rs.getInt("count"));
            }
        }
        
        return regionCounts;
    }

    public List<Integer> getMonthlyGrowthData(int months) throws SQLException {
        List<Integer> data = new ArrayList<>();
        String sql = """
            SELECT COUNT(*) as count
            FROM Experiences 
            WHERE createdAt >= DATEADD(MONTH, ?, GETDATE())
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

    public double getGrowthPercentage(String period) throws SQLException {
        String sql;
        switch (period) {
            case "week":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(DAY, -7, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(DAY, -14, GETDATE()) 
                         AND createdAt < DATEADD(DAY, -7, GETDATE())) as previous_period
                """;
                break;
            case "year":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(YEAR, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(YEAR, -2, GETDATE()) 
                         AND createdAt < DATEADD(YEAR, -1, GETDATE())) as previous_period
                """;
                break;
            default: // month
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(MONTH, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(MONTH, -2, GETDATE()) 
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

    public int getRecentExperiencesCount(int days) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE createdAt >= DATEADD(DAY, ?, GETDATE())";
        return getCountWithParam(sql, -days);
    }

    /**
     * CÁC PHƯƠNG THỨC PLACEHOLDER CHO TƯƠNG THÍCH
     */
    public List<Experience> getReportedExperiences(int page, int pageSize) throws SQLException {
        // Base schema không có report fields, return empty list
        return new ArrayList<>();
    }

    public List<Experience> getFlaggedExperiences(int page, int pageSize) throws SQLException {
        // Base schema không có flag fields, return empty list
        return new ArrayList<>();
    }

    public List<Experience> getDeletedExperiences(int page, int pageSize) throws SQLException {
        // Base schema không có soft delete, return empty list
        return new ArrayList<>();
    }

    public int getReportedExperiencesCount() throws SQLException {
        return 0;
    }

    public int getFlaggedExperiencesCount() throws SQLException {
        return 0;
    }

    public int getDeletedExperiencesCount() throws SQLException {
        return 0;
    }

    /**
     * CÁC PHƯƠNG THỨC HỖ TRỢ
     */
    private List<Experience> executeExperienceQuery(String sql, Object... params) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            return executeQuery(ps);
        }
    }

    private List<Experience> executeQuery(PreparedStatement ps) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                experiences.add(mapExperienceFromResultSet(rs));
            }
        }
        
        return experiences;
    }

    private int getCount(String sql) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting count", e);
            return 0;
        }
    }

    private int getCountWithParam(String sql, Object param) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, param);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting count with param", e);
            return 0;
        }
    }

    private int getCountWithParams(String sql, List<Object> params) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting count with params", e);
            return 0;
        }
    }

    /**
     * Map ResultSet sang Experience object
     */
    private Experience mapExperienceFromResultSet(ResultSet rs) throws SQLException {
        Experience experience = new Experience();
        
        // Basic fields
        experience.setExperienceId(rs.getInt("experienceId"));
        experience.setHostId(rs.getInt("hostId"));
        experience.setTitle(rs.getString("title"));
        experience.setDescription(rs.getString("description"));
        experience.setLocation(rs.getString("location"));
        experience.setCityId(rs.getInt("cityId"));
        experience.setType(rs.getString("type"));
        experience.setPrice(rs.getDouble("price"));
        experience.setMaxGroupSize(rs.getInt("maxGroupSize"));
        experience.setDuration(rs.getTime("duration"));
        experience.setDifficulty(rs.getString("difficulty"));
        experience.setLanguage(rs.getString("language"));
        experience.setIncludedItems(rs.getString("includedItems"));
        experience.setRequirements(rs.getString("requirements"));
        experience.setCreatedAt(rs.getDate("createdAt"));
        experience.setActive(rs.getBoolean("isActive"));
        experience.setImages(rs.getString("images"));
        experience.setAverageRating(rs.getDouble("averageRating"));
        experience.setTotalBookings(rs.getInt("totalBookings"));
        
        // Promotion fields (nếu có)
        try {
            experience.setPromotionPercent(rs.getInt("promotion_percent"));
            experience.setPromotionStart(rs.getTimestamp("promotion_start"));
            experience.setPromotionEnd(rs.getTimestamp("promotion_end"));
        } catch (SQLException e) {
            // Ignore if fields don't exist in this query
        }
        
        // Admin approval fields (nếu có)
        try {
            experience.setAdminApprovalStatus(rs.getString("adminApprovalStatus"));
            experience.setAdminApprovedBy(rs.getInt("adminApprovedBy"));
            if (rs.wasNull()) experience.setAdminApprovedBy(null);
            experience.setAdminApprovedAt(rs.getTimestamp("adminApprovedAt"));
            experience.setAdminRejectReason(rs.getString("adminRejectReason"));
            experience.setAdminNotes(rs.getString("adminNotes"));
        } catch (SQLException e) {
            // Ignore if fields don't exist in this query
            experience.setAdminApprovalStatus("PENDING");
        }
        
        // Joined fields (nếu có)
        try {
            experience.setHostName(rs.getString("hostName"));
            experience.setCityName(rs.getString("cityName"));
        } catch (SQLException e) {
            // Ignore if fields don't exist in this query
        }
        
        return experience;
    }

    // ===== LEGACY METHODS CHO TƯƠNG THÍCH NGƯỢC =====
    
    @Deprecated
    public List<Experience> getAllActiveExperiences(int offset, int limit) throws SQLException {
        return getPublicExperiences((offset / limit) + 1, limit);
    }

    @Deprecated
    public boolean approveExperience(int experienceId) throws SQLException {
        // Fallback - approve without admin info
        String sql = "UPDATE Experiences SET adminApprovalStatus = 'APPROVED', adminApprovedAt = GETDATE() WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    @Deprecated
    public boolean rejectExperience(int experienceId, String reason, boolean allowResubmit) throws SQLException {
        return rejectExperience(experienceId, 1, reason); // Use admin ID = 1 as fallback
    }

    @Deprecated
    public boolean rejectExperience(int experienceId, String reason) throws SQLException {
        return rejectExperience(experienceId, 1, reason); // Use admin ID = 1 as fallback
    }

    @Deprecated
    public boolean revokeApproval(int experienceId, String reason) throws SQLException {
        return revokeApproval(experienceId, 1, reason); // Use admin ID = 1 as fallback
    }

    /**
     * Update promotion for experience
     */
    public boolean updatePromotion(int experienceId, int promotionPercent,
            java.sql.Timestamp promotionStart, java.sql.Timestamp promotionEnd) throws SQLException {
        String sql = "UPDATE experiences SET promotion_percent = ?, promotion_start = ?, promotion_end = ? WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, promotionPercent);
            pstmt.setTimestamp(2, promotionStart);
            pstmt.setTimestamp(3, promotionEnd);
            pstmt.setInt(4, experienceId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating promotion for experience ID: " + experienceId, e);
            throw e;
        }
    }
}