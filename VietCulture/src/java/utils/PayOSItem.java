package utils;

/**
 * PayOS Item Data Model for payment items
 */
public class PayOSItem {
    private String name;
    private int quantity;
    private long price;
    private String imageUrl;
    private String description;
    
    public PayOSItem() {}
    
    public PayOSItem(String name, int quantity, long price) {
        this.name = name;
        this.quantity = quantity;
        this.price = price;
    }
    
    public PayOSItem(String name, int quantity, long price, String description) {
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.description = description;
    }
    
    // ==================== GETTERS & SETTERS ====================
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    // ==================== UTILITY METHODS ====================
    
    public long getTotalPrice() { return price * quantity; }
    
    public boolean isValid() {
        return name != null && !name.trim().isEmpty()
            && quantity > 0
            && price > 0;
    }
    
    @Override
    public String toString() {
        return "PayOSItem{" +
               "name='" + name + '\'' +
               ", quantity=" + quantity +
               ", price=" + price +
               ", totalPrice=" + getTotalPrice() +
               '}';
    }
}