<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtils" %>
<%@ page import="dao.ExperienceDAO" %>
<%@ page import="dao.UserDAO" %>

<!DOCTYPE html>
<html>
<head>
    <title>Database Test</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <h2>1. Connection Test</h2>
    <%
    try {
        Connection conn = DBUtils.getConnection();
        out.println("<p style='color: green;'>✅ Database connection successful!</p>");
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color: red;'>❌ Database connection failed: " + e.getMessage() + "</p>");
    }
    %>
    
    <h2>2. Experiences Table Test</h2>
    <%
    try {
        ExperienceDAO expDAO = new ExperienceDAO();
        
        // Test total count
        int totalExp = expDAO.getTotalExperiencesCount();
        out.println("<p>Total experiences: " + totalExp + "</p>");
        
        // Test pending count
        int pendingExp = expDAO.getPendingExperiencesCount();
        out.println("<p>Pending experiences: " + pendingExp + "</p>");
        
        // Test approved count
        int approvedExp = expDAO.getApprovedExperiencesCount();
        out.println("<p>Approved experiences: " + approvedExp + "</p>");
        
        // Show recent experiences
        out.println("<h3>Recent Experiences:</h3>");
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT TOP 5 experienceId, title, isActive, createdAt FROM Experiences ORDER BY createdAt DESC")) {
            ResultSet rs = ps.executeQuery();
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Title</th><th>isActive</th><th>Created</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("experienceId") + "</td>");
                out.println("<td>" + rs.getString("title") + "</td>");
                out.println("<td>" + rs.getBoolean("isActive") + "</td>");
                out.println("<td>" + rs.getDate("createdAt") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        
    } catch (Exception e) {
        out.println("<p style='color: red;'>❌ Error testing experiences: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
    
    <h2>3. Users Table Test</h2>
    <%
    try {
        UserDAO userDAO = new UserDAO();
        int totalUsers = userDAO.getTotalUsersCount();
        out.println("<p>Total users: " + totalUsers + "</p>");
        
        // Show admin users
        out.println("<h3>Admin Users:</h3>");
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT userId, email, fullName, role FROM Users WHERE role = 'ADMIN'")) {
            ResultSet rs = ps.executeQuery();
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Email</th><th>Name</th><th>Role</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("userId") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("fullName") + "</td>");
                out.println("<td>" + rs.getString("role") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        
    } catch (Exception e) {
        out.println("<p style='color: red;'>❌ Error testing users: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
    
    <h2>4. Database Schema Test</h2>
    <%
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(
             "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'")) {
        ResultSet rs = ps.executeQuery();
        out.println("<p>Available tables:</p>");
        out.println("<ul>");
        while (rs.next()) {
            out.println("<li>" + rs.getString("TABLE_NAME") + "</li>");
        }
        out.println("</ul>");
    } catch (Exception e) {
        out.println("<p style='color: red;'>❌ Error getting table list: " + e.getMessage() + "</p>");
    }
    %>
</body>
</html> 