package com.chatbot.utils;

public class StringUtils {
    
    /**
     * Capitalize first letter of each word
     */
    public static String capitalize(String s) {
        if (s == null || s.isEmpty()) return s;
        String[] arr = s.split(" ");
        StringBuilder sb = new StringBuilder();
        for (String word : arr) {
            if (!word.isEmpty()) {
                sb.append(Character.toUpperCase(word.charAt(0)))
                  .append(word.substring(1))
                  .append(" ");
            }
        }
        return sb.toString().trim();
    }
    
    /**
     * Check if string is null or empty
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Safe substring that doesn't throw IndexOutOfBoundsException
     */
    public static String safeSubstring(String str, int start, int end) {
        if (str == null) return null;
        if (start < 0) start = 0;
        if (end > str.length()) end = str.length();
        if (start >= end) return "";
        return str.substring(start, end);
    }
    
    /**
     * Normalize Vietnamese text for better comparison
     */
    public static String normalizeVietnamese(String text) {
        if (text == null) return null;
        return text.toLowerCase().trim()
            .replace("đ", "d").replace("Đ", "D")
            .replaceAll("[áàảãạâấầẩẫậăắằẳẵặ]", "a")
            .replaceAll("[éèẻẽẹêếềểễệ]", "e")
            .replaceAll("[íìỉĩị]", "i")
            .replaceAll("[óòỏõọôốồổỗộơớờởỡợ]", "o")
            .replaceAll("[úùủũụưứừửữự]", "u")
            .replaceAll("[ýỳỷỹỵ]", "y");
    }
    
    /**
     * Format number with thousands separator
     */
    public static String formatNumber(long number) {
        return String.format("%,d", number);
    }
    
    /**
     * Truncate string to specified length with ellipsis
     */
    public static String truncate(String str, int length) {
        if (str == null || str.length() <= length) return str;
        return str.substring(0, length - 3) + "...";
    }
}