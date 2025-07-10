package controller;

import model.Favorite;
import model.User;
import service.FavoriteService;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet(name = "FavoriteController", urlPatterns = {"/favorites", "/favorites/*"})
public class FavoriteController extends HttpServlet {

    private FavoriteService favoriteService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            favoriteService = new FavoriteService();
            gson = new Gson();
            System.out.println("FavoriteController initialized successfully");
        } catch (Exception e) {
            System.err.println("Error initializing FavoriteController: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize FavoriteController", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        System.out.println("FavoriteController GET - pathInfo: " + pathInfo);

        try {
            if (pathInfo == null || "/".equals(pathInfo)) {
                // Show favorites page
                showFavoritesPage(request, response);
            } else if ("/list".equals(pathInfo)) {
                // AJAX: Get user favorites list
                getUserFavoritesList(request, response);
            } else if ("/test".equals(pathInfo)) {
                // Debug/Test endpoint
                testFavorites(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Endpoint not found: " + pathInfo);
            }
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            handleException(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        System.out.println("FavoriteController POST - pathInfo: " + pathInfo);

        try {
            if ("/toggle".equals(pathInfo)) {
                // AJAX: Toggle favorite
                toggleFavorite(request, response);
            } else if ("/remove".equals(pathInfo)) {
                // AJAX: Remove favorite
                removeFavorite(request, response);
            } else if ("/clear".equals(pathInfo)) {
                // AJAX: Clear all favorites
                clearAllFavorites(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Endpoint not found: " + pathInfo);
            }
        } catch (Exception e) {
            System.err.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            handleException(request, response, e);
        }
    }

    // FIXED: Show favorites page with proper error handling
    private void showFavoritesPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Debug logging
        System.out.println("=== FAVORITES PAGE DEBUG ===");
        System.out.println("User: " + (user != null ? user.getFullName() : "null"));
        System.out.println("Role: " + (user != null ? user.getRole() : "null"));

        // Check authentication - RETURN EARLY TO AVOID DOUBLE RESPONSE
        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return; // CRITICAL: Return here to prevent further processing
        }
        
        try {
            System.out.println("Getting favorites for userId: " + user.getUserId());

            // Get user favorites with error handling
            List<Favorite> allFavorites = null;
            Map<String, Integer> counts = null;
            
            try {
                allFavorites = favoriteService.getUserFavorites(user.getUserId());
                counts = favoriteService.getFavoriteCounts(user.getUserId());
            } catch (Exception serviceException) {
                System.err.println("Service error: " + serviceException.getMessage());
                serviceException.printStackTrace();
                
                // Set empty defaults and error message
                allFavorites = new ArrayList<>();
                counts = new HashMap<>();
                counts.put("total", 0);
                counts.put("experience", 0);
                counts.put("accommodation", 0);
                
                request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách yêu thích. Vui lòng thử lại sau.");
            }

            // Ensure non-null values
            if (allFavorites == null) {
                allFavorites = new ArrayList<>();
            }
            if (counts == null) {
                counts = new HashMap<>();
                counts.put("total", 0);
                counts.put("experience", 0);
                counts.put("accommodation", 0);
            }

            System.out.println("Favorites retrieved: " + allFavorites.size());
            System.out.println("Experience count: " + counts.get("experience"));
            System.out.println("Accommodation count: " + counts.get("accommodation"));

            // Set attributes with null safety
            request.setAttribute("allFavorites", allFavorites);
            request.setAttribute("experienceCount", counts.get("experience") != null ? counts.get("experience") : 0);
            request.setAttribute("accommodationCount", counts.get("accommodation") != null ? counts.get("accommodation") : 0);
            request.setAttribute("totalCount", counts.get("total") != null ? counts.get("total") : 0);

            System.out.println("Forwarding to: /view/jsp/home/favorites.jsp");

            // Forward to JSP
            request.getRequestDispatcher("/view/jsp/home/favorites.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Unexpected error in showFavoritesPage: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values and error message
            request.setAttribute("allFavorites", new ArrayList<>());
            request.setAttribute("experienceCount", 0);
            request.setAttribute("accommodationCount", 0);
            request.setAttribute("totalCount", 0);
            request.setAttribute("error", "Có lỗi không mong muốn xảy ra: " + e.getMessage());

            // Forward to favorites page with error message
            request.getRequestDispatcher("/view/jsp/home/favorites.jsp").forward(request, response);
        }
    }

    // ENHANCED: Toggle favorite with better error handling
    private void toggleFavorite(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Debug logging
        System.out.println("=== TOGGLE FAVORITE DEBUG ===");
        System.out.println("User: " + (user != null ? user.getFullName() : "null"));
        System.out.println("Role: " + (user != null ? user.getRole() : "null"));

        // Check authentication
        if (user == null) {
            System.out.println("Unauthorized access attempt");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Vui lòng đăng nhập để sử dụng tính năng yêu thích"
            )));
            return;
        }

        try {
            // Parse JSON request
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }

            String jsonString = sb.toString();
            System.out.println("Received JSON: " + jsonString);

            if (jsonString == null || jsonString.trim().isEmpty()) {
                response.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "message", "Dữ liệu yêu cầu trống"
                )));
                return;
            }

            // Parse with better error handling
            Map<String, Object> requestData;
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> temp = gson.fromJson(jsonString, Map.class);
                requestData = temp;
            } catch (JsonSyntaxException e) {
                System.err.println("JSON parsing error: " + e.getMessage());
                response.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "message", "Dữ liệu JSON không hợp lệ"
                )));
                return;
            }

            // Check if this is a batch request
            if (requestData.containsKey("items") && requestData.get("items") instanceof List) {
                // Handle batch favorites
                handleBatchFavorites(request, response, user.getUserId(), requestData);
                return;
            }

            // Normal single favorite process
            Integer experienceId = null;
            Integer accommodationId = null;
            String itemType = null;

            // Handle experienceId
            if (requestData.containsKey("experienceId") && requestData.get("experienceId") != null) {
                Object expIdObj = requestData.get("experienceId");
                experienceId = convertToInteger(expIdObj);
            }

            // Handle accommodationId
            if (requestData.containsKey("accommodationId") && requestData.get("accommodationId") != null) {
                Object accIdObj = requestData.get("accommodationId");
                accommodationId = convertToInteger(accIdObj);
            }

            // Handle itemType
            if (requestData.containsKey("itemType")) {
                itemType = (String) requestData.get("itemType");
            }

            System.out.println("Parsed data - experienceId: " + experienceId + ", accommodationId: " + accommodationId + ", itemType: " + itemType);

            // Validate input
            if (itemType == null || (!itemType.equals("experience") && !itemType.equals("accommodation"))) {
                System.out.println("Invalid itemType: " + itemType);
                response.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "message", "Loại không hợp lệ"
                )));
                return;
            }

            if ((itemType.equals("experience") && experienceId == null) || 
                (itemType.equals("accommodation") && accommodationId == null)) {
                System.out.println("Missing required ID for itemType: " + itemType);
                response.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "message", "Thiếu ID của mục yêu thích"
                )));
                return;
            }

            // Call service with correct parameters
            Map<String, Object> result;
            if (itemType.equals("experience")) {
                result = favoriteService.toggleFavorite(user.getUserId(), itemType, experienceId);
            } else {
                result = favoriteService.toggleFavorite(user.getUserId(), itemType, accommodationId);
            }

            System.out.println("Service result: " + result);
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            System.err.println("Exception in toggleFavorite: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Có lỗi xảy ra: " + e.getMessage()
            )));
        }
    }

    // Handle batch favorites
    private void handleBatchFavorites(HttpServletRequest request, HttpServletResponse response, 
                                       int userId, Map<String, Object> requestData) throws IOException {
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> items = (List<Map<String, Object>>) requestData.get("items");
            boolean addToFavorites = requestData.containsKey("addToFavorites") ? 
                                     (Boolean) requestData.get("addToFavorites") : true;

            List<Map<String, Object>> results = new ArrayList<>();
            boolean allSuccess = true;
            int successCount = 0;

            System.out.println("Processing batch favorites - items: " + items.size());

            for (Map<String, Object> item : items) {
                String itemType = (String) item.get("itemType");
                Integer itemId = null;

                if ("experience".equals(itemType)) {
                    Object id = item.get("experienceId");
                    itemId = convertToInteger(id);
                } else if ("accommodation".equals(itemType)) {
                    Object id = item.get("accommodationId");
                    itemId = convertToInteger(id);
                }

                Map<String, Object> result = new HashMap<>();
                result.put("itemType", itemType);
                result.put("itemId", itemId);

                if (itemType != null && itemId != null) {
                    if (addToFavorites) {
                        Map<String, Object> toggleResult = favoriteService.toggleFavorite(userId, itemType, itemId);
                        // Copy all values from toggleResult to result
                        result.putAll(toggleResult);

                        if ((Boolean)toggleResult.get("success")) {
                            successCount++;
                        } else {
                            allSuccess = false;
                        }
                    } else {
                        // Find the favorite ID first
                        Favorite favorite = favoriteService.getFavoriteByUserAndItem(userId, itemType, itemId);
                        if (favorite != null && favorite.getFavoriteId() != null) {
                            Map<String, Object> removeResult = favoriteService.removeFavorite(userId, favorite.getFavoriteId());
                            result.putAll(removeResult);

                            if ((Boolean)removeResult.get("success")) {
                                successCount++;
                            } else {
                                allSuccess = false;
                            }
                        } else {
                            result.put("success", false);
                            result.put("message", "Mục yêu thích không tồn tại");
                            allSuccess = false;
                        }
                    }
                } else {
                    result.put("success", false);
                    result.put("message", "Dữ liệu không hợp lệ");
                    allSuccess = false;
                }

                results.add(result);
            }

            Map<String, Object> response_data = new HashMap<>();
            response_data.put("success", successCount > 0); // Success if at least one item was processed successfully
            response_data.put("results", results);
            response_data.put("successCount", successCount);

            if (successCount > 0) {
                response_data.put("message", successCount + " mục đã được xử lý thành công");
            } else {
                response_data.put("message", "Không có mục nào được xử lý thành công");
            }

            System.out.println("Batch result: " + successCount + " successful out of " + items.size());
            response.getWriter().write(gson.toJson(response_data));

        } catch (Exception e) {
            System.err.println("Exception in handleBatchFavorites: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Có lỗi xảy ra khi xử lý hàng loạt: " + e.getMessage()
            )));
        }
    }

    // IMPROVED: Get user favorites list
    private void getUserFavoritesList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"TRAVELER".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Unauthorized"
            )));
            return;
        }

        try {
            System.out.println("Getting favorites list for user: " + user.getUserId());
            Map<String, Object> result = favoriteService.getUserFavoriteIds(user.getUserId());
            System.out.println("Favorites list result: " + result);
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            System.err.println("Error getting favorites list: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Có lỗi xảy ra: " + e.getMessage()
            )));
        }
    }

    // ENHANCED: Remove favorite with better error handling
    private void removeFavorite(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"TRAVELER".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Không có quyền truy cập"
            )));
            return;
        }

        try {
            // Parse JSON request
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }

            String jsonString = sb.toString();
            if (jsonString == null || jsonString.trim().isEmpty()) {
                response.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "message", "Dữ liệu yêu cầu trống"
                )));
                return;
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> requestData = gson.fromJson(jsonString, Map.class);

            Integer favoriteId = convertToInteger(requestData.get("favoriteId"));

            if (favoriteId == null) {
                response.getWriter().write(gson.toJson(Map.of(
                    "success", false,
                    "message", "ID không hợp lệ"
                )));
                return;
            }

            // Remove favorite
            Map<String, Object> result = favoriteService.removeFavorite(user.getUserId(), favoriteId);
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Có lỗi xảy ra: " + e.getMessage()
            )));
        }
    }

    // Clear all favorites
    private void clearAllFavorites(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"TRAVELER".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Không có quyền truy cập"
            )));
            return;
        }

        try {
            boolean success = favoriteService.clearAllFavorites(user.getUserId());
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Đã xóa tất cả yêu thích thành công" : "Có lỗi xảy ra khi xóa");
            
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Có lỗi xảy ra: " + e.getMessage()
            )));
        }
    }

    // Test/Debug endpoint
    private void testFavorites(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Map<String, Object> result = new HashMap<>();
        result.put("endpoint", "favorites/test");
        result.put("userLoggedIn", user != null);
        result.put("userRole", user != null ? user.getRole() : "null");

        if (user != null && "TRAVELER".equals(user.getRole())) {
            try {
                Map<String, Object> testResult = favoriteService.testFavorites(user.getUserId());
                result.put("serviceTest", testResult);
            } catch (Exception e) {
                result.put("serviceTest", Map.of("error", e.getMessage()));
            }
        } else {
            result.put("message", "Only TRAVELER can test favorites");
        }

        response.getWriter().write(gson.toJson(result));
    }

    // UTILITY METHODS

    /**
     * Convert Object to Integer safely
     */
    private Integer convertToInteger(Object obj) {
        if (obj == null) {
            return null;
        }
        
        if (obj instanceof Integer) {
            return (Integer) obj;
        } else if (obj instanceof Double) {
            return ((Double) obj).intValue();
        } else if (obj instanceof String) {
            try {
                return Integer.parseInt((String) obj);
            } catch (NumberFormatException e) {
                System.err.println("Invalid number format: " + obj);
                return null;
            }
        } else if (obj instanceof Number) {
            return ((Number) obj).intValue();
        }
        
        System.err.println("Cannot convert to Integer: " + obj.getClass().getSimpleName());
        return null;
    }

    /**
     * Handle exceptions in a centralized way
     */
    private void handleException(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        
        System.err.println("Handling exception in FavoriteController: " + e.getMessage());
        e.printStackTrace();
        
        // Check if response is already committed
        if (response.isCommitted()) {
            System.err.println("Response already committed, cannot handle exception properly");
            return;
        }
        
        // For AJAX requests, return JSON error
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of(
                "success", false,
                "message", "Lỗi hệ thống: " + e.getMessage()
            )));
            return;
        }
        
        // For regular requests, show error page
        request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        request.setAttribute("allFavorites", new ArrayList<>());
        request.setAttribute("experienceCount", 0);
        request.setAttribute("accommodationCount", 0);
        request.setAttribute("totalCount", 0);
        
        try {
            request.getRequestDispatcher("/view/jsp/home/favorites.jsp").forward(request, response);
        } catch (Exception forwardException) {
            System.err.println("Failed to forward to error page: " + forwardException.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }
}