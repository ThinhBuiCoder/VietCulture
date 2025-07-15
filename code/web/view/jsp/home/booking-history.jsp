<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đặt Chỗ - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #10466C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
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

        /* Custom Navbar */
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

        .custom-navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            height: 50px;
            margin-right: 12px;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav-right a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: var(--transition);
        }

        .nav-right a:hover {
            color: var(--primary-color);
            background-color: rgba(255, 56, 92, 0.08);
        }

        /* Nav Center Styles */
        .nav-center {
            display: flex;
            align-items: center;
            gap: 40px;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .nav-center-item {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
        }

        .nav-center-item:hover {
            color: white;
        }

        .nav-center-item.active {
            color: var(--primary-color);
        }

        /* Dropdown Styles */
        .dropdown-menu {
            border: none;
            box-shadow: var(--shadow-lg);
            border-radius: 12px;
            padding: 10px 0;
            min-width: 200px;
            background: white;
        }

        .dropdown-item {
            padding: 10px 20px;
            color: var(--dark-color);
            transition: var(--transition);
            border-radius: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: var(--primary-color);
        }

        .dropdown-item.active {
            background-color: var(--primary-color) !important;
            color: white !important;
        }

        .dropdown-item.active:hover {
            background-color: #0d3a5a !important;
            color: white !important;
        }

        .dropdown-item i {
            width: 16px;
            text-align: center;
        }

        .dropdown-divider {
            margin: 8px 0;
            border-color: #e9ecef;
        }

        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 40px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            text-align: center;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* Booking Cards */
        .booking-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            border-left: 4px solid var(--primary-color);
        }

        .booking-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .booking-header {
            display: flex;
            justify-content: between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .booking-image {
            width: 120px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 20px;
        }

        .booking-info {
            flex: 1;
        }

        .booking-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .booking-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .booking-type.experience {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .booking-type.accommodation {
            background-color: #f3e5f5;
            color: #7b1fa2;
        }

        .booking-status {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            margin-left: 10px;
        }

        .status-confirmed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-completed {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-icon {
            width: 32px;
            height: 32px;
            background: rgba(16, 70, 108, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
        }

        .detail-content {
            flex: 1;
        }

        .detail-label {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 2px;
        }

        .detail-value {
            font-weight: 500;
            color: var(--dark-color);
        }

        .booking-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        .btn {
            border-radius: 10px;
            padding: 8px 16px;
            font-weight: 500;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #0d3a5a;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
        }

        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: var(--dark-color);
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
            margin-bottom: 30px;
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
            transition: var(--transition);
        }

        .back-button:hover {
            color: #0d3a5a;
            transform: translateX(-5px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-header {
                padding: 25px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .booking-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .booking-image {
                width: 100%;
                height: 200px;
                margin-right: 0;
                margin-bottom: 15px;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
            }
            
            .booking-actions {
                flex-direction: column;
            }
            
            .nav-center {
                position: relative;
                left: 0;
                transform: none;
                margin-top: 20px;
                justify-content: center;
            }

            .custom-navbar .container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>

            <div class="nav-center">
                <a href="${pageContext.request.contextPath}/" class="nav-center-item">
                    Trang Chủ
                </a>
                <a href="/Travel/experiences" class="nav-center-item">
                    Trải Nghiệm
                </a>
                <a href="/Travel/accommodations" class="nav-center-item">
                    Lưu Trú
                </a>
            </div>

            <div class="nav-right">
                <div class="dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="color: white;">
                        <i class="ri-user-line" style="color: white;"></i> 
                        ${sessionScope.user.fullName}
                    </a>
                    <ul class="dropdown-menu">
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard" style="color: #10466C; font-weight: 600;">
                                    <i class="ri-dashboard-line"></i> Quản Trị
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.user.role == 'HOST'}">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/Travel/create_service" style="color: #10466C; font-weight: 600;">
                                    <i class="ri-add-circle-line"></i> Tạo Dịch Vụ
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/host/services/manage" style="color: #10466C; font-weight: 600;">
                                    <i class="ri-settings-4-line"></i> Quản Lý Dịch Vụ
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.user.role == 'TRAVELER'}">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/traveler/upgrade-to-host" style="color: #10466C; font-weight: 600;">
                                    <i class="ri-vip-crown-line"></i> Nâng Lên Host
                                </a>
                            </li>
                        </c:if>
                        
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="color: #10466C; font-weight: 600;">
                                <i class="ri-user-settings-line"></i> Hồ Sơ
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="color: #10466C; font-weight: 600;">
                                <i class="ri-logout-circle-r-line"></i> Đăng Xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/profile" class="back-button">
            <i class="ri-arrow-left-line"></i>
            Quay lại Hồ sơ
        </a>

        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="ri-calendar-check-line me-3"></i>Lịch Sử Đặt Chỗ</h1>
            <p>Xem lại tất cả các đặt chỗ của bạn</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="ri-error-warning-line me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Booking History -->
        <c:choose>
            <c:when test="${not empty bookings}">
                <c:forEach var="booking" items="${bookings}">
                    <div class="booking-card">
                        <div class="booking-header">
                            <c:choose>
                                <c:when test="${not empty booking.serviceImage}">
                                    <img src="${pageContext.request.contextPath}/images/${booking.isExperienceBooking() ? 'experiences' : 'accommodations'}/${booking.serviceImage}" 
                                         alt="${booking.serviceName}" class="booking-image"
                                         onerror="this.src='https://via.placeholder.com/120x80?text=No+Image'">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/120x80?text=No+Image" alt="No Image" class="booking-image">
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="booking-info">
                                <h3 class="booking-title">
                                    <c:choose>
                                        <c:when test="${booking.isExperienceBooking()}">${booking.experienceName}</c:when>
                                        <c:otherwise>${booking.accommodationName}</c:otherwise>
                                    </c:choose>
                                </h3>
                                <c:choose>
                                    <c:when test="${booking.isExperienceBooking()}">
                                        <span class="booking-type experience">
                                            <i class="ri-map-pin-line me-1"></i>Trải nghiệm
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="booking-type accommodation">
                                            <i class="ri-home-line me-1"></i>Lưu trú
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="booking-status status-${booking.status.toLowerCase()}">
                                    ${booking.statusText}
                                </span>
                            </div>
                        </div>

                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="ri-calendar-line"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Ngày đặt</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${booking.isExperienceBooking()}">
                                <div class="detail-item">
                                    <div class="detail-icon">
                                        <i class="ri-time-line"></i>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Thời gian</div>
                                        <div class="detail-value">
                                            <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${booking.isAccommodationBooking()}">
                                <div class="detail-item">
                                    <div class="detail-icon">
                                        <i class="ri-calendar-check-line"></i>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Nhận phòng</div>
                                        <div class="detail-value">
                                            <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                </div>

                                <div class="detail-item">
                                    <div class="detail-icon">
                                        <i class="ri-calendar-close-line"></i>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Trả phòng</div>
                                        <div class="detail-value">
                                            <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="ri-group-line"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Số người</div>
                                    <div class="detail-value">${booking.numberOfPeople} người</div>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="ri-money-dollar-circle-line"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Tổng tiền</div>
                                    <div class="detail-value">
                                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="đ"/>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="ri-time-line"></i>
                                </div>
                                <div class="detail-content">
                                    <div class="detail-label">Ngày tạo</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty booking.specialRequests}">
                            <div class="mt-3 p-3 bg-light rounded">
                                <strong>Yêu cầu đặc biệt:</strong>
                                <p class="mb-0 mt-1">${booking.specialRequests}</p>
                            </div>
                        </c:if>

                        <div class="booking-actions">
                            <c:if test="${booking.status == 'PENDING'}">
                                <button class="btn btn-primary btn-sm" onclick="cancelBooking(${booking.bookingId})">
                                    <i class="ri-close-line"></i>Hủy đặt chỗ
                                </button>
                            </c:if>
                            
                            <c:if test="${booking.status == 'CONFIRMED' && booking.isExperienceBooking()}">
                                <a href="${pageContext.request.contextPath}/experiences/detail?id=${booking.experienceId}" class="btn btn-outline-primary btn-sm">
                                    <i class="ri-eye-line"></i>Xem chi tiết
                                </a>
                            </c:if>
                            
                            <c:if test="${booking.status == 'CONFIRMED' && booking.isAccommodationBooking()}">
                                <a href="${pageContext.request.contextPath}/accommodations/detail?id=${booking.accommodationId}" class="btn btn-outline-primary btn-sm">
                                    <i class="ri-eye-line"></i>Xem chi tiết
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="ri-calendar-line"></i>
                    <h3>Chưa có đặt chỗ nào</h3>
                    <p>Bạn chưa có lịch sử đặt chỗ nào. Hãy khám phá các trải nghiệm và lưu trú thú vị!</p>
                    <div class="d-flex gap-3 justify-content-center">
                        <a href="/Travel/experiences" class="btn btn-primary">
                            <i class="ri-map-pin-line me-2"></i>Khám phá trải nghiệm
                        </a>
                        <a href="/Travel/accommodations" class="btn btn-outline-primary">
                            <i class="ri-home-line me-2"></i>Tìm lưu trú
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelBooking(bookingId) {
            if (confirm('Bạn có chắc chắn muốn hủy đặt chỗ này?')) {
                // Gửi request hủy đặt chỗ
                fetch('${pageContext.request.contextPath}/booking/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'bookingId=' + bookingId + '&action=cancel'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Đã hủy đặt chỗ thành công!');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi hủy đặt chỗ');
                });
            }
        }
    </script>
</body>
</html> 