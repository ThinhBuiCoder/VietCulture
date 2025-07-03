<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đặt Chỗ - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .profile-header { background: linear-gradient(135deg, #10466C, #83C5BE); color: white; border-radius: 18px; padding: 32px 24px; margin-bottom: 32px; box-shadow: 0 4px 24px rgba(16,70,108,0.10); }
        .profile-avatar { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid #fff; margin-right: 20px; box-shadow: 0 2px 8px rgba(16,70,108,0.10); }
        .table-container { background: #fff; border-radius: 18px; box-shadow: 0 4px 24px rgba(16,70,108,0.08); overflow: hidden; }
        .table thead th { background: #10466C; color: #fff; border: none; font-weight: 600; font-size: 1.05em; }
        .table tbody tr { transition: background 0.2s; }
        .table tbody tr:hover { background: #f0f6fa; }
        .table td, .table th { vertical-align: middle; border: none; }
        .badge { font-size: 0.98em; border-radius: 8px; padding: 6px 14px; }
        .total-booking { font-size: 1.1em; color: #10466C; font-weight: 600; background: #e9f5f8; border-radius: 8px; padding: 4px 14px; }
        .back-btn { font-weight: 500; border-radius: 8px; box-shadow: 0 2px 8px rgba(16,70,108,0.08); }
        @media (max-width: 600px) {
            .profile-header { flex-direction: column; text-align: center; padding: 20px 8px; }
            .profile-avatar { margin-bottom: 12px; margin-right: 0; }
            .table-container { padding: 18px 6px; }
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="profile-header d-flex align-items-center mb-4 flex-wrap">
            <img src="${pageContext.request.contextPath}/images/avatars/${profileUser.avatar}?t=${System.currentTimeMillis()}" class="profile-avatar" alt="Avatar" onerror="this.src='https://cdn.pixabay.com/photo/2017/08/01/08/29/animation-2563491_1280.jpg'">
            <div>
                <h3 class="mb-1">${profileUser.fullName}</h3>
                <div class="text-white-50">${profileUser.email}</div>
                <div class="mt-1">
                    <span class="badge bg-primary">${profileUser.role}</span>
                </div>
            </div>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/profile?userId=${profileUser.userId}" class="btn btn-outline-light back-btn"><i class="ri-arrow-left-line me-1"></i> Quay lại hồ sơ</a>
            </div>
        </div>
        <div class="table-container mb-4">
            <div class="d-flex justify-content-between align-items-center px-4 pt-4 pb-2">
                <h5 class="mb-0"><i class="ri-bookmark-line me-2"></i>Lịch Sử Đặt Chỗ</h5>
                <span class="total-booking">Tổng số: <b>${fn:length(bookingHistory)}</b></span>
            </div>
            <div class="px-4 pb-4">
                <c:choose>
                    <c:when test="${not empty bookingHistory}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Dịch vụ</th>
                                        <th>Ngày đặt</th>
                                        <th>Thời gian</th>
                                        <th>Số người</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${bookingHistory}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <c:choose>
                                                        <c:when test="${not empty b.experienceName}">
                                                            <i class="ri-compass-3-line text-primary"></i>
                                                            <span class="badge bg-primary">Trải nghiệm</span>
                                                            <a href="${pageContext.request.contextPath}/profile/booking-detail?bookingId=${b.bookingId}" class="ms-1 text-decoration-underline text-dark">${b.experienceName}</a>
                                                        </c:when>
                                                        <c:when test="${not empty b.accommodationName}">
                                                            <i class="ri-hotel-bed-line text-success"></i>
                                                            <span class="badge bg-success">Lưu trú</span>
                                                            <a href="${pageContext.request.contextPath}/profile/booking-detail?bookingId=${b.bookingId}" class="ms-1 text-decoration-underline text-dark">${b.accommodationName}</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${b.bookingTime}" pattern="HH:mm"/></td>
                                            <td>${b.numberOfPeople}</td>
                                            <td><fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'CONFIRMED'}">
                                                        <span class="badge bg-success">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'COMPLETED'}">
                                                        <span class="badge bg-primary">Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${b.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            Không có lịch sử đặt chỗ nào.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html> 