package dao;

import model.Region;
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
        
        String sql = "SELECT regionId, name, vietnameseName, description, imageUrl, climate, culture FROM Regions";
        
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

