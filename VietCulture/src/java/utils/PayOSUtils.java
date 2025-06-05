package utils;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * PayOS Integration Utils - Không cần Maven
 * Tải các file JAR cần thiết:
 * 1. gson-2.10.1.jar từ https://github.com/google/gson/releases
 * 2. Hoặc sử dụng JSON parsing manual như dưới đây
 */
public class PayOSUtils {
    private static final Logger LOGGER = Logger.getLogger(PayOSUtils.class.getName());
    
    // PayOS Configuration - Lấy từ PayOS Dashboard
    private static final String CLIENT_ID = "c8808ca8-6183-4cc4-bd68-e1f278f5fe7d";
    private static final String API_KEY = "2202e203-d95a-4f6b-bf8f-db1a3bcec1c0";
    private static final String CHECKSUM_KEY = "d6e0e013bffc980473af930350d0237df45a7be90cdb40b2aa3c1af7aa884c7b";
    private static final String PAYOS_API_URL = "https://api-merchant.payos.vn/v2/payment-requests";
    
    /**
     * Tạo payment link với PayOS
     */
    public static PayOSResponse createPaymentLink(PayOSRequest request) {
        try {
            // Tạo signature
            String signature = createSignature(request);
            
            // Tạo JSON request body
            String jsonBody = createJsonRequest(request, signature);
            
            // Gửi HTTP POST request
            String response = sendHttpPost(PAYOS_API_URL, jsonBody);
            
            // Parse response
            return parseResponse(response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating PayOS payment link", e);
            return PayOSResponse.error("Lỗi tạo link thanh toán: " + e.getMessage());
        }
    }
    
    /**
     * Tạo payment link giả lập cho testing
     */
    public static PayOSResponse createPaymentLinkSimulated(PayOSRequest request) {
        try {
            // Giả lập response thành công
            String checkoutUrl = "https://payos.vn/simulated-checkout/" + request.getOrderCode();
            return PayOSResponse.success(checkoutUrl, request.getOrderCode(), "simulated-" + request.getOrderCode());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating simulated PayOS payment link", e);
            return PayOSResponse.error("Lỗi tạo link thanh toán giả lập: " + e.getMessage());
        }
    }
    
    /**
     * Xác minh trạng thái thanh toán
     */
    public static boolean verifyPaymentStatus(long orderCode) {
        try {
            String url = PAYOS_API_URL + "/" + orderCode;
            String response = sendHttpGet(url);
            
            // Parse response để kiểm tra trạng thái
            String status = extractJsonValue(response, "status");
            return "PAID".equalsIgnoreCase(status);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying payment status for order: " + orderCode, e);
            return false;
        }
    }
    
    /**
     * Hủy payment link
     */
    public static boolean cancelPaymentLink(long orderCode, String reason) {
        try {
            String url = PAYOS_API_URL + "/" + orderCode + "/cancel";
            String jsonBody = "{\"cancellationReason\":\"" + escapeJson(reason) + "\"}";
            
            String response = sendHttpPost(url, jsonBody);
            String code = extractJsonValue(response, "code");
            return "00".equals(code);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error cancelling payment link for order: " + orderCode, e);
            return false;
        }
    }
    
    /**
     * Xử lý PayOS webhook
     */
    public static PayOSWebhookData processWebhook(String webhookBody, String signature) {
        try {
            // Xác minh signature
            if (!verifyWebhookSignature(webhookBody, signature)) {
                LOGGER.warning("Invalid webhook signature");
                return null;
            }
            
            // Parse webhook body
            PayOSWebhookData data = new PayOSWebhookData();
            data.orderCode = Long.parseLong(extractJsonValue(webhookBody, "orderCode"));
            data.status = extractJsonValue(webhookBody, "status");
            data.amount = Long.parseLong(extractJsonValue(webhookBody, "amount"));
            
            return data;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing PayOS webhook", e);
            return null;
        }
    }
    
    /**
     * Tạo signature cho PayOS
     */
    private static String createSignature(PayOSRequest request) throws Exception {
        String data = String.format("amount=%d&cancelUrl=%s&description=%s&orderCode=%d&returnUrl=%s",
                request.getAmount(),
                request.getCancelUrl(),
                request.getDescription(),
                request.getOrderCode(),
                request.getReturnUrl()
        );
        
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(CHECKSUM_KEY.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        mac.init(secretKeySpec);
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        
        StringBuilder result = new StringBuilder();
        for (byte b : hash) {
            result.append(String.format("%02x", b));
        }
        
        return result.toString();
    }
    
    /**
     * Tạo JSON request body
     */
    private static String createJsonRequest(PayOSRequest request, String signature) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"orderCode\":").append(request.getOrderCode()).append(",");
        json.append("\"amount\":").append(request.getAmount()).append(",");
        json.append("\"description\":\"").append(escapeJson(request.getDescription())).append("\",");
        json.append("\"cancelUrl\":\"").append(request.getCancelUrl()).append("\",");
        json.append("\"returnUrl\":\"").append(request.getReturnUrl()).append("\",");
        json.append("\"signature\":\"").append(signature).append("\"");
        
        if (request.getBuyerName() != null) {
            json.append(",\"buyerInfo\":{");
            json.append("\"name\":\"").append(escapeJson(request.getBuyerName())).append("\",");
            json.append("\"email\":\"").append(request.getBuyerEmail()).append("\",");
            json.append("\"phone\":\"").append(request.getBuyerPhone()).append("\"");
            json.append("}");
        }
        
        if (request.getItems() != null && !request.getItems().isEmpty()) {
            json.append(",\"items\":[");
            for (int i = 0; i < request.getItems().size(); i++) {
                PayOSItem item = request.getItems().get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"name\":\"").append(escapeJson(item.getName())).append("\",");
                json.append("\"quantity\":").append(item.getQuantity()).append(",");
                json.append("\"price\":").append(item.getPrice());
                json.append("}");
            }
            json.append("]");
        }
        
