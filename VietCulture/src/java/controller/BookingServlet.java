package controller;

import dao.BookingDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Booking;
import model.Experience;
import model.Accommodation;
import model.User;
import utils.EmailUtils;
<<<<<<< HEAD
import utils.PayOSConfig;

import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
=======
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a

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
import java.util.Calendar;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
<<<<<<< HEAD
 * Enhanced BookingServlet with improved Accommodation handling
 * Maintains all existing Experience functionality while enhancing Accommodation support
=======
 * 
 * Supported URLs:
 * - GET /booking: Hiển thị form đặt chỗ
 * - GET /booking/confirm: Hiển thị trang xác nhận
 * - GET /booking/momo-payment: Hiển thị trang thanh toán MoMo QR
 * - GET /booking/success: Hiển thị trang thành công
 * - POST /booking: Tạo booking mới
 * - POST /booking (action=confirm): Xác nhận booking tiền mặt
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
 */
@WebServlet({"/booking", "/booking/*"})
public class BookingServlet extends HttpServlet {

    // ==================== CONSTANTS & FIELDS ====================
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    private static final String ERROR_PAGE = "/view/jsp/error.jsp";
    private static final String BOOKING_FORM_PAGE = "/view/jsp/home/booking-form.jsp";
    private static final String BOOKING_CONFIRM_PAGE = "/view/jsp/home/booking-confirm.jsp";
    private static final String BOOKING_SUCCESS_PAGE = "/view/jsp/home/booking-success.jsp";
    private static final String BOOKING_FAIL_PAGE = "/view/jsp/home/booking-fail.jsp";
    private static final String PAYOS_PAYMENT_PAGE = "/view/jsp/home/payos-payment.jsp";

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
<<<<<<< HEAD
            } else if (pathInfo.equals("/payos-payment")) {
                handlePayOSPaymentPage(request, response);
            } else if (pathInfo.equals("/success")) {
                handleBookingSuccess(request, response);
            } else if (pathInfo.equals("/fail")) {
                handleBookingFail(request, response);
=======
            } else if (pathInfo.equals("/momo-payment")) {
                handleMoMoPaymentPage(request, response);
            } else if (pathInfo.equals("/success")) {
                handleBookingSuccess(request, response);
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
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
<<<<<<< HEAD

        try {
            if ("confirm".equals(action)) {
                handleConfirmBooking(request, response, user);
            } else if ("payos-payment".equals(action)) {
                handlePayOSPaymentRequest(request, response, user);
=======
        
        try {
            if ("confirm".equals(action)) {
                handleConfirmBooking(request, response, user);
            } else if ("momo-payment".equals(action)) {
                handleMoMoPaymentRequest(request, response, user);
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
            } else if ("complete-payment".equals(action)) {
                handleCompletePayment(request, response, user);
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
     * Enhanced booking form handler with improved service type detection
     */
    private void handleBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String serviceType = detectServiceType(request);
        LOGGER.info("handleBookingForm - detected service type: " + serviceType);

        switch (serviceType) {
            case "experience":
                String experienceId = request.getParameter("experienceId");
                if (experienceId != null && !experienceId.trim().isEmpty()) {
                    handleExperienceBooking(request, response, experienceId);
                } else {
                    sendErrorResponse(request, response, "Experience ID is required");
                }
                break;

            case "accommodation":
                String accommodationId = request.getParameter("accommodationId");
                if (accommodationId != null && !accommodationId.trim().isEmpty()) {
                    handleAccommodationBooking(request, response, accommodationId);
                } else {
                    sendErrorResponse(request, response, "Accommodation ID is required");
                }
                break;

            default:
                handleBookingFromSession(request, response);
                break;
        }
    }

    /**
     * Enhanced service type detection with improved logic
     */
    private String detectServiceType(HttpServletRequest request) {
        // Priority 1: Explicit service type parameter
        String serviceType = request.getParameter("serviceType");
        if (serviceType != null && !serviceType.trim().isEmpty()) {
            return serviceType.toLowerCase();
        }

        // Priority 2: Service ID parameters
        String experienceId = request.getParameter("experienceId");
        String accommodationId = request.getParameter("accommodationId");
        
        if (experienceId != null && !experienceId.trim().isEmpty()) {
            return "experience";
        }
        if (accommodationId != null && !accommodationId.trim().isEmpty()) {
            return "accommodation";
        }

        // Priority 3: Check for accommodation-specific parameters
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String guests = request.getParameter("guests");
        
        if ((checkIn != null && !checkIn.trim().isEmpty()) ||
            (checkOut != null && !checkOut.trim().isEmpty()) ||
            (guests != null && !guests.trim().isEmpty())) {
            return "accommodation";
        }

        // Priority 4: Check for experience-specific parameters
        String timeSlot = request.getParameter("timeSlot");
        String participants = request.getParameter("participants");
        String bookingDate = request.getParameter("bookingDate");
        
        if ((timeSlot != null && !timeSlot.trim().isEmpty()) ||
            (participants != null && !participants.trim().isEmpty()) ||
            (bookingDate != null && !bookingDate.trim().isEmpty())) {
            return "experience";
        }

        // Priority 5: Check session data
        HttpSession session = request.getSession(false);
        if (session != null) {
            BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
            if (formData != null) {
                return formData.getServiceType();
            }
        }

        // Priority 6: Check referer URL
        String referer = request.getHeader("Referer");
        if (referer != null) {
            if (referer.contains("/experiences/")) {
                return "experience";
            } else if (referer.contains("/accommodations/")) {
                return "accommodation";
            }
        }

        return "unknown";
    }

    /**
     * Handle experience booking (keeping existing functionality)
     */
    private void handleExperienceBooking(HttpServletRequest request, HttpServletResponse response,
            String experienceIdParam) throws ServletException, IOException, SQLException {
        try {
            int experienceId = Integer.parseInt(experienceIdParam);
            LOGGER.info("Loading experience with ID: " + experienceId);

            Experience experience = experienceDAO.getExperienceById(experienceId);
            if (experience == null) {
                LOGGER.warning("Experience not found for ID: " + experienceId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Trải nghiệm không tồn tại với ID: " + experienceId);
                return;
            }

            if (!experience.isActive()) {
                LOGGER.warning("Experience is not active for ID: " + experienceId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trải nghiệm đã bị tạm ngừng.");
                return;
            }

            LOGGER.info("Successfully loaded experience: " + experience.getTitle());
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");

            // Pre-fill data từ URL parameters
            BookingFormData prefilledData = getPrefilledExperienceData(request);
            request.setAttribute("formData", prefilledData);

            LOGGER.info("Forwarding to booking form page: " + BOOKING_FORM_PAGE);
            request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid experience ID format: " + experienceIdParam);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                             "ID trải nghiệm không hợp lệ: " + experienceIdParam);
        }
    }

    /**
     * Enhanced accommodation booking handler
     */
    private void handleAccommodationBooking(HttpServletRequest request, HttpServletResponse response,
            String accommodationIdParam) throws ServletException, IOException, SQLException {
        try {
            int accommodationId = Integer.parseInt(accommodationIdParam);
            LOGGER.info("Loading accommodation with ID: " + accommodationId);

            Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationId);
            if (accommodation == null) {
                LOGGER.warning("Accommodation not found for ID: " + accommodationId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Chỗ lưu trú không tồn tại với ID: " + accommodationId);
                return;
            }

            if (!accommodation.isActive()) {
                LOGGER.warning("Accommodation is not active for ID: " + accommodationId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Chỗ lưu trú đã bị tạm ngừng.");
                return;
            }

            LOGGER.info("Successfully loaded accommodation: " + accommodation.getName());
            request.setAttribute("accommodation", accommodation);
            request.setAttribute("bookingType", "accommodation");

            // Enhanced pre-fill data for accommodation
            BookingFormData prefilledData = getPrefilledAccommodationData(request);
            request.setAttribute("formData", prefilledData);

            LOGGER.info("Forwarding to booking form page for accommodation: " + BOOKING_FORM_PAGE);
            request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid accommodation ID format: " + accommodationIdParam);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                             "ID lưu trú không hợp lệ: " + accommodationIdParam);
        }
    }

    // ==================== BOOKING PROCESS HANDLERS ====================
    /**
     * Enhanced booking creation with improved accommodation support
     */
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException, SQLException {

        // Parse và validate form data
        BookingFormData formData = parseBookingForm(request);

        if (!formData.isValid()) {
            request.setAttribute("errorMessage", formData.getErrorMessage());
            request.setAttribute("formData", formData);
            forwardToAppropriateForm(request, response, formData);
            return;
        }

        // Validate service availability
        if (!validateServiceAvailability(formData)) {
            request.setAttribute("errorMessage", "Dịch vụ không còn khả dụng.");
            request.setAttribute("formData", formData);
            forwardToAppropriateForm(request, response, formData);
            return;
        }

        // Calculate pricing
        double totalPrice = calculateTotalPrice(formData);
        formData.setTotalPrice(totalPrice);

        // Store trong session
        HttpSession session = request.getSession();
        session.setAttribute("bookingFormData", formData);

        LOGGER.info("Booking form processed - User: " + user.getUserId()
                + ", Type: " + formData.getServiceType()
                + ", ServiceId: " + formData.getServiceId()
                + ", Total: " + totalPrice);

        response.sendRedirect(request.getContextPath() + "/booking/confirm");
    }

    /**
     * Enhanced PayOS payment handler for both service types
     */
<<<<<<< HEAD
    private void handlePayOSPaymentRequest(HttpServletRequest request, HttpServletResponse response, User user)
=======
    private void handleBookingConfirmation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }
        
        // Load experience data for display
        if (formData.getExperienceId() != null) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");
        }
        
        request.setAttribute("formData", formData);
        request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
    }
    
    /**
     * Xác nhận đặt chỗ tiền mặt (lưu vào database)
     */
    private void handleConfirmBooking(HttpServletRequest request, HttpServletResponse response, User user) 
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
            throws ServletException, IOException, SQLException {

        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");

        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }

        try {
            // Tạo booking với status PENDING
            Booking booking = createBookingFromFormData(formData, user.getUserId());
<<<<<<< HEAD
            booking.setStatus("PENDING");
            int bookingId = bookingDAO.createBooking(booking);

            if (bookingId <= 0) {
=======
            booking.setStatus("CONFIRMED"); // Tiền mặt -> xác nhận luôn
            int bookingId = bookingDAO.createBooking(booking);
            
            if (bookingId > 0) {
                booking.setBookingId(bookingId);
                
                // Gửi email xác nhận
                sendBookingConfirmationEmail(booking, formData, user);
                
                // Clear form data và set success data
                session.removeAttribute("bookingFormData");
                session.setAttribute("successBooking", booking);
                
                // Log activity
                logBookingActivity(bookingId, "CASH_PAYMENT_CONFIRMED", "Booking confirmed with cash payment");
                
                LOGGER.info("Cash booking created successfully - ID: " + bookingId + 
                           ", User: " + user.getUserId());
                
                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
                throw new SQLException("Failed to create booking");
            }

            booking.setBookingId(bookingId);

            // Tạo PayOS payment
            PayOS payOS = PayOSConfig.getPayOS();
            
<<<<<<< HEAD
            // Create service-specific item data
            ItemData item = createPayOSItemData(formData);
            
            // URLs
            String baseUrl = getBaseUrl(request);
            String returnUrl = baseUrl + "/booking/success?bookingId=" + bookingId;
            String cancelUrl = baseUrl + "/booking/fail?bookingId=" + bookingId;

            // Create payment data
            PaymentData paymentData = PaymentData.builder()
                    .orderCode((long) bookingId)
                    .amount((int) formData.getTotalPrice())
                    .description(createPayOSDescription(formData, bookingId))
                    .returnUrl(returnUrl)
                    .cancelUrl(cancelUrl)
                    .item(item)
                    .build();

            CheckoutResponseData checkoutResponse = payOS.createPaymentLink(paymentData);

            // Set attributes for payment page
            setPaymentPageAttributes(request, checkoutResponse, booking, formData);

            // Store booking in session
            session.setAttribute("pendingBooking", booking);

            LOGGER.info("PayOS payment link created - Booking ID: " + bookingId
                    + ", Type: " + formData.getServiceType()
                    + ", Amount: " + formData.getTotalPrice());

            request.getRequestDispatcher(PAYOS_PAYMENT_PAGE).forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating PayOS payment", e);
            request.setAttribute("errorMessage", "Không thể tạo link thanh toán. Vui lòng thử lại.");
=======
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating cash booking", e);
            request.setAttribute("errorMessage", "Không thể tạo đặt chỗ. Vui lòng thử lại.");
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
            request.setAttribute("formData", formData);
            request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
        }
    }
<<<<<<< HEAD

    // ==================== FORM PARSING METHODS ====================
    /**
     * Enhanced form parsing with improved accommodation support
=======
    
    
    
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
    
    // ==================== UTILITY METHODS ====================
    
    /**
     * Parse booking form data
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
     */
    private BookingFormData parseBookingForm(HttpServletRequest request) {
        BookingFormData formData = new BookingFormData();

        try {
            // Parse service IDs
            parseServiceIds(request, formData);

            // Parse booking details based on service type
            parseBookingDetails(request, formData);

            // Parse contact info
            parseContactInfo(request, formData);

            // Validate all data
            validateBookingData(formData);

        } catch (NumberFormatException e) {
            formData.addError("Dữ liệu số không hợp lệ.");
            LOGGER.warning("Number format error in form parsing: " + e.getMessage());
        } catch (ParseException e) {
            formData.addError("Định dạng ngày không hợp lệ.");
            LOGGER.warning("Date parsing error: " + e.getMessage());
        } catch (Exception e) {
            formData.addError("Dữ liệu form không hợp lệ: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Error parsing booking form", e);
        }

        return formData;
    }

    /**
     * Enhanced accommodation booking details parsing
     */
    private void parseAccommodationBookingDetails(HttpServletRequest request, BookingFormData formData)
            throws ParseException {
        
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");
        String roomType = request.getParameter("roomType");

        // Store raw strings for form redisplay
        formData.setCheckInDateStr(checkInStr);
        formData.setCheckOutDateStr(checkOutStr);
        formData.setGuestsStr(guestsStr);
        formData.setRoomType(roomType);

        // Parse and validate check-in date
        if (checkInStr != null && !checkInStr.trim().isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                dateFormat.setLenient(false);
                Date checkInDate = dateFormat.parse(checkInStr);
                formData.setCheckInDate(checkInDate);
                formData.setBookingDate(checkInDate); // Set as main booking date
            } catch (ParseException e) {
                formData.addError("Ngày nhận phòng không hợp lệ: " + checkInStr);
                LOGGER.warning("Invalid check-in date: " + checkInStr);
            }
        }

        // Parse and validate check-out date
        if (checkOutStr != null && !checkOutStr.trim().isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                dateFormat.setLenient(false);
                Date checkOutDate = dateFormat.parse(checkOutStr);
                formData.setCheckOutDate(checkOutDate);
            } catch (ParseException e) {
                formData.addError("Ngày trả phòng không hợp lệ: " + checkOutStr);
                LOGGER.warning("Invalid check-out date: " + checkOutStr);
            }
        }

        // Validate date sequence
        if (formData.getCheckInDate() != null && formData.getCheckOutDate() != null) {
            if (formData.getCheckOutDate().before(formData.getCheckInDate()) ||
                formData.getCheckOutDate().equals(formData.getCheckInDate())) {
                formData.addError("Ngày trả phòng phải sau ngày nhận phòng.");
            }
            
            // Calculate nights
            long diffInMillies = formData.getCheckOutDate().getTime() - formData.getCheckInDate().getTime();
            int nights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
            formData.setCalculatedNights(nights);
            
            if (nights > 30) {
                formData.addError("Không thể đặt quá 30 đêm.");
            }
        }

        // Parse guests
        if (guestsStr != null && !guestsStr.trim().isEmpty()) {
            try {
                int guests = Integer.parseInt(guestsStr);
                if (guests <= 0) {
                    formData.addError("Số khách phải lớn hơn 0.");
                } else if (guests > 20) {
                    formData.addError("Số khách không được vượt quá 20 người.");
                } else {
                    formData.setNumberOfPeople(guests);
                }
            } catch (NumberFormatException e) {
                formData.addError("Số khách không hợp lệ: " + guestsStr);
                LOGGER.warning("Invalid guests number: " + guestsStr);
            }
        }

        // Set default check-in time (14:00)
        try {
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            formData.setBookingTime(timeFormat.parse("14:00"));
        } catch (ParseException e) {
            // Fallback to current time
            formData.setBookingTime(new Date());
        }
    }

    /**
     * Enhanced validation for booking data
     */
    private void validateBookingData(BookingFormData formData) {
        // Common validations
        validateRequiredFields(formData);
        validateDates(formData);
        
        // Service-specific validations
        if (formData.hasAccommodation()) {
            validateAccommodationSpecificData(formData);
        } else if (formData.hasExperience()) {
            validateExperienceSpecificData(formData);
        }
    }

    private void validateAccommodationSpecificData(BookingFormData formData) {
        if (formData.getCheckInDate() == null) {
            formData.addError("Vui lòng chọn ngày nhận phòng.");
        }
        if (formData.getCheckOutDate() == null) {
            formData.addError("Vui lòng chọn ngày trả phòng.");
        }
        if (formData.getNumberOfPeople() <= 0) {
            formData.addError("Vui lòng chọn số khách.");
        }
        
        // Validate against today
        if (formData.getCheckInDate() != null) {
            Date today = resetTimeToMidnight(new Date());
            if (formData.getCheckInDate().before(today)) {
                formData.addError("Ngày nhận phòng không thể là ngày trong quá khứ.");
            }
        }
    }

    // ==================== PAYOS UTILITY METHODS ====================
    /**
     * Create PayOS item data based on service type
     */
    private ItemData createPayOSItemData(BookingFormData formData) throws SQLException {
        String itemName;
        int price = (int) formData.getTotalPrice();
        
        if (formData.hasAccommodation()) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            int nights = formData.getNumberOfNights();
            itemName = String.format("%s - %d đêm", 
                    truncateString(accommodation.getName(), 20), nights);
        } else if (formData.hasExperience()) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            itemName = truncateString(experience.getTitle(), 25);
        } else {
            itemName = "VietCulture Service";
        }

        return ItemData.builder()
                .name(itemName)
                .quantity(1)
                .price(price)
                .build();
    }

    /**
     * Create PayOS description
     */
    private String createPayOSDescription(BookingFormData formData, int bookingId) {
        String serviceType = formData.hasExperience() ? "EXP" : "ACC";
        String description = serviceType + " #" + bookingId;
        
        if (formData.getContactName() != null && !formData.getContactName().trim().isEmpty()) {
            String shortName = truncateString(formData.getContactName(), 10);
            description += " - " + shortName;
        }
        
        return description;
    }

    /**
     * Set payment page attributes
     */
    private void setPaymentPageAttributes(HttpServletRequest request, 
                                        CheckoutResponseData checkoutResponse,
                                        Booking booking, BookingFormData formData) throws SQLException {
        
        request.setAttribute("paymentUrl", checkoutResponse.getCheckoutUrl());
        request.setAttribute("qrCodeData", checkoutResponse.getQrCode());
        request.setAttribute("bookingID", booking.getBookingId());
        request.setAttribute("customerName", formData.getContactName());
        request.setAttribute("serviceName", getServiceDisplayName(formData));
        request.setAttribute("serviceType", formData.getServiceType());
        request.setAttribute("amount", formData.getTotalPrice());
    }

    // ==================== PRE-FILL DATA METHODS ====================
    /**
     * Enhanced pre-fill data for accommodation
     */
    private BookingFormData getPrefilledAccommodationData(HttpServletRequest request) {
        BookingFormData data = new BookingFormData();

        // Get URL parameters
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String guests = request.getParameter("guests");
        String roomType = request.getParameter("roomType");

        LOGGER.info("Prefilled accommodation data - checkIn: " + checkIn + 
                   ", checkOut: " + checkOut + ", guests: " + guests + ", roomType: " + roomType);

        // Validate and set check-in date
        if (checkIn != null && !checkIn.trim().isEmpty() && isValidDateFormat(checkIn)) {
            data.setCheckInDateStr(checkIn.trim());
        }

        // Validate and set check-out date
        if (checkOut != null && !checkOut.trim().isEmpty() && isValidDateFormat(checkOut)) {
            data.setCheckOutDateStr(checkOut.trim());
        }

        // Validate and set guests
        if (guests != null && !guests.trim().isEmpty()) {
            try {
                int guestCount = Integer.parseInt(guests.trim());
                if (guestCount > 0 && guestCount <= 20) {
                    data.setGuestsStr(guests.trim());
                }
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid guests parameter: " + guests);
            }
        }

        // Set room type if provided
        if (roomType != null && !roomType.trim().isEmpty()) {
            data.setRoomType(roomType.trim());
        }

        return data;
    }

    /**
     * Enhanced pre-fill data for experience (keeping existing functionality)
     */
    private BookingFormData getPrefilledExperienceData(HttpServletRequest request) {
        BookingFormData data = new BookingFormData();

        String dateParam = request.getParameter("date");
        if (dateParam == null || dateParam.trim().isEmpty()) {
            dateParam = request.getParameter("bookingDate");
        }
        
        String guestsParam = request.getParameter("guests");
        if (guestsParam == null || guestsParam.trim().isEmpty()) {
            guestsParam = request.getParameter("participants");
        }
        
        String timeParam = request.getParameter("time");
        if (timeParam == null || timeParam.trim().isEmpty()) {
            timeParam = request.getParameter("timeSlot");
        }

        LOGGER.info("Prefilled experience data - date: " + dateParam + 
                   ", guests: " + guestsParam + ", time: " + timeParam);

        // Validate and set date
        if (dateParam != null && !dateParam.trim().isEmpty() && isValidDateFormat(dateParam)) {
            data.setBookingDateStr(dateParam.trim());
        }
        
        // Validate and set participants
        if (guestsParam != null && !guestsParam.trim().isEmpty()) {
            try {
                int guests = Integer.parseInt(guestsParam.trim());
                if (guests > 0 && guests <= 20) {
                    data.setParticipantsStr(guestsParam.trim());
                }
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid guests parameter: " + guestsParam);
            }
        }
        
        // Validate and set time slot
        if (timeParam != null && !timeParam.trim().isEmpty()) {
            String timeSlot = timeParam.trim().toLowerCase();
            if (timeSlot.equals("morning") || timeSlot.equals("afternoon") || timeSlot.equals("evening")) {
                data.setTimeSlot(timeSlot);
            }
        }

        return data;
    }

    // ==================== PRICING CALCULATION ====================
    /**
     * Enhanced pricing calculation for both service types
     */
    private double calculateTotalPrice(BookingFormData formData) throws SQLException {
        double basePrice = 0;
        double multiplier = 1;

        if (formData.hasExperience()) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            basePrice = experience.getPrice();
            multiplier = formData.getNumberOfPeople();
            
            LOGGER.info("Experience pricing - Base: " + basePrice + ", People: " + multiplier);
            
        } else if (formData.hasAccommodation()) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            basePrice = accommodation.getPricePerNight();
            
            int nights = formData.getNumberOfNights();
            multiplier = nights;
            
            LOGGER.info("Accommodation pricing - Base: " + basePrice + ", Nights: " + nights);
        }

        double subtotal = basePrice * multiplier;
        double serviceFee = subtotal * 0.05; // 5% service fee
        double total = subtotal + serviceFee;
        
        LOGGER.info("Pricing calculation - Subtotal: " + subtotal + ", Fee: " + serviceFee + ", Total: " + total);
        
        return total;
    }

    // ==================== BOOKING CREATION ====================
    /**
     * Enhanced booking creation with accommodation support
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

        // Create enhanced contact info JSON
        String contactInfo = createEnhancedContactInfoJson(formData);
        booking.setContactInfo(contactInfo);
        booking.setCreatedAt(new Date());

        return booking;
    }

    /**
     * Create enhanced contact info JSON with accommodation-specific data
     */
    private String createEnhancedContactInfoJson(BookingFormData formData) {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        
        // Basic contact info
        jsonBuilder.append("\"contactName\":\"").append(escapeJson(formData.getContactName())).append("\",");
        jsonBuilder.append("\"contactEmail\":\"").append(escapeJson(formData.getContactEmail())).append("\",");
        jsonBuilder.append("\"contactPhone\":\"").append(escapeJson(formData.getContactPhone())).append("\",");
        jsonBuilder.append("\"serviceType\":\"").append(formData.getServiceType()).append("\"");
        
        // Accommodation-specific data
        if (formData.hasAccommodation()) {
            if (formData.getCheckInDateStr() != null) {
                jsonBuilder.append(",\"checkInDate\":\"").append(escapeJson(formData.getCheckInDateStr())).append("\"");
            }
            if (formData.getCheckOutDateStr() != null) {
                jsonBuilder.append(",\"checkOutDate\":\"").append(escapeJson(formData.getCheckOutDateStr())).append("\"");
            }
            jsonBuilder.append(",\"numberOfNights\":").append(formData.getNumberOfNights());
            jsonBuilder.append(",\"numberOfGuests\":").append(formData.getNumberOfPeople());
            
            if (formData.getRoomType() != null && !formData.getRoomType().trim().isEmpty()) {
                jsonBuilder.append(",\"roomType\":\"").append(escapeJson(formData.getRoomType())).append("\"");
            }
        }
        
        // Experience-specific data
        if (formData.hasExperience()) {
            if (formData.getTimeSlot() != null) {
                jsonBuilder.append(",\"timeSlot\":\"").append(escapeJson(formData.getTimeSlot())).append("\"");
                jsonBuilder.append(",\"timeSlotDisplay\":\"").append(escapeJson(formData.getTimeSlotDisplayName())).append("\"");
            }
            jsonBuilder.append(",\"numberOfParticipants\":").append(formData.getNumberOfPeople());
        }
        
        // Special requests
        if (formData.getSpecialRequests() != null && !formData.getSpecialRequests().trim().isEmpty()) {
            jsonBuilder.append(",\"specialRequests\":\"").append(escapeJson(formData.getSpecialRequests())).append("\"");
        }
        
        jsonBuilder.append("}");
        return jsonBuilder.toString();
    }

    // ==================== UTILITY METHODS ====================
    /**
     * Enhanced service display name with accommodation support
     */
    private String getServiceDisplayName(BookingFormData formData) {
        try {
            if (formData.hasExperience()) {
                Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
                return experience.getTitle();
            } else if (formData.hasAccommodation()) {
                Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
                return accommodation.getName() + " (" + accommodation.getType() + ")";
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting service display name", e);
        }
        
        return "VietCulture Service";
    }

    /**
     * Enhanced booking confirmation with accommodation support
     */
    private void handleBookingConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");

        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }

        // Load service data for display
        if (formData.hasExperience()) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");
        } else if (formData.hasAccommodation()) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            request.setAttribute("accommodation", accommodation);
            request.setAttribute("bookingType", "accommodation");
        }

        request.setAttribute("formData", formData);
        request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
    }

    /**
     * Enhanced cash booking confirmation
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
            booking.setStatus("CONFIRMED"); // Cash payment -> confirmed immediately
            int bookingId = bookingDAO.createBooking(booking);

            if (bookingId > 0) {
                booking.setBookingId(bookingId);

                // Send confirmation email
                sendBookingConfirmationEmail(booking, formData, user);

                // Clear form data and set success data
                session.removeAttribute("bookingFormData");
                session.setAttribute("successBooking", booking);

                // Log activity
                logBookingActivity(bookingId, "CASH_PAYMENT_CONFIRMED",
                        "Booking confirmed with cash payment for " + formData.getServiceType());

                LOGGER.info("Cash booking created successfully - ID: " + bookingId
                        + ", User: " + user.getUserId() + ", Type: " + formData.getServiceType());

                response.sendRedirect(request.getContextPath() + "/booking/success");
            } else {
                throw new SQLException("Failed to create booking");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating cash booking", e);
            request.setAttribute("errorMessage", "Không thể tạo đặt chỗ. Vui lòng thử lại.");
            request.setAttribute("formData", formData);
            request.getRequestDispatcher(BOOKING_CONFIRM_PAGE).forward(request, response);
        }
    }

    /**
     * Enhanced success page handler
     */
    private void handleBookingSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        HttpSession session = request.getSession();
        Booking booking = (Booking) session.getAttribute("successBooking");

        // If no booking in session, try to get from PayOS redirect
        if (booking == null) {
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam != null) {
                try {
                    int bookingId = Integer.parseInt(bookingIdParam);
                    booking = bookingDAO.getBookingById(bookingId);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error loading booking for success page", e);
                }
            }
        }

        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Determine booking type and load related data
        String bookingType;
        if (booking.getExperienceId() != null && booking.getExperienceId() > 0) {
            bookingType = "experience";
            try {
                Experience experience = experienceDAO.getExperienceById(booking.getExperienceId());
                request.setAttribute("experience", experience);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading experience for success page", e);
            }
        } else if (booking.getAccommodationId() != null && booking.getAccommodationId() > 0) {
            bookingType = "accommodation";
            try {
                Accommodation accommodation = accommodationDAO.getAccommodationById(booking.getAccommodationId());
                request.setAttribute("accommodation", accommodation);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error loading accommodation for success page", e);
            }
        } else {
            bookingType = "unknown";
        }

        request.setAttribute("bookingType", bookingType);
        request.setAttribute("booking", booking);
        session.removeAttribute("successBooking");

        request.getRequestDispatcher(BOOKING_SUCCESS_PAGE).forward(request, response);
    }

    /**
     * Enhanced failure page handler
     */
    private void handleBookingFail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdParam = request.getParameter("bookingId");
        String reason = request.getParameter("reason");

        // Log failed payment attempt
        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                LOGGER.info("Payment failed for booking ID: " + bookingId
                        + (reason != null ? ", reason: " + reason : ""));

                // Update booking status to CANCELLED
                bookingDAO.updateBookingStatus(bookingId, "CANCELLED");

            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error processing failed booking", e);
            }
        }

        request.setAttribute("failureReason", reason);
        request.setAttribute("bookingId", bookingIdParam);
        request.getRequestDispatcher(BOOKING_FAIL_PAGE).forward(request, response);
    }

    // ==================== PARSING METHODS ====================
    private void parseServiceIds(HttpServletRequest request, BookingFormData formData) {
        String experienceIdParam = request.getParameter("experienceId");
        String accommodationIdParam = request.getParameter("accommodationId");

        if (experienceIdParam != null && !experienceIdParam.trim().isEmpty()) {
            try {
                formData.setExperienceId(Integer.parseInt(experienceIdParam));
            } catch (NumberFormatException e) {
                formData.addError("Experience ID không hợp lệ: " + experienceIdParam);
            }
        }
        if (accommodationIdParam != null && !accommodationIdParam.trim().isEmpty()) {
            try {
                formData.setAccommodationId(Integer.parseInt(accommodationIdParam));
            } catch (NumberFormatException e) {
                formData.addError("Accommodation ID không hợp lệ: " + accommodationIdParam);
            }
        }
    }

    private void parseBookingDetails(HttpServletRequest request, BookingFormData formData)
            throws ParseException {

        if (formData.hasExperience()) {
            parseExperienceBookingDetails(request, formData);
        } else if (formData.hasAccommodation()) {
            parseAccommodationBookingDetails(request, formData);
        }
    }

    private void parseExperienceBookingDetails(HttpServletRequest request, BookingFormData formData)
            throws ParseException {
        String bookingDateStr = request.getParameter("bookingDate");
        String timeSlot = request.getParameter("timeSlot");
        String participantsStr = request.getParameter("participants");

        formData.setBookingDateStr(bookingDateStr);
        formData.setTimeSlot(timeSlot);
        formData.setParticipantsStr(participantsStr);

        // Parse booking date
        if (bookingDateStr != null && !bookingDateStr.trim().isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                dateFormat.setLenient(false);
                Date bookingDate = dateFormat.parse(bookingDateStr);
                formData.setBookingDate(bookingDate);
            } catch (ParseException e) {
                formData.addError("Định dạng ngày không hợp lệ: " + bookingDateStr);
            }
        }

        // Parse time slot
        if (timeSlot != null && !timeSlot.trim().isEmpty()) {
            Date bookingTime = parseTimeSlot(timeSlot);
            formData.setBookingTime(bookingTime);
        }

        // Parse participants
        if (participantsStr != null && !participantsStr.trim().isEmpty()) {
            try {
                int participants = Integer.parseInt(participantsStr);
                if (participants > 0) {
                    formData.setNumberOfPeople(participants);
                } else {
                    formData.addError("Số người tham gia phải lớn hơn 0.");
                }
            } catch (NumberFormatException e) {
                formData.addError("Số người tham gia không hợp lệ: " + participantsStr);
            }
        }
    }

    private void parseContactInfo(HttpServletRequest request, BookingFormData formData) {
        formData.setContactName(request.getParameter("contactName"));
        formData.setContactEmail(request.getParameter("contactEmail"));
        formData.setContactPhone(request.getParameter("contactPhone"));
        formData.setSpecialRequests(request.getParameter("specialRequests"));
    }

    private void validateRequiredFields(BookingFormData formData) {
        if (isNullOrEmpty(formData.getContactName())) {
            formData.addError("Vui lòng nhập họ tên liên hệ.");
        }
        if (isNullOrEmpty(formData.getContactEmail())) {
            formData.addError("Vui lòng nhập email liên hệ.");
        } else if (!isValidEmail(formData.getContactEmail())) {
            formData.addError("Email không hợp lệ.");
        }
        if (isNullOrEmpty(formData.getContactPhone())) {
            formData.addError("Vui lòng nhập số điện thoại liên hệ.");
        }
    }

    private void validateDates(BookingFormData formData) {
        Date today = resetTimeToMidnight(new Date());

        if (formData.hasExperience()) {
            if (formData.getBookingDate() == null) {
                formData.addError("Vui lòng chọn ngày tham gia.");
            } else if (formData.getBookingDate().before(today)) {
                formData.addError("Ngày tham gia không thể là ngày trong quá khứ.");
            }
        }

        if (formData.hasAccommodation()) {
            if (formData.getCheckInDate() == null) {
                formData.addError("Vui lòng chọn ngày nhận phòng.");
            } else if (formData.getCheckInDate().before(today)) {
                formData.addError("Ngày nhận phòng không thể là ngày trong quá khứ.");
            }

            if (formData.getCheckOutDate() == null) {
                formData.addError("Vui lòng chọn ngày trả phòng.");
            }
        }
    }

    private void validateExperienceSpecificData(BookingFormData formData) {
        if (formData.getTimeSlot() == null || formData.getTimeSlot().trim().isEmpty()) {
            formData.addError("Vui lòng chọn khung giờ.");
        }
        if (formData.getNumberOfPeople() <= 0) {
            formData.addError("Vui lòng chọn số người tham gia.");
        }
    }

    // ==================== UTILITY HELPER METHODS ====================
    private boolean validateServiceAvailability(BookingFormData formData) throws SQLException {
        if (formData.hasExperience()) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            return experience != null && experience.isActive();
        } else if (formData.hasAccommodation()) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            return accommodation != null && accommodation.isActive();
        }
        return false;
    }

    private void forwardToAppropriateForm(HttpServletRequest request, HttpServletResponse response,
            BookingFormData formData) throws ServletException, IOException, SQLException {

        if (formData.hasExperience()) {
            Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
            request.setAttribute("experience", experience);
            request.setAttribute("bookingType", "experience");
        } else if (formData.hasAccommodation()) {
            Accommodation accommodation = accommodationDAO.getAccommodationById(formData.getAccommodationId());
            request.setAttribute("accommodation", accommodation);
            request.setAttribute("bookingType", "accommodation");
        }

        request.getRequestDispatcher(BOOKING_FORM_PAGE).forward(request, response);
    }

    private void sendBookingConfirmationEmail(Booking booking, BookingFormData formData, User user) {
        try {
            String serviceName = getServiceDisplayName(formData);
            String serviceType = formData.getServiceType();
            
            String bookingDate = "";
            String bookingTime = "";
            
            if ("experience".equals(serviceType)) {
                bookingDate = formData.getFormattedBookingDate();
                bookingTime = formData.getTimeSlotDisplayName();
            } else if ("accommodation".equals(serviceType)) {
                bookingDate = formData.getFormattedCheckInDate() + " - " + formData.getFormattedCheckOutDate();
                bookingTime = "14:00 (Nhận phòng)";
            }
            
            boolean emailSent = EmailUtils.sendBookingConfirmationEmail(
                    formData.getContactEmail(),
                    formData.getContactName(),
                    booking.getBookingId(),
                    serviceName,
                    bookingDate,
                    bookingTime,
                    formData.getNumberOfPeople(),
                    formData.getFormattedTotalPrice()
            );

            if (emailSent) {
                LOGGER.info("Booking confirmation email sent to: " + formData.getContactEmail()
                        + " for " + serviceType + " booking ID: " + booking.getBookingId());
            } else {
                LOGGER.warning("Failed to send booking confirmation email to: " + formData.getContactEmail());
            }

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send booking confirmation email", e);
        }
    }

    private void logBookingActivity(int bookingId, String activity, String details) {
        try {
            String logMessage = String.format("Booking %d: %s - %s", bookingId, activity, details);
            LOGGER.info(logMessage);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to log booking activity", e);
        }
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

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
<<<<<<< HEAD

    private String truncateString(String input, int maxLength) {
        if (input == null) return "";
        if (input.length() <= maxLength) return input;
        return input.substring(0, maxLength - 3) + "...";
    }

    private boolean isValidDateFormat(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return false;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            sdf.parse(dateStr);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }

    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        String emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$";
        return email.matches(emailRegex);
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);

        if ((scheme.equals("http") && serverPort != 80)
                || (scheme.equals("https") && serverPort != 443)) {
            url.append(":").append(serverPort);
=======
    
    // ==================== EMAIL & NOTIFICATION METHODS ====================
    
    /**
     * Send booking confirmation email
     */
    private void sendBookingConfirmationEmail(Booking booking, BookingFormData formData, User user) {
        try {
            String serviceName = "Dịch vụ VietCulture";
            if (formData.getExperienceId() != null) {
                Experience experience = experienceDAO.getExperienceById(formData.getExperienceId());
                serviceName = experience.getTitle();
            }
            
            // TODO: Implement email service với template cho booking confirmation
            boolean emailSent = EmailUtils.sendBookingConfirmationEmail(
                formData.getContactEmail(), 
                formData.getContactName(),
                booking.getBookingId(),
                serviceName,
                formData.getFormattedBookingDate(),
                formData.getTimeSlotDisplayName(),
                formData.getNumberOfPeople(),
                formData.getFormattedTotalPrice()
            );
            
            if (emailSent) {
                LOGGER.info("Booking confirmation email sent to: " + formData.getContactEmail() +
                           " for booking ID: " + booking.getBookingId());
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send booking confirmation email", e);
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
        }

        url.append(contextPath);
        return url.toString();
    }
<<<<<<< HEAD

    private Date resetTimeToMidnight(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

=======
    
    /**
     * Notify admin about new booking
     */
    private void notifyAdminNewBooking(Booking booking, BookingFormData formData) {
        try {
            // TODO: Implement admin notification system
            LOGGER.info("Admin notification: New booking created - ID: " + booking.getBookingId() +
                       ", Total: " + formData.getFormattedTotalPrice());
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to notify admin about new booking", e);
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
    
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
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
        response.sendRedirect(request.getContextPath() + "/login?redirect="
                + request.getRequestURI());
    }
<<<<<<< HEAD

=======
    
    /**
     * Check if string is null hoặc empty
     */
>>>>>>> 5d0d95f58eaf1e7ddffe420e89c182484563a48a
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            Exception e, String logMessage)
            throws ServletException, IOException {
        LOGGER.log(Level.SEVERE, logMessage, e);
        request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại sau.");
        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
    }

    private void sendErrorResponse(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        LOGGER.warning("Booking error: " + message);
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
    }

    private void handleBookingFromSession(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
            if (formData != null && (formData.hasExperience() || formData.hasAccommodation())) {
                response.sendRedirect(request.getContextPath() + "/booking/confirm");
                return;
            }
        }

        sendErrorResponse(request, response,
                "Thiếu thông tin về dịch vụ cần đặt chỗ. Vui lòng chọn trải nghiệm hoặc lưu trú để đặt chỗ.");
    }

    private void handlePayOSPaymentPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getAttribute("paymentUrl") == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }
        request.getRequestDispatcher(PAYOS_PAYMENT_PAGE).forward(request, response);
    }

    private void handleCompletePayment(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null) {
            response.sendRedirect(request.getContextPath() + "/booking/success?bookingId=" + bookingId);
        } else {
            response.sendRedirect(request.getContextPath() + "/booking");
        }
    }

    // ==================== ENHANCED BOOKINGFORMDATA CLASS ====================
    public static class BookingFormData {
        
        // Common fields
        private Integer experienceId;
        private Integer accommodationId;
        private Date bookingDate;
        private String bookingDateStr;
        private Date bookingTime;
        private int numberOfPeople;
        private double totalPrice;
        private String contactName;
        private String contactEmail;
        private String contactPhone;
        private String specialRequests;
        private List<String> errors = new ArrayList<>();

        // Experience-specific fields
        private String timeSlot;
        private String participantsStr;

        // Accommodation-specific fields
        private Date checkInDate;
        private Date checkOutDate;
        private String checkInDateStr;
        private String checkOutDateStr;
        private String guestsStr;
        private String roomType;
        private int calculatedNights = 1;

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

        public int getNumberOfPeople() { return numberOfPeople; }
        public void setNumberOfPeople(int numberOfPeople) { this.numberOfPeople = numberOfPeople; }

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

        public String getTimeSlot() { return timeSlot; }
        public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

        public String getParticipantsStr() { return participantsStr; }
        public void setParticipantsStr(String participantsStr) { this.participantsStr = participantsStr; }

        public Date getCheckInDate() { return checkInDate; }
        public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

        public Date getCheckOutDate() { return checkOutDate; }
        public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

        public String getCheckInDateStr() { return checkInDateStr; }
        public void setCheckInDateStr(String checkInDateStr) { this.checkInDateStr = checkInDateStr; }

        public String getCheckOutDateStr() { return checkOutDateStr; }
        public void setCheckOutDateStr(String checkOutDateStr) { this.checkOutDateStr = checkOutDateStr; }

        public String getGuestsStr() { return guestsStr; }
        public void setGuestsStr(String guestsStr) { this.guestsStr = guestsStr; }

        public String getRoomType() { return roomType; }
        public void setRoomType(String roomType) { this.roomType = roomType; }

        public int getCalculatedNights() { return calculatedNights; }
        public void setCalculatedNights(int calculatedNights) { this.calculatedNights = calculatedNights; }

        public List<String> getErrors() { return errors; }
        public void addError(String error) { this.errors.add(error); }
        public boolean isValid() { return errors.isEmpty(); }
        public String getErrorMessage() { return errors.isEmpty() ? null : String.join(", ", errors); }

        // ==================== UTILITY METHODS ====================
        public boolean hasExperience() { return experienceId != null && experienceId > 0; }
        public boolean hasAccommodation() { return accommodationId != null && accommodationId > 0; }

        public String getServiceType() {
            if (hasExperience()) return "experience";
            if (hasAccommodation()) return "accommodation";
            return "unknown";
        }

        public Integer getServiceId() {
            if (hasExperience()) return experienceId;
            if (hasAccommodation()) return accommodationId;
            return null;
        }

        public int getNumberOfNights() {
            if (checkInDate != null && checkOutDate != null) {
                long diffInMillies = checkOutDate.getTime() - checkInDate.getTime();
                int nights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
                return Math.max(1, nights);
            }
            return calculatedNights > 0 ? calculatedNights : 1;
        }

        public String getFormattedBookingDate() {
            if (bookingDate == null) return "";
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            return formatter.format(bookingDate);
        }

        public String getFormattedCheckInDate() {
            if (checkInDate == null) return "";
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            return formatter.format(checkInDate);
        }

        public String getFormattedCheckOutDate() {
            if (checkOutDate == null) return "";
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            return formatter.format(checkOutDate);
        }

        public String getTimeSlotDisplayName() {
            if (hasExperience() && timeSlot != null) {
                switch (timeSlot) {
                    case "morning": return "Buổi sáng (9:00)";
                    case "afternoon": return "Buổi chiều (14:00)";
                    case "evening": return "Buổi tối (18:00)";
                    default: return timeSlot;
                }
            } else if (hasAccommodation()) {
                return "14:00 (Nhận phòng)";
            }
            return "";
        }

        public String getFormattedTotalPrice() {
            return String.format("%,.0f VNĐ", totalPrice);
        }

        @Override
        public String toString() {
            return "BookingFormData{" +
                    "serviceType=" + getServiceType() +
                    ", experienceId=" + experienceId +
                    ", accommodationId=" + accommodationId +
                    ", bookingDate=" + bookingDate +
                    ", checkInDate=" + checkInDate +
                    ", checkOutDate=" + checkOutDate +
                    ", numberOfPeople=" + numberOfPeople +
                    ", totalPrice=" + totalPrice +
                    ", contactName='" + contactName + '\'' +
                    ", contactEmail='" + contactEmail + '\'' +
                    ", roomType='" + roomType + '\'' +
                    ", errors=" + errors.size() +
                    '}';
        }
    }
}