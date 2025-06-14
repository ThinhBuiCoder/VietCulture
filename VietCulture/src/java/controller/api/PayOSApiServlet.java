package controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import service.PayOSService;
import service.PayOSService.PaymentInfo;
import service.PayOSService.PayOSException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.BufferedReader;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * PayOS API Servlet for handling payment status checks
 * Provides REST endpoints for payment verification
 */
@WebServlet("/api/payment/*")
public class PayOSApiServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(PayOSApiServlet.class.getName());
    private PayOSService payOSService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            payOSService = new PayOSService();
            gson = new Gson();
            LOGGER.info("PayOSApiServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize PayOSApiServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setJsonResponse(request, response);
        
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/status".equals(pathInfo)) {
                handlePaymentStatusCheck(request, response);
            } else {
                sendJsonError(response, HttpServletResponse.SC_NOT_FOUND, 
                            "ENDPOINT_NOT_FOUND", "API endpoint not found");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in PayOS API", e);
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                        "INTERNAL_ERROR", "Internal server error");
        }
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle CORS preflight
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
    
    /**
     * Handle payment status check request
     */
    private void handlePaymentStatusCheck(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Parse request JSON
        JsonObject requestData = parseJsonRequest(request);
        if (requestData == null) {
            sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, 
                        "INVALID_JSON", "Invalid JSON request");
            return;
        }
        
        // Extract order code
        Long orderCode = extractOrderCode(requestData);
        if (orderCode == null) {
            sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, 
                        "MISSING_ORDER_CODE", "Order code is required");
            return;
        }
        
        try {
            // Check payment status with PayOS
            PaymentInfo paymentInfo = payOSService.getPaymentInfo(orderCode);
            
            // Build response
            JsonObject responseData = buildPaymentStatusResponse(paymentInfo);
            
            LOGGER.info("Payment status checked - OrderCode: " + orderCode + 
                       ", Status: " + paymentInfo.getStatus());
            
            sendJsonSuccess(response, responseData);
            
        } catch (PayOSException e) {
            LOGGER.log(Level.WARNING, "PayOS error checking payment status", e);
            
            // Determine error type
            if (e.getMessage().contains("not found") || e.getMessage().contains("404")) {
                sendJsonError(response, HttpServletResponse.SC_NOT_FOUND, 
                            "PAYMENT_NOT_FOUND", "Payment not found");
            } else if (e.isNetworkError()) {
                sendJsonError(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE, 
                            "NETWORK_ERROR", "PayOS service unavailable");
            } else {
                sendJsonError(response, HttpServletResponse.SC_BAD_REQUEST, 
                            "PAYOS_ERROR", e.getMessage());
            }
        }
    }
    
    /**
     * Parse JSON request body
     */
    private JsonObject parseJsonRequest(HttpServletRequest request) {
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            String jsonString = sb.toString();
            if (jsonString.trim().isEmpty()) {
                return null;
            }
            
            return gson.fromJson(jsonString, JsonObject.class);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to parse JSON request", e);
            return null;
        }
    }
    
    /**
     * Extract order code from request data
     */
    private Long extractOrderCode(JsonObject requestData) {
        try {
            if (requestData.has("orderCode")) {
                return requestData.get("orderCode").getAsLong();
            }
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to extract order code", e);
            return null;
        }
    }
    
    /**
     * Build payment status response object
     */
    private JsonObject buildPaymentStatusResponse(PaymentInfo paymentInfo) {
        JsonObject response = new JsonObject();
        
        response.addProperty("orderCode", paymentInfo.getOrderCode());
        response.addProperty("status", paymentInfo.getStatus());
        response.addProperty("amount", paymentInfo.getAmount());
        response.addProperty("amountPaid", paymentInfo.getAmountPaid());
        response.addProperty("amountRemaining", paymentInfo.getAmountRemaining());
        response.addProperty("createdAt", paymentInfo.getCreatedAt());
        response.addProperty("isPaid", paymentInfo.isPaid());
        response.addProperty("isFinal", paymentInfo.isFinal());
        response.addProperty("statusMessage", paymentInfo.getStatusMessage());
        
        return response;
    }
    
    /**
     * Set JSON response headers
     */
    private void setJsonResponse(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Enable CORS
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    }
    
    /**
     * Send JSON success response
     */
    private void sendJsonSuccess(HttpServletResponse response, JsonObject data) throws IOException {
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.addProperty("message", "Success");
        result.add("data", data);
        
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(result));
    }
    
    /**
     * Send JSON error response
     */
    private void sendJsonError(HttpServletResponse response, int statusCode, 
                              String errorCode, String message) throws IOException {
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("errorCode", errorCode);
        error.addProperty("message", message);
        error.addProperty("timestamp", System.currentTimeMillis());
        
        response.setStatus(statusCode);
        response.getWriter().write(gson.toJson(error));
    }
}