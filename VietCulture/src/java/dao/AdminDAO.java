package dao;

import model.Admin;
import utils.DBUtils;
import java.sql.*;
import java.util.logging.Logger;

public class AdminDAO {
    private static final Logger LOGGER = Logger.getLogger(AdminDAO.class.getName());
    
    public Admin getAdminByUserId(int userId) throws SQLException {
        String sql = "SELECT userId, role, permissions FROM Admins WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setUserId(rs.getInt("userId"));
                    admin.setRole(rs.getString("role"));
                    admin.setPermissions(rs.getString("permissions"));
                    return admin;
                }
            }
        }
        return null;
    }
    
    public boolean createAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO Admins (userId, role, permissions) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, admin.getUserId());
            ps.setString(2, admin.getRole());
            ps.setString(3, admin.getPermissions() != null ? admin.getPermissions() : "{}");
            
            return ps.executeUpdate() > 0;
        }
    }
}