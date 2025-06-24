package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Tiện ích kết nối cơ sở dữ liệu.
 */
public class DatabaseUtils {
<<<<<<< HEAD

=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    // Thay đổi các giá trị sau cho phù hợp với cấu hình SQL Server của bạn
    private static final String DB_URL = "jdbc:sqlserver://LAPTOP-MBT88TH7\\SQLEXPRESS;databaseName=payOS;encrypt=true;trustServerCertificate=true;";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "123";

    static {
        try {
            // Đăng ký driver (không bắt buộc nếu JDBC tự load driver)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Trả về kết nối đến cơ sở dữ liệu.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
