<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.role ne 'LOCALHOST'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Localhost Dashboard - VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
        <style>
            .dashboard-container {
                padding: 2rem;
            }
            .feature-card {
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                transition: transform 0.2s, box-shadow 0.2s;
                background: white;
            }
            .feature-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            .feature-icon {
                width: 50px;
                height: 50px;
                background: #10466C;
                color: white;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                margin-bottom: 1rem;
            }
            .feature-title {
                color: #10466C;
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }
            .feature-description {
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }
            .feature-link {
                color: #10466C;
                text-decoration: none;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }
            .feature-link:hover {
                color: #0d3554;
            }
            .welcome-section {
                background: linear-gradient(135deg, #10466C, #1a6b9c);
                color: white;
                padding: 2rem;
                border-radius: 10px;
                margin-bottom: 2rem;
            }
            .stats-card {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            .stats-number {
                font-size: 2rem;
                font-weight: 700;
                color: #10466C;
            }
            .stats-label {
                color: #666;
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #10466C;">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                    <img src="${pageContext.request.contextPath}/view/assets/home/img/logo1.jpg" alt="VietCulture Logo" height="40">
                    <span class="ms-2">VIETCULTURE</span>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/">
                                <i class="ri-home-line me-1"></i>Trang Chủ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                <i class="ri-logout-box-line me-1"></i>Đăng Xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container dashboard-container">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h2>Chào mừng, ${sessionScope.user.fullName}!</h2>
                <p class="mb-0">Đây là trang quản lý dành cho tài khoản Localhost</p>
            </div>

            <!-- Stats Section -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="stats-number">${totalUsers}</div>
                        <div class="stats-label">Tổng số người dùng</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="stats-number">${totalExperiences}</div>
                        <div class="stats-label">Tổng số trải nghiệm</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="stats-number">${totalBookings}</div>
                        <div class="stats-label">Tổng số đặt chỗ</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <div class="stats-number">${totalRevenue}</div>
                        <div class="stats-label">Tổng doanh thu (VNĐ)</div>
                    </div>
                </div>
            </div>

            <!-- Features Grid -->
            <div class="row">
                <!-- Quản lý người dùng -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="ri-user-settings-line"></i>
                        </div>
                        <h3 class="feature-title">Quản lý người dùng</h3>
                        <p class="feature-description">Xem, thêm, sửa và xóa thông tin người dùng trong hệ thống</p>
                        <a href="${pageContext.request.contextPath}/localhost/users" class="feature-link">
                            Truy cập <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
                </div>

                <!-- Quản lý trải nghiệm -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="ri-compass-3-line"></i>
                        </div>
                        <h3 class="feature-title">Quản lý trải nghiệm</h3>
                        <p class="feature-description">Duyệt và quản lý các trải nghiệm được tạo bởi host</p>
                        <a href="${pageContext.request.contextPath}/localhost/experiences" class="feature-link">
                            Truy cập <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
                </div>

                <!-- Quản lý đặt chỗ -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="ri-calendar-check-line"></i>
                        </div>
                        <h3 class="feature-title">Quản lý đặt chỗ</h3>
                        <p class="feature-description">Theo dõi và quản lý các đơn đặt chỗ của khách hàng</p>
                        <a href="${pageContext.request.contextPath}/localhost/bookings" class="feature-link">
                            Truy cập <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
                </div>

                <!-- Báo cáo thống kê -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="ri-bar-chart-line"></i>
                        </div>
                        <h3 class="feature-title">Báo cáo thống kê</h3>
                        <p class="feature-description">Xem các báo cáo về doanh thu, lượt đặt chỗ và hoạt động</p>
                        <a href="${pageContext.request.contextPath}/localhost/reports" class="feature-link">
                            Truy cập <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
                </div>

                <!-- Quản lý nội dung -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="ri-file-list-3-line"></i>
                        </div>
                        <h3 class="feature-title">Quản lý nội dung</h3>
                        <p class="feature-description">Quản lý các bài viết, tin tức và nội dung trang web</p>
                        <a href="${pageContext.request.contextPath}/localhost/content" class="feature-link">
                            Truy cập <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
                </div>

                <!-- Cài đặt hệ thống -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="ri-settings-4-line"></i>
                        </div>
                        <h3 class="feature-title">Cài đặt hệ thống</h3>
                        <p class="feature-description">Cấu hình các thông số và tùy chọn của hệ thống</p>
                        <a href="${pageContext.request.contextPath}/localhost/settings" class="feature-link">
                            Truy cập <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Localhost Dashboard - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        .dashboard-container {
            padding: 2rem;
        }
        .feature-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: transform 0.2s, box-shadow 0.2s;
            background: white;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .feature-icon {
            width: 50px;
            height: 50px;
            background: #10466C;
            color: white;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .feature-title {
            color: #10466C;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .feature-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        .feature-link {
            color: #10466C;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .feature-link:hover {
            color: #0d3554;
        }
        .welcome-section {
            background: linear-gradient(135deg, #10466C, #1a6b9c);
            color: white;
            padding: 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: #10466C;
        }
        .stats-label {
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #10466C;">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/view/assets/home/img/logo1.jpg" alt="VietCulture Logo" height="40">
                <span class="ms-2">VIETCULTURE</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="ri-home-line me-1"></i>Trang Chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="ri-logout-box-line me-1"></i>Đăng Xuất
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h2>Chào mừng, ${sessionScope.user.fullName}!</h2>
            <p class="mb-0">Đây là trang quản lý dành cho tài khoản Localhost</p>
        </div>

        <!-- Stats Section -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${totalUsers}</div>
                    <div class="stats-label">Tổng số người dùng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${totalExperiences}</div>
                    <div class="stats-label">Tổng số trải nghiệm</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${totalBookings}</div>
                    <div class="stats-label">Tổng số đặt chỗ</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${totalRevenue}</div>
                    <div class="stats-label">Tổng doanh thu (VNĐ)</div>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                </div>
            </div>
        </div>

<<<<<<< HEAD
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
=======
        <!-- Features Grid -->
        <div class="row">
            <!-- Quản lý người dùng -->
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="ri-user-settings-line"></i>
                    </div>
                    <h3 class="feature-title">Quản lý người dùng</h3>
                    <p class="feature-description">Xem, thêm, sửa và xóa thông tin người dùng trong hệ thống</p>
                    <a href="${pageContext.request.contextPath}/localhost/users" class="feature-link">
                        Truy cập <i class="ri-arrow-right-line"></i>
                    </a>
                </div>
            </div>

            <!-- Quản lý trải nghiệm -->
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="ri-compass-3-line"></i>
                    </div>
                    <h3 class="feature-title">Quản lý trải nghiệm</h3>
                    <p class="feature-description">Duyệt và quản lý các trải nghiệm được tạo bởi host</p>
                    <a href="${pageContext.request.contextPath}/localhost/experiences" class="feature-link">
                        Truy cập <i class="ri-arrow-right-line"></i>
                    </a>
                </div>
            </div>

            <!-- Quản lý đặt chỗ -->
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="ri-calendar-check-line"></i>
                    </div>
                    <h3 class="feature-title">Quản lý đặt chỗ</h3>
                    <p class="feature-description">Theo dõi và quản lý các đơn đặt chỗ của khách hàng</p>
                    <a href="${pageContext.request.contextPath}/localhost/bookings" class="feature-link">
                        Truy cập <i class="ri-arrow-right-line"></i>
                    </a>
                </div>
            </div>

            <!-- Báo cáo thống kê -->
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="ri-bar-chart-line"></i>
                    </div>
                    <h3 class="feature-title">Báo cáo thống kê</h3>
                    <p class="feature-description">Xem các báo cáo về doanh thu, lượt đặt chỗ và hoạt động</p>
                    <a href="${pageContext.request.contextPath}/localhost/reports" class="feature-link">
                        Truy cập <i class="ri-arrow-right-line"></i>
                    </a>
                </div>
            </div>

            <!-- Quản lý nội dung -->
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="ri-file-list-3-line"></i>
                    </div>
                    <h3 class="feature-title">Quản lý nội dung</h3>
                    <p class="feature-description">Quản lý các bài viết, tin tức và nội dung trang web</p>
                    <a href="${pageContext.request.contextPath}/localhost/content" class="feature-link">
                        Truy cập <i class="ri-arrow-right-line"></i>
                    </a>
                </div>
            </div>

            <!-- Cài đặt hệ thống -->
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="ri-settings-4-line"></i>
                    </div>
                    <h3 class="feature-title">Cài đặt hệ thống</h3>
                    <p class="feature-description">Cấu hình các thông số và tùy chọn của hệ thống</p>
                    <a href="${pageContext.request.contextPath}/localhost/settings" class="feature-link">
                        Truy cập <i class="ri-arrow-right-line"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
</html> 