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
    <title>Chi Tiết Nội Dung - VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', sans-serif;
        }
        
        .admin-content {
            background: #f8f9fc;
            min-height: 100vh;
            padding-left: 250px;
        }
        
        .content-wrapper {
            padding: 1.5rem;
        }
        
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e3e6f0;
        }
        
        .page-title {
            color: #2c3e50;
            font-size: 1.75rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .back-btn {
            background: #f8f9fc;
            border: 1px solid #d1d3e2;
            color: #5a5c69;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .back-btn:hover {
            background: #eaecf4;
            color: #3a3b45;
            transform: translateY(-1px);
        }
        
        .content-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e3e6f0;
            transition: all 0.2s ease;
            overflow: hidden;
        }
        
        .content-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .content-image {
            height: 350px;
            width: 100%;
            object-fit: cover;
            border-radius: 12px;
        }
        
        .image-fallback {
            height: 350px;
            background: #f8f9fc;
            border: 2px dashed #d1d3e2;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            color: #6c757d;
        }
        
        .status-alert {
            border-radius: 10px;
            border: none;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .status-alert.pending {
            background: #fff3cd;
            color: #856404;
            border-left: 4px solid #ffc107;
        }
        
        .status-alert.approved {
            background: #d1edff;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .status-alert.rejected {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .action-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e3e6f0;
        }
        
        .btn-approve {
            background: #28a745;
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .btn-approve:hover {
            background: #218838;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
        }
        
        .btn-reject {
            background: #dc3545;
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .btn-reject:hover {
            background: #c82333;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }
        
        .info-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e3e6f0;
        }
        
        .section-title {
            color: #2c3e50;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-item {
            display: flex;
            margin-bottom: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
            background: #f8f9fc;
            transition: all 0.2s ease;
        }
        
        .info-item:hover {
            background: #eaecf4;
        }
        
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        
        .info-content {
            flex-grow: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: #6c757d;
        }
        
        .host-card {
            background: linear-gradient(135deg, #f8f9fc 0%, #e9ecef 100%);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid #e3e6f0;
        }
        
        .host-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 600;
            margin-right: 1rem;
        }
        
        .badge-type {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
        }
        
        .badge-experience {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
        }
        
        .badge-accommodation {
            background: linear-gradient(135deg, #4ecdc4, #45b7af);
            color: white;
        }
        
        .price-display {
            color: #28a745;
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .modal-content {
            border-radius: 12px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .modal-header {
            background: #dc3545;
            color: white;
            border-radius: 12px 12px 0 0;
            padding: 1.25rem 1.5rem;
        }
        
        .modal-body {
            padding: 1.5rem;
        }
        
        .modal-footer {
            background: #f8f9fc;
            border-radius: 0 0 12px 12px;
            padding: 1.25rem 1.5rem;
        }
        
        .form-control {
            border: 2px solid #e3e6f0;
            border-radius: 8px;
            padding: 0.75rem;
            transition: border-color 0.2s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .reason-btn {
            background: #f8f9fc;
            border: 1px solid #d1d3e2;
            color: #5a5c69;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            transition: all 0.2s ease;
        }
        
        .reason-btn:hover {
            background: #667eea;
            border-color: #667eea;
            color: white;
        }
        
        .toast {
            border-radius: 8px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .not-found {
            background: white;
            border-radius: 12px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e3e6f0;
        }
        
        .fade-in {
            animation: fadeIn 0.3s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Mobile responsive */
        @media (max-width: 768px) {
            .admin-content {
                padding-left: 0;
                padding-top: 70px;
            }
            
            .content-wrapper {
                padding: 1rem;
            }
            
            .page-title {
                font-size: 1.5rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
            
            .content-image,
            .image-fallback {
                height: 250px;
            }
            
            .info-item {
                flex-direction: column;
                text-align: center;
            }
            
            .info-icon {
                margin: 0 auto 0.75rem auto;
            }
            
            .host-card {
                text-align: center;
            }
            
            .host-avatar {
                margin: 0 auto 1rem auto;
            }
        }
        
        /* Loading states */
        .btn-loading {
            position: relative;
            color: transparent !important;
        }
        
        .btn-loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            top: 50%;
            left: 50%;
            margin-left: -8px;
            margin-top: -8px;
            border: 2px solid #ffffff;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Improved accessibility */
        .btn:focus,
        .form-control:focus {
            outline: 2px solid #667eea;
            outline-offset: 2px;
        }
        
        /* Better visual hierarchy */
        .text-muted {
            color: #6c757d !important;
        }
        
        .text-primary {
            color: #667eea !important;
        }
        
        /* Simplified animations */
        .simple-hover {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .simple-hover:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0">
            <%@ include file="../includes/admin-sidebar.jsp" %>

            <main class="admin-content">
                <div class="content-wrapper">
                    <!-- Page Header -->
                    <div class="page-header fade-in">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <c:if test="${not empty content}">
                                    <c:set var="isExperience" value="${not empty content.experienceId}" />
                                    <div class="page-title">
                                        <span class="badge-type ${isExperience ? 'badge-experience' : 'badge-accommodation'}">
                                            <i class="fas ${isExperience ? 'fa-map-marked-alt' : 'fa-home'} me-2"></i>
                                            ${isExperience ? 'Trải nghiệm' : 'Chỗ ở'}
                                        </span>
                                        Chi tiết nội dung
                                    </div>
                                    <p class="text-muted mt-2 mb-0">
                                        <c:choose>
                                            <c:when test="${isExperience}">${fn:escapeXml(content.title)}</c:when>
                                            <c:otherwise>${fn:escapeXml(content.name)}</c:otherwise>
                                        </c:choose>
                                    </p>
                                </c:if>
                                <c:if test="${empty content}">
                                    <div class="page-title">
                                        <i class="fas fa-exclamation-triangle text-warning"></i>
                                        Không tìm thấy nội dung
                                    </div>
                                    <p class="text-muted mt-2 mb-0">Nội dung không tồn tại hoặc đã bị xóa</p>
                                </c:if>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/content/approval" class="back-btn">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                        </div>
                    </div>

                    <!-- Detect content from either attribute -->
                    <c:set var="content" value="${not empty content ? content : contentItem}" />
                    <c:set var="isExperience" value="${not empty content.experienceId}" />

                    <c:choose>
                        <c:when test="${empty content}">
                            <!-- Not found -->
                            <div class="not-found fade-in">
                                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted mb-2">Không tìm thấy nội dung</h4>
                                <p class="text-muted mb-4">
                                    Nội dung bạn đang tìm kiếm không tồn tại hoặc đã bị xóa khỏi hệ thống.
                                </p>
                                <a href="${pageContext.request.contextPath}/admin/content/approval" class="btn btn-primary">
                                    <i class="fas fa-list me-2"></i>Về danh sách
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Status Alert -->
                            <div class="status-alert fade-in
                                <c:choose>
                                    <c:when test="${content.adminApprovalStatus eq 'PENDING'}">pending</c:when>
                                    <c:when test="${content.adminApprovalStatus eq 'APPROVED'}">approved</c:when>
                                    <c:when test="${content.adminApprovalStatus eq 'REJECTED'}">rejected</c:when>
                                    <c:otherwise>pending</c:otherwise>
                                </c:choose>">
                                <div class="d-flex align-items-center">
                                    <i class="fas 
                                        <c:choose>
                                            <c:when test="${content.adminApprovalStatus eq 'PENDING'}">fa-clock</c:when>
                                            <c:when test="${content.adminApprovalStatus eq 'APPROVED'}">fa-check-circle</c:when>
                                            <c:when test="${content.adminApprovalStatus eq 'REJECTED'}">fa-times-circle</c:when>
                                            <c:otherwise>fa-info-circle</c:otherwise>
                                        </c:choose> me-3"></i>
                                    <div>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${content.adminApprovalStatus eq 'PENDING'}">Đang chờ duyệt</c:when>
                                                <c:when test="${content.adminApprovalStatus eq 'APPROVED'}">
                                                    Đã được duyệt${content.active ? ' và đang hiển thị' : ' (host đã ẩn)'}
                                                </c:when>
                                                <c:when test="${content.adminApprovalStatus eq 'REJECTED'}">Đã bị từ chối</c:when>
                                                <c:otherwise>Trạng thái không xác định</c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <c:if test="${content.adminApprovalStatus eq 'PENDING' or content.adminApprovalStatus eq 'REJECTED'}">
                                <div class="action-section fade-in">
                                    <h6 class="section-title">
                                        <i class="fas fa-tasks"></i>
                                        Hành động
                                    </h6>
                                    <div class="d-flex gap-3 flex-wrap">
                                        <button type="button" class="btn btn-approve" 
                                                onclick="approveContent('${isExperience ? 'experience' : 'accommodation'}', '${isExperience ? content.experienceId : content.accommodationId}')">
                                            <i class="fas fa-check me-2"></i>
                                            ${content.adminApprovalStatus eq 'PENDING' ? 'Duyệt nội dung' : 'Duyệt lại'}
                                        </button>
                                        
                                        <c:if test="${content.adminApprovalStatus eq 'PENDING'}">
                                            <button type="button" class="btn btn-reject" 
                                                    onclick="rejectContent('${isExperience ? 'experience' : 'accommodation'}', '${isExperience ? content.experienceId : content.accommodationId}', '${fn:escapeXml(isExperience ? content.title : content.name)}')">
                                                <i class="fas fa-times me-2"></i>Từ chối
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Reject Reason -->
                            <c:if test="${content.adminApprovalStatus eq 'REJECTED' and not empty content.adminRejectReason}">
                                <div class="info-section fade-in">
                                    <h6 class="section-title text-danger">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        Lý do từ chối
                                    </h6>
                                    <div class="alert alert-danger mb-0">
                                        ${fn:escapeXml(content.adminRejectReason)}
                                    </div>
                                </div>
                            </c:if>

                            <!-- Main Content -->
                            <div class="row g-4">
                                <!-- Image Section -->
                                <div class="col-lg-5">
                                    <div class="content-card fade-in">
                                        <c:choose>
                                            <c:when test="${not empty content.images}">
                                                <c:set var="firstImage" value="${fn:trim(fn:split(content.images, ',')[0])}" />
                                                <c:if test="${not empty firstImage}">
                                                    <img src="${pageContext.request.contextPath}/images/${isExperience ? 'experiences' : 'accommodations'}/${firstImage}" 
                                                         class="content-image" 
                                                         alt="${fn:escapeXml(isExperience ? content.title : content.name)}"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                </c:if>
                                                <div class="image-fallback" style="display: ${empty firstImage ? 'flex' : 'none'};">
                                                    <div>
                                                        <i class="fas fa-image fa-3x mb-2"></i>
                                                        <div>Không tải được ảnh</div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="image-fallback">
                                                    <div>
                                                        <i class="fas fa-image fa-3x mb-2"></i>
                                                        <div>Chưa có ảnh</div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <div class="p-3">
                                            <div class="d-flex justify-content-between align-items-center text-muted small">
                                                <span>
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <fmt:formatDate value="${content.createdAt}" pattern="dd/MM/yyyy"/>
                                                </span>
                                                <c:if test="${not empty content.images}">
                                                    <span>
                                                        <i class="fas fa-images me-1"></i>
                                                        ${fn:length(fn:split(content.images, ','))} ảnh
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Info Section -->
                                <div class="col-lg-7">
                                    <!-- Basic Info -->
                                    <div class="info-section fade-in">
                                        <h6 class="section-title">
                                            <i class="fas fa-info-circle"></i>
                                            Thông tin cơ bản
                                        </h6>
                                        
                                        <h3 class="mb-3 fw-bold">
                                            <c:choose>
                                                <c:when test="${isExperience}">${fn:escapeXml(content.title)}</c:when>
                                                <c:otherwise>${fn:escapeXml(content.name)}</c:otherwise>
                                            </c:choose>
                                        </h3>
                                        
                                        <div class="info-item">
                                            <div class="info-icon">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Địa điểm</div>
                                                <div class="info-value">
                                                    ${fn:escapeXml(content.location)}
                                                    <c:if test="${not empty content.cityName}">
                                                        , ${fn:escapeXml(content.cityName)}
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="info-item">
                                            <div class="info-icon">
                                                <i class="fas fa-dollar-sign"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Giá</div>
                                                <div class="price-display">
                                                    <fmt:formatNumber value="${content.price}" pattern="#,###"/> VND
                                                    <c:if test="${not isExperience}">
                                                        <small class="text-muted">/đêm</small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="info-item">
                                            <div class="info-icon">
                                                <i class="fas fa-align-left"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Mô tả</div>
                                                <div class="info-value">${fn:escapeXml(content.description)}</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Host Info -->
                                    <div class="info-section fade-in">
                                        <h6 class="section-title">
                                            <i class="fas fa-user"></i>
                                            Thông tin Host
                                        </h6>
                                        
                                        <div class="host-card">
                                            <div class="d-flex align-items-center">
                                                <div class="host-avatar">
                                                    ${fn:escapeXml(fn:substring(content.hostName != null ? content.hostName : 'N', 0, 1))}
                                                </div>
                                                <div>
                                                    <h5 class="mb-1">${fn:escapeXml(content.hostName != null ? content.hostName : 'N/A')}</h5>
                                                    <div class="text-muted">
                                                        <small>
                                                            <i class="fas fa-id-card me-1"></i>
                                                            ID: ${content.hostId}
                                                        </small>
                                                        <small class="ms-3">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            Tham gia: <fmt:formatDate value="${content.createdAt}" pattern="MM/yyyy"/>
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Detailed Info -->
                                    <div class="info-section fade-in">
                                        <h6 class="section-title">
                                            <i class="fas fa-list"></i>
                                            Chi tiết ${isExperience ? 'trải nghiệm' : 'chỗ ở'}
                                        </h6>
                                        
                                        <c:if test="${isExperience}">
                                            <!-- Experience Details -->
                                            <c:if test="${not empty content.duration}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-clock"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Thời gian</div>
                                                        <div class="info-value">
                                                            <fmt:formatDate value="${content.duration}" pattern="HH'h'mm'm'" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.maxGroupSize}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-users"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Số người tối đa</div>
                                                        <div class="info-value">${content.maxGroupSize} người</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.difficulty}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-signal"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Độ khó</div>
                                                        <div class="info-value">
                                                            <c:choose>
                                                                <c:when test="${content.difficulty eq 'EASY'}">
                                                                    <span class="badge bg-success">Dễ</span>
                                                                </c:when>
                                                                <c:when test="${content.difficulty eq 'MODERATE'}">
                                                                    <span class="badge bg-warning">Trung bình</span>
                                                                </c:when>
                                                                <c:when test="${content.difficulty eq 'CHALLENGING'}">
                                                                    <span class="badge bg-danger">Khó</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${content.difficulty}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.language}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-language"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Ngôn ngữ</div>
                                                        <div class="info-value">${fn:escapeXml(content.language)}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.includedItems}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-check-circle"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Bao gồm</div>
                                                        <div class="info-value">${fn:escapeXml(content.includedItems)}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <!-- Sử dụng c:catch để xử lý nếu thuộc tính excludedItems không tồn tại -->
                                            <c:catch var="excludedItemsException">
                                                <c:if test="${not empty content.excludedItems}">
                                                    <div class="info-item">
                                                        <div class="info-icon">
                                                            <i class="fas fa-times-circle"></i>
                                                        </div>
                                                        <div class="info-content">
                                                            <div class="info-label">Không bao gồm</div>
                                                            <div class="info-value">${fn:escapeXml(content.excludedItems)}</div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:catch>
                                            
                                            <c:if test="${not empty content.requirements}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-exclamation-circle"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Yêu cầu</div>
                                                        <div class="info-value">${fn:escapeXml(content.requirements)}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:if>

                                        <c:if test="${not isExperience}">
                                            <!-- Accommodation Details -->
                                            <c:if test="${not empty content.numberOfRooms}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-bed"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Số phòng ngủ</div>
                                                        <div class="info-value">${content.numberOfRooms} phòng</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.maxOccupancy}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-users"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Số khách tối đa</div>
                                                        <div class="info-value">${content.maxOccupancy} người</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.propertyType}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-building"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Loại chỗ ở</div>
                                                        <div class="info-value">${fn:escapeXml(content.propertyType)}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.bathrooms}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-bath"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Số phòng tắm</div>
                                                        <div class="info-value">${content.bathrooms} phòng</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty content.amenities}">
                                                <div class="info-item">
                                                    <div class="info-icon">
                                                        <i class="fas fa-concierge-bell"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Tiện nghi</div>
                                                        <div class="info-value">${fn:escapeXml(content.amenities)}</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:if>
                                        
                                        <!-- Empty state if no details -->
                                        <c:if test="${(isExperience and empty content.duration and empty content.maxGroupSize and empty content.difficulty and empty content.language) or 
                                                      (not isExperience and empty content.numberOfRooms and empty content.maxOccupancy and empty content.amenities)}">
                                            <div class="text-center py-4">
                                                <i class="fas fa-info-circle fa-2x text-muted mb-2"></i>
                                                <h6 class="text-muted">Chưa có thông tin chi tiết</h6>
                                                <p class="text-muted small mb-0">
                                                    Host chưa cung cấp thông tin chi tiết cho ${isExperience ? 'trải nghiệm' : 'chỗ ở'} này.
                                                </p>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-times-circle me-2"></i>
                        Từ chối nội dung
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="rejectForm" method="POST">
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Bạn đang từ chối nội dung "<strong id="rejectContentName"></strong>".
                            Host sẽ nhận được thông báo và có thể chỉnh sửa nội dung.
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                Lý do từ chối <span class="text-danger">*</span>
                            </label>
                            <textarea class="form-control" name="reason" rows="4" required 
                                      placeholder="Vui lòng nhập lý do từ chối cụ thể để host có thể hiểu và cải thiện..."></textarea>
                            <div class="form-text">Lý do này sẽ được gửi đến host</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Lý do thông thường</label>
                            <div class="d-flex flex-wrap gap-2">
                                <button type="button" class="btn reason-btn" 
                                        onclick="addReason('Nội dung không phù hợp với tiêu chuẩn cộng đồng')">
                                    Không phù hợp
                                </button>
                                <button type="button" class="btn reason-btn" 
                                        onclick="addReason('Cần bổ sung thêm thông tin chi tiết')">
                                    Thiếu thông tin
                                </button>
                                <button type="button" class="btn reason-btn" 
                                        onclick="addReason('Hình ảnh chất lượng chưa tốt')">
                                    Hình ảnh kém
                                </button>
                                <button type="button" class="btn reason-btn" 
                                        onclick="addReason('Giá cả chưa phù hợp')">
                                    Giá chưa hợp lý
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Hủy bỏ
                        </button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-ban me-1"></i>Xác nhận từ chối
                        </button>
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
                btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang duyệt...';
                btn.disabled = true;
                btn.classList.add('btn-loading');

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
                        showToast('✅ Duyệt thành công!', 'success');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/admin/content/approval';
                        }, 1500);
                    } else {
                        showToast('❌ ' + (data.message || 'Không thể duyệt nội dung'), 'error');
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                        btn.classList.remove('btn-loading');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('❌ Có lỗi xảy ra, vui lòng thử lại', 'error');
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
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
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');
            
            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body">${message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            `;
            
            document.getElementById('toastContainer').appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', () => toast.remove());
        }

        // Reject form submission
        document.getElementById('rejectForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const btn = this.querySelector('button[type="submit"]');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang từ chối...';
            btn.disabled = true;
            btn.classList.add('btn-loading');
            
            const reason = this.querySelector('textarea[name="reason"]').value;
            if (!reason || reason.trim() === '') {
                showToast('⚠️ Vui lòng nhập lý do từ chối', 'error');
                btn.innerHTML = originalText;
                btn.disabled = false;
                btn.classList.remove('btn-loading');
                return;
            }
            
            const formData = new URLSearchParams();
            formData.append('reason', reason);
            
            fetch(this.action, {
                method: 'POST',
                body: formData,
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest' 
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('✅ Từ chối thành công!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/admin/content/approval';
                    }, 1500);
                } else {
                    showToast('❌ ' + (data.message || 'Không thể từ chối nội dung'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('❌ Có lỗi xảy ra, vui lòng thử lại', 'error');
            })
            .finally(() => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                btn.classList.remove('btn-loading');
            });
        });

        // Reset modal when hidden
        document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('rejectForm').reset();
        });
        
        // Add reason to textarea
        function addReason(reasonText) {
            const textarea = document.querySelector('#rejectForm textarea[name="reason"]');
            const currentText = textarea.value.trim();
            
            if (currentText === '') {
                textarea.value = reasonText;
            } else {
                textarea.value = currentText + '\n\n' + reasonText;
            }
            
            textarea.focus();
            textarea.scrollTop = textarea.scrollHeight;
            
            // Visual feedback
            textarea.style.backgroundColor = '#e7f3ff';
            setTimeout(() => {
                textarea.style.backgroundColor = '';
            }, 300);
        }
        
        // Reason button effects
        document.querySelectorAll('.reason-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // Visual feedback
                this.style.backgroundColor = '#667eea';
                this.style.color = 'white';
                
                setTimeout(() => {
                    this.style.backgroundColor = '';
                    this.style.color = '';
                }, 300);
            });
        });

        // DOM Ready
        document.addEventListener('DOMContentLoaded', function() {
            // Simple animations
            const elements = document.querySelectorAll('.fade-in');
            elements.forEach((el, index) => {
                el.style.animationDelay = (index * 0.1) + 's';
            });

            // Image error handling
            document.querySelectorAll('img').forEach(img => {
                img.addEventListener('error', function() {
                    if (this.nextElementSibling && this.nextElementSibling.classList.contains('image-fallback')) {
                        this.style.display = 'none';
                        this.nextElementSibling.style.display = 'flex';
                    }
                });
            });

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    const openModals = document.querySelectorAll('.modal.show');
                    openModals.forEach(modal => {
                        bootstrap.Modal.getInstance(modal)?.hide();
                    });
                }
            });

            // Auto-save draft (simple version)
            const reasonTextarea = document.querySelector('textarea[name="reason"]');
            if (reasonTextarea) {
                reasonTextarea.addEventListener('input', function() {
                    if (this.value.trim().length > 10) {
                        sessionStorage.setItem('draftReason', this.value);
                    }
                });

                // Restore draft
                document.getElementById('rejectModal').addEventListener('shown.bs.modal', function() {
                    const draft = sessionStorage.getItem('draftReason');
                    if (draft && !reasonTextarea.value.trim()) {
                        reasonTextarea.value = draft;
                    }
                });

                // Clear draft on submit
                document.getElementById('rejectForm').addEventListener('submit', function() {
                    sessionStorage.removeItem('draftReason');
                });
            }

            // Copy ID feature
            document.querySelectorAll('.host-card').forEach(card => {
                const hostId = card.textContent.match(/ID:\s*(\d+)/);
                if (hostId) {
                    card.style.cursor = 'pointer';
                    card.title = 'Nhấp để sao chép ID';
                    
                    card.addEventListener('click', function() {
                        navigator.clipboard.writeText(hostId[1]).then(() => {
                            showToast('📋 Đã sao chép ID: ' + hostId[1], 'success');
                        }).catch(() => {
                            showToast('❌ Không thể sao chép ID', 'error');
                        });
                    });
                }
            });

            // Enhanced hover effects
            document.querySelectorAll('.simple-hover').forEach(el => {
                el.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                    this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
                });
                
                el.addEventListener('mouseleave', function() {
                    this.style.transform = '';
                    this.style.boxShadow = '';
                });
            });

            // Welcome message for first-time users
            if (!sessionStorage.getItem('welcomeShown')) {
                setTimeout(() => {
                    showToast('👋 Chào mừng! Sử dụng các nút hành động để duyệt nội dung', 'info');
                    sessionStorage.setItem('welcomeShown', 'true');
                }, 1000);
            }
        });

        // Performance monitoring (simplified)
        window.addEventListener('load', function() {
            const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
            if (loadTime > 3000) {
                console.warn('⚠️ Page load time is slow:', loadTime + 'ms');
            }
        });

        // Network status
        window.addEventListener('online', () => showToast('🌐 Kết nối mạng đã khôi phục', 'success'));
        window.addEventListener('offline', () => showToast('📶 Mất kết nối mạng', 'error'));

        // Cleanup
        window.addEventListener('beforeunload', function() {
            sessionStorage.removeItem('draftReason');
        });
    </script>
</body>
</html>