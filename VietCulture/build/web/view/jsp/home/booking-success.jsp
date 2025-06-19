<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Chỗ Thành Công | VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <style>
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --success-color: #4BB543;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-success: linear-gradient(135deg, #4BB543, #28a745);
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
            background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
            min-height: 100vh;
            padding-top: 80px;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
        }

        /* Navigation */
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

        /* Success Header */
        .success-header {
            text-align: center;
            padding: 60px 0;
            background: var(--light-color);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }

        .success-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="%234BB543" opacity="0.1"><animate attributeName="opacity" values="0.1;0.3;0.1" dur="2s" repeatCount="indefinite"/></circle><circle cx="80" cy="30" r="3" fill="%2383C5BE" opacity="0.1"><animate attributeName="opacity" values="0.1;0.4;0.1" dur="3s" repeatCount="indefinite"/></circle><circle cx="60" cy="70" r="2.5" fill="%23FF385C" opacity="0.1"><animate attributeName="opacity" values="0.1;0.35;0.1" dur="2.5s" repeatCount="indefinite"/></circle></svg>') repeat;
            pointer-events: none;
        }

        .success-icon {
            width: 120px;
            height: 120px;
            background: var(--gradient-success);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            box-shadow: 0 10px 30px rgba(75, 181, 67, 0.3);
            position: relative;
            z-index: 1;
        }

        .success-icon i {
            font-size: 3rem;
            color: white;
        }

        .success-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 15px;
            color: var(--dark-color);
            position: relative;
            z-index: 1;
        }

        .success-subtitle {
            font-size: 1.2rem;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .booking-number {
            display: inline-block;
            background: var(--gradient-primary);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 700;
            margin-top: 20px;
            font-size: 1.1rem;
            position: relative;
            z-index: 1;
        }

        /* Main Content */
        .main-content {
            padding: 40px 0 80px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 40px;
        }

        /* Booking Details Card */
        .booking-details {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
            border: 2px solid rgba(75, 181, 67, 0.2);
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(0,0,0,0.1);
        }

        .section-title i {
            color: var(--success-color);
            font-size: 1.2rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 500;
            color: #6c757d;
        }

        .detail-value {
            font-weight: 600;
            color: var(--dark-color);
            text-align: right;
        }

        .status-badge {
            background: var(--gradient-success);
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
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
            margin-bottom: 20px;
        }

        .service-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .service-info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #6c757d;
            font-size: 0.95rem;
        }

        .service-info-item i {
            color: var(--primary-color);
            font-size: 1rem;
        }

        /* Next Steps */
        .next-steps {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
        }

        .step-item {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background: rgba(75, 181, 67, 0.05);
            border-radius: 10px;
            border-left: 4px solid var(--success-color);
        }

        .step-item:last-child {
            margin-bottom: 0;
        }

        .step-number {
            min-width: 30px;
            height: 30px;
            background: var(--success-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .step-content h6 {
            margin-bottom: 5px;
            color: var(--dark-color);
        }

        .step-content p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            transition: var(--transition);
            border: none;
            text-decoration: none;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 56, 92, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 56, 92, 0.4);
            color: white;
        }

        .btn-success {
            background: var(--gradient-success);
            color: white;
            box-shadow: 0 4px 15px rgba(75, 181, 67, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(75, 181, 67, 0.4);
            color: white;
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

        /* Contact Info */
        .contact-info {
            background: linear-gradient(135deg, #4BB543, #28a745);
            color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            text-align: center;
        }

        .contact-info h5 {
            margin-bottom: 15px;
            color: white;
        }

        .contact-item {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .contact-item:last-child {
            margin-bottom: 0;
        }

        .contact-item i {
            font-size: 1.1rem;
        }

        /* Social Share */
        .social-share {
            background: var(--light-color);
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--shadow-sm);
            text-align: center;
            margin-top: 20px;
        }

        .social-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
        }

        .social-btn {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: white;
            transition: var(--transition);
            font-size: 1.2rem;
        }

        .social-btn.facebook { background: #3b5998; }
        .social-btn.twitter { background: #1da1f2; }
        .social-btn.instagram { background: #e4405f; }
        .social-btn.zalo { background: #0068ff; }

        .social-btn:hover {
            transform: translateY(-3px);
            color: white;
        }

        /* Success Alert */
        .success-alert {
            background: rgba(75, 181, 67, 0.1);
            border: 1px solid rgba(75, 181, 67, 0.3);
            color: #155724;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .content-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }

        @media (max-width: 768px) {
            .success-title {
                font-size: 2rem;
            }
            
            .success-icon {
                width: 100px;
                height: 100px;
            }
            
            .success-icon i {
                font-size: 2.5rem;
            }
            
            .booking-details,
            .service-summary,
            .next-steps {
                padding: 20px;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }

        /* Animations */
        .fade-in {
            animation: fadeIn 1s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Pulse animation for important elements */
        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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

    <!-- Success Header -->
    <div class="success-header">
        <div class="container">
            <div class="success-icon animate__animated animate__bounceIn">
                <i class="ri-check-line"></i>
            </div>
            
            <h1 class="success-title animate__animated animate__fadeInUp">
                Đặt chỗ thành công!
            </h1>
            
            <p class="success-subtitle animate__animated animate__fadeInUp animate__delay-1s">
                Cảm ơn bạn đã tin tưởng VietCulture. Chúng tôi đã gửi email xác nhận đến địa chỉ của bạn.
            </p>
            
            <div class="booking-number animate__animated animate__fadeInUp animate__delay-2s pulse">
                <i class="ri-bookmark-line me-2"></i>
                Mã đặt chỗ: #${booking.bookingId}
            </div>
        </div>
    </div>

    <!-- Success Alert -->
    <div class="container">
        <div class="success-alert animate__animated animate__fadeInDown">
            <i class="ri-check-double-line"></i>
            <div>
                <strong>Đặt chỗ đã được xác nhận!</strong> 
                <c:choose>
                    <c:when test="${booking.status == 'CONFIRMED'}">
                        Bạn đã thanh toán thành công và booking của bạn đã được xác nhận.
                    </c:when>
                    <c:otherwise>
                        Booking của bạn đang chờ xử lý và sẽ sớm được xác nhận.
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container main-content">
        <div class="content-grid">
            <!-- Booking Details -->
            <div class="fade-in">
                <!-- Service Information -->
                <div class="booking-details">
                    <h3 class="section-title">
                        <i class="ri-information-line"></i>
                        Chi tiết đặt chỗ
                    </h3>
                    
                    <div class="detail-row">
                        <span class="detail-label">Mã đặt chỗ:</span>
                        <span class="detail-value">#${booking.bookingId}</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Loại dịch vụ:</span>
                        <span class="detail-value">${booking.bookingType}</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Ngày tham gia:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${booking.bookingDate}" pattern="EEEE, dd/MM/yyyy" />
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Thời gian:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm" />
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Số người:</span>
                        <span class="detail-value">${booking.numberOfPeople} người</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Tổng tiền:</span>
                        <span class="detail-value">
                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0" /> VNĐ
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Trạng thái:</span>
                        <span class="detail-value">
                            <span class="status-badge">
                                <i class="ri-check-line"></i>
                                ${booking.statusText}
                            </span>
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Ngày đặt:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </span>
                    </div>
                </div>

                <!-- Next Steps -->
                <div class="next-steps">
                    <h3 class="section-title">
                        <i class="ri-roadmap-line"></i>
                        Những bước tiếp theo
                    </h3>
                    
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <h6>Chờ xác nhận từ host</h6>
                            <p>Host sẽ xác nhận đặt chỗ của bạn trong vòng 24 giờ. Bạn sẽ nhận được thông báo qua email.</p>
                        </div>
                    </div>
                    
                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-content">
                            <h6>Chuẩn bị cho chuyến đi</h6>
                            <p>Kiểm tra email để biết thông tin chi tiết về địa điểm tập trung và những gì cần mang theo.</p>
                        </div>
                    </div>
                    
                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-content">
                            <h6>Liên hệ host nếu cần</h6>
                            <p>Nếu có bất kỳ câu hỏi nào, bạn có thể liên hệ trực tiếp với host hoặc đội ngũ hỗ trợ của chúng tôi.</p>
                        </div>
                    </div>
                    
                    <div class="step-item">
                        <div class="step-number">4</div>
                        <div class="step-content">
                            <h6>Tận hưởng trải nghiệm</h6>
                            <p>Đến đúng giờ và tận hưởng trải nghiệm tuyệt vời! Đừng quên đánh giá sau khi hoàn thành.</p>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                        <i class="ri-home-line"></i>
                        Về Trang Chủ
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/profile/bookings" class="btn btn-primary">
                        <i class="ri-bookmark-line"></i>
                        Xem Đặt Chỗ Của Tôi
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/experiences" class="btn btn-success">
                        <i class="ri-search-line"></i>
                        Khám Phá Thêm
                    </a>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="fade-in">
                <!-- Service Summary -->
                <div class="service-summary">
                    <c:if test="${booking.isExperienceBooking()}">
                        <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                             alt="Experience" class="service-image">
                        
                        <h4 class="service-title">${booking.experienceName}</h4>
                        
                        <div class="service-info-item">
                            <i class="ri-calendar-line"></i>
                            <span>
                                <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy" />
                            </span>
                        </div>
                        
                        <div class="service-info-item">
                            <i class="ri-time-line"></i>
                            <span>
                                <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm" />
                            </span>
                        </div>
                        
                        <div class="service-info-item">
                            <i class="ri-group-line"></i>
                            <span>${booking.numberOfPeople} người tham gia</span>
                        </div>
                    </c:if>
                    
                    <c:if test="${booking.isAccommodationBooking()}">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&h=500&q=80" 
                             alt="Accommodation" class="service-image">
                        
                        <h4 class="service-title">${booking.accommodationName}</h4>
                        
                        <div class="service-info-item">
                            <i class="ri-calendar-line"></i>
                            <span>
                                <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy" />
                            </span>
                        </div>
                        
                        <div class="service-info-item">
                            <i class="ri-group-line"></i>
                            <span>${booking.numberOfPeople} khách</span>
                        </div>
                    </c:if>
                </div>

                <!-- Contact Support -->
                <div class="contact-info">
                    <h5>
                        <i class="ri-customer-service-2-line me-2"></i>
                        Cần hỗ trợ?
                    </h5>
                    
                    <div class="contact-item">
                        <i class="ri-phone-line"></i>
                        <span>Hotline: 1900 1234</span>
                    </div>
                    
                    <div class="contact-item">
                        <i class="ri-mail-line"></i>
                        <span>support@vietculture.vn</span>
                    </div>
                    
                    <div class="contact-item">
                        <i class="ri-time-line"></i>
                        <span>Hỗ trợ 24/7</span>
                    </div>
                </div>

                <!-- Social Share -->
                <div class="social-share">
                    <h6>Chia sẻ trải nghiệm</h6>
                    <p class="small text-muted mb-3">
                        Chia sẻ niềm vui với bạn bè và gia đình
                    </p>
                    
                    <div class="social-buttons">
                        <a href="#" class="social-btn facebook" onclick="shareOnFacebook()">
                            <i class="ri-facebook-fill"></i>
                        </a>
                        <a href="#" class="social-btn twitter" onclick="shareOnTwitter()">
                            <i class="ri-twitter-fill"></i>
                        </a>
                        <a href="#" class="social-btn instagram" onclick="shareOnInstagram()">
                            <i class="ri-instagram-line"></i>
                        </a>
                        <a href="#" class="social-btn zalo" onclick="shareOnZalo()">
                            <i class="ri-chat-3-line"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Social sharing functions
        function shareOnFacebook() {
            const url = encodeURIComponent(window.location.href);
            const text = encodeURIComponent('Tôi vừa đặt một trải nghiệm tuyệt vời trên VietCulture!');
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${text}`, '_blank', 'width=600,height=400');
        }

        function shareOnTwitter() {
            const url = encodeURIComponent(window.location.href);
            const text = encodeURIComponent('Tôi vừa đặt một trải nghiệm tuyệt vời trên VietCulture! #VietCulture #Travel');
            window.open(`https://twitter.com/intent/tweet?url=${url}&text=${text}`, '_blank', 'width=600,height=400');
        }

        function shareOnInstagram() {
            // Instagram doesn't support direct sharing, so copy link to clipboard
            navigator.clipboard.writeText(window.location.href).then(() => {
                alert('Đã sao chép link! Bạn có thể dán vào Instagram Story hoặc bài viết.');
            });
        }

        function shareOnZalo() {
            const url = encodeURIComponent(window.location.href);
            const text = encodeURIComponent('Tôi vừa đặt một trải nghiệm tuyệt vời trên VietCulture!');
            window.open(`https://zalo.me/share?url=${url}&text=${text}`, '_blank', 'width=600,height=400');
        }

        // Auto-scroll to top and show animations
        window.addEventListener('load', function() {
            window.scrollTo(0, 0);
            
            // Trigger fade-in animations
            setTimeout(() => {
                document.querySelectorAll('.fade-in').forEach((element, index) => {
                    setTimeout(() => {
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }, index * 200);
                });
            }, 500);
        });

        // Initialize fade-in elements
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.fade-in').forEach(element => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                element.style.transition = 'all 0.6s ease-out';
            });

            // Celebration effect
            setTimeout(() => {
                createCelebrationEffect();
            }, 2000);
        });

        // Create celebration effect
        function createCelebrationEffect() {
            // Create confetti-like particles
            for (let i = 0; i < 50; i++) {
                setTimeout(() => {
                    createParticle();
                }, i * 100);
            }
        }

        function createParticle() {
            const particle = document.createElement('div');
            particle.style.position = 'fixed';
            particle.style.width = '10px';
            particle.style.height = '10px';
            particle.style.background = ['#FF385C', '#4BB543', '#83C5BE', '#FFD700'][Math.floor(Math.random() * 4)];
            particle.style.borderRadius = '50%';
            particle.style.pointerEvents = 'none';
            particle.style.zIndex = '9999';
            particle.style.left = Math.random() * 100 + 'vw';
            particle.style.top = '-10px';
            particle.style.opacity = '0.8';

            document.body.appendChild(particle);

            // Animate particle falling
            const animation = particle.animate([
                { transform: 'translateY(0) rotate(0deg)', opacity: 0.8 },
                { transform: 'translateY(100vh) rotate(360deg)', opacity: 0 }
            ], {
                duration: 3000 + Math.random() * 2000,
                easing: 'ease-out'
            });

            animation.onfinish = () => {
                particle.remove();
            };
        }
    </script>
</body>
</html>