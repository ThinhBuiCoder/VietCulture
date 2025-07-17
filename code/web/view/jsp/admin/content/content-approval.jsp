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
            border-radius: 8px 8px 0 0;
        }
        
        /* Status styles */
        .status-pending { background-color: #fff3cd; border-color: #ffeaa7; }
        .status-approved { background-color: #d1edff; border-color: #bee5eb; }
        .status-rejected { background-color: #f8d7da; border-color: #f5c6cb; }
        
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
        .content-type-badge {
            position: absolute;
            top: 8px;
            left: 8px;
            z-index: 10;
        }
        .experience-badge { background: linear-gradient(45deg, #ff6b6b, #ee5a52); }
        .accommodation-badge { background: linear-gradient(45deg, #4ecdc4, #45b7af); }
        
        /* Image fallback */
        .image-fallback {
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px 8px 0 0;
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
                    <h1 class="h2"><i class="fas fa-check-circle me-2"></i>Duyệt Nội Dung</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-success" onclick="approveAll()">
                                <i class="fas fa-check-double me-1"></i>Duyệt tất cả
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
                                <li><a class="dropdown-item ${currentFilter eq 'rejected' ? 'active' : ''}" href="?filter=rejected&contentType=${currentContentType}">Bị từ chối</a></li>
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
                                    <i class="fas fa-times-circle fa-2x"></i>
                                </div>
                                <h5 class="card-title text-danger">${stats.totalRejected}</h5>
                                <p class="card-text mb-0 small">Bị từ chối</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-info mb-2">
                                    <i class="fas fa-map-marked-alt fa-2x"></i>
                                </div>
                                <h5 class="card-title text-info">${stats.experienceTotal}</h5>
                                <p class="card-text mb-0 small">Tổng Exp</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-primary mb-2">
                                    <i class="fas fa-home fa-2x"></i>
                                </div>
                                <h5 class="card-title text-primary">${stats.accommodationTotal}</h5>
                                <p class="card-text mb-0 small">Tổng Acc</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4 col-6 mb-3">
                        <div class="card text-center stats-card h-100">
                            <div class="card-body">
                                <div class="text-secondary mb-2">
                                    <i class="fas fa-eye-slash fa-2x"></i>
                                </div>
                                <h5 class="card-title text-secondary">${stats.experienceHidden + stats.accommodationHidden}</h5>
                                <p class="card-text mb-0 small">Host ẩn</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Content List -->
                <div class="row">
                    <c:if test="${not empty contentItems}">
                        <c:forEach var="item" items="${contentItems}">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card content-card h-100 
                                    <c:choose>
                                        <c:when test="${item.adminApprovalStatus eq 'PENDING'}">status-pending</c:when>
                                        <c:when test="${item.adminApprovalStatus eq 'APPROVED'}">status-approved</c:when>
                                        <c:when test="${item.adminApprovalStatus eq 'REJECTED'}">status-rejected</c:when>
                                        <c:otherwise>status-pending</c:otherwise>
                                    </c:choose>">
                                    
                                    <!-- Content Image - ĐỒNG NHẤT VỚI ImageServlet -->
                                    <div class="position-relative">
                                        <c:choose>
                                            <c:when test="${not empty item.images}">
                                                <c:set var="imageArray" value="${fn:split(item.images, ',')}" />
                                                <c:set var="firstImage" value="${fn:trim(imageArray[0])}" />
                                                <c:choose>
                                                    <c:when test="${not empty firstImage}">
                                                        <!-- ĐỒNG NHẤT: Sử dụng cùng đường dẫn với ImageServlet -->
                                                        <img src="${pageContext.request.contextPath}/images/${item.type}s/${firstImage}" 
                                                             class="card-img-top content-image" 
                                                             alt="${fn:escapeXml(item.title)}"
                                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                        
                                                        <div class="image-fallback" style="display: none;">
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
                                                                <div class="small text-muted">Tên ảnh không hợp lệ</div>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
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
                                        
                                        <!-- Status Badge -->
                                        <div class="position-absolute top-0 end-0 m-2">
                                            <c:choose>
                                                <c:when test="${item.adminApprovalStatus eq 'PENDING'}">
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="fas fa-clock me-1"></i>Chờ duyệt
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.adminApprovalStatus eq 'APPROVED'}">
                                                    <c:choose>
                                                        <c:when test="${item.active}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check me-1"></i>Đang hiển thị
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="fas fa-eye-slash me-1"></i>Host ẩn
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:when test="${item.adminApprovalStatus eq 'REJECTED'}">
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-times me-1"></i>Bị từ chối
                                                    </span>
                                                </c:when>
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
                                        
                                        <!-- Price -->
                                        <div class="mb-2">
                                            <span class="h6 text-primary">
                                                <i class="fas fa-dollar-sign me-1"></i>
                                                <fmt:formatNumber value="${item.price}" pattern="#,###"/> VND
                                                <c:if test="${item.type eq 'accommodation'}"> /đêm</c:if>
                                            </span>
                                        </div>
                                        
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
                                        
                                        <!-- Host Info -->
                                        <div class="host-info mb-3">
                                            <div class="d-flex align-items-center">
                                                <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center me-2" 
                                                     style="width: 40px; height: 40px;">
                                                    <span class="text-white fw-bold">
                                                        ${fn:escapeXml(fn:substring(item.hostName != null ? item.hostName : 'N', 0, 1))}
                                                    </span>
                                                </div>
                                                <div>
                                                    <strong>${fn:escapeXml(item.hostName != null ? item.hostName : 'N/A')}</strong>
                                                    <br>
                                                    <small class="text-muted">Host ID: ${item.hostId}</small>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Created Date -->
                                        <p class="text-muted mb-0">
                                            <small>
                                                <i class="fas fa-calendar me-1"></i>
                                                Tạo ngày: <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </p>
                                        
                                        <!-- Reject Reason -->
                                        <c:if test="${item.adminApprovalStatus eq 'REJECTED' and not empty item.adminRejectReason}">
                                            <div class="alert alert-danger mt-2 p-2">
                                                <small>
                                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                                    <strong>Lý do từ chối:</strong> ${fn:escapeXml(item.adminRejectReason)}
                                                </small>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <c:if test="${item.adminApprovalStatus eq 'PENDING'}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2 mb-2">
                                                <button type="button" 
                                                        class="btn btn-success btn-sm flex-fill" 
                                                        onclick="approveContent('${item.type}', '${item.id}')">
                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                </button>
                                                <button type="button" 
                                                        class="btn btn-danger btn-sm flex-fill" 
                                                        onclick="rejectContent('${item.type}', '${item.id}', '${fn:escapeXml(item.title)}')">
                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                </button>
                                            </div>
                                            
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/content/approval/${item.type}/${item.id}" 
                                                   class="btn btn-outline-primary btn-sm flex-fill">
                                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                                </a>
                                                <c:if test="${not empty item.images}">
                                                    <button type="button" 
                                                            class="btn btn-outline-info btn-sm flex-fill" 
                                                            onclick="showAllImages('${item.type}', '${item.id}', '${fn:escapeXml(item.images)}')">
                                                        <i class="fas fa-images me-1"></i>Hình ảnh
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${item.adminApprovalStatus eq 'APPROVED'}">
                                        <div class="approval-actions">
                                            <a href="${pageContext.request.contextPath}/admin/content/approval/${item.type}/${item.id}" 
                                               class="btn btn-outline-primary btn-sm w-100">
                                                <i class="fas fa-eye me-1"></i>Xem chi tiết
                                            </a>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${item.adminApprovalStatus eq 'REJECTED'}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2">
                                                <button type="button" 
                                                        class="btn btn-success btn-sm flex-fill" 
                                                        onclick="approveContent('${item.type}', '${item.id}')">
                                                    <i class="fas fa-check me-1"></i>Duyệt lại
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/content/approval/${item.type}/${item.id}" 
                                                   class="btn btn-outline-primary btn-sm flex-fill">
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
                                        <c:when test="${currentFilter eq 'rejected'}">
                                            Chưa có nội dung nào bị từ chối.
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

    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Global variables
        let currentContentType = '';
        let currentContentId = 0;

        function approveContent(contentType, contentId) {
            if (confirm('Bạn có chắc chắn muốn duyệt nội dung này?')) {
                const loadingBtn = event.target;
                const originalContent = loadingBtn.innerHTML;
                loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                loadingBtn.disabled = true;

                const url = '${pageContext.request.contextPath}/admin/content/approval/' + contentType + '/' + contentId + '/approve';

                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
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
            document.getElementById('rejectContentName').textContent = contentName;
            document.getElementById('rejectForm').action = '${pageContext.request.contextPath}/admin/content/approval/' + contentType + '/' + contentId + '/reject';
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
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

                const url = '${pageContext.request.contextPath}/admin/content/approval/approve-all' + 
                           (contentType !== 'all' ? '?contentType=' + contentType : '');

                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
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

        function showAllImages(contentType, contentId, imagesString) {
            const gallery = document.getElementById('imageGallery');
            gallery.innerHTML = '';
            
            if (imagesString && imagesString.trim() !== '') {
                const images = imagesString.split(',').map(img => img.trim()).filter(img => img !== '');
                
                if (images.length > 0) {
                    images.forEach((image, index) => {
                        // ĐỒNG NHẤT: Sử dụng cùng đường dẫn với ImageServlet
                        const imagePath = '${pageContext.request.contextPath}/images/' + contentType + 's/' + encodeURIComponent(image);
                        
                        const col = document.createElement('div');
                        col.className = 'col-md-4 col-6 mb-2';
                        col.innerHTML = 
                            '<img src="' + imagePath + '" ' +
                            'class="img-fluid rounded shadow-sm" ' +
                            'style="height: 150px; width: 100%; object-fit: cover; cursor: pointer;" ' +
                            'alt="Hình ' + (index + 1) + '" ' +
                            'onclick="window.open(this.src, \'_blank\')" ' +
                            'onerror="this.parentElement.innerHTML=\'<div class=\\\"text-center p-3 border rounded\\\"><i class=\\\"fas fa-image-slash fa-2x text-muted mb-2\\\"></i><br><small class=\\\"text-muted\\\">Lỗi: ' + image + '</small></div>\'">';
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
                    '<div class="toast-body">' + message + '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', function() {
                toast.remove();
            });
        }

        // Form submission for reject
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

        // Reset form when modal is hidden
        document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('rejectForm').reset();
            document.getElementById('rejectContentName').textContent = '';
        });

        // DOM Ready
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize tooltips
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            tooltipTriggerList.forEach(tooltipTriggerEl => {
                new bootstrap.Tooltip(tooltipTriggerEl);
            });

            // Log image loading for debugging
            const images = document.querySelectorAll('.content-image');
            images.forEach(img => {
                img.addEventListener('load', function() {
                    console.log('✅ Image loaded:', this.src);
                });
                img.addEventListener('error', function() {
                    console.log('❌ Image failed:', this.src);
                });
            });
        });

        // Auto-refresh every 5 minutes if on pending filter
        if ('${currentFilter}' === 'pending' || '${currentFilter}' === '') {
            setInterval(function() {
                if (document.visibilityState === 'visible') {
                    location.reload();
                }
            }, 300000); // 5 minutes
        }
    </script>
</body>
</html>