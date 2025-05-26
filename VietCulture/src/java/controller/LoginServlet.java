package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Show login form
        request.getRequestDispatcher("/view/jsp/home/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        try {
            // Validate input
            if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập email và mật khẩu.");
                request.getRequestDispatcher("/view/jsp/home/login.jsp").forward(request, response);
                return;
            }

            // Attempt login
            User user = userDAO.login(email.toLowerCase().trim(), password);

            if (user != null) {
                // Check if email is verified
                if (!user.isEmailVerified()) {
                    LOGGER.warning("Login attempt with unverified email: " + email);
                    request.setAttribute("error", "Email chưa được xác thực. Vui lòng kiểm tra hộp thư.");
                    request.setAttribute("unverifiedEmail", email);
                    request.getRequestDispatcher("/view/jsp/home/login.jsp").forward(request, response);
                    return;
                }

                // Check if account is active
                if (!user.isActive()) {
                    LOGGER.warning("Login attempt with inactive account: " + email);
                    request.setAttribute("error", "Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ.");
                    request.getRequestDispatcher("/view/jsp/home/login.jsp").forward(request, response);
                    return;
                }

                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role", user.getRole()); // Changed from userType to role
                session.setAttribute("fullName", user.getFullName());

                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);

                // Handle remember me
                if ("on".equals(remember)) {
                    // Could implement cookie-based remember me here
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days
                }

                LOGGER.info("User logged in successfully: " + email);

                // Redirect based on role
                String redirectUrl = determineRedirectUrl(user, request);
                response.sendRedirect(redirectUrl);

            } else {
                // Login failed
                LOGGER.warning("Failed login attempt for: " + email);
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                request.setAttribute("email", email); // Preserve email input
                request.getRequestDispatcher("/view/jsp/home/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during login", e);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/jsp/home/login.jsp").forward(request, response);
        }
    }

    /**
     * Determine redirect URL based on user role and return URL
     */
    private String determineRedirectUrl(User user, HttpServletRequest request) {
        String contextPath = request.getContextPath();

        // Check if there's a return URL
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl != null && !returnUrl.isEmpty() && returnUrl.startsWith(contextPath)) {
            return returnUrl;
        }

        // Redirect based on role
        switch (user.getRole()) {
            case "ADMIN":
                return contextPath + "/admin/dashboard";
            case "HOST":
                return contextPath + "/host/dashboard";
            case "TRAVELER":
                return contextPath + "/view/jsp/home/home.jsp";
            default:
                return contextPath + "/view/jsp/home/home.jsp";
        }
    }
}