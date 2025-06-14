package service;

import model.Booking;
import utils.PayOSConfig;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonElement;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.Scanner;

/**
 * PayOS Service with Complete Debug Logging
 * Version: Debug - Will show EXACTLY what PayOS returns
 */
public class PayOSService {
    
    private static final Logger LOGGER = Logger.getLogger(PayOSService.class.getName());
    private final Gson gson = new Gson();
    
    private static final String PAYOS_BASE_URL = "https://api-merchant.payos.vn";
    
    public PayOSService() {
        try {
            PayOSConfig.validateConfiguration();
            System.out.println("\n🔧 PAYOS SERVICE INITIALIZED");
            System.out.println("================================");
            System.out.println("Mock Mode: " + PayOSConfig.ENABLE_MOCK_MODE);
            System.out.println("Base URL: " + getBaseUrl());
            System.out.println("Client ID: " + (PayOSConfig.CLIENT_ID != null ? PayOSConfig.CLIENT_ID.substring(0, 8) + "..." : "null"));
            System.out.println("================================\n");
        } catch (IllegalStateException e) {
            LOGGER.log(Level.SEVERE, "PayOS configuration error", e);
            throw e;
        }
    }
    
    private String getBaseUrl() {
        if (PayOSConfig.ENABLE_MOCK_MODE) {
            return "http://localhost:8080/mock-payos";
        }
        return PAYOS_BASE_URL;
    }
    
