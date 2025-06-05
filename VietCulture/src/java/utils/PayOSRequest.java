package utils;

import java.util.ArrayList;
import java.util.List;

/**
 * PayOS Payment Request Data Model
 */
public class PayOSRequest {
    private long orderCode;
    private long amount;
    private String description;
    private String cancelUrl;
    private String returnUrl;
    private String buyerName;
    private String buyerEmail;
    private String buyerPhone;
    private List<PayOSItem> items;
    
    public PayOSRequest() {
        this.items = new ArrayList<>();
    }
    
    public PayOSRequest(long orderCode, long amount, String description, 
                       String cancelUrl, String returnUrl) {
        this.orderCode = orderCode;
        this.amount = amount;
        this.description = description;
        this.cancelUrl = cancelUrl;
        this.returnUrl = returnUrl;
        this.items = new ArrayList<>();
    }
    
    // ==================== GETTERS & SETTERS ====================
    
    public long getOrderCode() { return orderCode; }
    public void setOrderCode(long orderCode) { this.orderCode = orderCode; }
    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCancelUrl() { return cancelUrl; }
    public void setCancelUrl(String cancelUrl) { this.cancelUrl = cancelUrl; }
    public String getReturnUrl() { return returnUrl; }
    public void setReturnUrl(String returnUrl) { this.returnUrl = returnUrl; }
    public String getBuyerName() { return buyerName; }
    public void setBuyerName(String buyerName) { this.buyerName = buyerName; }
    public String getBuyerEmail() { return buyerEmail; }
    public void setBuyerEmail(String buyerEmail) { this.buyerEmail = buyerEmail; }
    public String getBuyerPhone() { return buyerPhone; }
    public void setBuyerPhone(String buyerPhone) { this.buyerPhone = buyerPhone; }
    public List<PayOSItem> getItems() { return items; }
    public void setItems(List<PayOSItem> items) { this.items = items; }
    
    // ==================== UTILITY METHODS ====================
    
    public void addItem(String name, int quantity, long price) {
        PayOSItem item = new PayOSItem(name, quantity, price);
        this.items.add(item);
    }
    
    public void addItem(PayOSItem item) {
        this.items.add(item);
    }
    
    public long calculateTotalFromItems() {
        return items.stream()
                   .mapToLong(item -> item.getPrice() * item.getQuantity())
                   .sum();
    }
    
    public boolean isValid() {
        return orderCode > 0 
            && amount > 0 
            && description != null && !description.trim().isEmpty()
            && cancelUrl != null && !cancelUrl.trim().isEmpty()
            && returnUrl != null && !returnUrl.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "PayOSRequest{" +
               "orderCode=" + orderCode +
               ", amount=" + amount +
               ", description='" + description + '\'' +
               ", buyerName='" + buyerName + '\'' +
               ", buyerEmail='" + buyerEmail + '\'' +
               ", itemCount=" + items.size() +
               '}';
    }
}