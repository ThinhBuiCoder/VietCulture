<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Security check -->
<c:if test="${empty sessionScope.user or sessionScope.user.userType ne 'ADMIN'}">
    <c:redirect url="/login" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý xóa nội dung - Admin</title>
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
        .content-item {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        .content-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        .content-type-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .content-type-experience {
            background-color: #28a745;
            color: white;
        }
        .content-type-accommodation {
            background-color: #007bff;
            color: white;
        }
        .content-type-user {
            background-color: #6f42c1;
            color: white;
        }
        .content-type-review {
            background-color: #fd7e14;
            color: white;
        }
        .delete-reason {
            background-color: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: 8px;
            padding: 10px;
            margin-top: 8px;
        }
        .content-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        .danger-zone {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .warning-zone {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
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
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .filter-tabs {
            border-bottom: 2px solid #dee2e6;
            margin-bottom: 20px;
        }
        .filter-tabs .nav-link {
            border: none;
            border-bottom: 3px solid transparent;
            color: #6c757d;
            font-weight: 500;
        }
        .filter-tabs .nav-link.active {
            border-bottom-color: #007bff;
            color: #007bff;
            background: none;
        }
        .bulk-actions {
            background: linear-gradient(135deg, #e9ecef 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .content-thumbnail {
            position: relative;
            overflow: hidden;
            border-radius: 8px;
        }
        .reported-badge {
            background-color: #dc3545;
            color: white;
            position: absolute;
            top: 5px;
            left: 5px;
            padding: 2px 6px;
            border-radius: 8px;
            font-size: 0.7rem;
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
                                <li><a class="dropdown-item" href="?type=user">Users</a></li>
                                <li><a class="dropdown-item" href="?type=review">Reviews</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><h6 class="dropdown-header">Trạng thái</h6></li>
                                <li><a class="dropdown-item" href="?status=reported">Bị báo cáo</a></li>
                                <li><a class="dropdown-item" href="?status=flagged">Bị đánh dấu</a></li>
                                <li><a class="dropdown-item" href="?status=pending">Chờ xử lý</a></li>
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
                                <div class="text-danger mb-2">
                                    <i class="fas fa-exclamation-circle fa-3x"></i>
                                </div>
                                <h4 class="card-title text-danger mb-1">${reportedCount != null ? reportedCount : 0}</h4>
                                <p class="card-text mb-0 text-muted">Bị báo cáo</p>
                                <small class="text-muted">Cần xem xét</small>
                            </div>
                        </div>
                    </div>
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
                                <p class="card-text mb-0 text-muted">Chờ xử lý</p>
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
                </div>

                <!-- Filter Tabs -->
                <ul class="nav nav-tabs filter-tabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <a class="nav-link ${param.tab eq 'reported' or empty param.tab ? 'active' : ''}" 
                           href="?tab=reported" role="tab">
                            <i class="fas fa-exclamation-triangle me-2"></i>Bị báo cáo
                        </a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link ${param.tab eq 'flagged' ? 'active' : ''}" 
                           href="?tab=flagged" role="tab">
                            <i class="fas fa-flag me-2"></i>Bị đánh dấu
                        </a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link ${param.tab eq 'pending' ? 'active' : ''}" 
                           href="?tab=pending" role="tab">
                            <i class="fas fa-clock me-2"></i>Chờ xử lý
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
                                <button type="button" class="btn btn-sm btn-outline-warning" onclick="bulkSoftDelete()" disabled id="bulkSoftDeleteBtn">
                                    <i class="fas fa-archive me-1"></i>Ẩn đã chọn
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
                                                
                                                <c:if test="${content.isReported}">
                                                    <span class="reported-badge">Báo cáo</span>
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
                                                        <li><a class="dropdown-item" href="#" onclick="editContent('${content.type}', ${content.id})">
                                                            <i class="fas fa-edit me-2"></i>Chỉnh sửa
                                                        </a></li>
                                                        <li><hr class="dropdown-divider"></li>
                                                        <li><a class="dropdown-item text-warning" href="#" onclick="softDelete('${content.type}', ${content.id})">
                                                            <i class="fas fa-archive me-2"></i>Ẩn nội dung
                                                        </a></li>
                                                        <li><a class="dropdown-item text-danger" href="#" onclick="hardDelete('${content.type}', ${content.id})">
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
                                            
                                            <c:if test="${content.reportCount > 0}">
                                                <div class="mb-2">
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-exclamation-triangle me-1"></i>
                                                        ${content.reportCount} báo cáo
                                                    </span>
                                                </div>
                                            </c:if>
                                            
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
                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                        onclick="viewReports('${content.type}', ${content.id})">
                                                    <i class="fas fa-list me-1"></i>Xem báo cáo
                                                </button>
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
                                        <c:when test="${param.tab eq 'reported'}">
                                            Không có nội dung nào bị báo cáo.
                                        </c:when>
                                        <c:when test="${param.tab eq 'flagged'}">
                                            Không có nội dung nào bị đánh dấu.
                                        </c:when>
                                        <c:when test="${param.tab eq 'pending'}">
                                            Không có nội dung nào chờ xử lý.
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

    <!-- Reports Modal -->
    <div class="modal fade" id="reportsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Báo cáo vi phạm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="reportsList">
                        <!-- Reports will be loaded here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-success" onclick="dismissAllReports()">
                        <i class="fas fa-check me-1"></i>Bỏ qua tất cả báo cáo
                    </button>
                </div>
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
        let selectedItems = [];
        let currentDeleteType = '';
        let currentDeleteId = 0;

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Setup checkbox handlers
            setupCheckboxHandlers();
        });

        function setupCheckboxHandlers() {
            const selectAllCheckbox = document.getElementById('selectAll');
            const contentCheckboxes = document.querySelectorAll('.content-checkbox');

            selectAllCheckbox.addEventListener('change', function() {
                contentCheckboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
                updateSelectedItems();
            });

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
            document.getElementById('selectedCount').textContent = count;
            
            // Enable/disable bulk action buttons
            const bulkButtons = ['bulkDeleteBtn', 'bulkSoftDeleteBtn', 'bulkRestoreBtn'];
            bulkButtons.forEach(btnId => {
                const btn = document.getElementById(btnId);
                if (btn) {
                    btn.disabled = count === 0;
                }
            });
        }

        function viewContent(type, id) {
            window.open(`${contextPath}/admin/${type}s/${id}`, '_blank');
        }

        function editContent(type, id) {
            window.location.href = `${contextPath}/admin/${type}s/${id}/edit`;
        }

        function softDelete(type, id) {
            currentDeleteType = type;
            currentDeleteId = id;
            document.getElementById('deleteMessage').textContent = 
                `Bạn có chắc chắn muốn ẩn ${type} này? Nội dung sẽ không hiển thị công khai nhưng vẫn có thể khôi phục.`;
            document.getElementById('confirmDeleteBtn').innerHTML = '<i class="fas fa-archive me-1"></i>Ẩn';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function hardDelete(type, id) {
            currentDeleteType = type;
            currentDeleteId = id;
            document.getElementById('deleteMessage').textContent = 
                `Bạn có chắc chắn muốn xóa vĩnh viễn ${type} này? Hành động này không thể hoàn tác!`;
            document.getElementById('confirmDeleteBtn').innerHTML = '<i class="fas fa-trash me-1"></i>Xóa vĩnh viễn';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function restoreContent(type, id) {
            if (confirm(`Bạn có chắc chắn muốn khôi phục ${type} này?`)) {
                fetch(`${contextPath}/admin/content/restore`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: JSON.stringify({ type: type, id: id })
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
                    body: JSON.stringify({ type: type, id: id })
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

        function viewReports(type, id) {
            fetch(`${contextPath}/admin/content/reports?type=${type}&id=${id}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayReports(data.reports);
                        new bootstrap.Modal(document.getElementById('reportsModal')).show();
                    } else {
                        showToast('Không thể tải báo cáo', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Có lỗi xảy ra khi tải báo cáo', 'error');
                });
        }

        function displayReports(reports) {
            const reportsList = document.getElementById('reportsList');
            
            if (reports.length === 0) {
                reportsList.innerHTML = '<div class="text-center text-muted">Không có báo cáo nào</div>';
                return;
            }
            
            let html = '';
            reports.forEach(report => {
                html += `
                    <div class="border rounded p-3 mb-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${report.reason}</h6>
                                <p class="mb-1 text-muted">${report.description || 'Không có mô tả'}</p>
                                <small class="text-muted">
                                    Báo cáo bởi: ${report.reporterName} - ${report.createdAt}
                                </small>
                            </div>
                            <span class="badge bg-warning text-dark">
                                PENDING
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-success">
                                RESOLVED
                            </span>
                        </c:otherwise>
                    </c:choose>
                        </div>
                    </div>
                `;
            });
            
            reportsList.innerHTML = html;
        }

        function bulkDelete() {
            if (selectedItems.length === 0) {
                showToast('Vui lòng chọn ít nhất một mục', 'warning');
                return;
            }
            
            document.getElementById('bulkDeleteCount').textContent = selectedItems.length;
            new bootstrap.Modal(document.getElementById('bulkDeleteModal')).show();
        }

        function bulkSoftDelete() {
            if (selectedItems.length === 0) {
                showToast('Vui lòng chọn ít nhất một mục', 'warning');
                return;
            }
            
            if (confirm(`Bạn có chắc chắn muốn ẩn ${selectedItems.length} mục đã chọn?`)) {
                executeBulkAction('soft-delete');
            }
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
                    switch(action) {
                        case 'delete':
                            actionText = 'xóa';
                            break;
                        case 'soft-delete':
                            actionText = 'ẩn';
                            break;
                        case 'restore':
                            actionText = 'khôi phục';
                            break;
                        default:
                            actionText = 'xử lý';
                    }
                    showToast('Đã ' + actionText + ' ' + (data.count || selectedItems.length) + ' mục!', 'success');
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
            window.location.href = '${pageContext.request.contextPath}/admin/content/delete?tab=deleted';
        }

        function dismissAllReports() {
            if (confirm('Bạn có chắc chắn muốn bỏ qua tất cả báo cáo cho nội dung này?')) {
                // Implementation for dismissing reports
                showToast('Đã bỏ qua tất cả báo cáo', 'success');
                bootstrap.Modal.getInstance(document.getElementById('reportsModal')).hide();
                setTimeout(() => location.reload(), 1500);
            }
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
                        body: JSON.stringify({ type: type, id: id })
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
        document.getElementById('deleteForm').addEventListener('submit', function(e) {
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

        document.getElementById('bulkDeleteForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            executeBulkAction('delete', formData.get('bulkReason'));
            
            bootstrap.Modal.getInstance(document.getElementById('bulkDeleteModal')).hide();
        });

        // Reset forms when modals are hidden
        document.getElementById('deleteModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('deleteForm').reset();
        });

        document.getElementById('bulkDeleteModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('bulkDeleteForm').reset();
        });

        const contextPath = '${pageContext.request.contextPath}';
    </script>
</body>
</html>