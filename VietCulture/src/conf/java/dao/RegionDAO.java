package dao;

import model.Region;
import model.City;
import utils.DBUtils;
import java.sql.*;
import java.util.*;
import java.util.logging.Logger;

public class RegionDAO {
    private static final Logger LOGGER = Logger.getLogger(RegionDAO.class.getName());
    
    /**
     * Get all regions only (for testing)
     */
    public List<Region> getAllRegionsOnly() throws SQLException {
        List<Region> regions = new ArrayList<>();
        String sql = "SELECT regionId, name, vietnameseName, description, imageUrl, climate, culture FROM Regions ORDER BY regionId";
        
        LOGGER.info("Loading regions only...");
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Region region = new Region();
                region.setRegionId(rs.getInt("regionId"));
                region.setName(rs.getString("name"));
                region.setVietnameseName(rs.getString("vietnameseName"));
                region.setDescription(rs.getString("description"));
                region.setImageUrl(rs.getString("imageUrl"));
                region.setClimate(rs.getString("climate"));
                region.setCulture(rs.getString("culture"));
                regions.add(region);
            }
            
            LOGGER.info("Loaded " + regions.size() + " regions only");
        }
        
        return regions;
    }

    /**
     * Get all regions with their cities (Simple version)
     */
    public List<Region> getAllRegionsWithCitiesSimple() throws SQLException {
        List<Region> regions = new ArrayList<>();
        Map<Integer, Region> regionMap = new HashMap<>();
        
        LOGGER.info("Starting to load regions with cities...");
        
        // First get all regions
        String regionSql = "SELECT regionId, name, vietnameseName, description, imageUrl, climate, culture FROM Regions ORDER BY regionId";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(regionSql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Region region = new Region();
                region.setRegionId(rs.getInt("regionId"));
                region.setName(rs.getString("name"));
                region.setVietnameseName(rs.getString("vietnameseName"));
                region.setDescription(rs.getString("description"));
                region.setImageUrl(rs.getString("imageUrl"));
                region.setClimate(rs.getString("climate"));
                region.setCulture(rs.getString("culture"));
                region.setCities(new ArrayList<>());
                
                regionMap.put(region.getRegionId(), region);
                regions.add(region);
            }
            
            LOGGER.info("Loaded " + regions.size() + " regions");
        }
        
        // Then get all cities and add to their regions
        String citySql = "SELECT cityId, name, vietnameseName, regionId, description FROM Cities ORDER BY regionId, cityId";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(citySql);
             ResultSet rs = ps.executeQuery()) {
            
            int cityCount = 0;
            while (rs.next()) {
                int regionId = rs.getInt("regionId");
                Region region = regionMap.get(regionId);
                
                if (region != null) {
                    City city = new City();
                    city.setCityId(rs.getInt("cityId"));
                    city.setName(rs.getString("name"));
                    city.setVietnameseName(rs.getString("vietnameseName"));
                    city.setRegionId(regionId);
                    city.setDescription(rs.getString("description"));
                    city.setRegion(region);
                    region.getCities().add(city);
                    cityCount++;
                } else {
                    LOGGER.warning("Found city with invalid regionId: " + regionId);
                }
            }
            
            LOGGER.info("Loaded " + cityCount + " cities");
        }
        
        LOGGER.info("Successfully loaded " + regions.size() + " regions with cities");
        return regions;
    }

    /**
     * Get all regions with their cities
     */
    public List<Region> getAllRegionsWithCities() throws SQLException {
        String sql = "SELECT r.regionId, r.name, r.vietnameseName, r.description, r.imageUrl, r.climate, r.culture, " +
                    "c.cityId, c.name as cityName, c.vietnameseName as cityVietnameseName, c.description as cityDescription " +
                    "FROM Regions r " +
                    "LEFT JOIN Cities c ON r.regionId = c.regionId " +
                    "ORDER BY r.regionId, c.cityId";
        
        Map<Integer, Region> regionMap = new HashMap<>();
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                int regionId = rs.getInt("regionId");
                
                Region region = regionMap.get(regionId);
                if (region == null) {
                    region = new Region();
                    region.setRegionId(regionId);
                    region.setName(rs.getString("name"));
                    region.setVietnameseName(rs.getString("vietnameseName"));
                    region.setDescription(rs.getString("description"));
                    region.setImageUrl(rs.getString("imageUrl"));
                    region.setClimate(rs.getString("climate"));
                    region.setCulture(rs.getString("culture"));
                    region.setCities(new ArrayList<>());
                    regionMap.put(regionId, region);
                }
                
                // Add city if exists
                if (rs.getInt("cityId") > 0) {
                    City city = new City();
                    city.setCityId(rs.getInt("cityId"));
                    city.setName(rs.getString("cityName"));
                    city.setVietnameseName(rs.getString("cityVietnameseName"));
                    city.setDescription(rs.getString("cityDescription"));
                    city.setRegionId(regionId);
                    city.setRegion(region);
                    region.getCities().add(city);
                }
            }
            
            LOGGER.info("Retrieved " + regionMap.size() + " regions with cities");
        }
        
        return new ArrayList<>(regionMap.values());
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
                    return mapRegionFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get all regions
     */
    public List<Region> getAllRegions() throws SQLException {
        List<Region> regions = new ArrayList<>();
        String sql = "SELECT regionId, name, vietnameseName, description, imageUrl, climate, culture FROM Regions ORDER BY name";
        
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
     * Create new region
     */
    public int createRegion(Region region) throws SQLException {
        String sql = "INSERT INTO Regions (name, vietnameseName, description, imageUrl, climate, culture) VALUES (?, ?, ?, ?, ?, ?)";
        
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
        String sql = "UPDATE Regions SET name = ?, vietnameseName = ?, description = ?, imageUrl = ?, climate = ?, culture = ? WHERE regionId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, region.getName());
            ps.setString(2, region.getVietnameseName());
            ps.setString(3, region.getDescription());
            ps.setString(4, region.getImageUrl());
            ps.setString(5, region.getClimate());
            ps.setString(6, region.getCulture());
            ps.setInt(7, region.getRegionId());
            
            return ps.executeUpdate() > 0;
        }
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
}