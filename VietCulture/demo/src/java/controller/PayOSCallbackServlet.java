package controller;

import dao.BookingDAO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

/**
 * Servlet xử lý callback webhook từ PayOS. Sử dụng manual JSON parsing để tránh
 * dependency issues với PayOS SDK 1.0.3
 */
@WebServlet("/payos-callback")
public class PayOSCallbackServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");

        try {
            // Đọc JSON body từ PayOS
            StringBuilder jsonString = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonString.append(line);
                }
            }

            String webhookBody = jsonString.toString();
            System.out.println("PayOS Webhook received: " + webhookBody);

            if (webhookBody.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Empty webhook body");
                return;
            }

            // Xử lý webhook - sử dụng manual parsing thay vì SDK
            // Vì PayOS SDK 1.0.3 có Webhook constructor phức tạp
            boolean paymentProcessed = processPaymentWebhookManual(webhookBody);

            if (paymentProcessed) {
                // Trả về 200 OK cho PayOS
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Failed to process webhook");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error processing PayOS webhook: " + e.getMessage());

            // Trả về lỗi 500
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    /**
     * Xử lý webhook với manual JSON parsing - đơn giản và ổn định
     */
    private boolean processPaymentWebhookManual(String webhookBody) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(webhookBody);

            // PayOS webhook structure:
            // {
            //   "code": "00",
            //   "desc": "success", 
            //   "success": true,
            //   "data": {
            //     "orderCode": 123,
            //     "amount": 50000,
            //     "description": "...",
            //     "accountNumber": "...",
            //     "reference": "...",
            //     "transactionDateTime": "...",
            //     "paymentLinkId": "...",
            //     "code": "00",
            //     "desc": "Thành công"
            //   },
            //   "signature": "..."
            // }
            String code = rootNode.get("code").asText();
            JsonNode dataNode = rootNode.get("data");

            if (dataNode != null) {
                long orderCode = dataNode.get("orderCode").asLong();
                String dataCode = dataNode.has("code") ? dataNode.get("code").asText() : code;
                String desc = dataNode.has("desc") ? dataNode.get("desc").asText() : "No description";

                int bookingID = (int) orderCode;

                // Cập nhật trạng thái thanh toán
                String paymentStatus;
                if ("00".equals(code) && "00".equals(dataCode)) {
                    paymentStatus = "Paid";
                    System.out.println("Payment successful for booking ID: " + bookingID);
                } else {
                    paymentStatus = "Failed";
                    System.out.println("Payment failed for booking ID: " + bookingID + ", reason: " + desc);
                }

                boolean updated = bookingDAO.updatePaymentStatus(bookingID, paymentStatus);
                if (updated) {
                    System.out.println("Updated payment status to: " + paymentStatus + " for booking: " + bookingID);
                    return true;
                } else {
                    System.err.println("Failed to update payment status for booking: " + bookingID);
                    return false;
                }

            } else {
                System.err.println("No data node found in webhook");
                return false;
            }

        } catch (Exception e) {
            System.err.println("Error in manual webhook processing: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // PayOS sử dụng POST, nhưng có thể cần GET cho test
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write("PayOS Callback endpoint is working!");
    }
}
