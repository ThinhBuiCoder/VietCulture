package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBUtils {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Sử dụng Logger thay cho System.out
    private static final Logger LOGGER = Logger.getLogger(DBUtils.class.getName());

    // Cấu hình kết nối database
<<<<<<< HEAD
<<<<<<< HEAD
    private static final String DB_URL = "jdbc:sqlserver://LAPTOP-MBT88TH7\\SQLEXPRESS;databaseName=TravelerDB_b;encrypt=true;trustServerCertificate=true";
=======
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=TravelerDB;encrypt=true;trustServerCertificate=true";
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
=======
    private static final String DB_URL = "jdbc:sqlserver://DESKTOP-09LI1S6\\SQLEXPRESS;databaseName=TravelerDB_b;encrypt=true;trustServerCertificate=true";
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123";

    // Prevent instantiation
    private DBUtils() {
        throw new IllegalStateException("Utility class");
    }

    // Static block để đảm bảo driver được nạp
    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            LOGGER.info("JDBC Driver registered successfully");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "JDBC Driver not found", e);
            throw new ExceptionInInitializerError(e);
        }
    }

    /**
     * Lấy kết nối đến database
<<<<<<< HEAD
     *
=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @return Connection tới database
     * @throws SQLException nếu không thể kết nối
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
            LOGGER.info("Database connection established successfully");
            return connection;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection error", e);
            throw e;
        }
    }

    /**
     * Đóng kết nối an toàn
<<<<<<< HEAD
     *
=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param conn Connection cần đóng
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                LOGGER.info("Database connection closed successfully");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing database connection", e);
            }
        }
    }

    /**
     * Kiểm tra kết nối database
<<<<<<< HEAD
     *
=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @return true nếu kết nối thành công, false nếu không
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            LOGGER.info("Connection test passed successfully");
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Connection test failed", e);
            return false;
        }
    }

    /**
     * Kiểm tra thông tin kết nối
<<<<<<< HEAD
     *
=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @return Thông tin chi tiết về kết nối
     */
    public static String getConnectionInfo() {
        return String.format("Database URL: %s, Username: %s", DB_URL, USERNAME);
    }

    /**
     * Main method để kiểm tra kết nối trực tiếp
<<<<<<< HEAD
     *
=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param args Tham số dòng lệnh
     */
    public static void main(String[] args) {
        LOGGER.info("Testing database connection...");
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        if (testConnection()) {
            LOGGER.info("Connection successful!");
            LOGGER.info("Connection Details: " + getConnectionInfo());
        } else {
            LOGGER.severe("Connection failed. Please check your database configuration.");
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
