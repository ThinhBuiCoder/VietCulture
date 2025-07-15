<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Booking #${booking.bookingId} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --danger-gradient: linear-gradient(135deg, #fc466b 0%, #3f5efb 100%);
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            
            --card-shadow: 0 10px 40px rgba(0,0,0,0.1);
            --card-shadow-hover: 0 20px 60px rgba(0,0,0,0.15);
            --border-radius: 16px;
            --border-radius-sm: 12px;
            --border-radius-lg: 20px;
        }

        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #2d3748;
        }
        
        .admin-sidebar {
            min-height: 100vh;
            background: var(--primary-gradient);
            color: white;
            box-shadow: 4px 0 20px rgba(0,0,0,0.1);
        }
        
        .admin-content {
            background: transparent;
            min-height: 100vh;
            padding: 2rem 1.5rem;
        }
        
        /* Header Styles */
        .page-header {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            border-left: 6px solid #667eea;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2d3748;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .booking-id-badge {
            background: var(--primary-gradient);
            color: white;
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        /* Professional Cards */
        .professional-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.8);
        }
        
        .professional-card:hover {
            box-shadow: var(--card-shadow-hover);
            transform: translateY(-2px);
        }
        
        .card-header-pro {
            background: var(--primary-gradient);
            color: white;
            padding: 1.5rem 2rem;
            border: none;
            position: relative;
            overflow: hidden;
        }
        
        .card-header-pro::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            pointer-events: none;
        }
        
        .card-header-pro h5 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .card-body-pro {
            padding: 2rem;
        }
        
        /* Information Grid */
        .info-grid {
            display: grid;
            gap: 1.5rem;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid #e2e8f0;
            transition: all 0.2s ease;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-item:hover {
            background: #f8fafc;
            margin: 0 -1rem;
            padding: 1rem;
            border-radius: var(--border-radius-sm);
        }
        
        .info-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1976d2;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #64748b;
            margin-bottom: 0.25rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: #1e293b;
            line-height: 1.4;
        }
        
        /* Status & Type Badges */
        .status-badge-pro {
            padding: 0.6rem 1.2rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(251, 191, 36, 0.3);
        }
        
        .status-confirmed {
            background: var(--success-gradient);
            color: white;
            box-shadow: 0 4px 20px rgba(17, 153, 142, 0.3);
        }
        
        .status-completed {
            background: var(--info-gradient);
            color: white;
            box-shadow: 0 4px 20px rgba(79, 172, 254, 0.3);
        }
        
        .status-cancelled {
            background: var(--danger-gradient);
            color: white;
            box-shadow: 0 4px 20px rgba(252, 70, 107, 0.3);
        }
        
        .type-badge-pro {
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .type-experience {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .type-accommodation {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        /* Price Display */
        .price-section {
            text-align: center;
            padding: 2rem;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: var(--border-radius);
            margin: 1rem 0;
        }
        
        .price-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--success-gradient);
            color: white;
            font-size: 2rem;
            box-shadow: 0 10px 30px rgba(17, 153, 142, 0.3);
        }
        
        .price-amount {
            font-size: 2.5rem;
            font-weight: 700;
            color: #059669;
            margin-bottom: 0.5rem;
            letter-spacing: -1px;
        }
        
        .price-label {
            font-size: 1rem;
            color: #6b7280;
            font-weight: 500;
        }
        
        .price-breakdown {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e5e7eb;
        }
        
        .price-item {
            text-align: center;
        }
        
        .price-item-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 0.25rem;
        }
        
        .price-item-label {
            font-size: 0.875rem;
            color: #6b7280;
            font-weight: 500;
        }
        
        /* Timeline Styles */
        .timeline-pro {
            position: relative;
            padding: 2rem 0;
        }
        
        .timeline-pro::before {
            content: '';
            position: absolute;
            left: 30px;
            top: 0;
            bottom: 0;
            width: 3px;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            border-radius: 2px;
        }
        
        .timeline-item-pro {
            position: relative;
            padding-left: 80px;
            margin-bottom: 2rem;
        }
        
        .timeline-item-pro:last-child {
            margin-bottom: 0;
        }
        
        .timeline-marker-pro {
            position: absolute;
            left: 18px;
            top: 8px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.75rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .timeline-content-pro {
            background: white;
            padding: 1.5rem;
            border-radius: var(--border-radius-sm);
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border-left: 4px solid #e5e7eb;
        }
        
        .timeline-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }
        
        .timeline-time {
            font-size: 0.875rem;
            color: #6b7280;
            font-weight: 500;
        }
        
        
        
        /* Action Buttons */
        .action-btn-pro {
            background: var(--dark-gradient);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(44, 62, 80, 0.3);
        }
        
        .action-btn-pro:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(44, 62, 80, 0.4);
            color: white;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .admin-content {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-title {
                font-size: 1.5rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 0.75rem;
            }
            
            .card-body-pro {
                padding: 1.5rem;
            }
            
            .info-item {
                flex-direction: column;
                gap: 0.75rem;
            }
            
            .price-breakdown {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .timeline-item-pro {
                padding-left: 60px;
            }
            
            .timeline-marker-pro {
                left: 12px;
                width: 20px;
                height: 20px;
                font-size: 0.7rem;
            }
            
            .timeline-pro::before {
                left: 21px;
                width: 2px;
            }
        }
        
        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .professional-card {
            animation: fadeInUp 0.6s ease forwards;
        }
        
        .professional-card:nth-child(2) { animation-delay: 0.1s; }
        .professional-card:nth-child(3) { animation-delay: 0.2s; }
        .professional-card:nth-child(4) { animation-delay: 0.3s; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include sidebar -->
            <%@ include file="../includes/admin-sidebar.jsp" %>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 admin-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="d-flex justify-content-between align-items-center flex-wrap">
                        <h1 class="page-title">
                            <i class="fas fa-receipt"></i>
                            Chi tiết Booking
                            <span class="booking-id-badge">#${booking.bookingId}</span>
                        </h1>
                        <a href="${pageContext.request.contextPath}/admin/bookings" class="btn action-btn-pro">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>

                <div class="row">
                    <!-- Booking Information -->
                    <div class="col-lg-8">
                        <!-- Main Booking Info -->
                        <div class="professional-card">
                            <div class="card-header-pro">
                                <h5>
                                    <i class="fas fa-clipboard-list"></i>
                                    Thông tin đặt chỗ
                                </h5>
                            </div>
                            <div class="card-body-pro">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Khách hàng</div>
                                            <div class="info-value">
                                                ${booking.travelerName}
                                                <div style="font-size: 0.875rem; color: #64748b; font-weight: 400; margin-top: 2px;">
                                                    ${booking.travelerEmail}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-tag"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Loại dịch vụ</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${booking.experienceId != null}">
                                                        <span class="type-badge-pro type-experience">
                                                            <i class="fas fa-mountain me-1"></i>Experience
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.accommodationId != null}">
                                                        <span class="type-badge-pro type-accommodation">
                                                            <i class="fas fa-bed me-1"></i>Accommodation
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-star"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Tên dịch vụ</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty booking.experienceName}">
                                                        ${booking.experienceName}
                                                    </c:when>
                                                    <c:when test="${not empty booking.accommodationName}">
                                                        ${booking.accommodationName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8;">Không có thông tin</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-calendar-alt"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Ngày & Giờ đặt</div>
                                            <div class="info-value">
                                                <fmt:formatDate value="${booking.bookingDate}" pattern="EEEE, dd/MM/yyyy"/>
                                                <c:if test="${booking.bookingTime != null}">
                                                    <div style="font-size: 0.875rem; color: #64748b; margin-top: 2px;">
                                                        <i class="fas fa-clock me-1"></i>
                                                        <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Số lượng người</div>
                                            <div class="info-value">
                                                <span class="badge bg-primary" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                                    ${booking.numberOfPeople} người
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-history"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Ngày tạo booking</div>
                                            <div class="info-value">
                                                <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy"/>
                                                <div style="font-size: 0.875rem; color: #64748b; margin-top: 2px;">
                                                    <fmt:formatDate value="${booking.createdAt}" pattern="HH:mm:ss"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-flag"></i>
                                        </div>
                                        <div class="info-content">
                                            <div class="info-label">Trạng thái hiện tại</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${booking.status == 'PENDING'}">
                                                        <span class="status-badge-pro status-pending">
                                                            <i class="fas fa-clock me-1"></i>Chờ xác nhận
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'CONFIRMED'}">
                                                        <span class="status-badge-pro status-confirmed">
                                                            <i class="fas fa-check me-1"></i>Đã xác nhận
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'COMPLETED'}">
                                                        <span class="status-badge-pro status-completed">
                                                            <i class="fas fa-check-double me-1"></i>Hoàn thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'CANCELLED'}">
                                                        <span class="status-badge-pro status-cancelled">
                                                            <i class="fas fa-times me-1"></i>Đã hủy
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Special Requests -->
                        <c:if test="${not empty booking.specialRequests}">
                            <div class="professional-card">
                                <div class="card-header-pro">
                                    <h5>
                                        <i class="fas fa-comment-dots"></i>
                                        Yêu cầu đặc biệt
                                    </h5>
                                </div>
                                <div class="card-body-pro">
                                    <div class="contact-section">
                                        <div style="background: #fff; padding: 1.5rem; border-radius: 12px; border-left: 4px solid #667eea;">
                                            <p style="margin: 0; line-height: 1.6; color: #374151; font-size: 1rem;">
                                                ${booking.specialRequests}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>


                    </div>

                    <!-- Price Summary -->
                    <div class="col-lg-4">
                        <div class="professional-card">
                            <div class="card-header-pro">
                                <h5>
                                    <i class="fas fa-wallet"></i>
                                    Thông tin thanh toán
                                </h5>
                            </div>
                            <div class="card-body-pro">
                                <div class="price-section">
                                    <div class="price-icon">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                    <div class="price-amount">
                                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND" pattern="#,##0"/>
                                    </div>
                                    <div class="price-label">Tổng giá trị booking</div>
                                    
                                    <div class="price-breakdown">
                                        <div class="price-item">
                                            <div class="price-item-value">${booking.numberOfPeople}</div>
                                            <div class="price-item-label">Số người</div>
                                        </div>
                                        <div class="price-item">
                                            <div class="price-item-value">
                                                <fmt:formatNumber value="${booking.totalPrice / booking.numberOfPeople}" type="currency" currencyCode="VND" pattern="#,##0"/>
                                            </div>
                                            <div class="price-item-label">Giá/người</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Booking Timeline -->
                        <div class="professional-card">
                            <div class="card-header-pro">
                                <h5>
                                    <i class="fas fa-history"></i>
                                    Lịch sử trạng thái
                                </h5>
                            </div>
                            <div class="card-body-pro">
                                <div class="timeline-pro">
                                    <div class="timeline-item-pro">
                                        <div class="timeline-marker-pro" style="background: var(--primary-gradient);">
                                            <i class="fas fa-plus"></i>
                                        </div>
                                        <div class="timeline-content-pro" style="border-left-color: #667eea;">
                                            <div class="timeline-title">Booking được tạo</div>
                                            <div class="timeline-time">
                                                <i class="fas fa-calendar me-1"></i>
                                                <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy"/>
                                                <span style="margin-left: 10px;">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <fmt:formatDate value="${booking.createdAt}" pattern="HH:mm"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${booking.status == 'CONFIRMED' or booking.status == 'COMPLETED'}">
                                        <div class="timeline-item-pro">
                                            <div class="timeline-marker-pro" style="background: var(--success-gradient);">
                                                <i class="fas fa-check"></i>
                                            </div>
                                            <div class="timeline-content-pro" style="border-left-color: #11998e;">
                                                <div class="timeline-title">Đã xác nhận</div>
                                                <div class="timeline-time">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Booking đã được xác nhận và sẵn sàng sử dụng
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${booking.status == 'COMPLETED'}">
                                        <div class="timeline-item-pro">
                                            <div class="timeline-marker-pro" style="background: var(--info-gradient);">
                                                <i class="fas fa-flag-checkered"></i>
                                            </div>
                                            <div class="timeline-content-pro" style="border-left-color: #4facfe;">
                                                <div class="timeline-title">Hoàn thành</div>
                                                <div class="timeline-time">
                                                    <i class="fas fa-thumbs-up me-1"></i>
                                                    Dịch vụ đã được sử dụng thành công
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${booking.status == 'CANCELLED'}">
                                        <div class="timeline-item-pro">
                                            <div class="timeline-marker-pro" style="background: var(--danger-gradient);">
                                                <i class="fas fa-times"></i>
                                            </div>
                                            <div class="timeline-content-pro" style="border-left-color: #fc466b;">
                                                <div class="timeline-title">Đã hủy</div>
                                                <div class="timeline-time">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                                    Booking đã bị hủy bỏ
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add smooth loading animation
        document.addEventListener('DOMContentLoaded', function() {
            // Add fade-in effect to cards
            const cards = document.querySelectorAll('.professional-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
            
            // Animate timeline markers
            const timelineMarkers = document.querySelectorAll('.timeline-marker-pro');
            timelineMarkers.forEach((marker, index) => {
                setTimeout(() => {
                    marker.style.transform = 'scale(1.1)';
                    setTimeout(() => {
                        marker.style.transform = 'scale(1)';
                    }, 200);
                }, 500 + (index * 200));
            });
            
            // Animate price amount
            const priceAmount = document.querySelector('.price-amount');
            if (priceAmount) {
                const finalValue = priceAmount.textContent;
                priceAmount.textContent = '0';
                
                setTimeout(() => {
                    let currentValue = 0;
                    const targetValue = parseFloat(finalValue.replace(/[^\d]/g, ''));
                    const increment = targetValue / 50;
                    
                    const timer = setInterval(() => {
                        currentValue += increment;
                        if (currentValue >= targetValue) {
                            priceAmount.textContent = finalValue;
                            clearInterval(timer);
                        } else {
                            priceAmount.textContent = Math.floor(currentValue).toLocaleString() + ' VND';
                        }
                    }, 20);
                }, 800);
            }
        });
        
        // Add hover effects for info items
        document.addEventListener('DOMContentLoaded', function() {
            const infoItems = document.querySelectorAll('.info-item');
            infoItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                });
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });
        });
    </script>
</body>
</html> 