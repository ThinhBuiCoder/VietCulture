package com.chatbot.dao;

import com.chatbot.model.Experience;
import com.chatbot.model.Accommodation;
import com.chatbot.model.City;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TravelDAO {
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;
    
    // 1. Tìm kiếm trải nghiệm theo từ khóa
    public List<Experience> searchExperiences(String keyword) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND (e.title LIKE ? OR e.description LIKE ? OR e.type LIKE ? OR c.vietnameseName LIKE ?)";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            String searchTerm = "%" + keyword + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ps.setString(4, searchTerm);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // 2. Tìm kiếm nơi lưu trú theo từ khóa
    public List<Accommodation> searchAccommodations(String keyword) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        String query = "SELECT a.accommodationId, a.name, a.description, a.address, a.type, " +
                      "a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, " +
                      "a.images, a.averageRating, a.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Accommodations a " +
                      "JOIN Cities c ON a.cityId = c.cityId " +
                      "JOIN Users u ON a.hostId = u.userId " +
                      "WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 " +
                      "AND (a.name LIKE ? OR a.description LIKE ? OR a.type LIKE ? OR c.vietnameseName LIKE ?)";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            String searchTerm = "%" + keyword + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ps.setString(4, searchTerm);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
    // 3. Lấy trải nghiệm theo thành phố
    public List<Experience> getExperiencesByCity(String cityName, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND c.vietnameseName LIKE ? " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setString(2, "%" + cityName + "%");
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // 4. Lấy nơi lưu trú theo thành phố
    public List<Accommodation> getAccommodationsByCity(String cityName, int limit) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        String query = "SELECT TOP (?) a.accommodationId, a.name, a.description, a.address, a.type, " +
                      "a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, " +
                      "a.images, a.averageRating, a.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Accommodations a " +
                      "JOIN Cities c ON a.cityId = c.cityId " +
                      "JOIN Users u ON a.hostId = u.userId " +
                      "WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 " +
                      "AND c.vietnameseName LIKE ? " +
                      "ORDER BY a.averageRating DESC, a.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setString(2, "%" + cityName + "%");
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
    
    // 5. Lấy trải nghiệm theo loại
    public List<Experience> getExperiencesByType(String type, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND e.type LIKE ? " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setString(2, "%" + type + "%");
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // 6. Lấy nơi lưu trú theo loại
    public List<Accommodation> getAccommodationsByType(String type, int limit) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        String query = "SELECT TOP (?) a.accommodationId, a.name, a.description, a.address, a.type, " +
                      "a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, " +
                      "a.images, a.averageRating, a.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Accommodations a " +
                      "JOIN Cities c ON a.cityId = c.cityId " +
                      "JOIN Users u ON a.hostId = u.userId " +
                      "WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 " +
                      "AND a.type = ? " +
                      "ORDER BY a.averageRating DESC, a.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setString(2, type);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
   // 7. Lấy tất cả trải nghiệm (với limit) - METHOD THIẾU TRONG CODE CŨ
    public List<Experience> getAllExperiences(int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // 8. Lấy tất cả chỗ ở (với limit) - METHOD THIẾU TRONG CODE CŨ
    public List<Accommodation> getAllAccommodations(int limit) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        String query = "SELECT TOP (?) a.accommodationId, a.name, a.description, a.address, a.type, " +
                      "a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, " +
                      "a.images, a.averageRating, a.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Accommodations a " +
                      "JOIN Cities c ON a.cityId = c.cityId " +
                      "JOIN Users u ON a.hostId = u.userId " +
                      "WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 " +
                      "ORDER BY a.averageRating DESC, a.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
    
    // 10. Lấy nơi lưu trú theo khoảng giá
    public List<Accommodation> getAccommodationsByPriceRange(double minPrice, double maxPrice, int limit) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        String query = "SELECT TOP (?) a.accommodationId, a.name, a.description, a.address, a.type, " +
                      "a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, " +
                      "a.images, a.averageRating, a.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Accommodations a " +
                      "JOIN Cities c ON a.cityId = c.cityId " +
                      "JOIN Users u ON a.hostId = u.userId " +
                      "WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 " +
                      "AND a.pricePerNight BETWEEN ? AND ? " +
                      "ORDER BY a.pricePerNight";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setDouble(2, minPrice);
            ps.setDouble(3, maxPrice);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
    
    // 11. Lấy trải nghiệm phổ biến (nhiều booking nhất)
    public List<Experience> getPopularExperiences(int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "ORDER BY e.totalBookings DESC, e.averageRating DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // 12. Lấy nơi lưu trú phổ biến
    public List<Accommodation> getPopularAccommodations(int limit) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        String query = "SELECT TOP (?) a.accommodationId, a.name, a.description, a.address, a.type, " +
                      "a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, " +
                      "a.images, a.averageRating, a.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Accommodations a " +
                      "JOIN Cities c ON a.cityId = c.cityId " +
                      "JOIN Users u ON a.hostId = u.userId " +
                      "WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 " +
                      "ORDER BY a.totalBookings DESC, a.averageRating DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
    // 13. Lấy danh sách các thành phố
    public List<City> getAllCities() throws Exception {
        List<City> cities = new ArrayList<>();
        String query = "SELECT cityId, name, vietnameseName, description, imageUrl, attractions " +
                      "FROM Cities ORDER BY vietnameseName";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                City city = new City();
                city.setCityId(rs.getInt("cityId"));
                city.setName(rs.getString("name"));
                city.setVietnameseName(rs.getString("vietnameseName"));
                city.setDescription(rs.getString("description"));
                city.setImageUrl(rs.getString("imageUrl"));
                city.setAttractions(rs.getString("attractions"));
                cities.add(city);
            }
        } finally {
            closeConnections();
        }
        return cities;
    }
    
    // 14. Lấy trải nghiệm theo độ khó
    public List<Experience> getExperiencesByDifficulty(String difficulty, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND e.difficulty = ? " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setString(2, difficulty);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // 15. Lấy gợi ý dựa trên booking history của user
    public List<Experience> getRecommendedExperiences(String userEmail, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "JOIN Bookings b ON e.experienceId = b.experienceId " +
                      "JOIN Users traveler ON b.travelerId = traveler.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND traveler.email = ? " +
                      "AND b.status = 'COMPLETED' " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, limit);
            ps.setString(2, userEmail);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // Lấy trải nghiệm theo thành phố và loại
    public List<Experience> getExperiencesByCityAndType(String cityName, String type, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP " + limit + " e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND c.vietnameseName LIKE ? " +
                      "AND e.type LIKE ? " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + cityName + "%");
            ps.setString(2, "%" + type + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // Lấy trải nghiệm theo khu vực (region) và loại
    public List<Experience> getExperiencesByRegionAndType(String region, String type, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP " + limit + " e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                      "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                      "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                      "c.vietnameseName as cityName, u.fullName as hostName " +
                      "FROM Experiences e " +
                      "JOIN Cities c ON e.cityId = c.cityId " +
                      "JOIN Regions r ON c.regionId = r.regionId " +
                      "JOIN Users u ON e.hostId = u.userId " +
                      "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                      "AND r.name = ? " +
                      "AND e.type LIKE ? " +
                      "ORDER BY e.averageRating DESC, e.totalBookings DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, region);
            ps.setString(2, "%" + type + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // Lấy trải nghiệm theo khoảng giá và thành phố
    public List<Experience> getExperiencesByPriceRange(double minPrice, double maxPrice, String cityName, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        StringBuilder query = new StringBuilder();
        query.append("SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, ")
             .append("e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, ")
             .append("e.requirements, e.images, e.averageRating, e.totalBookings, ")
             .append("c.vietnameseName as cityName, u.fullName as hostName ")
             .append("FROM Experiences e ")
             .append("JOIN Cities c ON e.cityId = c.cityId ")
             .append("JOIN Users u ON e.hostId = u.userId ")
             .append("WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 ")
             .append("AND e.price BETWEEN ? AND ? ");
        if (cityName != null && !cityName.trim().isEmpty()) {
            query.append("AND c.vietnameseName LIKE ? ");
        }
        query.append("ORDER BY e.price ASC, e.averageRating DESC, e.totalBookings DESC");
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query.toString());
            ps.setInt(1, limit);
            ps.setDouble(2, minPrice);
            ps.setDouble(3, maxPrice);
            int paramIdx = 4;
            if (cityName != null && !cityName.trim().isEmpty()) {
                ps.setString(paramIdx, "%" + cityName + "%");
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // Lấy chỗ ở theo khoảng giá và thành phố
    public List<Accommodation> getAccommodationsByPriceRangeAndCity(double minPrice, double maxPrice, String cityName, int limit) throws Exception {
        List<Accommodation> accommodations = new ArrayList<>();
        StringBuilder query = new StringBuilder();
        query.append("SELECT TOP (?) a.accommodationId, a.name, a.description, a.address, a.type, a.numberOfRooms, a.maxOccupancy, a.amenities, a.pricePerNight, a.images, a.averageRating, a.totalBookings, c.vietnameseName as cityName, u.fullName as hostName ")
             .append("FROM Accommodations a ")
             .append("JOIN Cities c ON a.cityId = c.cityId ")
             .append("JOIN Users u ON a.hostId = u.userId ")
             .append("WHERE a.adminApprovalStatus = 'APPROVED' AND a.isActive = 1 ")
             .append("AND a.pricePerNight BETWEEN ? AND ? ");
        if (cityName != null && !cityName.trim().isEmpty()) {
            query.append("AND c.vietnameseName LIKE ? ");
        }
        query.append("ORDER BY a.pricePerNight ASC, a.averageRating DESC, a.totalBookings DESC");
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query.toString());
            ps.setInt(1, limit);
            ps.setDouble(2, minPrice);
            ps.setDouble(3, maxPrice);
            int paramIdx = 4;
            if (cityName != null && !cityName.trim().isEmpty()) {
                ps.setString(paramIdx, "%" + cityName + "%");
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation acc = new Accommodation();
                acc.setAccommodationId(rs.getInt("accommodationId"));
                acc.setName(rs.getString("name"));
                acc.setDescription(rs.getString("description"));
                acc.setAddress(rs.getString("address"));
                acc.setType(rs.getString("type"));
                acc.setNumberOfRooms(rs.getInt("numberOfRooms"));
                acc.setMaxOccupancy(rs.getInt("maxOccupancy"));
                acc.setAmenities(rs.getString("amenities"));
                acc.setPricePerNight(rs.getDouble("pricePerNight"));
                acc.setImages(rs.getString("images"));
                acc.setAverageRating(rs.getFloat("averageRating"));
                acc.setTotalBookings(rs.getInt("totalBookings"));
                acc.setCityName(rs.getString("cityName"));
                acc.setHostName(rs.getString("hostName"));
                accommodations.add(acc);
            }
        } finally {
            closeConnections();
        }
        return accommodations;
    }
    
    // Lấy trải nghiệm theo city, type và price range
    public List<Experience> getExperiencesByPriceRangeAndType(double minPrice, double maxPrice, String cityName, String type, int limit) throws Exception {
        List<Experience> experiences = new ArrayList<>();
        String query = "SELECT TOP (?) e.experienceId, e.title, e.description, e.location, e.type, e.price, " +
                "e.maxGroupSize, e.duration, e.difficulty, e.language, e.includedItems, " +
                "e.requirements, e.images, e.averageRating, e.totalBookings, " +
                "c.vietnameseName as cityName, u.fullName as hostName " +
                "FROM Experiences e " +
                "JOIN Cities c ON e.cityId = c.cityId " +
                "JOIN Users u ON e.hostId = u.userId " +
                "WHERE e.adminApprovalStatus = 'APPROVED' AND e.isActive = 1 " +
                "AND e.price >= ? AND e.price <= ? " +
                (cityName != null && !cityName.isEmpty() ? "AND c.vietnameseName LIKE ? " : "") +
                "AND e.type LIKE ? " +
                "ORDER BY e.price ASC, e.averageRating DESC, e.totalBookings DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            int idx = 1;
            ps.setInt(idx++, limit);
            ps.setDouble(idx++, minPrice);
            ps.setDouble(idx++, maxPrice);
            if (cityName != null && !cityName.isEmpty()) {
                ps.setString(idx++, "%" + cityName + "%");
            }
            ps.setString(idx++, "%" + type + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setExperienceId(rs.getInt("experienceId"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setLocation(rs.getString("location"));
                exp.setType(rs.getString("type"));
                exp.setPrice(rs.getDouble("price"));
                exp.setMaxGroupSize(rs.getInt("maxGroupSize"));
                exp.setDuration(rs.getString("duration"));
                exp.setDifficulty(rs.getString("difficulty"));
                exp.setLanguage(rs.getString("language"));
                exp.setIncludedItems(rs.getString("includedItems"));
                exp.setRequirements(rs.getString("requirements"));
                exp.setImages(rs.getString("images"));
                exp.setAverageRating(rs.getFloat("averageRating"));
                exp.setTotalBookings(rs.getInt("totalBookings"));
                exp.setCityName(rs.getString("cityName"));
                exp.setHostName(rs.getString("hostName"));
                experiences.add(exp);
            }
        } finally {
            closeConnections();
        }
        return experiences;
    }
    
    // Helper method to close connections
    private void closeConnections() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}