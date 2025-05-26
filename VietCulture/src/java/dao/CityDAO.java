package dao;

import model.City;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CityDAO {
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
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cityId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCityFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get top cities with statistics
     */
    public List<CityStats> getTopCitiesWithStats(int limit) throws SQLException {
        List<CityStats> cities = new ArrayList<>();
        
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
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                int maxCount = 0;
                List<CityStats> tempList = new ArrayList<>();
                
                // First pass: collect data and find max count
                while (rs.next()) {
                    CityStats cityStats = new CityStats();
                    cityStats.setName(rs.getString("name"));
                    cityStats.setVietnameseName(rs.getString("vietnameseName"));
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
    
    /**
     * Inner class for City Statistics
     */
    public static class CityStats {
        private String name;
        private String vietnameseName;
        private int experienceCount;
        private int accommodationCount;
        private double percentage;
        
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