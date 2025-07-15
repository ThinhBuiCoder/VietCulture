package com.chatbot.model;

import java.util.Date;

public class ChatMessage {
    private String message;
    private String sender;
    private Date timestamp;
    
    public ChatMessage() {
        this.timestamp = new Date();
    }
    
    public ChatMessage(String message, String sender) {
        this.message = message;
        this.sender = sender;
        this.timestamp = new Date();
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getSender() {
        return sender;
    }
    
    public void setSender(String sender) {
        this.sender = sender;
    }
    
    public Date getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }
}

