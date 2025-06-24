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
 * Lớp DAO xử lý các thao tác với bảng Experiences trong cơ sở dữ liệu
 */
public class ExperienceDAO {

    private static final Logger LOGGER = Logger.getLogger(ExperienceDAO.class.getName());

    /**
     * Lấy tổng số trải nghiệm theo host
     */
    public int getTotalExperiencesByHost(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE hostId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm theo host với phân trang
     */
    public List<Experience> getExperiencesByHost(int hostId, int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.hostId = ?
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy trải nghiệm theo ID
     */
    public Experience getExperienceById(int experienceId) throws SQLException {
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.experienceId = ?
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapExperienceFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Tạo trải nghiệm mới
     */
    public int createExperience(Experience experience) throws SQLException {
        String sql = """
            INSERT INTO Experiences (hostId, title, description, location, cityId, type,
                                   price, maxGroupSize, duration, difficulty, language,
                                   includedItems, requirements, images, isActive)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
            ps.setBoolean(15, experience.isActive());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int experienceId = generatedKeys.getInt(1);
                        experience.setExperienceId(experienceId);
                        return experienceId;
                    }
                }
            }
        }
        return 0;
    }

    /**
     * Cập nhật thông tin trải nghiệm
     */
    public boolean updateExperience(Experience experience) throws SQLException {
        String sql = """
            UPDATE Experiences 
            SET title = ?, description = ?, location = ?, cityId = ?, type = ?,
                price = ?, maxGroupSize = ?, duration = ?, difficulty = ?, language = ?,
                includedItems = ?, requirements = ?, images = ?, isActive = ?
            WHERE experienceId = ?
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
            ps.setBoolean(14, experience.isActive());
            ps.setInt(15, experience.getExperienceId());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật trạng thái hoạt động của trải nghiệm
     */
    public boolean updateExperienceStatus(int experienceId, boolean isActive) throws SQLException {
        String sql = "UPDATE Experiences SET isActive = ? WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, experienceId);
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Cập nhật trạng thái trải nghiệm: " + experienceId + " -> " + isActive);
            return rowsAffected > 0;
        }
    }

    /**
     * Lấy tất cả trải nghiệm đang hoạt động với phân trang
     */
    public List<Experience> getAllActiveExperiences(int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Tìm kiếm trải nghiệm với bộ lọc
     */
    public List<Experience> searchExperiences(String keyword, Integer cityId, String type,
            int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1
        """);
        List<Object> parameters = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        if (cityId != null) {
            sqlBuilder.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (type != null && !type.trim().isEmpty()) {
            sqlBuilder.append(" AND e.type = ?");
            parameters.add(type);
        }
        sqlBuilder.append(" ORDER BY e.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Tìm kiếm trải nghiệm với bộ lọc nâng cao (hỗ trợ ExperiencesServlet)
     */
    public List<Experience> searchExperiences(Integer categoryId, Integer regionId, Integer cityId,
            String search, String sort, int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE e.isActive = 1
        """);
        List<Object> parameters = new ArrayList<>();

        if (categoryId != null) {
            sqlBuilder.append(" AND e.type = (SELECT name FROM Categories WHERE categoryId = ?)");
            parameters.add(categoryId);
        }
        if (regionId != null) {
            sqlBuilder.append(" AND c.regionId = ?");
            parameters.add(regionId);
        }
        if (cityId != null) {
            sqlBuilder.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sqlBuilder.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Apply sorting
        if ("price-asc".equals(sort)) {
            sqlBuilder.append(" ORDER BY e.price ASC");
        } else if ("price-desc".equals(sort)) {
            sqlBuilder.append(" ORDER BY e.price DESC");
        } else if ("rating-desc".equals(sort)) {
            sqlBuilder.append(" ORDER BY e.averageRating DESC");
        } else {
            sqlBuilder.append(" ORDER BY e.createdAt DESC");
        }

        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy tổng số trải nghiệm theo bộ lọc (hỗ trợ ExperiencesServlet)
     */
    public int getFilteredExperiencesCount(Integer categoryId, Integer regionId, Integer cityId,
            String search) throws SQLException {
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT COUNT(*)
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE e.isActive = 1
        """);
        List<Object> parameters = new ArrayList<>();

        if (categoryId != null) {
            sqlBuilder.append(" AND e.type = (SELECT name FROM Categories WHERE categoryId = ?)");
            parameters.add(categoryId);
        }
        if (regionId != null) {
            sqlBuilder.append(" AND c.regionId = ?");
            parameters.add(regionId);
        }
        if (cityId != null) {
            sqlBuilder.append(" AND e.cityId = ?");
            parameters.add(cityId);
        }
        if (search != null && !search.trim().isEmpty()) {
            sqlBuilder.append(" AND (e.title LIKE ? OR e.description LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
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
     * Lấy danh sách trải nghiệm phổ biến
     */
    public List<Experience> getPopularExperiences(int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1
            ORDER BY e.totalBookings DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số lượng trải nghiệm phổ biến
     */
    public int getPopularExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 1";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm mới nhất
     */
    public List<Experience> getNewestExperiences(int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số lượng trải nghiệm mới nhất
     */
    public int getNewestExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 1";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm được đánh giá cao nhất
     */
    public List<Experience> getTopRatedExperiences(int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1 AND e.averageRating IS NOT NULL
            ORDER BY e.averageRating DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số lượng trải nghiệm được đánh giá cao nhất
     */
    public int getTopRatedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 1 AND averageRating IS NOT NULL";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm giá thấp nhất
     */
    public List<Experience> getLowPriceExperiences(int offset, int limit) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1
            ORDER BY e.price ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience experience = mapExperienceFromResultSet(rs);
                    experiences.add(experience);
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số lượng trải nghiệm giá thấp nhất
     */
    public int getLowPriceExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 1";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Cập nhật điểm đánh giá trung bình
     */
    public boolean updateExperienceRating(int experienceId, double averageRating) throws SQLException {
        String sql = "UPDATE Experiences SET averageRating = ? WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, averageRating);
            ps.setInt(2, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tăng số lượt đặt
     */
    public boolean incrementTotalBookings(int experienceId) throws SQLException {
        String sql = "UPDATE Experiences SET totalBookings = totalBookings + 1 WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy tổng số trải nghiệm
     */
    public int getTotalExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy số trải nghiệm đang chờ duyệt
     */
    public int getPendingExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 0";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy số trải nghiệm đã được duyệt
     */
    public int getApprovedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 1";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy số trải nghiệm bị từ chối (giả định có bảng riêng)
     */
    public int getRejectedExperiencesCount() throws SQLException {
        // Giả định chưa có bảng từ chối, trả về 0
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm đang chờ duyệt
     */
    public List<Experience> getPendingExperiences(int page, int pageSize) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 0
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapExperienceFromResultSet(rs));
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy danh sách trải nghiệm đã được duyệt
     */
    public List<Experience> getApprovedExperiences(int page, int pageSize) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isActive = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapExperienceFromResultSet(rs));
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy danh sách trải nghiệm bị từ chối
     */
    public List<Experience> getRejectedExperiences(int page, int pageSize) throws SQLException {
        // Giả định chưa có bảng từ chối, trả về danh sách rỗng
        return new ArrayList<>();
    }

    /**
     * Lấy tất cả trải nghiệm
     */
    public List<Experience> getAllExperiences(int page, int pageSize) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapExperienceFromResultSet(rs));
                }
            }
        }
        return experiences;
    }

    /**
     * Duyệt trải nghiệm
     */
    public boolean approveExperience(int experienceId) throws SQLException {
        String sql = "UPDATE Experiences SET isActive = 1 WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Từ chối trải nghiệm
     */
    public boolean rejectExperience(int experienceId, String reason, boolean allowResubmit) throws SQLException {
        String sql = "UPDATE Experiences SET isActive = 0, rejectionReason = ? WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Thu hồi duyệt trải nghiệm
     */
    public boolean revokeApproval(int experienceId, String reason) throws SQLException {
        String sql = "UPDATE Experiences SET isActive = 0 WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            if (ps.executeUpdate() > 0) {
                logExperienceAction(experienceId, "REVOKED", reason);
                return true;
            }
        }
        return false;
    }

    /**
     * Xóa mềm trải nghiệm
     */
    public boolean softDeleteExperience(int contentId, String reason) throws SQLException {
        String sql = "UPDATE Experiences SET isDeleted = 1, deleteReason = ?, deletedAt = GETDATE() WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, contentId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Khôi phục trải nghiệm
     */
    public boolean restoreExperience(int contentId) throws SQLException {
        String sql = "UPDATE Experiences SET isDeleted = 0, deleteReason = NULL, deletedAt = NULL WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, contentId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy số trải nghiệm đang hoạt động
     */
    public int getActiveExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isActive = 1 AND isDeleted = 0";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm đã bị xóa
     */
    public List<Experience> getDeletedExperiences(int page, int pageSize) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isDeleted = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapExperienceFromResultSet(rs));
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số trải nghiệm đã bị xóa
     */
    public int getDeletedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isDeleted = 1";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm bị báo cáo
     */
    public List<Experience> getReportedExperiences(int page, int pageSize) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.reportCount > 0
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapExperienceFromResultSet(rs));
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số trải nghiệm bị báo cáo
     */
    public int getReportedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE reportCount > 0";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách trải nghiệm bị đánh dấu
     */
    public List<Experience> getFlaggedExperiences(int page, int pageSize) throws SQLException {
        List<Experience> experiences = new ArrayList<>();
        String sql = """
            SELECT e.experienceId, e.hostId, e.title, e.description, e.location,
                   e.cityId, e.type, e.price, e.maxGroupSize, e.duration,
                   e.difficulty, e.language, e.includedItems, e.requirements,
                   e.createdAt, e.isActive, e.images, e.averageRating, e.totalBookings,
                   c.vietnameseName as cityName, u.fullName as hostName
            FROM Experiences e
            LEFT JOIN Cities c ON e.cityId = c.cityId
            LEFT JOIN Users u ON e.hostId = u.userId
            WHERE e.isFlagged = 1
            ORDER BY e.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiences.add(mapExperienceFromResultSet(rs));
                }
            }
        }
        return experiences;
    }

    /**
     * Lấy số trải nghiệm bị đánh dấu
     */
    public int getFlaggedExperiencesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE isFlagged = 1";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Xóa vĩnh viễn trải nghiệm
     */
    public boolean deleteExperience(int experienceId) throws SQLException {
        String sql = "DELETE FROM Experiences WHERE experienceId = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Thống kê số lượng trải nghiệm theo vùng
     */
    public Map<String, Integer> getExperiencesByRegion() throws SQLException {
        Map<String, Integer> regionCounts = new HashMap<>();
        String sql = """
            SELECT r.name as regionName, COUNT(e.experienceId) as count
            FROM Experiences e
            JOIN Cities c ON e.cityId = c.cityId
            JOIN Regions r ON c.regionId = r.regionId
            WHERE e.isActive = 1
            GROUP BY r.name
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                regionCounts.put(rs.getString("regionName"), rs.getInt("count"));
            }
        }
        return regionCounts;
    }

    /**
     * Lấy dữ liệu tăng trưởng hàng tháng
     */
    public List<Integer> getMonthlyGrowthData(int months) throws SQLException {
        List<Integer> data = new ArrayList<>();
        String sql = """
            SELECT COUNT(*) as count
            FROM Experiences 
            WHERE createdAt >= DATEADD(MONTH, ?, GETDATE())
            AND createdAt < DATEADD(MONTH, ?, GETDATE())
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
     * Tính tỷ lệ tăng trưởng
     */
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
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
     * Ghi log hành động trên trải nghiệm
     */
    private void logExperienceAction(int experienceId, String action, String details) throws SQLException {
        String sql = """
            INSERT INTO ExperienceActions (experienceId, action, details, createdAt)
            VALUES (?, ?, ?, GETDATE())
        """;
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, experienceId);
            ps.setString(2, action);
            ps.setString(3, details);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể ghi log hành động trải nghiệm", e);
        }
    }

    /**
     * Ánh xạ ResultSet sang đối tượng Experience
     */
    private Experience mapExperienceFromResultSet(ResultSet rs) throws SQLException {
        Experience experience = new Experience();
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
        if (rs.getString("cityName") != null) {
            experience.setCityName(rs.getString("cityName"));
        }
        if (rs.getString("hostName") != null) {
            experience.setHostName(rs.getString("hostName"));
        }
        return experience;
    }

    public boolean rejectExperience(int contentId, String reason) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean flagExperience(int contentId, String reason) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean unflagExperience(int contentId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
