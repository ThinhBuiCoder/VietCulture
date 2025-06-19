package controller;

import dao.BookingDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Booking;
import model.Experience;
import model.User;
import utils.EmailUtils;

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
 * 
 * Supported URLs:
 * - GET /booking: Hiển thị form đặt chỗ
 * - GET /booking/confirm: Hiển thị trang xác nhận
 * - GET /booking/momo-payment: Hiển thị trang thanh toán MoMo QR
 * - GET /booking/success: Hiển thị trang thành công
 * - POST /booking: Tạo booking mới
 * - POST /booking (action=confirm): Xác nhận booking tiền mặt
 */
@WebServlet({"/booking", "/booking/*"})
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
            } else if (pathInfo.equals("/momo-payment")) {
                handleMoMoPaymentPage(request, response);
            } else if (pathInfo.equals("/success")) {
                handleBookingSuccess(request, response);
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
        
        try {
            if ("confirm".equals(action)) {
                handleConfirmBooking(request, response, user);
            } else if ("momo-payment".equals(action)) {
                handleMoMoPaymentRequest(request, response, user);
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
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        BookingFormData formData = (BookingFormData) session.getAttribute("bookingFormData");
        
        if (formData == null) {
            response.sendRedirect(request.getContextPath() + "/booking");
            return;
        }
        
        try {
            Booking booking = createBookingFromFormData(formData, user.getUserId());
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
        }
    }
    
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