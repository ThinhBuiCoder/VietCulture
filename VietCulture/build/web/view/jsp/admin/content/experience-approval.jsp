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
        <title>Duyệt Experiences - Admin</title>
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
            .experience-card {
                transition: transform 0.2s;
                border: none;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .experience-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }
            .experience-image {
                height: 200px;
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
                        <h1 class="h2"><i class="fas fa-check-circle me-2"></i>Duyệt Experiences</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-success" onclick="approveAll()">
                                    <i class="fas fa-check-double me-1"></i>Duyệt tất cả
                                </button>
                            </div>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-filter me-1"></i>Lọc
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item ${param.filter eq 'pending' ? 'active' : ''}" href="?filter=pending">Chờ duyệt</a></li>
                                    <li><a class="dropdown-item ${param.filter eq 'approved' ? 'active' : ''}" href="?filter=approved">Đã duyệt</a></li>
                                    <li><a class="dropdown-item ${param.filter eq 'rejected' ? 'active' : ''}" href="?filter=rejected">Bị từ chối</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item ${empty param.filter ? 'active' : ''}" href="?">Tất cả</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Buttons (Alternative mobile-friendly version) -->
                    <div class="filter-buttons d-md-none mb-3">
                        <a href="?" class="btn btn-sm ${empty param.filter ? 'btn-primary' : 'btn-outline-primary'}">Tất cả</a>
                        <a href="?filter=pending" class="btn btn-sm ${param.filter eq 'pending' ? 'btn-warning' : 'btn-outline-warning'}">Chờ duyệt</a>
                        <a href="?filter=approved" class="btn btn-sm ${param.filter eq 'approved' ? 'btn-success' : 'btn-outline-success'}">Đã duyệt</a>
                        <a href="?filter=rejected" class="btn btn-sm ${param.filter eq 'rejected' ? 'btn-danger' : 'btn-outline-danger'}">Bị từ chối</a>
                    </div>

                    <!-- Statistics -->
                    <div class="row mb-4">
                        <div class="col-md-3 col-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-warning mb-2">
                                        <i class="fas fa-clock fa-2x"></i>
                                    </div>
                                    <h5 class="card-title text-warning">${pendingCount != null ? pendingCount : 0}</h5>
                                    <p class="card-text mb-0">Chờ duyệt</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-success mb-2">
                                        <i class="fas fa-check-circle fa-2x"></i>
                                    </div>
                                    <h5 class="card-title text-success">${approvedCount != null ? approvedCount : 0}</h5>
                                    <p class="card-text mb-0">Đã duyệt</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-danger mb-2">
                                        <i class="fas fa-times-circle fa-2x"></i>
                                    </div>
                                    <h5 class="card-title text-danger">${rejectedCount != null ? rejectedCount : 0}</h5>
                                    <p class="card-text mb-0">Bị từ chối</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-info mb-2">
                                        <i class="fas fa-list fa-2x"></i>
                                    </div>
                                    <h5 class="card-title text-info">${totalCount != null ? totalCount : 0}</h5>
                                    <p class="card-text mb-0">Tổng cộng</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Experiences List -->
                    <div class="row">
                        <c:forEach var="experience" items="${experiences}">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card experience-card h-100 
                                     ${experience.isActive == 0 ? 'status-pending' : ''} 
                                     ${experience.isActive == -1 ? 'status-rejected' : ''}">

                                    <!-- Experience Image -->
                                    <div class="position-relative">
                                        <c:choose>
                                            <c:when test="${not empty experience.images}">
                                                <c:set var="imageArray" value="${fn:split(experience.images, ',')}" />
                                                <c:set var="firstImage" value="${fn:trim(imageArray[0])}" />
                                                <img src="${pageContext.request.contextPath}/assets/images/experiences/${firstImage}" 
                                                     class="card-img-top experience-image" 
                                                     alt="${experience.title}"
                                                     data-lightbox="experience-${experience.experienceId}"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                <div class="card-img-top experience-image bg-light d-flex align-items-center justify-content-center" style="display: none;">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="card-img-top experience-image bg-light d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Status Badge -->
                                        <div class="position-absolute top-0 end-0 m-2">
                                            <c:choose>
                                                <c:when test="${experience.isActive == 1}">
                                                    <span class="badge bg-success">Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${experience.isActive == -1}">
                                                    <span class="badge bg-danger">Bị từ chối</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning">Chờ duyệt</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Type Badge -->
                                        <div class="position-absolute top-0 start-0 m-2">
                                            <span class="badge bg-primary">${experience.type != null ? experience.type : 'N/A'}</span>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <!-- Title -->
                                        <h5 class="card-title">${experience.title}</h5>

                                        <!-- Location -->
                                        <p class="text-muted mb-2">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            ${experience.location}
                                            <c:if test="${not empty experience.cityName}">
                                                , ${experience.cityName}
                                            </c:if>
                                        </p>

                                        <!-- Description -->
                                        <p class="card-text">
                                            <c:choose>
                                                <c:when test="${fn:length(experience.description) > 100}">
                                                    ${fn:substring(experience.description, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${experience.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>

                                        <!-- Experience Details -->
                                        <div class="row text-sm mb-3">
                                            <div class="col-6">
                                                <small class="text-muted">
                                                    <i class="fas fa-dollar-sign me-1"></i>
                                                    <fmt:formatNumber value="${experience.price}" type="currency" currencySymbol="$"/>
                                                </small>
                                            </div>
                                            <div class="col-6">
                                                <small class="text-muted">
                                                    <i class="fas fa-users me-1"></i>
                                                    Tối đa ${experience.maxGroupSize} người
                                                </small>
                                            </div>
                                            <c:if test="${not empty experience.duration}">
                                                <div class="col-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-clock me-1"></i>
                                                        <fmt:formatDate value="${experience.duration}" pattern="HH'h'mm"/>
                                                    </small>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty experience.difficulty}">
                                                <div class="col-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-signal me-1"></i>
                                                        ${experience.difficulty}
                                                    </small>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Host Info -->
                                        <div class="host-info mb-3">
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty experience.hostName}">
                                                        <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center me-2" 
                                                             style="width: 40px; height: 40px;">
                                                            <span class="text-white fw-bold">
                                                                ${fn:substring(experience.hostName, 0, 1)}
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
                                                    <strong>${experience.hostName != null ? experience.hostName : 'N/A'}</strong>
                                                    <br>
                                                    <small class="text-muted">Host ID: ${experience.hostId}</small>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Additional Info -->
                                        <c:if test="${not empty experience.language}">
                                            <p class="mb-1">
                                                <small>
                                                    <i class="fas fa-language me-1"></i>
                                                    <strong>Ngôn ngữ:</strong> ${experience.language}
                                                </small>
                                            </p>
                                        </c:if>

                                        <c:if test="${not empty experience.includedItems}">
                                            <p class="mb-1">
                                                <small>
                                                    <i class="fas fa-gift me-1"></i>
                                                    <strong>Bao gồm:</strong> 
                                                    <c:choose>
                                                        <c:when test="${fn:length(experience.includedItems) > 50}">
                                                            ${fn:substring(experience.includedItems, 0, 50)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${experience.includedItems}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </p>
                                        </c:if>

                                        <!-- Created Date -->
                                        <p class="text-muted mb-0">
                                            <small>
                                                <i class="fas fa-calendar me-1"></i>
                                                Tạo ngày: <fmt:formatDate value="${experience.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </p>
                                    </div>

                                    <!-- Actions for Pending -->
                                    <c:if test="${experience.isActive == 0}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2 mb-2">
                                                <button type="button" 
                                                        class="btn btn-success btn-sm flex-fill" 
                                                        onclick="approveExperience(${experience.experienceId})">
                                                    <i class="fas fa-check me-1"></i>Duyệt
                                                </button>
                                                <button type="button" 
                                                        class="btn btn-danger btn-sm flex-fill" 
                                                        onclick="rejectExperience(${experience.experienceId}, '${fn:escapeXml(experience.title)}')">
                                                    <i class="fas fa-times me-1"></i>Từ chối
                                                </button>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/experiences/${experience.experienceId}" 
                                                   class="btn btn-outline-primary btn-sm flex-fill">
                                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                                </a>
                                                <c:if test="${not empty experience.images}">
                                                    <button type="button" 
                                                            class="btn btn-outline-info btn-sm flex-fill" 
                                                            onclick="showAllImages(${experience.experienceId}, '${fn:escapeXml(experience.images)}')">
                                                        <i class="fas fa-images me-1"></i>Hình ảnh
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Actions for Approved -->
                                    <c:if test="${experience.isActive == 1}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2">
                                                <button type="button" 
                                                        class="btn btn-warning btn-sm flex-fill" 
                                                        onclick="revokeApproval(${experience.experienceId}, '${fn:escapeXml(experience.title)}')">
                                                    <i class="fas fa-undo me-1"></i>Thu hồi duyệt
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/experiences/${experience.experienceId}" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Actions for Rejected -->
                                    <c:if test="${experience.isActive == -1}">
                                        <div class="approval-actions">
                                            <div class="d-flex gap-2">
                                                <button type="button" 
                                                        class="btn btn-success btn-sm flex-fill" 
                                                        onclick="approveExperience(${experience.experienceId})">
                                                    <i class="fas fa-check me-1"></i>Duyệt lại
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/experiences/${experience.experienceId}" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                                </a>
                                            </div>
                                            <c:if test="${not empty experience.rejectionReason}">
                                                <div class="mt-2">
                                                    <small class="text-danger">
                                                        <i class="fas fa-info-circle me-1"></i>
                                                        <strong>Lý do từ chối:</strong> ${experience.rejectionReason}
                                                    </small>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Empty State -->
                        <c:if test="${empty experiences}">
                            <div class="col-12">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h4 class="text-muted">Không có experience nào</h4>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${param.filter eq 'pending'}">
                                                Không có experience nào đang chờ duyệt.
                                            </c:when>
                                            <c:when test="${param.filter eq 'approved'}">
                                                Chưa có experience nào được duyệt.
                                            </c:when>
                                            <c:when test="${param.filter eq 'rejected'}">
                                                Không có experience nào bị từ chối.
                                            </c:when>
                                            <c:otherwise>
                                                Chưa có experience nào trong hệ thống.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Experience pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&filter=${param.filter}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${pageNum}&filter=${param.filter}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&filter=${param.filter}">
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
                        <h5 class="modal-title">Từ chối Experience</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="rejectForm" method="POST">
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn từ chối experience <strong id="rejectExperienceName"></strong>?</p>
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
                        <h5 class="modal-title">Hình ảnh Experience</h5>
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
                            <p>Bạn có chắc chắn muốn thu hồi duyệt cho experience <strong id="revokeExperienceName"></strong>?</p>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Experience sẽ bị ẩn khỏi website và các booking hiện tại có thể bị ảnh hưởng.
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/lightbox2@2.11.3/dist/js/lightbox.min.js"></script>

        <script>
                                                            // Configure lightbox
                                                            lightbox.option({
                                                                'resizeDuration': 200,
                                                                'wrapAround': true,
                                                                'albumLabel': 'Hình %1 / %2'
                                                            });

                                                            function approveExperience(experienceId) {
                                                                if (confirm('Bạn có chắc chắn muốn duyệt experience này?')) {
                                                                    const loadingBtn = event.target;
                                                                    const originalContent = loadingBtn.innerHTML;
                                                                    loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                                                                    loadingBtn.disabled = true;

                                                                    fetch('${pageContext.request.contextPath}/admin/experiences/' + experienceId + '/approve', {
                                                                        method: 'POST',
                                                                        headers: {
                                                                            'Content-Type': 'application/json',
                                                                            'X-Requested-With': 'XMLHttpRequest'
                                                                        }
                                                                    })
                                                                            .then(response => response.json())
                                                                            .then(data => {
                                                                                if (data.success) {
                                                                                    showToast('Experience đã được duyệt thành công!', 'success');
                                                                                    setTimeout(() => location.reload(), 1500);
                                                                                } else {
                                                                                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể duyệt experience'), 'error');
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

                                                            function rejectExperience(experienceId, experienceName) {
                                                                document.getElementById('rejectExperienceName').textContent = experienceName;
                                                                document.getElementById('rejectForm').action = '${pageContext.request.contextPath}/admin/experiences/' + experienceId + '/reject';
                                                                new bootstrap.Modal(document.getElementById('rejectModal')).show();
                                                            }

                                                            function revokeApproval(experienceId, experienceName) {
                                                                document.getElementById('revokeExperienceName').textContent = experienceName;
                                                                document.getElementById('revokeForm').action = '${pageContext.request.contextPath}/admin/experiences/' + experienceId + '/revoke';
                                                                new bootstrap.Modal(document.getElementById('revokeModal')).show();
                                                            }

                                                            function approveAll() {
                                                                if (confirm('Bạn có chắc chắn muốn duyệt TẤT CẢ experiences đang chờ?')) {
                                                                    const loadingBtn = event.target;
                                                                    const originalContent = loadingBtn.innerHTML;
                                                                    loadingBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                                                                    loadingBtn.disabled = true;

                                                                    fetch('${pageContext.request.contextPath}/admin/experiences/approve-all', {
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
                                                                                    showToast('Đã duyệt ' + count + ' experience thành công!', 'success');
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

                                                            function showAllImages(experienceId, imagesString) {
                                                                const gallery = document.getElementById('imageGallery');
                                                                gallery.innerHTML = '';

                                                                if (imagesString && imagesString.trim() !== '') {
                                                                    const images = imagesString.split(',').map(img => img.trim()).filter(img => img !== '');

                                                                    if (images.length > 0) {
                                                                        images.forEach((image, index) => {
                                                                            const col = document.createElement('div');
                                                                            col.className = 'col-md-4 col-6 mb-2';
                                                                            col.innerHTML =
                                                                                    '<img src="${pageContext.request.contextPath}/assets/images/experiences/' + encodeURIComponent(image) + '" ' +
                                                                                    'class="img-fluid rounded shadow-sm" ' +
                                                                                    'style="height: 150px; width: 100%; object-fit: cover; cursor: pointer;" ' +
                                                                                    'data-lightbox="gallery-' + experienceId + '" ' +
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
                                                                toast.addEventListener('hidden.bs.toast', function () {
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
                                                                return text.replace(/[&<>"']/g, function (m) {
                                                                    return map[m];
                                                                });
                                                            }

                                                            // Handle form submissions
                                                            document.getElementById('rejectForm').addEventListener('submit', function (e) {
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
                                                                                showToast('Experience đã bị từ chối!', 'success');
                                                                                bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
                                                                                setTimeout(() => location.reload(), 1500);
                                                                            } else {
                                                                                showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể từ chối experience'), 'error');
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

                                                            document.getElementById('revokeForm').addEventListener('submit', function (e) {
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
                                                                                showToast('Đã thu hồi duyệt experience!', 'success');
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

                                                            // Reset form when modal is hidden
                                                            document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function () {
                                                                document.getElementById('rejectForm').reset();
                                                            });

                                                            document.getElementById('revokeModal').addEventListener('hidden.bs.modal', function () {
                                                                document.getElementById('revokeForm').reset();
                                                            });

                                                            // Auto-refresh every 5 minutes if on pending filter
                                                            if ('${param.filter}' === 'pending' || '${param.filter}' === '') {
                                                                setInterval(function () {
                                                                    // Only refresh if user is still on the page
                                                                    if (document.visibilityState === 'visible') {
                                                                        location.reload();
                                                                    }
                                                                }, 300000); // 5 minutes
                                                            }
        </script>
    </body>
</html>