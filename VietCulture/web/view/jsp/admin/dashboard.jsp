<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.css" rel="stylesheet">
    <style>
        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .stat-card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }
        .bg-primary-gradient { background: linear-gradient(45deg, #007bff, #0056b3); }
        .bg-success-gradient { background: linear-gradient(45deg, #28a745, #1e7e34); }
        .bg-warning-gradient { background: linear-gradient(45deg, #ffc107, #e0a800); }
        .bg-info-gradient { background: linear-gradient(45deg, #17a2b8, #138496); }
        .bg-danger-gradient { background: linear-gradient(45deg, #dc3545, #c82333); }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block admin-sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
<img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="Logo" style="height: 60px;">                        <h5 class="mt-2">ADMIN VIETCULTURE</h5>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/users">
                                <i class="fas fa-users me-2"></i> Quản lý Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/content/moderation">
                                <i class="fas fa-eye me-2"></i> Kiểm duyệt nội dung
                            </a>
                        </li>                 
                        <li class="nav-item">
                            <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/admin/complaints">
                                <i class="fas fa-exclamation-triangle me-2"></i> Khiếu nại
                            </a>
                        </li>
                    </ul>
                    
                    <hr class="text-white-50">
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-2"></i>
                            <strong>${sessionScope.user.fullName}</strong>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 admin-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">Xuất báo cáo</button>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary">
                            <i class="fas fa-calendar-alt me-1"></i>
                            Tuần này
                        </button>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng Users</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">${totalUsers}</div>
                                    </div>
                                    <div class="col-auto">
                                        <div class="stat-icon bg-primary-gradient">
                                            <i class="fas fa-users"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Experiences hoạt động</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">${activeExperiences}</div>
                                    </div>
                                    <div class="col-auto">
                                        <div class="stat-icon bg-success-gradient">
                                            <i class="fas fa-compass"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Chờ duyệt</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingApproval}</div>
                                    </div>
                                    <div class="col-auto">
                                        <div class="stat-icon bg-warning-gradient">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Bookings tháng này</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">${monthlyBookings}</div>
                                    </div>
                                    <div class="col-auto">
                                        <div class="stat-icon bg-info-gradient">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row mb-4">
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Thống kê Bookings</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-area">
                                    <canvas id="bookingChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Phân bố User Types</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-pie pt-4 pb-2">
                                    <canvas id="roleChart"></canvas>
                                </div>
                                <div class="mt-4 text-center small">
                                    <span class="mr-2"><i class="fas fa-circle text-primary"></i> Travelers</span>
                                    <span class="mr-2"><i class="fas fa-circle text-success"></i> Hosts</span>
                                    <span class="mr-2"><i class="fas fa-circle text-info"></i> Admins</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="row">
                    <div class="col-lg-6 mb-4">
                        <div class="card shadow">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Hoạt động gần đây</h6>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <div class="list-group-item d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">${activity.action}</h6>
                                                <p class="mb-1">${activity.description}</p>
                                                <small class="text-muted"><fmt:formatDate value="${activity.createdAt}" pattern="dd/MM/yyyy HH:mm"/></small>
                                            </div>
                                            <span class="badge ${activity.type == 'success' ? 'bg-success' : activity.type == 'warning' ? 'bg-warning' : 'bg-info'} rounded-pill">${activity.status}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 mb-4">
                        <div class="card shadow">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Cần xử lý</h6>
                            </div>
                            <div class="card-body">
                                <div class="list-group">
                                    <a href="${pageContext.request.contextPath}/admin/experiences/approval" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-compass text-warning me-2"></i>
                                            Experiences chờ duyệt
                                        </div>
                                        <span class="badge bg-warning rounded-pill">${pendingExperiences}</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/accommodations/approval" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-home text-info me-2"></i>
                                            Accommodations chờ duyệt
                                        </div>
                                        <span class="badge bg-info rounded-pill">${pendingAccommodations}</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/complaints" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-exclamation-triangle text-danger me-2"></i>
                                            Khiếu nại mới
                                        </div>
                                        <span class="badge bg-danger rounded-pill">${newComplaints}</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Booking Chart
        const bookingCtx = document.getElementById('bookingChart').getContext('2d');
        const bookingChart = new Chart(bookingCtx, {
            type: 'line',
            data: {
                labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                datasets: [{
                    label: 'Bookings',
                    data: [${weeklyBookings}],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // User Type Chart
        const roleCtx = document.getElementById('roleChart').getContext('2d');
        const roleChart = new Chart(roleCtx, {
            type: 'doughnut',
            data: {
                labels: ['Travelers', 'Hosts', 'Admins'],
                datasets: [{
                    data: [${travelerCount}, ${hostCount}, ${adminCount}],
                    backgroundColor: ['#007bff', '#28a745', '#17a2b8'],
                    hoverBackgroundColor: ['#0056b3', '#1e7e34', '#138496']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    </script>
</body>
</html>