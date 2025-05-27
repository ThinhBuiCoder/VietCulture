package dao;

import model.Accommodation;
import model.City;
import model.Region;
import model.User;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class AccommodationDAO {
    private static final Logger LOGGER = Logger.getLogger(AccommodationDAO.class.getName());
    
    /**
     * Get featured accommodations (top rated and most booked)
     */
    public List<Accommodation> getFeaturedAccommodations(int limit) throws SQLException {
        List<Accommodation> accommodations = new ArrayList<>();
        String sql = """
            SELECT a.accommodationId, a.hostId, a.name, a.description, a.address, a.type,
                   a.numberOfRooms, a.amenities, a.pricePerNight, a.images,
                   a.averageRating, a.totalBookings,
                   c.cityId, c.name as cityName, c.vietnameseName as cityVietnameseName,
                   r.regionId, r.name as regionName, r.vietnameseName as regionVietnameseName,
                   u.userId, u.fullName as hostName, u.avatar as hostAvatar
            FROM Accommodations a
            INNER JOIN Cities c ON a.cityId = c.cityId
            INNER JOIN Regions r ON c.regionId = r.regionId
            INNER JOIN Users u ON a.hostId = u.userId
            WHERE a.isActive = 1
            ORDER BY a.averageRating DESC, a.totalBookings DESC
            OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Accommodation accommodation = mapAccommodationFromResultSet(rs);
                    accommodations.add(accommodation);
                }
            }
            
            LOGGER.info("Retrieved " + accommodations.size() + " featured accommodations");
        }
        return accommodations;
    }
    
    /**
     * Get accommodation by ID
     */
    public Accommodation getAccommodationById(int accommodationId) throws SQLException {
        String sql = """
            SELECT a.accommodationId, a.hostId, a.name, a.description, a.address, a.type,
                   a.numberOfRooms, a.amenities, a.pricePerNight, a.images, a.createdAt,
                   a.isActive, a.averageRating, a.totalBookings,
                   c.cityId, c.name as cityName, c.vietnameseName as cityVietnameseName,
                   r.regionId, r.name as regionName, r.vietnameseName as regionVietnameseName,
                   u.userId, u.fullName as hostName, u.avatar as hostAvatar
            FROM Accommodations a
            INNER JOIN Cities c ON a.cityId = c.cityId
            INNER JOIN Regions r ON c.regionId = r.regionId
            INNER JOIN Users u ON a.hostId = u.userId
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
        }
        return null;
    }
    
    /**
     * Search accommodations with filters
     */
    public List<Accommodation> searchAccommodations(Integer regionId, Integer cityId, 
                                                   String type, Double minPrice, Double maxPrice,
                                                   Integer minRooms, int offset, int limit) throws SQLException {
        List<Accommodation> accommodations = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT a.accommodationId, a.hostId, a.name, a.description, a.address, a.type,
                   a.numberOfRooms, a.amenities, a.pricePerNight, a.images,
                   a.averageRating, a.totalBookings,
                   c.cityId, c.name as cityName, c.vietnameseName as cityVietnameseName,
                   r.regionId, r.name as regionName, r.vietnameseName as regionVietnameseName,
                   u.userId, u.fullName as hostName, u.avatar as hostAvatar
            FROM Accommodations a
            INNER JOIN Cities c ON a.cityId = c.cityId
            INNER JOIN Regions r ON c.regionId = r.regionId
            INNER JOIN Users u ON a.hostId = u.userId
            WHERE a.isActive = 1
        """);
        
        List<Object> parameters = new ArrayList<>();
        
        if (regionId != null) {
            sql.append(" AND r.regionId = ?");
            parameters.add(regionId);
        }
        
        if (cityId != null) {
            sql.append(" AND c.cityId = ?");
            parameters.add(cityId);
        }
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            parameters.add(type);
        }
        
        if (minPrice != null) {
            sql.append(" AND a.pricePerNight >= ?");
            parameters.add(minPrice);
        }
        
        if (maxPrice != null) {
            sql.append(" AND a.pricePerNight <= ?");
            parameters.add(maxPrice);
        }
        
        if (minRooms != null) {
            sql.append(" AND a.numberOfRooms >= ?");
            parameters.add(minRooms);
        }
        
        sql.append(" ORDER BY a.averageRating DESC, a.totalBookings DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(limit);
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    accommodations.add(mapAccommodationFromResultSet(rs));
                }
            }
        }
        
        return accommodations;
    }
    
    /**
     * Get accommodations by host ID
     */
    public List<Accommodation> getAccommodationsByHostId(int hostId) throws SQLException {
        List<Accommodation> accommodations = new ArrayList<>();
        String sql = """
            SELECT a.accommodationId, a.hostId, a.name, a.description, a.address, a.type,
                   a.numberOfRooms, a.amenities, a.pricePerNight, a.images, a.createdAt,
                   a.isActive, a.averageRating, a.totalBookings,
                   c.cityId, c.name as cityName, c.vietnameseName as cityVietnameseName,
                   r.regionId, r.name as regionName, r.vietnameseName as regionVietnameseName,
                   u.userId, u.fullName as hostName, u.avatar as hostAvatar
            FROM Accommodations a
            INNER JOIN Cities c ON a.cityId = c.cityId
            INNER JOIN Regions r ON c.regionId = r.regionId
            INNER JOIN Users u ON a.hostId = u.userId
            WHERE a.hostId = ?
            ORDER BY a.createdAt DESC
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hostId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    accommodations.add(mapAccommodationFromResultSet(rs));
                }
            }
        }
        return accommodations;
    }
    
    /**
     * Create new accommodation
     */
    public int createAccommodation(Accommodation accommodation) throws SQLException {
        String sql = """
            INSERT INTO Accommodations (hostId, name, description, cityId, address, type,
                                      numberOfRooms, amenities, pricePerNight, images)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
            ps.setString(8, accommodation.getAmenities());
            ps.setDouble(9, accommodation.getPricePerNight());
            ps.setString(10, accommodation.getImages());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int accommodationId = generatedKeys.getInt(1);
                        accommodation.setAccommodationId(accommodationId);
                        return accommodationId;
                    }
                }
            }
        }
        return 0;
    }
    
    /**
     * Update accommodation
     */
    public boolean updateAccommodation(Accommodation accommodation) throws SQLException {
        String sql = """
            UPDATE Accommodations 
            SET name = ?, description = ?, cityId = ?, address = ?, type = ?,
                numberOfRooms = ?, amenities = ?, pricePerNight = ?, images = ?, isActive = ?
            WHERE accommodationId = ?
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
            ps.setBoolean(10, accommodation.isActive());
            ps.setInt(11, accommodation.getAccommodationId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Map ResultSet to Accommodation object
     */
    private Accommodation mapAccommodationFromResultSet(ResultSet rs) throws SQLException {
        Accommodation accommodation = new Accommodation();
        accommodation.setAccommodationId(rs.getInt("accommodationId"));
        accommodation.setHostId(rs.getInt("hostId"));
        accommodation.setName(rs.getString("name"));
        accommodation.setDescription(rs.getString("description"));
        accommodation.setAddress(rs.getString("address"));
        accommodation.setType(rs.getString("type"));
        accommodation.setNumberOfRooms(rs.getInt("numberOfRooms"));
        accommodation.setAmenities(rs.getString("amenities"));
        accommodation.setPricePerNight(rs.getDouble("pricePerNight"));
        accommodation.setImages(rs.getString("images"));
        accommodation.setAverageRating(rs.getDouble("averageRating"));
        accommodation.setTotalBookings(rs.getInt("totalBookings"));
        
        // Map City
        City city = new City();
        city.setCityId(rs.getInt("cityId"));
        city.setName(rs.getString("cityName"));
        city.setVietnameseName(rs.getString("cityVietnameseName"));
        
        // Map Region
        Region region = new Region();
        region.setRegionId(rs.getInt("regionId"));
        region.setName(rs.getString("regionName"));
        region.setVietnameseName(rs.getString("regionVietnameseName"));
        city.setRegion(region);
        
        accommodation.setCity(city);
        
        // Map Host
        User host = new User();
        host.setUserId(rs.getInt("userId"));
        host.setFullName(rs.getString("hostName"));
        host.setAvatar(rs.getString("hostAvatar"));
        accommodation.setHost(host);
        
        return accommodation;
    }
}