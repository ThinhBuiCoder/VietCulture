package controller;

import dao.ExperienceDAO;
import model.Experience;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "KeywordSuggestionsServlet", urlPatterns = {"/api/keyword-suggestions"})
public class ExperienceApiServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ExperienceApiServlet.class.getName());
    
    private ExperienceDAO experienceDAO;
    
    // Predefined keywords for suggestions
    private static final String[] POPULAR_KEYWORDS = {
        "ẩm thực", "văn hóa", "phiêu lưu", "thiên nhiên", "làng nghề", "festival", "biển", "núi",
        "nấu ăn", "truyền thống", "thể thao", "lịch sử", "chùa", "đền", "phố cổ", "làng cổ",
        "thác", "hang động", "vịnh", "đồi", "ruộng bậc thang", "rừng", "suối", "đầm",
        "lễ hội", "múa", "ca", "nhạc", "chèo", "tuồng", "quan họ", "dân ca",
        "pho", "bún", "bánh", "chả", "nem", "gỏi", "cơm", "chè", "che",
        "trekking", "leo núi", "lặn", "bơi", "chèo thuyền", "câu cá", "xe đạp", "moto"
    };

    @Override
    public void init() throws ServletException {
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("Keyword suggestions API called");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            handleKeywordSuggestions(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in keyword suggestions API", e);
            sendErrorResponse(response, "Internal server error", 500);
        }
    }

    /**
     * Handle keyword suggestions for search autocomplete
     */
    private void handleKeywordSuggestions(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String query = request.getParameter("q");
        if (query == null || query.trim().length() < 2) {
            sendErrorResponse(response, "Query too short", 400);
            return;
        }

        query = query.trim().toLowerCase();
        List<String> suggestions = new ArrayList<>();

        // Get suggestions from predefined keywords
        for (String keyword : POPULAR_KEYWORDS) {
            if (keyword.toLowerCase().contains(query) && suggestions.size() < 8) {
                suggestions.add(keyword);
            }
        }

        // Add related keywords based on semantic similarity
        List<String> relatedKeywords = getRelatedKeywords(query);
        for (String related : relatedKeywords) {
            if (!suggestions.contains(related) && suggestions.size() < 10) {
                suggestions.add(related);
            }
        }

        sendSuccessResponse(response, suggestions, query);
    }

    /**
     * Get related keywords based on semantic similarity
     */
    private List<String> getRelatedKeywords(String query) {
        Map<String, List<String>> semanticMap = new HashMap<>();
        
        // Food-related
        semanticMap.put("ẩm thực", Arrays.asList("nấu ăn", "món ăn", "phở", "bún", "bánh", "chả", "nem"));
        semanticMap.put("phở", Arrays.asList("ẩm thực", "bún", "mì", "cơm", "món ăn"));
        semanticMap.put("nấu ăn", Arrays.asList("ẩm thực", "học nấu ăn", "làm bánh", "món truyền thống"));
        
        // Culture-related  
        semanticMap.put("văn hóa", Arrays.asList("truyền thống", "lễ hội", "làng nghề", "phố cổ", "chùa"));
        semanticMap.put("truyền thống", Arrays.asList("văn hóa", "làng nghề", "thủ công", "dân gian"));
        semanticMap.put("lễ hội", Arrays.asList("văn hóa", "festival", "múa", "ca nhạc", "truyền thống"));
        
        // Adventure-related
        semanticMap.put("phiêu lưu", Arrays.asList("thể thao", "leo núi", "trekking", "thiên nhiên", "mạo hiểm"));
        semanticMap.put("leo núi", Arrays.asList("phiêu lưu", "trekking", "núi", "thể thao", "thiên nhiên"));
        semanticMap.put("trekking", Arrays.asList("leo núi", "đi bộ", "khám phá", "núi", "rừng"));
        
        // Nature-related
        semanticMap.put("thiên nhiên", Arrays.asList("núi", "biển", "rừng", "thác", "hang động", "vịnh"));
        semanticMap.put("biển", Arrays.asList("thiên nhiên", "bơi", "lặn", "du thuyền", "câu cá"));
        semanticMap.put("núi", Arrays.asList("thiên nhiên", "leo núi", "trekking", "thác", "rừng"));

        List<String> related = new ArrayList<>();
        
        // Find related keywords
        for (Map.Entry<String, List<String>> entry : semanticMap.entrySet()) {
            if (entry.getKey().contains(query)) {
                related.addAll(entry.getValue());
            }
            for (String synonym : entry.getValue()) {
                if (synonym.contains(query)) {
                    related.add(entry.getKey());
                    related.addAll(entry.getValue());
                    break;
                }
            }
        }

        Set<String> uniqueRelated = new HashSet<>(related);
        List<String> result = new ArrayList<>();
        for (String keyword : uniqueRelated) {
            if (!keyword.equals(query) && result.size() < 3) {
                result.add(keyword);
            }
        }
        
        return result;
    }

    /**
     * Send success response with manual JSON construction
     */
    private void sendSuccessResponse(HttpServletResponse response, List<String> suggestions, String query) throws IOException {
        PrintWriter out = response.getWriter();
        
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"query\": \"").append(escapeJson(query)).append("\",");
        json.append("\"suggestions\": [");
        
        for (int i = 0; i < suggestions.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(escapeJson(suggestions.get(i))).append("\"");
        }
        
        json.append("]}");
        
        out.print(json.toString());
        out.flush();
    }

    /**
     * Send error response with manual JSON construction
     */
    private void sendErrorResponse(HttpServletResponse response, String message, int status) throws IOException {
        response.setStatus(status);
        PrintWriter out = response.getWriter();
        
        String json = "{\"success\": false, \"message\": \"" + escapeJson(message) + "\"}";
        out.print(json);
        out.flush();
    }

    /**
     * Escape special characters for JSON
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}