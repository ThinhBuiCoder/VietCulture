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
    <title>Chi Tiết Nội Dung - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
        }
        .content-image {
            height: 400px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .content-image:hover {
            transform: scale(1.02);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .host-info {
            background-color: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
            border-left: 4px solid #4e73df;
        }
        .host-info:hover {
            transform: translateY(-3px);
        }
        .detail-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.07);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        .detail-card:hover {
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .detail-card .card-header {
            border-bottom: 1px solid rgba(0,0,0,0.05);
            background-color: rgba(0,0,0,0.02);
            padding: 15px 20px;
        }
        .approval-actions {
            background-color: white;
            border: 1px solid #dee2e6;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        .approval-actions:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .image-fallback {
            height: 400px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .experience-badge { 
            background: linear-gradient(45deg, #ff6b6b, #ee5a52);
            transition: all 0.3s ease;
            padding: 8px 15px;
            font-weight: 500;
            letter-spacing: 0.3px;
        }
        .accommodation-badge { 
            background: linear-gradient(45deg, #4ecdc4, #45b7af);
            transition: all 0.3s ease;
            padding: 8px 15px;
            font-weight: 500;
            letter-spacing: 0.3px;
        }
        .badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn {
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            letter-spacing: 0.3px;
        }
        .btn-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            border: none;
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.3);
        }
        .btn-success:hover {
            background: linear-gradient(45deg, #218838, #1e9a78);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(40, 167, 69, 0.4);
        }
        .btn-danger {
            background: linear-gradient(45deg, #dc3545, #ef5350);
            border: none;
            box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3);
        }
        .btn-danger:hover {
            background: linear-gradient(45deg, #c82333, #e53935);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(220, 53, 69, 0.4);
        }
        .btn-outline-secondary {
            border: 1px solid #6c757d;
            background: transparent;
            transition: all 0.3s ease;
        }
        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
            transform: translateY(-2px);
        }
        .alert {
            border-radius: 12px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border: none;
            animation: fadeIn 0.5s ease-out;
        }
        .alert-warning {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        .alert-success {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
        }
        .alert-danger {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        .alert-info {
            background-color: #d1ecf1;
            border-left: 4px solid #17a2b8;
            font-size: 0.9rem;
        }
        .text-primary {
            color: #4e73df !important;
        }
        .mb-4 {
            margin-bottom: 1.8rem !important;
        }
        .rounded-circle {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .property-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 8px;
            transition: all 0.2s ease;
        }
        .property-item:hover {
            background-color: rgba(0,0,0,0.02);
        }
        .property-icon {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            background: linear-gradient(135deg, #4e73df, #224abe);
            color: white;
            box-shadow: 0 3px 5px rgba(0,0,0,0.15);
        }
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .content-image {
                height: 300px;
            }
            .image-fallback {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <%@ include file="../includes/admin-sidebar.jsp" %>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 admin-content">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                    <h1 class="h2">
                        <c:if test="${not empty content}">
                            <c:set var="isExperience" value="${not empty content.experienceId}" />
                            <span class="badge ${isExperience ? 'experience-badge' : 'accommodation-badge'} text-white">
                                <i class="fas ${isExperience ? 'fa-map-marked-alt' : 'fa-home'} me-1"></i>
                                ${isExperience ? 'Experience' : 'Accommodation'}
                            </span>
                            Chi tiết: 
                            <c:choose>
                                <c:when test="${isExperience}">${fn:escapeXml(content.title)}</c:when>
                                <c:otherwise>${fn:escapeXml(content.name)}</c:otherwise>
                            </c:choose>
                        </c:if>
                        <c:if test="${empty content}">
                            <span class="badge bg-secondary text-white">
                                <i class="fas fa-info-circle me-1"></i>Chi tiết nội dung
                            </span>
                            Không tìm thấy
                        </c:if>
                    </h1>
                    <a href="${pageContext.request.contextPath}/admin/content/approval" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                </div>

                <!-- Detect content from either attribute -->
                <c:set var="content" value="${not empty content ? content : contentItem}" />
                <c:set var="isExperience" value="${not empty content.experienceId}" />

                <c:choose>
                    <c:when test="${empty content}">
                        <!-- Not found -->
                        <div class="text-center py-5">
                            <i class="fas fa-exclamation-triangle fa-5x text-muted mb-3"></i>
                            <h3>Không tìm thấy nội dung</h3>
                            <p class="text-muted">
                                Không tìm thấy thông tin cho ID hoặc loại nội dung đã yêu cầu
                            </p>
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/admin/content/approval" class="btn btn-primary">
                                    <i class="fas fa-list me-1"></i>Quay lại danh sách
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Approval Status Alert -->
                        <div class="alert 
                            <c:choose>
                                <c:when test="${content.adminApprovalStatus eq 'PENDING'}">alert-warning</c:when>
                                <c:when test="${content.adminApprovalStatus eq 'APPROVED'}">alert-success</c:when>
                                <c:when test="${content.adminApprovalStatus eq 'REJECTED'}">alert-danger</c:when>
                                <c:otherwise>alert-secondary</c:otherwise>
                            </c:choose>">
                            <i class="fas 
                                <c:choose>
                                    <c:when test="${content.adminApprovalStatus eq 'PENDING'}">fa-clock</c:when>
                                    <c:when test="${content.adminApprovalStatus eq 'APPROVED'}">fa-check-circle</c:when>
                                    <c:when test="${content.adminApprovalStatus eq 'REJECTED'}">fa-times-circle</c:when>
                                    <c:otherwise>fa-info-circle</c:otherwise>
                                </c:choose> me-1"></i>
                            <c:choose>
                                <c:when test="${content.adminApprovalStatus eq 'PENDING'}">Đang chờ duyệt</c:when>
                                <c:when test="${content.adminApprovalStatus eq 'APPROVED'}">
                                    Đã được duyệt${content.active ? ' và đang hiển thị' : ' nhưng host đã ẩn'}
                                </c:when>
                                <c:when test="${content.adminApprovalStatus eq 'REJECTED'}">Đã bị từ chối</c:when>
                                <c:otherwise>Trạng thái không xác định</c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Action Buttons -->
                        <c:if test="${content.adminApprovalStatus eq 'PENDING' or content.adminApprovalStatus eq 'REJECTED'}">
                            <div class="approval-actions mb-4">
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-success" 
                                            onclick="approveContent('${isExperience ? 'experience' : 'accommodation'}', '${isExperience ? content.experienceId : content.accommodationId}')">
                                        <i class="fas fa-check me-1"></i>
                                        ${content.adminApprovalStatus eq 'PENDING' ? 'Duyệt' : 'Duyệt lại'}
                                    </button>
                                    
                                    <c:if test="${content.adminApprovalStatus eq 'PENDING'}">
                                        <button type="button" class="btn btn-danger" 
                                                onclick="rejectContent('${isExperience ? 'experience' : 'accommodation'}', '${isExperience ? content.experienceId : content.accommodationId}', '${fn:escapeXml(isExperience ? content.title : content.name)}')">
                                            <i class="fas fa-times me-1"></i>Từ chối
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>

                        <!-- Reject Reason -->
                        <c:if test="${content.adminApprovalStatus eq 'REJECTED' and not empty content.adminRejectReason}">
                            <div class="alert alert-danger mb-4">
                                <i class="fas fa-exclamation-triangle me-1"></i>
                                <strong>Lý do từ chối:</strong> ${fn:escapeXml(content.adminRejectReason)}
                            </div>
                        </c:if>

                        <!-- Main Content -->
                        <div class="row">
                            <!-- Images -->
                            <div class="col-lg-5 mb-4">
                                <c:choose>
                                    <c:when test="${not empty content.images}">
                                        <c:set var="firstImage" value="${fn:trim(fn:split(content.images, ',')[0])}" />
                                        <c:if test="${not empty firstImage}">
                                            <img src="${pageContext.request.contextPath}/images/${isExperience ? 'experiences' : 'accommodations'}/${firstImage}" 
                                                 class="img-fluid content-image w-100" 
                                                 alt="${fn:escapeXml(isExperience ? content.title : content.name)}"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        </c:if>
                                        <div class="image-fallback" style="display: ${empty firstImage ? 'flex' : 'none'};">
                                            <div class="text-center">
                                                <i class="fas fa-image fa-3x text-muted mb-2"></i>
                                                <div class="small text-muted">Không tải được ảnh</div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="image-fallback">
                                            <div class="text-center">
                                                <i class="fas fa-image fa-3x text-muted mb-2"></i>
                                                <div class="small text-muted">Chưa có ảnh</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Dates -->
                                <div class="d-flex justify-content-between mt-2">
                                    <small class="text-muted">
                                        <i class="fas fa-calendar me-1"></i>
                                        Tạo: <fmt:formatDate value="${content.createdAt}" pattern="dd/MM/yyyy"/>
                                    </small>
                                </div>
                            </div>
                            
                            <!-- Details -->
                            <div class="col-lg-7">
                                <h2 class="mb-3">
                                    <c:choose>
                                        <c:when test="${isExperience}">${fn:escapeXml(content.title)}</c:when>
                                        <c:otherwise>${fn:escapeXml(content.name)}</c:otherwise>
                                    </c:choose>
                                </h2>
                                
                                <!-- Basic Info -->
                                <div class="card detail-card mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="card-title mb-0">Thông tin cơ bản</h5>
                                        <span class="badge bg-${isExperience ? 'warning' : 'info'} text-white">
                                            ${isExperience ? 'Trải nghiệm' : 'Lưu trú'}
                                        </span>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="property-item">
                                                    <div class="property-icon">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                    </div>
                                                    <div>
                                                        <strong>Địa điểm:</strong><br>
                                                        <span>
                                                            ${fn:escapeXml(content.location)}
                                                            <c:if test="${not empty content.cityName}">
                                                                , ${fn:escapeXml(content.cityName)}
                                                            </c:if>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="property-item">
                                                    <div class="property-icon">
                                                        <i class="fas fa-dollar-sign"></i>
                                                    </div>
                                                    <div>
                                                        <strong>Giá:</strong><br>
                                                        <span class="fw-bold text-primary">
                                                            <fmt:formatNumber value="${content.price}" pattern="#,###"/> VND
                                                            <c:if test="${not isExperience}"> /đêm</c:if>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="property-item">
                                                    <div class="property-icon">
                                                        <i class="fas fa-info-circle"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <strong>Mô tả:</strong><br>
                                                        <p class="mt-1">${fn:escapeXml(content.description)}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Host Info -->
                                <div class="card host-info mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center bg-light">
                                        <h5 class="card-title mb-0">Thông tin Host</h5>
                                        <span class="badge bg-primary text-white">ID: ${content.hostId}</span>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center me-3" 
                                                style="width: 60px; height: 60px;">
                                                <span class="text-white fw-bold fs-4">
                                                    ${fn:escapeXml(fn:substring(content.hostName != null ? content.hostName : 'N', 0, 1))}
                                                </span>
                                            </div>
                                            <div>
                                                <h4 class="mb-1">${fn:escapeXml(content.hostName != null ? content.hostName : 'N/A')}</h4>
                                                <div class="d-flex mt-2">
                                                    <span class="badge bg-light text-dark me-2">
                                                        <i class="fas fa-id-card me-1"></i>
                                                        Host ID: ${content.hostId}
                                                    </span>
                                                    <span class="badge bg-light text-dark">
                                                        <i class="fas fa-calendar-alt me-1"></i>
                                                        Tham gia: <fmt:formatDate value="${content.createdAt}" pattern="MM/yyyy"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Specific Details -->
                                <div class="card detail-card">
                                    <div class="card-header bg-light">
                                        <h5 class="card-title mb-0">Chi tiết</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <c:if test="${isExperience}">
                                                <!-- Experience Details -->
                                                <c:if test="${not empty content.duration}">
                                                    <div class="property-item col-md-6 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-clock"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Thời gian:</strong><br>
                                                            <span><fmt:formatDate value="${content.duration}" pattern="HH'h'mm'm'" /></span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty content.maxGroupSize}">
                                                    <div class="property-item col-md-6 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-users"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Số người:</strong><br>
                                                            <span>${content.maxGroupSize}</span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty content.difficulty}">
                                                    <div class="property-item col-md-6 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-signal"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Độ khó:</strong><br>
                                                            <span>
                                                                <c:choose>
                                                                    <c:when test="${content.difficulty eq 'EASY'}">Dễ</c:when>
                                                                    <c:when test="${content.difficulty eq 'MODERATE'}">Trung bình</c:when>
                                                                    <c:when test="${content.difficulty eq 'CHALLENGING'}">Khó</c:when>
                                                                    <c:otherwise>${content.difficulty}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty content.language}">
                                                    <div class="property-item col-md-6 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-language"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Ngôn ngữ:</strong><br>
                                                            <span>${fn:escapeXml(content.language)}</span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:if>

                                            <c:if test="${not isExperience}">
                                                <!-- Accommodation Details -->
                                                <c:if test="${not empty content.numberOfRooms}">
                                                    <div class="property-item col-md-6 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-bed"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Số phòng:</strong><br>
                                                            <span>${content.numberOfRooms}</span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty content.maxOccupancy}">
                                                    <div class="property-item col-md-6 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-users"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Số khách:</strong><br>
                                                            <span>${content.maxOccupancy}</span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty content.amenities}">
                                                    <div class="property-item col-md-12 mb-2">
                                                        <div class="property-icon">
                                                            <i class="fas fa-concierge-bell"></i>
                                                        </div>
                                                        <div>
                                                            <strong>Tiện nghi:</strong><br>
                                                            <span>${fn:escapeXml(content.amenities)}</span>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
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

    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3"></div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function approveContent(contentType, contentId) {
            if (confirm('Bạn có chắc chắn muốn duyệt nội dung này?')) {
                const btn = event.target;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                btn.disabled = true;

                fetch('${pageContext.request.contextPath}/admin/content/approval/' + contentType + '/' + contentId + '/approve', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Duyệt thành công!', 'success');
                        setTimeout(() => window.location.href = '${pageContext.request.contextPath}/admin/content/approval', 1500);
                    } else {
                        showToast('Có lỗi: ' + (data.message || 'Không thể duyệt'), 'error');
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    }
                })
                .catch(error => {
                    showToast('Có lỗi: ' + error.message, 'error');
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                });
            }
        }

        function rejectContent(contentType, contentId, contentName) {
            document.getElementById('rejectContentName').textContent = contentName;
            document.getElementById('rejectForm').action = '${pageContext.request.contextPath}/admin/content/approval/' + contentType + '/' + contentId + '/reject';
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        function showToast(message, type) {
            const toast = document.createElement('div');
            const bgClass = type === 'error' ? 'bg-danger' : type === 'success' ? 'bg-success' : 'bg-info';
            
            toast.className = 'toast align-items-center text-white ' + bgClass;
            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body">${message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            `;
            
            document.getElementById('toastContainer').appendChild(toast);
            new bootstrap.Toast(toast).show();
            
            toast.addEventListener('hidden.bs.toast', () => toast.remove());
        }

        // Reject form submission
        document.getElementById('rejectForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const btn = this.querySelector('button[type="submit"]');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
            btn.disabled = true;
            
            fetch(this.action, {
                method: 'POST',
                body: new FormData(this),
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Từ chối thành công!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
                    setTimeout(() => window.location.href = '${pageContext.request.contextPath}/admin/content/approval', 1500);
                } else {
                    showToast('Có lỗi: ' + (data.message || 'Không thể từ chối'), 'error');
                }
            })
            .catch(error => {
                showToast('Có lỗi: ' + error.message, 'error');
            })
            .finally(() => {
                btn.innerHTML = originalText;
                btn.disabled = false;
            });
        });

        // Reset modal when hidden
        document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('rejectForm').reset();
        });
    </script>
</body>
</html>