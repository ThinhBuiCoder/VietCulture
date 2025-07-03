<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đặt Chỗ - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #10466C;
            --secondary-color: #83C5BE;
            --success-color: #22C55E;
            --warning-color: #F59E0B;
            --danger-color: #EF4444;
            --light-bg: #F8FAFC;
            --card-shadow: 0 4px 24px rgba(16, 70, 108, 0.08);
            --border-radius: 16px;
        }

        body { 
            background: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
        }

        /* Header Profile Section */
        .profile-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            pointer-events: none;
        }

        .profile-content {
            position: relative;
            z-index: 1;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .profile-avatar:hover {
            transform: scale(1.05);
        }

        .user-info h3 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            font-size: 1.5rem;
        }

        .user-email {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.95rem;
            margin-bottom: 0.75rem;
        }

        .role-badge {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 500;
            font-size: 0.875rem;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.25);
            color: white;
            transform: translateY(-2px);
        }

        /* Main Content Card */
        .detail-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 2rem;
            max-width: 900px;
            margin: 0 auto;
            border: 1px solid rgba(16, 70, 108, 0.06);
        }

        .card-header {
            border-bottom: 2px solid #F1F5F9;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .card-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-label {
            font-weight: 600;
            color: var(--primary-color);
            min-width: 120px;
            display: inline-block;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-value {
            font-size: 1.1em;
            color: #1E293B;
        }

        .row-detail {
            margin-bottom: 20px;
            padding: 1rem;
            background: #FAFBFC;
            border-radius: 12px;
            border: 1px solid #E5E7EB;
        }

        /* Service Items */
        .service-item {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 8px;
            padding: 12px 16px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .service-item.experience {
            background: #EEF2FF;
            border-color: #C7D2FE;
        }

        .service-item.accommodation {
            background: #F0FDF4;
            border-color: #BBF7D0;
        }

        .service-item i {
            font-size: 1.2rem;
        }

        /* Status Badges */
        .status-badge {
            font-size: 0.875rem;
            border-radius: 50px;
            padding: 8px 16px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        /* Special Requests & Contact Info Styling */
        .special-requests-box, .contact-info-box {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 8px;
            padding: 12px 16px;
            margin-top: 8px;
            font-size: 1rem;
            line-height: 1.5;
        }

        .contact-info-box {
            background: #F0FDF4;
            border-color: #BBF7D0;
        }

        .special-requests-box {
            background: #EEF2FF;
            border-color: #C7D2FE;
        }

        /* Action Buttons */
        .action-btn {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            color: white;
            padding: 1rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 16px rgba(16, 70, 108, 0.2);
        }

        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 32px rgba(16, 70, 108, 0.3);
            color: white;
        }

        /* Enhanced styling for better visual hierarchy */
        .badge { 
            font-size: 1em; 
            border-radius: 8px; 
            padding: 6px 14px; 
        }

        .text-muted {
            color: #6B7280 !important;
            font-style: italic;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
                padding: 20px 16px;
            }

            .profile-avatar {
                margin-bottom: 12px;
                margin-right: 0;
            }

            .detail-card {
                padding: 18px 16px;
                margin: 0 1rem;
            }

            .row-detail {
                padding: 0.75rem;
            }

            .action-btn {
                padding: 0.875rem 1.5rem;
                font-size: 0.9rem;
            }

            .col-md-6, .col-md-3 {
                margin-bottom: 1rem;
            }

            .detail-label {
                min-width: auto;
                display: block;
                margin-bottom: 0.5rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 0.5rem;
            }

            .profile-header {
                margin: 0 0.5rem 1.5rem;
                padding: 1rem;
            }

            .detail-card {
                margin: 0 0.5rem;
                padding: 1rem;
            }

            .user-info h3 {
                font-size: 1.25rem;
            }
        }

        /* Animation for smooth loading */
        .row-detail {
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Profile Header -->
        <div class="profile-header d-flex align-items-center mb-4 flex-wrap">
            <img src="${pageContext.request.contextPath}/images/avatars/${profileUser.avatar}?t=${System.currentTimeMillis()}" 
                 class="profile-avatar" 
                 alt="Avatar" 
                 onerror="this.src='https://cdn.pixabay.com/photo/2017/08/01/08/29/animation-2563491_1280.jpg'">
            <div class="user-info">
                <h3 class="mb-1">${profileUser.fullName}</h3>
                <div class="user-email">${profileUser.email}</div>
                <div class="mt-1">
                    <span class="role-badge">${profileUser.role}</span>
                </div>
            </div>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/profile/bookings?userId=${profileUser.userId}" class="back-btn">
                    <i class="ri-arrow-left-line me-1"></i> Quay lại lịch sử
                </a>
            </div>
        </div>

        <!-- Main Content Card -->
        <div class="detail-card">
            <div class="card-header">
                <h4 class="card-title">
                    <i class="ri-file-list-3-line"></i>Chi Tiết Đặt Chỗ
                </h4>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger mb-4">
                    <i class="ri-error-warning-line me-2"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Booking Details -->
            <c:if test="${not empty booking}">
                <div class="row row-detail">
                    <div class="col-md-6 mb-2">
                        <span class="detail-label">Dịch vụ:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty booking.experienceName}">
                                    <div class="service-item experience">
                                        <i class="ri-compass-3-line text-primary"></i>
                                        <span class="badge bg-primary">Trải nghiệm</span>
                                        <span class="ms-2 fw-semibold text-dark">${booking.experienceName}</span>
                                    </div>
                                </c:when>
                                <c:when test="${not empty booking.accommodationName}">
                                    <div class="service-item accommodation">
                                        <i class="ri-hotel-bed-line text-success"></i>
                                        <span class="badge bg-success">Lưu trú</span>
                                        <span class="ms-2 fw-semibold text-dark">${booking.accommodationName}</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Không có dịch vụ</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="detail-label">Ngày đặt:</span>
                        <span class="detail-value">
                            <i class="ri-calendar-line text-primary me-2"></i>
                            <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="detail-label">Thời gian:</span>
                        <span class="detail-value">
                            <i class="ri-time-line text-primary me-2"></i>
                            <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/>
                        </span>
                    </div>
                </div>

                <div class="row row-detail">
                    <div class="col-md-3 mb-2">
                        <span class="detail-label">Số người:</span>
                        <span class="detail-value">
                            <i class="ri-group-line text-primary me-2"></i>
                            ${booking.numberOfPeople} người
                        </span>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="detail-label">Tổng tiền:</span>
                        <span class="detail-value">
                            <i class="ri-money-dollar-circle-line text-success me-2"></i>
                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="detail-label">Trạng thái:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${booking.status == 'PENDING'}">
                                    <span class="badge bg-warning text-dark status-badge">
                                        <i class="ri-time-line me-1"></i>Chờ xác nhận
                                    </span>
                                </c:when>
                                <c:when test="${booking.status == 'CONFIRMED'}">
                                    <span class="badge bg-success status-badge">
                                        <i class="ri-checkbox-circle-line me-1"></i>Đã xác nhận
                                    </span>
                                </c:when>
                                <c:when test="${booking.status == 'CANCELLED'}">
                                    <span class="badge bg-danger status-badge">
                                        <i class="ri-close-circle-line me-1"></i>Đã hủy
                                    </span>
                                </c:when>
                                <c:when test="${booking.status == 'COMPLETED'}">
                                    <span class="badge bg-primary status-badge">
                                        <i class="ri-medal-line me-1"></i>Hoàn thành
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${booking.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="col-md-3 mb-2">
                        <span class="detail-label">Ngày tạo:</span>
                        <span class="detail-value">
                            <i class="ri-calendar-check-line text-primary me-2"></i>
                            <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>
                </div>

                <!-- Additional Information -->
                <div class="row row-detail">
                    <div class="col-md-6 mb-2">
                        <span class="detail-label">Ghi chú/Special requests:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty booking.specialRequests}">
                                    <div class="special-requests-box">
                                        <i class="ri-chat-3-line text-primary me-2"></i>
                                        ${booking.specialRequests}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Không có yêu cầu đặc biệt</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="col-md-6 mb-2">
                        <span class="detail-label">Thông tin liên hệ:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty booking.travelerName || not empty booking.travelerEmail || not empty booking.contactInfo}">
                                    <div class="contact-info-box">
                                        <c:if test="${not empty booking.travelerName}">
                                            <div><strong>Tên:</strong> ${booking.travelerName}</div>
                                        </c:if>
                                        <c:if test="${not empty booking.travelerEmail}">
                                            <div><strong>Email:</strong> ${booking.travelerEmail}</div>
                                        </c:if>
                                        <c:if test="${not empty booking.contactInfo}">
                                            <div><strong>Số điện thoại:</strong> ${booking.contactInfo}</div>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Không có thông tin liên hệ</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="row row-detail">
                    <div class="col-12">
                        <div class="d-flex justify-content-center mt-4">
                            <c:choose>
                                <c:when test="${not empty booking.experienceId}">
                                    <a href="${pageContext.request.contextPath}/experiences/${booking.experienceId}?bookingId=${booking.bookingId}" class="btn btn-primary me-3 action-btn">
                                        <i class="ri-compass-3-line me-2"></i>Xem chi tiết trải nghiệm
                                    </a>
                                </c:when>
                                <c:when test="${not empty booking.accommodationId}">
                                    <a href="${pageContext.request.contextPath}/accommodations/${booking.accommodationId}?bookingId=${booking.bookingId}" class="btn btn-primary me-3 action-btn">
                                        <i class="ri-hotel-bed-line me-2"></i>Xem chi tiết lưu trú
                                    </a>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>