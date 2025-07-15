package com.chatbot.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * Simple logging utility
 * In production, replace with proper logging framework like SLF4J + Logback
 */
public class Logger {
    
    private static Logger instance;
    private static final DateTimeFormatter TIMESTAMP_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
    
    public enum Level {
        DEBUG, INFO, WARN, ERROR
    }
    
    private Level currentLevel = Level.INFO;
    
    private Logger() {}
    
    public static synchronized Logger getInstance() {
        if (instance == null) {
            instance = new Logger();
        }
        return instance;
    }
    
    public void setLevel(Level level) {
        this.currentLevel = level;
    }
    
    public void debug(String message) {
        log(Level.DEBUG, message, null);
    }
    
    public void info(String message) {
        log(Level.INFO, message, null);
    }
    
    public void warn(String message) {
        log(Level.WARN, message, null);
    }
    
    public void warn(String message, Throwable throwable) {
        log(Level.WARN, message, throwable);
    }
    
    public void error(String message) {
        log(Level.ERROR, message, null);
    }
    
    public void error(String message, Throwable throwable) {
        log(Level.ERROR, message, throwable);
    }
    
    private void log(Level level, String message, Throwable throwable) {
        if (level.ordinal() < currentLevel.ordinal()) {
            return;
        }
        
        String timestamp = LocalDateTime.now().format(TIMESTAMP_FORMAT);
        String logMessage = String.format("[%s] [%s] [%s] %s", 
            timestamp, level, Thread.currentThread().getName(), message);
        
        if (level == Level.ERROR || level == Level.WARN) {
            System.err.println(logMessage);
        } else {
            System.out.println(logMessage);
        }
        
        if (throwable != null) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            throwable.printStackTrace(pw);
            
            if (level == Level.ERROR || level == Level.WARN) {
                System.err.println(sw.toString());
            } else {
                System.out.println(sw.toString());
            }
        }
    }
}