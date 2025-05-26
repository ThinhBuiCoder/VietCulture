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
    <title>Kiểm duyệt nội dung - Admin</title>
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
        .moderation-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
        }
        .moderation-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .priority-high {
            border-left: 5px solid #dc3545;
        }
        .priority-medium {
            border-left: 5px solid #ffc107;
        }
        .priority-low {
            border-left: 5px solid #28a745;
        }
        .severity-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .severity-critical {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        .severity-high {
            background: linear-gradient(135deg, #fd7e14 0%, #e55d0b 100%);
            color: white;
        }
        .severity-medium {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: black;
        }
        .severity-low {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .content-preview {
            max-height: 200px;
            overflow: hidden;
            position: relative;
        }
        .content-fade {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 50px;
            background: linear-gradient(transparent, white);
        }
        .violation-type {
            display: inline-block;
            background-color: #e3f2fd;
            color: #1976d2;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            margin: 2px;
        }
        .ai-confidence {
            background: linear-gradient(135deg, #6f42c1 0%, #007bff 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
        }
        .moderation-timeline {
            border-left: 2px solid #dee2e6;
            padding-left: 20px;
            margin-left: 10px;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -25px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #007bff;
        }
        .stats-dashboard {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }
        .moderation-filters {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .quick-action-btn {
            margin: 2px;
            border-radius: 20px;
            font-size: 0.8rem;
            padding: 4px 12px;
        }
        .content-thumbnail {
            width: 120px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        .ai-analysis {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 15px;
            margin-top: 15px;
        }
        .confidence-bar {
            width: 100%;
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }
        .confidence-fill {
            height: 100%;
            background: linear-gradient(90deg, #28a745 0%, #ffc107 50%, #dc3545 100%);
            transition: width 0.3s ease;
        }
        .filter-toggle {
            cursor: pointer;
            user-select: none;
        }
        .filter-section {
            border-top: 1px solid #dee2e6;
            padding-top: 15px;
            margin-top: 15px;
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
                        <i class="fas fa-shield-alt me-2 text-primary"></i>Kiểm duyệt nội dung
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-success" onclick="approveAll()">
                                <i class="fas fa-check-double me-1"></i>Duyệt tất cả
                            </button>
                            <button type="button" class="btn btn-sm btn-warning" onclick="showAISettings()">
                                <i class="fas fa-robot me-1"></i>Cài đặt AI
                            </button>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-cog me-1"></i>Tùy chọn
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="exportModerationLog()">
                                    <i class="fas fa-download me-2"></i>Xuất log kiểm duyệt
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="showModerationStats()">
                                    <i class="fas fa-chart-bar me-2"></i>Thống kê chi tiết
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" onclick="trainAI()">
                                    <i class="fas fa-brain me-2"></i>Huấn luyện AI
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Stats Dashboard -->
                <div class="stats-dashboard">
                    <div class="row">
                        <div class="col-md-3 text-center">
                            <h3 class="mb-1">${pendingModerationCount != null ? pendingModerationCount : 0}</h3>
                            <p class="mb-0">Chờ kiểm duyệt</p>
                            <small class="opacity-75">Cần xử lý ngay</small>
                        </div>
                        <div class="col-md-3 text-center">
                            <h3 class="mb-1">${aiDetectedCount != null ? aiDetectedCount : 0}</h3>
                            <p class="mb-0">AI phát hiện</p>
                            <small class="opacity-75">Tự động đánh dấu</small>
                        </div>
                        <div class="col-md-3 text-center">
                            <h3 class="mb-1">${userReportedCount != null ? userReportedCount : 0}</h3>
                            <p class="mb-0">Người dùng báo cáo</p>
                            <small class="opacity-75">Cần xem xét</small>
                        </div>
                        <div class="col-md-3 text-center">
                            <h3 class="mb-1">${todayProcessedCount != null ? todayProcessedCount : 0}</h3>
                            <p class="mb-0">Xử lý hôm nay</p>
                            <small class="opacity-75">Hiệu suất làm việc</small>
                        </div>
                    </div>
                </div>

                <!-- Moderation Filters -->
                <div class="moderation-filters">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h6 class="mb-3">
                                <i class="fas fa-filter me-2"></i>Bộ lọc kiểm duyệt
                                <span class="filter-toggle" onclick="toggleAdvancedFilters()">
                                    <i class="fas fa-chevron-down ms-2" id="filterToggleIcon"></i>
                                </span>
                            </h6>
                            
                            <div class="btn-group flex-wrap" role="group">
                                <input type="radio" class="btn-check" name="priority" id="all-priority" autocomplete="off" checked>
                                <label class="btn btn-outline-primary btn-sm" for="all-priority">Tất cả</label>
                                
                                <input type="radio" class="btn-check" name="priority" id="high-priority" autocomplete="off">
                                <label class="btn btn-outline-danger btn-sm" for="high-priority">Ưu tiên cao</label>
                                
                                <input type="radio" class="btn-check" name="priority" id="medium-priority" autocomplete="off">
                                <label class="btn btn-outline-warning btn-sm" for="medium-priority">Ưu tiên trung bình</label>
                                
                                <input type="radio" class="btn-check" name="priority" id="ai-detected" autocomplete="off">
                                <label class="btn btn-outline-info btn-sm" for="ai-detected">AI phát hiện</label>
                            </div>
                        </div>
                        <div class="col-md-6 text-end">
                            <div class="input-group input-group-sm" style="max-width: 300px; margin-left: auto;">
                                <input type="text" class="form-control" placeholder="Tìm kiếm nội dung..." id="searchInput">
                                <button class="btn btn-outline-secondary" type="button" onclick="searchContent()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Advanced Filters (Collapsible) -->
                    <div class="filter-section collapse" id="advancedFilters">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label">Loại vi phạm:</label>
                                <select class="form-select form-select-sm" id="violationType">
                                    <option value="">Tất cả</option>
                                    <option value="spam">Spam</option>
                                    <option value="inappropriate">Nội dung không phù hợp</option>
                                    <option value="harassment">Quấy rối</option>
                                    <option value="fake">Thông tin giả mạo</option>
                                    <option value="copyright">Vi phạm bản quyền</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Loại nội dung:</label>
                                <select class="form-select form-select-sm" id="contentType">
                                    <option value="">Tất cả</option>
                                    <option value="experience">Experience</option>
                                    <option value="accommodation">Accommodation</option>
                                    <option value="review">Review</option>
                                    <option value="user">User Profile</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Độ tin cậy AI:</label>
                                <select class="form-select form-select-sm" id="aiConfidence">
                                    <option value="">Tất cả</option>
                                    <option value="high">Cao (>80%)</option>
                                    <option value="medium">Trung bình (50-80%)</option>
                                    <option value="low">Thấp (<50%)</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Ngày tạo:</label>
                                <select class="form-select form-select-sm" id="dateRange">
                                    <option value="">Tất cả</option>
                                    <option value="today">Hôm nay</option>
                                    <option value="week">7 ngày qua</option>
                                    <option value="month">30 ngày qua</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary btn-sm me-2" onclick="applyFilters()">
                                    <i class="fas fa-filter me-1"></i>Áp dụng bộ lọc
                                </button>
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetFilters()">
                                    <i class="fas fa-undo me-1"></i>Đặt lại
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Moderation Queue -->
                <div class="row">
                    <c:forEach var="item" items="${moderationQueue}">
                        <div class="col-lg-6 mb-4">
                            <div class="card moderation-card h-100 priority-${fn:toLowerCase(item.priority)}">
                                <div class="card-body position-relative">
                                    <!-- Severity Badge -->
                                    <span class="severity-badge severity-${fn:toLowerCase(item.severity)}">
                                        ${item.severity}
                                    </span>
                                    
                                    <div class="row">
                                        <div class="col-4">
                                            <!-- Content Thumbnail -->
                                            <c:choose>
                                                <c:when test="${not empty item.thumbnail}">
                                                    <img src="${item.thumbnail}" class="content-thumbnail" alt="Thumbnail">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="content-thumbnail bg-light d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-file-alt fa-2x text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-8">
                                            <!-- Content Info -->
                                            <h6 class="card-title mb-2">
                                                ${item.title}
                                                <small class="text-muted">(${item.contentType})</small>
                                            </h6>
                                            
                                            <p class="card-text text-muted small mb-2">
                                                Tác giả: ${item.authorName}
                                            </p>
                                            
                                            <p class="card-text text-muted small mb-2">
                                                <i class="fas fa-calendar me-1"></i>
                                                <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            
                                            <!-- Violation Types -->
                                            <div class="mb-2">
                                                <c:forEach var="violation" items="${item.violations}">
                                                    <span class="violation-type">${violation}</span>
                                                </c:forEach>
                                            </div>
                                            
                                            <!-- AI Confidence -->
                                            <c:if test="${item.aiDetected}">
                                                <div class="mb-2">
                                                    <span class="ai-confidence">
                                                        <i class="fas fa-robot me-1"></i>
                                                        AI: ${item.aiConfidence}% tin cậy
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <!-- Content Preview -->
                                    <div class="content-preview mt-3">
                                        <p class="mb-0">${item.contentPreview}</p>
                                        <div class="content-fade"></div>
                                    </div>
                                    
                                    <!-- AI Analysis -->
                                    <c:if test="${item.aiDetected}">
                                        <div class="ai-analysis">
                                            <h6 class="mb-2">
                                                <i class="fas fa-brain me-2"></i>Phân tích AI
                                            </h6>
                                            <p class="mb-2 small">${item.aiAnalysis}</p>
                                            <div class="confidence-bar">
                                                <div class="confidence-fill" style="width: ${item.aiConfidence}%"></div>
                                            </div>
                                            <small class="text-muted">Độ tin cậy: ${item.aiConfidence}%</small>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Reports Summary -->
                                    <c:if test="${item.reportCount > 0}">
                                        <div class="mt-3">
                                            <h6 class="mb-2">
                                                <i class="fas fa-flag me-2"></i>Báo cáo từ người dùng (${item.reportCount})
                                            </h6>
                                            <c:forEach var="report" items="${item.recentReports}" end="2">
                                                <div class="border-start border-3 border-warning ps-3 mb-2">
                                                    <strong>${report.reason}</strong>
                                                    <p class="mb-1 small text-muted">${report.description}</p>
                                                    <small class="text-muted">
                                                        ${report.reporterName} - <fmt:formatDate value="${report.createdAt}" pattern="dd/MM HH:mm"/>
                                                    </small>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${item.reportCount > 2}">
                                                <small class="text-muted">và ${item.reportCount - 2} báo cáo khác...</small>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="card-footer bg-transparent">
                                    <div class="d-flex flex-wrap gap-2">
                                        <button type="button" class="btn btn-success btn-sm quick-action-btn" 
                                                onclick="approveContent('${item.contentType}', ${item.contentId})">
                                            <i class="fas fa-check me-1"></i>Duyệt
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm quick-action-btn" 
                                                onclick="rejectContent('${item.contentType}', ${item.contentId})">
                                            <i class="fas fa-times me-1"></i>Từ chối
                                        </button>
                                        <button type="button" class="btn btn-warning btn-sm quick-action-btn" 
                                                onclick="requestEdit('${item.contentType}', ${item.contentId})">
                                            <i class="fas fa-edit me-1"></i>Yêu cầu sửa
                                        </button>
                                        <button type="button" class="btn btn-info btn-sm quick-action-btn" 
                                                onclick="viewDetails('${item.contentType}', ${item.contentId})">
                                            <i class="fas fa-eye me-1"></i>Chi tiết
                                        </button>
                                        <div class="dropdown">
                                            <button class="btn btn-outline-secondary btn-sm dropdown-toggle quick-action-btn" 
                                                    type="button" data-bs-toggle="dropdown">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li><a class="dropdown-item" href="#" onclick="flagContent('${item.contentType}', ${item.contentId})">
                                                    <i class="fas fa-flag me-2"></i>Đánh dấu vi phạm
                                                </a></li>
                                                <li><a class="dropdown-item" href="#" onclick="banAuthor(${item.authorId})">
                                                    <i class="fas fa-user-slash me-2"></i>Cấm tác giả
                                                </a></li>
                                                <li><a class="dropdown-item" href="#" onclick="escalateToSupervisor('${item.contentType}', ${item.contentId})">
                                                    <i class="fas fa-arrow-up me-2"></i>Chuyển cấp trên
                                                </a></li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item text-muted" href="#" onclick="addToWhitelist('${item.contentType}', ${item.contentId})">
                                                    <i class="fas fa-shield-check me-2"></i>Thêm vào whitelist
                                                </a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    
                                    <!-- Priority Indicator -->
                                    <div class="mt-2">
                                        <small class="text-muted">
                                            Ưu tiên: <strong class="text-${item.priority == 'HIGH' ? 'danger' : item.priority == 'MEDIUM' ? 'warning' : 'success'}">${item.priority}</strong>
                                            <c:if test="${item.aiDetected}">
                                                | <i class="fas fa-robot me-1"></i>AI Detection
                                            </c:if>
                                            <c:if test="${item.reportCount > 0}">
                                                | <i class="fas fa-flag me-1"></i>${item.reportCount} Reports
                                            </c:if>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Empty State -->
                    <c:if test="${empty moderationQueue}">
                        <div class="col-12">
                            <div class="text-center py-5">
                                <i class="fas fa-shield-check fa-4x text-success mb-3"></i>
                                <h4 class="text-muted">Không có nội dung cần kiểm duyệt</h4>
                                <p class="text-muted">Tất cả nội dung đã được xử lý hoặc không có vi phạm nào được báo cáo.</p>
                                <button type="button" class="btn btn-outline-primary" onclick="refreshQueue()">
                                    <i class="fas fa-sync-alt me-1"></i>Làm mới hàng đợi
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Moderation pagination" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&priority=${param.priority}&type=${param.type}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&priority=${param.priority}&type=${param.type}">
                                        ${pageNum}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&priority=${param.priority}&type=${param.type}">
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

    <!-- Moderation Action Modal -->
    <div class="modal fade" id="moderationModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="moderationModalTitle">Hành động kiểm duyệt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="moderationForm">
                    <div class="modal-body">
                        <div id="moderationContent">
                            <!-- Content will be loaded dynamically -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary" id="moderationSubmitBtn">
                            <i class="fas fa-check me-1"></i>Xác nhận
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- AI Settings Modal -->
    <div class="modal fade" id="aiSettingsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cài đặt AI Moderation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Ngưỡng phát hiện</h6>
                            <div class="mb-3">
                                <label class="form-label">Spam Detection</label>
                                <input type="range" class="form-range" min="0" max="100" value="70" id="spamThreshold">
                                <small class="text-muted">Ngưỡng: <span id="spamValue">70</span>%</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Inappropriate Content</label>
                                <input type="range" class="form-range" min="0" max="100" value="80" id="inappropriateThreshold">
                                <small class="text-muted">Ngưỡng: <span id="inappropriateValue">80</span>%</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Harassment Detection</label>
                                <input type="range" class="form-range" min="0" max="100" value="75" id="harassmentThreshold">
                                <small class="text-muted">Ngưỡng: <span id="harassmentValue">75</span>%</small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6>Hành động tự động</h6>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" id="autoHide" checked>
                                <label class="form-check-label" for="autoHide">
                                    Tự động ẩn nội dung có độ tin cậy > 90%
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" id="autoFlag" checked>
                                <label class="form-check-label" for="autoFlag">
                                    Tự động đánh dấu nội dung có độ tin cậy > 70%
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" id="notifyAdmin">
                                <label class="form-check-label" for="notifyAdmin">
                                    Thông báo admin khi phát hiện vi phạm nghiêm trọng
                                </label>
                            </div>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="learningMode" checked>
                                <label class="form-check-label" for="learningMode">
                                    Chế độ học tập (AI sẽ học từ quyết định của admin)
                                </label>
                            </div>
                            
                            <h6>Thống kê AI</h6>
                            <div class="row">
                                <div class="col-6">
                                    <div class="text-center">
                                        <h4 class="text-success">${aiAccuracy != null ? aiAccuracy : 85}%</h4>
                                        <small class="text-muted">Độ chính xác</small>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="text-center">
                                        <h4 class="text-info">${aiProcessedToday != null ? aiProcessedToday : 127}</h4>
                                        <small class="text-muted">Xử lý hôm nay</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveAISettings()">
                        <i class="fas fa-save me-1"></i>Lưu cài đặt
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let currentContentType = '';
        let currentContentId = 0;
        let currentAction = '';

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            setupAISettingsHandlers();
            setupFilterHandlers();
        });

        function setupAISettingsHandlers() {
            const thresholds = ['spam', 'inappropriate', 'harassment'];
            thresholds.forEach(type => {
                const slider = document.getElementById(type + 'Threshold');
                const valueSpan = document.getElementById(type + 'Value');
                if (slider && valueSpan) {
                    slider.addEventListener('input', function() {
                        valueSpan.textContent = this.value;
                    });
                }
            });
        }

        function setupFilterHandlers() {
            const priorityRadios = document.querySelectorAll('input[name="priority"]');
            priorityRadios.forEach(radio => {
                radio.addEventListener('change', function() {
                    applyFilters();
                });
            });
        }

        function toggleAdvancedFilters() {
            const filtersDiv = document.getElementById('advancedFilters');
            const icon = document.getElementById('filterToggleIcon');
            
            if (filtersDiv.classList.contains('show')) {
                filtersDiv.classList.remove('show');
                icon.classList.remove('fa-chevron-up');
                icon.classList.add('fa-chevron-down');
            } else {
                filtersDiv.classList.add('show');
                icon.classList.remove('fa-chevron-down');
                icon.classList.add('fa-chevron-up');
            }
        }

        function applyFilters() {
            const priority = document.querySelector('input[name="priority"]:checked')?.id || '';
            const violationType = document.getElementById('violationType')?.value || '';
            const contentType = document.getElementById('contentType')?.value || '';
            const aiConfidence = document.getElementById('aiConfidence')?.value || '';
            const dateRange = document.getElementById('dateRange')?.value || '';
            const search = document.getElementById('searchInput')?.value || '';

            const params = new URLSearchParams();
            if (priority && priority !== 'all-priority') params.append('priority', priority.replace('-priority', '').replace('-', '_'));
            if (violationType) params.append('violation', violationType);
            if (contentType) params.append('type', contentType);
            if (aiConfidence) params.append('ai_confidence', aiConfidence);
            if (dateRange) params.append('date', dateRange);
            if (search) params.append('search', search);

            window.location.href = '${pageContext.request.contextPath}/admin/content/moderation?' + params.toString();
        }

        function resetFilters() {
            document.getElementById('all-priority').checked = true;
            document.getElementById('violationType').value = '';
            document.getElementById('contentType').value = '';
            document.getElementById('aiConfidence').value = '';
            document.getElementById('dateRange').value = '';
            document.getElementById('searchInput').value = '';
            
            window.location.href = '${pageContext.request.contextPath}/admin/content/moderation';
        }

        function searchContent() {
            applyFilters();
        }

        function approveContent(type, id) {
            currentContentType = type;
            currentContentId = id;
            currentAction = 'approve';
            
            const modalContent = `
                <div class="text-center mb-3">
                    <i class="fas fa-check-circle fa-3x text-success"></i>
                </div>
                <p class="text-center">Bạn có chắc chắn muốn duyệt nội dung này?</p>
                <div class="mb-3">
                    <label class="form-label">Ghi chú (tùy chọn)</label>
                    <textarea class="form-control" name="note" rows="2" placeholder="Ghi chú về quyết định duyệt..."></textarea>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="notifyAuthor" id="notifyAuthor" checked>
                    <label class="form-check-label" for="notifyAuthor">
                        Thông báo cho tác giả
                    </label>
                </div>
            `;
            
            showModerationModal('Duyệt nội dung', modalContent, 'success');
        }

        function rejectContent(type, id) {
            currentContentType = type;
            currentContentId = id;
            currentAction = 'reject';
            
            const modalContent = `
                <div class="text-center mb-3">
                    <i class="fas fa-times-circle fa-3x text-danger"></i>
                </div>
                <p class="text-center">Bạn có chắc chắn muốn từ chối nội dung này?</p>
                <div class="mb-3">
                    <label class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                    <select class="form-select mb-2" name="reason" required>
                        <option value="">-- Chọn lý do --</option>
                        <option value="spam">Spam</option>
                        <option value="inappropriate">Nội dung không phù hợp</option>
                        <option value="harassment">Quấy rối</option>
                        <option value="fake">Thông tin giả mạo</option>
                        <option value="copyright">Vi phạm bản quyền</option>
                        <option value="other">Khác</option>
                    </select>
                    <textarea class="form-control" name="details" rows="3" placeholder="Chi tiết lý do từ chối..."></textarea>
                </div>
                <div class="form-check mb-2">
                    <input class="form-check-input" type="checkbox" name="allowEdit" id="allowEdit" checked>
                    <label class="form-check-label" for="allowEdit">
                        Cho phép tác giả chỉnh sửa và gửi lại
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="notifyAuthor" id="notifyAuthor2" checked>
                    <label class="form-check-label" for="notifyAuthor2">
                        Thông báo cho tác giả
                    </label>
                </div>
            `;
            
            showModerationModal('Từ chối nội dung', modalContent, 'danger');
        }

        function requestEdit(type, id) {
            currentContentType = type;
            currentContentId = id;
            currentAction = 'request_edit';
            
            const modalContent = `
                <div class="text-center mb-3">
                    <i class="fas fa-edit fa-3x text-warning"></i>
                </div>
                <p class="text-center">Yêu cầu tác giả chỉnh sửa nội dung</p>
                <div class="mb-3">
                    <label class="form-label">Yêu cầu chỉnh sửa <span class="text-danger">*</span></label>
                    <textarea class="form-control" name="editRequest" rows="4" required placeholder="Mô tả chi tiết những gì cần chỉnh sửa..."></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thời hạn chỉnh sửa</label>
                    <select class="form-select" name="deadline">
                        <option value="3">3 ngày</option>
                        <option value="7" selected>7 ngày</option>
                        <option value="14">14 ngày</option>
                        <option value="30">30 ngày</option>
                    </select>
                </div>
            `;
            
            showModerationModal('Yêu cầu chỉnh sửa', modalContent, 'warning');
        }

        function viewDetails(type, id) {
            window.open(`${contextPath}/admin/${type}s/${id}`, '_blank');
        }

        function flagContent(type, id) {
            // Implementation for flagging content
            showToast('Nội dung đã được đánh dấu', 'warning');
        }

        function banAuthor(authorId) {
            if (confirm('Bạn có chắc chắn muốn cấm tác giả này?')) {
                fetch(`${contextPath}/admin/users/${authorId}/ban`, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Đã cấm tác giả', 'success');
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        showToast('Có lỗi xảy ra', 'error');
                    }
                });
            }
        }

        function escalateToSupervisor(type, id) {
            if (confirm('Chuyển vụ việc này cho cấp trên xử lý?')) {
                fetch(`${contextPath}/admin/content/escalate`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ type: type, id: id })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Đã chuyển cho cấp trên', 'info');
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        showToast('Có lỗi xảy ra', 'error');
                    }
                });
            }
        }

        function addToWhitelist(type, id) {
            if (confirm('Thêm nội dung này vào whitelist?')) {
                fetch(`${contextPath}/admin/content/whitelist`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ type: type, id: id })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Đã thêm vào whitelist', 'success');
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        showToast('Có lỗi xảy ra', 'error');
                    }
                });
            }
        }

        function showModerationModal(title, content, type) {
            document.getElementById('moderationModalTitle').textContent = title;
            document.getElementById('moderationContent').innerHTML = content;
            
            const submitBtn = document.getElementById('moderationSubmitBtn');
            submitBtn.className = `btn btn-${type}`;
            
            new bootstrap.Modal(document.getElementById('moderationModal')).show();
        }

        function approveAll() {
            if (confirm('Bạn có chắc chắn muốn duyệt TẤT CẢ nội dung trong hàng đợi?')) {
                fetch(`${contextPath}/admin/content/approve-all`, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast(`Đã duyệt ${data.count} nội dung`, 'success');
                        setTimeout(() => location.reload(), 2000);
                    } else {
                        showToast('Có lỗi xảy ra', 'error');
                    }
                });
            }
        }

        function showAISettings() {
            new bootstrap.Modal(document.getElementById('aiSettingsModal')).show();
        }

        function saveAISettings() {
            const settings = {
                spamThreshold: document.getElementById('spamThreshold').value,
                inappropriateThreshold: document.getElementById('inappropriateThreshold').value,
                harassmentThreshold: document.getElementById('harassmentThreshold').value,
                autoHide: document.getElementById('autoHide').checked,
                autoFlag: document.getElementById('autoFlag').checked,
                notifyAdmin: document.getElementById('notifyAdmin').checked,
                learningMode: document.getElementById('learningMode').checked
            };

            fetch(`${contextPath}/admin/ai/settings`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(settings)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Đã lưu cài đặt AI', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('aiSettingsModal')).hide();
                } else {
                    showToast('Có lỗi xảy ra', 'error');
                }
            });
        }

        function refreshQueue() {
            location.reload();
        }

        function exportModerationLog() {
            window.location.href = `${contextPath}/admin/content/export-log`;
        }

        function showModerationStats() {
            window.open(`${contextPath}/admin/reports/moderation-stats`, '_blank');
        }

        function trainAI() {
            if (confirm('Bắt đầu huấn luyện AI với dữ liệu hiện tại?')) {
                fetch(`${contextPath}/admin/ai/train`, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('Đã bắt đầu huấn luyện AI', 'info');
                    } else {
                        showToast('Có lỗi xảy ra', 'error');
                    }
                });
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

        // Handle moderation form submission
        document.getElementById('moderationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = document.getElementById('moderationSubmitBtn');
            const originalContent = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            const formData = new FormData(this);
            const data = {
                action: currentAction,
                contentType: currentContentType,
                contentId: currentContentId
            };
            
            // Add form data to the data object
            for (let [key, value] of formData.entries()) {
                data[key] = value;
            }
            
            fetch(`${contextPath}/admin/content/moderate`, {
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
                    showToast('Đã xử lý thành công!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('moderationModal')).hide();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showToast('Có lỗi xảy ra: ' + (data.message || 'Unknown error'), 'error');
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
        document.getElementById('moderationModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('moderationForm').reset();
            currentContentType = '';
            currentContentId = 0;
            currentAction = '';
        });

        // Auto-refresh every 3 minutes for moderation queue
        setInterval(function() {
            if (document.visibilityState === 'visible') {
                fetch(`${contextPath}/admin/content/moderation/count`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.newItems > 0) {
                            showToast(`Có ${data.newItems} nội dung mới cần kiểm duyệt`, 'info');
                            
                            // Update the counter in the stats dashboard
                            const pendingElement = document.querySelector('.stats-dashboard h3');
                            if (pendingElement) {
                                const currentCount = parseInt(pendingElement.textContent) || 0;
                                pendingElement.textContent = currentCount + data.newItems;
                            }
                        }
                    })
                    .catch(error => console.log('Auto-refresh failed:', error));
            }
        }, 180000); // 3 minutes

        // Keyboard shortcuts for quick actions
        document.addEventListener('keydown', function(e) {
            // Only work when no modal is open and no input is focused
            if (document.activeElement.tagName === 'INPUT' || 
                document.activeElement.tagName === 'TEXTAREA' || 
                document.querySelector('.modal.show')) {
                return;
            }

            switch(e.key) {
                case '1':
                    // Quick approve first item
                    const firstApproveBtn = document.querySelector('.btn-success.quick-action-btn');
                    if (firstApproveBtn) firstApproveBtn.click();
                    break;
                case '2':
                    // Quick reject first item
                    const firstRejectBtn = document.querySelector('.btn-danger.quick-action-btn');
                    if (firstRejectBtn) firstRejectBtn.click();
                    break;
                case '3':
                    // Quick edit request first item
                    const firstEditBtn = document.querySelector('.btn-warning.quick-action-btn');
                    if (firstEditBtn) firstEditBtn.click();
                    break;
                case 'r':
                    // Refresh queue
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        refreshQueue();
                    }
                    break;
                case 'f':
                    // Focus search
                    if (e.ctrlKey || e.metaKey) {
                        e.preventDefault();
                        document.getElementById('searchInput').focus();
                    }
                    break;
            }
        });

        // Show keyboard shortcuts help
        function showKeyboardShortcuts() {
            const helpContent = `
                <div class="text-center mb-3">
                    <i class="fas fa-keyboard fa-3x text-info"></i>
                </div>
                <h6>Phím tắt hữu ích:</h6>
                <div class="row">
                    <div class="col-6">
                        <ul class="list-unstyled">
                            <li><kbd>1</kbd> - Duyệt item đầu tiên</li>
                            <li><kbd>2</kbd> - Từ chối item đầu tiên</li>
                            <li><kbd>3</kbd> - Yêu cầu sửa item đầu</li>
                        </ul>
                    </div>
                    <div class="col-6">
                        <ul class="list-unstyled">
                            <li><kbd>Ctrl</kbd> + <kbd>R</kbd> - Làm mới</li>
                            <li><kbd>Ctrl</kbd> + <kbd>F</kbd> - Tìm kiếm</li>
                            <li><kbd>?</kbd> - Hiện trợ giúp này</li>
                        </ul>
                    </div>
                </div>
            `;
            
            showModerationModal('Phím tắt', helpContent, 'info');
        }

        // Show help when pressing ?
        document.addEventListener('keydown', function(e) {
            if (e.key === '?' && !document.querySelector('.modal.show') && 
                document.activeElement.tagName !== 'INPUT' && 
                document.activeElement.tagName !== 'TEXTAREA') {
                showKeyboardShortcuts();
            }
        });

        // Add help button to toolbar
        document.addEventListener('DOMContentLoaded', function() {
            const toolbar = document.querySelector('.btn-toolbar');
            if (toolbar) {
                const helpBtn = document.createElement('button');
                helpBtn.type = 'button';
                helpBtn.className = 'btn btn-sm btn-outline-info ms-2';
                helpBtn.innerHTML = '<i class="fas fa-question-circle me-1"></i>Trợ giúp';
                helpBtn.onclick = showKeyboardShortcuts;
                toolbar.appendChild(helpBtn);
            }
        });
    </script>
</body>