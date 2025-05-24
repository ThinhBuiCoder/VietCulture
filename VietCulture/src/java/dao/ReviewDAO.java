package dao;

import model.Review;
import model.Experience;
import model.Accommodation;
import model.User;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());
    
    /**
     * Get recent reviews (for homepage)
     */
    public List<Review> getRecentReviews(int limit) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.rating, r.comment, 
                   r.photos, r.createdAt,
                   u.userId, u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.experienceId as expId, e.title as experienceTitle,
                   a.accommodationId as accId, a.name as accommodationName
            FROM Reviews r
            INNER JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.isVisible = 1 AND r.comment IS NOT NULL AND r.comment != ''
            ORDER BY r.createdAt DESC
            OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
            
            LOGGER.info("Retrieved " + reviews.size() + " recent reviews");
        }
        return reviews;
    }
    
    /**
     * Get reviews by experience ID
     */
    public List<Review> getReviewsByExperienceId(int experienceId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.rating, r.comment, 
                   r.photos, r.createdAt,
                   u.userId, u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.experienceId as expId, e.title as experienceTitle
            FROM Reviews r
            INNER JOIN Users u ON r.travelerId = u.userId
            INNER JOIN Experiences e ON r.experienceId = e.experienceId
            WHERE r.experienceId = ? AND r.isVisible = 1
            ORDER BY r.createdAt DESC
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapReviewFromResultSet(rs));
                }
            }
        }
        return reviews;
    }
    
    /**
     * Get reviews by accommodation ID
     */
    public List<Review> getReviewsByAccommodationId(int accommodationId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.rating, r.comment, 
                   r.photos, r.createdAt,
                   u.userId, u.fullName as travelerName, u.avatar as travelerAvatar,
                   a.accommodationId as accId, a.name as accommodationName
            FROM Reviews r
            INNER JOIN Users u ON r.travelerId = u.userId
            INNER JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.accommodationId = ? AND r.isVisible = 1
            ORDER BY r.createdAt DESC
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapReviewFromResultSet(rs));
                }
            }
        }
        return reviews;
    }
    
    /**
     * Get review by ID
     */
    public Review getReviewById(int reviewId) throws SQLException {
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId, r.rating, 
                   r.comment, r.photos, r.createdAt, r.isVisible,
                   u.userId, u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.experienceId as expId, e.title as experienceTitle,
                   a.accommodationId as accId, a.name as accommodationName
            FROM Reviews r
            INNER JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.reviewId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapReviewFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Create new review
     */
    public int createReview(Review review) throws SQLException {
        String sql = """
            INSERT INTO Reviews (experienceId, accommodationId, travelerId, rating, comment, photos)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setObject(1, review.getExperienceId());
            ps.setObject(2, review.getAccommodationId());
            ps.setInt(3, review.getTravelerId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            ps.setString(6, review.getPhotos());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int reviewId = generatedKeys.getInt(1);
                        review.setReviewId(reviewId);
                        return reviewId;
                    }
                }
            }
        }
        return 0;
    }
    
    /**
     * Update review
     */
    public boolean updateReview(Review review) throws SQLException {
        String sql = """
            UPDATE Reviews 
            SET rating = ?, comment = ?, photos = ?, isVisible = ?
            WHERE reviewId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, review.getRating());
            ps.setString(2, review.getComment());
            ps.setString(3, review.getPhotos());
            ps.setBoolean(4, review.isVisible());
            ps.setInt(5, review.getReviewId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete review
     */
    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM Reviews WHERE reviewId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Get average rating for experience
     */
    public double getAverageRatingForExperience(int experienceId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) as avgRating FROM Reviews WHERE experienceId = ? AND isVisible = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, experienceId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avgRating");
                }
            }
        }
        return 0.0;
    }
    
    /**
     * Get average rating for accommodation
     */
    public double getAverageRatingForAccommodation(int accommodationId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) as avgRating FROM Reviews WHERE accommodationId = ? AND isVisible = 1";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avgRating");
                }
            }
        }
        return 0.0;
    }
    
    /**
     * Map ResultSet to Review object
     */
    private Review mapReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("reviewId"));
        review.setExperienceId((Integer) rs.getObject("experienceId"));
        review.setAccommodationId((Integer) rs.getObject("accommodationId"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setPhotos(rs.getString("photos"));
        review.setCreatedAt(rs.getDate("createdAt"));
        
        // Map Traveler
        User traveler = new User();
        traveler.setUserId(rs.getInt("userId"));
        traveler.setFullName(rs.getString("travelerName"));
        traveler.setAvatar(rs.getString("travelerAvatar"));
        review.setTraveler(traveler);
        
        // Map Experience if exists
        if (rs.getObject("expId") != null) {
            Experience experience = new Experience();
            experience.setExperienceId(rs.getInt("expId"));
            experience.setTitle(rs.getString("experienceTitle"));
            review.setExperience(experience);
        }
        
        // Map Accommodation if exists
        if (rs.getObject("accId") != null) {
            Accommodation accommodation = new Accommodation();
            accommodation.setAccommodationId(rs.getInt("accId"));
            accommodation.setName(rs.getString("accommodationName"));
            review.setAccommodation(accommodation);
        }
        
        return review;
    }
}