package dao;

import model.Favorite;
import model.Experience;
import model.Accommodation;
import utils.DBUtils;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class FavoriteDAO {
    private static final Logger LOGGER = Logger.getLogger(FavoriteDAO.class.getName());

    // Add favorite
 public boolean addFavorite(Integer userId, Integer experienceId, Integer accommodationId) {
    // Debug logs
    System.out.println("=== DEBUG addFavorite ===");
    System.out.println("userId: " + userId);
    System.out.println("experienceId: " + experienceId);
    System.out.println("accommodationId: " + accommodationId);
    
    // Validate input
    if (userId == null) {
        System.err.println("ERROR: userId cannot be null");
        return false;
    }
    
    if ((experienceId == null && accommodationId == null) || 
        (experienceId != null && accommodationId != null)) {
        System.err.println("ERROR: Exactly one of experienceId or accommodationId must be provided");
        return false;
    }
    
    // Test connection first
    try (Connection testConn = DBUtils.getConnection()) {
        if (testConn == null) {
            System.err.println("ERROR: Database connection is null!");
            return false;
        }
        System.out.println("Database connection successful");
    } catch (SQLException e) {
        System.err.println("ERROR: Cannot connect to database: " + e.getMessage());
        return false;
    }
    
    // First check if the favorite already exists
    if (isFavorited(userId, experienceId, accommodationId)) {
        System.out.println("Already favorited, returning true");
        return true;
    }
    
    String sql = "INSERT INTO Favorites (userId, experienceId, accommodationId) VALUES (?, ?, ?)";
    System.out.println("Executing SQL: " + sql);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        
        // Handle NULL values properly
        if (experienceId != null) {
            ps.setInt(2, experienceId);
            ps.setNull(3, java.sql.Types.INTEGER);
        } else {
            ps.setNull(2, java.sql.Types.INTEGER);
            ps.setInt(3, accommodationId);
        }
        
        System.out.println("Parameters set: userId=" + userId + 
                          ", experienceId=" + experienceId + 
                          ", accommodationId=" + accommodationId);
        
        int rowsAffected = ps.executeUpdate();
        System.out.println("Rows affected: " + rowsAffected);
        
        boolean success = rowsAffected > 0;
        System.out.println("Insert successful: " + success);
        return success;
        
    } catch (SQLException e) {
        System.err.println("SQL Error details:");
        System.err.println("SQL State: " + e.getSQLState());
        System.err.println("Error Code: " + e.getErrorCode());
        System.err.println("Message: " + e.getMessage());
        
        // Check for specific error codes
        if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) { // Unique constraint violation
            System.out.println("Unique constraint violation - item already favorited, returning true");
            return true;
        }
        
        return false;
    }
}
    
    // Remove favorite by ID
    public boolean removeFavorite(Integer favoriteId) {
        String sql = "DELETE FROM Favorites WHERE favoriteId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, favoriteId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing favorite", e);
            return false;
        }
    }
    
    // Remove favorite by user and item
public boolean removeFavoriteByUserAndItem(Integer userId, Integer experienceId, Integer accommodationId) {
    String sql;
    
    if (experienceId != null) {
        sql = "DELETE FROM Favorites WHERE userId = ? AND experienceId = ?";
    } else if (accommodationId != null) {
        sql = "DELETE FROM Favorites WHERE userId = ? AND accommodationId = ?";
    } else {
        return false; // Neither experienceId nor accommodationId provided
    }
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        if (experienceId != null) {
            ps.setInt(2, experienceId);
        } else {
            ps.setInt(2, accommodationId);
        }
        
        return ps.executeUpdate() > 0;
        
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error removing favorite by user and item", e);
        return false;
    }
}    
    // Check if item is favorited
// THAY THẾ method isFavorited hiện tại trong FavoriteDAO.java
// Tìm method này trong file paste-2.txt (FavoriteDAO) và thay thế toàn bộ

