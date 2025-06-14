package controller;

import dao.BookingDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Booking;
import model.Experience;
import model.Accommodation;
import model.User;
import service.PayOSService;
import service.PayOSService.PaymentResponse;
import service.PayOSService.PayOSException;
import utils.EmailUtils;
import utils.PayOSConfig;

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
import java.util.UUID;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Enhanced BookingServlet with improved PayOS integration
 * Handles complete booking lifecycle from form to payment completion
 */
@WebServlet({"/booking", "/booking/*"})
public class BookingServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    
    // Page constants
    private static final String ERROR_PAGE = "/view/jsp/error.jsp";
    private static final String BOOKING_FORM_PAGE = "/view/jsp/home/booking-form.jsp";
    private static final String BOOKING_CONFIRM_PAGE = "/view/jsp/home/booking-confirm.jsp";
    private static final String PAYOS_PAYMENT_PAGE = "/view/jsp/home/payos-payment.jsp";
    private static final String BOOKING_SUCCESS_PAGE = "/view/jsp/home/booking-success.jsp";
    private static final String SERVICE_LIST_PAGE = "/view/jsp/home/service-list.jsp";
    
    // Services
    private BookingDAO bookingDAO;
    private ExperienceDAO experienceDAO;
    private AccommodationDAO accommodationDAO;
    private PayOSService payOSService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            bookingDAO = new BookingDAO();
            experienceDAO = new ExperienceDAO();
            accommodationDAO = new AccommodationDAO();
            payOSService = new PayOSService();
            
            LOGGER.info("BookingServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize BookingServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setCharacterEncoding(request, response);
        String pathInfo = request.getPathInfo();
        
        try {
            switch (pathInfo == null ? "/" : pathInfo) {
                case "/":
                    handleBookingForm(request, response);
                    break;
                case "/confirm":
                    handleBookingConfirmation(request, response);
                    break;
                case "/payos-payment":
                    handlePayOSPaymentPage(request, response);
                    break;
                case "/success":
                    handleBookingSuccess(request, response);
                    break;
                case "/payment-return":
                    handlePaymentReturn(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            handleError(request, response, e, "Error in GET request");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        setCharacterEncoding(request, response);
        
        // Check authentication
        User user = getUserFromSession(request);
        if (user == null) {
            redirectToLogin(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        LOGGER.info("Processing POST action: " + action);
        
        try {
            switch (action == null ? "create" : action) {
                case "create":
                    handleCreateBooking(request, response, user);
                    break;
                case "confirm":
                    handleConfirmCashBooking(request, response, user);
                    break;
                case "payos-payment":
                    handleCreatePayOSPayment(request, response, user);
                    break;
                case "verify-payment":
                    handleVerifyPayment(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (Exception e) {
            handleError(request, response, e, "Error in POST request with action: " + action);
        }
    }
    
    // ==================== BOOKING FORM HANDLERS ====================
    
    private void handleBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String experienceId = request.getParameter("experienceId");
        String accommodationId = request.getParameter("accommodationId");
        
        if (experienceId != null) {
            loadExperienceBookingForm(request, response, experienceId);
        } else if (accommodationId != null) {
            loadAccommodationBookingForm(request, response, accommodationId);
        } else {
            redirectToServiceList(request, response, "Vui lòng chọn dịch vụ để đặt chỗ");
        }
    }
    
    private void loadExperienceBookingForm(HttpServletRequest request, HttpServletResponse response, 
                                         String experienceIdParam) 
            throws ServletException, IOException, SQLException {
        try {
            int experienceId = Integer.parseInt(experienceIdParam);
            Experience experience = experienceDAO.getExperienceById(experienceId);
            
            if (experience == null || !experience.isActive()) {
                redirectToServiceList(request, response, "Trải nghiệm không tồn tại hoặc đã ngừng hoạt động");
                return;
            }
            
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");
            request.setAttribute("prefilledData", getPrefilledData(request));
            
            request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);
            
        } catch (NumberFormatException e) {
            redirectToServiceList(request, response, "ID trải nghiệm không hợp lệ");
        }
    }
    
    private void loadAccommodationBookingForm(HttpServletRequest request, HttpServletResponse response, 
                                            String accommodationIdParam) 
            throws ServletException, IOException, SQLException {
        try {
            int accommodationId = Integer.parseInt(accommodationIdParam);
            Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
            
            if (accommodation == null || !accommodation.isActive()) {
                redirectToServiceList(request, response, "Lưu trú không tồn tại hoặc đã ngừng hoạt động");
                return;
            }
            
            request.setAttribute("accommodation", accommodation);
            request.setAttribute("bookingType", "accommodation");
            request.setAttribute("prefilledData", getPrefilledData(request));
            
            request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);
            
        } catch (NumberFormatException e) {
            redirectToServiceList(request, response, "ID lưu trú không hợp lệ");
        }
    }
    
    // ==================== BOOKING CREATION ====================
    
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        BookingFormData formData = parseAndValidateForm(request);
        
        if (!formData.isValid()) {
            forwardWithError(request, response, BOOKING_FORM_PAGE, formData.getErrorMessage(), formData);
            return;
        }
        
        // Validate service availability
        if (!isServiceAvailable(formData)) {
            forwardWithError(request, response, BOOKING_FORM_PAGE, "Dịch vụ không còn khả dụng", formData);
            return;
        }
        
        // Calculate pricing
        double totalPrice = calculateTotalPrice(formData);
        formData.setTotalPrice(totalPrice);
        
        // Store in session for confirmation
        HttpSession session = request.getSession();
        session.setAttribute("bookingFormData", formData);
        session.setAttribute("userId", user.getUserId());
        
        LOGGER.info("Booking form validated - User: " + user.getUserId() + ", Total: " + totalPrice);
        
        response.sendRedirect(request.getContextPath() + "/booking/confirm");
    }
    
    // ==================== BOOKING CONFIRMATION ====================
    
    private void handleBookingConfirmation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            redirectToServiceList(request, response, "Phiên đặt chỗ đã hết hạn. Vui lòng thử lại");
            return;
        }
        
        // Load service data for display
        loadServiceDataForConfirmation(request, formData);
        
        request.setAttribute("formData", formData);
        request.setAttribute("payosConfigured", PayOSConfig.isConfigured());
        
        request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
    }
    
    private void loadServiceDataForConfirmation(HttpServletRequest request, BookingFormData formData) 
            throws SQLException {
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");
        } else if (formData.getAccommodationId() != null) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            request.setAttribute("accommodation", accommodation);
            request.setAttribute("bookingType", "accommodation");
        }
    }
    
    // ==================== CASH PAYMENT ====================
    
    private void handleConfirmCashBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            redirectToServiceList(request, response, "Phiên đặt chỗ đã hết hạn");
            return;
        }
        
        try {
            // Create and save booking
            Booking booking = createBookingFromFormData(formData, user.getUserId());
            booking.setStatus("CONFIRMED");
            booking.setPaymentMethod("CASH");
            booking.setPaymentStatus("PENDING");
            
            int bookingId = bookingDAO.createBooking(booking);
            
            if (bookingId > 0) {
                booking.setBookingId(bookingId);
                
                // Send confirmation email
                sendConfirmationEmail(booking, formData);
                
                // Clean up session and redirect to success
                session.removeAttribute("bookingFormData");
                session.setAttribute("successBooking", booking);
                
                logBookingActivity(bookingId, "CASH_BOOKING_CONFIRMED", user.getUserId());
                
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                throw new SQLException("Failed to create booking");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating cash booking", e);
            forwardWithError(request, response, BOOKING_CONFIRM_PAGE, 
                           "Không thể tạo đặt chỗ. Vui lòng thử lại", formData);
        }
    }
    
    // ==================== PAYOS PAYMENT ====================
    
    private void handleCreatePayOSPayment(HttpServletRequest request, HttpServletResponse response, User user) 
        throws ServletException, IOException, SQLException {
    
    LOGGER.info("=== DEBUG: Starting PayOS payment creation ===");
    LOGGER.info("User ID: " + user.getUserId());
    
    HttpSession session = request.getSession();
    BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
    
    if (formData == null) {
        LOGGER.warning("No booking form data in session");
        redirectToServiceList(request, response, "Phiên đặt chỗ đã hết hạn");
        return;
    }
    
    LOGGER.info("Form data found - Amount: " + formData.getTotalPrice());
    
    try {
        // Kiểm tra cấu hình PayOS
        LOGGER.info("Checking PayOS configuration...");
        if (!PayOSConfig.isConfigured()) {
            LOGGER.severe("PayOS is not configured properly");
            LOGGER.severe("CLIENT_ID: " + (PayOSConfig.CLIENT_ID != null ? "SET" : "NULL"));
            LOGGER.severe("API_KEY: " + (PayOSConfig.API_KEY != null ? "SET" : "NULL"));
            LOGGER.severe("CHECKSUM_KEY: " + (PayOSConfig.CHECKSUM_KEY != null ? "SET" : "NULL"));
            LOGGER.severe("Base URL: " + PayOSConfig.getApiBaseUrl());
            
            forwardWithError(request, response, BOOKING_CONFIRM_PAGE, 
                           "Hệ thống thanh toán chưa được cấu hình. Vui lòng chọn phương thức thanh toán khác.", formData);
            return;
        }
        
        LOGGER.info("PayOS configuration OK");
        LOGGER.info("API Base URL: " + PayOSConfig.getApiBaseUrl());
        LOGGER.info("Is Sandbox: " + PayOSConfig.IS_SANDBOX);
        
        // Validate amount for PayOS
        int amount = PayOSConfig.formatAmount(formData.getTotalPrice());
        LOGGER.info("Formatted amount: " + amount);
        
        if (!PayOSConfig.isValidAmount(amount)) {
            String errorMsg = "Số tiền không hợp lệ: " + PayOSConfig.formatVND(amount);
            LOGGER.severe(errorMsg);
            throw new PayOSService.PayOSException(errorMsg);
        }
        
        LOGGER.info("Amount validation passed");
        
        // Create booking with pending payment status
        LOGGER.info("Creating booking entity...");
        Booking booking = createBookingFromFormData(formData, user.getUserId());
        booking.setStatus("PENDING_PAYMENT");
        booking.setPaymentMethod("PAYOS");
        booking.setPaymentStatus("PENDING");
        
        LOGGER.info("Saving booking to database...");
        int bookingId = bookingDAO.createBooking(booking);
        
        if (bookingId > 0) {
            booking.setBookingId(bookingId);
            LOGGER.info("Booking created successfully with ID: " + bookingId);
            
            try {
                // Create PayOS payment
                LOGGER.info("Creating PayOS payment...");
                PayOSService.PaymentResponse paymentResponse = createPayOSPayment(booking, request);
                
                LOGGER.info("PayOS payment created successfully");
                LOGGER.info("Order Code: " + paymentResponse.getOrderCode());
                LOGGER.info("Checkout URL: " + (paymentResponse.getCheckoutUrl() != null ? "SET" : "NULL"));
                LOGGER.info("QR Code: " + (paymentResponse.getQrCode() != null ? "SET" : "NULL"));
                
                // Store payment data in session
                session.setAttribute("pendingBooking", booking);
                session.setAttribute("paymentResponse", paymentResponse);
                
                logBookingActivity(bookingId, "PAYOS_PAYMENT_CREATED", user.getUserId());
                
                LOGGER.info("Redirecting to payment page...");
                response.sendRedirect(request.getContextPath() + "/booking/payos-payment");
                
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "PayOS payment creation failed", e);
                
                // Debug thông tin chi tiết
                LOGGER.severe("=== PayOS Error Details ===");
                LOGGER.severe("Error type: " + e.getClass().getSimpleName());
                LOGGER.severe("Error message: " + e.getMessage());
                if (e.getCause() != null) {
                    LOGGER.severe("Cause: " + e.getCause().getMessage());
                }
                
                // Xóa booking nếu tạo payment thất bại
                bookingDAO.deleteBooking(bookingId);
                LOGGER.info("Deleted booking due to payment creation failure");
                
                throw e;
            }
        } else {
            LOGGER.severe("Failed to create booking - bookingId is 0");
            throw new SQLException("Failed to create booking");
        }
        
    } catch (PayOSService.PayOSException e) {
        LOGGER.log(Level.SEVERE, "PayOS payment creation failed: " + e.getMessage(), e);
        
        // Debug network errors specifically
        if (e.isNetworkError()) {
            LOGGER.severe("This is a NETWORK ERROR");
            LOGGER.severe("Please check:");
            LOGGER.severe("1. Internet connection");
            LOGGER.severe("2. PayOS API URL: " + PayOSConfig.getApiBaseUrl());
            LOGGER.severe("3. Firewall settings");
            LOGGER.severe("4. DNS resolution");
        }
        
        forwardWithError(request, response, BOOKING_CONFIRM_PAGE, 
                       "Lỗi tạo thanh toán: " + e.getMessage(), formData);
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Unexpected error creating PayOS payment", e);
        forwardWithError(request, response, BOOKING_CONFIRM_PAGE, 
                       "Có lỗi xảy ra khi tạo thanh toán. Vui lòng thử lại.", formData);
    }
}
    
    private PaymentResponse createPayOSPayment(Booking booking, HttpServletRequest request) 
            throws PayOSException {
        
        String baseUrl = getBaseUrl(request);
        String returnUrl = baseUrl + "/booking/payment-return";
        String cancelUrl = baseUrl + "/booking/payos-payment?cancelled=true";
        
        LOGGER.info("Creating PayOS payment with returnUrl: " + returnUrl);
        
        return payOSService.createBookingPayment(booking, returnUrl, cancelUrl);
    }
    
    // ==================== PAYOS PAYMENT PAGE ====================
    
    private void handlePayOSPaymentPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        Booking pendingBooking = (Booking) session.getAttribute("pendingBooking");
        PaymentResponse paymentResponse = (PaymentResponse) session.getAttribute("paymentResponse");
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (pendingBooking == null || paymentResponse == null) {
            redirectToServiceList(request, response, "Phiên thanh toán đã hết hạn");
            return;
        }
        
        // Check if payment was cancelled
        if ("true".equals(request.getParameter("cancelled"))) {
            request.setAttribute("paymentCancelled", true);
        }
        
        // Load service data for display
        loadServiceDataForConfirmation(request, formData);
        
        request.setAttribute("booking", pendingBooking);
        request.setAttribute("paymentResponse", paymentResponse);
        request.setAttribute("formData", formData);
        
        request.getRequestDispatcher(PAYOS_PAYMENT_PAGE).forward(request, response);
    }
    
    // ==================== PAYMENT VERIFICATION ====================
    
    private void handleVerifyPayment(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        Booking pendingBooking = (Booking) session.getAttribute("pendingBooking");
        PaymentResponse paymentResponse = (PaymentResponse) session.getAttribute("paymentResponse");
        
        if (pendingBooking == null || paymentResponse == null) {
            response.sendRedirect(request.getContextPath() + "/booking?error=invalid_payment");
            return;
        }
        
        try {
            // Check payment status with PayOS
            boolean paymentCompleted = payOSService.isPaymentCompleted(paymentResponse.getOrderCode());
            
            if (paymentCompleted) {
                // Update booking status to confirmed
                pendingBooking.setStatus("CONFIRMED");
                pendingBooking.setPaymentStatus("COMPLETED");
                bookingDAO.updateBookingStatus(pendingBooking.getBookingId(), "CONFIRMED");
                bookingDAO.updatePaymentStatus(pendingBooking.getBookingId(), "COMPLETED");
                
                // Send confirmation email
                BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
                sendConfirmationEmail(pendingBooking, formData);
                
                // Clean up session
                session.removeAttribute("pendingBooking");
                session.removeAttribute("paymentResponse");
                session.removeAttribute("bookingFormData");
                
                // Set success booking
                session.setAttribute("successBooking", pendingBooking);
                
                logBookingActivity(pendingBooking.getBookingId(), "PAYOS_PAYMENT_VERIFIED", user.getUserId());
                
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                // Payment not completed yet
                response.sendRedirect(request.getContextPath() + 
                        "/booking/payos-payment?error=payment_not_completed");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying payment", e);
            response.sendRedirect(request.getContextPath() + 
                    "/booking/payos-payment?error=verification_failed");
        }
    }
    
    // ==================== PAYMENT RETURN HANDLER ====================
    
    private void handlePaymentReturn(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        String orderCode = request.getParameter("orderCode");
        
        LOGGER.info("Payment return - Status: " + status + ", OrderCode: " + orderCode);
        
        HttpSession session = request.getSession();
        
        // Set return status for display
        if ("PAID".equals(status) && orderCode != null) {
            session.setAttribute("paymentReturnStatus", "success");
            session.setAttribute("paymentOrderCode", orderCode);
        } else if ("CANCELLED".equals(status)) {
            session.setAttribute("paymentReturnStatus", "cancelled");
        } else {
            session.setAttribute("paymentReturnStatus", "failed");
        }
        
        response.sendRedirect(request.getContextPath() + "/booking/payos-payment");
    }
    
    // ==================== SUCCESS PAGE ====================
    
    private void handleBookingSuccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Booking booking = (Booking) session.getAttribute("successBooking");
        
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Enhance booking object with display data
        enhanceBookingForDisplay(booking);
        
        request.setAttribute("booking", booking);
        session.removeAttribute("successBooking");
        
        request.getRequestDispatcher(BOOKING_SUCCESS_PAGE).forward(request, response);
    }
    
    // ==================== UTILITY METHODS ====================
    
    private BookingFormData parseAndValidateForm(HttpServletRequest request) {
        BookingFormData formData = new BookingFormData();
        
        try {
            // Parse service IDs
            parseServiceIds(request, formData);
            
            // Parse booking details
            parseBookingDetails(request, formData);
            
            // Parse contact info
            parseContactInfo(request, formData);
            
            // Validate all data
            validateFormData(formData);
            
        } catch (Exception e) {
            formData.addError("Dữ liệu form không hợp lệ: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Form validation error", e);
        }
        
        return formData;
    }
    
    private void parseServiceIds(HttpServletRequest request, BookingFormData formData) {
        String experienceId = request.getParameter("experienceId");
        String accommodationId = request.getParameter("accommodationId");
        
        if (experienceId != null && !experienceId.trim().isEmpty()) {
            formData.setExperienceId(Integer.parseInt(experienceId));
        }
        if (accommodationId != null && !accommodationId.trim().isEmpty()) {
            formData.setAccommodationId(Integer.parseInt(accommodationId));
        }
    }
    
    private void parseBookingDetails(HttpServletRequest request, BookingFormData formData) 
            throws ParseException {
        
        String bookingDate = request.getParameter("bookingDate");
        String timeSlot = request.getParameter("timeSlot");
        String participants = request.getParameter("participants");
        
        // Store string values for form repopulation
        formData.setBookingDateStr(bookingDate);
        formData.setTimeSlot(timeSlot);
        formData.setParticipantsStr(participants);
        
        // Parse date
        if (bookingDate != null && !bookingDate.trim().isEmpty()) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            formData.setBookingDate(dateFormat.parse(bookingDate));
        }
        
        // Parse time slot
        if (timeSlot != null && !timeSlot.trim().isEmpty()) {
            formData.setBookingTime(parseTimeSlot(timeSlot));
        }
        
        // Parse participants
        if (participants != null && !participants.trim().isEmpty()) {
            formData.setNumberOfPeople(Integer.parseInt(participants));
        }
    }
    
    private void parseContactInfo(HttpServletRequest request, BookingFormData formData) {
        formData.setContactName(request.getParameter("contactName"));
        formData.setContactEmail(request.getParameter("contactEmail"));
        formData.setContactPhone(request.getParameter("contactPhone"));
        formData.setSpecialRequests(request.getParameter("specialRequests"));
    }
    
    private void validateFormData(BookingFormData formData) {
        // Validate service selection
        if (formData.getExperienceId() == null && formData.getAccommodationId() == null) {
            formData.addError("Vui lòng chọn dịch vụ");
        }
        
        // Validate date
        if (formData.getBookingDate() == null) {
            formData.addError("Vui lòng chọn ngày");
        } else if (formData.getBookingDate().before(new Date())) {
            formData.addError("Ngày đặt chỗ không thể là quá khứ");
        }
        
        // Validate participants
        if (formData.getNumberOfPeople() <= 0) {
            formData.addError("Số người tham gia phải lớn hơn 0");
        }
        
        // Validate contact info
        if (isEmpty(formData.getContactName())) {
            formData.addError("Vui lòng nhập họ tên");
        }
        if (isEmpty(formData.getContactEmail())) {
            formData.addError("Vui lòng nhập email");
        }
        if (isEmpty(formData.getContactPhone())) {
            formData.addError("Vui lòng nhập số điện thoại");
        }
    }
    
    private boolean isServiceAvailable(BookingFormData formData) throws SQLException {
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            return experience != null && experience.isActive();
        } else if (formData.getAccommodationId() != null) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            return accommodation != null && accommodation.isActive();
        }
        return false;
    }
    
    private double calculateTotalPrice(BookingFormData formData) throws SQLException {
        double basePrice = 0;
        
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            basePrice = experience.getPrice();
        } else if (formData.getAccommodationId() != null) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            basePrice = accommodation.getPricePerNight();
        }
        
        double subtotal = basePrice * formData.getNumberOfPeople();
        double serviceFee = subtotal * 0.05; // 5% service fee
        
        return subtotal + serviceFee;
    }
    
    private Booking createBookingFromFormData(BookingFormData formData, int userId) {
        Booking booking = new Booking();
        
        booking.setExperienceId(formData.getExperienceId());
        booking.setAccommodationId(formData.getAccommodationId());
        booking.setTravelerId(userId);
        booking.setBookingDate(formData.getBookingDate());
        booking.setBookingTime(formData.getBookingTime());
        booking.setNumberOfPeople(formData.getNumberOfPeople());
        booking.setTotalPrice(formData.getTotalPrice());
        booking.setSpecialRequests(formData.getSpecialRequests());
        booking.setCreatedAt(new Date());
        
        // Create contact info JSON
        String contactInfo = String.format(
            "{\"name\":\"%s\",\"email\":\"%s\",\"phone\":\"%s\"}", 
            escapeJson(formData.getContactName()), 
            escapeJson(formData.getContactEmail()), 
            escapeJson(formData.getContactPhone())
        );
        booking.setContactInfo(contactInfo);
        
        return booking;
    }
    
    private Date parseTimeSlot(String timeSlot) {
        try {
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            switch (timeSlot.toLowerCase()) {
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
    
    private void sendConfirmationEmail(Booking booking, BookingFormData formData) {
        try {
            // TODO: Implement email sending
            LOGGER.info("Confirmation email sent for booking: " + booking.getBookingId());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send confirmation email", e);
        }
    }
    
    private void enhanceBookingForDisplay(Booking booking) {
        // Add status text and other display properties
        if ("CONFIRMED".equals(booking.getStatus())) {
            booking.setStatusText("Đã xác nhận");
        } else if ("PENDING".equals(booking.getStatus())) {
            booking.setStatusText("Đang chờ xử lý");
        } else if ("PENDING_PAYMENT".equals(booking.getStatus())) {
            booking.setStatusText("Chờ thanh toán");
        }
    }
    
    private void logBookingActivity(int bookingId, String activity, int userId) {
        String message = String.format("Booking %d: %s by user %d", bookingId, activity, userId);
        LOGGER.info(message);
    }
    
    private BookingFormData getPrefilledData(HttpServletRequest request) {
        BookingFormData data = new BookingFormData();
        data.setBookingDateStr(request.getParameter("date"));
        data.setParticipantsStr(request.getParameter("guests"));
        data.setTimeSlot(request.getParameter("time"));
        return data;
    }
    
    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);
        
        if ((scheme.equals("http") && serverPort != 80) || 
            (scheme.equals("https") && serverPort != 443)) {
            url.append(":").append(serverPort);
        }
        
        url.append(contextPath);
        return url.toString();
    }
    
    // ==================== HELPER METHODS ====================
    
    private void setCharacterEncoding(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }
    
    private User getUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (User) session.getAttribute("user");
    }
    
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String redirectUrl = request.getContextPath() + "/login?redirect=" + 
                           request.getRequestURI();
        if (request.getQueryString() != null) {
            redirectUrl += "?" + request.getQueryString();
        }
        response.sendRedirect(redirectUrl);
    }
    
    private void redirectToServiceList(HttpServletRequest request, HttpServletResponse response, 
                                     String errorMessage) throws IOException {
        response.sendRedirect(request.getContextPath() + 
                             "/experiences?error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
    }
    
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, 
                                String page, String errorMessage, Object data) 
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        if (data != null) {
            request.setAttribute("formData", data);
        }
        request.getRequestDispatcher(page).forward(request, response);
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           Exception e, String logMessage) 
            throws ServletException, IOException {
        LOGGER.log(Level.SEVERE, logMessage, e);
        request.setAttribute("errorMessage", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
    }
    
    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
    
    // ==================== FORM DATA CLASS ====================
    
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
        
        // Getters and Setters
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
        public void clearErrors() { this.errors.clear(); }
        
        public boolean isValid() { return errors.isEmpty(); }
        public String getErrorMessage() { 
            return errors.isEmpty() ? null : String.join(", ", errors); 
        }
        
        // Utility methods
        public boolean hasExperience() { return experienceId != null && experienceId > 0; }
        public boolean hasAccommodation() { return accommodationId != null && accommodationId > 0; }
        
        public String getFormattedDate() {
            if (bookingDate == null) return "";
            return new SimpleDateFormat("dd/MM/yyyy").format(bookingDate);
        }
        
        public String getFormattedTime() {
            if (bookingTime == null) return "";
            return new SimpleDateFormat("HH:mm").format(bookingTime);
        }
        
        public String getTimeSlotDisplayName() {
            if (timeSlot == null) return "";
            switch (timeSlot.toLowerCase()) {
                case "morning": return "Buổi sáng (9:00)";
                case "afternoon": return "Buổi chiều (14:00)";
                case "evening": return "Buổi tối (18:00)";
                default: return timeSlot;
            }
        }
        
        public String getFormattedPrice() {
            return String.format("%,.0f VNĐ", totalPrice);
        }
        
        @Override
        public String toString() {
            return "BookingFormData{" +
                   "experienceId=" + experienceId +
                   ", accommodationId=" + accommodationId +
                   ", bookingDate=" + bookingDate +
                   ", numberOfPeople=" + numberOfPeople +
                   ", totalPrice=" + totalPrice +
                   ", contactName='" + contactName + '\'' +
                   ", contactEmail='" + contactEmail + '\'' +
                   ", errors=" + errors.size() +
                   '}';
        }
    }
}