        json.append("}");
        return json.toString();
    }
    
    /**
     * Escape JSON strings
     */
    private static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
    
    /**
     * Gửi HTTP POST request
     */
    private static String sendHttpPost(String urlString, String jsonBody) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setRequestProperty("x-client-id", CLIENT_ID);
        connection.setRequestProperty("x-api-key", API_KEY);
        connection.setRequestProperty("x-partner-code", "VIETCULTURE");
        connection.setDoOutput(true);
        
        try (OutputStream os = connection.getOutputStream()) {
            byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }
        
        int responseCode = connection.getResponseCode();
        InputStream inputStream = responseCode >= 200 && responseCode < 300 
            ? connection.getInputStream() 
            : connection.getErrorStream();
            
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }
        
        if (responseCode >= 400) {
            throw new IOException("HTTP Error " + responseCode + ": " + response.toString());
        }
        
        return response.toString();
    }
    
    /**
     * Gửi HTTP GET request
     */
    private static String sendHttpGet(String urlString) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        connection.setRequestMethod("GET");
        connection.setRequestProperty("x-client-id", CLIENT_ID);
        connection.setRequestProperty("x-api-key", API_KEY);
        
        int responseCode = connection.getResponseCode();
        InputStream inputStream = responseCode >= 200 && responseCode < 300 
            ? connection.getInputStream() 
            : connection.getErrorStream();
            
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }
        
        if (responseCode >= 400) {
            throw new IOException("HTTP Error " + responseCode + ": " + response.toString());
        }
        
        return response.toString();
    }
    
    /**
     * Parse JSON response
     */
    private static PayOSResponse parseResponse(String jsonResponse) {
        try {
            String code = extractJsonValue(jsonResponse, "code");
            String desc = extractJsonValue(jsonResponse, "desc");
            String checkoutUrl = extractJsonValue(jsonResponse, "checkoutUrl");
            String qrCode = extractJsonValue(jsonResponse, "qrCode");
            String paymentLinkId = extractJsonValue(jsonResponse, "paymentLinkId");
            String orderCode = extractJsonValue(jsonResponse, "orderCode");
            
            boolean success = "00".equals(code);
            PayOSResponse response = new PayOSResponse(success, desc);
            response.setCheckoutUrl(checkoutUrl);
            response.setQrCode(qrCode);
            response.setPaymentLinkId(paymentLinkId);
            if (orderCode != null) {
                response.setOrderCode(Long.parseLong(orderCode));
            }
            
            return response;
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error parsing PayOS response", e);
            return PayOSResponse.error("Lỗi xử lý phản hồi từ PayOS");
        }
    }
    
    /**
     * Extract value from JSON string
     */
    private static String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\":";
        int startIndex = json.indexOf(searchKey);
        if (startIndex == -1) return null;
        
        startIndex += searchKey.length();
        while (startIndex < json.length() && Character.isWhitespace(json.charAt(startIndex))) {
            startIndex++;
        }
        
        if (startIndex >= json.length()) return null;
        
        if (json.charAt(startIndex) == '"') {
            startIndex++;
            int endIndex = json.indexOf('"', startIndex);
            if (endIndex == -1) return null;
            return json.substring(startIndex, endIndex);
        } else {
            int endIndex = startIndex;
            while (endIndex < json.length() && 
                   json.charAt(endIndex) != ',' && 
                   json.charAt(endIndex) != '}' && 
                   json.charAt(endIndex) != ']') {
                endIndex++;
            }
            return json.substring(startIndex, endIndex).trim();
        }
    }
    
    /**
     * Verify webhook signature
     */
    public static boolean verifyWebhookSignature(String webhookBody, String receivedSignature) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(CHECKSUM_KEY.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] hash = mac.doFinal(webhookBody.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder expectedSignature = new StringBuilder();
            for (byte b : hash) {
                expectedSignature.append(String.format("%02x", b));
            }
            
            return expectedSignature.toString().equals(receivedSignature);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying webhook signature", e);
            return false;
        }
    }
    
    /**
     * Tạo order code unique
     */
    public static long generateOrderCode() {
        return System.currentTimeMillis() / 1000;
    }
    
    /**
     * PayOS Webhook Data Model
     */
    public static class PayOSWebhookData {
        private long orderCode;
        private String status;
        private long amount;
        
        public long getOrderCode() { return orderCode; }
        public String getStatus() { return status; }
        public long getAmount() { return amount; }
        
        public boolean isPaid() { return "PAID".equalsIgnoreCase(status); }
        public boolean isCancelled() { return "CANCELLED".equalsIgnoreCase(status); }
    }
}