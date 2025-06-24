package dao;

import model.Category;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CategoryDAO {
    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());
    
    /**
     * Get all categories
     */
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT categoryId, name, description, iconUrl FROM Categories ORDER BY name";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapCategoryFromResultSet(rs));
            }
            
            LOGGER.info("Retrieved " + categories.size() + " categories");
        }
        return categories;
    }
    
    /**
     * Get category by ID
     */
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT categoryId, name, description, iconUrl FROM Categories WHERE categoryId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCategoryFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Create new category
     */
    public int createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO Categories (name, description, iconUrl) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getIconUrl());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int categoryId = generatedKeys.getInt(1);
                        category.setCategoryId(categoryId);
                        return categoryId;
                    }
                }
            }
        }
        return 0;
    }
    
    /**
     * Update category
     */
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE Categories SET name = ?, description = ?, iconUrl = ? WHERE categoryId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getIconUrl());
            ps.setInt(4, category.getCategoryId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete category
     */
    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM Categories WHERE categoryId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Map ResultSet to Category object
     */
    private Category mapCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("categoryId"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setIconUrl(rs.getString("iconUrl"));
        return category;
    }
}