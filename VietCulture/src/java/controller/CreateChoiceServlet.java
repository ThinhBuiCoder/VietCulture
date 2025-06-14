package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/Travel/create_choice")
public class CreateChoiceServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CreateChoiceServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Đang xử lý GET cho /Travel/create_choice");
        request.getRequestDispatcher("/view/jsp/host/create_choice.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Đang xử lý POST cho /Travel/create_choice");
        
        // Kiểm tra authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("User chưa đăng nhập");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String choice = request.getParameter("choice");
        LOGGER.info("Lựa chọn được chọn: " + choice);
        
        try {
            switch (choice) {
                case "experience":
                    LOGGER.info("Chuyển hướng đến trang tạo trải nghiệm");
                    response.sendRedirect(request.getContextPath() + "/Travel/create_experience");
                    break;
                case "accommodation":
                    LOGGER.info("Chuyển hướng đến trang tạo lưu trú");
                    response.sendRedirect(request.getContextPath() + "/Travel/create_accommodation");
                    break;
                default:
                    LOGGER.warning("Lựa chọn không hợp lệ: " + choice);
                    request.setAttribute("error", "Vui lòng chọn một lựa chọn hợp lệ");
                    request.getRequestDispatcher("/view/jsp/host/create_choice.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.severe("Lỗi khi xử lý lựa chọn: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("/view/jsp/host/create_choice.jsp").forward(request, response);
        }
    }
}
