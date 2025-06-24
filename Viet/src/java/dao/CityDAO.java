package dao;

import model.City;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CityDAO {
<<<<<<< HEAD

    private static final Logger LOGGER = Logger.getLogger(CityDAO.class.getName());

    /**
     * Get city by ID
     */
    public City getCityById(int cityId) throws SQLException {
        String sql = """
            SELECT cityId, name, vietnameseName, regionId, description, imageUrl, attractions
            FROM Cities 
            WHERE cityId = ?
        """;

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cityId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCityFromResultSet(rs);
                }
            }
        }
        return null;
    }

=======
    private static final Logger LOGGER = Logger.getLogger(CityDAO.class.getName());
    
    /**
     * Get ALL cities - SIMPLE VERSION
     */
    public List<City> getAllCities() throws SQLException {
        List<City> cities = new ArrayList<>();
        
        String sql = "SELECT cityId, name, vietnameseName, regionId, description, imageUrl, attractions FROM Cities ORDER BY regionId, name";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                cities.add(mapCityFromResultSet(rs));
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting all cities: " + e.getMessage());
            throw e;
        }
        
        LOGGER.info("Loaded " + cities.size() + " cities");
        return cities;
    }
    
    /**
     * Get city by ID
     */
public City getCityById(int cityId) throws SQLException {
    String sql = "SELECT cityId, name, vietnameseName, regionId FROM Cities WHERE cityId = ?";
    
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, cityId);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapBasicCityFromResultSet(rs);
            }
        }
    } catch (SQLException e) {
        LOGGER.severe("Error getting city by ID " + cityId + ": " + e.getMessage());
        // Return null instead of throwing to prevent servlet crash
        return null;
    }
    return null;
}
private City mapBasicCityFromResultSet(ResultSet rs) throws SQLException {
    City city = new City();
    
    try {
        city.setCityId(rs.getInt("cityId"));
        city.setName(rs.getString("name"));
        city.setVietnameseName(rs.getString("vietnameseName"));
        city.setRegionId(rs.getInt("regionId"));
        
    } catch (SQLException e) {
        LOGGER.severe("Error mapping basic city from ResultSet: " + e.getMessage());
        throw e;
    }
    
    return city;
}
    /**
     * Get cities by region ID
     */
    public List<City> getCitiesByRegionId(int regionId) throws SQLException {
        List<City> cities = new ArrayList<>();
        
        String sql = "SELECT cityId, name, vietnameseName, regionId, description, imageUrl, attractions FROM Cities WHERE regionId = ? ORDER BY name";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, regionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cities.add(mapCityFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting cities by region " + regionId + ": " + e.getMessage());
            throw e;
        }
        return cities;
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Get top cities with statistics
     */
    public List<CityStats> getTopCitiesWithStats(int limit) throws SQLException {
        List<CityStats> cities = new ArrayList<>();
<<<<<<< HEAD

        String sql = """
            SELECT TOP(?) c.cityId, c.name, c.vietnameseName,
                   COUNT(DISTINCT e.experienceId) as experienceCount,
                   COUNT(DISTINCT a.accommodationId) as accommodationCount
            FROM Cities c
            LEFT JOIN Experiences e ON c.cityId = e.cityId AND e.isActive = 1
            LEFT JOIN Accommodations a ON c.cityId = a.cityId AND a.isActive = 1
            GROUP BY c.cityId, c.name, c.vietnameseName
            HAVING (COUNT(DISTINCT e.experienceId) + COUNT(DISTINCT a.accommodationId)) > 0
            ORDER BY (COUNT(DISTINCT e.experienceId) + COUNT(DISTINCT a.accommodationId)) DESC
        """;

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                int maxCount = 0;
                List<CityStats> tempList = new ArrayList<>();

                // First pass: collect data and find max count
=======
        
        // Simple version without complex joins
        String sql = "SELECT TOP(?) cityId, name, vietnameseName FROM Cities ORDER BY cityId";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                while (rs.next()) {
                    CityStats cityStats = new CityStats();
                    cityStats.setName(rs.getString("name"));
                    cityStats.setVietnameseName(rs.getString("vietnameseName"));
<<<<<<< HEAD
                    cityStats.setExperienceCount(rs.getInt("experienceCount"));
                    cityStats.setAccommodationCount(rs.getInt("accommodationCount"));

                    int totalCount = cityStats.getExperienceCount() + cityStats.getAccommodationCount();
                    if (totalCount > maxCount) {
                        maxCount = totalCount;
                    }

                    tempList.add(cityStats);
                }

                // Second pass: calculate percentages
                for (CityStats cityStats : tempList) {
                    int totalCount = cityStats.getExperienceCount() + cityStats.getAccommodationCount();
                    if (maxCount > 0) {
                        cityStats.setPercentage((double) totalCount / maxCount * 100);
                    }
                    cities.add(cityStats);
                }
            }
        }
        return cities;
    }

