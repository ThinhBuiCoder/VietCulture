package com.chatbot.model;

import java.util.Date;

public class Transaction {
    private int transactionId;
    private int userId;
    private Integer bookingId;
    private String type; // PAYMENT, WITHDRAWAL, DEPOSIT, REFUND
    private double amount;
    private String currency;
    private String status; // PENDING, SUCCESS, FAILED, CANCELLED
    private String paymentMethod;
    private String gatewayTransactionId;
    private String description;
    private Date createdAt;
    private Date completedAt;
    private String failureReason;
    
    // Additional fields for display
    private String userName;
    private String bookingDetails;
    
    // Constructor
    public Transaction() {}
    
    // Getters and Setters
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getGatewayTransactionId() { return gatewayTransactionId; }
    public void setGatewayTransactionId(String gatewayTransactionId) { this.gatewayTransactionId = gatewayTransactionId; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }
    
    public String getFailureReason() { return failureReason; }
    public void setFailureReason(String failureReason) { this.failureReason = failureReason; }
    
    // Display fields
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getBookingDetails() { return bookingDetails; }
    public void setBookingDetails(String bookingDetails) { this.bookingDetails = bookingDetails; }
    
    // Helper methods
    public String getFormattedAmount() {
        return String.format("%.0f %s", amount, currency != null ? currency : "VNĐ");
    }
    
    public String getDisplayType() {
        switch (type) {
            case "PAYMENT": return "Thanh toán";
            case "WITHDRAWAL": return "Rút tiền";
            case "DEPOSIT": return "Nạp tiền";
            case "REFUND": return "Hoàn tiền";
            default: return type;
        }
    }
    
    public String getDisplayStatus() {
        switch (status) {
            case "PENDING": return "Đang xử lý";
            case "SUCCESS": return "Thành công";
            case "FAILED": return "Thất bại";
            case "CANCELLED": return "Đã hủy";
            default: return status;
        }
    }
    
    public String getDisplayPaymentMethod() {
        switch (paymentMethod) {
            case "CREDIT_CARD": return "Thẻ tín dụng";
            case "DEBIT_CARD": return "Thẻ ghi nợ";
            case "BANK_TRANSFER": return "Chuyển khoản ngân hàng";
            case "E_WALLET": return "Ví điện tử";
            case "CASH": return "Tiền mặt";
            default: return paymentMethod;
        }
    }
    
    public boolean isPayment() { return "PAYMENT".equals(type); }
    public boolean isWithdrawal() { return "WITHDRAWAL".equals(type); }
    public boolean isDeposit() { return "DEPOSIT".equals(type); }
    public boolean isRefund() { return "REFUND".equals(type); }
    
    public boolean isSuccess() { return "SUCCESS".equals(status); }
    public boolean isPending() { return "PENDING".equals(status); }
    public boolean isFailed() { return "FAILED".equals(status); }
    public boolean isCancelled() { return "CANCELLED".equals(status); }
}