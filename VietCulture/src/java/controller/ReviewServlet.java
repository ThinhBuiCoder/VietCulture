package controller;

import dao.ReviewDAO;
import model.Review;
import model.User;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/*", "/submitReview"})
public class ReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Hiển thị danh sách đánh giá
                handleGetAllReviews(request, response);
            } else if (pathInfo.equals("/new")) {
                // Hiển thị form đánh giá mới
                showReviewForm(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Xem chi tiết một đánh giá
                int reviewId = Integer.parseInt(pathInfo.substring(1));
                handleGetReviewById(reviewId, response);
            } else if (pathInfo.matches("/\\d+/edit")) {
                // Hiển thị form chỉnh sửa đánh giá
                int reviewId = Integer.parseInt(pathInfo.split("/")[1]);
                showEditReviewForm(request, response, reviewId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Vui lòng đăng nhập để đánh giá")));
            return;
        }

        try {
            // Parse request parameters
            Integer experienceId = parseIntegerParameter(request, "experienceId");
            Integer accommodationId = parseIntegerParameter(request, "accommodationId");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            String photos = request.getParameter("photos");

            // Validate input
            if (rating < 1 || rating > 5) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Điểm đánh giá phải từ 1 đến 5")));
                return;
            }

            if (experienceId == null && accommodationId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Phải chọn trải nghiệm hoặc chỗ ở để đánh giá")));
                return;
            }

            // Create review object
            Review review = new Review();
            review.setExperienceId(experienceId);
            review.setAccommodationId(accommodationId);
            review.setTravelerId(user.getUserId());
            review.setRating(rating);
            review.setComment(comment);
            review.setPhotos(photos);
            review.setCreatedAt(new Date());
            review.setVisible(true);

            // Save to database
            int reviewId = reviewDAO.createReview(review);
            if (reviewId > 0) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write(gson.toJson(new ServerResponse(true, "Đánh giá đã được tạo thành công", reviewId)));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không thể tạo đánh giá")));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Dữ liệu đầu vào không hợp lệ")));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during review creation", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Lỗi cơ sở dữ liệu")));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Vui lòng đăng nhập")));
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Thiếu ID đánh giá")));
            return;
        }

        try {
            int reviewId = Integer.parseInt(pathInfo.substring(1));
            Review existingReview = reviewDAO.getReviewById(reviewId);

            if (existingReview == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không tìm thấy đánh giá")));
                return;
            }

            // Check if user is the owner or admin
            if (existingReview.getTravelerId() != user.getUserId() && !user.isAdmin()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không có quyền chỉnh sửa đánh giá này")));
                return;
            }

            // Update review fields
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            String photos = request.getParameter("photos");

            if (rating < 1 || rating > 5) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Điểm đánh giá phải từ 1 đến 5")));
                return;
            }

            existingReview.setRating(rating);
            existingReview.setComment(comment);
            existingReview.setPhotos(photos);

            if (reviewDAO.updateReview(existingReview)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(new ServerResponse(true, "Đánh giá đã được cập nhật")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không thể cập nhật đánh giá")));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "ID đánh giá không hợp lệ")));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during review update", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Lỗi cơ sở dữ liệu")));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Vui lòng đăng nhập")));
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Thiếu ID đánh giá")));
            return;
        }

        try {
            int reviewId = Integer.parseInt(pathInfo.substring(1));
            Review review = reviewDAO.getReviewById(reviewId);

            if (review == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không tìm thấy đánh giá")));
                return;
            }

            // Check if user is the owner or admin
            if (review.getTravelerId() != user.getUserId() && !user.isAdmin()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không có quyền xóa đánh giá này")));
                return;
            }

            String deleteReason = request.getParameter("reason");
            if (reviewDAO.softDeleteReview(reviewId, deleteReason)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(new ServerResponse(true, "Đánh giá đã được xóa")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không thể xóa đánh giá")));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "ID đánh giá không hợp lệ")));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during review deletion", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Lỗi cơ sở dữ liệu")));
        }
    }

    private void handleGetAllReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = Integer.parseInt(request.getParameter("page"));
            int pageSize = Integer.parseInt(request.getParameter("pageSize"));
            List<Review> reviews = reviewDAO.getAllReviews(page, pageSize);
            response.getWriter().write(gson.toJson(reviews));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Tham số trang không hợp lệ")));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching reviews", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Lỗi cơ sở dữ liệu")));
        }
    }

    private void handleGetReviewById(int reviewId, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Review review = reviewDAO.getReviewById(reviewId);
            if (review != null) {
                response.getWriter().write(gson.toJson(review));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(new ServerResponse(false, "Không tìm thấy đánh giá")));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching review", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(new ServerResponse(false, "Lỗi cơ sở dữ liệu")));
        }
    }

    private Integer parseIntegerParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void showReviewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ request parameters
        String reviewType = request.getParameter("type"); // "experience" hoặc "accommodation"
        String itemId = request.getParameter("id");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }

        // Set các thuộc tính cần thiết cho form
        request.setAttribute("reviewType", reviewType);
        if ("experience".equals(reviewType)) {
            request.setAttribute("experienceId", itemId);
        } else if ("accommodation".equals(reviewType)) {
            request.setAttribute("accommodationId", itemId);
        }

        // Forward đến trang JSP
        request.getRequestDispatcher("/WEB-INF/jsp/review/review-form.jsp").forward(request, response);
    }

    private void showEditReviewForm(HttpServletRequest request, HttpServletResponse response, int reviewId)
            throws ServletException, IOException, SQLException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }

        // Lấy thông tin review
        Review review = reviewDAO.getReviewById(reviewId);
        if (review == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đánh giá");
            return;
        }

        // Kiểm tra quyền chỉnh sửa
        if (review.getTravelerId() != user.getUserId() && !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền chỉnh sửa đánh giá này");
            return;
        }

        // Set các thuộc tính cho form
        request.setAttribute("review", review);
        request.setAttribute("reviewType", review.getExperienceId() != null ? "experience" : "accommodation");

        // Forward đến trang JSP
        request.getRequestDispatcher("/WEB-INF/jsp/review/review-form.jsp").forward(request, response);
    }

    // Helper class for JSON response
    private static class ServerResponse {
        private final boolean success;
        private final String message;
        private final Integer reviewId;

        public ServerResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
            this.reviewId = null;
        }

        public ServerResponse(boolean success, String message, Integer reviewId) {
            this.success = success;
            this.message = message;
            this.reviewId = reviewId;
        }
    }
} 