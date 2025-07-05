package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/host/bookings/manage")
public class HostBookingManageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"HOST".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        BookingDAO bookingDAO = new BookingDAO();
        try {
            List<Booking> bookings = bookingDAO.getAllBookingsByHost(user.getUserId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/view/jsp/host/booking-manage.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String action = request.getParameter("action"); // CONFIRMED hoặc REJECTED

        if (bookingIdStr != null && action != null) {
            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDAO bookingDAO = new BookingDAO();
            try {
                bookingDAO.updateBookingStatus(bookingId, action);
                response.setStatus(HttpServletResponse.SC_OK);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
} 