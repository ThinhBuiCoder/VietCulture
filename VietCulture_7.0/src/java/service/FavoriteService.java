package service;

import dao.FavoriteDAO;
import model.Favorite;
import model.User;
import java.util.*;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.stream.Collectors;
import static service.FavoriteService.ItemType.values;

public class FavoriteService {
    
    private static final Logger LOGGER = Logger.getLogger(FavoriteService.class.getName());
    private final FavoriteDAO favoriteDAO;
    
    // Enum cho loại mục yêu thích
    public enum ItemType {
        EXPERIENCE("experience"),
        ACCOMMODATION("accommodation");
        
        private final String value;
        
        ItemType(String value) {
            this.value = value;
        }
        
        public String getValue() {
            return value;
        }
        
        public static ItemType fromString(String type) {
            for (ItemType itemType : values()) {
                if (itemType.value.equalsIgnoreCase(type)) {
                    return itemType;
                }
            }
            throw new IllegalArgumentException("Invalid item type: " + type);
        }
    }
    
    public FavoriteService() {
        this.favoriteDAO = new FavoriteDAO();
        System.out.println("FavoriteService initialized with DAO: " + this.favoriteDAO);
    }
    
    /**
     * Toggle favorite (thêm/xóa) - FIXED VERSION
     */
    public Map<String, Object> toggleFavorite(int userId, String itemTypeStr, int itemId) {
        System.out.println("=== FavoriteService.toggleFavorite ===");
        System.out.println("userId: " + userId + ", itemType: " + itemTypeStr + ", itemId: " + itemId);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Validate input
            if (itemTypeStr == null || itemTypeStr.trim().isEmpty()) {
                return createErrorResponse("Loại mục không được để trống");
            }
            
            ItemType itemType = ItemType.fromString(itemTypeStr);
            
            Integer experienceId = itemType == ItemType.EXPERIENCE ? itemId : null;
            Integer accommodationId = itemType == ItemType.ACCOMMODATION ? itemId : null;
            
            // Kiểm tra trạng thái hiện tại
            boolean isFavorited = favoriteDAO.isFavorited(userId, experienceId, accommodationId);
            System.out.println("Current favorite status: " + isFavorited);
            
            boolean success;
            if (isFavorited) {
                // Xóa khỏi danh sách yêu thích
                System.out.println("Removing from favorites...");
                success = favoriteDAO.removeFavoriteByUserAndItem(userId, experienceId, accommodationId);
                response.put("action", "removed");
            } else {
                // Thêm vào danh sách yêu thích
                System.out.println("Adding to favorites...");
                success = favoriteDAO.addFavorite(userId, experienceId, accommodationId);
                response.put("action", "added");
            }
            
            // Chuẩn bị phản hồi
            response.put("success", success);
            response.put("isFavorited", !isFavorited);
            response.put("message", generateToggleMessage(itemType, !isFavorited));
            
            // Ghi log
            System.out.println("Toggle result: " + response);
            
            return response;
            
        } catch (IllegalArgumentException e) {
            // Xử lý loại mục không hợp lệ
            System.err.println("Invalid item type: " + itemTypeStr);
            return createErrorResponse("Loại mục không hợp lệ: " + itemTypeStr);
        } catch (Exception e) {
            // Xử lý các ngoại lệ không mong muốn
            System.err.println("Error in toggleFavorite: " + e.getMessage());
            e.printStackTrace();
            return createErrorResponse("Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    /**
     * Lấy danh sách yêu thích của người dùng - ENHANCED VERSION
     */
    public List<Favorite> getUserFavorites(int userId) {
        System.out.println("=== FavoriteService.getUserFavorites ===");
        System.out.println("Getting favorites for userId: " + userId);
        
        try {
            List<Favorite> favorites = favoriteDAO.getFavoritesByUser(userId);
            
            if (favorites == null) {
                System.out.println("DAO returned null, creating empty list");
                return new ArrayList<>();
            }
            
            if (favorites.isEmpty()) {
                System.out.println("No favorites found for user: " + userId);
                return favorites;
            }
            
            System.out.println("Found " + favorites.size() + " favorites for user " + userId);
            
            // Log chi tiết các mục yêu thích
            for (int i = 0; i < favorites.size(); i++) {
                Favorite favorite = favorites.get(i);
                System.out.println("Favorite " + i + ": ID=" + favorite.getFavoriteId() + 
                                   ", Type=" + favorite.getType() + 
                                   ", ExpId=" + favorite.getExperienceId() + 
                                   ", AccId=" + favorite.getAccommodationId());
            }
            
            return favorites;
            
        } catch (Exception e) {
            System.err.println("Error getting user favorites: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * Lấy ID các mục yêu thích - UNIFIED AND FIXED VERSION
     * This replaces both getUserFavoriteIds and getUserFavoriteIdsSimplified
     */
    public Map<String, Object> getUserFavoriteIds(int userId) {
        System.out.println("=== FavoriteService.getUserFavoriteIds ===");
        System.out.println("Getting favorite IDs for userId: " + userId);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Favorite> favorites = favoriteDAO.getFavoritesByUser(userId);
            
            List<Integer> experienceIds = new ArrayList<>();
            List<Integer> accommodationIds = new ArrayList<>();
            
            if (favorites != null && !favorites.isEmpty()) {
                for (Favorite favorite : favorites) {
                    System.out.println("Processing favorite: type=" + favorite.getType() + 
                                     ", expId=" + favorite.getExperienceId() + 
                                     ", accId=" + favorite.getAccommodationId());
                    
                    if ("experience".equals(favorite.getType()) && favorite.getExperienceId() != null) {
                        experienceIds.add(favorite.getExperienceId());
                        System.out.println("Added experience ID: " + favorite.getExperienceId());
                    } else if ("accommodation".equals(favorite.getType()) && favorite.getAccommodationId() != null) {
                        accommodationIds.add(favorite.getAccommodationId());
                        System.out.println("Added accommodation ID: " + favorite.getAccommodationId());
                    }
                }
            }
            
            System.out.println("Final experience IDs: " + experienceIds);
            System.out.println("Final accommodation IDs: " + accommodationIds);
            
            response.put("success", true);
            response.put("experienceIds", experienceIds);
            response.put("accommodationIds", accommodationIds);
            response.put("experienceCount", experienceIds.size());
            response.put("accommodationCount", accommodationIds.size());
            response.put("totalCount", experienceIds.size() + accommodationIds.size());
            
            return response;
            
        } catch (Exception e) {
            System.err.println("Error getting favorite IDs: " + e.getMessage());
            e.printStackTrace();
            return createErrorFavoriteIdsResponse();
        }
    }
    
    /**
     * Xóa mục yêu thích - FIXED VERSION (không cần getFavoriteById)
     */
    public Map<String, Object> removeFavorite(int userId, int favoriteId) {
        System.out.println("=== FavoriteService.removeFavorite ===");
        System.out.println("userId: " + userId + ", favoriteId: " + favoriteId);
        
        try {
            // Kiểm tra quyền sở hữu thông qua getUserFavorites
            List<Favorite> userFavorites = getUserFavorites(userId);
            boolean isOwner = false;
            
            for (Favorite favorite : userFavorites) {
                if (favorite.getFavoriteId() != null && favorite.getFavoriteId().equals(favoriteId)) {
                    isOwner = true;
                    break;
                }
            }
            
            if (!isOwner) {
                System.out.println("Unauthorized removal attempt - favoriteId: " + favoriteId + " not owned by userId: " + userId);
                return createErrorResponse("Không có quyền xóa mục này");
            }
            
            // Thực hiện xóa
            boolean success = favoriteDAO.removeFavorite(favoriteId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", success);
            response.put("message", success ? "Đã xóa thành công" : "Có lỗi xảy ra khi xóa");
            response.put("favoriteId", favoriteId);
            
            System.out.println("Remove result: " + response);
            
            return response;
            
        } catch (Exception e) {
            System.err.println("Error removing favorite: " + e.getMessage());
            e.printStackTrace();
            return createErrorResponse("Lỗi hệ thống khi xóa: " + e.getMessage());
        }
    }
    
    /**
     * Lấy thống kê về danh sách yêu thích
     */
    public Map<String, Object> getFavoriteStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            Map<String, Integer> counts = getFavoriteCounts(userId);
            List<Favorite> allFavorites = getUserFavorites(userId);
            
            stats.put("totalCount", counts.get("total"));
            stats.put("experienceCount", counts.get("experience"));
            stats.put("accommodationCount", counts.get("accommodation"));
            
            // Tính giá trung bình của các mục yêu thích
            double averagePrice = allFavorites.stream()
                    .mapToDouble(f -> {
                        if ("experience".equals(f.getType()) && f.getExperience() != null) {
                            return f.getExperience().getPrice();
                        } else if ("accommodation".equals(f.getType()) && f.getAccommodation() != null) {
                            return f.getAccommodation().getPricePerNight();
                        }
                        return 0.0;
                    })
                    .filter(price -> price > 0)
                    .average()
                    .orElse(0.0);
            
            stats.put("averagePrice", Math.round(averagePrice));
            stats.put("hasItems", counts.get("total") > 0);
            
        } catch (Exception e) {
            System.err.println("Error getting favorite stats: " + e.getMessage());
            e.printStackTrace();
            
            // Trả về các giá trị mặc định nếu có lỗi
            stats.put("totalCount", 0);
            stats.put("experienceCount", 0);
            stats.put("accommodationCount", 0);
            stats.put("averagePrice", 0);
            stats.put("hasItems", false);
        }
        
        return stats;
    }
    
    /**
     * Lấy số lượng mục yêu thích - FIXED VERSION
     */
    public Map<String, Integer> getFavoriteCounts(int userId) {
        System.out.println("=== FavoriteService.getFavoriteCounts ===");
        System.out.println("Getting counts for userId: " + userId);
        
        Map<String, Integer> countsMap = new HashMap<>();
        
        try {
            int[] counts = favoriteDAO.getFavoriteCounts(userId);
            
            // Đảm bảo mảng có đủ phần tử
            if (counts != null && counts.length >= 3) {
                countsMap.put("total", counts[0]);
                countsMap.put("experience", counts[1]);
                countsMap.put("accommodation", counts[2]);
            } else {
                System.err.println("getFavoriteCounts returned invalid array: " + Arrays.toString(counts));
                // Fallback: đếm từ getUserFavorites
                List<Favorite> favorites = getUserFavorites(userId);
                long expCount = favorites.stream().filter(f -> "experience".equals(f.getType())).count();
                long accCount = favorites.stream().filter(f -> "accommodation".equals(f.getType())).count();
                
                countsMap.put("total", favorites.size());
                countsMap.put("experience", (int) expCount);
                countsMap.put("accommodation", (int) accCount);
            }
            
            System.out.println("Counts result: " + countsMap);
            
        } catch (Exception e) {
            System.err.println("Error getting favorite counts: " + e.getMessage());
            e.printStackTrace();
            
            // Trả về các giá trị 0 nếu có lỗi
            countsMap.put("total", 0);
            countsMap.put("experience", 0);
            countsMap.put("accommodation", 0);
        }
        
        return countsMap;
    }
    
    /**
     * Kiểm tra đã yêu thích chưa
     */
    public boolean isFavorited(int userId, String itemType, int itemId) {
        try {
            ItemType type = ItemType.fromString(itemType);
            
            Integer experienceId = type == ItemType.EXPERIENCE ? itemId : null;
            Integer accommodationId = type == ItemType.ACCOMMODATION ? itemId : null;
            
            return favoriteDAO.isFavorited(userId, experienceId, accommodationId);
            
        } catch (Exception e) {
            System.err.println("Error checking favorite status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra và lấy mục yêu thích của người dùng
     */
    public Favorite getFavoriteByUserAndItem(int userId, String itemType, int itemId) {
        try {
            ItemType type = ItemType.fromString(itemType);
            
            Integer experienceId = type == ItemType.EXPERIENCE ? itemId : null;
            Integer accommodationId = type == ItemType.ACCOMMODATION ? itemId : null;
            
            return favoriteDAO.getFavoriteByUserAndItem(userId, experienceId, accommodationId);
            
        } catch (Exception e) {
            System.err.println("Error getting favorite by user and item: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Xóa tất cả mục yêu thích của người dùng
     */
    public boolean clearAllFavorites(int userId) {
        try {
            List<Favorite> favorites = getUserFavorites(userId);
            boolean allSuccess = true;
            
            for (Favorite favorite : favorites) {
                if (favorite.getFavoriteId() != null) {
                    boolean success = favoriteDAO.removeFavorite(favorite.getFavoriteId());
                    if (!success) {
                        allSuccess = false;
                        System.err.println("Failed to remove favorite " + favorite.getFavoriteId() + " for user " + userId);
                    }
                }
            }
            
            if (allSuccess) {
                System.out.println("Cleared all favorites for user " + userId);
            }
            
            return allSuccess;
            
        } catch (Exception e) {
            System.err.println("Error clearing all favorites for user " + userId);
            e.printStackTrace();
            return false;
        }
    }
    
    // ===== HELPER METHODS =====
    
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
    }
    
    private Map<String, Object> createErrorFavoriteIdsResponse() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("experienceIds", new ArrayList<>());
        response.put("accommodationIds", new ArrayList<>());
        response.put("experienceCount", 0);
        response.put("accommodationCount", 0);
        response.put("totalCount", 0);
        response.put("message", "Lỗi tải danh sách yêu thích");
        return response;
    }
    
    /**
     * Sinh message khi toggle favorite
     */
    private String generateToggleMessage(ItemType itemType, boolean isAdded) {
        String typeText = itemType == ItemType.EXPERIENCE ? "trải nghiệm" : "chỗ lưu trú";
        return isAdded 
            ? "Đã thêm " + typeText + " vào danh sách yêu thích" 
            : "Đã xóa " + typeText + " khỏi danh sách yêu thích";
    }
    
    /**
     * Test kết nối và dữ liệu - PHỤC VỤ DEBUG
     */
    public Map<String, Object> testFavorites(int userId) {
        System.out.println("=== FavoriteService.testFavorites ===");
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Kiểm tra khởi tạo DAO
            result.put("daoInitialized", favoriteDAO != null);
            
            // Kiểm tra kết nối database qua việc đếm số lượng
            int[] counts = favoriteDAO.getFavoriteCounts(userId);
            result.put("countsFromDAO", counts != null ? Arrays.toString(counts) : "null");
            
            // Lấy danh sách yêu thích
            List<Favorite> favorites = favoriteDAO.getFavoritesByUser(userId);
            result.put("favoritesFromDAO", favorites != null ? favorites.size() : "null");
            
            // Kiểm tra trạng thái yêu thích của một mục cụ thể
            if (favorites != null && !favorites.isEmpty()) {
                Favorite first = favorites.get(0);
                if ("experience".equals(first.getType()) && first.getExperienceId() != null) {
                    boolean isFav = favoriteDAO.isFavorited(userId, first.getExperienceId(), null);
                    result.put("testIsFavorited", isFav);
                }
            }
            
            result.put("success", true);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            result.put("stackTrace", Arrays.toString(e.getStackTrace()));
            System.err.println("Error in testFavorites: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Test result: " + result);
        return result;
    }
    
    /**
     * Kiểm tra loại mục có hợp lệ không
     */
    private boolean isValidItemType(String itemType) {
        return "experience".equals(itemType) || "accommodation".equals(itemType);
    }
    
    /**
     * Phương thức trợ giúp để in log chi tiết về danh sách yêu thích
     */
    private void logFavoriteDetails(List<Favorite> favorites) {
        if (favorites == null) {
            System.out.println("Favorites list is null");
            return;
        }
        
        System.out.println("Favorite Details - Total: " + favorites.size());
        for (int i = 0; i < favorites.size(); i++) {
            Favorite fav = favorites.get(i);
            System.out.printf("Favorite [%d]: ID=%d, Type=%s, ExpId=%d, AccId=%d%n", 
                i, 
                fav.getFavoriteId(), 
                fav.getType(), 
                fav.getExperienceId() != null ? fav.getExperienceId() : -1,
                fav.getAccommodationId() != null ? fav.getAccommodationId() : -1
            );
        }
    }
}