package controller;

import dao.BookingDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Booking;
import model.Experience;
import model.User;
import utils.PayOSUtils;
import utils.PayOSRequest;
import utils.PayOSResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * BookingServlet - Xử lý các yêu cầu đặt chỗ và thanh toán
 * 
 * Supported URLs:
 * - GET /booking: Hiển thị form đặt chỗ
 * - GET /booking/confirm: Hiển thị trang xác nhận
 * - GET /booking/success: Hiển thị trang thành công
 * - GET /booking/payment/success: Callback thanh toán thành công
 * - GET /booking/payment/cancel: Callback hủy thanh toán
 * - POST /booking: Tạo booking mới
 * - POST /booking (action=confirm): Xác nhận booking
 * - POST /booking (action=payment): Tạo link thanh toán
 * - POST /booking/webhook: PayOS webhook
 */
@WebServlet({"/booking", "/booking/*", "/payment/*"})
public class BookingServlet extends HttpServlet {
    
    // ==================== CONSTANTS & FIELDS ====================
    
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    private static final String ERROR_PAGE = "/view/jsp/error.jsp";
    private static final String BOOKING_FORM_PAGE = "/view/jsp/home/booking-form.jsp";
    private static final String BOOKING_CONFIRM_PAGE = "/view/jsp/home/booking-confirm.jsp";
    private static final String BOOKING_SUCCESS_PAGE = "/view/jsp/home/booking-success.jsp";
    
    private BookingDAO bookingDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    
    // ==================== SERVLET LIFECYCLE ====================
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            bookingDAO = new BookingDAO();
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            LOGGER.info("BookingServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize DAOs", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }
    
