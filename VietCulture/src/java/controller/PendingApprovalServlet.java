package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "PendingApprovalServlet", urlPatterns = {"/Travel/host/pending_approval"})
public class PendingApprovalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is a host
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null || !"host".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/Travel/login");
            return;
        }

        // Forward to the pending approval page
        request.getRequestDispatcher("/view/jsp/host/pending_approval.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 