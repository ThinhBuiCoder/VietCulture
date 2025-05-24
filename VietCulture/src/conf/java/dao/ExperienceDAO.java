package dao;

import model.Experience;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class ExperienceDAO {
    private static final Logger LOGGER = Logger.getLogger(ExperienceDAO.class.getName());
    
    /**
     * Get total experiences count by host
     */
    public int getTotalExperiencesByHost(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Experiences WHERE hostId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
     * Get experiences by host with pagination
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
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
     * Get experience by ID
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
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
     * Create new experience
     */
    public int createExperience(Experience experience) throws SQLException {
        String sql = """
            INSERT INTO Experiences (hostId, title, description, location, cityId, type,
                                   price, maxGroupSize, duration, difficulty, language,
                                   includedItems, requirements, images, isActive)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
     * Update experience
     */
    public boolean updateExperience(Experience experience) throws SQLException {
        String sql = """
            UPDATE Experiences 
            SET title = ?, description = ?, location = ?, cityId = ?, type = ?,
                price = ?, maxGroupSize = ?, duration = ?, difficulty = ?, language = ?,
                includedItems = ?, requirements = ?, images = ?, isActive = ?
            WHERE experienceId = ?
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
            ps.setBoolean(14, experience.isActive());
            ps.setInt(15, experience.getExperienceId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Update experience status
     */
    public boolean updateExperienceStatus(int experienceId, boolean isActive) throws SQLException {
        String sql = "UPDATE Experiences SET isActive = ? WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, experienceId);
            
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Experience status updated: " + experienceId + " -> " + isActive);
            return rowsAffected > 0;
        }
    }
    
    /**
     * Get all active experiences with pagination
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
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
     * Search experiences with filters
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
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
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
     * Update experience rating
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
    
    /**
     * Increment total bookings count
     * @param experienceId
     */
    public boolean incrementTotalBookings(int experienceId) throws SQLException {
        String sql = "UPDATE Experiences SET totalBookings = totalBookings + 1 WHERE experienceId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Map ResultSet to Experience object
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
        
        // Set additional info if available
        if (rs.getString("cityName") != null) {
            experience.setCityName(rs.getString("cityName"));
        }
        if (rs.getString("hostName") != null) {
            experience.setHostName(rs.getString("hostName"));
        }
        
        return experience;
    }
}