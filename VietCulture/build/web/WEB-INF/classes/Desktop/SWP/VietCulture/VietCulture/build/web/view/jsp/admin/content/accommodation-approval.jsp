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
    <title>Duyệt Accommodations - Admin</title>
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
        .accommodation-card {
            transition: transform 0.2s;
            border: none;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        .accommodation-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        .accommodation-image {
            height: 220px;
            object-fit: cover;
            border-radius: 8px;
        }
        .status-pending {
            background-color: #fff3cd;
            border-color: #ffeaa7;
        }
        .status-rejected {
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        .status-approved {
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .host-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            padding: 12px;
        }
        .price-badge {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            font-weight: bold;
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        .amenity-tag {
            background-color: #e3f2fd;
            color: #1976d2;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            margin: 2px;
            display: inline-block;
        }
        .rating-stars {
            color: #ffc107;
        }
        .approval-actions {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-top: 1px solid #dee2e6;
            padding: 15px;
            border-radius: 0 0 12px 12px;
        }
        .stats-card {
            transition: all 0.3s ease;
            border-radius: 12px;
            border: none;
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
        }
        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .filter-buttons .btn {
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            border-radius: 20px;
        }
        .accommodation-type-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
        }
        .approval-reason {
            background-color: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
        }
        .quick-actions {
            position: sticky;
            top: 20px;
            z-index: 100;
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
                    <h1 class="h2">
                        <i class="fas fa-bed me-2 text-primary"></i>Duyệt Accommodations
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-success" onclick="approveAll()">
                                <i class="fas fa-check-double me-1"></i>Duyệt tất cả
                            </button>
                            <button type="button" class="btn btn-sm btn-info" onclick="refreshPage()">
                                <i class="fas fa-sync-alt me-1"></i>Làm mới
                            </button>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-filter me-1"></i>Lọc & Sắp xếp
                            </button>
                            <ul class="dropdown-menu">
                                <li><h6 class="dropdown-header">Trạng thái</h6></li>
                                <li><a class="dropdown-item ${param.filter eq 'pending' ? 'active' : ''}" href="?filter=pending">Chờ duyệt</a></li>
                                <li><a class="dropdown-item ${param.filter eq 'approved' ? 'active' : ''}" href="?filter=approved">Đã duyệt</a></li>
                                <li><a class="dropdown-item ${param.filter eq 'rejected' ? 'active' : ''}" href="?filter=rejected">Bị từ chối</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><h6 class="dropdown-header">Loại hình</h6></li>
                                <li><a class="dropdown-item" href="?filter=${param.filter}&type=HOTEL">Khách sạn</a></li>
                                <li><a class="dropdown-item" href="?filter=${param.filter}&type=HOMESTAY">Homestay</a></li>
                                <li><a class="dropdown-item" href="?filter=${param.filter}&type=RESORT">Resort</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item ${empty param.filter ? 'active' : ''}" href="?">Tất cả</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Filter Buttons (Mobile-friendly) -->
                <div class="filter-buttons d-md-none mb-3">
                    <a href="?" class="btn btn-sm ${empty param.filter ? 'btn-primary' : 'btn-outline-primary'}">Tất cả</a>
                    <a href="?filter=pending" class="btn btn-sm ${param.filter eq 'pending' ? 'btn-warning' : 'btn-outline-warning'}">Chờ duyệt</a>
                    <a href="?filter=approved" class="btn btn-sm ${param.filter eq 'approved' ? 'btn-success' : 'btn-outline-success'}">Đã duyệt</a>
                    <a href="?filter=rejected" class="btn btn-sm ${param.filter eq 'rejected' ? 'btn-danger' : 'btn-outline-danger'}">Bị từ chối</a>
                </div>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-warning mb-2">
                                    <i class="fas fa-clock fa-3x"></i>
                                </div>
                                <h4 class="card-title text-warning mb-1">${pendingCount != null ? pendingCount : 0}</h4>
                                <p class="card-text mb-0 text-muted">Chờ duyệt</p>
                                <small class="text-muted">Cần xử lý</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-success mb-2">
                                    <i class="fas fa-check-circle fa-3x"></i>
                                </div>
                                <h4 class="card-title text-success mb-1">${approvedCount != null ? approvedCount : 0}</h4>
                                <p class="card-text mb-0 text-muted">Đã duyệt</p>
                                <small class="text-muted">Hoạt động</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-danger mb-2">
                                    <i class="fas fa-times-circle fa-3x"></i>
                                </div>
                                <h4 class="card-title text-danger mb-1">${rejectedCount != null ? rejectedCount : 0}</h4>
                                <p class="card-text mb-0 text-muted">Bị từ chối</p>
                                <small class="text-muted">Cần sửa chữa</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-info mb-2">
                                    <i class="fas fa-building fa-3x"></i>
                                </div>
                                <h4 class="card-title text-info mb-1">${totalCount != null ? totalCount : 0}</h4>
                                <p class="card-text mb-0 text-muted">Tổng cộng</p>
                                <small class="text-muted">Toàn hệ thống</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions (Sticky) -->
                <div class="quick-actions mb-3">
                    <div class="alert alert-info d-flex align-items-center" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        <div class="flex-grow-1">
                            <strong>Lưu ý:</strong> Tất cả accommodations cần được duyệt trước khi hiển thị công khai.
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-info ms-2" onclick="showBulkActions()">
                            <i class="fas fa-tasks me-1"></i>Hành động hàng loạt
                        </button>
                    </div>
                </div>

                <!-- Accommodations List -->
                <div class="row">
                    <c:forEach var="accommodation" items="${accommodations}">
                        <div class="col-lg-6 col-xl-4 mb-4">
                            <div class="card accommodation-card h-100 
                                ${accommodation.isActive == 0 ? 'status-pending' : ''} 
                                ${accommodation.isActive == -1 ? 'status-rejected' : ''}
                                ${accommodation.isActive == 1 ? 'status-approved' : ''}">
                                
                                <!-- Accommodation Image -->
                                <div class="position-relative">
                                    <c:choose>
                                        <c:when test="${not empty accommodation.images}">
                                            <c:set var="imageArray" value="${fn:split(accommodation.images, ',')}" />
                                            <c:set var="firstImage" value="${fn:trim(imageArray[0])}" />
                                            <img src="${pageContext.request.contextPath}/assets/images/accommodations/${firstImage}" 
                                                 class="card-img-top accommodation-image" 
                                                 alt="${accommodation.name}"
                                                 data-lightbox="accommodation-${accommodation.accommodationId}"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                            <div class="card-img-top accommodation-image bg-light d-flex align-items-center justify-content-center" style="display: none;">
                                                <i class="fas fa-image fa-3x text-muted"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-img-top accommodation-image bg-light d-flex align-items-center justify-content-center">
                                                <i class="fas fa-image fa-4x text-muted"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Type Badge -->
                                    <span class="accommodation-type-badge">
                                        <i class="fas fa-bed me-1"></i>${accommodation.type != null ? accommodation.type : 'N/A'}
                                    </span>
                                    
                                    <!-- Status Badge -->
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <c:choose>
                                            <c:when test="${accommodation.isActive == 1}">
                                                <span class="badge bg-success fs-6">
                                                    <i class="fas fa-check-circle me-1"></i>Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${accommodation.isActive == -1}">
                                                <span class="badge bg-danger fs-6">
                                                    <i class="fas fa-times-circle me-1"></i>Bị từ chối
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning fs-6">
                                                    <i class="fas fa-clock me-1"></i>Chờ duyệt
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Price Badge -->
                                    <div class="position-absolute bottom-0 start-0 m-2">
                                        <span class="price-badge">
                                            <fmt:formatNumber value="${accommodation.pricePerNight}" type="currency" currencySymbol=""/>đ/đêm
                                        </span>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <!-- Title & Rating -->
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="card-title mb-0" style="flex: 1; line-height: 1.3;">
                                            ${accommodation.name}
                                        </h5>
                                        <div class="rating-stars ms-2">
                                            <c:forEach begin="1" end="${accommodation.averageRating > 0 ? accommodation.averageRating : 0}" var="i">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                            <c:if test="${accommodation.averageRating > 0}">
                                                <small class="text-muted ms-1">(${accommodation.averageRating})</small>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <!-- Location -->
                                    <p class="text-muted mb-2">
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                        ${accommodation.address}
                                        <c:if test="${not empty accommodation.cityName}">
                                            , ${accommodation.cityName}
                                        </c:if>
                                    </p>
                                    
                                    <!-- Description -->
                                    <p class="card-text">
                                        <c:choose>
                                            <c:when test="${fn:length(accommodation.description) > 120}">
                                                ${fn:substring(accommodation.description, 0, 120)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${accommodation.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <!-- Accommodation Details -->
                                    <div class="row text-sm mb-3">
                                        <div class="col-6 mb-2">
                                            <small class="text-muted">
                                                <i class="fas fa-users me-1"></i>
                                                ${accommodation.maxGuests} khách
                                            </small>
                                        </div>
                                        <div class="col-6 mb-2">
                                            <small class="text-muted">
                                                <i class="fas fa-door-open me-1"></i>
                                                ${accommodation.bedrooms} phòng ngủ
                                            </small>
                                        </div>
                                        <div class="col-6 mb-2">
                                            <small class="text-muted">
                                                <i class="fas fa-bath me-1"></i>
                                                ${accommodation.bathrooms} phòng tắm
                                            </small>
                                        </div>
                                        <div class="col-6 mb-2">
                                            <small class="text-muted">
                                                <i class="fas fa-calendar-check me-1"></i>
                                                ${accommodation.totalBookings} lượt đặt
                                            </small>
                                        </div>
                                    </div>
                                    
                                    <!-- Amenities -->
                                    <c:if test="${not empty accommodation.amenities}">
                                        <div class="mb-3">
                                            <small class="text-muted d-block mb-1">Tiện nghi:</small>
                                            <c:set var="amenityArray" value="${fn:split(accommodation.amenities, ',')}" />
                                            <c:forEach items="${amenityArray}" var="amenity" begin="0" end="3">
                                                <span class="amenity-tag">${fn:trim(amenity)}</span>
                                            </c:forEach>
                                            <c:if test="${fn:length(amenityArray) > 4}">
                                                <span class="amenity-tag">+${fn:length(amenityArray) - 4} khác</span>
                                            </c:if>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Host Info -->
                                    <div class="host-info mb-3">
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty accommodation.hostName}">
                                                    <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center me-2" 
                                                         style="width: 35px; height: 35px;">
                                                        <span class="text-white fw-bold" style="font-size: 0.8rem;">
                                                            ${fn:substring(accommodation.hostName, 0, 1)}
                                                        </span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center me-2" 
                                                         style="width: 35px; height: 35px;">
                                                        <i class="fas fa-user text-white" style="font-size: 0.8rem;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <strong style="font-size: 0.9rem;">${accommodation.hostName != null ? accommodation.hostName : 'N/A'}</strong>
                                                <br>
                                                <small class="text-muted">Host ID: ${accommodation.hostId}</small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Created Date -->
                                    <p class="text-muted mb-0">
                                        <small>
                                            <i class="fas fa-calendar-plus me-1"></i>
                                            Tạo: <fmt:formatDate value="${accommodation.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </p>
                                </div>
                                
                                <!-- Actions for Pending -->
                                <c:if test="${accommodation.isActive == 0}">
                                    <div class="approval-actions">
                                        <div class="d-flex gap-2 mb-2">
                                            <button type="button" 
                                                    class="btn btn-success btn-sm flex-fill" 
                                                    onclick="approveAccommodation(${accommodation.accommodationId})">
                                                <i class="fas fa-check me-1"></i>Duyệt
                                            </button>
                                            <button type="button" 
                                                    class="btn btn-danger btn-sm flex-fill" 
                                                    onclick="rejectAccommodation(${accommodation.accommodationId}, '${fn:escapeXml(accommodation.name)}')">
                                                <i class="fas fa-times me-1"></i>Từ chối
                                            </button>
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/accommodations/${accommodation.accommodationId}" 
                                               class="btn btn-outline-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                            </a>
                                            <c:if test="${not empty accommodation.images}">
                                                <button type="button" 
                                                        class="btn btn-outline-info btn-sm flex-fill" 
                                                        onclick="showAllImages(${accommodation.accommodationId}, '${fn:escapeXml(accommodation.images)}')">
                                                    <i class="fas fa-images me-1"></i>Hình ảnh
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Actions for Approved -->
                                <c:if test="${accommodation.isActive == 1}">
                                    <div class="approval-actions">
                                        <div class="d-flex gap-2">
                                            <button type="button" 
                                                    class="btn btn-warning btn-sm flex-fill" 
                                                    onclick="revokeApproval(${accommodation.accommodationId}, '${fn:escapeXml(accommodation.name)}')">
                                                <i class="fas fa-undo me-1"></i>Thu hồi
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/accommodations/${accommodation.accommodationId}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Actions for Rejected -->
                                <c:if test="${accommodation.isActive == -1}">
                                    <div class="approval-actions">
                                        <div class="d-flex gap-2 mb-2">
                                            <button type="button" 
                                                    class="btn btn-success btn-sm flex-fill" 
                                                    onclick="approveAccommodation(${accommodation.accommodationId})">
                                                <i class="fas fa-check me-1"></i>Duyệt lại
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/accommodations/${accommodation.accommodationId}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                            </a>
                                        </div>
                                        <c:if test="${not empty accommodation.rejectionReason}">
                                            <div class="approval-reason">
                                                <small class="text-danger">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                                    <strong>Lý do từ chối:</strong> ${accommodation.rejectionReason}
                                                </small>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Empty State -->
                    <c:if test="${empty accommodations}">
                        <div class="col-12">
                            <div class="text-center py-5">
                                <i class="fas fa-bed fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Không có accommodation nào</h4>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${param.filter eq 'pending'}">
                                            Không có accommodation nào đang chờ duyệt.
                                        </c:when>
                                        <c:when test="${param.filter eq 'approved'}">
                                            Chưa có accommodation nào được duyệt.
                                        </c:when>
                                        <c:when test="${param.filter eq 'rejected'}">
                                            Không có accommodation nào bị từ chối.
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có accommodation nào trong hệ thống.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <button type="button" class="btn btn-outline-primary" onclick="refreshPage()">
                                    <i class="fas fa-sync-alt me-1"></i>Làm mới trang
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Accommodation pagination" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&filter=${param.filter}&type=${param.type}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&filter=${param.filter}&type=${param.type}">
                                        ${pageNum}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&filter=${param.filter}&type=${param.type}">
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
                    <h5 class="modal-title">Từ chối Accommodation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="rejectForm" method="POST">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn từ chối accommodation <strong id="rejectAccommodationName"></strong>?</p>
                        <div class="mb-3">
                            <label class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="4" required placeholder="Nhập lý do từ chối chi tiết..."></textarea>
                            <div class="form-text">Host sẽ nhận được thông báo về lý do từ chối và có thể chỉnh sửa để gửi lại</div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="allowResubmit" id="allowResubmit" checked>
                                <label class="form-check-label" for="allowResubmit">
                                    Cho phép host chỉnh sửa và gửi lại
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="sendNotification" id="sendNotification" checked>
                                <label class="form-check-label" for="sendNotification">
                                    Gửi email thông báo cho host
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times me-1"></i>Từ chối
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Image Gallery Modal -->
    <div class="modal fade" id="imageGalleryModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hình ảnh Accommodation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="imageGallery" class="row g-2">
                        <!-- Images will be loaded here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
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
                        <p>Bạn có chắc chắn muốn thu hồi duyệt cho accommodation <strong id="revokeAccommodationName"></strong>?</p>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Cảnh báo:</strong> Accommodation sẽ bị ẩn khỏi website và các booking hiện tại có thể bị ảnh hưởng.
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Lý do thu hồi <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="3" required placeholder="Nhập lý do thu hồi duyệt..."></textarea>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="suspendBookings" id="suspendBookings">
                                <label class="form-check-label" for="suspendBookings">
                                    Tạm dừng các booking trong tương lai
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-undo me-1"></i>Thu hồi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bulk Actions Modal -->
    <div class="modal fade" id="bulkActionsModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hành động hàng loạt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Chọn hành động:</label>
                        <select class="form-select" id="bulkAction">
                            <option value="">-- Chọn hành động --</option>
                            <option value="approve-all">Duyệt tất cả đang chờ</option>
                            <option value="reject-old">Từ chối cũ hơn 30 ngày</option>
                            <option value="export-pending">Xuất danh sách chờ duyệt</option>
                        </select>
                    </div>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Hành động hàng loạt sẽ áp dụng cho tất cả accommodation phù hợp với điều kiện đã chọn.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="executeBulkAction()">
                        <i class="fas fa-play me-1"></i>Thực hiện
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lightbox2@2.11.3/dist/js/lightbox.min.js"></script>
    
    <script>
        // Configure lightbox
        lightbox.option({
            'resizeDuration': 200,
            'wrapAround': true,
            'albumLabel': 'Hình %1 / %2'
        });

        function approveAccommodation(accommodationId) {
            if (confirm('Bạn có chắc chắn muốn duyệt accommodation này?')) {
                const loadingBtn = event.target;
                const originalContent = loadingBtn.innerHTML;
                loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                loadingBtn.disabled = true;

                fetch('${pageContext.request.contextPath}/admin/accommodations/' + accommodationId + '/approve', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Accommodation đã được duyệt thành công!', 'success');
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể duyệt accommodation'), 'error');
                        loadingBtn.innerHTML = originalContent;
                        loadingBtn.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Có lỗi xảy ra khi kết nối server', 'error');
                    loadingBtn.innerHTML = originalContent;
                    loadingBtn.disabled = false;
                });
            }
        }

        function rejectAccommodation(accommodationId, accommodationName) {
            document.getElementById('rejectAccommodationName').textContent = accommodationName;
            document.getElementById('rejectForm').action = '${pageContext.request.contextPath}/admin/accommodations/' + accommodationId + '/reject';
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        function revokeApproval(accommodationId, accommodationName) {
            document.getElementById('revokeAccommodationName').textContent = accommodationName;
            document.getElementById('revokeForm').action = '${pageContext.request.contextPath}/admin/accommodations/' + accommodationId + '/revoke';
            new bootstrap.Modal(document.getElementById('revokeModal')).show();
        }

        function approveAll() {
            if (confirm('Bạn có chắc chắn muốn duyệt TẤT CẢ accommodations đang chờ?')) {
                const loadingBtn = event.target;
                const originalContent = loadingBtn.innerHTML;
                loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                loadingBtn.disabled = true;

                fetch('${pageContext.request.contextPath}/admin/accommodations/approve-all', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const count = data.count || 0;
                        showToast('Đã duyệt ' + count + ' accommodation thành công!', 'success');
                        setTimeout(() => location.reload(), 2000);
                    } else {
                        showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể duyệt tất cả'), 'error');
                        loadingBtn.innerHTML = originalContent;
                        loadingBtn.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Có lỗi xảy ra khi kết nối server', 'error');
                    loadingBtn.innerHTML = originalContent;
                    loadingBtn.disabled = false;
                });
            }
        }

        function showAllImages(accommodationId, imagesString) {
            const gallery = document.getElementById('imageGallery');
            gallery.innerHTML = '';
            
            if (imagesString && imagesString.trim() !== '') {
                const images = imagesString.split(',').map(img => img.trim()).filter(img => img !== '');
                
                if (images.length > 0) {
                    images.forEach((image, index) => {
                        const col = document.createElement('div');
                        col.className = 'col-md-3 col-6 mb-2';
                        col.innerHTML = 
                            '<img src="${pageContext.request.contextPath}/assets/images/accommodations/' + encodeURIComponent(image) + '" ' +
                            'class="img-fluid rounded shadow-sm" ' +
                            'style="height: 150px; width: 100%; object-fit: cover; cursor: pointer;" ' +
                            'data-lightbox="gallery-' + accommodationId + '" ' +
                            'data-title="Hình ' + (index + 1) + '" ' +
                            'onerror="this.parentElement.style.display=\'none\'">';
                        gallery.appendChild(col);
                    });
                } else {
                    gallery.innerHTML = '<div class="col-12 text-center"><p class="text-muted">Không có hình ảnh hợp lệ</p></div>';
                }
            } else {
                gallery.innerHTML = '<div class="col-12 text-center"><p class="text-muted">Không có hình ảnh</p></div>';
            }
            
            new bootstrap.Modal(document.getElementById('imageGalleryModal')).show();
        }

        function showBulkActions() {
            new bootstrap.Modal(document.getElementById('bulkActionsModal')).show();
        }

        function executeBulkAction() {
            const action = document.getElementById('bulkAction').value;
            if (!action) {
                showToast('Vui lòng chọn hành động', 'warning');
                return;
            }

            if (confirm('Bạn có chắc chắn muốn thực hiện hành động này?')) {
                // Execute bulk action based on selection
                switch(action) {
                    case 'approve-all':
                        approveAll();
                        break;
                    case 'reject-old':
                        rejectOldAccommodations();
                        break;
                    case 'export-pending':
                        exportPendingAccommodations();
                        break;
                    default:
                        showToast('Hành động không hợp lệ', 'error');
                }
                
                bootstrap.Modal.getInstance(document.getElementById('bulkActionsModal')).hide();
            }
        }

        function rejectOldAccommodations() {
            fetch('${pageContext.request.contextPath}/admin/accommodations/reject-old', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Đã từ chối ' + (data.count || 0) + ' accommodation cũ', 'success');
                    setTimeout(() => location.reload(), 2000);
                } else {
                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể thực hiện'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra khi kết nối server', 'error');
            });
        }

        function exportPendingAccommodations() {
            window.location.href = '${pageContext.request.contextPath}/admin/accommodations/export-pending';
            showToast('Đang xuất danh sách...', 'info');
        }

        function refreshPage() {
            location.reload();
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
                    '<div class="toast-body">' + escapeHtml(message) + '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            // Remove toast after it's hidden
            toast.addEventListener('hidden.bs.toast', function() {
                toast.remove();
            });
        }

        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
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
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Accommodation đã bị từ chối!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể từ chối accommodation'), 'error');
                    submitBtn.innerHTML = originalContent;
                    submitBtn.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra khi kết nối server', 'error');
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
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Đã thu hồi duyệt accommodation!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('revokeModal')).hide();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể thu hồi duyệt'), 'error');
                    submitBtn.innerHTML = originalContent;
                    submitBtn.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra khi kết nối server', 'error');
                submitBtn.innerHTML = originalContent;
                submitBtn.disabled = false;
            });
        });

        // Reset forms when modals are hidden
        document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('rejectForm').reset();
        });

        document.getElementById('revokeModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('revokeForm').reset();
        });

        // Auto-refresh every 5 minutes if on pending filter
        if ('${param.filter}' === 'pending' || '${param.filter}' === '') {
            setInterval(function() {
                // Only refresh if user is still on the page
                if (document.visibilityState === 'visible') {
                    location.reload();
                }
            }, 300000); // 5 minutes
        }
    </script>
</body>
</html>