public boolean isFavorited(Integer userId, Integer experienceId, Integer accommodationId) {
    System.out.println("=== DEBUG isFavorited ===");
    System.out.println("userId: " + userId);
    System.out.println("experienceId: " + experienceId);
    System.out.println("accommodationId: " + accommodationId);
    
    // Validate input
    if (userId == null) {
        System.err.println("ERROR: userId cannot be null");
        return false;
    }
    
    if ((experienceId == null && accommodationId == null) || 
        (experienceId != null && accommodationId != null)) {
        System.err.println("ERROR: Exactly one of experienceId or accommodationId must be provided");
        return false;
    }
    
    String sql;
    
    if (experienceId != null) {
        sql = "SELECT COUNT(*) FROM Favorites WHERE userId = ? AND experienceId = ? AND accommodationId IS NULL";
        System.out.println("Checking for experience favorite");
    } else {
        sql = "SELECT COUNT(*) FROM Favorites WHERE userId = ? AND accommodationId = ? AND experienceId IS NULL";
        System.out.println("Checking for accommodation favorite");
    }
    
    System.out.println("SQL: " + sql);
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        
        if (experienceId != null) {
            ps.setInt(2, experienceId);
        } else {
            ps.setInt(2, accommodationId);
        }
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            int count = rs.getInt(1);
            System.out.println("Count found: " + count);
            boolean isFavorited = count > 0;
            System.out.println("Is favorited: " + isFavorited);
            return isFavorited;
        }
        
    } catch (SQLException e) {
        System.err.println("Error in isFavorited: " + e.getMessage());
        e.printStackTrace();
    }
    
    System.out.println("Returning false (default)");
    return false;
}
    public List<Favorite> getFavoritesByUser(Integer userId) {
        String sql = """
            SELECT f.favoriteId, f.userId, f.experienceId, f.accommodationId, f.createdAt,
                   -- Experience data
                   e.experienceId, e.title as experience_title, e.description as experience_description,
                   e.price as experience_price, e.images as experience_images,
                   e.type as experience_type, e.difficulty, e.maxGroupSize, e.duration,
                   e.averageRating as experience_rating, e.totalBookings as experience_bookings,
                   e.location as experience_location,
                   -- Accommodation data
                   a.accommodationId, a.name as accommodation_name, a.description as accommodation_description,
                   a.pricePerNight, a.images as accommodation_images, a.type as accommodation_type,
                   a.numberOfRooms, a.amenities, a.averageRating as accommodation_rating,
                   a.totalBookings as accommodation_bookings, a.address as accommodation_address,
                   -- City and Host info
                   ec.vietnameseName as experience_city, ac.vietnameseName as accommodation_city,
                   eh.fullName as experience_host, ah.fullName as accommodation_host
            FROM Favorites f
            LEFT JOIN Experiences e ON f.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON f.accommodationId = a.accommodationId
            LEFT JOIN Cities ec ON e.cityId = ec.cityId
            LEFT JOIN Cities ac ON a.cityId = ac.cityId
            LEFT JOIN Users eh ON e.hostId = eh.userId
            LEFT JOIN Users ah ON a.hostId = ah.userId
            WHERE f.userId = ?
            ORDER BY f.createdAt DESC
        """;
        
        List<Favorite> favorites = new ArrayList<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Favorite favorite = new Favorite();
                favorite.setFavoriteId(rs.getInt("favoriteId"));
                favorite.setUserId(rs.getInt("userId"));
                favorite.setExperienceId((Integer) rs.getObject("experienceId"));
                favorite.setAccommodationId((Integer) rs.getObject("accommodationId"));
                
                // Convert SQL Timestamp to LocalDateTime
                Timestamp timestamp = rs.getTimestamp("createdAt");
                if (timestamp != null) {
                    favorite.setCreatedAt(timestamp.toLocalDateTime());
                }
                
                // Set type and create related objects
                if (favorite.getExperienceId() != null) {
                    favorite.setType("experience");
                    
                    // Create Experience object using existing structure
                    Experience experience = new Experience();
                    experience.setExperienceId(favorite.getExperienceId());
                    experience.setTitle(rs.getString("experience_title"));
                    experience.setDescription(rs.getString("experience_description"));
                    experience.setPrice(rs.getDouble("experience_price"));
                    experience.setImages(rs.getString("experience_images"));
                    experience.setType(rs.getString("experience_type"));
                    experience.setDifficulty(rs.getString("difficulty"));
                    experience.setMaxGroupSize(rs.getInt("maxGroupSize"));
                    experience.setLocation(rs.getString("experience_location"));
                    
                    // Handle duration (Time to Date conversion)
                    Time duration = rs.getTime("duration");
                    if (duration != null) {
                        experience.setDuration(new java.util.Date(duration.getTime()));
                    }
                    
                    experience.setAverageRating(rs.getDouble("experience_rating"));
                    experience.setTotalBookings(rs.getInt("experience_bookings"));
                    experience.setCityName(rs.getString("experience_city"));
                    experience.setHostName(rs.getString("experience_host"));
                    
                    favorite.setExperience(experience);
                    
                } else if (favorite.getAccommodationId() != null) {
                    favorite.setType("accommodation");
                    
                    // Create Accommodation object using existing structure
                    Accommodation accommodation = new Accommodation();
                    accommodation.setAccommodationId(favorite.getAccommodationId());
                    accommodation.setName(rs.getString("accommodation_name"));
                    accommodation.setDescription(rs.getString("accommodation_description"));
                    accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
                    accommodation.setImages(rs.getString("accommodation_images"));
                    accommodation.setType(rs.getString("accommodation_type"));
                    accommodation.setNumberOfRooms(rs.getInt("numberOfRooms"));
                    accommodation.setAmenities(rs.getString("amenities"));
                    accommodation.setAddress(rs.getString("accommodation_address"));
                    accommodation.setAverageRating(rs.getDouble("accommodation_rating"));
                    accommodation.setTotalBookings(rs.getInt("accommodation_bookings"));
                    accommodation.setCityName(rs.getString("accommodation_city"));
                    accommodation.setHostName(rs.getString("accommodation_host"));
                    
                    favorite.setAccommodation(accommodation);
                }
                
                favorites.add(favorite);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting favorites by user", e);
        }
        
        return favorites;
    }
    
    // Get favorite counts
    public int[] getFavoriteCounts(Integer userId) {
        String sql = """
            SELECT 
                COUNT(*) as totalCount,
                COUNT(experienceId) as experienceCount,
                COUNT(accommodationId) as accommodationCount
            FROM Favorites 
            WHERE userId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new int[]{
                    rs.getInt("totalCount"),
                    rs.getInt("experienceCount"), 
                    rs.getInt("accommodationCount")
                };
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting favorite counts", e);
        }
        
        return new int[]{0, 0, 0}; // [total, experience, accommodation]
    }
    
    // Get experience favorites only
    public List<Favorite> getExperienceFavoritesByUser(Integer userId) {
        List<Favorite> allFavorites = getFavoritesByUser(userId);
        return allFavorites.stream()
                .filter(f -> "experience".equals(f.getType()))
                .toList();
    }
    
    // Get accommodation favorites only
    public List<Favorite> getAccommodationFavoritesByUser(Integer userId) {
        List<Favorite> allFavorites = getFavoritesByUser(userId);
        return allFavorites.stream()
                .filter(f -> "accommodation".equals(f.getType()))
                .toList();
    }
    
    // Get favorite by user and item (for security check)
    public Favorite getFavoriteByUserAndItem(Integer userId, Integer experienceId, Integer accommodationId) {
        String sql;
        
        if (experienceId != null) {
            sql = """
                SELECT f.*, 
                e.title as experience_title, e.description as experience_description,
                e.price as experience_price, e.images as experience_images,
                e.type as experience_type, e.difficulty, e.maxGroupSize, e.duration,
                e.averageRating as experience_rating, e.totalBookings as experience_bookings,
                e.location as experience_location,
                ec.vietnameseName as experience_city, eh.fullName as experience_host
                FROM Favorites f
                LEFT JOIN Experiences e ON f.experienceId = e.experienceId
                LEFT JOIN Cities ec ON e.cityId = ec.cityId
                LEFT JOIN Users eh ON e.hostId = eh.userId
                WHERE f.userId = ? AND f.experienceId = ?
            """;
        } else if (accommodationId != null) {
            sql = """
                SELECT f.*,
                a.name as accommodation_name, a.description as accommodation_description,
                a.pricePerNight, a.images as accommodation_images, a.type as accommodation_type,
                a.numberOfRooms, a.amenities, a.averageRating as accommodation_rating,
                a.totalBookings as accommodation_bookings, a.address as accommodation_address,
                ac.vietnameseName as accommodation_city, ah.fullName as accommodation_host
                FROM Favorites f
                LEFT JOIN Accommodations a ON f.accommodationId = a.accommodationId
                LEFT JOIN Cities ac ON a.cityId = ac.cityId
                LEFT JOIN Users ah ON a.hostId = ah.userId
                WHERE f.userId = ? AND f.accommodationId = ?
            """;
        } else {
            return null; // Neither experienceId nor accommodationId provided
        }
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            if (experienceId != null) {
                ps.setInt(2, experienceId);
            } else {
                ps.setInt(2, accommodationId);
            }
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Favorite favorite = new Favorite();
                favorite.setFavoriteId(rs.getInt("favoriteId"));
                favorite.setUserId(rs.getInt("userId"));
                favorite.setExperienceId((Integer) rs.getObject("experienceId"));
                favorite.setAccommodationId((Integer) rs.getObject("accommodationId"));
                
                // Convert SQL Timestamp to LocalDateTime
                Timestamp timestamp = rs.getTimestamp("createdAt");
                if (timestamp != null) {
                    favorite.setCreatedAt(timestamp.toLocalDateTime());
                }
                
                // Set type
                if (favorite.getExperienceId() != null) {
                    favorite.setType("experience");
                    
                    // Create Experience object
                    if (experienceId != null) {
                        Experience experience = new Experience();
                        experience.setExperienceId(favorite.getExperienceId());
                        experience.setTitle(rs.getString("experience_title"));
                        experience.setDescription(rs.getString("experience_description"));
                        experience.setPrice(rs.getDouble("experience_price"));
                        experience.setImages(rs.getString("experience_images"));
                        experience.setType(rs.getString("experience_type"));
                        experience.setDifficulty(rs.getString("difficulty"));
                        experience.setMaxGroupSize(rs.getInt("maxGroupSize"));
                        experience.setLocation(rs.getString("experience_location"));
                        
                        // Handle duration (Time to Date conversion)
                        Time duration = rs.getTime("duration");
                        if (duration != null) {
                            experience.setDuration(new java.util.Date(duration.getTime()));
                        }
                        
                        experience.setAverageRating(rs.getDouble("experience_rating"));
                        experience.setTotalBookings(rs.getInt("experience_bookings"));
                        experience.setCityName(rs.getString("experience_city"));
                        experience.setHostName(rs.getString("experience_host"));
                        
                        favorite.setExperience(experience);
                    }
                } else if (favorite.getAccommodationId() != null) {
                    favorite.setType("accommodation");
                    
                    // Create Accommodation object
                    if (accommodationId != null) {
                        Accommodation accommodation = new Accommodation();
                        accommodation.setAccommodationId(favorite.getAccommodationId());
                        accommodation.setName(rs.getString("accommodation_name"));
                        accommodation.setDescription(rs.getString("accommodation_description"));
                        accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
                        accommodation.setImages(rs.getString("accommodation_images"));
                        accommodation.setType(rs.getString("accommodation_type"));
                        accommodation.setNumberOfRooms(rs.getInt("numberOfRooms"));
                        accommodation.setAmenities(rs.getString("amenities"));
                        accommodation.setAddress(rs.getString("accommodation_address"));
                        accommodation.setAverageRating(rs.getDouble("accommodation_rating"));
                        accommodation.setTotalBookings(rs.getInt("accommodation_bookings"));
                        accommodation.setCityName(rs.getString("accommodation_city"));
                        accommodation.setHostName(rs.getString("accommodation_host"));
                        
                        favorite.setAccommodation(accommodation);
                    }
                }
                
                return favorite;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking favorite by user and item", e);
        }
        
        return null;
    }
}