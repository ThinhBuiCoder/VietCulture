<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Chỗ | VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
            --shadow-lg: 0 10px 25px rgba(0,0,0,0.12);
            --border-radius: 16px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            color: var(--dark-color);
            background-color: var(--accent-color);
            padding-top: 80px;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
        }

        /* Navigation Styles */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #10466C;
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow-sm);
            z-index: 1000;
            padding: 15px 0;
            transition: var(--transition);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 1.3rem;
            color: white;
            text-decoration: none;
        }

        .navbar-brand img {
            height: 50px !important;
            width: auto !important;
            margin-right: 12px !important;
        }

        /* Breadcrumb */
        .breadcrumb-container {
            background-color: var(--light-color);
            padding: 15px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .breadcrumb {
            background: none;
            margin: 0;
            padding: 0;
        }

        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
        }

        /* Main Content */
        .main-content {
            min-height: 100vh;
            padding: 40px 0;
        }

        .booking-header {
            background: var(--light-color);
            padding: 30px 0;
            margin-bottom: 40px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .booking-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 10px;
            color: var(--dark-color);
        }

        .booking-subtitle {
            color: #6c757d;
            font-size: 1.1rem;
        }

        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 40px;
        }

        /* Booking Form */
        .booking-form-card {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow-sm);
            height: fit-content;
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: var(--primary-color);
            font-size: 1.2rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark-color);
            display: block;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid rgba(0,0,0,0.1);
            border-radius: 10px;
            font-size: 1rem;
            transition: var(--transition);
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 56, 92, 0.2);
        }

        .form-select {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 40px;
        }

        .form-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
        }

        .btn {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            transition: var(--transition);
            border: none;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
        }

        .btn-outline-secondary {
            color: var(--dark-color);
            border: 2px solid rgba(0,0,0,0.2);
            background: transparent;
        }

        .btn-outline-secondary:hover {
            background: var(--dark-color);
            color: white;
        }

        /* Service Summary */
        .service-summary {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
        }

        .service-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .service-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--dark-color);
        }

        .service-details {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 15px;
        }

        .service-detail {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .service-detail i {
            color: var(--primary-color);
            font-size: 1rem;
        }

        .price-display {
            background: rgba(255, 56, 92, 0.1);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }

        .price-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .price-unit {
            color: #6c757d;
            font-size: 0.9rem;
        }

        /* Booking Summary */
        .booking-summary {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 2px solid var(--primary-color);
        }

        .summary-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--dark-color);
            text-align: center;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark-color);
            border-top: 1px solid rgba(0,0,0,0.2);
            padding-top: 15px;
            margin-top: 15px;
        }

        /* Error Messages */
        .alert {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #721c24;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .content-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .booking-title {
                font-size: 2rem;
            }
        }

        @media (max-width: 768px) {
            .booking-title {
                font-size: 1.7rem;
            }
            
            .booking-form-card,
            .service-summary,
            .booking-summary {
                padding: 20px;
            }
        }

        /* Loading State */
        .btn-loading {
            position: relative;
        }

        .btn-loading:disabled {
            opacity: 0.8;
        }

        .spinner-border-sm {
            width: 1rem;
            height: 1rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/master/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>
        </div>
    </nav>

    <!-- Breadcrumb -->
    <div class="breadcrumb-container">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/">
                            <i class="ri-home-line me-1"></i>Trang Chủ
                        </a>
                    </li>
                    <c:if test="${bookingType == 'experience'}">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/experiences">Trải Nghiệm</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/experiences/${experience.experienceId}">${experience.title}</a>
                        </li>
                    </c:if>
                    <li class="breadcrumb-item active" aria-current="page">Đặt Chỗ</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Header -->
    <div class="booking-header">
        <div class="container">
            <h1 class="booking-title">Đặt chỗ của bạn</h1>
            <p class="booking-subtitle">
                <c:choose>
                    <c:when test="${bookingType == 'experience'}">
                        Hoàn tất thông tin để đặt trải nghiệm "${experience.title}"
                    </c:when>
                    <c:otherwise>
                        Hoàn tất thông tin để đặt chỗ lưu trú
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container main-content">
        <div class="content-grid">
            <!-- Booking Form -->
            <div class="booking-form-card">
                <!-- Error Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="ri-error-warning-line me-2"></i>
                        ${errorMessage}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm">
                    <!-- Hidden Fields -->
                    <c:if test="${bookingType == 'experience'}">
                        <input type="hidden" name="experienceId" value="${experience.experienceId}">
                    </c:if>
                    <c:if test="${bookingType == 'accommodation'}">
                        <input type="hidden" name="accommodationId" value="${param.accommodationId}">
                    </c:if>

                    <!-- Booking Details Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="ri-calendar-line"></i>
                            Chi tiết đặt chỗ
                        </h3>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="bookingDate" class="form-label">
                                        Ngày tham gia <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="bookingDate" name="bookingDate" 
                                           value="${not empty prefilledData.bookingDateStr ? prefilledData.bookingDateStr : (not empty formData ? formData.bookingDateStr : '')}" required>
                                    <div class="form-text">Chọn ngày bạn muốn tham gia</div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="timeSlot" class="form-label">
                                        Khung giờ <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-control form-select" id="timeSlot" name="timeSlot" required>
                                        <option value="">Chọn khung giờ</option>
                                        <option value="morning" ${not empty prefilledData.timeSlot && prefilledData.timeSlot == 'morning' ? 'selected' : (not empty formData && formData.timeSlot == 'morning' ? 'selected' : '')}>
                                            Buổi sáng (9:00 - 12:00)
                                        </option>
                                        <option value="afternoon" ${not empty prefilledData.timeSlot && prefilledData.timeSlot == 'afternoon' ? 'selected' : (not empty formData && formData.timeSlot == 'afternoon' ? 'selected' : '')}>
                                            Buổi chiều (14:00 - 17:00)
                                        </option>
                                        <option value="evening" ${not empty prefilledData.timeSlot && prefilledData.timeSlot == 'evening' ? 'selected' : (not empty formData && formData.timeSlot == 'evening' ? 'selected' : '')}>
                                            Buổi tối (18:00 - 21:00)
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="participants" class="form-label">
                                Số người tham gia <span class="text-danger">*</span>
                            </label>
                            <select class="form-control form-select" id="participants" name="participants" required>
                                <option value="">Chọn số người</option>
                                <c:choose>
                                    <c:when test="${bookingType == 'experience'}">
                                        <c:forEach begin="1" end="${experience.maxGroupSize}" var="i">
                                            <option value="${i}" ${not empty prefilledData.participantsStr && prefilledData.participantsStr == i ? 'selected' : (not empty formData && formData.participantsStr == i ? 'selected' : '')}>
                                                ${i} người
                                            </option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach begin="1" end="10" var="i">
                                            <option value="${i}" ${not empty prefilledData.participantsStr && prefilledData.participantsStr == i ? 'selected' : (not empty formData && formData.participantsStr == i ? 'selected' : '')}>
                                                ${i} người
                                            </option>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                    </div>

                    <!-- Contact Information Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="ri-user-line"></i>
                            Thông tin liên hệ
                        </h3>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="contactName" class="form-label">
                                        Họ và tên <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="contactName" name="contactName" 
                                           value="${not empty formData && not empty formData.contactName ? formData.contactName : (not empty sessionScope.user ? sessionScope.user.fullName : '')}" 
                                           required>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="contactEmail" class="form-label">
                                        Email <span class="text-danger">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="contactEmail" name="contactEmail" 
                                           value="${not empty formData && not empty formData.contactEmail ? formData.contactEmail : (not empty sessionScope.user ? sessionScope.user.email : '')}" 
                                           required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="contactPhone" class="form-label">
                                Số điện thoại <span class="text-danger">*</span>
                            </label>
                            <input type="tel" class="form-control" id="contactPhone" name="contactPhone" 
                                   value="${not empty formData && not empty formData.contactPhone ? formData.contactPhone : ''}" 
                                   placeholder="0123 456 789" required>
                        </div>
                    </div>

                    <!-- Special Requests Section -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="ri-message-3-line"></i>
                            Yêu cầu đặc biệt
                        </h3>
                        
                        <div class="form-group">
                            <label for="specialRequests" class="form-label">Ghi chú (tùy chọn)</label>
                            <textarea class="form-control" id="specialRequests" name="specialRequests" 
                                      rows="3" placeholder="Chia sẻ bất kỳ yêu cầu đặc biệt nào...">${not empty formData && not empty formData.specialRequests ? formData.specialRequests : ''}</textarea>
                            <div class="form-text">
                                Ví dụ: dị ứng thực phẩm, yêu cầu hỗ trợ di chuyển, ngôn ngữ ưa thích...
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                            <i class="ri-arrow-left-line me-2"></i>Quay Lại
                        </button>
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <span class="btn-text">
                                <i class="ri-arrow-right-line me-2"></i>Tiếp Tục
                            </span>
                            <span class="btn-loading d-none">
                                <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                            </span>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Sidebar -->
            <div>
                <!-- Service Summary -->
                <div class="service-summary">
                    <c:if test="${bookingType == 'experience'}">
                        <c:choose>
                            <c:when test="${not empty experience.images}">
                                <c:set var="firstImage" value="${fn:split(experience.images, ',')[0]}" />
                                <img src="${pageContext.request.contextPath}/images/experiences/${fn:trim(firstImage)}" 
                                     alt="${experience.title}" class="service-image"
                                     onerror="this.src='https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                                     alt="${experience.title}" class="service-image">
                            </c:otherwise>
                        </c:choose>
                        
                        <h4 class="service-title">${experience.title}</h4>
                        
                        <div class="service-details">
                            <div class="service-detail">
                                <i class="ri-map-pin-line"></i>
                                <span>${experience.location}</span>
                            </div>
                            <div class="service-detail">
                                <i class="ri-group-line"></i>
                                <span>Tối đa ${experience.maxGroupSize} người</span>
                            </div>
                            <div class="service-detail">
                                <i class="ri-time-line"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty experience.duration}">
                                            <fmt:formatDate value="${experience.duration}" pattern="H" />h<fmt:formatDate value="${experience.duration}" pattern="mm" />
                                        </c:when>
                                        <c:otherwise>
                                            Cả ngày
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="service-detail">
                                <i class="ri-user-star-line"></i>
                                <span>Hướng dẫn viên ${experience.hostName}</span>
                            </div>
                        </div>
                        
                        <div class="price-display">
                            <div class="price-amount">
                                <c:choose>
                                    <c:when test="${experience.price == 0}">
                                        Miễn phí
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="price-unit">mỗi người</div>
                        </div>
                    </c:if>
                    <c:if test="${bookingType == 'accommodation'}">
                        <!-- TODO: Add accommodation summary -->
                        <h4 class="service-title">Lưu trú</h4>
                        <div class="price-display">
                            <div class="price-amount">Liên hệ để biết giá</div>
                        </div>
                    </c:if>
                </div>

                <!-- Booking Summary -->
                <div class="booking-summary" id="bookingSummary" style="display: none;">
                    <h4 class="summary-title">Tóm tắt đặt chỗ</h4>
                    
                    <div class="summary-item">
                        <span>Ngày:</span>
                        <span id="summaryDate">-</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Thời gian:</span>
                        <span id="summaryTime">-</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Số người:</span>
                        <span id="summaryParticipants">-</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Giá × <span id="participantCount">0</span> người:</span>
                        <span id="basePrice">0 VNĐ</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Phí dịch vụ (5%):</span>
                        <span id="serviceFee">0 VNĐ</span>
                    </div>
                    
                    <div class="summary-total">
                        <span>Tổng cộng:</span>
                        <span id="totalPrice">0 VNĐ</span>
                    </div>
                </div>

                <!-- Safety Info -->
                <div class="mt-4 p-3 bg-light rounded">
                    <h6 class="mb-3">
                        <i class="ri-shield-check-line me-2"></i>Cam kết an toàn
                    </h6>
                    <ul class="list-unstyled mb-0 small">
                        <li class="mb-2">
                            <i class="ri-check-line text-success me-2"></i>
                            Thanh toán được bảo mật
                        </li>
                        <li class="mb-2">
                            <i class="ri-check-line text-success me-2"></i>
                            Hướng dẫn viên đã xác minh
                        </li>
                        <li class="mb-2">
                            <i class="ri-check-line text-success me-2"></i>
                            Hỗ trợ khách hàng 24/7
                        </li>
                        <li>
                            <i class="ri-check-line text-success me-2"></i>
                            Chính sách hủy linh hoạt
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Price calculation
        const pricePerPerson = ${bookingType == 'experience' ? experience.price : 0};
        
        // Form elements
        const bookingDateInput = document.getElementById('bookingDate');
        const timeSlotSelect = document.getElementById('timeSlot');
        const participantsSelect = document.getElementById('participants');
        const bookingSummary = document.getElementById('bookingSummary');
        const bookingForm = document.getElementById('bookingForm');
        const submitBtn = document.getElementById('submitBtn');

        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        bookingDateInput.min = today;

        // Update summary when form changes
        bookingDateInput.addEventListener('change', updateSummary);
        timeSlotSelect.addEventListener('change', updateSummary);
        participantsSelect.addEventListener('change', updateSummary);

        function updateSummary() {
            const date = bookingDateInput.value;
            const timeSlot = timeSlotSelect.value;
            const participants = parseInt(participantsSelect.value) || 0;
            
            if (date && timeSlot && participants) {
                // Show summary
                bookingSummary.style.display = 'block';
                
                // Update date
                const dateObj = new Date(date);
                const formattedDate = dateObj.toLocaleDateString('vi-VN', {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                });
                document.getElementById('summaryDate').textContent = formattedDate;
                
                // Update time
                const timeText = getTimeSlotText(timeSlot);
                document.getElementById('summaryTime').textContent = timeText;
                
                // Update participants
                document.getElementById('summaryParticipants').textContent = participants + ' người';
                document.getElementById('participantCount').textContent = participants;
                
                // Calculate prices
                const basePrice = participants * pricePerPerson;
                const serviceFee = Math.round(basePrice * 0.05);
                const totalPrice = basePrice + serviceFee;
                
                document.getElementById('basePrice').textContent = formatCurrency(basePrice);
                document.getElementById('serviceFee').textContent = formatCurrency(serviceFee);
                document.getElementById('totalPrice').textContent = formatCurrency(totalPrice);
                
            } else {
                bookingSummary.style.display = 'none';
            }
        }

        function getTimeSlotText(timeSlot) {
            switch (timeSlot) {
                case 'morning': return 'Buổi sáng (9:00 - 12:00)';
                case 'afternoon': return 'Buổi chiều (14:00 - 17:00)';
                case 'evening': return 'Buổi tối (18:00 - 21:00)';
                default: return '-';
            }
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
        }

        // Form submission
        bookingForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate form
            if (!validateForm()) {
                return;
            }
            
            // Show loading state
            showLoadingState();
            
            // Submit form
            setTimeout(() => {
                this.submit();
            }, 500);
        });

        function validateForm() {
            const date = bookingDateInput.value;
            const timeSlot = timeSlotSelect.value;
            const participants = participantsSelect.value;
            const contactName = document.getElementById('contactName').value;
            const contactEmail = document.getElementById('contactEmail').value;
            const contactPhone = document.getElementById('contactPhone').value;
            
            if (!date || !timeSlot || !participants || !contactName || !contactEmail || !contactPhone) {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
                return false;
            }
            
            // Validate date not in past
            const selectedDate = new Date(date);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate < today) {
                alert('Ngày tham gia không thể là ngày trong quá khứ.');
                return false;
            }
            
            // Validate email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(contactEmail)) {
                alert('Địa chỉ email không hợp lệ.');
                return false;
            }
            
            // Validate phone
            const phoneRegex = /^0\d{9}$/;
            if (!phoneRegex.test(contactPhone)) {
                alert('Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam (10 chữ số, bắt đầu bằng 0).');
                return false;
            }
            
            return true;
        }

        function showLoadingState() {
            const btnText = submitBtn.querySelector('.btn-text');
            const btnLoading = submitBtn.querySelector('.btn-loading');
            
            btnText.classList.add('d-none');
            btnLoading.classList.remove('d-none');
            submitBtn.disabled = true;
        }

        // Initialize summary if form has pre-filled data
        document.addEventListener('DOMContentLoaded', function() {
            updateSummary();
        });
    </script>
</body>
</html>