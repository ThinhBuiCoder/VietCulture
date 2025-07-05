<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <style>
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #10466C;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            z-index: 1000;
            padding: 15px 0;
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
            width: auto;
            margin-right: 12px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
            object-fit: contain;
            display: inline-block;
        }
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
        .nav-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .nav-right a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
        }
        .nav-right a:hover {
            color: #FF385C;
            background-color: rgba(255, 56, 92, 0.08);
        }
        .dropdown-item { color: #10466C; }
        .dropdown-item i { color: #10466C; }
        body { font-family: 'Inter', sans-serif; background-color: #F8F9FA; padding-top: 80px; }
    </style>
</head>
<body>
<nav class="custom-navbar">
    <div class="container">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
            <span>VIETCULTURE</span>
        </a>
        <div class="nav-center">
            <a href="${pageContext.request.contextPath}/" class="nav-center-item">Trang Chủ</a>
            <a href="/Travel/experiences" class="nav-center-item">Trải Nghiệm</a>
            <a href="/Travel/accommodations" class="nav-center-item">Lưu Trú</a>
        </div>
        <div class="nav-right">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
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
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/host/bookings/manage" style="color: #10466C; font-weight: 600;">
                                        <i class="ri-calendar-check-line"></i> Quản Lý Booking
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
                </c:when>
            </c:choose>
        </div>
    </div>
</nav>
<div class="container my-5">
    <h2 class="mb-4"><i class="ri-calendar-check-line"></i> Quản Lý Booking</h2>
    <table class="table table-hover table-bordered align-middle">
        <thead class="table-light">
            <tr>
                <th>Mã Booking</th>
                <th>Khách</th>
                <th>Dịch vụ</th>
                <th>Ngày</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="booking" items="${bookings}">
            <tr>
                <td>${booking.bookingId}</td>
                <td>${booking.travelerName}</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty booking.accommodationId}">Lưu trú</c:when>
                        <c:otherwise>Trải nghiệm</c:otherwise>
                    </c:choose>
                </td>
                <td>${booking.bookingDate}</td>
                <td>
                    <span class="badge 
                        ${booking.status eq 'PENDING' ? 'bg-warning text-dark' : 
                          booking.status eq 'CONFIRMED' ? 'bg-success' : 
                          booking.status eq 'REJECTED' ? 'bg-danger' : 'bg-secondary'}">
                        ${booking.status}
                    </span>
                </td>
                <td>
                    <c:if test="${booking.status eq 'PENDING'}">
                        <button class="btn btn-success btn-sm" onclick="confirmBooking(${booking.bookingId}, 'CONFIRMED')">
                            <i class="ri-check-line"></i> Chấp nhận
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="confirmBooking(${booking.bookingId}, 'REJECTED')">
                            <i class="ri-close-line"></i> Từ chối
                        </button>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<script>
function confirmBooking(bookingId, action) {
    fetch('${pageContext.request.contextPath}/host/bookings/manage', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `bookingId=${bookingId}&action=${action}`
    }).then(() => location.reload());
}
</script>
</body>
</html> 