    // ==================== HTTP METHODS ====================
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setCharacterEncoding(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleBookingForm(request, response);
            } else if (pathInfo.equals("/confirm")) {
                handleBookingConfirmation(request, response);
            } else if (pathInfo.equals("/success")) {
                handleBookingSuccess(request, response);
            } else if (pathInfo.startsWith("/payment")) {
                handlePaymentCallback(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(request, response, e, "Database error in BookingServlet");
        } catch (Exception e) {
            handleError(request, response, e, "Unexpected error in BookingServlet");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setCharacterEncoding(request, response);
        
        // Kiểm tra đăng nhập
        User user = getUserFromSession(request);
        if (user == null) {
            redirectToLogin(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.equals("/webhook")) {
                handlePayOSWebhook(request, response);
            } else if ("confirm".equals(action)) {
                handleConfirmBooking(request, response, user);
            } else if ("payment".equals(action)) {
                handlePaymentRequest(request, response, user);
            } else {
                handleCreateBooking(request, response, user);
            }
        } catch (SQLException e) {
            handleError(request, response, e, "Database error in booking creation");
        } catch (Exception e) {
            handleError(request, response, e, "Unexpected error in booking creation");
        }
    }
    
    // ==================== BOOKING FORM HANDLERS ====================
    
    /**
     * Hiển thị form đặt chỗ
     */
    private void handleBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String experienceIdParam = request.getParameter("experienceId");
        String accommodationIdParam = request.getParameter("accommodationId");
        
        if (experienceIdParam != null) {
            handleExperienceBooking(request, response, experienceIdParam);
        } else if (accommodationIdParam != null) {
            handleAccommodationBooking(request, response, accommodationIdParam);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                             "Thiếu thông tin về dịch vụ cần đặt chỗ.");
        }
    }
    
    /**
     * Xử lý đặt chỗ cho trải nghiệm
     */
    private void handleExperienceBooking(HttpServletRequest request, HttpServletResponse response, 
                                       String experienceIdParam) 
            throws ServletException, IOException, SQLException {
        try {
            int experienceId = Integer.parseInt(experienceIdParam);
            Experience experience = experienceDAO.getExperienceById(experienceId);
            
            if (experience == null || !experience.isActive()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, 
                                 "Trải nghiệm không tồn tại hoặc đã bị tạm ngừng.");
                return;
            }
            
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");
            
            // Pre-fill data từ URL parameters
            BookingFormData prefilledData = getPrefilledBookingData(request);
            request.setAttribute("prefilledData", prefilledData);
            
            LOGGER.info("Displaying booking form for experienceId: " + experienceId);
            request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID trải nghiệm không hợp lệ.");
        }
    }
    
    /**
     * Xử lý đặt chỗ cho lưu trú
     */
    private void handleAccommodationBooking(HttpServletRequest request, HttpServletResponse response, 
                                          String accommodationIdParam) 
            throws ServletException, IOException, SQLException {
        try {
            int accommodationId = Integer.parseInt(accommodationIdParam);
            // TODO: Load accommodation data
            request.setAttribute("bookingType", "accommodation");
            request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID lưu trú không hợp lệ.");
        }
    }
    
    // ==================== BOOKING PROCESS HANDLERS ====================
    
    /**
     * Tạo booking mới (chuyển đến trang xác nhận)
     */
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        // Parse và validate form data
        BookingFormData formData = parseBookingForm(request);
        
        if (!formData.isValid()) {
            request.setAttribute("errorMessage", formData.getErrorMessage());
            request.setAttribute("formData", formData);
            handleBookingForm(request, response);
            return;
        }
        
        // Validate service availability
        if (!validateServiceAvailability(formData)) {
            request.setAttribute("errorMessage", "Dịch vụ không còn khả dụng.");
            request.setAttribute("formData", formData);
            handleBookingForm(request, response);
            return;
        }
        
        // Calculate pricing
        double totalPrice = calculateTotalPrice(formData);
        formData.setTotalPrice(totalPrice);
        
        // Store trong session
        HttpSession session = request.getSession();
        session.setAttribute("bookingFormData", formData);
        
        LOGGER.info("Booking form processed - User: " + user.getUserId() + 
                   ", ExperienceId: " + formData.getExperienceId() + 
                   ", Total: " + totalPrice);
        
        response.sendRedirect(request.getContextPath() + "/booking/confirm");
    }
    
    /**
     * Hiển thị trang xác nhận đặt chỗ
     */
    private void handleBookingConfirmation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }
        
        request.setAttribute("formData", formData);
        request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
    }
    
    /**
     * Xác nhận đặt chỗ (lưu vào database)
     */
    private void handleConfirmBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }
        
        try {
            Booking booking = createBookingFromFormData(formData, user.getUserId());
            int bookingId = bookingDAO.createBooking(booking);
            
            if (bookingId > 0) {
                booking.setBookingId(bookingId);
                
                // Clear form data và set success data
                session.removeAttribute("bookingFormData");
                session.setAttribute("successBooking", booking);
                
                // Log activity
                logBookingActivity(bookingId, "BOOKING_CONFIRMED", "Booking created without payment");
                
                LOGGER.info("Booking created successfully - ID: " + bookingId + 
                           ", User: " + user.getUserId());
                
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                throw new SQLException("Failed to create booking");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating booking", e);
            request.setAttribute("errorMessage", "Không thể tạo đặt chỗ. Vui lòng thử lại.");
            request.setAttribute("formData", formData);
            request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
        }
    }
    
    /**
     * Hiển thị trang đặt chỗ thành công
     */
    private void handleBookingSuccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Booking booking = (Booking) session.getAttribute("successBooking");
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.setAttribute("booking", booking);
        session.removeAttribute("successBooking");
        
        request.getRequestDispatcher(BOOKING_SUCCESS_PAGE).forward(request, response);
    }
    
    // ==================== PAYMENT HANDLERS ====================
    
    /**
     * Xử lý yêu cầu thanh toán PayOS
     */
    private void handlePaymentRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }
        
        try {
            // Validate payment amount
            if (!validatePaymentAmount(formData)) {
                request.setAttribute("errorMessage", "Số tiền thanh toán không hợp lệ.");
                request.setAttribute("formData", formData);
                request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
                return;
            }
            
            // Tạo booking với status PENDING_PAYMENT
            Booking booking = createBookingFromFormData(formData, user.getUserId());
            booking.setStatus("PENDING_PAYMENT");
            
            // Tạo PayOS payment link
            PayOSResponse payosResponse = createPayOSPayment(request, formData, booking);
            
            if (payosResponse.isSuccess()) {
                // Lưu booking vào DB
                int bookingId = bookingDAO.createBooking(booking);
                
                if (bookingId > 0) {
                    booking.setBookingId(bookingId);
                    
                    // Store payment info trong session
                    session.setAttribute("pendingPaymentBooking", booking);
                    session.setAttribute("paymentOrderCode", payosResponse.getOrderCode());
                    
                    // Log activity
                    logBookingActivity(bookingId, "PAYMENT_INITIATED", 
                        "Payment link created, order code: " + payosResponse.getOrderCode());
                    
                    // Redirect đến PayOS checkout
                    response.sendRedirect(payosResponse.getCheckoutUrl());
                    
                    LOGGER.info("Payment link created - Order: " + payosResponse.getOrderCode() + 
                               ", Booking: " + bookingId);
                } else {
                    throw new SQLException("Failed to create booking");
                }
            } else {
                request.setAttribute("errorMessage", "Không thể tạo link thanh toán: " + payosResponse.getMessage());
                request.setAttribute("formData", formData);
                request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating PayOS payment", e);
            request.setAttribute("errorMessage", "Lỗi hệ thống thanh toán. Vui lòng thử lại.");
            request.setAttribute("formData", formData);
            request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
        }
    }
    
    /**
     * Xử lý callback từ PayOS
     */
    private void handlePaymentCallback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String orderCodeParam = request.getParameter("orderCode");
        
        try {
            if (pathInfo.equals("/payment/success")) {
                handlePaymentSuccess(request, response, orderCodeParam);
            } else if (pathInfo.equals("/payment/cancel")) {
                handlePaymentCancel(request, response, orderCodeParam);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling payment callback", e);
            response.sendRedirect(request.getContextPath() + "/booking?error=payment_callback_error");
        }
    }
    
    /**
     * Xử lý thanh toán thành công
     */
    private void handlePaymentSuccess(HttpServletRequest request, HttpServletResponse response, String orderCode) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Booking pendingBooking = (Booking) session.getAttribute("pendingPaymentBooking");
        Long sessionOrderCode = (Long) session.getAttribute("paymentOrderCode");
        
        if (pendingBooking == null || sessionOrderCode == null || 
            !sessionOrderCode.toString().equals(orderCode)) {
            response.sendRedirect(request.getContextPath() + "/booking?error=invalid_payment");
            return;
        }
        
        try {
            // Xác minh thanh toán với PayOS
            boolean paymentVerified = PayOSUtils.verifyPaymentStatus(sessionOrderCode);
            
            if (paymentVerified) {
                // Cập nhật trạng thái booking
                pendingBooking.setStatus("CONFIRMED");
                bookingDAO.updateBookingStatus(pendingBooking.getBookingId(), "CONFIRMED");
                
                // Gửi email xác nhận
                BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
                if (formData != null) {
                    sendBookingConfirmationEmail(pendingBooking, formData);
                }
                
                // Log activity
                logBookingActivity(pendingBooking.getBookingId(), "PAYMENT_CONFIRMED", 
                    "Payment verified, order code: " + orderCode);
                
                // Clear session
                session.removeAttribute("pendingPaymentBooking");
                session.removeAttribute("paymentOrderCode");
                session.removeAttribute("bookingFormData");
                
                // Set success booking
                session.setAttribute("successBooking", pendingBooking);
                
                LOGGER.info("Payment successful - Order: " + orderCode + 
                           ", Booking: " + pendingBooking.getBookingId());
                
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                LOGGER.warning("Payment verification failed for order: " + orderCode);
                response.sendRedirect(request.getContextPath() + "/booking?error=payment_verification_failed");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking status after payment", e);
            response.sendRedirect(request.getContextPath() + "/booking?error=payment_processing_error");
        }
    }
    
    /**
     * Xử lý hủy thanh toán
     */
    private void handlePaymentCancel(HttpServletRequest request, HttpServletResponse response, String orderCode) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Booking pendingBooking = (Booking) session.getAttribute("pendingPaymentBooking");
        
        if (pendingBooking != null && orderCode != null) {
            try {
                // Hủy payment link
                PayOSUtils.cancelPaymentLink(Long.parseLong(orderCode), "User cancelled payment");
                
                // Xóa booking
                bookingDAO.deleteBooking(pendingBooking.getBookingId());
                
                // Log activity
                logBookingActivity(pendingBooking.getBookingId(), "PAYMENT_CANCELLED", 
                    "Payment cancelled, order code: " + orderCode);
                
                LOGGER.info("Payment cancelled and booking removed - Order: " + orderCode + 
                           ", Booking: " + pendingBooking.getBookingId());
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid order code format: " + orderCode, e);
            }
        }
        
        // Clear session
        session.removeAttribute("pendingPaymentBooking");
        session.removeAttribute("paymentOrderCode");
        
        response.sendRedirect(request.getContextPath() + "/booking?error=payment_cancelled");
    }
    
    /**
     * Xử lý PayOS webhook
     */
    private void handlePayOSWebhook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Đọc webhook body
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                stringBuilder.append(line);
            }
            String webhookBody = stringBuilder.toString();
            
            // Get signature
            String signature = request.getHeader("x-payos-signature");
            
            // Xử lý webhook
            PayOSUtils.PayOSWebhookData webhookData = PayOSUtils.processWebhook(webhookBody, signature);
            
            if (webhookData != null) {
                // Cập nhật trạng thái booking
                if (webhookData.isPaid()) {
                    bookingDAO.updateBookingStatus((int) webhookData.getOrderCode(), "CONFIRMED");
                    logBookingActivity((int) webhookData.getOrderCode(), "WEBHOOK_PAYMENT_CONFIRMED", 
                        "Webhook confirmed payment");
                    LOGGER.info("Booking confirmed via webhook - OrderCode: " + webhookData.getOrderCode());
                } else if (webhookData.isCancelled()) {
                    bookingDAO.updateBookingStatus((int) webhookData.getOrderCode(), "CANCELLED");
                    logBookingActivity((int) webhookData.getOrderCode(), "WEBHOOK_PAYMENT_CANCELLED", 
                        "Webhook confirmed cancellation");
                    LOGGER.info("Booking cancelled via webhook - OrderCode: " + webhookData.getOrderCode());
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid webhook data");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing PayOS webhook", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Webhook processing failed");
        }
    }
    
    // ==================== UTILITY METHODS ====================
    
    /**
     * Tạo PayOS payment request
     */
    private PayOSResponse createPayOSPayment(HttpServletRequest request, BookingFormData formData, 
                                           Booking booking) throws Exception {
        long orderCode = PayOSUtils.generateOrderCode();
        String baseUrl = getBaseUrl(request);
        
        PayOSRequest paymentRequest = new PayOSRequest(
            orderCode,
            (long) formData.getTotalPrice(),
            "Thanh toán đặt chỗ VietCulture #" + orderCode,
            baseUrl + "/booking/payment/cancel?orderCode=" + orderCode,
            baseUrl + "/booking/payment/success?orderCode=" + orderCode
        );
        
        // Set buyer info
        paymentRequest.setBuyerName(formData.getContactName());
        paymentRequest.setBuyerEmail(formData.getContactEmail());
        paymentRequest.setBuyerPhone(formData.getContactPhone());
        
        // Add items
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            paymentRequest.addItem(
                experience.getTitle(), 
                formData.getNumberOfPeople(), 
                (long) experience.getPrice()
            );
        }
        
        // Use simulated version for testing, switch to real API when ready
        return PayOSUtils.createPaymentLinkSimulated(paymentRequest);
        // return PayOSUtils.createPaymentLink(paymentRequest); // For production
    }
    
    /**
     * Parse booking form data
     */
    private BookingFormData parseBookingForm(HttpServletRequest request) {
        BookingFormData formData = new BookingFormData();
        
        try {
            // Parse IDs
            parseServiceIds(request, formData);
            
            // Parse booking details
            parseBookingDetails(request, formData);
            
            // Parse contact info
            parseContactInfo(request, formData);
            
            // Validate dates
            validateBookingDates(formData);
            
            // Validate required fields
            validateRequiredFields(formData);
            
        } catch (NumberFormatException e) {
            formData.addError("Dữ liệu số không hợp lệ.");
        } catch (ParseException e) {
            formData.addError("Định dạng ngày không hợp lệ.");
        } catch (Exception e) {
            formData.addError("Dữ liệu form không hợp lệ.");
        }
        
        return formData;
    }
    
    /**
     * Parse service IDs từ form
     */
    private void parseServiceIds(HttpServletRequest request, BookingFormData formData) {
        String experienceIdParam = request.getParameter("experienceId");
        String accommodationIdParam = request.getParameter("accommodationId");
        
        if (experienceIdParam != null && !experienceIdParam.trim().isEmpty()) {
            formData.setExperienceId(Integer.parseInt(experienceIdParam));
        }
        if (accommodationIdParam != null && !accommodationIdParam.trim().isEmpty()) {
            formData.setAccommodationId(Integer.parseInt(accommodationIdParam));
        }
    }
    
    /**
     * Parse booking details từ form
     */
    private void parseBookingDetails(HttpServletRequest request, BookingFormData formData) 
            throws ParseException {
        String bookingDateStr = request.getParameter("bookingDate");
        String timeSlot = request.getParameter("timeSlot");
        String participantsStr = request.getParameter("participants");
        
        formData.setBookingDateStr(bookingDateStr);
        formData.setTimeSlot(timeSlot);
        formData.setParticipantsStr(participantsStr);
        
        // Parse booking date
        if (bookingDateStr != null && !bookingDateStr.trim().isEmpty()) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date bookingDate = dateFormat.parse(bookingDateStr);
            formData.setBookingDate(bookingDate);
        }
        
        // Parse time slot
        if (timeSlot != null && !timeSlot.trim().isEmpty()) {
            Date bookingTime = parseTimeSlot(timeSlot);
            formData.setBookingTime(bookingTime);
        }
        
        // Parse participants
        if (participantsStr != null && !participantsStr.trim().isEmpty()) {
            int participants = Integer.parseInt(participantsStr);
            formData.setNumberOfPeople(participants);
        }
    }
    
    /**
     * Parse contact info từ form
     */
    private void parseContactInfo(HttpServletRequest request, BookingFormData formData) {
        formData.setContactName(request.getParameter("contactName"));
        formData.setContactEmail(request.getParameter("contactEmail"));
        formData.setContactPhone(request.getParameter("contactPhone"));
        formData.setSpecialRequests(request.getParameter("specialRequests"));
    }
    
    /**
     * Validate booking dates
     */
    private void validateBookingDates(BookingFormData formData) {
        if (formData.getBookingDate() == null) {
            formData.addError("Vui lòng chọn ngày đặt chỗ.");
        } else {
            Date today = new Date();
            if (formData.getBookingDate().before(today)) {
                formData.addError("Ngày đặt chỗ không thể là ngày trong quá khứ.");
            }
        }
        
        if (formData.getTimeSlot() == null || formData.getTimeSlot().trim().isEmpty()) {
            formData.addError("Vui lòng chọn khung giờ.");
        }
        
        if (formData.getNumberOfPeople() <= 0) {
            formData.addError("Số người tham gia phải lớn hơn 0.");
        }
    }
    
    /**
     * Validate required fields
     */
    private void validateRequiredFields(BookingFormData formData) {
        if (isNullOrEmpty(formData.getContactName())) {
            formData.addError("Vui lòng nhập họ tên liên hệ.");
        }
        if (isNullOrEmpty(formData.getContactEmail())) {
            formData.addError("Vui lòng nhập email liên hệ.");
        }
        if (isNullOrEmpty(formData.getContactPhone())) {
            formData.addError("Vui lòng nhập số điện thoại liên hệ.");
        }
    }
    
    /**
     * Validate service availability
     */
    private boolean validateServiceAvailability(BookingFormData formData) throws SQLException {
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            return experience != null && experience.isActive();
        }
        return true;
    }
    
    /**
     * Calculate total price
     */
    private double calculateTotalPrice(BookingFormData formData) throws SQLException {
        double basePrice = 0;
        
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            basePrice = experience.getPrice();
        }
        
        double totalPrice = basePrice * formData.getNumberOfPeople();
        double serviceFee = totalPrice * 0.05; // 5% service fee
        
        return totalPrice + serviceFee;
    }
    
    /**
     * Create Booking object từ form data
     */
    private Booking createBookingFromFormData(BookingFormData formData, int userId) {
        Booking booking = new Booking();
        
        booking.setExperienceId(formData.getExperienceId());
        booking.setAccommodationId(formData.getAccommodationId());
        booking.setTravelerId(userId);
        booking.setBookingDate(formData.getBookingDate());
        booking.setBookingTime(formData.getBookingTime());
        booking.setNumberOfPeople(formData.getNumberOfPeople());
        booking.setTotalPrice(formData.getTotalPrice());
        booking.setStatus("PENDING");
        booking.setSpecialRequests(formData.getSpecialRequests());
        
        // Create contact info JSON
        String contactInfo = String.format(
            "{\"name\":\"%s\",\"email\":\"%s\",\"phone\":\"%s\"}", 
            formData.getContactName(), 
            formData.getContactEmail(), 
            formData.getContactPhone()
        );
        booking.setContactInfo(contactInfo);
        
        return booking;
    }
    
    /**
     * Parse time slot to Date object
     */
    private Date parseTimeSlot(String timeSlot) {
        try {
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            switch (timeSlot) {
                case "morning":
                    return timeFormat.parse("09:00");
                case "afternoon":
                    return timeFormat.parse("14:00");
                case "evening":
                    return timeFormat.parse("18:00");
                default:
                    return timeFormat.parse("09:00");
            }
        } catch (ParseException e) {
            return new Date();
        }
    }
    
    /**
     * Get prefilled booking data từ URL parameters
     */
    private BookingFormData getPrefilledBookingData(HttpServletRequest request) {
        BookingFormData data = new BookingFormData();
        
        String dateParam = request.getParameter("date");
        String guestsParam = request.getParameter("guests");
        String timeParam = request.getParameter("time");
        
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            data.setBookingDateStr(dateParam.trim());
        }
        if (guestsParam != null && !guestsParam.trim().isEmpty()) {
            data.setParticipantsStr(guestsParam.trim());
        }
        if (timeParam != null && !timeParam.trim().isEmpty()) {
            data.setTimeSlot(timeParam.trim());
        }
        
        return data;
    }
    
    // ==================== ADDITIONAL UTILITY METHODS ====================
    
    /**
     * Verify payment với PayOS trước khi confirm booking
     */
    private boolean verifyPaymentWithPayOS(long orderCode) {
        try {
            return PayOSUtils.verifyPaymentStatus(orderCode);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to verify payment with PayOS for order: " + orderCode, e);
            return false;
        }
    }
    
    /**
     * Cancel PayOS payment link nếu user hủy booking
     */
    private void cancelPayOSPayment(long orderCode, String reason) {
        try {
            boolean cancelled = PayOSUtils.cancelPaymentLink(orderCode, reason);
            if (cancelled) {
                LOGGER.info("PayOS payment link cancelled for order: " + orderCode);
            } else {
                LOGGER.warning("Failed to cancel PayOS payment link for order: " + orderCode);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error cancelling PayOS payment for order: " + orderCode, e);
        }
    }
    
    /**
     * Send booking confirmation email
     */
    private void sendBookingConfirmationEmail(Booking booking, BookingFormData formData) {
        try {
            // TODO: Implement email service
            LOGGER.info("Booking confirmation email should be sent to: " + formData.getContactEmail() +
                       " for booking ID: " + booking.getBookingId());
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send booking confirmation email", e);
        }
    }
    
    /**
     * Log booking activity for audit trail
     */
    private void logBookingActivity(int bookingId, String activity, String details) {
        try {
            String logMessage = String.format("Booking %d: %s - %s", bookingId, activity, details);
            LOGGER.info(logMessage);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to log booking activity", e);
        }
    }
    
    /**
     * Check if user có thể book service này
     */
    private boolean canUserBookService(User user, BookingFormData formData) {
        try {
            return true; // TODO: Implement rate limiting and duplicate booking checks
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error checking user booking eligibility", e);
            return false;
        }
    }
    
    /**
     * Validate payment amount trước khi tạo PayOS link
     */
    private boolean validatePaymentAmount(BookingFormData formData) throws SQLException {
        double calculatedTotal = calculateTotalPrice(formData);
        double tolerance = 0.01;
        boolean amountMatches = Math.abs(calculatedTotal - formData.getTotalPrice()) < tolerance;
        
        if (!amountMatches) {
            LOGGER.warning("Payment amount mismatch - Calculated: " + calculatedTotal + 
                          ", Form: " + formData.getTotalPrice());
        }
        
        return amountMatches && calculatedTotal > 0;
    }
    
    // ==================== HELPER METHODS ====================
    
    /**
     * Set character encoding cho request và response
     */
    private void setCharacterEncoding(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }
    
    /**
     * Get user từ session
     */
    private User getUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (User) session.getAttribute("user");
    }
    
    /**
     * Redirect đến trang login
     */
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                            request.getRequestURI());
    }
    
    /**
     * Get base URL từ request
     */
    private String getBaseUrl(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName() + 
               (request.getServerPort() != 80 && request.getServerPort() != 443 ? 
                ":" + request.getServerPort() : "") +
               request.getContextPath();
    }
    
    /**
     * Check if string is null hoặc empty
     */
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Handle errors và forward đến error page
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           Exception e, String logMessage) 
            throws ServletException, IOException {
        LOGGER.log(Level.SEVERE, logMessage, e);
        request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại sau.");
        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
    }
    
    // ==================== INNER CLASSES ====================
    
    /**
     * Booking form data container class
     */
    public static class BookingFormData {
        private Integer experienceId;
        private Integer accommodationId;
        private Date bookingDate;
        private String bookingDateStr;
        private Date bookingTime;
        private String timeSlot;
        private int numberOfPeople;
        private String participantsStr;
        private double totalPrice;
        private String contactName;
        private String contactEmail;
        private String contactPhone;
        private String specialRequests;
        private List<String> errors = new ArrayList<>();
        
        // ==================== GETTERS & SETTERS ====================
        
        public Integer getExperienceId() { return experienceId; }
        public void setExperienceId(Integer experienceId) { this.experienceId = experienceId; }
        public Integer getAccommodationId() { return accommodationId; }
        public void setAccommodationId(Integer accommodationId) { this.accommodationId = accommodationId; }
        public Date getBookingDate() { return bookingDate; }
        public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
        public String getBookingDateStr() { return bookingDateStr; }
        public void setBookingDateStr(String bookingDateStr) { this.bookingDateStr = bookingDateStr; }
        public Date getBookingTime() { return bookingTime; }
        public void setBookingTime(Date bookingTime) { this.bookingTime = bookingTime; }
        public String getTimeSlot() { return timeSlot; }
        public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
        public int getNumberOfPeople() { return numberOfPeople; }
        public void setNumberOfPeople(int numberOfPeople) { this.numberOfPeople = numberOfPeople; }
        public String getParticipantsStr() { return participantsStr; }
        public void setParticipantsStr(String participantsStr) { this.participantsStr = participantsStr; }
        public double getTotalPrice() { return totalPrice; }
        public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
        public String getContactName() { return contactName; }
        public void setContactName(String contactName) { this.contactName = contactName; }
        public String getContactEmail() { return contactEmail; }
        public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
        public String getContactPhone() { return contactPhone; }
        public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
        public String getSpecialRequests() { return specialRequests; }
        public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
        public List<String> getErrors() { return errors; }
        public void addError(String error) { this.errors.add(error); }
        public boolean isValid() { return errors.isEmpty(); }
        public String getErrorMessage() { return errors.isEmpty() ? null : String.join(", ", errors); }
        
        // ==================== UTILITY METHODS ====================
        
        public void clearErrors() { this.errors.clear(); }
        public boolean hasExperience() { return experienceId != null && experienceId > 0; }
        public boolean hasAccommodation() { return accommodationId != null && accommodationId > 0; }
        
        public String getFormattedBookingDate() {
            if (bookingDate == null) return "";
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            return formatter.format(bookingDate);
        }
        
        public String getFormattedBookingTime() {
            if (bookingTime == null) return "";
            SimpleDateFormat formatter = new SimpleDateFormat("HH:mm");
            return formatter.format(bookingTime);
        }
        
        public String getTimeSlotDisplayName() {
            if (timeSlot == null) return "";
            switch (timeSlot) {
                case "morning": return "Buổi sáng (9:00)";
                case "afternoon": return "Buổi chiều (14:00)";
                case "evening": return "Buổi tối (18:00)";
                default: return timeSlot;
            }
        }
        
        public String getFormattedTotalPrice() {
            return String.format("%,.0f VNĐ", totalPrice);
        }
        
        @Override
        public String toString() {
            return "BookingFormData{" +
                   "experienceId=" + experienceId +
                   ", accommodationId=" + accommodationId +
                   ", bookingDate=" + bookingDate +
                   ", timeSlot='" + timeSlot + '\'' +
                   ", numberOfPeople=" + numberOfPeople +
                   ", totalPrice=" + totalPrice +
                   ", contactName='" + contactName + '\'' +
                   ", contactEmail='" + contactEmail + '\'' +
                   ", contactPhone='" + contactPhone + '\'' +
                   ", errors=" + errors.size() +
                   '}';
        }
    }
}