    /**
     * Create payment for booking with complete debugging
     */
    public PaymentResponse createBookingPayment(Booking booking, String returnUrl, String cancelUrl) 
            throws PayOSException {
        
        System.out.println("\n🚀 ===== CREATE PAYMENT SESSION =====");
        System.out.println("Session ID: " + System.currentTimeMillis());
        System.out.println("Timestamp: " + new java.util.Date());
        System.out.println("====================================");
        
        if (PayOSConfig.ENABLE_MOCK_MODE) {
            System.out.println("🧪 MOCK MODE ACTIVE - Creating fake payment");
            return createMockPayment(booking, returnUrl, cancelUrl);
        }
        
        try {
            // Prepare payment data
            long orderCode = generateOrderCode();
            int amount = PayOSConfig.formatAmount(booking.getTotalPrice());
            
            System.out.println("📊 Payment Request Details:");
            System.out.println("  Booking ID: " + booking.getBookingId());
            System.out.println("  Order Code: " + orderCode);
            System.out.println("  Amount: " + amount + " VND");
            System.out.println("  Description: " + generateDescription(booking));
            System.out.println("  Return URL: " + returnUrl);
            System.out.println("  Cancel URL: " + cancelUrl);
            
            if (!PayOSConfig.isValidAmount(amount)) {
                throw new PayOSException("Số tiền không hợp lệ: " + PayOSConfig.formatVND(amount));
            }
            
            // Build request payload
            Map<String, Object> paymentRequest = buildPaymentRequest(
                orderCode, amount, generateDescription(booking),
                returnUrl, cancelUrl, booking
            );
            
            System.out.println("\n📤 Request Payload:");
            String requestJson = gson.toJson(paymentRequest);
            System.out.println(requestJson);
            
            // Send to PayOS with complete debugging
            JsonObject response = sendToPayOSWithCompleteDebug("POST", "/v2/payment-requests", paymentRequest);
            
            // Parse with complete debugging
            PaymentResponse paymentResponse = parseWithCompleteDebug(response, orderCode);
            
            booking.setPaymentOrderCode(orderCode);
            
            System.out.println("\n✅ ===== PAYMENT CREATION SUCCESS =====");
            System.out.println("Order Code: " + orderCode);
            System.out.println("Checkout URL: " + (paymentResponse.getCheckoutUrl() != null ? "✅ Present" : "❌ Missing"));
            System.out.println("QR Code: " + (paymentResponse.getQrCode() != null ? "✅ Present (" + paymentResponse.getQrCode().length() + " chars)" : "❌ Missing"));
            System.out.println("Payment Link ID: " + paymentResponse.getPaymentLinkId());
            System.out.println("======================================\n");
            
            return paymentResponse;
            
        } catch (PayOSException e) {
            System.err.println("\n❌ ===== PAYOS EXCEPTION =====");
            System.err.println("Error: " + e.getMessage());
            System.err.println("Network Error: " + e.isNetworkError());
            System.err.println("=============================\n");
            throw e;
        } catch (Exception e) {
            System.err.println("\n❌ ===== UNEXPECTED EXCEPTION =====");
            System.err.println("Type: " + e.getClass().getSimpleName());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
            System.err.println("==================================\n");
            throw new PayOSException("Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    /**
     * Send request to PayOS with complete debugging
     */
    private JsonObject sendToPayOSWithCompleteDebug(String method, String endpoint, Object requestBody) 
            throws PayOSException {
        
        HttpURLConnection connection = null;
        String fullUrl = getBaseUrl() + endpoint;
        
        System.out.println("\n🌐 ===== HTTP REQUEST DEBUG =====");
        System.out.println("Method: " + method);
        System.out.println("Full URL: " + fullUrl);
        System.out.println("Endpoint: " + endpoint);
        
        try {
            // Create connection
            URL url = new URL(fullUrl);
            connection = (HttpURLConnection) url.openConnection();
            
            // Set method and headers
            connection.setRequestMethod(method);
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            connection.setRequestProperty("x-client-id", PayOSConfig.CLIENT_ID);
            connection.setRequestProperty("x-api-key", PayOSConfig.API_KEY);
            connection.setRequestProperty("User-Agent", "VietCulture-Debug/1.0 (Java)");
            connection.setRequestProperty("Accept", "application/json");
            
            // Set timeouts
            connection.setConnectTimeout(30000);
            connection.setReadTimeout(30000);
            
            System.out.println("\n📋 Request Headers:");
            System.out.println("  Content-Type: application/json; charset=UTF-8");
            System.out.println("  x-client-id: " + PayOSConfig.CLIENT_ID);
            System.out.println("  x-api-key: " + PayOSConfig.API_KEY.substring(0, 8) + "...");
            System.out.println("  User-Agent: VietCulture-Debug/1.0 (Java)");
            System.out.println("  Accept: application/json");
            
            // Send body for POST requests
            if ("POST".equals(method) && requestBody != null) {
                connection.setDoOutput(true);
                String jsonBody = gson.toJson(requestBody);
                
                System.out.println("\n📤 Sending Request Body:");
                System.out.println("Body Length: " + jsonBody.length() + " characters");
                System.out.println("Body Content: " + jsonBody);
                
                try (OutputStream os = connection.getOutputStream()) {
                    byte[] bodyBytes = jsonBody.getBytes("UTF-8");
                    os.write(bodyBytes);
                    os.flush();
                    System.out.println("✅ Request body sent successfully (" + bodyBytes.length + " bytes)");
                }
            }
            
            // Get response
            System.out.println("\n📥 ===== HTTP RESPONSE DEBUG =====");
            
            int responseCode = connection.getResponseCode();
            String responseMessage = connection.getResponseMessage();
            
            System.out.println("Response Code: " + responseCode);
            System.out.println("Response Message: " + responseMessage);
            
            // Log ALL response headers
            System.out.println("\n📋 Response Headers:");
            connection.getHeaderFields().forEach((key, values) -> {
                System.out.println("  " + (key != null ? key : "[Status]") + ": " + values);
            });
            
            // Read response body
            Scanner scanner;
            boolean isErrorStream = false;
            
            try {
                scanner = new Scanner(connection.getInputStream(), "UTF-8");
                System.out.println("\n📥 Reading from InputStream (success)");
            } catch (IOException e) {
                scanner = new Scanner(connection.getErrorStream(), "UTF-8");
                isErrorStream = true;
                System.out.println("\n📥 Reading from ErrorStream (error)");
                System.out.println("InputStream Error: " + e.getMessage());
            }
            
            StringBuilder responseBuilder = new StringBuilder();
            int lineCount = 0;
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                responseBuilder.append(line);
                lineCount++;
            }
            scanner.close();
            
            String responseBody = responseBuilder.toString();
            
            System.out.println("\n📊 Response Body Analysis:");
            System.out.println("  Total Lines: " + lineCount);
            System.out.println("  Total Length: " + responseBody.length() + " characters");
            System.out.println("  Is Error Stream: " + isErrorStream);
            System.out.println("  First 200 chars: " + (responseBody.length() > 200 ? responseBody.substring(0, 200) + "..." : responseBody));
            
            System.out.println("\n📄 ===== COMPLETE RAW RESPONSE =====");
            System.out.println(responseBody);
            System.out.println("===================================");
            
            // Validate response
            if (responseBody.trim().isEmpty()) {
                System.err.println("❌ CRITICAL: Response body is empty!");
                throw new PayOSException("PayOS returned empty response");
            }
            
            // Check for HTML response
            if (responseBody.trim().startsWith("<")) {
                System.err.println("❌ CRITICAL: PayOS returned HTML instead of JSON!");
                System.err.println("This indicates:");
                System.err.println("  1. Wrong API endpoint URL");
                System.err.println("  2. PayOS server issues");
                System.err.println("  3. Firewall/proxy blocking");
                System.err.println("  4. DNS resolution issues");
                
                System.err.println("\nHTML Response (first 500 chars):");
                System.err.println(responseBody.substring(0, Math.min(500, responseBody.length())));
                
                throw new PayOSException("PayOS returned HTML instead of JSON - endpoint may be incorrect");
            }
            
            // Try to parse JSON
            JsonElement jsonElement;
            try {
                System.out.println("\n🔍 Parsing JSON Response...");
                jsonElement = JsonParser.parseString(responseBody);
                System.out.println("✅ JSON parsing successful");
            } catch (Exception parseException) {
                System.err.println("❌ JSON PARSING FAILED!");
                System.err.println("Parse Error: " + parseException.getMessage());
                System.err.println("Response was: " + responseBody.substring(0, Math.min(300, responseBody.length())));
                throw new PayOSException("PayOS returned invalid JSON: " + parseException.getMessage());
            }
            
            if (!jsonElement.isJsonObject()) {
                System.err.println("❌ CRITICAL: Response is not a JSON object!");
                System.err.println("Response type: " + jsonElement.getClass().getSimpleName());
                throw new PayOSException("PayOS response is not a JSON object");
            }
            
            JsonObject jsonResponse = jsonElement.getAsJsonObject();
            
            System.out.println("\n🎯 JSON Object Analysis:");
            System.out.println("  JSON Type: " + jsonResponse.getClass().getSimpleName());
            System.out.println("  Field Count: " + jsonResponse.size());
            System.out.println("  Root Keys: " + jsonResponse.keySet());
            
            // Handle HTTP errors
            if (responseCode >= 400) {
                System.err.println("\n❌ HTTP ERROR RESPONSE DETECTED");
                String errorDetails = extractErrorDetails(jsonResponse);
                System.err.println("Error Details: " + errorDetails);
                handlePayOSError(responseCode, jsonResponse);
            }
            
            System.out.println("✅ HTTP Request completed successfully");
            return jsonResponse;
            
        } catch (IOException networkException) {
            System.err.println("\n❌ ===== NETWORK ERROR =====");
            System.err.println("Error Type: " + networkException.getClass().getSimpleName());
            System.err.println("Error Message: " + networkException.getMessage());
            
            if (networkException.getMessage().contains("timeout")) {
                System.err.println("Issue: Request timeout - PayOS may be slow or unreachable");
            } else if (networkException.getMessage().contains("connection")) {
                System.err.println("Issue: Connection failed - PayOS may be down");
            } else if (networkException.getMessage().contains("resolve")) {
                System.err.println("Issue: DNS resolution failed - Check internet connection");
            }
            
            System.err.println("===========================");
            throw new PayOSException("Network error connecting to PayOS: " + networkException.getMessage(), true);
            
        } finally {
            if (connection != null) {
                connection.disconnect();
                System.out.println("🔌 HTTP connection closed");
            }
        }
    }
    
    /**
     * Parse PayOS response with complete debugging
     */
    private PaymentResponse parseWithCompleteDebug(JsonObject response, long orderCode) throws PayOSException {
        
        System.out.println("\n🔍 ===== RESPONSE PARSING DEBUG =====");
        System.out.println("Order Code: " + orderCode);
        System.out.println("Response Type: " + response.getClass().getSimpleName());
        System.out.println("Response Size: " + response.size() + " fields");
        
        System.out.println("\n📋 ALL RESPONSE FIELDS DETAILED ANALYSIS:");
        response.entrySet().forEach(entry -> {
            String key = entry.getKey();
            JsonElement value = entry.getValue();
            
            System.out.println("  🔑 Field: " + key);
            
            if (value.isJsonNull()) {
                System.out.println("    📄 Type: null");
            } else if (value.isJsonPrimitive()) {
                String valueStr = value.getAsString();
                System.out.println("    📄 Type: string");
                System.out.println("    📄 Length: " + valueStr.length() + " characters");
                System.out.println("    📄 Value: " + (valueStr.length() > 100 ? valueStr.substring(0, 100) + "..." : valueStr));
            } else if (value.isJsonObject()) {
                JsonObject obj = value.getAsJsonObject();
                System.out.println("    📄 Type: object (" + obj.size() + " fields)");
                System.out.println("    📄 Fields: " + obj.keySet());
                
                // Print details for important objects
                if ("data".equals(key) || "result".equals(key) || "response".equals(key) || "payload".equals(key)) {
                    System.out.println("    📄 DETAILED OBJECT CONTENTS:");
                    obj.entrySet().forEach(subEntry -> {
                        String subKey = subEntry.getKey();
                        JsonElement subValue = subEntry.getValue();
                        if (subValue.isJsonPrimitive()) {
                            String subValueStr = subValue.getAsString();
                            System.out.println("      - " + subKey + ": " + 
                                (subValueStr.length() > 50 ? subValueStr.substring(0, 50) + "..." : subValueStr));
                        } else {
                            System.out.println("      - " + subKey + ": " + subValue.getClass().getSimpleName());
                        }
                    });
                }
            } else if (value.isJsonArray()) {
                System.out.println("    📄 Type: array (" + value.getAsJsonArray().size() + " items)");
            } else {
                System.out.println("    📄 Type: " + value.getClass().getSimpleName());
            }
            System.out.println();
        });
        
        try {
            // Check for immediate errors
            System.out.println("🚨 Error Detection:");
            if (response.has("error") && !response.get("error").isJsonNull()) {
                String error = response.get("error").getAsString();
                System.err.println("❌ Found 'error' field: " + error);
                throw new PayOSException("PayOS API error: " + error);
            }
            
            if (response.has("success")) {
                boolean success = response.get("success").getAsBoolean();
                System.out.println("  Success field: " + success);
                if (!success) {
                    String message = response.has("message") ? response.get("message").getAsString() : "Unknown error";
                    System.err.println("❌ success = false: " + message);
                    throw new PayOSException("PayOS error: " + message);
                }
            }
            
            if (response.has("code")) {
                String code = response.get("code").getAsString();
                System.out.println("  Code field: " + code);
                if (!"00".equals(code)) {
                    System.out.println("⚠️ Non-success code detected: " + code);
                }
            }
            
            System.out.println("✅ No immediate error indicators found");
            
            // Try data extraction using multiple strategies
            System.out.println("\n📋 Data Extraction Attempts:");
            JsonObject dataObject = attemptDataExtraction(response);
            
            if (dataObject == null) {
                System.err.println("\n❌ ===== DATA EXTRACTION FAILED =====");
                System.err.println("No valid data object found in response");
                System.err.println("Available response keys: " + response.keySet());
                
                // Print complete response for manual analysis
                System.err.println("\n📄 COMPLETE RESPONSE FOR MANUAL ANALYSIS:");
                System.err.println(gson.toJson(response));
                System.err.println("==========================================");
                
                throw new PayOSException("Không tìm thấy dữ liệu thanh toán trong response PayOS");
            }
            
            System.out.println("✅ Data object extracted successfully");
            
            // Extract payment fields
            System.out.println("\n🎯 Payment Field Extraction:");
            return extractPaymentFieldsComplete(dataObject, orderCode);
            
        } catch (PayOSException e) {
            throw e;
        } catch (Exception e) {
            System.err.println("\n❌ PARSING EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            throw new PayOSException("Lỗi phân tích response PayOS: " + e.getMessage());
        }
    }
    
    /**
     * Attempt data extraction using multiple strategies
     */
    private JsonObject attemptDataExtraction(JsonObject response) {
        System.out.println("Trying extraction strategies...");
        
        // Strategy 1: Standard success response
        if (response.has("code") && "00".equals(response.get("code").getAsString()) && response.has("data")) {
            System.out.println("  ✅ Strategy 1: Success response with code=00 and data field");
            return response.getAsJsonObject("data");
        }
        
        // Strategy 2: Direct data field
        if (response.has("data") && response.get("data").isJsonObject()) {
            System.out.println("  ✅ Strategy 2: Direct data field");
            return response.getAsJsonObject("data");
        }
        
        // Strategy 3: Root level payment fields
        if (hasDirectPaymentFields(response)) {
            System.out.println("  ✅ Strategy 3: Root level payment fields");
            return response;
        }
        
        // Strategy 4: Nested in common fields
        String[] nestedFields = {"result", "response", "payload", "content", "body"};
        for (String field : nestedFields) {
            if (response.has(field) && response.get(field).isJsonObject()) {
                JsonObject nested = response.getAsJsonObject(field);
                if (hasDirectPaymentFields(nested)) {
                    System.out.println("  ✅ Strategy 4: Payment fields in '" + field + "'");
                    return nested;
                }
            }
        }
        
        // Strategy 5: Look for any object with payment-like fields
        for (Map.Entry<String, JsonElement> entry : response.entrySet()) {
            if (entry.getValue().isJsonObject()) {
                JsonObject obj = entry.getValue().getAsJsonObject();
                if (hasDirectPaymentFields(obj)) {
                    System.out.println("  ✅ Strategy 5: Payment fields in '" + entry.getKey() + "'");
                    return obj;
                }
            }
        }
        
        System.out.println("  ❌ All extraction strategies failed");
        return null;
    }
    
    /**
     * Check if object has direct payment fields
     */
    private boolean hasDirectPaymentFields(JsonObject obj) {
        String[] paymentFields = {
            "checkoutUrl", "checkout_url", "paymentUrl", "payment_url", "url",
            "qrCode", "qr_code", "qrCodeData", "qr_code_data", "qr",
            "paymentLinkId", "payment_link_id", "id", "linkId"
        };
        
        for (String field : paymentFields) {
            if (obj.has(field) && !obj.get(field).isJsonNull()) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Extract payment fields from data object with complete logging
     */
    private PaymentResponse extractPaymentFieldsComplete(JsonObject data, long orderCode) throws PayOSException {
        System.out.println("Extracting payment fields from data object...");
        System.out.println("Available fields: " + data.keySet());
        
        // Complete field mapping for maximum compatibility
        String[][] fieldMappings = {
            // Checkout URL variants
            {
                "checkoutUrl", "checkout_url", "paymentUrl", "payment_url", "url", "link", 
                "paymentLink", "payment_link", "checkoutLink", "checkout_link",
                "redirectUrl", "redirect_url", "payUrl", "pay_url"
            },
            // QR Code variants  
            {
                "qrCode", "qr_code", "qrCodeData", "qr_code_data", "qrData", "qr_data",
                "qr", "qrCodeUrl", "qr_code_url", "qrUrl", "qr_url", "qrImage", "qr_image",
                "qrCodeBase64", "qr_code_base64", "qrBase64", "qr_base64"
            },
            // Payment Link ID variants
            {
                "paymentLinkId", "payment_link_id", "id", "linkId", "link_id",
                "paymentId", "payment_id", "orderId", "order_id", "transactionId", "transaction_id",
                "paymentToken", "payment_token", "token", "requestId", "request_id"
            }
        };
        
        String[] fieldNames = {"Checkout URL", "QR Code", "Payment Link ID"};
        String[] values = new String[3];
        
        // Extract each field
        for (int i = 0; i < fieldMappings.length; i++) {
            System.out.println("\n🔍 Searching for " + fieldNames[i] + ":");
            
            for (String fieldName : fieldMappings[i]) {
                if (data.has(fieldName) && !data.get(fieldName).isJsonNull()) {
                    try {
                        JsonElement element = data.get(fieldName);
                        if (element.isJsonPrimitive()) {
                            String value = element.getAsString();
                            if (value != null && !value.trim().isEmpty()) {
                                values[i] = value;
                                System.out.println("  ✅ Found in '" + fieldName + "': " + 
                                    (value.length() > 60 ? value.substring(0, 60) + "..." : value));
                                break;
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("  ⚠️ Field '" + fieldName + "' exists but extraction failed: " + e.getMessage());
                    }
                }
            }
            
            if (values[i] == null) {
                System.out.println("  ❌ " + fieldNames[i] + " not found in: " + String.join(", ", fieldMappings[i]));
                
                // Debug: Show what string fields are available
                System.out.println("  🔍 Available string fields in data:");
                data.entrySet().forEach(entry -> {
                    if (entry.getValue().isJsonPrimitive() && entry.getValue().getAsJsonPrimitive().isString()) {
                        String value = entry.getValue().getAsString();
                        System.out.println("    - " + entry.getKey() + ": " + 
                            (value.length() > 40 ? value.substring(0, 40) + "..." : value));
                    }
                });
            }
        }
        
        // Generate fallbacks and validate
        String checkoutUrl = values[0];
        String qrCode = values[1];
        String paymentLinkId = values[2];
        
        if (checkoutUrl == null || checkoutUrl.isEmpty()) {
            checkoutUrl = "https://pay.payos.vn/web/" + orderCode;
            System.out.println("⚠️ Using fallback checkout URL: " + checkoutUrl);
        }
        
        if (paymentLinkId == null || paymentLinkId.isEmpty()) {
            paymentLinkId = "GEN_" + orderCode;
            System.out.println("⚠️ Using generated payment link ID: " + paymentLinkId);
        }
        
        // QR Code is critical
        if (qrCode == null || qrCode.isEmpty()) {
            System.err.println("❌ CRITICAL: QR Code is missing from PayOS response!");
            System.err.println("This usually means:");
            System.err.println("  1. PayOS API format has changed");
            System.err.println("  2. PayOS is returning an error we didn't catch");
            System.err.println("  3. Response structure is different than expected");
            System.err.println("  4. PayOS account/configuration issues");
            
            // Don't fail completely - continue without QR
            System.err.println("⚠️ Continuing without QR code - payment may not work via QR scan");
        } else {
            // Analyze QR code
            if (qrCode.startsWith("data:image/")) {
                System.out.println("✅ QR Code: Base64 image (" + qrCode.length() + " characters)");
            } else if (qrCode.startsWith("http")) {
                System.out.println("✅ QR Code: URL format (" + qrCode + ")");
            } else {
                System.out.println("✅ QR Code: Raw format (" + qrCode.length() + " characters)");
            }
        }
        
        System.out.println("\n🎯 Final Payment Response:");
        System.out.println("  Order Code: " + orderCode);
        System.out.println("  Checkout URL: " + (checkoutUrl != null ? "✅" : "❌"));
        System.out.println("  QR Code: " + (qrCode != null ? "✅" : "❌"));
        System.out.println("  Payment Link ID: " + paymentLinkId);
        
        return new PaymentResponse(orderCode, checkoutUrl, qrCode, paymentLinkId);
    }
    
    /**
     * Extract error details from response
     */
    private String extractErrorDetails(JsonObject response) {
        StringBuilder details = new StringBuilder();
        
        if (response.has("error")) {
            details.append("error: ").append(response.get("error").getAsString()).append("; ");
        }
        if (response.has("message")) {
            details.append("message: ").append(response.get("message").getAsString()).append("; ");
        }
        if (response.has("code")) {
            details.append("code: ").append(response.get("code").getAsString()).append("; ");
        }
        
        return details.length() > 0 ? details.toString() : "No error details found";
    }
    
    /**
     * Create mock payment for testing
     */
    private PaymentResponse createMockPayment(Booking booking, String returnUrl, String cancelUrl) {
        long orderCode = generateOrderCode();
        String mockQr = "data:image/svg+xml;base64," + 
            java.util.Base64.getEncoder().encodeToString(
                ("<svg width='200' height='200' xmlns='http://www.w3.org/2000/svg'>" +
                 "<rect width='200' height='200' fill='#f0f0f0' stroke='#ddd'/>" +
                 "<text x='100' y='90' text-anchor='middle' font-family='Arial' font-size='14' fill='#666'>MOCK QR CODE</text>" +
                 "<text x='100' y='110' text-anchor='middle' font-family='Arial' font-size='10' fill='#999'>Order: " + orderCode + "</text>" +
                 "<text x='100' y='130' text-anchor='middle' font-family='Arial' font-size='10' fill='#999'>Not scannable</text>" +
                 "</svg>").getBytes()
            );
        
        booking.setPaymentOrderCode(orderCode);
        
        System.out.println("🧪 Mock payment created:");
        System.out.println("  Order Code: " + orderCode);
        System.out.println("  Checkout URL: https://pay.payos.vn/web/" + orderCode);
        System.out.println("  QR Code: Mock SVG (" + mockQr.length() + " chars)");
        
        return new PaymentResponse(orderCode, "https://pay.payos.vn/web/" + orderCode, mockQr, "MOCK_" + orderCode);
    }
    
    /**
     * Build payment request object
     */
    private Map<String, Object> buildPaymentRequest(long orderCode, int amount, String description,
                                                   String returnUrl, String cancelUrl, Booking booking) {
        Map<String, Object> request = new HashMap<>();
        
        request.put("orderCode", orderCode);
        request.put("amount", amount);
        request.put("description", description);
        request.put("cancelUrl", cancelUrl);
        request.put("returnUrl", returnUrl);
        request.put("expiredAt", PayOSConfig.getDefaultPaymentExpiry());
        
        // Add buyer info
        Map<String, Object> buyerInfo = new HashMap<>();
        buyerInfo.put("name", getContactName(booking));
        buyerInfo.put("email", getContactEmail(booking));
        buyerInfo.put("phone", getContactPhone(booking));
        request.put("buyerInfo", buyerInfo);
        
        // Add items
        Map<String, Object> item = new HashMap<>();
        item.put("name", getServiceName(booking));
        item.put("quantity", booking.getNumberOfPeople());
        item.put("price", amount / booking.getNumberOfPeople());
        request.put("items", new Object[]{item});
        
        return request;
    }
    
    /**
     * Handle PayOS API errors
     */
    private void handlePayOSError(int responseCode, JsonObject errorResponse) throws PayOSException {
        String errorMessage = extractErrorDetails(errorResponse);
        
        switch (responseCode) {
            case 400:
                throw new PayOSException("Dữ liệu yêu cầu không hợp lệ: " + errorMessage);
            case 401:
                throw new PayOSException("Xác thực PayOS thất bại. Kiểm tra CLIENT_ID và API_KEY: " + errorMessage);
            case 403:
                throw new PayOSException("Không có quyền truy cập PayOS: " + errorMessage);
            case 404:
                throw new PayOSException("API endpoint không tồn tại: " + errorMessage);
            case 422:
                throw new PayOSException("Dữ liệu không hợp lệ: " + errorMessage);
            case 429:
                throw new PayOSException("Quá nhiều yêu cầu: " + errorMessage);
            case 500:
            case 502:
            case 503:
                throw new PayOSException("Lỗi hệ thống PayOS: " + errorMessage, true);
            default:
                throw new PayOSException("Lỗi PayOS (" + responseCode + "): " + errorMessage);
        }
    }
    
    /**
     * Get payment information by order code
     */
    public PaymentInfo getPaymentInfo(long orderCode) throws PayOSException {
        if (PayOSConfig.ENABLE_MOCK_MODE) {
            System.out.println("🧪 Mock mode: Returning fake payment info for order " + orderCode);
            return new PaymentInfo(orderCode, "PENDING", 100000, 0, 100000, "2025-06-09T03:00:00Z");
        }
        
        try {
            System.out.println("\n🔍 Getting payment info for order: " + orderCode);
            JsonObject response = sendToPayOSWithCompleteDebug("GET", "/v2/payment-requests/" + orderCode, null);
            
            return parsePaymentInfo(response);
            
        } catch (Exception e) {
            System.err.println("❌ Failed to get payment info: " + e.getMessage());
            throw new PayOSException("Lỗi kiểm tra thanh toán: " + e.getMessage());
        }
    }
    
    /**
     * Parse payment info response
     */
    private PaymentInfo parsePaymentInfo(JsonObject response) throws PayOSException {
        try {
            JsonObject data = null;
            
            // Try to extract data using same logic as payment creation
            if (response.has("code") && "00".equals(response.get("code").getAsString()) && response.has("data")) {
                data = response.getAsJsonObject("data");
            } else if (response.has("data") && response.get("data").isJsonObject()) {
                data = response.getAsJsonObject("data");
            } else if (response.has("orderCode")) {
                data = response;
            }
            
            if (data == null) {
                throw new PayOSException("No payment data in response");
            }
            
            long orderCode = data.has("orderCode") ? data.get("orderCode").getAsLong() : 0L;
            String status = data.has("status") ? data.get("status").getAsString() : "UNKNOWN";
            int amount = data.has("amount") ? data.get("amount").getAsInt() : 0;
            int amountPaid = data.has("amountPaid") ? data.get("amountPaid").getAsInt() : 0;
            int amountRemaining = data.has("amountRemaining") ? data.get("amountRemaining").getAsInt() : amount - amountPaid;
            String createdAt = data.has("createdAt") ? data.get("createdAt").getAsString() : "";
            
            return new PaymentInfo(orderCode, status, amount, amountPaid, amountRemaining, createdAt);
            
        } catch (Exception e) {
            throw new PayOSException("Failed to parse payment info: " + e.getMessage());
        }
    }
    
    /**
     * Check if payment is completed
     */
    public boolean isPaymentCompleted(long orderCode) throws PayOSException {
        try {
            PaymentInfo paymentInfo = getPaymentInfo(orderCode);
            return paymentInfo.isPaid();
        } catch (PayOSException e) {
            if (e.getMessage().contains("not found") || e.getMessage().contains("404")) {
                return false;
            }
            throw e;
        }
    }
    
    // Utility methods
    private long generateOrderCode() {
        return System.currentTimeMillis() / 1000;
    }
    
    private String generateDescription(Booking booking) {
        if (booking.isExperienceBooking()) {
            return PayOSConfig.generateExperienceOrderDescription(
                booking.getBookingId(), 
                booking.getExperienceName() != null ? booking.getExperienceName() : "Trải nghiệm"
            );
        } else if (booking.isAccommodationBooking()) {
            return PayOSConfig.generateAccommodationOrderDescription(
                booking.getBookingId(), 
                booking.getAccommodationName() != null ? booking.getAccommodationName() : "Lưu trú"
            );
        } else {
            return "VietCulture Booking #" + booking.getBookingId();
        }
    }
    
    private String getServiceName(Booking booking) {
        if (booking.isExperienceBooking()) {
            return booking.getExperienceName() != null ? booking.getExperienceName() : "Trải nghiệm";
        } else if (booking.isAccommodationBooking()) {
            return booking.getAccommodationName() != null ? booking.getAccommodationName() : "Lưu trú";
        } else {
            return "Dịch vụ VietCulture";
        }
    }
    
    private String getContactName(Booking booking) {
        String name = booking.getContactName();
        return (name != null && !name.isEmpty()) ? name : "VietCulture Customer";
    }
    
    private String getContactEmail(Booking booking) {
        String email = booking.getContactEmail();
        return (email != null && !email.isEmpty()) ? email : "customer@vietculture.vn";
    }
    
    private String getContactPhone(Booking booking) {
        String phone = booking.getContactPhone();
        return (phone != null && !phone.isEmpty()) ? phone : "0123456789";
    }
    
    // Data classes
    public static class PaymentResponse {
        private final long orderCode;
        private final String checkoutUrl;
        private final String qrCode;
        private final String paymentLinkId;
        
        public PaymentResponse(long orderCode, String checkoutUrl, String qrCode, String paymentLinkId) {
            this.orderCode = orderCode;
            this.checkoutUrl = checkoutUrl;
            this.qrCode = qrCode;
            this.paymentLinkId = paymentLinkId;
        }
        
        public long getOrderCode() { return orderCode; }
        public String getCheckoutUrl() { return checkoutUrl; }
        public String getQrCode() { return qrCode; }
        public String getPaymentLinkId() { return paymentLinkId; }
        
        @Override
        public String toString() {
            return "PaymentResponse{" +
                   "orderCode=" + orderCode +
                   ", checkoutUrl='" + checkoutUrl + '\'' +
                   ", qrCode=" + (qrCode != null ? "present(" + qrCode.length() + ")" : "null") +
                   ", paymentLinkId='" + paymentLinkId + '\'' +
                   '}';
        }
    }
    
    public static class PaymentInfo {
        private final long orderCode;
        private final String status;
        private final int amount;
        private final int amountPaid;
        private final int amountRemaining;
        private final String createdAt;
        
        public PaymentInfo(long orderCode, String status, int amount, int amountPaid, 
                          int amountRemaining, String createdAt) {
            this.orderCode = orderCode;
            this.status = status;
            this.amount = amount;
            this.amountPaid = amountPaid;
            this.amountRemaining = amountRemaining;
            this.createdAt = createdAt;
        }
        
        public long getOrderCode() { return orderCode; }
        public String getStatus() { return status; }
        public int getAmount() { return amount; }
        public int getAmountPaid() { return amountPaid; }
        public int getAmountRemaining() { return amountRemaining; }
        public String getCreatedAt() { return createdAt; }
        
        public boolean isPaid() {
            return "PAID".equals(status) || "COMPLETED".equals(status);
        }
        
        public boolean isFinal() {
            return isPaid() || "CANCELLED".equals(status) || "EXPIRED".equals(status);
        }
        
        public String getStatusMessage() {
            return PayOSConfig.getStatusMessage(status);
        }
        
        @Override
        public String toString() {
            return "PaymentInfo{" +
                   "orderCode=" + orderCode +
                   ", status='" + status + '\'' +
                   ", amount=" + amount +
                   ", amountPaid=" + amountPaid +
                   ", amountRemaining=" + amountRemaining +
                   ", createdAt='" + createdAt + '\'' +
                   '}';
        }
    }
    
    public static class PayOSException extends Exception {
        private final boolean isNetworkError;
        
        public PayOSException(String message) {
            super(message);
            this.isNetworkError = false;
        }
        
        public PayOSException(String message, boolean isNetworkError) {
            super(message);
            this.isNetworkError = isNetworkError;
        }
        
        public PayOSException(String message, Throwable cause) {
            super(message, cause);
            this.isNetworkError = false;
        }
        
        public boolean isNetworkError() {
            return isNetworkError;
        }
    }
}