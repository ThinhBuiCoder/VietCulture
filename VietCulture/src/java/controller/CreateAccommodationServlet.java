package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;
import dao.AccommodationDAO;
import model.Accommodation;
import java.io.ByteArrayOutputStream;

@WebServlet({"/Travel/create_accommodation"})
@MultipartConfig(
    maxFileSize = 16777215,    // 16MB per file
    maxRequestSize = 25165824, // 24MB total
    fileSizeThreshold = 5242880 // 5MB
)
public class CreateAccommodationServlet extends HttpServlet {      
    private static final Logger LOGGER = Logger.getLogger(CreateAccommodationServlet.class.getName());
    private AccommodationDAO accommodationDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        accommodationDAO = new AccommodationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Đang xử lý GET cho /Travel/create_accommodation");
        try {
            request.getRequestDispatcher("/view/jsp/host/accommodations/create_accommodation.jsp").forward(request, response);
            LOGGER.info("Chuyển tiếp đến create_accommodation.jsp thành công");
        } catch (Exception e) {
            LOGGER.severe("Lỗi khi chuyển tiếp đến JSP: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể hiển thị trang tạo lưu trú.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String address = request.getParameter("address");
            int cityId = Integer.parseInt(request.getParameter("cityId"));
            String type = request.getParameter("type");
            double pricePerNight = Double.parseDouble(request.getParameter("price"));
            int numberOfRooms = Integer.parseInt(request.getParameter("bedrooms"));
            String amenities = request.getParameter("amenities");
            Part filePart = request.getPart("image");

            // Input validation
            List<String> errors = new ArrayList<>();
            if (name == null || name.trim().isEmpty()) {
                errors.add("Tên lưu trú là bắt buộc.");
            }
            if (description == null || description.trim().isEmpty()) {
                errors.add("Mô tả là bắt buộc.");
            }
            if (address == null || address.trim().isEmpty()) {
                errors.add("Địa chỉ là bắt buộc.");
            }
            if (pricePerNight <= 0) {
                errors.add("Giá phải lớn hơn 0.");
            }
            if (numberOfRooms <= 0) {
                errors.add("Số phòng ngủ phải lớn hơn 0.");
            }

            // Validate image upload
            StringBuilder images = new StringBuilder();
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (!contentType.startsWith("image/")) {
                    errors.add("Chỉ cho phép tải lên file ảnh.");
                } else {
                    try (InputStream inputStream = filePart.getInputStream();
                         ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                        byte[] buffer = new byte[8192];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        String base64Image = java.util.Base64.getEncoder().encodeToString(outputStream.toByteArray());
                        images.append(base64Image);
                    }
                }
            } else {
                errors.add("Ảnh là bắt buộc.");
            }

            // If there are validation errors, forward back to form
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/view/jsp/host/accommodations/create_accommodation.jsp").forward(request, response);
                return;
            }

            // Get host ID from session (assuming user is authenticated)
            HttpSession session = request.getSession();
            Integer hostId = (Integer) session.getAttribute("userId");
            if (hostId == null) {
                request.setAttribute("errors", List.of("Người dùng chưa xác thực."));
                request.getRequestDispatcher("/view/jsp/host/accommodations/create_accommodation.jsp").forward(request, response);
                return;
            }

            // Create Accommodation object with submitted values
            Accommodation accommodation = new Accommodation();
            accommodation.setHostId(hostId);
            accommodation.setName(name.trim());
            accommodation.setDescription(description.trim());
            accommodation.setAddress(address.trim());
            accommodation.setCityId(cityId);
            accommodation.setType(type);
            accommodation.setPricePerNight(pricePerNight);
            accommodation.setNumberOfRooms(numberOfRooms);
            accommodation.setAmenities(amenities);
            accommodation.setImages(images.toString());
            accommodation.setCreatedAt(new Date());
            accommodation.setActive(false); // Default to inactive (pending approval)
            accommodation.setAverageRating(0.0);
            accommodation.setTotalBookings(0);

            // Save to database using DAO
            try {
                int accommodationId = accommodationDAO.createAccommodation(accommodation);
                if (accommodationId == 0) {
                    request.setAttribute("errors", List.of("Không thể tạo lưu trú. Vui lòng thử lại."));
                    request.getRequestDispatcher("/view/jsp/host/accommodations/create_accommodation.jsp").forward(request, response);
                    return;
                }
                
                // Success: redirect to the pending approval page
                response.setCharacterEncoding("UTF-8");
                response.setHeader("Content-Type", "text/html; charset=UTF-8");
                response.sendRedirect(request.getContextPath() + "/Travel/host/pending_approval?type=accommodation");
                return;
            } catch (SQLException e) {
                LOGGER.severe("Database error: " + e.getMessage());
                request.setAttribute("errors", List.of("Lỗi cơ sở dữ liệu khi tạo lưu trú. Vui lòng thử lại sau."));
                request.getRequestDispatcher("/view/jsp/host/accommodations/create_accommodation.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            LOGGER.severe("Error in accommodation creation: " + e.getMessage());
            request.setAttribute("errors", List.of("Có lỗi xảy ra khi tạo lưu trú: " + e.getMessage() + ". Vui lòng thử lại."));
            request.getRequestDispatcher("/view/jsp/host/accommodations/create_accommodation.jsp").forward(request, response);
        }
    }
} 