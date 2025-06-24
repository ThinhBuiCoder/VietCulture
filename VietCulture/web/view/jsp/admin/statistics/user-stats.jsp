<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.userType ne 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê hệ thống - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .chart-container {
                position: relative;
                height: 400px;
            }
            .metric-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .trend-up {
                color: #28a745;
            }
            .trend-down {
                color: #dc3545;
            }
            .trend-stable {
                color: #6c757d;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Include sidebar -->
                <%@ include file="../includes/admin-sidebar.jsp" %>

                <!-- Main content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 admin-content">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2"><i class="fas fa-chart-bar me-2"></i>Thống kê hệ thống</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown">
                                    <i class="fas fa-calendar me-1"></i>Thời gian
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="?period=today">Hôm nay</a></li>
                                    <li><a class="dropdown-item" href="?period=week">7 ngày qua</a></li>
                                    <li><a class="dropdown-item" href="?period=month">30 ngày qua</a></li>
                                    <li><a class="dropdown-item" href="?period=year">12 tháng qua</a></li>
                                </ul>
                            </div>
                            <button type="button" class="btn btn-sm btn-primary" onclick="exportReport()">
                                <i class="fas fa-download me-1"></i>Xuất báo cáo
                            </button>
                        </div>
                    </div>

                    <!-- Key Metrics Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card h-100">
                                <div class="card-body text-center">
                                    <div class="mb-3">
                                        <i class="fas fa-users fa-3x"></i>
                                    </div>
                                    <h2 class="mb-1">${totalUsers}</h2>
                                    <p class="mb-2">Tổng Users</p>
                                    <div class="small">
                                        <span class="trend-up">
                                            <i class="fas fa-arrow-up me-1"></i>${userGrowth}%
                                        </span>
                                        so với tháng trước
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card h-100">
                                <div class="card-body text-center">
                                    <div class="mb-3">
                                        <i class="fas fa-compass fa-3x"></i>
                                    </div>
                                    <h2 class="mb-1">${totalExperiences}</h2>
                                    <p class="mb-2">Experiences</p>
                                    <div class="small">
                                        <span class="trend-up">
                                            <i class="fas fa-arrow-up me-1"></i>${experienceGrowth}%
                                        </span>
                                        so với tháng trước
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card h-100">
                                <div class="card-body text-center">
                                    <div class="mb-3">
                                        <i class="fas fa-calendar-check fa-3x"></i>
                                    </div>
                                    <h2 class="mb-1">${totalBookings}</h2>
                                    <p class="mb-2">Bookings</p>
                                    <div class="small">
                                        <span class="trend-up">
                                            <i class="fas fa-arrow-up me-1"></i>${bookingGrowth}%
                                        </span>
                                        so với tháng trước
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card h-100">
                                <div class="card-body text-center">
                                    <div class="mb-3">
                                        <i class="fas fa-dollar-sign fa-3x"></i>
                                    </div>
                                    <h2 class="mb-1">${totalRevenue}K</h2>
                                    <p class="mb-2">Doanh thu (VNĐ)</p>
                                    <div class="small">
                                        <span class="trend-up">
                                            <i class="fas fa-arrow-up me-1"></i>${revenueGrowth}%
                                        </span>
                                        so với tháng trước
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row -->
                    <div class="row mb-4">
                        <!-- User Growth Chart -->
                        <div class="col-xl-8 col-lg-7">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">Tăng trưởng Users</h6>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" onclick="changeChartType('line')">Biểu đồ đường</a></li>
                                            <li><a class="dropdown-item" href="#" onclick="changeChartType('bar')">Biểu đồ cột</a></li>
                                            <li><a class="dropdown-item" href="#" onclick="changeChartType('area')">Biểu đồ vùng</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="userGrowthChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- User Distribution -->
                        <div class="col-xl-4 col-lg-5">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Phân bố User Types</h6>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="userDistributionChart"></canvas>
                                    </div>
                                    <div class="mt-4">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span><i class="fas fa-circle text-primary"></i> Travelers</span>
                                            <span>${travelerPercentage}%</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span><i class="fas fa-circle text-success"></i> Hosts</span>
                                            <span>${hostPercentage}%</span>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <span><i class="fas fa-circle text-info"></i> Admins</span>
                                            <span>${adminPercentage}%</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Regional Statistics -->
                    <div class="row mb-4">
                        <div class="col-lg-8">
                            <div class="card shadow">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Thống kê theo vùng miền</h6>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="regionalChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="card shadow">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Top Cities</h6>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="city" items="${topCities}">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div>
                                                <strong>${city.vietnameseName}</strong>
                                                <br>
                                                <small class="text-muted">${city.experienceCount + city.accommodationCount} listings</small>
                                            </div>
                                            <div class="text-end">
                                                <div class="progress" style="width: 80px; height: 8px;">
                                                    <div class="progress-bar" role="progressbar" 
                                                         style="width: ${city.percentage}%" 
                                                         aria-valuenow="${city.percentage}" 
                                                         aria-valuemin="0" 
                                                         aria-valuemax="100">
                                                    </div>
                                                </div>
                                                <small class="text-muted">${city.percentage}%</small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Performance Metrics -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6">
                            <div class="metric-card text-center">
                                <i class="fas fa-star fa-2x text-warning mb-2"></i>
                                <h4>${averageRating}</h4>
                                <p class="text-muted">Đánh giá trung bình</p>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6">
                            <div class="metric-card text-center">
                                <i class="fas fa-percentage fa-2x text-success mb-2"></i>
                                <h4>${conversionRate}%</h4>
                                <p class="text-muted">Tỷ lệ chuyển đổi</p>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6">
                            <div class="metric-card text-center">
                                <i class="fas fa-redo-alt fa-2x text-info mb-2"></i>
                                <h4>${returnRate}%</h4>
                                <p class="text-muted">Khách quay lại</p>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6">
                            <div class="metric-card text-center">
                                <i class="fas fa-clock fa-2x text-primary mb-2"></i>
                                <h4>${avgResponseTime}h</h4>
                                <p class="text-muted">Thời gian phản hồi</p>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activities Table -->
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card shadow">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Hoạt động gần đây</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Thời gian</th>
                                                    <th>Hoạt động</th>
                                                    <th>User</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="activity" items="${recentActivities}">
                                                    <tr>
                                                        <td>
                                                            <small><fmt:formatDate value="${activity.createdAt}" pattern="dd/MM HH:mm"/></small>
                                                        </td>
                                                        <td>
                                                            <i class="fas ${activity.icon} me-2"></i>
                                                            ${activity.description}
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <c:choose>
                                                                    <c:when test="${not empty activity.userAvatar}">
                                                                        <img src="${pageContext.request.contextPath}/assets/images/avatars/${activity.userAvatar}" 
                                                                             class="rounded-circle me-2" style="width: 30px; height: 30px; object-fit: cover;">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center me-2" 
                                                                             style="width: 30px; height: 30px;">
                                                                            <i class="fas fa-user text-white" style="font-size: 12px;"></i>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <div>
                                                                    <strong>${activity.userName}</strong>
                                                                    <br>
                                                                    <small class="text-muted">${activity.userType}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${activity.status == 'success'}">
                                                                    <span class="badge bg-success">Thành công</span>
                                                                </c:when>
                                                                <c:when test="${activity.status == 'pending'}">
                                                                    <span class="badge bg-warning">Chờ xử lý</span>
                                                                </c:when>
                                                                <c:when test="${activity.status == 'failed'}">
                                                                    <span class="badge bg-danger">Thất bại</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-info">${activity.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- System Health -->
                        <div class="col-lg-4">
                            <div class="card shadow">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Tình trạng hệ thống</h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span>Server Status</span>
                                            <span class="badge bg-success">Online</span>
                                        </div>
                                        <div class="progress mb-1" style="height: 8px;">
                                            <div class="progress-bar bg-success" role="progressbar" style="width: 98%" aria-valuenow="98" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <small class="text-muted">Uptime: 99.8%</small>
                                    </div>

                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span>Database</span>
                                            <span class="badge bg-success">Healthy</span>
                                        </div>
                                        <div class="progress mb-1" style="height: 8px;">
                                            <div class="progress-bar bg-success" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <small class="text-muted">Response time: 45ms</small>
                                    </div>

                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span>Storage</span>
                                            <span class="badge bg-warning">70% Used</span>
                                        </div>
                                        <div class="progress mb-1" style="height: 8px;">
                                            <div class="progress-bar bg-warning" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <small class="text-muted">35GB / 50GB</small>
                                    </div>

                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span>API Calls</span>
                                            <span class="text-muted">${apiCallsToday}</span>
                                        </div>
                                        <div class="progress mb-1" style="height: 8px;">
                                            <div class="progress-bar bg-info" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <small class="text-muted">Hôm nay</small>
                                    </div>

                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <small>Hệ thống hoạt động bình thường. Lần backup cuối: <fmt:formatDate value="${lastBackup}" pattern="dd/MM/yyyy HH:mm"/></small>
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
                                                // User Growth Chart
                                                const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
                                                const userGrowthChart = new Chart(userGrowthCtx, {
                                                    type: 'line',
                                                    data: {
                                                        labels: [${monthLabels}],
                                                        datasets: [{
                                                                label: 'Travelers',
                                                                data: [${travelerData}],
                                                                borderColor: '#007bff',
                                                                backgroundColor: 'rgba(0, 123, 255, 0.1)',
                                                                tension: 0.4,
                                                                fill: true
                                                            }, {
                                                                label: 'Hosts',
                                                                data: [${hostData}],
                                                                borderColor: '#28a745',
                                                                backgroundColor: 'rgba(40, 167, 69, 0.1)',
                                                                tension: 0.4,
                                                                fill: true
                                                            }]
                                                    },
                                                    options: {
                                                        responsive: true,
                                                        maintainAspectRatio: false,
                                                        scales: {
                                                            y: {
                                                                beginAtZero: true,
                                                                ticks: {
                                                                    callback: function (value) {
                                                                        return value.toLocaleString();
                                                                    }
                                                                }
                                                            }
                                                        },
                                                        plugins: {
                                                            legend: {
                                                                position: 'top',
                                                            },
                                                            tooltip: {
                                                                mode: 'index',
                                                                intersect: false,
                                                                callbacks: {
                                                                    label: function (context) {
                                                                        return context.dataset.label + ': ' + context.parsed.y.toLocaleString();
                                                                    }
                                                                }
                                                            }
                                                        },
                                                        interaction: {
                                                            mode: 'nearest',
                                                            axis: 'x',
                                                            intersect: false
                                                        }
                                                    }
                                                });

                                                // User Distribution Chart
                                                const userDistributionCtx = document.getElementById('userDistributionChart').getContext('2d');
                                                const userDistributionChart = new Chart(userDistributionCtx, {
                                                    type: 'doughnut',
                                                    data: {
                                                        labels: ['Travelers', 'Hosts', 'Admins'],
                                                        datasets: [{
                                                                data: [${travelerCount}, ${hostCount}, ${adminCount}],
                                                                backgroundColor: ['#007bff', '#28a745', '#17a2b8'],
                                                                hoverBackgroundColor: ['#0056b3', '#1e7e34', '#138496'],
                                                                borderWidth: 2,
                                                                borderColor: '#fff'
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
                                                                callbacks: {
                                                                    label: function (context) {
                                                                        const label = context.label || '';
                                                                        const value = context.parsed || 0;
                                                                        const percentage = ((value / ${totalUsers}) * 100).toFixed(1);
                                                                        return label + ': ' + value + ' (' + percentage + '%)';
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                });

                                                // Regional Chart
                                                const regionalCtx = document.getElementById('regionalChart').getContext('2d');
                                                const regionalChart = new Chart(regionalCtx, {
                                                    type: 'bar',
                                                    data: {
                                                        labels: ['Miền Bắc', 'Miền Trung', 'Miền Nam'],
                                                        datasets: [{
                                                                label: 'Experiences',
                                                                data: [${northExperiences}, ${centralExperiences}, ${southExperiences}],
                                                                backgroundColor: 'rgba(54, 162, 235, 0.8)',
                                                                borderColor: 'rgba(54, 162, 235, 1)',
                                                                borderWidth: 1
                                                            }, {
                                                                label: 'Accommodations',
                                                                data: [${northAccommodations}, ${centralAccommodations}, ${southAccommodations}],
                                                                backgroundColor: 'rgba(255, 99, 132, 0.8)',
                                                                borderColor: 'rgba(255, 99, 132, 1)',
                                                                borderWidth: 1
                                                            }, {
                                                                label: 'Users',
                                                                data: [${northUsers}, ${centralUsers}, ${southUsers}],
                                                                backgroundColor: 'rgba(75, 192, 192, 0.8)',
                                                                borderColor: 'rgba(75, 192, 192, 1)',
                                                                borderWidth: 1
                                                            }]
                                                    },
                                                    options: {
                                                        responsive: true,
                                                        maintainAspectRatio: false,
                                                        scales: {
                                                            y: {
                                                                beginAtZero: true,
                                                                ticks: {
                                                                    callback: function (value) {
                                                                        return value.toLocaleString();
                                                                    }
                                                                }
                                                            }
                                                        },
                                                        plugins: {
                                                            legend: {
                                                                position: 'top',
                                                            },
                                                            tooltip: {
                                                                callbacks: {
                                                                    label: function (context) {
                                                                        return context.dataset.label + ': ' + context.parsed.y.toLocaleString();
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                });

                                                // Chart type change function
                                                function changeChartType(type) {
                                                    userGrowthChart.config.type = type;
                                                    if (type === 'area') {
                                                        userGrowthChart.config.type = 'line';
                                                        userGrowthChart.data.datasets.forEach(dataset => {
                                                            dataset.fill = true;
                                                        });
                                                    } else {
                                                        userGrowthChart.data.datasets.forEach(dataset => {
                                                            dataset.fill = false;
                                                        });
                                                    }
                                                    userGrowthChart.update();
                                                }

                                                // Export report function
                                                function exportReport() {
                                                    const period = new URLSearchParams(window.location.search).get('period') || 'month';
                                                    window.open(`/admin/statistics/export?period=${period}&format=pdf`, '_blank');
                                                }

                                                // Auto refresh every 5 minutes
                                                setInterval(function () {
                                                    // Update system health and recent activities
                                                    fetch('/admin/statistics/refresh')
                                                            .then(response => response.json())
                                                            .then(data => {
                                                                if (data.success) {
                                                                    // Update system health indicators
                                                                    updateSystemHealth(data.systemHealth);

                                                                    // Update recent activities if needed
                                                                    if (data.newActivities > 0) {
                                                                        location.reload();
                                                                    }
                                                                }
                                                            })
                                                            .catch(error => console.log('Auto refresh failed:', error));
                                                }, 300000); // 5 minutes

                                                function updateSystemHealth(health) {
                                                    // Update server status
                                                    document.querySelector('.progress-bar.bg-success').style.width = health.serverUptime + '%';

                                                    // Update other health indicators
                                                    // This would be implemented based on actual API response structure
                                                }

                                                // Initialize tooltips
                                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                                });
        </script>
    </body>
</html>