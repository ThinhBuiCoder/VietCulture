package utils;

/**
 * PayOS Payment Response Data Model
 */
public class PayOSResponse {
    private boolean success;
    private String message;
    private String checkoutUrl;
    private long orderCode;
    private String paymentLinkId;
    private String qrCode;
    private int errorCode;
    
    public PayOSResponse() {}
    
    public PayOSResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
    }
    
    // ==================== STATIC FACTORY METHODS ====================
    
    public static PayOSResponse success(String checkoutUrl, long orderCode, String paymentLinkId) {
        PayOSResponse response = new PayOSResponse(true, "Payment link created successfully");
        response.setCheckoutUrl(checkoutUrl);
        response.setOrderCode(orderCode);
        response.setPaymentLinkId(paymentLinkId);
        return response;
    }
    
    public static PayOSResponse error(String message, int errorCode) {
        PayOSResponse response = new PayOSResponse(false, message);
        response.setErrorCode(errorCode);
        return response;
    }
    
    public static PayOSResponse error(String message) {
        return error(message, -1);
    }
    
    // ==================== GETTERS & SETTERS ====================
    
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getCheckoutUrl() { return checkoutUrl; }
    public void setCheckoutUrl(String checkoutUrl) { this.checkoutUrl = checkoutUrl; }
    public long getOrderCode() { return orderCode; }
    public void setOrderCode(long orderCode) { this.orderCode = orderCode; }
    public String getPaymentLinkId() { return paymentLinkId; }
    public void setPaymentLinkId(String paymentLinkId) { this.paymentLinkId = paymentLinkId; }
    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }
    public int getErrorCode() { return errorCode; }
    public void setErrorCode(int errorCode) { this.errorCode = errorCode; }
    
    @Override
    public String toString() {
        return "PayOSResponse{" +
               "success=" + success +
               ", message='" + message + '\'' +
               ", orderCode=" + orderCode +
               ", checkoutUrl='" + checkoutUrl + '\'' +
               ", errorCode=" + errorCode +
               '}';
    }
}