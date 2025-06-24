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
        <title>Quản lý xóa nội dung - Admin VietCulture</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --success-gradient: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%);
                --danger-gradient: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                --warning-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .admin-sidebar {
                min-height: 100vh;
                background: var(--primary-gradient);
                color: white;
                position: sticky;
                top: 0;
            }

            .admin-content {
                background-color: #f8f9fa;
                min-height: 100vh;
            }

            .content-item {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: none;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                border-radius: 16px;
                overflow: hidden;
                background: white;
            }

            .content-item:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .content-type-badge {
                position: absolute;
                top: 8px;
                right: 8px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .content-type-experience {
                background: var(--success-gradient);
                color: white;
            }

            .content-type-accommodation {
                background: var(--info-gradient);
                color: white;
            }

            .content-type-user {
                background: var(--primary-gradient);
                color: white;
            }

            .content-type-review {
                background: var(--warning-gradient);
                color: white;
            }

            .delete-reason {
                background: linear-gradient(135deg, #fff5f5 0%, #fed7d7 100%);
                border: 1px solid #fed7d7;
                border-radius: 12px;
                padding: 12px;
                margin-top: 10px;
            }

            .content-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 12px;
            }

            .danger-zone {
                background: var(--danger-gradient);
                color: white;
                border-radius: 16px;
                padding: 24px;
                margin-bottom: 24px;
                box-shadow: 0 4px 20px rgba(255, 107, 107, 0.3);
            }

            .stats-card {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border-radius: 16px;
                border: none;
                background: white;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                overflow: hidden;
            }

            .stats-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.12);
            }

            .stats-card .card-body {
                padding: 1.5rem;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            .filter-tabs {
                border-bottom: 2px solid #e9ecef;
                margin-bottom: 24px;
                background: white;
                border-radius: 12px 12px 0 0;
                padding: 0 16px;
            }

            .filter-tabs .nav-link {
                border: none;
                border-bottom: 3px solid transparent;
                color: #6c757d;
                font-weight: 500;
                padding: 16px 20px;
                border-radius: 12px 12px 0 0;
                transition: all 0.3s ease;
            }

            .filter-tabs .nav-link:hover {
                color: #007bff;
                background-color: rgba(0, 123, 255, 0.05);
            }

            .filter-tabs .nav-link.active {
                border-bottom-color: #007bff;
                color: #007bff;
                background: linear-gradient(135deg, rgba(0, 123, 255, 0.1) 0%, rgba(0, 123, 255, 0.05) 100%);
            }

            .bulk-actions {
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                border-radius: 16px;
                padding: 20px;
                margin-bottom: 24px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                border: 1px solid #e9ecef;
            }

            .content-thumbnail {
                position: relative;
                overflow: hidden;
                border-radius: 12px;
            }

            .reported-badge {
                background: var(--danger-gradient);
                color: white;
                position: absolute;
                top: 4px;
                left: 4px;
                padding: 3px 8px;
                border-radius: 12px;
                font-size: 0.7rem;
                font-weight: 600;
            }

            .empty-state {
                padding: 60px 0;
                text-align: center;
            }

            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .btn {
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn:hover {
                transform: translateY(-1px);
            }

            .modal-content {
                border-radius: 16px;
                border: none;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            }

            .modal-header {
                border-bottom: 1px solid #e9ecef;
                padding: 24px;
            }

            .modal-body {
                padding: 24px;
            }

            .modal-footer {
                border-top: 1px solid #e9ecef;
                padding: 24px;
            }

            .toast {
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            }

            .page-link {
                border-radius: 8px;
                margin: 0 2px;
                border: none;
                color: #6c757d;
            }

            .page-item.active .page-link {
                background: var(--primary-gradient);
                border: none;
            }

            .dropdown-menu {
                border-radius: 12px;
                border: none;
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            }

            .form-control, .form-select {
                border-radius: 8px;
                border: 1px solid #e0e0e0;
                padding: 12px 16px;
            }

            .form-control:focus, .form-select:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

            @media (max-width: 768px) {
                .stats-card {
                    margin-bottom: 16px;
                }

                .content-item {
                    margin-bottom: 16px;
                }

                .action-buttons {
                    justify-content: center;
                }
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
                    <!-- Toggle button for mobile -->
                    <div class="d-md-none mb-3">
                        <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target=".admin-sidebar">
                            <i class="fas fa-bars"></i> Menu
                        </button>
                    </div>

                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">
                            <i class="fas fa-trash-alt me-2 text-danger"></i>Quản lý xóa nội dung
                        </h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="showBulkDelete()">
                                    <i class="fas fa-trash me-1"></i>Xóa hàng loạt
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-info" onclick="showRecycleBin()">
                                    <i class="fas fa-recycle me-1"></i>Thùng rác
                                </button>
                            </div>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-filter me-1"></i>Lọc
                                </button>
                                <ul class="dropdown-menu">
                                    <li><h6 class="dropdown-header">Loại nội dung</h6></li>
                                    <li><a class="dropdown-item" href="?type=experience">Experiences</a></li>
                                    <li><a class="dropdown-item" href="?type=accommodation">Accommodations</a></li>
                                    <li><a class="dropdown-item" href="?type=review">Reviews</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><h6 class="dropdown-header">Trạng thái</h6></li>
                                    <li><a class="dropdown-item" href="?tab=flagged">Bị đánh dấu</a></li>
                                    <li><a class="dropdown-item" href="?tab=pending">Chờ duyệt</a></li>
                                    <li><a class="dropdown-item" href="?tab=deleted">Đã xóa</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="?">Tất cả</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Danger Zone Alert -->
                    <div class="danger-zone">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                            <div>
                                <h5 class="mb-1">Khu vực nguy hiểm</h5>
                                <p class="mb-0">Hãy cẩn thận khi xóa nội dung. Một số thao tác không thể hoàn tác.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-warning mb-2">
                                        <i class="fas fa-flag fa-3x"></i>
                                    </div>
                                    <h4 class="card-title text-warning mb-1">${flaggedCount != null ? flaggedCount : 0}</h4>
                                    <p class="card-text mb-0 text-muted">Bị đánh dấu</p>
                                    <small class="text-muted">Vi phạm tiềm ẩn</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-info mb-2">
                                        <i class="fas fa-clock fa-3x"></i>
                                    </div>
                                    <h4 class="card-title text-info mb-1">${pendingCount != null ? pendingCount : 0}</h4>
                                    <p class="card-text mb-0 text-muted">Chờ duyệt</p>
                                    <small class="text-muted">Cần quyết định</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-secondary mb-2">
                                        <i class="fas fa-recycle fa-3x"></i>
                                    </div>
                                    <h4 class="card-title text-secondary mb-1">${deletedCount != null ? deletedCount : 0}</h4>
                                    <p class="card-text mb-0 text-muted">Đã xóa</p>
                                    <small class="text-muted">Trong thùng rác</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card text-center stats-card h-100">
                                <div class="card-body">
                                    <div class="text-success mb-2">
                                        <i class="fas fa-check-circle fa-3x"></i>
                                    </div>
                                    <h4 class="card-title text-success mb-1">
                                        ${(flaggedCount != null ? flaggedCount : 0) + (pendingCount != null ? pendingCount : 0) + (deletedCount != null ? deletedCount : 0)}
                                    </h4>
                                    <p class="card-text mb-0 text-muted">Tổng cộng</p>
                                    <small class="text-muted">Tất cả nội dung</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Tabs -->
                    <ul class="nav nav-tabs filter-tabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link ${param.tab eq 'flagged' or empty param.tab ? 'active' : ''}" 
                               href="?tab=flagged" role="tab">
                                <i class="fas fa-flag me-2"></i>Bị đánh dấu
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link ${param.tab eq 'pending' ? 'active' : ''}" 
                               href="?tab=pending" role="tab">
                                <i class="fas fa-clock me-2"></i>Chờ duyệt
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link ${param.tab eq 'deleted' ? 'active' : ''}" 
                               href="?tab=deleted" role="tab">
                                <i class="fas fa-recycle me-2"></i>Thùng rác
                            </a>
                        </li>
                    </ul>

                    <!-- Bulk Actions -->
                    <div class="bulk-actions">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="selectAll">
                                    <label class="form-check-label" for="selectAll">
                                        Chọn tất cả (<span id="selectedCount">0</span> mục)
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <div class="btn-group">
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="bulkDelete()" disabled id="bulkDeleteBtn">
                                        <i class="fas fa-trash me-1"></i>Xóa đã chọn
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-success" onclick="bulkRestore()" disabled id="bulkRestoreBtn">
                                        <i class="fas fa-undo me-1"></i>Khôi phục đã chọn
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Content List -->
                    <div class="row">
                        <c:forEach var="content" items="${contentList}">
                            <div class="col-lg-6 mb-4">
                                <div class="card content-item h-100">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-3">
                                                <div class="content-thumbnail">
                                                    <c:choose>
                                                        <c:when test="${not empty content.thumbnail}">
                                                            <img src="${content.thumbnail}" class="content-image" alt="Thumbnail">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="content-image bg-light d-flex align-items-center justify-content-center">
                                                                <i class="fas fa-image fa-2x text-muted"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <c:if test="${content.reportCount > 0}">
                                                        <span class="reported-badge">${content.reportCount} báo cáo</span>
                                                    </c:if>

                                                    <span class="content-type-badge content-type-${fn:toLowerCase(content.type)}">
                                                        ${content.type}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col-9">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div class="form-check">
                                                        <input class="form-check-input content-checkbox" type="checkbox" 
                                                               value="${content.id}" data-type="${content.type}">
                                                    </div>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                                type="button" data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#" onclick="viewContent('${content.type}', ${content.id})">
                                                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                                </a></li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li><a class="dropdown-item text-warning" href="#" onclick="softDelete('${content.type}', ${content.id})">
                                                                    <i class="fas fa-archive me-2"></i>Ẩn nội dung
                                                                </a></li>
                                                            <li><a class="dropdown-item text-danger" href="#" onclick="permanentDelete('${content.type}', ${content.id})">
                                                                    <i class="fas fa-trash me-2"></i>Xóa vĩnh viễn
                                                                </a></li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <h6 class="card-title mb-2">${content.title}</h6>

                                                <p class="card-text text-muted mb-2">
                                                    <small>
                                                        <c:choose>
                                                            <c:when test="${fn:length(content.description) > 80}">
                                                                ${fn:substring(content.description, 0, 80)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${content.description}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </p>

                                                <div class="mb-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-user me-1"></i>
                                                        ${content.authorName != null ? content.authorName : 'N/A'}
                                                    </small>
                                                    <br>
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${content.createdAt}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </div>

                                                <c:if test="${not empty content.deleteReason}">
                                                    <div class="delete-reason">
                                                        <small class="text-danger">
                                                            <i class="fas fa-info-circle me-1"></i>
                                                            <strong>Lý do:</strong> ${content.deleteReason}
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-footer bg-transparent">
                                        <div class="action-buttons">
                                            <c:choose>
                                                <c:when test="${content.isDeleted}">
                                                    <button type="button" class="btn btn-sm btn-outline-success" 
                                                            onclick="restoreContent('${content.type}', ${content.id})">
                                                        <i class="fas fa-undo me-1"></i>Khôi phục
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                            onclick="permanentDelete('${content.type}', ${content.id})">
                                                        <i class="fas fa-trash me-1"></i>Xóa vĩnh viễn
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-sm btn-outline-warning" 
                                                            onclick="softDelete('${content.type}', ${content.id})">
                                                        <i class="fas fa-archive me-1"></i>Ẩn
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-success" 
                                                            onclick="approveContent('${content.type}', ${content.id})">
                                                        <i class="fas fa-check me-1"></i>Duyệt
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Empty State -->
                        <c:if test="${empty contentList}">
                            <div class="col-12">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                                    <h4 class="text-muted">Không có nội dung nào</h4>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${param.tab eq 'flagged'}">
                                                Không có nội dung nào bị đánh dấu.
                                            </c:when>
                                            <c:when test="${param.tab eq 'pending'}">
                                                Không có nội dung nào chờ duyệt.
                                            </c:when>
                                            <c:when test="${param.tab eq 'deleted'}">
                                                Thùng rác trống.
                                            </c:when>
                                            <c:otherwise>
                                                Không có nội dung nào cần xử lý.
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
                                        <a class="page-link" href="?page=${currentPage - 1}&tab=${param.tab}&type=${param.type}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${pageNum}&tab=${param.tab}&type=${param.type}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&tab=${param.tab}&type=${param.type}">
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

        <!-- Modals -->
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="deleteForm">
                        <div class="modal-body">
                            <div class="text-center mb-3">
                                <i class="fas fa-exclamation-triangle fa-3x text-danger"></i>
                            </div>
                            <p class="text-center" id="deleteMessage"></p>
                            <div class="mb-3">
                                <label class="form-label">Lý do xóa <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="reason" rows="3" required 
                                          placeholder="Nhập lý do xóa nội dung này..."></textarea>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="sendNotification" id="sendNotification" checked>
                                <label class="form-check-label" for="sendNotification">
                                    Gửi thông báo cho tác giả
                                </label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-danger" id="confirmDeleteBtn">
                                <i class="fas fa-trash me-1"></i>Xóa
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bulk Delete Modal -->
        <div class="modal fade" id="bulkDeleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xóa hàng loạt</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="bulkDeleteForm">
                        <div class="modal-body">
                            <div class="text-center mb-3">
                                <i class="fas fa-exclamation-triangle fa-3x text-danger"></i>
                            </div>
                            <p class="text-center">Bạn có chắc chắn muốn xóa <strong id="bulkDeleteCount">0</strong> mục đã chọn?</p>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Hành động này không thể hoàn tác!
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Lý do xóa hàng loạt <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="bulkReason" rows="3" required 
                                          placeholder="Nhập lý do xóa hàng loạt..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-1"></i>Xóa tất cả
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Toast Container -->
        <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                const contextPath = '${pageContext.request.contextPath}';
                                                                let selectedItems = [];
                                                                let currentDeleteType = '';
                                                                let currentDeleteId = 0;

                                                                // Initialize
                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                    setupCheckboxHandlers();
                                                                });

                                                                function setupCheckboxHandlers() {
                                                                    const selectAllCheckbox = document.getElementById('selectAll');
                                                                    const contentCheckboxes = document.querySelectorAll('.content-checkbox');

                                                                    if (selectAllCheckbox) {
                                                                        selectAllCheckbox.addEventListener('change', function () {
                                                                            contentCheckboxes.forEach(checkbox => {
                                                                                checkbox.checked = this.checked;
                                                                            });
                                                                            updateSelectedItems();
                                                                        });
                                                                    }

                                                                    contentCheckboxes.forEach(checkbox => {
                                                                        checkbox.addEventListener('change', updateSelectedItems);
                                                                    });
                                                                }

                                                                function updateSelectedItems() {
                                                                    const checkboxes = document.querySelectorAll('.content-checkbox:checked');
                                                                    selectedItems = Array.from(checkboxes).map(cb => ({
                                                                            id: cb.value,
                                                                            type: cb.dataset.type
                                                                        }));

                                                                    const count = selectedItems.length;
                                                                    const selectedCountElement = document.getElementById('selectedCount');
                                                                    if (selectedCountElement) {
                                                                        selectedCountElement.textContent = count;
                                                                    }

                                                                    // Enable/disable bulk action buttons
                                                                    const bulkButtons = ['bulkDeleteBtn', 'bulkRestoreBtn'];
                                                                    bulkButtons.forEach(btnId => {
                                                                        const btn = document.getElementById(btnId);
                                                                        if (btn) {
                                                                            btn.disabled = count === 0;
                                                                        }
                                                                    });
                                                                }

                                                                function viewContent(type, id) {
                                                                    const url = `${contextPath}/admin/${type}s/${id}`;
                                                                            window.open(url, '_blank');
                                                                        }

                                                                        function softDelete(type, id) {
                                                                            currentDeleteType = type;
                                                                            currentDeleteId = id;
                                                                            document.getElementById('deleteMessage').textContent =
                                                                                    `Bạn có chắc chắn muốn ẩn ${type} này? Nội dung sẽ không hiển thị công khai nhưng vẫn có thể khôi phục.`;
                                                                            document.getElementById('confirmDeleteBtn').innerHTML = '<i class="fas fa-archive me-1"></i>Ẩn';
                                                                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                                                                        }

                                                                        function permanentDelete(type, id) {
                                                                            if (confirm(`Bạn có THỰC SỰ chắc chắn muốn xóa vĩnh viễn ${type} này?\n\nHành động này KHÔNG THỂ HOÀN TÁC!`)) {
                                                                                if (confirm('Lần xác nhận cuối cùng. Nội dung sẽ bị xóa hoàn toàn khỏi hệ thống!')) {
                                                                                    fetch(`${contextPath}/admin/content/permanent-delete`, {
                                                                                        method: 'DELETE',
                                                                                        headers: {
                                                                                            'Content-Type': 'application/json',
                                                                                            'X-Requested-With': 'XMLHttpRequest'
                                                                                        },
                                                                                        body: JSON.stringify({type: type, id: id})
                                                                                    })
                                                                                            .then(response => response.json())
                                                                                            .then(data => {
                                                                                                if (data.success) {
                                                                                                    showToast('Đã xóa vĩnh viễn nội dung!', 'success');
                                                                                                    setTimeout(() => location.reload(), 1500);
                                                                                                } else {
                                                                                                    showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể xóa'), 'error');
                                                                                                }
                                                                                            })
                                                                                            .catch(error => {
                                                                                                console.error('Error:', error);
                                                                                                showToast('Có lỗi xảy ra khi kết nối server', 'error');
                                                                                            });
                                                                                }
                                                                            }
                                                                        }

                                                                        function restoreContent(type, id) {
                                                                            if (confirm(`Bạn có chắc chắn muốn khôi phục ${type} này?`)) {
                                                                                fetch(`${contextPath}/admin/content/restore`, {
                                                                                    method: 'POST',
                                                                                    headers: {
                                                                                        'Content-Type': 'application/json',
                                                                                        'X-Requested-With': 'XMLHttpRequest'
                                                                                    },
                                                                                    body: JSON.stringify({type: type, id: id})
                                                                                })
                                                                                        .then(response => response.json())
                                                                                        .then(data => {
                                                                                            if (data.success) {
                                                                                                showToast('Đã khôi phục nội dung thành công!', 'success');
                                                                                                setTimeout(() => location.reload(), 1500);
                                                                                            } else {
                                                                                                showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể khôi phục'), 'error');
                                                                                            }
                                                                                        })
                                                                                        .catch(error => {
                                                                                            console.error('Error:', error);
                                                                                            showToast('Có lỗi xảy ra khi kết nối server', 'error');
                                                                                        });
                                                                            }
                                                                        }

                                                                        function approveContent(type, id) {
                                                                            if (confirm(`Bạn có chắc chắn muốn duyệt ${type} này?`)) {
                                                                                fetch(`${contextPath}/admin/content/approve`, {
                                                                                    method: 'POST',
                                                                                    headers: {
                                                                                        'Content-Type': 'application/json',
                                                                                        'X-Requested-With': 'XMLHttpRequest'
                                                                                    },
                                                                                    body: JSON.stringify({type: type, id: id})
                                                                                })
                                                                                        .then(response => response.json())
                                                                                        .then(data => {
                                                                                            if (data.success) {
                                                                                                showToast('Đã duyệt nội dung thành công!', 'success');
                                                                                                setTimeout(() => location.reload(), 1500);
                                                                                            } else {
                                                                                                showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể duyệt'), 'error');
                                                                                            }
                                                                                        })
                                                                                        .catch(error => {
                                                                                            console.error('Error:', error);
                                                                                            showToast('Có lỗi xảy ra khi kết nối server', 'error');
                                                                                        });
                                                                            }
                                                                        }

                                                                        function bulkDelete() {
                                                                            if (selectedItems.length === 0) {
                                                                                showToast('Vui lòng chọn ít nhất một mục', 'warning');
                                                                                return;
                                                                            }

                                                                            document.getElementById('bulkDeleteCount').textContent = selectedItems.length;
                                                                            new bootstrap.Modal(document.getElementById('bulkDeleteModal')).show();
                                                                        }

                                                                        function bulkRestore() {
                                                                            if (selectedItems.length === 0) {
                                                                                showToast('Vui lòng chọn ít nhất một mục', 'warning');
                                                                                return;
                                                                            }

                                                                            if (confirm(`Bạn có chắc chắn muốn khôi phục ${selectedItems.length} mục đã chọn?`)) {
                                                                                executeBulkAction('restore');
                                                                            }
                                                                        }

                                                                        function executeBulkAction(action, reason = '') {
                                                                            fetch(`${contextPath}/admin/content/bulk-action`, {
                                                                                method: 'POST',
                                                                                headers: {
                                                                                    'Content-Type': 'application/json',
                                                                                    'X-Requested-With': 'XMLHttpRequest'
                                                                                },
                                                                                body: JSON.stringify({
                                                                                    action: action,
                                                                                    items: selectedItems,
                                                                                    reason: reason
                                                                                })
                                                                            })
                                                                                    .then(response => response.json())
                                                                                    .then(data => {
                                                                                        if (data.success) {
                                                                                            let actionText = '';
                                                                                            switch (action) {
                                                                                                case 'delete':
                                                                                                    actionText = 'xóa';
                                                                                                    break;
                                                                                                case 'restore':
                                                                                                    actionText = 'khôi phục';
                                                                                                    break;
                                                                                                default:
                                                                                                    actionText = 'xử lý';
                                                                                            }
                                                                                            showToast(`Đã ${actionText} ${data.count || selectedItems.length} mục!`, 'success');
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

                                                                        function showBulkDelete() {
                                                                            showToast('Chọn các mục cần xóa bằng checkbox, sau đó nhấn "Xóa đã chọn"', 'info');
                                                                        }

                                                                        function showRecycleBin() {
                                                                            window.location.href = `${contextPath}/admin/content/delete?tab=deleted`;
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
                                                                                '&': '&',
                                                                                '<': '<',
                                                                                '>': '>',
                                                                                '"': '"',
                                                                                "'": '''
                                                                            };
                                                                            return text.replace(/[&<>"']/g, function (m) {
                                                                                return map[m];
                                                                            });
                                                                        }

                                                                        // Handle form submissions
                                                                        document.getElementById('deleteForm').addEventListener('submit', function (e) {
                                                                            e.preventDefault();

                                                                            const submitBtn = document.getElementById('confirmDeleteBtn');
                                                                            const originalContent = submitBtn.innerHTML;
                                                                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                                                                            submitBtn.disabled = true;

                                                                            const formData = new FormData(this);
                                                                            const data = {
                                                                                type: currentDeleteType,
                                                                                id: currentDeleteId,
                                                                                reason: formData.get('reason'),
                                                                                sendNotification: formData.get('sendNotification') === 'on'
                                                                            };

                                                                            fetch(`${contextPath}/admin/content/delete`, {
                                                                                method: 'POST',
                                                                                headers: {
                                                                                    'Content-Type': 'application/json',
                                                                                    'X-Requested-With': 'XMLHttpRequest'
                                                                                },
                                                                                body: JSON.stringify(data)
                                                                            })
                                                                                    .then(response => response.json())
                                                                                    .then(data => {
                                                                                        if (data.success) {
                                                                                            showToast('Đã xóa nội dung thành công!', 'success');
                                                                                            bootstrap.Modal.getInstance(document.getElementById('deleteModal')).hide();
                                                                                            setTimeout(() => location.reload(), 1500);
                                                                                        } else {
                                                                                            showToast('Có lỗi xảy ra: ' + (data.message || 'Không thể xóa'), 'error');
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

                                                                        document.getElementById('bulkDeleteForm').addEventListener('submit', function (e) {
                                                                            e.preventDefault();

                                                                            const formData = new FormData(this);
                                                                            executeBulkAction('delete', formData.get('bulkReason'));

                                                                            bootstrap.Modal.getInstance(document.getElementById('bulkDeleteModal')).hide();
                                                                        });

                                                                        // Reset forms when modals are hidden
                                                                        document.getElementById('deleteModal').addEventListener('hidden.bs.modal', function () {
                                                                            document.getElementById('deleteForm').reset();
                                                                        });

                                                                        document.getElementById('bulkDeleteModal').addEventListener('hidden.bs.modal', function () {
                                                                            document.getElementById('bulkDeleteForm').reset();
                                                                        });
        </script>
    </body>
</html>