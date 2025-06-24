package dao;

import model.Review;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Lớp DAO để xử lý các thao tác với bảng Reviews trong cơ sở dữ liệu
 */
public class ReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());

    /**
     * Lấy điểm đánh giá trung bình của tất cả các review hiển thị
     */
    public double getAverageRating() throws SQLException {
        String sql = """
            SELECT AVG(CAST(rating AS FLOAT)) as avgRating
            FROM Reviews 
            WHERE isVisible = 1
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("avgRating");
            }
        }
        return 0.0;
    }

    /**
     * Lấy danh sách các review gần đây cho bảng điều khiển admin
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
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    /**
     * Xóa mềm một review
     */
    public boolean softDeleteReview(int reviewId, String reason) throws SQLException {
        String sql = "UPDATE Reviews SET isVisible = 0, deleteReason = ?, deletedAt = GETDATE() WHERE reviewId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, reason);
            pstmt.setInt(2, reviewId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                logReviewAction(reviewId, "SOFT_DELETED", reason);
                return true;
            }
            return false;
        }
    }

    /**
     * Khôi phục một review đã bị xóa mềm
     */
    public boolean restoreReview(int reviewId) throws SQLException {
        String sql = "UPDATE Reviews SET isVisible = 1, deleteReason = NULL, deletedAt = NULL WHERE reviewId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                logReviewAction(reviewId, "RESTORED", "Khôi phục review");
                return true;
            }
            return false;
        }
    }

    /**
     * Xóa vĩnh viễn một review
     */
    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM Reviews WHERE reviewId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                logReviewAction(reviewId, "DELETED", "Xóa vĩnh viễn review");
                return true;
            }
            return false;
        }
    }

    /**
     * Lấy danh sách review bị báo cáo
     */
    public List<Review> getReportedReviews(int page, int pageSize) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.reportCount > 0
            ORDER BY r.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    /**
     * Lấy số lượng review bị báo cáo
     */
    public int getReportedReviewsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE reportCount > 0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách review bị đánh dấu
     */
    public List<Review> getFlaggedReviews(int page, int pageSize) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.isFlagged = 1
            ORDER BY r.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    /**
     * Lấy số lượng review bị đánh dấu
     */
    public int getFlaggedReviewsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE isFlagged = 1";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách review đang chờ duyệt
     */
    public List<Review> getPendingReviews(int page, int pageSize) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.isVisible = 0 AND r.isDeleted = 0
            ORDER BY r.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    /**
     * Lấy số lượng review đang chờ duyệt
     */
    public int getPendingReviewsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE isVisible = 0 AND isDeleted = 0";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách review đã bị xóa
     */
    public List<Review> getDeletedReviews(int page, int pageSize) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.isDeleted = 1
            ORDER BY r.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    /**
     * Lấy số lượng review đã bị xóa
     */
    public int getDeletedReviewsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE isDeleted = 1";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy tất cả review với phân trang
     */
    public List<Review> getAllReviews(int page, int pageSize) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            ORDER BY r.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = mapReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    /**
     * Lấy tổng số review
     */
    public int getTotalReviewsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reviews";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Tạo một review mới
     */
    public int createReview(Review review) throws SQLException {
        String sql = """
            INSERT INTO Reviews (experienceId, accommodationId, travelerId, rating, comment, photos, isVisible)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setObject(1, review.getExperienceId());
            pstmt.setObject(2, review.getAccommodationId());
            pstmt.setInt(3, review.getTravelerId());
            pstmt.setInt(4, review.getRating());
            pstmt.setString(5, review.getComment());
            pstmt.setString(6, review.getPhotos());
            pstmt.setBoolean(7, review.isVisible());
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int reviewId = generatedKeys.getInt(1);
                        review.setReviewId(reviewId);
                        logReviewAction(reviewId, "CREATED", "Tạo review mới");
                        return reviewId;
                    }
                }
            }
        }
        return 0;
    }

    /**
     * Cập nhật thông tin review
     */
    public boolean updateReview(Review review) throws SQLException {
        String sql = """
            UPDATE Reviews 
            SET rating = ?, comment = ?, photos = ?, isVisible = ?
            WHERE reviewId = ?
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, review.getRating());
            pstmt.setString(2, review.getComment());
            pstmt.setString(3, review.getPhotos());
            pstmt.setBoolean(4, review.isVisible());
            pstmt.setInt(5, review.getReviewId());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                logReviewAction(review.getReviewId(), "UPDATED", "Cập nhật review");
                return true;
            }
            return false;
        }
    }

    /**
     * Lấy review theo ID
     */
    public Review getReviewById(int reviewId) throws SQLException {
        String sql = """
            SELECT r.reviewId, r.experienceId, r.accommodationId, r.travelerId,
                   r.rating, r.comment, r.photos, r.createdAt, r.isVisible,
                   u.fullName as travelerName, u.avatar as travelerAvatar,
                   e.title as experienceName,
                   a.name as accommodationName
            FROM Reviews r
            LEFT JOIN Users u ON r.travelerId = u.userId
            LEFT JOIN Experiences e ON r.experienceId = e.experienceId
            LEFT JOIN Accommodations a ON r.accommodationId = a.accommodationId
            WHERE r.reviewId = ?
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapReviewFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Ghi log hành động trên review
     */
    private void logReviewAction(int reviewId, String action, String details) throws SQLException {
        String sql = """
            INSERT INTO ReviewActions (reviewId, action, details, createdAt)
            VALUES (?, ?, ?, GETDATE())
        """;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            pstmt.setString(2, action);
            pstmt.setString(3, details);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể ghi log hành động review: " + reviewId, e);
        }
    }

    /**
     * Ánh xạ ResultSet sang đối tượng Review
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
}