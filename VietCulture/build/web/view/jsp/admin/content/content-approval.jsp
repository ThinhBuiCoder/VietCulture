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
    <title>Duyệt Nội Dung - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/lightbox2@2.11.3/dist/css/lightbox.min.css" rel="stylesheet">
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
        .content-card {
            transition: transform 0.2s;
            border: none;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .content-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .content-image {
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }
        /* FIXED: Trạng thái pending (isActive = 0) */
        .status-pending {
            background-color: #fff3cd;
            border-color: #ffeaa7;
        }
        /* FIXED: Trạng thái approved (isActive = 1) */
        .status-approved {
            background-color: #d1edff;
            border-color: #bee5eb;
        }
        .host-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 12px;
        }
        .approval-actions {
            background-color: white;
            border-top: 1px solid #dee2e6;
            padding: 15px;
            border-radius: 0 0 8px 8px;
        }
        .stats-card {
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
        .filter-buttons .btn {
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
        .content-type-badge {
            position: absolute;
            top: 8px;
            left: 8px;
            z-index: 10;
        }
        .experience-badge {
            background: linear-gradient(45deg, #ff6b6b, #ee5a52);
        }
        .accommodation-badge {
            background: linear-gradient(45deg, #4ecdc4, #45b7af);
        }
        .difficulty-easy { color: #28a745; }
        .difficulty-moderate { color: #ffc107; }
        .difficulty-challenging { color: #dc3545; }
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
                    <h1 class="h2"><i class="fas fa-check-circle me-2"></i>Duyệt Nội Dung</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-success" onclick="approveAll()">
                                <i class="fas fa-check-double me-1"></i>Duyệt tất cả
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-info" onclick="exportPending()">
                                <i class="fas fa-download me-1"></i>Xuất CSV
                            </button>
                        </div>
                        
                        <!-- Filter Dropdowns -->
                        <div class="dropdown me-2">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-filter me-1"></i>Trạng thái
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item ${currentFilter eq 'pending' ? 'active' : ''}" href="?filter=pending&contentType=${currentContentType}">Chờ duyệt</a></li>
                                <li><a class="dropdown-item ${currentFilter eq 'approved' ? 'active' : ''}" href="?filter=approved&contentType=${currentContentType}">Đã duyệt</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item ${currentFilter eq 'all' ? 'active' : ''}" href="?filter=all&contentType=${currentContentType}">Tất cả</a></li>
                            </ul>
                        </div>
                        
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-layer-group me-1"></i>Loại nội dung
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item ${currentContentType eq 'all' ? 'active' : ''}" href="?filter=${currentFilter}&contentType=all">Tất cả</a></li>
                                <li><a class="dropdown-item ${currentContentType eq 'experience' ? 'active' : ''}" href="?filter=${currentFilter}&contentType=experience">Experiences</a></li>
                                <li><a class="dropdown-item ${currentContentType eq 'accommodation' ? 'active' : ''}" href="?filter=${currentFilter}&contentType=accommodation">Accommodations</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Filter Buttons (Mobile-friendly version) -->
                <div class="filter-buttons d-md-none mb-3">
                    <a href="?" class="btn btn-sm ${empty currentFilter or currentFilter eq 'pending' ? 'btn-primary' : 'btn-outline-primary'}">Chờ duyệt</a>
                    <a href="?filter=approved" class="btn btn-sm ${currentFilter eq 'approved' ? 'btn-success' : 'btn-outline-success'}">Đã duyệt</a>
                    <a href="?filter=all" class="btn btn-sm ${currentFilter eq 'all' ? 'btn-info' : 'btn-outline-info'}">Tất cả</a>
                    <br>
                    <a href="?contentType=all" class="btn btn-sm ${currentContentType eq 'all' ? 'btn-secondary' : 'btn-outline-secondary'}">Tất cả nội dung</a>
                    <a href="?contentType=experience" class="btn btn-sm ${currentContentType eq 'experience' ? 'btn-danger' : 'btn-outline-danger'}">Experiences</a>
                    <a href="?contentType=accommodation" class="btn btn-sm ${currentContentType eq 'accommodation' ? 'btn-info' : 'btn-outline-info'}">Accommodations</a>
                </div>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-warning mb-2">
                                    <i class="fas fa-clock fa-2x"></i>
                                </div>
                                <h5 class="card-title text-warning">${stats.totalPending}</h5>
                                <p class="card-text mb-0 small">Chờ duyệt</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-success mb-2">
                                    <i class="fas fa-check-circle fa-2x"></i>
                                </div>
                                <h5 class="card-title text-success">${stats.totalApproved}</h5>
                                <p class="card-text mb-0 small">Đã duyệt</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-danger mb-2">
                                    <i class="fas fa-map-marked-alt fa-2x"></i>
                                </div>
                                <h5 class="card-title text-danger">${stats.experiencePending}</h5>
                                <p class="card-text mb-0 small">Exp chờ</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-info mb-2">
                                    <i class="fas fa-home fa-2x"></i>
                                </div>
                                <h5 class="card-title text-info">${stats.accommodationPending}</h5>
                                <p class="card-text mb-0 small">Acc chờ</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-primary mb-2">
                                    <i class="fas fa-chart-line fa-2x"></i>
                                </div>
                                <h5 class="card-title text-primary">${stats.experienceTotal}</h5>
                                <p class="card-text mb-0 small">Tổng Exp</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-secondary mb-2">
                                    <i class="fas fa-building fa-2x"></i>
                                </div>
                                <h5 class="card-title text-secondary">${stats.accommodationTotal}</h5>
                                <p class="card-text mb-0 small">Tổng Acc</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Content List -->
                <div class="row">
                    <c:if test="${not empty contentItems}">
                        <c:forEach var="item" items="${contentItems}">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <!-- FIXED: Áp dụng class theo trạng thái isActive -->
                                <div class="card content-card h-100 
                                    ${not item.active ? 'status-pending' : 'status-approved'}">
                                    
                                    <!-- Content Image -->
                                    <div class="position-relative">
                                        <c:choose>
                                            <c:when test="${not empty item.images}">
                                                <c:set var="imageArray" value="${fn:split(item.images, ',')}" />
                                                <c:set var="firstImage" value="${fn:trim(imageArray[0])}" />
                                                <img loading="lazy" 
                                                     src="${pageContext.request.contextPath}/assets/images/${item.type}s/${firstImage}" 
                                                     class="card-img-top content-image" 
                                                     alt="${fn:escapeXml(item.title)}"
                                                     data-lightbox="content-${item.id}"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                <div class="card-img-top content-image bg-light d-flex align-items-center justify-content-center" style="display: none;">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="card-img-top content-image bg-light d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- Content Type Badge -->
                                        <div class="content-type-badge">
                                            <c:choose>
                                                <c:when test="${item.type eq 'experience'}">
                                                    <span class="badge experience-badge text-white">
                                                        <i class="fas fa-map-marked-alt me-1"></i>Experience
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge accommodation-badge text-white">
                                                        <i class="fas fa-home me-1"></i>Accommodation
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <!-- FIXED: Status Badge theo isActive -->
                                        <div class="position-absolute top-0 end-0 m-2">
                                            <c:choose>
                                                <c:when test="${item.active}">
                                                    <span class="badge bg-success">Đã duyệt</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning">Chờ duyệt</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <!-- Title -->
                                        <h5 class="card-title">${fn:escapeXml(item.title)}</h5>
                                        
                                        <!-- Location -->
                                        <p class="text-muted mb-2">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            ${fn:escapeXml(item.location)}
                                            <c:if test="${not empty item.cityName}">
                                                , ${fn:escapeXml(item.cityName)}
                                            </c:if>
                                        </p>
                                        
                                        <!-- Description -->
                                        <p class="card-text">
                                            <c:choose>
                                                <c:when test="${fn:length(item.description) > 100}">
                                                    ${fn:escapeXml(fn:substring(item.description, 0, 100))}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${fn:escapeXml(item.description)}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        
                                        <!-- Content Details -->
                                        <div class="row text-sm mb-3">
                                            <div class="col-6">
                                                <small class="text-muted">
                                                    <i class="fas fa-dollar-sign me-1"></i>
                                                    <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="$"/>
                                                    <c:if test="${item.type eq 'accommodation'}"> /đêm</c:if>
                                                </small>
                                            </div>
                                            
                                            <!-- Experience specific details -->
                                            <c:if test="${item.type eq 'experience'}">
                                                <c:set var="exp" value="${item.experience}" />
                                                <div class="col-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-users me-1"></i>
                                                        Tối đa ${exp.maxGroupSize} người
                                                    </small>
                                                </div>
                                                <c:if test="${not empty exp.duration}">
                                                    <div class="col-6">
                                                        <small class="text-muted">
                                                            <i class="fas fa-clock me-1"></i>
                                                            <fmt:formatDate value="${exp.duration}" pattern="HH'h'mm"/>
                                                        </small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty exp.difficulty}">
                                                    <div class="col-6">
                                                        <small class="difficulty-${fn:toLowerCase(exp.difficulty)}">
                                                            <i class="fas fa-signal me-1"></i>
                                                            <c:choose>
                                                                <c:when test="${exp.difficulty eq 'EASY'}">Dễ</c:when>
                                                                <c:when test="${exp.difficulty eq 'MODERATE'}">Trung bình</c:when>
                                                                <c:when test="${exp.difficulty eq 'CHALLENGING'}">Khó</c:when>
                                                                <c:otherwise>${fn:escapeXml(exp.difficulty)}</c:otherwise>
                                                            </c:choose>
                                                        </small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty exp.type}">
                                                    <div class="col-12">
                                                        <small class="text-primary">
                                                            <i class="fas fa-tag me-1"></i>
                                                            ${fn:escapeXml(exp.type)}
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                            
                                            <!-- Accommodation specific details -->
                                            <c:if test="${item.type eq 'accommodation'}">
                                                <c:set var="acc" value="${item.accommodation}" />
                                                <div class="col-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-bed me-1"></i>
                                                        ${acc.numberOfRooms} phòng
                                                    </small>
                                                </div>
                                                <c:if test="${not empty acc.type}">
                                                    <div class="col-12">
                                                        <small class="text-info">
                                                            <i class="fas fa-building me-1"></i>
                                                            ${fn:escapeXml(acc.type)}
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                        </div>
                                        
                                        <!-- Host Info -->
                                        <div class="host-info mb-3">
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty item.hostName}">
                                                        <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center me-2" 
                                                             style="width: 40px; height: 40px;">
                                                            <span class="text-white fw-bold">
                                                                ${fn:escapeXml(fn:substring(item.hostName, 0, 1))}
                                                            </span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center me-2" 
                                                             style="width: 40px; height: 40px;">
                                                            <i class="fas fa-user text-white"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <strong>${fn:escapeXml(item.hostName != null ? item.hostName : 'N/A')}</strong>
                                                    <br>
                                                    <small class="text-muted">Host ID: ${item.hostId}</small>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Additional Experience Info -->
                                        <c:if test="${item.type eq 'experience'}">
                                            <c:set var="exp" value="${item.experience}" />
                                            <c:if test="${not empty exp.language}">
                                                <p class="mb-1">
                                                    <small>
                                                        <i class="fas fa-language me-1"></i>
                                                        <strong>Ngôn ngữ:</strong> ${fn:escapeXml(exp.language)}
                                                    </small>
                                                </p>
                                            </c:if>
                                            <c:if test="${not empty exp.includedItems}">
                                                <p class="mb-1">
                                                    <small>
                                                        <i class="fas fa-gift me-1"></i>
                                                        <strong>Bao gồm:</strong> 
                                                        <c:choose>
                                                            <c:when test="${fn:length(exp.includedItems) > 50}">
                                                                ${fn:escapeXml(fn:substring(exp.includedItems, 0, 50))}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:escapeXml(exp.includedItems)}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </p>
                                            </c:if>
                                        </c:if>
                                        
                                        <!-- Additional Accommodation Info -->
                                        <c:if test="${item.type eq 'accommodation'}">
                                            <c:set var="acc" value="${item.accommodation}" />
                                            <c:if test="${not empty acc.amenities}">
                                                <p class="mb-1">
                                                    <small>
                                                        <i class="fas fa-check-circle me-1"></i>
                                                        <strong>Tiện ích:</strong> 
                                                        <c:choose>
                                                            <c:when test="${fn:length(acc.amenities) > 50}">
                                                                ${fn:escapeXml(fn:substring(acc.amenities, 0, 50))}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:escapeXml(acc.amenities)}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </p>
                                            </c:if>
                                        </c:if>
                                        
                                        <!-- Created Date -->
                                        <p class="text-muted mb-0">
                                            <small>
                                                <i class="fas fa-calendar me-1"></i>
                                                Tạo ngày: <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </p>
                                    </div>
                                    
                                    <!-- FIXED: Actions theo trạng thái isActive -->
                                    <!-- Actions for Pending (isActive = false, chờ duyệt) -->
                                    <c:if test="${not item.active}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2 mb-2">
                                                <button type="button" 
                                                        class="btn btn-success btn-sm flex-fill" 
                                                        onclick="approveContent('${item.type}', ${item.id})">
                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                </button>
                                                <button type="button" 
                                                        class="btn btn-danger btn-sm flex-fill" 
                                                        onclick="rejectContent('${item.type}', ${item.id}, '${fn:escapeXml(item.title)}')">
                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                </button>
                                            </div>
                                            
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/content/${item.type}/${item.id}" 
                                                   class="btn btn-outline-primary btn-sm flex-fill">
                                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                                </a>
                                                <c:if test="${not empty item.images}">
                                                    <button type="button" 
                                                            class="btn btn-outline-info btn-sm flex-fill" 
                                                            onclick="showAllImages('${item.type}', ${item.id}, '${fn:escapeXml(item.images)}')">
                                                        <i class="fas fa-images me-1"></i>Hình ảnh
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Actions for Approved (isActive = true, đã duyệt) -->
                                    <c:if test="${item.active}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2">
                                                <button type="button" 
                                                        class="btn btn-warning btn-sm flex-fill" 
                                                        onclick="revokeApproval('${item.type}', ${item.id}, '${fn:escapeXml(item.title)}')">
                                                    <i class="fas fa-undo me-1"></i>Thu hồi duyệt
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/content/${item.type}/${item.id}" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                    
                    <!-- Empty State -->
                    <c:if test="${empty contentItems}">
                        <div class="col-12">
                            <div class="text-center py-5">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">Không có nội dung nào</h4>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${currentFilter eq 'pending'}">
                                            Không có nội dung nào đang chờ duyệt.
                                        </c:when>
                                        <c:when test="${currentFilter eq 'approved'}">
                                            Chưa có nội dung nào được duyệt.
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có nội dung nào trong hệ thống.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Content pagination" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&filter=${currentFilter}&contentType=${currentContentType}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&filter=${currentFilter}&contentType=${currentContentType}">
                                        ${pageNum}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&filter=${currentFilter}&contentType=${currentContentType}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </main>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Từ chối nội dung</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="rejectForm" method="POST">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn từ chối nội dung <strong id="rejectContentName"></strong>?</p>
                        <div class="mb-3">
                            <label class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="4" required placeholder="Nhập lý do từ chối..."></textarea>
                            <div class="form-text">Host sẽ nhận được thông báo về lý do từ chối</div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="allowResubmit" id="allowResubmit" checked>
                                <label class="form-check-label" for="allowResubmit">
                                    Cho phép host chỉnh sửa và gửi lại
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Từ chối</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Image Gallery Modal -->
    <div class="modal fade" id="imageGalleryModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hình ảnh nội dung</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="imageGallery" class="row g-2">
                        <!-- Images will be loaded here -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Revoke Approval Modal -->
    <div class="modal fade" id="revokeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thu hồi duyệt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="revokeForm" method="POST">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn thu hồi duyệt cho nội dung <strong id="revokeContentName"></strong>?</p>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Nội dung sẽ bị ẩn khỏi website và các booking hiện tại có thể bị ảnh hưởng.
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Lý do thu hồi <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="3" required placeholder="Nhập lý do thu hồi..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">Thu hồi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lightbox2@2.11.3/dist/js/lightbox.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dompurify/2.4.0/purify.min.js"></script>
    
    <script>
        // Wait for DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Configure lightbox
            if (typeof lightbox !== 'undefined') {
                lightbox.option({
                    'resizeDuration': 200,
                    'wrapAround': true,
                    'albumLabel': 'Hình %1 / %2'
                });
            } else {
                console.error('Lightbox is not loaded');
            }

            // Initialize tooltips
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            tooltipTriggerList.forEach(tooltipTriggerEl => {
                new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });

        // Global variables for modal management
        let currentContentType = '';
        let currentContentId = 0;

function approveContent(contentType, contentId) {
    if (confirm('Bạn có chắc chắn muốn duyệt nội dung này?')) {
        const loadingBtn = event.target;
        const originalContent = loadingBtn.innerHTML;
        loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
        loadingBtn.disabled = true;

        const url = '${pageContext.request.contextPath}/admin/content/' + contentType + '/' + contentId + '/approve';
        console.log('Sending request to:', url); // Debug log

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers.get('content-type'));
            
            // Kiểm tra status code trước
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                // Nếu không phải JSON, đọc text để debug
                return response.text().then(text => {
                    console.error('Expected JSON but received:', contentType, 'Content:', text);
                    throw new Error(`Expected JSON, but received: ${contentType || 'unknown'} - Content: ${text.substring(0, 100)}`);
                });
            }
            
            return response.json(); // Parse JSON nếu content-type đúng
        })
        .then(data => {
            console.log('Response data:', data); // Debug log
            
            if (typeof data !== 'object' || data.success === undefined) {
                throw new Error('Invalid response structure: ' + JSON.stringify(data));
            }
            
            if (data.success) {
                showToast('Nội dung đã được duyệt thành công!', 'success');
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể duyệt nội dung'), 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Có lỗi xảy ra: ' + error.message, 'error');
        })
        .finally(() => {
            loadingBtn.innerHTML = originalContent;
            loadingBtn.disabled = false;
        });
    }
}
        function rejectContent(contentType, contentId, contentName) {
            currentContentType = contentType;
            currentContentId = contentId;
            document.getElementById('rejectContentName').textContent = DOMPurify.sanitize(contentName);
            document.getElementById('rejectForm').action = '${pageContext.request.contextPath}/admin/content/' + contentType + '/' + contentId + '/reject';
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        function revokeApproval(contentType, contentId, contentName) {
            currentContentType = contentType;
            currentContentId = contentId;
            document.getElementById('revokeContentName').textContent = DOMPurify.sanitize(contentName);
            document.getElementById('revokeForm').action = '${pageContext.request.contextPath}/admin/content/' + contentType + '/' + contentId + '/revoke';
            new bootstrap.Modal(document.getElementById('revokeModal')).show();
        }

        function approveAll() {
            const contentType = '${currentContentType}' || 'all';
            let confirmMessage = 'Bạn có chắc chắn muốn duyệt TẤT CẢ nội dung đang chờ?';
            
            if (contentType === 'experience') {
                confirmMessage = 'Bạn có chắc chắn muốn duyệt TẤT CẢ experiences đang chờ?';
            } else if (contentType === 'accommodation') {
                confirmMessage = 'Bạn có chắc chắn muốn duyệt TẤT CẢ accommodations đang chờ?';
            }

            if (confirm(confirmMessage)) {
                const loadingBtn = event.target;
                const originalContent = loadingBtn.innerHTML;
                loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                loadingBtn.disabled = true;

                const url = '${pageContext.request.contextPath}/admin/content/approve-all' + 
                           (contentType !== 'all' ? '?contentType=' + contentType : '');

                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => {
                    console.log('Response status:', response.status, 'Headers:', response.headers.get('content-type'));
                    if (!response.ok) {
                        return response.text().then(text => {
                            throw new Error(`Network response was not ok: ${response.statusText} (${response.status}) - Response: ${text}`);
                        });
                    }
                    const contentTypeHeader = response.headers.get('content-type');
                    if (!contentTypeHeader || !contentTypeHeader.includes('application/json')) {
                        return response.text().then(text => {
                            throw new Error(`Expected JSON, but received: ${contentTypeHeader || 'none'} - Response: ${text}`);
                        });
                    }
                    return response.text();
                })
                .then(text => {
                    if (!text) {
                        throw new Error('Empty response received');
                    }
                    try {
                        return JSON.parse(text);
                    } catch (e) {
                        throw new Error('Invalid JSON format: ' + text);
                    }
                })
                .then(data => {
                    if (data.success === undefined) {
                        throw new Error('Invalid response structure');
                    }
                    if (data.success) {
                        const count = data.data?.count || 0;
                        const total = data.data?.total || 0;
                        showToast('Đã duyệt ' + count + '/' + total + ' nội dung thành công!', 'success');
                        setTimeout(() => location.reload(), 2000);
                    } else {
                        showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể duyệt tất cả'), 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Có lỗi xảy ra: ' + error.message, 'error');
                })
                .finally(() => {
                    loadingBtn.innerHTML = originalContent;
                    loadingBtn.disabled = false;
                });
            }
        }

        function exportPending() {
            const loadingBtn = event.target;
            const originalContent = loadingBtn.innerHTML;
            loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xuất...';
            loadingBtn.disabled = true;

            fetch('${pageContext.request.contextPath}/admin/content/export-pending', {
                method: 'GET'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Network response was not ok: ${response.statusText} (${response.status})`);
                }
                return response.blob();
            })
            .then(blob => {
                const link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);
                link.download = 'pending-content.csv';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                showToast('Tệp CSV đã được tải xuống!', 'success');
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra khi xuất CSV: ' + error.message, 'error');
            })
            .finally(() => {
                loadingBtn.innerHTML = originalContent;
                loadingBtn.disabled = false;
            });
        }

        function showAllImages(contentType, contentId, imagesString) {
            const gallery = document.getElementById('imageGallery');
            gallery.innerHTML = '';
            
            if (imagesString && imagesString.trim() !== '') {
                const images = imagesString.split(',').map(img => img.trim()).filter(img => img !== '');
                const fragment = document.createDocumentFragment();
                
                if (images.length > 0) {
                    images.forEach((image, index) => {
                        const col = document.createElement('div');
                        col.className = 'col-md-4 col-6 mb-2';
                        col.innerHTML = 
                            '<img loading="lazy" src="${pageContext.request.contextPath}/assets/images/' + contentType + 's/' + encodeURIComponent(image) + '" ' +
                            'class="img-fluid rounded shadow-sm" ' +
                            'style="height: 150px; width: 100%; object-fit: cover; cursor: pointer;" ' +
                            'data-lightbox="gallery-' + contentType + '-' + contentId + '" ' +
                            'data-title="Hình ' + (index + 1) + '" ' +
                            'onerror="this.parentElement.style.display=\'none\'">';
                        fragment.appendChild(col);
                    });
                    gallery.appendChild(fragment);
                } else {
                    gallery.innerHTML = '<div class="col-12 text-center"><p class="text-muted">Không có hình ảnh hợp lệ</p></div>';
                }
            } else {
                gallery.innerHTML = '<div class="col-12 text-center"><p class="text-muted">Không có hình ảnh</p></div>';
            }
            
            new bootstrap.Modal(document.getElementById('imageGalleryModal')).show();
        }

        function showToast(message, type) {
            type = type || 'info';
            const toastContainer = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            
            const bgClass = type === 'error' ? 'bg-danger' : 
                           type === 'success' ? 'bg-success' : 
                           type === 'warning' ? 'bg-warning' : 'bg-info';
            
            toast.className = 'toast align-items-center text-white ' + bgClass + ' border-0';
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');
            
            toast.innerHTML = 
                '<div class="d-flex">' +
                    '<div class="toast-body">' + DOMPurify.sanitize(message) + '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', function() {
                toast.remove();
            });
        }

        // Handle form submissions
        document.getElementById('rejectForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalContent = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            const formData = new FormData(this);
            
            fetch(this.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                console.log('Response status:', response.status, 'Headers:', response.headers.get('content-type'));
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(`Network response was not ok: ${response.statusText} (${response.status}) - Response: ${text}`);
                    });
                }
                const contentTypeHeader = response.headers.get('content-type');
                if (!contentTypeHeader || !contentTypeHeader.includes('application/json')) {
                    return response.text().then(text => {
                        throw new Error(`Expected JSON, but received: ${contentTypeHeader || 'none'} - Response: ${text}`);
                    });
                }
                return response.text();
            })
            .then(text => {
                if (!text) {
                    throw new Error('Empty response received');
                }
                try {
                    return JSON.parse(text);
                } catch (e) {
                    throw new Error('Invalid JSON format: ' + text);
                }
            })
            .then(data => {
                if (data.success === undefined) {
                    throw new Error('Invalid response structure');
                }
                if (data.success) {
                    showToast('Nội dung đã bị từ chối!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể từ chối nội dung'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra: ' + error.message, 'error');
            })
            .finally(() => {
                submitBtn.innerHTML = originalContent;
                submitBtn.disabled = false;
            });
        });

        document.getElementById('revokeForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalContent = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            const formData = new FormData(this);
            
            fetch(this.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                console.log('Response status:', response.status, 'Headers:', response.headers.get('content-type'));
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(`Network response was not ok: ${response.statusText} (${response.status}) - Response: ${text}`);
                    });
                }
                const contentTypeHeader = response.headers.get('content-type');
                if (!contentTypeHeader || !contentTypeHeader.includes('application/json')) {
                    return response.text().then(text => {
                        throw new Error(`Expected JSON, but received: ${contentTypeHeader || 'none'} - Response: ${text}`);
                    });
                }
                return response.text();
            })
            .then(text => {
                if (!text) {
                    throw new Error('Empty response received');
                }
                try {
                    return JSON.parse(text);
                } catch (e) {
                    throw new Error('Invalid JSON format: ' + text);
                }
            })
            .then(data => {
                if (data.success === undefined) {
                    throw new Error('Invalid response structure');
                }
                if (data.success) {
                    showToast('Đã thu hồi duyệt nội dung!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('revokeModal')).hide();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể thu hồi duyệt'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra: ' + error.message, 'error');
            })
            .finally(() => {
                submitBtn.innerHTML = originalContent;
                submitBtn.disabled = false;
            });
        });

        // Reset form when modal is hidden
        document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('rejectForm').reset();
            document.getElementById('rejectContentName').textContent = '';
        });

        document.getElementById('revokeModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('revokeForm').reset();
            document.getElementById('revokeContentName').textContent = '';
        });

        // Auto-refresh every 5 minutes if on pending filter
        if ('${currentFilter}' === 'pending' || '${currentFilter}' === '') {
            setInterval(function() {
                if (document.visibilityState === 'visible') {
                    location.reload();
                }
            }, 300000); // 5 minutes
        }

        // Enhanced keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'a' && !e.target.matches('input, textarea')) {
                e.preventDefault();
                const approveBtn = document.querySelector('button[onclick*="approveAll"]');
                if (approveBtn) approveBtn.click();
            }
            
            if (e.ctrlKey && e.key === 'e' && !e.target.matches('input, textarea')) {
                e.preventDefault();
                const exportBtn = document.querySelector('button[onclick*="exportPending"]');
                if (exportBtn) exportBtn.click();
            }
        });
    </script>
    <script>
function testDirectApprove() {
    console.log('Testing direct approve...');
    fetch('${pageContext.request.contextPath}/admin/content/experience/1/approve', {
        method: 'POST'
    })
    .then(response => response.text())
    .then(text => console.log('Direct test result:', text))
    .catch(error => console.error('Direct test error:', error));
}
// Gọi ngay: testDirectApprove()
</script>
</body>
</html>