=======
                    cityStats.setExperienceCount(0); // Default values
                    cityStats.setAccommodationCount(0);
                    cityStats.setPercentage(100.0);
                    cities.add(cityStats);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting top cities: " + e.getMessage());
            throw e;
        }
        return cities;
    }
    
    /**
     * Get popular cities - simple implementation
     */
    public List<City> getPopularCities(int limit) throws SQLException {
        List<City> cities = new ArrayList<>();
        
        String sql = "SELECT TOP(?) cityId, name, vietnameseName, regionId, description, imageUrl, attractions FROM Cities ORDER BY cityId";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cities.add(mapCityFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting popular cities: " + e.getMessage());
            throw e;
        }
        return cities;
    }
    
    /**
     * Create new city
     */
    public int createCity(City city) throws SQLException {
        String sql = "INSERT INTO Cities (name, vietnameseName, regionId, description, imageUrl, attractions) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, city.getName());
            ps.setString(2, city.getVietnameseName());
            ps.setInt(3, city.getRegionId());
            ps.setString(4, city.getDescription());
            ps.setString(5, city.getImageUrl());
            ps.setString(6, city.getAttractions());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int cityId = generatedKeys.getInt(1);
                        city.setCityId(cityId);
                        LOGGER.info("City created successfully with ID: " + cityId);
                        return cityId;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error creating city: " + e.getMessage());
            throw e;
        }
        return 0;
    }
    
    /**
     * Update city
     */
    public boolean updateCity(City city) throws SQLException {
        String sql = "UPDATE Cities SET name = ?, vietnameseName = ?, regionId = ?, description = ?, imageUrl = ?, attractions = ? WHERE cityId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, city.getName());
            ps.setString(2, city.getVietnameseName());
            ps.setInt(3, city.getRegionId());
            ps.setString(4, city.getDescription());
            ps.setString(5, city.getImageUrl());
            ps.setString(6, city.getAttractions());
            ps.setInt(7, city.getCityId());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("City updated successfully: " + city.getCityId());
            }
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.severe("Error updating city: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Delete city
     */
    public boolean deleteCity(int cityId) throws SQLException {
        String sql = "DELETE FROM Cities WHERE cityId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cityId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("City deleted - ID: " + cityId);
            }
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.severe("Error deleting city: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Get total cities count
     */
    public int getCitiesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cities";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error counting cities: " + e.getMessage());
            throw e;
        }
        return 0;
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Map ResultSet to City object
     */
    private City mapCityFromResultSet(ResultSet rs) throws SQLException {
        City city = new City();
        city.setCityId(rs.getInt("cityId"));
        city.setName(rs.getString("name"));
        city.setVietnameseName(rs.getString("vietnameseName"));
        city.setRegionId(rs.getInt("regionId"));
        city.setDescription(rs.getString("description"));
        city.setImageUrl(rs.getString("imageUrl"));
        city.setAttractions(rs.getString("attractions"));
        return city;
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Inner class for City Statistics
     */
    public static class CityStats {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        private String name;
        private String vietnameseName;
        private int experienceCount;
        private int accommodationCount;
        private double percentage;
<<<<<<< HEAD

        // Constructors, getters, setters
        public CityStats() {
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getVietnameseName() {
            return vietnameseName;
        }

        public void setVietnameseName(String vietnameseName) {
            this.vietnameseName = vietnameseName;
        }

        public int getExperienceCount() {
            return experienceCount;
        }

        public void setExperienceCount(int experienceCount) {
            this.experienceCount = experienceCount;
        }

        public int getAccommodationCount() {
            return accommodationCount;
        }

        public void setAccommodationCount(int accommodationCount) {
            this.accommodationCount = accommodationCount;
        }

        public double getPercentage() {
            return percentage;
        }

        public void setPercentage(double percentage) {
            this.percentage = percentage;
        }
    }
}
=======
        
        // Constructors, getters, setters
        public CityStats() {}
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getVietnameseName() { return vietnameseName; }
        public void setVietnameseName(String vietnameseName) { this.vietnameseName = vietnameseName; }
        
        public int getExperienceCount() { return experienceCount; }
        public void setExperienceCount(int experienceCount) { this.experienceCount = experienceCount; }
        
        public int getAccommodationCount() { return accommodationCount; }
        public void setAccommodationCount(int accommodationCount) { this.accommodationCount = accommodationCount; }
        
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
