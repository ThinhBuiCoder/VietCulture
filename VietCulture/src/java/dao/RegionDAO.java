package dao;

import model.Region;
import model.City;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class RegionDAO {
    private static final Logger LOGGER = Logger.getLogger(RegionDAO.class.getName());
    
    /**
     * Get all regions
     */
    public List<Region> getAllRegions() throws SQLException {
        List<Region> regions = new ArrayList<>();
        
        String sql = "SELECT regionId, name, vietnameseName, description, imageUrl, climate, culture FROM Regions ORDER BY regionId";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                regions.add(mapRegionFromResultSet(rs));
            }
        }
        return regions;
    }
    
    /**
     * Get all regions with their cities
     */
    public List<Region> getAllRegionsWithCities() throws SQLException {
        List<Region> regions = getAllRegions();
        
        // Load cities for each region
        for (Region region : regions) {
            List<City> cities = getCitiesByRegionId(region.getRegionId());
            region.setCities(cities);
        }
        
        return regions;
    }
    
    /**
     * Get region by ID
     */
    public Region getRegionById(int regionId) throws SQLException {
        String sql = "SELECT regionId, name, vietnameseName, description, imageUrl, climate, culture FROM Regions WHERE regionId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, regionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Region region = mapRegionFromResultSet(rs);
                    // Load cities for this region
                    List<City> cities = getCitiesByRegionId(regionId);
                    region.setCities(cities);
                    return region;
                }
            }
        }
        return null;
    }
    
    /**
     * Get cities by region ID
     */
    public List<City> getCitiesByRegionId(int regionId) throws SQLException {
        List<City> cities = new ArrayList<>();
        
        String sql = """
            SELECT cityId, name, vietnameseName, regionId, description, imageUrl, attractions 
            FROM Cities 
            WHERE regionId = ? 
            ORDER BY name
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, regionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cities.add(mapCityFromResultSet(rs));
                }
            }
        }
        return cities;
    }
    
    /**
     * Map ResultSet to Region object
     */
    private Region mapRegionFromResultSet(ResultSet rs) throws SQLException {
        Region region = new Region();
        region.setRegionId(rs.getInt("regionId"));
        region.setName(rs.getString("name"));
        region.setVietnameseName(rs.getString("vietnameseName"));
        region.setDescription(rs.getString("description"));
        region.setImageUrl(rs.getString("imageUrl"));
        region.setClimate(rs.getString("climate"));
        region.setCulture(rs.getString("culture"));
        return region;
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
     * Create new region
     */
    public int createRegion(Region region) throws SQLException {
        String sql = """
            INSERT INTO Regions (name, vietnameseName, description, imageUrl, climate, culture)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, region.getName());
            ps.setString(2, region.getVietnameseName());
            ps.setString(3, region.getDescription());
            ps.setString(4, region.getImageUrl());
            ps.setString(5, region.getClimate());
            ps.setString(6, region.getCulture());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int regionId = generatedKeys.getInt(1);
                        region.setRegionId(regionId);
                        LOGGER.info("Region created successfully with ID: " + regionId);
                        return regionId;
                    }
                }
            }
        }
        return 0;
    }
    
    /**
     * Update region
     */
    public boolean updateRegion(Region region) throws SQLException {
        String sql = """
            UPDATE Regions 
            SET name = ?, vietnameseName = ?, description = ?, imageUrl = ?, climate = ?, culture = ?
            WHERE regionId = ?
        """;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, region.getName());
            ps.setString(2, region.getVietnameseName());
            ps.setString(3, region.getDescription());
            ps.setString(4, region.getImageUrl());
            ps.setString(5, region.getClimate());
            ps.setString(6, region.getCulture());
            ps.setInt(7, region.getRegionId());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Region updated successfully: " + region.getRegionId());
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Delete region
     */
    public boolean deleteRegion(int regionId) throws SQLException {
        String sql = "DELETE FROM Regions WHERE regionId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, regionId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Region deleted - ID: " + regionId);
            }
            return rowsAffected > 0;
        }
    }
    
    /**
     * Get total regions count
     */
    public int getRegionsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Regions";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}