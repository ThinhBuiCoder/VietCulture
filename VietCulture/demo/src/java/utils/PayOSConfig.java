package utils;

import vn.payos.PayOS;

/**
 * Cấu hình PayOS.
 */
public class PayOSConfig {

    // Các thông tin xác thực từ PayOS (Client ID, Api Key, Checksum Key)
    public static final String CLIENT_ID = "283be80f-75a2-42d0-9328-29bf371ee4fa";
    public static final String API_KEY = "b1c4a6b9-5626-412b-8e30-da48c324368e";
    public static final String CHECKSUM_KEY = "ace17b6993ee4e4c10f022113d6026d9cee7fea6ee7cda189047d4ced38d6c3f";

    /**
     * Trả về đối tượng PayOS đã khởi tạo.
     */
    public static PayOS getPayOS() {
        return new PayOS(CLIENT_ID, API_KEY, CHECKSUM_KEY);
    }
}
