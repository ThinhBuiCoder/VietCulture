package com.chatbot.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=TravelerDB;encrypt=true;trustServerCertificate=true";
    private static final String USERNAME = "sa"; // Thay đổi theo config của bạn
    private static final String PASSWORD = "123"; // Thay đổi theo config của bạn
    
    public Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }
    }
}