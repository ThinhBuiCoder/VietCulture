<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đặt chỗ - VietCulture</title>
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
            --success-color: #28a745;
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
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Header Section */
        .header-section {
            background: linear-gradient(135deg, #2c5f7a, #4a90a4);
            color: white;
            padding: 60px 0;
            border-radius: var(--border-radius);
            margin-bottom: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(16, 70, 108, 0.9), rgba(131, 197, 190, 0.7));
            z-index: 1;
        }

        .header-content {
            position: relative;
            z-index: 2;
        }

        .header-section h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
        }

        .header-section h1 i {
            font-size: 2.2rem;
        }

        .booking-code {
            font-size: 1.2rem;
            opacity: 0.9;
            font-weight: 500;
        }

        /* Main Content */
        .main-content {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
            margin-bottom: 30px;
        }

        /* Booking Header */
        .booking-header {
            padding: 30px;
            border-bottom: 1px solid #e9ecef;
        }

        .booking-info {
            display: flex;
            gap: 30px;
            align-items: flex-start;
        }

        .booking-image {
            width: 200px;
            height: 150px;
            border-radius: 12px;
            object-fit: cover;
            flex-shrink: 0;
        }

        .booking-details {
            flex: 1;
        }

        .booking-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 15px;
        }

        .booking-tags {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .tag-experience {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .tag-confirmed {
            background-color: #d4edda;
            color: #155724;
        }

        .view-service-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: var(--transition);
        }

        .view-service-btn:hover {
            background-color: #0d3a5a;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 0;
        }

        .info-section {
            padding: 30px;
            border-right: 1px solid #e9ecef;
        }

        .info-section:last-child {
            border-right: none;
        }

        .info-section h3 {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            color: #6c757d;
        }

        .info-value {
            font-weight: 600;
            color: var(--dark-color);
        }

        /* Status Alert */
        .status-alert {
            margin: 30px;
            padding: 20px;
            background-color: #d1f2eb;
            border: 1px solid #7dcea0;
            border-radius: 12px;
            color: #0e6b47;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .status-alert i {
            font-size: 1.5rem;
            color: var(--success-color);
        }

        .status-alert-content h4 {
            margin: 0 0 8px 0;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .status-alert-content p {
            margin: 0;
            font-size: 0.9rem;
        }

        /* Action Buttons */
        .action-buttons {
            padding: 30px;
            border-top: 1px solid #e9ecef;
            display: flex;
            gap: 15px;
        }

        .btn {
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 500;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
            background: transparent;
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-section h1 {
                font-size: 2rem;
                flex-direction: column;
                gap: 10px;
            }

            .booking-info {
                flex-direction: column;
                gap: 20px;
            }

            .booking-image {
                width: 100%;
                height: 200px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .info-section {
                border-right: none;
                border-bottom: 1px solid #e9ecef;
            }

            .info-section:last-child {
                border-bottom: none;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <div class="header-section">
            <div class="header-content">
                <h1>
                    <i class="ri-file-list-3-line"></i>
                    Chi tiết đặt chỗ
                </h1>
                <div class="booking-code">Mã đặt chỗ: #1</div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Booking Header -->
            <div class="booking-header">
                <div class="booking-info">
                    <c:choose>
                        <c:when test="${bookingType == 'experience' && not empty experience && not empty experience.images}">
                            <c:set var="imageArray" value="${fn:split(experience.images, ',')}" />
                            <c:set var="firstImage" value="${imageArray[0]}" />
                            <img src="${pageContext.request.contextPath}/images/experiences/${firstImage}" 
                                 alt="${experience.title}" 
                                 class="booking-image"
                                 onerror="this.src='https://via.placeholder.com/200x150/4a90a4/ffffff?text=No+Image'">
                        </c:when>
                        <c:when test="${bookingType == 'accommodation' && not empty accommodation && not empty accommodation.images}">
                            <c:set var="imageArray" value="${fn:split(accommodation.images, ',')}" />
                            <c:set var="firstImage" value="${imageArray[0]}" />
                            <img src="${pageContext.request.contextPath}/images/accommodations/${firstImage}" 
                                 alt="${accommodation.name}" 
                                 class="booking-image"
                                 onerror="this.src='https://via.placeholder.com/200x150/4a90a4/ffffff?text=No+Image'">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/200x150/4a90a4/ffffff?text=No+Image" 
                                 alt="No Image" 
                                 class="booking-image">
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="booking-details">
                        <h2 class="booking-title">
                            <c:choose>
                                <c:when test="${bookingType == 'experience' && not empty experience}">
                                    ${experience.title}
                                </c:when>
                                <c:when test="${bookingType == 'accommodation' && not empty accommodation}">
                                    ${accommodation.name}
                                </c:when>
                                <c:otherwise>
                                    Chi tiết đặt chỗ #${booking.bookingId}
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        
                        <div class="booking-tags">
                            <span class="tag tag-${bookingType == 'experience' ? 'experience' : 'accommodation'}">
                                <i class="ri-${bookingType == 'experience' ? 'map-pin' : 'home'}-line"></i>
                                ${bookingType == 'experience' ? 'Trải nghiệm' : 'Lưu trú'}
                            </span>
                            <span class="tag tag-${booking.status.toLowerCase()}">
                                ${booking.status}
                            </span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/${bookingType == 'experience' ? 'experiences' : 'accommodations'}/${bookingType == 'experience' ? experience.experienceId : accommodation.accommodationId}" class="view-service-btn">
                            <i class="ri-eye-line"></i>
                            Xem ${bookingType == 'experience' ? 'trải nghiệm' : 'lưu trú'}
                        </a>
                    </div>
                </div>
            </div>

            <!-- Info Grid -->
            <div class="info-grid">
                <!-- Booking Information -->
                <div class="info-section">
                    <h3>
                        <i class="ri-calendar-line"></i>
                        Thông tin đặt chỗ
                    </h3>
                    
                    <div class="info-item">
                        <span class="info-label">Mã đặt chỗ</span>
                        <span class="info-value">#1</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Ngày đặt</span>
                        <span class="info-value">17/07/2025 00:00</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Trạng thái</span>
                        <span class="info-value">Đã xác nhận</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Tổng tiền</span>
                        <span class="info-value">₫240,000.00</span>
                    </div>
                </div>

                <!-- Experience Information -->
                <div class="info-section">
                    <h3>
                        <i class="ri-map-pin-line"></i>
                        Thông tin trải nghiệm
                    </h3>
                    
                    <div class="info-item">
                        <span class="info-label">Ngày tham gia</span>
                        <span class="info-value">01/06/2025</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Thời gian</span>
                        <span class="info-value">08:00</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Số người tham gia</span>
                        <span class="info-value">2 người</span>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="info-section">
                    <h3>
                        <i class="ri-user-line"></i>
                        Thông tin liên hệ
                    </h3>
                    
                    <div class="info-item">
                        <span class="info-label">Họ tên</span>
                        <span class="info-value">Không có</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value">Không có</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Số điện thoại</span>
                        <span class="info-value">Không có</span>
                    </div>
                </div>
            </div>

            <!-- Status Alert -->
            <div class="status-alert">
                <c:set var="currentTime" value="<%= new java.util.Date().getTime() %>" />
                <c:set var="bookingTime" value="${booking.bookingDate.time}" />
                <c:set var="timeDiff" value="${bookingTime - currentTime}" />
                <c:set var="hoursDiff" value="${timeDiff / (1000 * 60 * 60)}" />
                
                <c:choose>
                    <c:when test="${booking.status == 'CANCELLED'}">
                        <i class="ri-close-circle-line" style="color: #dc3545;"></i>
                        <div class="status-alert-content">
                            <h4>Đã hủy</h4>
                            <p>Đặt chỗ này đã bị hủy.</p>
                        </div>
                    </c:when>
                    <c:when test="${booking.status == 'COMPLETED'}">
                        <i class="ri-check-double-line" style="color: #0d6efd;"></i>
                        <div class="status-alert-content">
                            <h4>Đã hoàn thành</h4>
                            <p>Đặt chỗ này đã được hoàn thành thành công.</p>
                        </div>
                    </c:when>
                    <c:when test="${hoursDiff <= 24 && (booking.status == 'CONFIRMED' || booking.status == 'PENDING')}">
                        <i class="ri-time-line" style="color: #dc3545;"></i>
                        <div class="status-alert-content">
                            <h4>Không thể hủy</h4>
                            <p>Không thể hủy đặt chỗ trong vòng 24 giờ trước khi tham gia.</p>
                        </div>
                    </c:when>
                    <c:when test="${hoursDiff > 24 && (booking.status == 'CONFIRMED' || booking.status == 'PENDING')}">
                        <i class="ri-check-line" style="color: #28a745;"></i>
                        <div class="status-alert-content">
                            <h4>Có thể hủy</h4>
                            <p>Bạn có thể hủy đặt chỗ này miễn phí trước 24 giờ so với thời gian tham gia.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <i class="ri-information-line" style="color: #0dcaf0;"></i>
                        <div class="status-alert-content">
                            <h4>${booking.statusText}</h4>
                            <p>Vui lòng liên hệ host nếu bạn có thắc mắc về đặt chỗ này.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/booking/history" class="btn btn-outline-primary">
                    <i class="ri-arrow-left-line"></i>
                    Quay lại lịch sử
                </a>
                
                <c:if test="${booking.status == 'PENDING' || booking.status == 'CONFIRMED'}">
                    <c:set var="currentTime" value="<%= new java.util.Date().getTime() %>" />
                    <c:set var="bookingTime" value="${booking.bookingDate.time}" />
                    <c:set var="timeDiff" value="${bookingTime - currentTime}" />
                    <c:set var="hoursDiff" value="${timeDiff / (1000 * 60 * 60)}" />
                    
                    <c:choose>
                        <c:when test="${hoursDiff > 24}">
                            <button class="btn btn-danger" onclick="cancelBooking('${booking.bookingId}')">
                                <i class="ri-close-line"></i>
                                Hủy đặt chỗ
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-danger" disabled title="Không thể hủy trong vòng 24h trước khi tham gia">
                                <i class="ri-close-line"></i>
                                Không thể hủy
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelBooking(bookingId) {
            const confirmMessage = 'Bạn có chắc chắn muốn hủy đặt chỗ này? Hành động này không thể hoàn tác.';
            if (confirm(confirmMessage)) {
                // Hiển thị loading state
                const button = event.target.closest('button');
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="ri-loader-4-line"></i> Đang hủy...';
                button.disabled = true;
                
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
                        // Hiển thị thông báo thành công
                        showNotification('Đã hủy đặt chỗ thành công!', 'success');
                        // Reload trang sau 1 giây
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    } else {
                        showNotification('Có lỗi xảy ra: ' + data.message, 'error');
                        // Khôi phục button
                        button.innerHTML = originalText;
                        button.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra khi hủy đặt chỗ', 'error');
                    // Khôi phục button
                    button.innerHTML = originalText;
                    button.disabled = false;
                });
            }
        }

        function showNotification(message, type) {
            // Tạo notification element
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
                z-index: 10000;
                max-width: 300px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                transform: translateX(100%);
                transition: transform 0.3s ease;
            `;
            
            if (type === 'success') {
                notification.style.backgroundColor = '#28a745';
            } else {
                notification.style.backgroundColor = '#dc3545';
            }
            var iconClass = 'ri-' + (type === 'success' ? 'check-line' : 'error-warning-line');
            notification.innerHTML =
                '<div style="display: flex; align-items: center; gap: 10px;">' +
                '<i class="' + iconClass + '" style="font-size: 1.2rem;"></i>' +
                '<span>' + message + '</span>' +
                '</div>';
            document.body.appendChild(notification);
            // Hiển thị notification
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
            }, 100);
            // Tự động ẩn sau 3 giây
            setTimeout(() => {
                notification.style.transform = 'translateX(100%)';
                setTimeout(() => {
                    notification.remove();
                }, 300);
            }, 3000);
        }
    </script>
</body>
</html>