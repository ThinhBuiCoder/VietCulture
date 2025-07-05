package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")  // Thay đổi từ "/ContactServlet" thành "/contact"
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/jsp/home/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý form submission
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // Logic xử lý...
        request.setAttribute("successMessage", "Cảm ơn bạn đã liên hệ!");
        request.getRequestDispatcher("/view/jsp/home/contact.jsp").forward(request, response);
    }
}
