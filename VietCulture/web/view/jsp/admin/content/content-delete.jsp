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
    <title>Quản lý nội dung vi phạm - Admin VietCulture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .admin-content {
            background-color: #f8f9fa;
            min-height: 100vh;
            padding: 20px;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            transition: transform 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .content-item {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        
        .content-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 10px;
        }
        
        .content-type-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            color: white;
        }
        
        .content-type-experience {
            background: linear-gradient(45deg, #28a745, #20c997);
        }
        
        .content-type-accommodation {
            background: linear-gradient(45deg, #007bff, #17a2b8);
        }
        
        .reported-badge {
            position: absolute;
            top: 5px;
            left: 5px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.7rem;
        }
        
        .delete-reason {
            background: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: 10px;
            padding: 10px;
            margin-top: 10px;
            font-size: 0.9rem;
        }
        
        .nav-tabs {
            border: none;
            margin-bottom: 20px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            padding: 10px 20px;
            border-radius: 10px;
            margin-right: 10px;
        }
        
        .nav-tabs .nav-link.active {
            background: #007bff;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }
        
        .empty-state i {
            font-size: 3rem;
            color: #28a745;
            margin-bottom: 20px;
        }
        
        .action-buttons .btn {
            margin-right: 10px;
            border-radius: 8px;
            padding: 5px 15px;
        }
        
        .modal-content {
            border-radius: 15px;
        }
        
        .modal-header {
            border-bottom: 1px solid #dee2e6;
            padding: 20px;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            border-top: 1px solid #dee2e6;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include admin sidebar -->
            <%@ include file="../includes/admin-sidebar.jsp" %>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 admin-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-shield-alt me-2 text-danger"></i>
                        Quản lý nội dung vi phạm
                    </h1>
                </div>

                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card">
                            <h6 class="text-danger mb-2">
                                <i class="fas fa-flag me-2"></i>
                                Nội dung bị báo cáo
                            </h6>
                            <h3 class="mb-0">${flaggedCount}</h3>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card">
                            <h6 class="text-warning mb-2">
                                <i class="fas fa-clock me-2"></i>
                                Đang chờ xử lý
                            </h6>
                            <h3 class="mb-0">${pendingCount}</h3>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card">
                            <h6 class="text-success mb-2">
                                <i class="fas fa-check-circle me-2"></i>
                                Đã xử lý
                            </h6>
                            <h3 class="mb-0">${resolvedCount}</h3>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card">
                            <h6 class="text-info mb-2">
                                <i class="fas fa-trash-restore me-2"></i>
                                Đã khôi phục
                            </h6>
                            <h3 class="mb-0">${restoredCount}</h3>
                        </div>
                    </div>
                </div>

                <!-- Filter Tabs -->
                <ul class="nav nav-tabs">
                    <li class="nav-item">
                        <a class="nav-link ${currentTab == 'flagged' ? 'active' : ''}" 
                           href="?tab=flagged">
                            <i class="fas fa-flag me-2"></i>
                            Bị báo cáo
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentTab == 'pending' ? 'active' : ''}" 
                           href="?tab=pending">
                            <i class="fas fa-clock me-2"></i>
                            Chờ xử lý
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentTab == 'deleted' ? 'active' : ''}" 
                           href="?tab=deleted">
                            <i class="fas fa-trash me-2"></i>
                            Đã xóa
                        </a>
                    </li>
                </ul>

                <!-- Content List -->
                <div class="content-list">
                    <c:forEach items="${contentList}" var="content">
                        <div class="content-item">
                            <div class="row align-items-center">
                                <div class="col-auto position-relative">
                                    <img src="${content.thumbnail}" alt="${content.title}" class="content-image">
                                    <c:if test="${content.reportCount > 0}">
                                        <span class="reported-badge">
                                            <i class="fas fa-flag me-1"></i>${content.reportCount}
                                        </span>
                                    </c:if>
                                </div>
                                <div class="col">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h5 class="mb-1">${content.title}</h5>
                                            <p class="text-muted mb-1">
                                                <i class="fas fa-user me-1"></i> ${content.authorName} |
                                                <i class="fas fa-calendar me-1"></i> 
                                                <fmt:formatDate value="${content.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            <p class="mb-2">${content.description}</p>
                                        </div>
                                        <span class="content-type-badge content-type-${content.type.toLowerCase()}">
                                            ${content.type}
                                        </span>
                                    </div>

                                    <c:if test="${not empty content.deleteReason}">
                                        <div class="delete-reason">
                                            <i class="fas fa-info-circle me-2"></i>
                                            <strong>Lý do xóa:</strong> ${content.deleteReason}
                                        </div>
                                    </c:if>

                                    <div class="action-buttons mt-3">
                                        <c:choose>
                                            <c:when test="${content.deleted}">
                                                <button class="btn btn-outline-success" onclick="restoreContent(${content.id}, '${content.type}')">
                                                    <i class="fas fa-trash-restore me-1"></i> Khôi phục
                                                </button>
                                                <button class="btn btn-outline-danger" onclick="confirmPermanentDelete(${content.id}, '${content.type}')">
                                                    <i class="fas fa-trash me-1"></i> Xóa vĩnh viễn
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-outline-primary" onclick="viewContent(${content.id}, '${content.type}')">
                                                    <i class="fas fa-eye me-1"></i> Xem chi tiết
                                                </button>
                                                <button class="btn btn-outline-warning" onclick="showDeleteModal(${content.id}, '${content.type}')">
                                                    <i class="fas fa-ban me-1"></i> Ẩn nội dung
                                                </button>
                                                <c:if test="${not content.approved}">
                                                    <button class="btn btn-outline-success" onclick="approveContent(${content.id}, '${content.type}')">
                                                        <i class="fas fa-check me-1"></i> Duyệt
                                                    </button>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Empty State -->
                    <c:if test="${empty contentList}">
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h4>Không có nội dung nào!</h4>
                            <p class="text-muted">Hiện không có nội dung nào cần xử lý trong mục này.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&tab=${currentTab}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&tab=${currentTab}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&tab=${currentTab}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </main>
        </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                        Xác nhận ẩn nội dung
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="deleteForm">
                        <input type="hidden" id="deleteContentId">
                        <input type="hidden" id="deleteContentType">
                        
                        <div class="mb-3">
                            <label for="deleteReason" class="form-label">Lý do ẩn nội dung <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="deleteReason" rows="3" required></textarea>
                        </div>
                        
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="sendNotification" checked>
                            <label class="form-check-label" for="sendNotification">
                                Gửi thông báo cho người đăng
                            </label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-warning" onclick="deleteContent()">
                        <i class="fas fa-ban me-1"></i> Ẩn nội dung
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Permanent Delete Modal -->
    <div class="modal fade" id="permanentDeleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle text-danger me-2"></i>
                        Xác nhận xóa vĩnh viễn
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác. Nội dung sẽ bị xóa vĩnh viễn khỏi hệ thống.
                    </div>
                    <p>Bạn có chắc chắn muốn xóa vĩnh viễn nội dung này?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" onclick="permanentDelete()">
                        <i class="fas fa-trash me-1"></i> Xóa vĩnh viễn
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        let currentDeleteId = null;
        let currentDeleteType = null;

        function showDeleteModal(id, type) {
            currentDeleteId = id;
            currentDeleteType = type;
            document.getElementById('deleteContentId').value = id;
            document.getElementById('deleteContentType').value = type;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function deleteContent() {
            const reason = document.getElementById('deleteReason').value;
            const sendNotification = document.getElementById('sendNotification').checked;
            
            if (!reason) {
                alert('Vui lòng nhập lý do ẩn nội dung');
                return;
            }

            fetch('${pageContext.request.contextPath}/admin/content/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    id: currentDeleteId,
                    type: currentDeleteType,
                    reason: reason,
                    sendNotification: sendNotification
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }

        function confirmPermanentDelete(id, type) {
            currentDeleteId = id;
            currentDeleteType = type;
            new bootstrap.Modal(document.getElementById('permanentDeleteModal')).show();
        }

        function permanentDelete() {
            fetch('${pageContext.request.contextPath}/admin/content/permanent-delete', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    id: currentDeleteId,
                    type: currentDeleteType
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }

        function restoreContent(id, type) {
            if (!confirm('Bạn có chắc chắn muốn khôi phục nội dung này?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/admin/content/restore', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    id: id,
                    type: type
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }

        function approveContent(id, type) {
            if (!confirm('Bạn có chắc chắn muốn duyệt nội dung này?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/admin/content/approve', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    id: id,
                    type: type
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra');
            });
        }

        function viewContent(id, type) {
            window.location.href = `${pageContext.request.contextPath}/admin/content/delete/${type}/${id}`;
        }
    </script>
</body>
</html>