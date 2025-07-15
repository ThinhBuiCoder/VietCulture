package dao;

import model.Accommodation;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * AccommodationDAO với logic adminApprovalStatus mới
 * adminApprovalStatus: PENDING, APPROVED, REJECTED
 * isActive: 1 (host hiện), 0 (host ẩn)
 * Hiển thị công khai: adminApprovalStatus = 'APPROVED' AND isActive = 1
 */
public class AccommodationDAO {
    private static final Logger LOGGER = Logger.getLogger(AccommodationDAO.class.getName());

    /**
     * Lấy accommodation theo ID
     */
    public Accommodation getAccommodationById(int accommodationId) throws SQLException {
        String sql = """
            SELECT a.accommodationId, a.hostId, a.name, a.description, a.cityId, a.address,
                   a.type, a.numberOfRooms, a.maxOccupancy,a.amenities, a.pricePerNight, a.images,
                   a.createdAt, a.isActive, a.averageRating, a.totalBookings,
                   a.adminApprovalStatus, a.adminApprovedBy, a.adminApprovedAt,
                   a.adminRejectReason, a.adminNotes,
                   a.promotion_percent, a.promotion_start, a.promotion_end,
                   u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.accommodationId = ?
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accommodationId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAccommodationFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting accommodation by ID: " + accommodationId, e);
            return null;
        }
        return null;
    }

    /**
     * Tạo accommodation mới - LOGIC MỚI
     * Accommodation sẽ có adminApprovalStatus = 'PENDING' và isActive = true (host muốn hiện)
     */
    public int createAccommodation(Accommodation accommodation) throws SQLException {
        String sql = """
            INSERT INTO Accommodations (hostId, name, description, cityId, address, type, 
                                       numberOfRooms, maxOccupancy, amenities, pricePerNight, images, 
                                       isActive, adminApprovalStatus, averageRating, totalBookings, promotion_percent, promotion_start, promotion_end)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, accommodation.getHostId());
            ps.setString(2, accommodation.getName());
            ps.setString(3, accommodation.getDescription());
            ps.setInt(4, accommodation.getCityId());
            ps.setString(5, accommodation.getAddress());
            ps.setString(6, accommodation.getType());
            ps.setInt(7, accommodation.getNumberOfRooms());
             ps.setInt(8, accommodation.getMaxOccupancy());
            ps.setString(9, accommodation.getAmenities());
            ps.setDouble(10, accommodation.getPricePerNight());
            ps.setString(11, accommodation.getImages());
            ps.setBoolean(12, accommodation.isActive()); // Host muốn hiện/ẩn
            ps.setString(13, "PENDING"); // Chờ admin duyệt
            ps.setDouble(14, 0.0); // averageRating default
            ps.setInt(15, 0); // totalBookings default
            ps.setInt(16, accommodation.getPromotionPercent());
            ps.setTimestamp(17, accommodation.getPromotionStart());
            ps.setTimestamp(18, accommodation.getPromotionEnd());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int accommodationId = generatedKeys.getInt(1);
                        accommodation.setAccommodationId(accommodationId);
                        
