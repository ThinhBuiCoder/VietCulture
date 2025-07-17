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
    <title>Thống kê - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', sans-serif;
        }
        
        .admin-content {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-left: 250px;
            position: relative;
        }
        
        .admin-content::before {
            content: '';
            position: fixed;
            top: 0;
            left: 250px;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="%23ffffff" opacity="0.05"/><circle cx="75" cy="75" r="1" fill="%23ffffff" opacity="0.05"/><circle cx="25" cy="75" r="1" fill="%23ffffff" opacity="0.05"/><circle cx="75" cy="25" r="1" fill="%23ffffff" opacity="0.05"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            z-index: 0;
            pointer-events: none;
        }
        
        .content-wrapper {
            position: relative;
            z-index: 1;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            position: relative;
            z-index: 2;
        }
        
        .page-header h1 i {
            margin-right: 15px;
            font-size: 2rem;
        }
        
        .page-header .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-top: 0.5rem;
            position: relative;
            z-index: 2;
        }
        
        .action-buttons {
            position: relative;
            z-index: 2;
        }
        
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            height: 100%;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover::before {
            transform: scaleX(1);
        }
        
        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        }
        
        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin-bottom: 1.5rem;
            position: relative;
            overflow: hidden;
        }
        
        .stat-icon::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            transition: all 0.6s ease;
            transform: translate(-50%, -50%);
        }
        
        .stat-card:hover .stat-icon::before {
            width: 100px;
            height: 100px;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            margin: 0.5rem 0;
            line-height: 1.2;
        }
        
        .stat-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: #718096;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }
        
        .stat-change {
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            margin-top: 0.5rem;
        }
        
        .stat-change i {
            margin-right: 0.5rem;
            font-size: 0.8rem;
        }
        
        .chart-container {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .chart-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .chart-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f7fafc;
        }
        
        .chart-title i {
            margin-right: 0.75rem;
            color: #667eea;
            font-size: 1.2rem;
        }
        
        .activity-section, .task-section {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .activity-section::before, .task-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .activity-item {
            background: #f8fafc;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 4px solid transparent;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .activity-item:hover {
            transform: translateX(8px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .activity-item.success { border-left-color: #48bb78; }
        .activity-item.warning { border-left-color: #ed8936; }
        .activity-item.info { border-left-color: #4299e1; }
        .activity-item.danger { border-left-color: #f56565; }
        
        .activity-item h6 {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .activity-item p {
            color: #718096;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .task-item {
            background: #f8fafc;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 4px solid;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .task-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            text-decoration: none;
            color: inherit;
        }
        
        .task-item i {
            font-size: 1.2rem;
            margin-right: 0.75rem;
        }
        
        .badge-modern {
            padding: 0.5rem 1rem;
            font-weight: 600;
            font-size: 0.8rem;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-modern {
            border-radius: 12px;
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
            border: none;
            position: relative;
            overflow: hidden;
        }
        
        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s ease;
        }
        
        .btn-modern:hover::before {
            left: 100%;
        }
        
        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        
        .bg-primary-gradient { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .bg-success-gradient { background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); }
        .bg-warning-gradient { background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%); }
        .bg-info-gradient { background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%); }
        .bg-danger-gradient { background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%); }
        
        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .quick-stat {
            background: rgba(255,255,255,0.9);
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .quick-stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }
        
        .quick-stat-label {
            font-size: 0.8rem;
            color: #718096;
            font-weight: 500;
        }
        
        .legend-item {
            display: inline-flex;
            align-items: center;
            margin: 0.25rem 0.5rem;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 0.5rem;
        }
        
        @media (max-width: 768px) {
            .admin-content {
                padding-left: 0;
                padding-top: 70px;
            }
            
            .page-header h1 {
                font-size: 1.8rem;
            }
            
            .stat-value {
                font-size: 2rem;
            }
            
            .chart-title {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0">
            <!-- Include sidebar -->
            <jsp:include page="/view/jsp/admin/includes/admin-sidebar.jsp" />

            <!-- Main content -->
            <main class="admin-content">
                <div class="content-wrapper px-4 py-4">
                    <!-- Page Header -->
                    <div class="page-header">
                        <div class="row align-items-center">
                            <div class="col-lg-8">
                                <h1><i class="fas fa-chart-line"></i> Thống kê hệ thống</h1>
                                <p class="subtitle mb-0">Tổng quan về hoạt động của VietCulture</p>
                            </div>
                           
                        </div>
                    </div>

                    

                    <!-- Main Stats Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="stat-card">
                                <div class="stat-icon bg-primary-gradient">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="stat-label">Tổng người dùng</div>
                                <div class="stat-value">${totalUsers}</div>
                                <div class="stat-change text-success">
                                    <i class="fas fa-arrow-up"></i>12% so với tháng trước
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="stat-card">
                                <div class="stat-icon bg-success-gradient">
                                    <i class="fas fa-compass"></i>
                                </div>
                                <div class="stat-label">Experiences hoạt động</div>
                                <div class="stat-value">${activeExperiences}</div>
                                <div class="stat-change text-success">
                                    <i class="fas fa-arrow-up"></i>8% so với tháng trước
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="stat-card">
                                <div class="stat-icon bg-warning-gradient">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="stat-label">Chờ phê duyệt</div>
                                <div class="stat-value">${pendingApproval}</div>
                                <div class="stat-change text-muted">
                                    <i class="fas fa-minus"></i>Không thay đổi
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="stat-card">
                                <div class="stat-icon bg-info-gradient">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="stat-label">Bookings tháng này</div>
                                <div class="stat-value">${monthlyBookings}</div>
                                <div class="stat-change text-success">
                                    <i class="fas fa-arrow-up"></i>15% so với tháng trước
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Section -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-8 col-lg-7">
                            <div class="chart-container">
                                <h3 class="chart-title">
                                    <i class="fas fa-chart-line"></i>
                                    Xu hướng Bookings
                                </h3>
                                <div style="height: 350px; position: relative;">
                                    <canvas id="bookingChart"></canvas>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-xl-4 col-lg-5">
                            <div class="chart-container">
                                <h3 class="chart-title">
                                    <i class="fas fa-users-cog"></i>
                                    Phân bố loại người dùng
                                </h3>
                                <div style="height: 280px; position: relative;">
                                    <canvas id="roleChart"></canvas>
                                </div>
                                <div class="text-center mt-3">
                                    <div class="legend-item">
                                        <div class="legend-color" style="background: #667eea;"></div>
                                        Travelers
                                    </div>
                                    <div class="legend-item">
                                        <div class="legend-color" style="background: #48bb78;"></div>
                                        Hosts
                                    </div>
                                    <div class="legend-item">
                                        <div class="legend-color" style="background: #4299e1;"></div>
                                        Admins
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Revenue Chart Section -->
                    <div class="row g-4 mb-4">
                        <div class="col-12">
                            <div class="chart-container">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h3 class="chart-title mb-0">
                                        <i class="fas fa-money-bill-wave"></i>
                                        Thống kê doanh thu
                                    </h3>
                                    <div class="btn-group" role="group">
                                        <input type="radio" class="btn-check" name="revenueFilter" id="week" autocomplete="off" checked>
                                        <label class="btn btn-outline-primary btn-sm" for="week">Tuần</label>

                                        <input type="radio" class="btn-check" name="revenueFilter" id="month" autocomplete="off">
                                        <label class="btn btn-outline-primary btn-sm" for="month">Tháng</label>

                                        <input type="radio" class="btn-check" name="revenueFilter" id="year" autocomplete="off">
                                        <label class="btn btn-outline-primary btn-sm" for="year">Năm</label>
                                    </div>
                                </div>
                                <div style="height: 400px; position: relative;">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                                
                                <!-- Revenue Stats Cards -->
                                <div class="row mt-4">
                                    <div class="col-md-3">
                                        <div class="text-center p-3 bg-light rounded-3">
                                            <div class="h4 text-success mb-1" id="totalRevenue">0 VNĐ</div>
                                            <div class="small text-muted">Tổng doanh thu</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="text-center p-3 bg-light rounded-3">
                                            <div class="h4 text-info mb-1" id="avgRevenue">0 VNĐ</div>
                                            <div class="small text-muted">Trung bình</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="text-center p-3 bg-light rounded-3">
                                            <div class="h4 text-warning mb-1" id="maxRevenue">0 VNĐ</div>
                                            <div class="small text-muted">Cao nhất</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="text-center p-3 bg-light rounded-3">
                                            <div class="h4 text-primary mb-1" id="growthRate">0%</div>
                                            <div class="small text-muted">Tăng trưởng</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Activities and Tasks -->
                    <div class="row g-4">
                        <div class="col-lg-6">
                            <div class="activity-section">
                                <h3 class="chart-title">
                                    <i class="fas fa-history"></i>
                                    Hoạt động gần đây
                                </h3>
                                <div class="activity-list">
                                    <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                                        <div class="activity-item ${activity.type}">
                                            <h6>${activity.action}</h6>
                                            <p>${activity.description}</p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <small class="text-muted">
                                                    <i class="far fa-clock me-1"></i>
                                                    <fmt:formatDate value="${activity.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                                <span class="badge ${activity.type == 'success' ? 'bg-success' : activity.type == 'warning' ? 'bg-warning' : 'bg-info'} badge-modern">
                                                    ${activity.status}
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="task-section">
                                <h3 class="chart-title">
                                    <i class="fas fa-tasks"></i>
                                    Cần xử lý
                                </h3>
                                <div>
                                    <a href="${pageContext.request.contextPath}/admin/content/approval?type=experience&status=PENDING" class="task-item" style="border-left-color: #ed8936;">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <i class="fas fa-compass" style="color: #ed8936;"></i>
                                                <strong>Experiences chờ duyệt</strong>
                                                <div class="text-muted small mt-1">Cần phê duyệt trong 24h</div>
                                            </div>
                                            <span class="badge bg-warning badge-modern">${pendingExperiences}</span>
                                        </div>
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/admin/content/approval?type=accommodation&status=PENDING" class="task-item" style="border-left-color: #4299e1;">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <i class="fas fa-home" style="color: #4299e1;"></i>
                                                <strong>Accommodations chờ duyệt</strong>
                                                <div class="text-muted small mt-1">Đang chờ xem xét</div>
                                            </div>
                                            <span class="badge bg-info badge-modern">${pendingAccommodations}</span>
                                        </div>
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/admin/reports" class="task-item" style="border-left-color: #f56565;">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <i class="fas fa-exclamation-triangle" style="color: #f56565;"></i>
                                                <strong>Khiếu nại mới</strong>
                                                <div class="text-muted small mt-1">Cần xử lý ngay</div>
                                            </div>
                                            <span class="badge bg-danger badge-modern">${newComplaints}</span>
                                        </div>
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
        // Booking Chart với gradient và animation
        const bookingCtx = document.getElementById('bookingChart').getContext('2d');
        const gradient = bookingCtx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(102, 126, 234, 0.8)');
        gradient.addColorStop(1, 'rgba(102, 126, 234, 0.1)');

        const bookingChart = new Chart(bookingCtx, {
            type: 'line',
            data: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'],
                datasets: [{
                    label: 'Bookings',
                    data: JSON.parse('[${weeklyBookings}]'),
                    borderColor: '#667eea',
                    backgroundColor: gradient,
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#667eea',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        cornerRadius: 8,
                        padding: 12
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            color: '#718096'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#718096'
                        }
                    }
                },
                animation: {
                    duration: 2000,
                    easing: 'easeInOutQuart'
                }
            }
        });

        // Role Chart với màu sắc đẹp
        const roleCtx = document.getElementById('roleChart').getContext('2d');
        const roleChart = new Chart(roleCtx, {
            type: 'doughnut',
            data: {
                labels: ['Travelers', 'Hosts', 'Admins'],
                datasets: [{
                    data: [parseInt('${travelerCount}'), parseInt('${hostCount}'), parseInt('${adminCount}')],
                    backgroundColor: ['#667eea', '#48bb78', '#4299e1'],
                    borderWidth: 0,
                    hoverOffset: 15
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        cornerRadius: 8,
                        padding: 12
                    }
                },
                animation: {
                    duration: 1500,
                    easing: 'easeInOutQuart'
                }
            }
        });

        // Revenue Chart Data - Lấy từ backend
        const revenueData = {
            week: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'],
                data: JSON.parse('[${weeklyRevenue}]'), // Doanh thu theo tuần từ controller
                backgroundColor: '#667eea'
            },
            month: {
                labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                data: JSON.parse('[${monthlyRevenue}]'), // Doanh thu theo tháng từ controller  
                backgroundColor: '#48bb78'
            },
            year: {
                labels: JSON.parse('[${yearLabels}]'), // Nhãn năm từ controller
                data: JSON.parse('[${yearlyRevenue}]'), // Doanh thu theo năm từ controller
                backgroundColor: '#4299e1'
            }
        };

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        let revenueChart = new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: revenueData.week.labels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: revenueData.week.data,
                    backgroundColor: revenueData.week.backgroundColor,
                    borderRadius: 8,
                    borderSkipped: false,
                    borderWidth: 2,
                    borderColor: 'transparent'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        cornerRadius: 8,
                        padding: 12,
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + formatCurrency(context.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            color: '#718096',
                            callback: function(value) {
                                return formatCurrency(value);
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#718096'
                        }
                    }
                },
                animation: {
                    duration: 1500,
                    easing: 'easeInOutQuart'
                },
                interaction: {
                    mode: 'index',
                    intersect: false
                }
            }
        });

        // Format currency function
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            }).format(amount);
        }

        // Update revenue stats
        function updateRevenueStats(data) {
            const total = data.reduce((sum, value) => sum + value, 0);
            const average = total / data.length;
            const max = Math.max(...data);
            
            // Calculate growth rate (comparing with previous period)
            const currentPeriod = data.slice(-Math.ceil(data.length/2));
            const previousPeriod = data.slice(0, Math.floor(data.length/2));
            const currentAvg = currentPeriod.reduce((sum, value) => sum + value, 0) / currentPeriod.length;
            const previousAvg = previousPeriod.reduce((sum, value) => sum + value, 0) / previousPeriod.length;
            const growthRate = ((currentAvg - previousAvg) / previousAvg * 100).toFixed(1);

            document.getElementById('totalRevenue').textContent = formatCurrency(total);
            document.getElementById('avgRevenue').textContent = formatCurrency(average);
            document.getElementById('maxRevenue').textContent = formatCurrency(max);
            document.getElementById('growthRate').textContent = growthRate + '%';
            
            // Update growth rate color
            const growthElement = document.getElementById('growthRate');
            if (growthRate > 0) {
                growthElement.className = 'h4 text-success mb-1';
            } else if (growthRate < 0) {
                growthElement.className = 'h4 text-danger mb-1';
            } else {
                growthElement.className = 'h4 text-muted mb-1';
            }
        }

        // Revenue filter change handler
        document.querySelectorAll('input[name="revenueFilter"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const period = this.id;
                const data = revenueData[period];
                
                // Update chart data with animation
                revenueChart.data.labels = data.labels;
                revenueChart.data.datasets[0].data = data.data;
                revenueChart.data.datasets[0].backgroundColor = data.backgroundColor;
                
                // Create gradient background
                const ctx = revenueChart.ctx;
                const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, data.backgroundColor + 'CC');
                gradient.addColorStop(1, data.backgroundColor + '33');
                revenueChart.data.datasets[0].backgroundColor = gradient;
                
                revenueChart.update('active');
                
                // Update stats
                updateRevenueStats(data.data);
                
                // Update chart title based on period
                const titles = {
                    week: 'Doanh thu theo tuần',
                    month: 'Doanh thu theo tháng', 
                    year: 'Doanh thu theo năm'
                };
                
                // Add period indicator
                setTimeout(() => {
                    const chartTitle = document.querySelector('#revenueChart').closest('.chart-container').querySelector('.chart-title');
                    const titleText = chartTitle.innerHTML;
                    if (!titleText.includes('(')) {
                        chartTitle.innerHTML = titleText.replace('Thống kê doanh thu', `Thống kê doanh thu (${titles[period]})`);
                    } else {
                        chartTitle.innerHTML = titleText.replace(/\([^)]*\)/, `(${titles[period]})`);
                    }
                }, 100);
            });
        });

        // Initialize revenue stats
        updateRevenueStats(revenueData.week.data);

        // Animate numbers on scroll
        function animateNumbers() {
            const statValues = document.querySelectorAll('.stat-value');
            statValues.forEach(stat => {
                const target = parseInt(stat.textContent.replace(/[^\d]/g, ''));
                let current = 0;
                const increment = target / 100;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        current = target;
                        clearInterval(timer);
                    }
                    stat.textContent = Math.floor(current).toLocaleString();
                }, 20);
            });
        }

        // Trigger animation on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(animateNumbers, 500);
        });

        // Add hover effects to stat cards
        document.querySelectorAll('.stat-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Real-time clock for dashboard
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('vi-VN', { 
                hour: '2-digit', 
                minute: '2-digit',
                second: '2-digit'
            });
            const dateString = now.toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            
            // Update if clock element exists
            const clockElement = document.getElementById('dashboard-clock');
            if (clockElement) {
                clockElement.innerHTML = `<strong>${timeString}</strong><br><small>${dateString}</small>`;
            }
        }

        // Update time every second
        setInterval(updateTime, 1000);
        updateTime(); // Initial call

        // Smooth scrolling for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Loading states for buttons
        document.querySelectorAll('.btn-modern').forEach(btn => {
            btn.addEventListener('click', function() {
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                this.disabled = true;
                
                // Simulate loading (remove this in production)
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 2000);
            });
        });

        // Progressive enhancement for charts
        function enhanceCharts() {
            // Add data labels to charts when hovering
            Chart.defaults.plugins.tooltip.enabled = true;
            Chart.defaults.plugins.tooltip.mode = 'index';
            Chart.defaults.plugins.tooltip.intersect = false;
        }

        enhanceCharts();

        // Responsive chart resize
        window.addEventListener('resize', function() {
            if (bookingChart) bookingChart.resize();
            if (roleChart) roleChart.resize();
            if (revenueChart) revenueChart.resize();
        });

        // Auto-refresh data every 5 minutes (adjust as needed)
        setInterval(function() {
            // Uncomment below line in production to auto-refresh
            // location.reload();
            console.log('Auto-refresh triggered (disabled in demo)');
        }, 300000); // 5 minutes

        // Notification system for new activities
        function checkForUpdates() {
            // This would typically make an AJAX call to check for new data
            // For demo purposes, we'll simulate it
            const badges = document.querySelectorAll('.badge-modern');
            badges.forEach(badge => {
                const currentValue = parseInt(badge.textContent);
                // Simulate random updates (remove in production)
                if (Math.random() > 0.9) {
                    badge.textContent = currentValue + 1;
                    badge.style.animation = 'pulse 1s ease-in-out';
                    setTimeout(() => {
                        badge.style.animation = '';
                    }, 1000);
                }
            });
        }

        // Check for updates every 30 seconds
        setInterval(checkForUpdates, 30000);

        // Add pulse animation for important notifications
        const style = document.createElement('style');
        style.textContent = `
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.1); }
                100% { transform: scale(1); }
            }
            
            .notification-pulse {
                animation: pulse 1s ease-in-out infinite;
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>