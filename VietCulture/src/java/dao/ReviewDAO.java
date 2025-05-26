package dao;

import model.Review;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());
    
    /**
     * Get average rating across all experiences and accommodations
     */
    public double getAverageRating() throws SQLException {
        String sql = """
            SELECT AVG(CAST(rating as FLOAT)) as avgRating
            FROM Reviews 
            WHERE isVisible = 1
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("avgRating");
            }
        }
        return 0.0;
    }
    
    /**
     * Get recent reviews for admin dashboard
     */
    public List<Review> getRecentReviews(int limit) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        
        String sql = """
            SELECT TOP(?) r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.isVisible = 1
            ORDER BY r.createdAt DESC
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
        }
        return reviews;
    }
    
    /**
     * Map ResultSet to Review object
     */
    private Review mapReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("reviewId"));
        review.setExperienceId(rs.getObject("experienceId") != null ? rs.getInt("experienceId") : null);
        review.setAccommodationId(rs.getObject("accommodationId") != null ? rs.getInt("accommodationId") : null);
        review.setTravelerId(rs.getInt("travelerId"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setPhotos(rs.getString("photos"));
        review.setCreatedAt(rs.getDate("createdAt"));
        review.setVisible(rs.getBoolean("isVisible"));
        
        // Set additional info
        if (rs.getString("travelerName") != null) {
            review.setTravelerName(rs.getString("travelerName"));
            review.setTravelerAvatar(rs.getString("travelerAvatar"));
        }
        if (rs.getString("experienceName") != null) {
            review.setExperienceName(rs.getString("experienceName"));
        }
        if (rs.getString("accommodationName") != null) {
            review.setAccommodationName(rs.getString("accommodationName"));
        }
        
        return review;
    }

    public boolean softDeleteReview(int contentId, String trim) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean restoreReview(int contentId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean permanentDeleteReview(int contentId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}