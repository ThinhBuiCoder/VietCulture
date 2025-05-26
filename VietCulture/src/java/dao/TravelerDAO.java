package dao;

import model.Traveler;
import utils.DBUtils;
import java.sql.*;
import java.util.logging.Logger;
import java.util.logging.Level;

public class TravelerDAO {
    private static final Logger LOGGER = Logger.getLogger(TravelerDAO.class.getName());
    
    public Traveler getTravelerByUserId(int userId) throws SQLException {
        String sql = "SELECT userId, preferences, totalBookings FROM Travelers WHERE userId = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Traveler traveler = new Traveler();
                    traveler.setUserId(rs.getInt("userId"));
                    traveler.setPreferences(rs.getString("preferences"));
                    traveler.setTotalBookings(rs.getInt("totalBookings"));
                    return traveler;
                }
            }
        }
        return null;
    }
    
    public boolean createTraveler(Traveler traveler) throws SQLException {
        String sql = "INSERT INTO Travelers (userId, preferences, totalBookings) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, traveler.getUserId());
            ps.setString(2, traveler.getPreferences() != null ? traveler.getPreferences() : "{}");
            ps.setInt(3, 0);
            
            return ps.executeUpdate() > 0;
        }
    }
}