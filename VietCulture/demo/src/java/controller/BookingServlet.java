package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;
import utils.PayOSConfig;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Servlet xử lý đặt tour và tạo link thanh toán PayOS.
 */
@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng tới trang đặt tour
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String customerName = request.getParameter("customerName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String tourName = request.getParameter("tourName");
            String amountStr = request.getParameter("amount");

            // Validate dữ liệu đầu vào
            if (customerName == null || customerName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || tourName == null || tourName.trim().isEmpty()
                    || amountStr == null || amountStr.trim().isEmpty()) {

                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            BigDecimal amount;
            try {
                amount = new BigDecimal(amountStr);
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new NumberFormatException("Số tiền phải lớn hơn 0");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Số tiền không hợp lệ");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Booking
            Booking booking = new Booking();
            booking.setCustomerName(customerName.trim());
            booking.setEmail(email.trim());
            booking.setPhone(phone.trim());
            booking.setTourName(tourName.trim());
            booking.setAmount(amount);
            booking.setPaymentStatus("Pending");
            booking.setCreatedAt(LocalDateTime.now());

            // Lưu vào database
            int bookingID = bookingDAO.addBooking(booking);
            if (bookingID == -1) {
                request.setAttribute("error", "Không thể lưu thông tin đặt tour. Vui lòng thử lại.");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // Tạo link thanh toán PayOS
            PayOS payOS = PayOSConfig.getPayOS();

            // Tạo item data với tên ngắn gọn
            String shortTourName = getTourShortName(tourName);
            ItemData item = ItemData.builder()
                    .name(shortTourName) // Rút ngắn tên tour
                    .quantity(1)
                    .price(amount.intValue())
                    .build();

            // URL redirect sau thanh toán
            String baseUrl = "http://localhost:8080" + request.getContextPath();
            String returnUrl = baseUrl + "/success.jsp?bookingId=" + bookingID;
            String cancelUrl = baseUrl + "/fail.jsp?bookingId=" + bookingID;

            // Tạo payment data với description ngắn (≤ 25 ký tự)
            String shortDescription = "Tour #" + bookingID;  // Ví dụ: "Tour #123" = 8 ký tự

            PaymentData paymentData = PaymentData.builder()
                    .orderCode((long) bookingID)
                    .amount(amount.intValue())
                    .description(shortDescription) // ≤ 25 ký tự
                    .returnUrl(returnUrl)
                    .cancelUrl(cancelUrl)
                    .item(item)
                    .build();

            // Gọi PayOS tạo link thanh toán
            CheckoutResponseData checkoutResponse = payOS.createPaymentLink(paymentData);

            // Chuyển dữ liệu sang JSP hiển thị
            request.setAttribute("paymentUrl", checkoutResponse.getCheckoutUrl());
            request.setAttribute("qrCodeData", checkoutResponse.getQrCode());
            request.setAttribute("bookingID", bookingID);
            request.setAttribute("customerName", customerName);
            request.setAttribute("tourName", tourName);
            request.setAttribute("amount", amount);

            request.getRequestDispatcher("payment_qr.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        }
    }

    /**
     * Rút ngắn tên tour để phù hợp với PayOS item name requirements
     */
    private String getTourShortName(String tourName) {
        if (tourName.contains("nông nghiệp")) {
            return "Tour Nông nghiệp";
        } else if (tourName.contains("làng nghề")) {
            return "Tour Làng nghề";
        } else if (tourName.contains("ẩm thực")) {
            return "Tour Ẩm thực";
        } else if (tourName.contains("văn hóa")) {
            return "Tour Văn hóa";
        } else {
            // Fallback: lấy 20 ký tự đầu
            return tourName.length() > 20 ? tourName.substring(0, 20) : tourName;
        }
    }
}
