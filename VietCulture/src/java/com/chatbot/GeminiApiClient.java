package com.chatbot;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;

public class GeminiApiClient {
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
    private final String apiKey;
    
    public GeminiApiClient(String apiKey) {
        this.apiKey = apiKey;
    }
    
    public String generateResponse(String userMessage) throws IOException {
        URL url = new URL(API_URL + "?key=" + apiKey);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);
        
        // Create JSON request body
        JSONObject requestBody = new JSONObject();
        JSONArray contents = new JSONArray();
        JSONObject content = new JSONObject();
        JSONArray parts = new JSONArray();
        JSONObject part = new JSONObject();
        
        part.put("text", userMessage);
        parts.put(part);
        content.put("parts", parts);
        contents.put(content);
        requestBody.put("contents", contents);
        
        // Send request
        try (OutputStream os = connection.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        
        // Read response
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(
                connection.getResponseCode() == 200 ? 
                connection.getInputStream() : connection.getErrorStream()))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
        }
        
        // Parse response to extract text
        if (connection.getResponseCode() == 200) {
            JSONObject jsonResponse = new JSONObject(response.toString());
            JSONArray candidates = jsonResponse.getJSONArray("candidates");
            if (candidates.length() > 0) {
                JSONObject candidate = candidates.getJSONObject(0);
                JSONObject candidateContent = candidate.getJSONObject("content");
                JSONArray responseParts = candidateContent.getJSONArray("parts");
                if (responseParts.length() > 0) {
                    return responseParts.getJSONObject(0).getString("text");
                }
            }
        }
        
        return "Xin lỗi, tôi không thể trả lời câu hỏi này. Vui lòng thử lại!";
    }
}