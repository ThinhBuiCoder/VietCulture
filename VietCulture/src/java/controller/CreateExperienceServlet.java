package controller;

import dao.ExperienceDAO;
import model.Experience;
import utils.FileUploadUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

@WebServlet("/Travel/create_experience")
@MultipartConfig(
    maxFileSize = 16777215,    // 16MB per file
    maxRequestSize = 25165824, // 24MB total
    fileSizeThreshold = 5242880 // 5MB
)
public class CreateExperienceServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CreateExperienceServlet.class.getName());
    private ExperienceDAO experienceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        experienceDAO = new ExperienceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Đang xử lý GET cho /Travel/create_experience");
        try {
            request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
            LOGGER.info("Chuyển tiếp đến create_experience.jsp thành công");
        } catch (Exception e) {
            LOGGER.severe("Lỗi khi chuyển tiếp đến JSP: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể hiển thị trang tạo trải nghiệm.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            // Input validation
            List<String> errors = new ArrayList<>();

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            int cityId = Integer.parseInt(request.getParameter("cityId"));
            String type = request.getParameter("type");
            double price = Double.parseDouble(request.getParameter("price"));
            int maxGroupSize = Integer.parseInt(request.getParameter("maxGroupSize"));
            String difficulty = request.getParameter("difficulty");
            String language = request.getParameter("language");
            String includedItems = request.getParameter("includedItems");
            String requirements = request.getParameter("requirements");
            Part filePart = request.getPart("experienceImage");
            
            // Parse duration string to Date object
            Date durationDate = null;
            String durationString = request.getParameter("duration");
            if (durationString != null && !durationString.trim().isEmpty()) {
                try {
                    // Assuming the format is HH:mm
                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    durationDate = timeFormat.parse(durationString);
                } catch (ParseException e) {
                    errors.add("Định dạng thời lượng không hợp lệ. Vui lòng sử dụng HH:mm.");
                }
            } else {
                errors.add("Thời lượng là bắt buộc.");
            }

            // Input validation
            if (title == null || title.trim().isEmpty()) {
                errors.add("Tên trải nghiệm là bắt buộc.");
            }
            if (description == null || description.trim().isEmpty()) {
                errors.add("Mô tả là bắt buộc.");
            }
            if (location == null || location.trim().isEmpty()) {
                errors.add("Địa điểm là bắt buộc.");
            }
            if (price <= 0) {
                errors.add("Giá phải lớn hơn 0.");
            }
            if (maxGroupSize <= 0) {
                errors.add("Số người tối đa phải lớn hơn 0.");
            }

            // Handle image upload using FileUploadUtils
            String fileName = FileUploadUtils.uploadExperienceImage(filePart, request);
            if (fileName == null) {
                errors.add("Lỗi khi tải lên ảnh. Vui lòng thử lại.");
            }

            // If there are validation errors, forward back to form
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
                return;
            }

            // Get host ID from session (assuming user is authenticated)
            HttpSession session = request.getSession();
            Integer hostId = (Integer) session.getAttribute("userId");
            if (hostId == null) {
                request.setAttribute("errors", List.of("Người dùng chưa xác thực."));
                request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
                return;
            }

            // Create Experience object with submitted values
            Experience experience = new Experience(
                hostId,
                title.trim(),
                description.trim(),
                location.trim(),
                cityId,
                type,
                price,
                maxGroupSize,
                durationDate, // Use the parsed Date object
                difficulty,
                language
            );
            experience.setImages(fileName); // Store the file name, not Base64
            experience.setIncludedItems(includedItems);
            experience.setRequirements(requirements);
            experience.setCreatedAt(new Date());
            experience.setActive(false); // Default to inactive (pending approval)

            // Save to database using DAO
            try {
                int experienceId = experienceDAO.createExperience(experience);
                if (experienceId == 0) {
                    request.setAttribute("errors", List.of("Không thể tạo trải nghiệm. Vui lòng thử lại."));
                    request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
                    return;
                }
                LOGGER.info("Experience created with ID: " + experienceId); // Log new experience ID
                
                // Success: redirect to the pending approval page
                response.setCharacterEncoding("UTF-8");
                response.setHeader("Content-Type", "text/html; charset=UTF-8");
                response.sendRedirect(request.getContextPath() + "/Travel/host/pending_approval?type=experience");
                return;
            } catch (SQLException e) {
                LOGGER.severe("Database error: " + e.getMessage());
                request.setAttribute("errors", List.of("Lỗi cơ sở dữ liệu khi tạo trải nghiệm. Vui lòng thử lại sau."));
                request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid number format (this should now be handled by specific checks): " + e.getMessage());
            request.setAttribute("errors", List.of("Dữ liệu số không hợp lệ. Vui lòng kiểm tra lại giá, số người tối đa."));
            request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error processing request: " + e.getMessage());
            request.setAttribute("errors", List.of("Đã xảy ra lỗi không mong muốn khi tạo trải nghiệm."));
            request.getRequestDispatcher("/view/jsp/host/experiences/create_experience.jsp").forward(request, response);
        }
    }
}