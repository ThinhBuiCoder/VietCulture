<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Dịch Vụ - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #FF385C;
            --secondary-color: #83C5BE;
            --accent-color: #F8F9FA;
            --dark-color: #2F4858;
            --light-color: #FFFFFF;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --gradient-primary: linear-gradient(135deg, #FF385C, #FF6B6B);
            --gradient-secondary: linear-gradient(135deg, #83C5BE, #006D77);
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 5px 15px rgba(0,0,0,0.08);
            --border-radius: 16px;
            --transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--accent-color);
            padding-top: 100px;
            padding-bottom: 50px;
        }

        /* Navbar */
        .custom-navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background-color: #10466C;
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
            height: 50px;
            width: auto;
            margin-right: 12px;
        }

        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            background: var(--light-color);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        /* Header */
        .page-header {
            background: #10466C;
            padding: 40px;
            color: white;
            text-align: center;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        /* Statistics Cards */
        .stats-container {
            padding: 30px 40px;
            background: var(--light-color);
        }

        .stat-card {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: var(--transition);
            border: none;
            box-shadow: var(--shadow-sm);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .stat-card .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #10466C;
            margin-bottom: 5px;
        }

        .stat-card .stat-label {
            color: var(--dark-color);
            font-weight: 500;
        }

        /* Filters */
        .filters-container {
            padding: 30px 40px;
            border-bottom: 1px solid #e9ecef;
            background: #f8f9fa;
        }

        .filter-group {
            margin-bottom: 20px;
        }

        .filter-group label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 8px;
        }

        .form-select, .form-control {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: var(--transition);
        }

        .form-select:focus, .form-control:focus {
            border-color: #10466C;
            box-shadow: 0 0 0 0.2rem rgba(16, 70, 108, 0.1);
        }

        /* Services Container */
        .services-container {
            padding: 40px;
        }

        .service-card {
            background: var(--light-color);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            overflow: hidden;
            margin-bottom: 20px;
            border: 1px solid #e9ecef;
        }

        .service-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .service-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
        }

        .service-content {
            flex: 1;
            padding: 20px;
        }

        .service-title {
            font-weight: 700;
            font-size: 1.25rem;
            color: var(--dark-color);
            margin-bottom: 8px;
        }

        .service-description {
            color: #6c757d;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .service-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            font-size: 0.875rem;
            color: #6c757d;
        }

        .meta-item i {
            margin-right: 5px;
            color: #10466C;
        }

        .service-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #10466C;
            margin-bottom: 15px;
        }

        .service-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .status-active {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }

        .status-inactive {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }

        .status-pending {
            background-color: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 500;
            border: none;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-edit {
            background-color: #10466C;
            color: white;
        }

        .btn-edit:hover {
            background-color: #0d3a5a;
            color: white;
        }

        .btn-hide {
            background-color: #6c757d;
            color: white;
        }

        .btn-hide:hover {
            background-color: #5a6268;
            color: white;
        }

        .btn-show {
            background-color: var(--success-color);
            color: white;
        }

        .btn-show:hover {
            background-color: #218838;
            color: white;
        }

        .btn-delete {
            background-color: var(--danger-color);
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }

        .empty-state h3 {
            margin-bottom: 10px;
            color: var(--dark-color);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-container {
                margin: 0 15px;
            }
            
            .page-header, .stats-container, .filters-container, .services-container {
                padding: 20px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .service-card .d-flex {
                flex-direction: column;
            }
            
            .service-image {
                width: 100%;
                height: 200px;
                margin-bottom: 15px;
            }
            
            .action-buttons {
                justify-content: center;
            }
        }

        /* Alerts */
        .alert {
            border-radius: 12px;
            border: none;
            margin-bottom: 20px;
        }

        .btn-create {
            background: #10466C;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition);
        }

        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 70, 108, 0.3);
            background-color: #0d3a5a;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="custom-navbar">
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="VietCulture Logo">
                <span>VIETCULTURE</span>
            </a>
        </div>
    </nav>

    <div class="container">
        <!-- Messages -->
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <i class="ri-error-warning-line me-2"></i>
                ${sessionScope.error}
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="ri-check-circle-line me-2"></i>
                ${sessionScope.success}
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <!-- Main Container -->
        <div class="main-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>Quản Lý Dịch Vụ</h1>
                <p>Quản lý tất cả trải nghiệm và chỗ lưu trú của bạn</p>
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/Travel/create_experience" class="btn-create">
                        <i class="ri-add-line"></i> Tạo Trải Nghiệm
                    </a>
                    <a href="${pageContext.request.contextPath}/Travel/create_accommodation" class="btn-create ms-2">
                        <i class="ri-add-line"></i> Tạo Lưu Trú
                    </a>
                </div>
            </div>

            <!-- Statistics -->
            <div class="stats-container">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-number">${totalExperiences}</div>
                            <div class="stat-label">Tổng Trải Nghiệm</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-number">${activeExperiences}</div>
                            <div class="stat-label">Trải Nghiệm Đang Hiện</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-number">${totalAccommodations}</div>
                            <div class="stat-label">Tổng Lưu Trú</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-number">${activeAccommodations}</div>
                            <div class="stat-label">Lưu Trú Đang Hiện</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="filters-container">
                <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/host/services/manage">
                    <div class="row">
                        <div class="col-md-3 filter-group">
                            <label for="type">Loại Dịch Vụ</label>
                            <select class="form-select" id="type" name="type" onchange="submitFilters()">
                                <option value="all" ${selectedType == 'all' ? 'selected' : ''}>Tất Cả</option>
                                <option value="experience" ${selectedType == 'experience' ? 'selected' : ''}>Trải Nghiệm</option>
                                <option value="accommodation" ${selectedType == 'accommodation' ? 'selected' : ''}>Lưu Trú</option>
                            </select>
                        </div>
                        <div class="col-md-3 filter-group">
                            <label for="status">Trạng Thái</label>
                            <select class="form-select" id="status" name="status" onchange="submitFilters()">
                                <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>Tất Cả</option>
                                <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Đang Hiện</option>
                                <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Đang Ẩn</option>
                            </select>
                        </div>
                        <div class="col-md-3 filter-group">
                            <label for="sort">Sắp Xếp</label>
                            <select class="form-select" id="sort" name="sort" onchange="submitFilters()">
                                <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Mới Nhất</option>
                                <option value="oldest" ${selectedSort == 'oldest' ? 'selected' : ''}>Cũ Nhất</option>
                                <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Giá Thấp → Cao</option>
                                <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Giá Cao → Thấp</option>
                            </select>
                        </div>
                        <div class="col-md-3 filter-group">
                            <label>&nbsp;</label>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">
                                    <i class="ri-refresh-line"></i> Reset
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Services List -->
            <div class="services-container">
                <!-- Experience Services -->
                <c:if test="${(selectedType == 'all' || selectedType == 'experience') && not empty experiences}">
                    <h4 class="mb-4">
                        <i class="ri-compass-3-line me-2" style="color: #10466C;"></i>
                        Trải Nghiệm (${fn:length(experiences)})
                    </h4>
                    
                    <c:forEach var="experience" items="${experiences}">
                        <div class="service-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0">
                                    <c:choose>
                                        <c:when test="${not empty experience.images}">
                                            <c:set var="firstImage" value="${fn:split(experience.images, ',')[0]}" />
                                            <img src="${pageContext.request.contextPath}/${firstImage}" 
                                                 alt="${experience.title}" class="service-image">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="service-image d-flex align-items-center justify-content-center bg-light">
                                                <i class="ri-image-line text-muted" style="font-size: 2rem;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="service-content">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="service-title">${experience.title}</h5>
                                        <span class="service-status ${experience.active ? 'status-active' : 'status-inactive'}">
                                            <c:choose>
                                                <c:when test="${experience.active}">
                                                    <i class="ri-eye-line"></i> Đang Hiện
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="ri-eye-off-line"></i> Đang Ẩn
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <p class="service-description">${experience.description}</p>
                                    
                                    <div class="service-meta">
                                        <div class="meta-item">
                                            <i class="ri-map-pin-line"></i>
                                            ${experience.cityName}
                                        </div>
                                        <div class="meta-item">
                                            <i class="ri-time-line"></i>
                                            <fmt:formatNumber value="${experience.duration.hours}" pattern="#"/>h
                                            <fmt:formatNumber value="${experience.duration.minutes}" pattern="00"/>m
                                        </div>
                                        <div class="meta-item">
                                            <i class="ri-group-line"></i>
                                            Tối đa ${experience.maxGroupSize} người
                                        </div>
                                        <div class="meta-item">
                                            <i class="ri-calendar-line"></i>
                                            <fmt:formatDate value="${experience.createdAt}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between align-items-end">
                                        <div class="service-price">
                                            <fmt:formatNumber value="${experience.price}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true" />
                                            <small class="text-muted">/người</small>
                                        </div>
                                        
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/host/services/edit/experience/${experience.experienceId}" 
                                               class="btn-action btn-edit">
                                                <i class="ri-edit-line"></i> Sửa
                                            </a>
                                            
                                            <!-- ✅ SỬA LẠI TOGGLE FORM CHO EXPERIENCE - SIMPLE VERSION -->
<form method="POST" action="${pageContext.request.contextPath}/host/toggle-service" style="display: inline;">
    <input type="hidden" name="serviceType" value="experience">
    <input type="hidden" name="serviceId" value="${experience.experienceId}">
    <c:choose>
        <c:when test="${experience.active}">
            <button type="submit" class="btn-action btn-hide"
                    onclick="return confirm('Bạn có chắc muốn ẩn dịch vụ này khỏi danh sách công khai?')">
                <i class="ri-eye-off-line"></i> Ẩn
            </button>
        </c:when>
        <c:otherwise>
            <button type="submit" class="btn-action btn-show"
                    onclick="return confirm('Bạn có chắc muốn hiển thị dịch vụ này trong danh sách công khai?')">
                <i class="ri-eye-line"></i> Hiện
            </button>
        </c:otherwise>
    </c:choose>
</form>
                                            
                                            <form method="POST" style="display: inline;" 
                                                  action="${pageContext.request.contextPath}/host/services/delete/experience/${experience.experienceId}">
                                                <button type="submit" class="btn-action btn-delete"
                                                        onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này? Hành động này không thể hoàn tác!')">
                                                    <i class="ri-delete-bin-line"></i> Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>

                <!-- Accommodation Services -->
                <c:if test="${(selectedType == 'all' || selectedType == 'accommodation') && not empty accommodations}">
                    <h4 class="mb-4 ${not empty experiences ? 'mt-5' : ''}">
                        <i class="ri-home-2-line me-2" style="color: #10466C;"></i>
                        Lưu Trú (${fn:length(accommodations)})
                    </h4>
                    
                    <c:forEach var="accommodation" items="${accommodations}">
                        <div class="service-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0">
                                    <c:choose>
                                        <c:when test="${not empty accommodation.images}">
                                            <c:set var="firstImage" value="${fn:split(accommodation.images, ',')[0]}" />
                                            <img src="${pageContext.request.contextPath}/${firstImage}" 
                                                 alt="${accommodation.name}" class="service-image">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="service-image d-flex align-items-center justify-content-center bg-light">
                                                <i class="ri-image-line text-muted" style="font-size: 2rem;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="service-content">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="service-title">${accommodation.name}</h5>
                                        <span class="service-status ${accommodation.active ? 'status-active' : 'status-inactive'}">
                                            <c:choose>
                                                <c:when test="${accommodation.active}">
                                                    <i class="ri-eye-line"></i> Đang Hiện
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="ri-eye-off-line"></i> Đang Ẩn
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    
                                    <p class="service-description">${accommodation.description}</p>
                                    
                                    <div class="service-meta">
                                        <div class="meta-item">
                                            <i class="ri-map-pin-line"></i>
                                            ${accommodation.cityName}
                                        </div>
                                        <div class="meta-item">
                                            <i class="ri-hotel-bed-line"></i>
                                            ${accommodation.numberOfRooms} phòng
                                        </div>
                                        <div class="meta-item">
                                            <i class="ri-building-line"></i>
                                            ${accommodation.type}
                                        </div>
                                        <div class="meta-item">
                                            <i class="ri-calendar-line"></i>
                                            <fmt:formatDate value="${accommodation.createdAt}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between align-items-end">
                                        <div class="service-price">
                                            <fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true" />
                                            <small class="text-muted">/đêm</small>
                                        </div>
                                        
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/host/services/edit/accommodation/${accommodation.accommodationId}" 
                                               class="btn-action btn-edit">
                                                <i class="ri-edit-line"></i> Sửa
                                            </a>
                                            
                                            <!-- ✅ SỬA LẠI TOGGLE FORM CHO ACCOMMODATION -->
                                           <form method="POST" action="${pageContext.request.contextPath}/host/toggle-service" style="display: inline;">
    <input type="hidden" name="serviceType" value="accommodation">
    <input type="hidden" name="serviceId" value="${accommodation.accommodationId}">
    <c:choose>
        <c:when test="${accommodation.active}">
            <button type="submit" class="btn-action btn-hide"
                    onclick="return confirm('Bạn có chắc muốn ẩn dịch vụ này khỏi danh sách công khai?')">
                <i class="ri-eye-off-line"></i> Ẩn
            </button>
        </c:when>
        <c:otherwise>
            <button type="submit" class="btn-action btn-show"
                    onclick="return confirm('Bạn có chắc muốn hiển thị dịch vụ này trong danh sách công khai?')">
                <i class="ri-eye-line"></i> Hiện
            </button>
        </c:otherwise>
    </c:choose>
</form>
                                            
                                            <form method="POST" style="display: inline;" 
                                                  action="${pageContext.request.contextPath}/host/services/delete/accommodation/${accommodation.accommodationId}">
                                                <button type="submit" class="btn-action btn-delete"
                                                        onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này? Hành động này không thể hoàn tác!')">
                                                    <i class="ri-delete-bin-line"></i> Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>

                <!-- Empty State -->
                <c:if test="${empty experiences && empty accommodations}">
                    <div class="empty-state">
                        <i class="ri-inbox-line"></i>
                        <h3>Chưa Có Dịch Vụ Nào</h3>
                        <p>Bạn chưa tạo dịch vụ nào. Hãy bắt đầu bằng cách tạo trải nghiệm hoặc chỗ lưu trú đầu tiên!</p>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/Travel/create_experience" class="btn-create me-2">
                                <i class="ri-add-line"></i> Tạo Trải Nghiệm
                            </a>
                            <a href="${pageContext.request.contextPath}/Travel/create_accommodation" class="btn-create">
                                <i class="ri-add-line"></i> Tạo Lưu Trú
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function submitFilters() {
            document.getElementById('filterForm').submit();
        }
        
        function resetFilters() {
            document.getElementById('type').value = 'all';
            document.getElementById('status').value = 'all';
            document.getElementById('sort').value = 'newest';
            submitFilters();
        }
        
        // Auto submit on filter change
        document.addEventListener('DOMContentLoaded', function() {
            const filterSelects = document.querySelectorAll('#filterForm select');
            filterSelects.forEach(select => {
                select.addEventListener('change', submitFilters);
            });
        });

        // ✅ DEBUG FUNCTION CHO TOGGLE BUTTONS
        function debugToggleAction(form, serviceId, isActive) {
            console.log('=== DEBUG TOGGLE ACTION ===');
            console.log('Service ID:', serviceId);
            console.log('Current Active Status:', isActive);
            console.log('Form Action:', form.action);
            console.log('Form Method:', form.method);
            
            // Kiểm tra URL được tạo
            const contextPath = '${pageContext.request.contextPath}';
            const serviceType = form.action.includes('/experience/') ? 'experience' : 'accommodation';
            const expectedUrl = `${window.location.origin}${contextPath}/host/services/toggle/${serviceType}/${serviceId}`;
            console.log('Expected URL:', expectedUrl);
            console.log('Actual Form Action:', form.action);
            console.log('URLs Match:', form.action === expectedUrl);
            
            // Log thêm thông tin
            console.log('Context Path:', contextPath);
            console.log('Service Type:', serviceType);
            console.log('Current URL:', window.location.href);
            
            return true; // Allow form submission
        }

        // Attach debug to all toggle forms khi page load
        document.addEventListener('DOMContentLoaded', function() {
            const toggleForms = document.querySelectorAll('form[action*="/toggle/"]');
            console.log('Found toggle forms:', toggleForms.length);
            
            toggleForms.forEach((form, index) => {
                console.log(`Form ${index}:`, form.action);
                
                const button = form.querySelector('button[type="submit"]');
                if (button) {
                    button.addEventListener('click', function(e) {
                        // Extract service ID from action URL
                        const urlParts = form.action.split('/');
                        const serviceId = urlParts[urlParts.length - 1];
                        const isActive = button.classList.contains('btn-hide');
                        
                        console.log('Button clicked:', {
                            serviceId: serviceId,
                            isActive: isActive,
                            buttonClass: button.className,
                            formAction: form.action
                        });
                    });
                }
            });

            // Log page info
            console.log('=== PAGE INFO ===');
            console.log('Current URL:', window.location.href);
            console.log('Context Path:', '${pageContext.request.contextPath}');
            console.log('Total experiences:', '${fn:length(experiences)}');
            console.log('Total accommodations:', '${fn:length(accommodations)}');
        });
    </script>
</body>
</html>