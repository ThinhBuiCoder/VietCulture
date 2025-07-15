<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khiếu nại - Admin VietCulture</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .complaint-card {
            transition: all 0.3s ease;
            border-left: 4px solid #dee2e6;
        }
        
        .complaint-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .complaint-card.open {
            border-left-color: #ffc107;
        }
        
        .complaint-card.in-progress {
            border-left-color: #17a2b8;
        }
        
        .complaint-card.resolved {
            border-left-color: #28a745;
        }
        
        .complaint-card.closed {
            border-left-color: #6c757d;
        }
        
        .priority-high {
            border-left-color: #dc3545 !important;
        }
        
        .priority-medium {
            border-left-color: #ffc107 !important;
        }
        
        .priority-low {
            border-left-color: #28a745 !important;
        }
        
        .status-filter {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .status-filter:hover {
            transform: scale(1.05);
        }
        
        .status-filter.active {
            background-color: #007bff !important;
            color: white !important;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box .form-control {
            padding-left: 40px;
        }
        
        .search-box .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .complaint-text {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .action-buttons {
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .complaint-card:hover .action-buttons {
            opacity: 1;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
        }
        
        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .urgent-badge {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../includes/admin-sidebar.jsp" />
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <!-- Header -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                        Quản lý Khiếu nại
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="exportComplaints()">
                                <i class="fas fa-download me-1"></i> Xuất Excel
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="refreshPage()">
                                <i class="fas fa-sync-alt me-1"></i> Làm mới
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stats-card bg-warning">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number">${statusCounts['OPEN'] != null ? statusCounts['OPEN'] : 0}</div>
                                    <div class="stats-label">Chờ xử lý</div>
                                </div>
                                <i class="fas fa-clock fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card bg-info">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number">${statusCounts['IN_PROGRESS'] != null ? statusCounts['IN_PROGRESS'] : 0}</div>
                                    <div class="stats-label">Đang xử lý</div>
                                </div>
                                <i class="fas fa-cogs fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card bg-success">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number">${statusCounts['RESOLVED'] != null ? statusCounts['RESOLVED'] : 0}</div>
                                    <div class="stats-label">Đã giải quyết</div>
                                </div>
                                <i class="fas fa-check-circle fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card bg-secondary">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number">${statusCounts['CLOSED'] != null ? statusCounts['CLOSED'] : 0}</div>
                                    <div class="stats-label">Đã đóng</div>
                                </div>
                                <i class="fas fa-times-circle fa-2x opacity-75"></i>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters and Search -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <!-- Status Filters -->
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-outline-warning status-filter ${empty statusFilter ? 'active' : ''}" 
                                    onclick="filterByStatus('')">
                                <i class="fas fa-list me-1"></i> Tất cả
                            </button>
                            <button type="button" class="btn btn-outline-warning status-filter ${statusFilter == 'OPEN' ? 'active' : ''}" 
                                    onclick="filterByStatus('OPEN')">
                                <i class="fas fa-clock me-1"></i> Chờ xử lý
                                <c:if test="${statusCounts['OPEN'] != null and statusCounts['OPEN'] > 0}">
                                    <span class="badge bg-warning text-dark ms-1">${statusCounts['OPEN']}</span>
                                </c:if>
                            </button>
                            <button type="button" class="btn btn-outline-info status-filter ${statusFilter == 'IN_PROGRESS' ? 'active' : ''}" 
                                    onclick="filterByStatus('IN_PROGRESS')">
                                <i class="fas fa-cogs me-1"></i> Đang xử lý
                                <c:if test="${statusCounts['IN_PROGRESS'] != null and statusCounts['IN_PROGRESS'] > 0}">
                                    <span class="badge bg-info ms-1">${statusCounts['IN_PROGRESS']}</span>
                                </c:if>
                            </button>
                            <button type="button" class="btn btn-outline-success status-filter ${statusFilter == 'RESOLVED' ? 'active' : ''}" 
                                    onclick="filterByStatus('RESOLVED')">
                                <i class="fas fa-check-circle me-1"></i> Đã giải quyết
                                <c:if test="${statusCounts['RESOLVED'] != null and statusCounts['RESOLVED'] > 0}">
                                    <span class="badge bg-success ms-1">${statusCounts['RESOLVED']}</span>
                                </c:if>
                            </button>
                            <button type="button" class="btn btn-outline-secondary status-filter ${statusFilter == 'CLOSED' ? 'active' : ''}" 
                                    onclick="filterByStatus('CLOSED')">
                                <i class="fas fa-times-circle me-1"></i> Đã đóng
                                <c:if test="${statusCounts['CLOSED'] != null and statusCounts['CLOSED'] > 0}">
                                    <span class="badge bg-secondary ms-1">${statusCounts['CLOSED']}</span>
                                </c:if>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <!-- Search Box -->
                        <form class="search-box" method="GET" action="${pageContext.request.contextPath}/admin/complaints">
                            <input type="hidden" name="status" value="${statusFilter}">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" class="form-control" name="search" placeholder="Tìm kiếm khiếu nại..." 
                                   value="${searchQuery}">
                        </form>
                    </div>
                </div>
                
                <!-- Complaints List -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty complaints}">
                            <div class="col-12">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h4 class="text-muted">Không có khiếu nại nào</h4>
                                    <p class="text-muted">Tất cả khiếu nại đã được xử lý hoặc chưa có khiếu nại nào được gửi.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="complaint" items="${complaints}">
                                <div class="col-12 mb-3">
                                    <div class="card complaint-card ${fn:toLowerCase(complaint.status)} ${complaint.priorityLevel == 'Cao' ? 'priority-high' : complaint.priorityLevel == 'Trung bình' ? 'priority-medium' : 'priority-low'}">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <h6 class="card-title mb-0 me-3">
                                                            <i class="fas fa-user me-1"></i>
                                                            ${complaint.userName != null ? complaint.userName : 'Khách hàng'}
                                                        </h6>
                                                        <span class="${complaint.statusBadgeClass}">${complaint.displayStatus}</span>
                                                        <c:if test="${complaint.priorityLevel == 'Cao'}">
                                                            <span class="badge bg-danger urgent-badge ms-2">
                                                                <i class="fas fa-exclamation-triangle me-1"></i>Khẩn cấp
                                                            </span>
                                                        </c:if>
                                                        <span class="${complaint.priorityBadgeClass} ms-2">${complaint.priorityLevel}</span>
                                                    </div>
                                                    
                                                    <p class="card-text complaint-text text-muted mb-2">
                                                        ${complaint.shortComplaintText}
                                                    </p>
                                                    
                                                    <div class="d-flex align-items-center text-muted small">
                                                        <span class="me-3">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            ${complaint.timeSinceCreated}
                                                        </span>
                                                        <c:if test="${complaint.relatedBookingId != null}">
                                                            <span class="me-3">
                                                                <i class="fas fa-ticket-alt me-1"></i>
                                                                Booking #${complaint.relatedBookingId}
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${complaint.relatedContentTitle != null}">
                                                            <span class="me-3">
                                                                <i class="fas fa-map-marker-alt me-1"></i>
                                                                ${complaint.relatedContentTitle}
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${complaint.assignedAdminName != null}">
                                                            <span>
                                                                <i class="fas fa-user-shield me-1"></i>
                                                                ${complaint.assignedAdminName}
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                
                                                <div class="col-md-4">
                                                    <div class="action-buttons d-flex justify-content-end">
                                                        <c:if test="${complaint.isOpen() || complaint.isInProgress()}">
                                                            <button class="btn btn-success btn-sm me-2" onclick="acceptComplaint(${complaint.complaintId})">
                                                                <i class="fas fa-check"></i> Chấp nhận
                                                            </button>
                                                            <button class="btn btn-danger btn-sm" onclick="rejectComplaint(${complaint.complaintId})">
                                                                <i class="fas fa-times"></i> Từ chối
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${complaint.isOpen()}">
                                                            <button class="btn btn-sm btn-primary me-2" onclick="assignComplaint(${complaint.complaintId})">
                                                                <i class="fas fa-hand-paper me-1"></i> Nhận xử lý
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${complaint.isInProgress()}">
                                                            <button class="btn btn-sm btn-success me-2" onclick="resolveComplaint(${complaint.complaintId})">
                                                                <i class="fas fa-check me-1"></i> Giải quyết
                                                            </button>
                                                        </c:if>
                                                        <a href="${pageContext.request.contextPath}/admin/complaints/${complaint.complaintId}" 
                                                           class="btn btn-sm btn-outline-info me-2">
                                                            <i class="fas fa-eye me-1"></i> Chi tiết
                                                        </a>
                                                        <button class="btn btn-sm btn-outline-danger" onclick="deleteComplaint(${complaint.complaintId})">
                                                            <i class="fas fa-trash me-1"></i> Xóa
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Filter by status
        function filterByStatus(status) {
            var url = new URL(window.location);
            if (status) {
                url.searchParams.set('status', status);
            } else {
                url.searchParams.delete('status');
            }
            window.location.href = url.toString();
        }
        
        // Assign complaint
        function assignComplaint(complaintId) {
            if (confirm('Bạn có chắc chắn muốn nhận xử lý khiếu nại này?')) {
                fetch('${pageContext.request.contextPath}/admin/complaints', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=assign&complaintId=${complaintId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification(data.message, 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showNotification(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra', 'error');
                });
            }
        }
        
        // Resolve complaint
        function resolveComplaint(complaintId) {
            const resolution = prompt('Nhập giải pháp cho khiếu nại này:');
            if (resolution) {
                fetch('${pageContext.request.contextPath}/admin/complaints', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=resolve&complaintId=${complaintId}&resolution=${encodeURIComponent(resolution)}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification(data.message, 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showNotification(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra', 'error');
                });
            }
        }
        
        // Delete complaint
        function deleteComplaint(complaintId) {
            if (confirm('Bạn có chắc chắn muốn xóa khiếu nại này? Hành động này không thể hoàn tác.')) {
                fetch('${pageContext.request.contextPath}/admin/complaints', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=delete&complaintId=${complaintId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification(data.message, 'success');
                        setTimeout(() => window.location.reload(), 1500);
                    } else {
                        showNotification(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra', 'error');
                });
            }
        }
        
        // Export complaints
        function exportComplaints() {
            const url = new URL('${pageContext.request.contextPath}/admin/complaints');
            url.searchParams.set('action', 'export');
            if ('${statusFilter}') url.searchParams.set('status', '${statusFilter}');
            if ('${searchQuery}') url.searchParams.set('search', '${searchQuery}');
            window.open(url.toString(), '_blank');
        }
        
        // Refresh page
        function refreshPage() {
            window.location.reload();
        }
        
        // Show notification
        function showNotification(message, type) {
            const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
            const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
            
            const notification = document.createElement('div');
            notification.className = `alert ${alertClass} alert-dismissible fade show position-fixed`;
            notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
            notification.innerHTML = `
                <i class="fas ${icon} me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 5000);
        }
        
        // Auto refresh for urgent complaints
        setInterval(() => {
            const urgentComplaints = document.querySelectorAll('.priority-high');
            if (urgentComplaints.length > 0) {
                // Refresh every 30 seconds if there are urgent complaints
                window.location.reload();
            }
        }, 30000);

        function acceptComplaint(complaintId) {
            if (confirm('Bạn có chắc chắn muốn CHẤP NHẬN khiếu nại này?')) {
                fetch('${pageContext.request.contextPath}/admin/complaints', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=update-status&complaintId=' + complaintId + '&status=RESOLVED'
                })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    showNotification(data.message, data.success ? 'success' : 'error');
                    if (data.success) setTimeout(function() { window.location.reload(); }, 1000);
                });
            }
        }

        function rejectComplaint(complaintId) {
            if (confirm('Bạn có chắc chắn muốn TỪ CHỐI khiếu nại này?')) {
                fetch('${pageContext.request.contextPath}/admin/complaints', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=update-status&complaintId=' + complaintId + '&status=CLOSED'
                })
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    showNotification(data.message, data.success ? 'success' : 'error');
                    if (data.success) setTimeout(function() { window.location.reload(); }, 1000);
                });
            }
        }
    </script>
</body>
</html>