                        LOGGER.info("Accommodation created with ID: " + accommodationId + 
                                   ", adminApprovalStatus: PENDING, isActive: " + accommodation.isActive());
                        return accommodationId;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating accommodation", e);
            throw e;
        }
        return 0;
    }

    /**
     * ADMIN DUYỆT accommodation
     */
    public boolean approveAccommodation(int accommodationId, int adminUserId) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET adminApprovalStatus = 'APPROVED',
                adminApprovedBy = ?,
                adminApprovedAt = GETDATE(),
                adminRejectReason = NULL
            WHERE accommodationId = ? AND adminApprovalStatus = 'PENDING'
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminUserId);
            ps.setInt(2, accommodationId);

            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;

            LOGGER.info("Admin approve accommodation " + accommodationId + ": " + 
                       (success ? "SUCCESS" : "FAILED") + " by admin " + adminUserId);

            return success;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error approving accommodation " + accommodationId, e);
            throw e;
        }
    }

    /**
     * ADMIN TỪ CHỐI accommodation
     */
    public boolean rejectAccommodation(int accommodationId, int adminUserId, String reason) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET adminApprovalStatus = 'REJECTED',
                adminApprovedBy = ?,
                adminApprovedAt = GETDATE(),
                adminRejectReason = ?
            WHERE accommodationId = ? AND adminApprovalStatus IN ('PENDING', 'APPROVED')
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminUserId);
            ps.setString(2, reason);
            ps.setInt(3, accommodationId);

            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;

            LOGGER.info("Admin reject accommodation " + accommodationId + ": " + 
                       (success ? "SUCCESS" : "FAILED") + " - Reason: " + reason);

            return success;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error rejecting accommodation " + accommodationId, e);
            throw e;
        }
    }

    /**
     * ADMIN THU HỒI duyệt accommodation
     */
    public boolean revokeApproval(int accommodationId, int adminUserId, String reason) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET adminApprovalStatus = 'PENDING',
                adminApprovedBy = ?,
                adminApprovedAt = GETDATE(),
                adminRejectReason = ?,
                adminNotes = ?
            WHERE accommodationId = ? AND adminApprovalStatus = 'APPROVED'
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminUserId);
            ps.setString(2, reason);
            ps.setString(3, "Revoked: " + reason);
            ps.setInt(4, accommodationId);

            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;

            LOGGER.info("Admin revoke accommodation " + accommodationId + ": " + 
                       (success ? "SUCCESS" : "FAILED") + " - Reason: " + reason);

            return success;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error revoking accommodation " + accommodationId, e);
            throw e;
        }
    }

    /**
     * Lấy accommodation CHỜ DUYỆT (cho admin)
     */
    public List<Accommodation> getPendingAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'PENDING'
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation CHỜ DUYỆT với type filter
     */
    public List<Accommodation> getPendingAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'PENDING'
        """);

        List<Object> parameters = new ArrayList<>();

        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        sql.append(" ORDER BY a.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    /**
     * Lấy accommodation ĐÃ DUYỆT (cho admin)
     */
    public List<Accommodation> getApprovedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED'
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation ĐÃ DUYỆT với type filter
     */
    public List<Accommodation> getApprovedAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED'
        """);

        List<Object> parameters = new ArrayList<>();

        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        sql.append(" ORDER BY a.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    /**
     * Lấy accommodation BỊ TỪ CHỐI (cho admin)
     */
    public List<Accommodation> getRejectedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'REJECTED'
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy TẤT CẢ accommodation (cho admin)
     */
    public List<Accommodation> getAllAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy TẤT CẢ accommodation với type filter
     */
    public List<Accommodation> getAllAccommodations(int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE 1=1
        """);

        List<Object> parameters = new ArrayList<>();

        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        sql.append(" ORDER BY a.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    /**
     * Lấy accommodation HIỂN THỊ CÔNG KHAI (cho user)
     * Điều kiện: adminApprovalStatus = 'APPROVED' AND isActive = 1
     */
    public List<Accommodation> getPublicAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.vietnameseName as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation ĐÃ DUYỆT NHƯNG ẨN bởi host
     */
    public int getApprovedButHiddenCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'APPROVED' AND isActive = 0";
        return getCount(sql);
    }

    /**
     * Tìm kiếm accommodation nâng cao (chỉ hiển thị công khai)
     */
    public List<Accommodation> searchAccommodations(String type, int regionId, int cityId, 
                                                   String sortBy, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        // Add filters
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        // Add sorting
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "price-asc":
                    sql.append(" ORDER BY a.pricePerNight ASC");
                    break;
                case "price-desc":
                    sql.append(" ORDER BY a.pricePerNight DESC");
                    break;
                case "rating":
                    sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
                    break;
                case "newest":
                    sql.append(" ORDER BY a.createdAt DESC");
                    break;
                default:
                    sql.append(" ORDER BY a.createdAt DESC");
            }
        } else {
            sql.append(" ORDER BY a.createdAt DESC");
        }

        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    /**
     * Đếm kết quả tìm kiếm
     */
    public int getSearchAccommodationsCount(String type, int regionId, int cityId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) 
            FROM Accommodations a
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        return getCountWithParams(sql.toString(), parameters);
    }

    /**
     * Lấy accommodation phổ biến (hiển thị công khai + có booking cao)
     */
    public List<Accommodation> getPopularAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
            AND a.totalBookings >= 5 AND a.averageRating >= 4.0
            ORDER BY a.totalBookings DESC, a.averageRating DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation mới nhất (hiển thị công khai)
     */
    public List<Accommodation> getNewestAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
            ORDER BY a.createdAt DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation được đánh giá cao (hiển thị công khai)
     */
    public List<Accommodation> getTopRatedAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
            AND a.averageRating > 0
            ORDER BY a.averageRating DESC, a.totalBookings DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation giá thấp (hiển thị công khai)
     */
    public List<Accommodation> getLowPriceAccommodations(int page, int pageSize) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
            ORDER BY a.pricePerNight ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        return executeAccommodationQuery(sql, (page - 1) * pageSize, pageSize);
    }

    /**
     * Lấy accommodation với filters nâng cao (hiển thị công khai)
     */
    public List<Accommodation> getAccommodationsWithFilters(String type, int regionId, int cityId, 
                                                           String filter, String sortBy, 
                                                           int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        // Apply specific filters
        if ("popular".equals(filter)) {
            sql.append(" AND a.totalBookings >= 5 AND a.averageRating >= 4.0");
        } else if ("top-rated".equals(filter)) {
            sql.append(" AND a.averageRating > 0");
        }

        // Apply type filter
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        // Apply location filters
        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        // Apply sorting
        if ("popular".equals(filter)) {
            sql.append(" ORDER BY a.totalBookings DESC, a.averageRating DESC");
        } else if ("newest".equals(filter)) {
            sql.append(" ORDER BY a.createdAt DESC");
        } else if ("top-rated".equals(filter)) {
            sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
        } else if ("low-price".equals(filter)) {
            sql.append(" ORDER BY a.pricePerNight ASC");
        } else if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "price-asc":
                    sql.append(" ORDER BY a.pricePerNight ASC");
                    break;
                case "price-desc":
                    sql.append(" ORDER BY a.pricePerNight DESC");
                    break;
                case "rating":
                    sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
                    break;
                case "newest":
                    sql.append(" ORDER BY a.createdAt DESC");
                    break;
                default:
                    sql.append(" ORDER BY a.createdAt DESC");
            }
        } else {
            sql.append(" ORDER BY a.createdAt DESC");
        }

        // Add pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    /**
     * Đếm accommodation với filters
     */
    public int getFilteredAccommodationsCount(String type, int regionId, int cityId, String filter) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) 
            FROM Accommodations a
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);

        List<Object> parameters = new ArrayList<>();

        // Apply specific filters
        if ("popular".equals(filter)) {
            sql.append(" AND a.totalBookings >= 5 AND a.averageRating >= 4.0");
        } else if ("top-rated".equals(filter)) {
            sql.append(" AND a.averageRating > 0");
        }

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }

        if (regionId > 0) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }

        if (cityId > 0) {
            sql.append(" AND a.cityId = ?");
            parameters.add(cityId);
        }

        return getCountWithParams(sql.toString(), parameters);
    }

    /**
     * CÁC PHƯƠNG THỨC ĐẾM
     */
    public int getPendingAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'PENDING'";
        return getCount(sql);
    }

    public int getPendingAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'PENDING'");
        
        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" AND type = ?");
            return getCountWithParam(sql.toString(), type);
        }
        
        return getCount(sql.toString());
    }

    public int getApprovedAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'APPROVED'";
        return getCount(sql);
    }

    public int getApprovedAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'APPROVED'");
        
        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" AND type = ?");
            return getCountWithParam(sql.toString(), type);
        }
        
        return getCount(sql.toString());
    }

    public int getRejectedAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'REJECTED'";
        return getCount(sql);
    }

    public int getTotalAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations";
        return getCount(sql);
    }

    public int getTotalAccommodationsCount(String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations");
        
        if (type != null && !type.trim().isEmpty() && !"all".equals(type)) {
            sql.append(" WHERE type = ?");
            return getCountWithParam(sql.toString(), type);
        }
        
        return getCount(sql.toString());
    }

    public int getActiveAccommodationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE adminApprovalStatus = 'APPROVED' AND isActive = 1";
        return getCount(sql);
    }

    public int getPublicAccommodationsCount() throws SQLException {
        return getActiveAccommodationsCount();
    }

    /**
     * CÁC PHƯƠNG THỨC CHO HOST
     */
    public List<Accommodation> getAccommodationsByHostId(int hostId) throws SQLException {
        String sql = """
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.hostId = ?
            ORDER BY a.createdAt DESC
        """;
        
        return executeAccommodationQuery(sql, hostId);
    }

    public int countAccommodationsByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE hostId = ?";
        return getCountWithParam(sql, hostId);
    }

    public int countActiveAccommodationsByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE hostId = ? AND adminApprovalStatus = 'APPROVED' AND isActive = 1";
        return getCountWithParam(sql, hostId);
    }

    public int countPendingAccommodationsByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE hostId = ? AND adminApprovalStatus = 'PENDING'";
        return getCountWithParam(sql, hostId);
    }

    public int countApprovedAccommodationsByHostId(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE hostId = ? AND adminApprovalStatus = 'APPROVED'";
        return getCountWithParam(sql, hostId);
    }

    /**
     * HOST CẬP NHẬT TRẠNG THÁI ẨN/HIỆN (chỉ khi đã được duyệt)
     */
    public boolean updateAccommodationVisibility(int accommodationId, int hostId, boolean isActive) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET isActive = ? 
            WHERE accommodationId = ? AND hostId = ? AND adminApprovalStatus = 'APPROVED'
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, accommodationId);
            ps.setInt(3, hostId);
            
            int rowsAffected = ps.executeUpdate();
            boolean success = rowsAffected > 0;
            
            LOGGER.info("Host " + hostId + " " + (isActive ? "show" : "hide") + 
                       " accommodation " + accommodationId + ": " + (success ? "SUCCESS" : "FAILED"));
            
            return success;
        }
    }
  public boolean updateAccommodationStatus(int accommodationId, boolean isActive) throws SQLException {
        String sql = "UPDATE Accommodations SET isActive = ? WHERE accommodationId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }
    /**
     * CẬP NHẬT THÔNG TIN ACCOMMODATION (cho phép cả APPROVED - sẽ reset về PENDING)
     */
    public boolean updateAccommodation(Accommodation accommodation) throws SQLException {
        LOGGER.info("=== DAO UPDATE ACCOMMODATION ===");
        LOGGER.info("Accommodation ID: " + accommodation.getAccommodationId());
        LOGGER.info("Host ID: " + accommodation.getHostId());
        LOGGER.info("Name: " + accommodation.getName());
        LOGGER.info("Price: " + accommodation.getPricePerNight());
        
        String sql = """
            UPDATE Accommodations 
            SET name = ?, description = ?, cityId = ?, address = ?, type = ?, 
                numberOfRooms = ?, amenities = ?, pricePerNight = ?, images = ?, promotion_percent = ?, promotion_start = ?, promotion_end = ?
            WHERE accommodationId = ? AND hostId = ? 
            AND adminApprovalStatus IN ('PENDING', 'REJECTED', 'APPROVED')
        """;

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accommodation.getName());
            ps.setString(2, accommodation.getDescription());
            ps.setInt(3, accommodation.getCityId());
            ps.setString(4, accommodation.getAddress());
            ps.setString(5, accommodation.getType());
            ps.setInt(6, accommodation.getNumberOfRooms());
            ps.setString(7, accommodation.getAmenities());
            ps.setDouble(8, accommodation.getPricePerNight());
            ps.setString(9, accommodation.getImages());
            ps.setInt(10, accommodation.getPromotionPercent());
            ps.setTimestamp(11, accommodation.getPromotionStart());
            ps.setTimestamp(12, accommodation.getPromotionEnd());
            ps.setInt(13, accommodation.getAccommodationId());
            ps.setInt(14, accommodation.getHostId());

            LOGGER.info("Executing SQL update...");
            int rowsAffected = ps.executeUpdate();
            LOGGER.info("Rows affected: " + rowsAffected);
            boolean success = rowsAffected > 0;

            if (success) {
                LOGGER.info("Update successful! Checking if need to reset approval status...");
                // Reset về PENDING nếu đang bị REJECTED hoặc đã APPROVED
                String resetSql = """
                    UPDATE Accommodations 
                    SET adminApprovalStatus = 'PENDING', adminRejectReason = NULL,
                        adminApprovedBy = NULL, adminApprovedAt = NULL
                    WHERE accommodationId = ? AND adminApprovalStatus IN ('REJECTED', 'APPROVED')
                """;
                try (PreparedStatement resetPs = conn.prepareStatement(resetSql)) {
                    resetPs.setInt(1, accommodation.getAccommodationId());
                    int resetRows = resetPs.executeUpdate();
                    if (resetRows > 0) {
                        LOGGER.info("Accommodation " + accommodation.getAccommodationId() + " reset to PENDING for re-approval");
                    } else {
                        LOGGER.info("No status reset needed for accommodation " + accommodation.getAccommodationId());
                    }
                }
            } else {
                LOGGER.warning("Update failed! No rows affected. Check WHERE conditions.");
            }

            return success;
        }
    }

    /**
     * Lấy accommodations theo city và region
     */
    public List<Accommodation> getAccommodationsByCity(int cityId, int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            WHERE a.cityId = ? AND a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();
        parameters.add(cityId);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }
        
        sql.append(" ORDER BY a.createdAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);
        
        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    public List<Accommodation> getAccommodationsByRegion(int regionId, int page, int pageSize, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT a.*, u.fullName as hostName, c.name as cityName, c.vietnameseName as cityVietnameseName
            FROM Accommodations a
            LEFT JOIN Users u ON a.hostId = u.userId
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE r.regionId = ? AND a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();
        parameters.add(regionId);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }
        
        sql.append(" ORDER BY a.createdAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);
        
        return executeAccommodationQueryWithParams(sql.toString(), parameters);
    }

    public int getAccommodationsCountByCity(int cityId, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accommodations WHERE cityId = ? AND adminApprovalStatus = 'APPROVED' AND isActive = 1");
        
        List<Object> parameters = new ArrayList<>();
        parameters.add(cityId);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
            parameters.add(type);
        }
        
        return getCountWithParams(sql.toString(), parameters);
    }

    public int getAccommodationsCountByRegion(int regionId, String type) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM Accommodations a
            LEFT JOIN Cities c ON a.cityId = c.cityId
            LEFT JOIN Regions r ON c.regionId = r.regionId
            WHERE r.regionId = ? AND a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();
        parameters.add(regionId);
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }
        
        return getCountWithParams(sql.toString(), parameters);
    }

    public int getRecentAccommodationsCount(int days) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(DAY, ?, GETDATE())";
        return getCountWithParam(sql, -days);
    }

    /**
     * XÓA VĨNH VIỄN (ADMIN)
     */
    public boolean deleteAccommodation(int accommodationId) throws SQLException {
        String sql = "DELETE FROM Accommodations WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accommodationId);
            int rowsAffected = ps.executeUpdate();
            
            boolean success = rowsAffected > 0;
            LOGGER.info("Delete accommodation " + accommodationId + ": " + (success ? "SUCCESS" : "FAILED"));
            
            return success;
        }
    }

    /**
     * CÁC PHƯƠNG THỨC XỬ LÝ BÁO CÁO VÀ ĐÁNH DẤU (Base schema không có)
     */
    public boolean softDeleteAccommodation(int accommodationId, String reason) throws SQLException {
        // Base schema không có soft delete fields, perform hard delete
        LOGGER.info("Soft delete requested for accommodation " + accommodationId + " - Reason: " + reason);
        return deleteAccommodation(accommodationId);
    }

    public boolean restoreAccommodation(int accommodationId) throws SQLException {
        // Base schema không có soft delete fields, log action
        LOGGER.info("Restore requested for accommodation " + accommodationId);
        return true;
    }

    public boolean flagAccommodation(int accommodationId, String reason) throws SQLException {
        // Base schema không có flag fields, log action
        LOGGER.info("Flag accommodation " + accommodationId + " - Reason: " + reason);
        return true;
    }

    public boolean unflagAccommodation(int accommodationId) throws SQLException {
        // Base schema không có flag fields, log action
        LOGGER.info("Unflag accommodation " + accommodationId);
        return true;
    }

    public boolean updateReportCount(int accommodationId, int reportCount) throws SQLException {
        // Base schema không có report_count, log action
        LOGGER.info("Report count update requested for accommodation ID: " + accommodationId + ", count: " + reportCount);
        return true;
    }

    /**
     * CÁC PHƯƠNG THỨC PLACEHOLDER CHO TƯƠNG THÍCH
     */
    public List<Accommodation> getReportedAccommodations(int page, int pageSize) throws SQLException {
        // Base schema không có report fields, return empty list
        return new ArrayList<>();
    }

    public List<Accommodation> getFlaggedAccommodations(int page, int pageSize) throws SQLException {
        // Base schema không có flag fields, return empty list
        return new ArrayList<>();
    }

    public List<Accommodation> getDeletedAccommodations(int page, int pageSize) throws SQLException {
        // Base schema không có soft delete, return empty list
        return new ArrayList<>();
    }

    public int getReportedAccommodationsCount() throws SQLException {
        return 0;
    }

    public int getFlaggedAccommodationsCount() throws SQLException {
        return 0;
    }

    public int getDeletedAccommodationsCount() throws SQLException {
        return 0;
    }

    /**
     * CÁC PHƯƠNG THỨC THỐNG KÊ
     */
    public Map<String, Integer> getAccommodationsByRegion() throws SQLException {
        Map<String, Integer> regionCounts = new HashMap<>();
        String sql = """
            SELECT r.name as regionName, COUNT(a.accommodationId) as count
            FROM Accommodations a
            JOIN Cities c ON a.cityId = c.cityId
            JOIN Regions r ON c.regionId = r.regionId
            WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1
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
            FROM Accommodations 
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
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(DAY, -7, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(DAY, -14, GETDATE()) 
                         AND createdAt < DATEADD(DAY, -7, GETDATE())) as previous_period
                """;
                break;
            case "year":
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(YEAR, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(YEAR, -2, GETDATE()) 
                         AND createdAt < DATEADD(YEAR, -1, GETDATE())) as previous_period
                """;
                break;
            default: // month
                sql = """
                    SELECT 
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(MONTH, -1, GETDATE())) as current_period,
                        (SELECT COUNT(*) FROM Accommodations WHERE createdAt >= DATEADD(MONTH, -2, GETDATE()) 
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
     * CÁC PHƯƠNG THỨC HỖ TRỢ
     */
    private List<Accommodation> executeAccommodationQuery(String sql, Object... params) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            return executeQuery(ps);
        }
    }

    private List<Accommodation> executeAccommodationQueryWithParams(String sql, List<Object> params) throws SQLException {
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            return executeQuery(ps);
        }
    }

    private List<Accommodation> executeQuery(PreparedStatement ps) throws SQLException {
        List<Accommodation> accommodations = new ArrayList<>();

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                accommodations.add(mapAccommodationFromResultSet(rs));
            }
        }

        return accommodations;
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
     * Map ResultSet sang Accommodation object
     */
    private Accommodation mapAccommodationFromResultSet(ResultSet rs) throws SQLException {
        Accommodation accommodation = new Accommodation();
        
        // Basic fields
        accommodation.setAccommodationId(rs.getInt("accommodationId"));
        accommodation.setHostId(rs.getInt("hostId"));
        accommodation.setName(rs.getString("name"));
        accommodation.setDescription(rs.getString("description"));
        accommodation.setCityId(rs.getInt("cityId"));
        accommodation.setAddress(rs.getString("address"));
        accommodation.setType(rs.getString("type"));
        accommodation.setNumberOfRooms(rs.getInt("numberOfRooms"));
        accommodation.setMaxOccupancy(rs.getInt("maxOccupancy"));
        accommodation.setAmenities(rs.getString("amenities"));
        accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
        accommodation.setImages(rs.getString("images"));
        accommodation.setCreatedAt(rs.getDate("createdAt"));
        accommodation.setActive(rs.getBoolean("isActive"));
        accommodation.setAverageRating(rs.getDouble("averageRating"));
        accommodation.setTotalBookings(rs.getInt("totalBookings"));

        // Promotion fields (nếu có)
        try {
            accommodation.setPromotionPercent(rs.getInt("promotion_percent"));
            accommodation.setPromotionStart(rs.getTimestamp("promotion_start"));
            accommodation.setPromotionEnd(rs.getTimestamp("promotion_end"));
        } catch (SQLException e) {
            // Ignore if fields don't exist in this query
        }

        // Admin approval fields (nếu có)
        try {
            accommodation.setAdminApprovalStatus(rs.getString("adminApprovalStatus"));
            accommodation.setAdminApprovedBy(rs.getInt("adminApprovedBy"));
            if (rs.wasNull()) accommodation.setAdminApprovedBy(null);
            accommodation.setAdminApprovedAt(rs.getTimestamp("adminApprovedAt"));
            accommodation.setAdminRejectReason(rs.getString("adminRejectReason"));
            accommodation.setAdminNotes(rs.getString("adminNotes"));
        } catch (SQLException e) {
            // Ignore if fields don't exist in this query
            accommodation.setAdminApprovalStatus("PENDING");
        }

        // Joined fields (nếu có)
        try {
            accommodation.setHostName(rs.getString("hostName"));
            accommodation.setCityName(rs.getString("cityName"));
        } catch (SQLException e) {
            // Ignore if fields don't exist in this query
        }

        // Set default values for extended fields
        accommodation.setReportCount(0);
        accommodation.setDeleted(false);
        accommodation.setFlagged(false);

        return accommodation;
    }

    // ===== LEGACY METHODS CHO TƯƠNG THÍCH NGƯỢC =====
    
    @Deprecated
    public boolean approveAccommodation(int accommodationId) throws SQLException {
        // Fallback - approve without admin info
        String sql = "UPDATE Accommodations SET adminApprovalStatus = 'APPROVED', adminApprovedAt = GETDATE() WHERE accommodationId = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accommodationId);
            return ps.executeUpdate() > 0;
        }
    }

    @Deprecated
    public boolean rejectAccommodation(int accommodationId, String reason) throws SQLException {
        return rejectAccommodation(accommodationId, 1, reason); // Use admin ID = 1 as fallback
    }

    /**
     * Update promotion for accommodation
     */
    public boolean updatePromotion(int accommodationId, int promotionPercent,
            java.sql.Timestamp promotionStart, java.sql.Timestamp promotionEnd) throws SQLException {
        String sql = "UPDATE accommodations SET promotion_percent = ?, promotion_start = ?, promotion_end = ? WHERE accommodationId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, promotionPercent);
            pstmt.setTimestamp(2, promotionStart);
            pstmt.setTimestamp(3, promotionEnd);
            pstmt.setInt(4, accommodationId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating promotion for accommodation ID: " + accommodationId, e);
            throw e;
        }
    }
}