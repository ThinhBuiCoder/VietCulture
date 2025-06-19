package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.payos.PayOS;
import vn.payos.model.ItemData;
import vn.payos.model.PaymentData;
import vn.payos.model.PaymentLinkResponse;


import java.io.IOException;
import java.util.Collections;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private PayOS payOS;

    @Override
    public void init() throws ServletException {
        super.init();
        payOS = new PayOS("YOUR_CLIENT_ID", "YOUR_API_KEY", "YOUR_CHECKSUM_KEY");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String product = request.getParameter("productName");
        int qty = Integer.parseInt(request.getParameter("quantity"));
        int price = Integer.parseInt(request.getParameter("price"));
        long order += System.currentTimeMillis();
        int amount = qty * price;

        ItemData item = new ItemData(product, qty, price);
        PaymentData paymentData = new PaymentData(order, amount,
            "Thanh toán " + product, Collections.singletonList(item),
            "http://localhost:8080/demoPayOS/success.jsp",
            "http://localhost:8080/demoPayOS/cancel.jsp");

        try {
            PaymentLinkResponse res = payOS.createPaymentLink(paymentData);
            response.sendRedirect(res.getCheckoutUrl());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
