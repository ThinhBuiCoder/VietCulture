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
        <title>Tổng quan kiểm duyệt - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            .overview-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 15px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            .metric-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: none;
                transition: all 0.3s ease;
                height: 100%;
            }
            .metric-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            }
            .metric-icon {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                margin-bottom: 20px;
            }
            .metric-icon.pending {
                background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
                color: white;
            }
            .metric-icon.approved {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }
            .metric-icon.rejected {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
            }
            .metric-icon.ai {
                background: linear-gradient(135deg, #6f42c1 0%, #007bff 100%);
                color: white;
            }
            .metric-number {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .metric-label {
                font-size: 1.1rem;
                color: #6c757d;
                margin-bottom: 15px;
            }
            .metric-change {
                font-size: 0.9rem;
                padding: 5px 10px;
                border-radius: 20px;
                font-weight: 500;
            }
            .change-positive {
                background-color: #d4edda;
                color: #155724;
            }
            .change-negative {
                background-color: #f8d7da;
                color: #721c24;
            }
            .change-neutral {
                background-color: #e2e3e5;
                color: #383d41;
            }
            .chart-container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                margin-bottom: 25px;
            }
            .activity-feed {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                max-height: 500px;
                overflow-y: auto;
            }
            .activity-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #f1f3f4;
            }
            .activity-item:last-child {
                border-bottom: none;
            }
            .activity-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                font-size: 14px;
            }
            .activity-icon.approve {
                background-color: #d4edda;
                color: #155724;
            }
            .activity-icon.reject {
                background-color: #f8d7da;
                color: #721c24;
            }
            .activity-icon.flag {
                background-color: #fff3cd;
                color: #856404;
            }
            .priority-indicator {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                display: inline-block;
                margin-right: 8px;
            }
            .priority-high {
                background-color: #dc3545;
            }
            .priority-medium {
                background-color: #ffc107;
            }
            .priority-low {
                background-color: #28a745;
            }
            .quick-action-btn {
                border-radius: 20px;
                padding: 8px 16px;
                font-size: 0.85rem;
                margin: 2px;
            }
            .performance-badge {
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 500;
                font-size: 0.9rem;
            }
            .performance-excellent {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }
            .performance-good {
                background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
                color: white;
            }
            .performance-average {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
                color: black;
            }
            .performance-poor {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
            }
            .time-filter {
                background: white;
                border-radius: 25px;
                padding: 5px;
                display: inline-flex;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .time-filter .btn {
                border-radius: 20px;
                border: none;
                padding: 8px 20px;
                font-size: 0.9rem;
                margin: 0 2px;
            }
            .moderation-heatmap {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
            .heatmap-cell {
                width: 30px;
                height: 30px;
                border-radius: 4px;
                display: inline-block;
                margin: 1px;
                transition: all 0.2s ease;
            }
            .heatmap-cell:hover {
                transform: scale(1.1);
            }
            .heatmap-legend {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 15px;
            }
            .alert-banner {
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                color: white;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 25px;
                border: none;
            }
            .moderator-leaderboard {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
            .leaderboard-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #f1f3f4;
            }
            .leaderboard-item:last-child {
                border-bottom: none;
            }
            .leaderboard-rank {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                margin-right: 15px;
            }
            .rank-1 {
                background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
                color: #856404;
            }
            .rank-2 {
                background: linear-gradient(135deg, #c0c0c0 0%, #e9ecef 100%);
                color: #495057;
            }
            .rank-3 {
                background: linear-gradient(135deg, #cd7f32 0%, #fd7e14 100%);
                color: white;
            }
            .rank-other {
                background-color: #f8f9fa;
                color: #6c757d;
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
                    <!-- Overview Header -->
                    <div class="overview-header">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h1 class="mb-3">
                                    <i class="fas fa-shield-alt me-3"></i>Tổng quan kiểm duyệt
                                </h1>
                                <p class="mb-0 opacity-90">
                                    Theo dõi hiệu suất kiểm duyệt nội dung, phát hiện vi phạm và đảm bảo chất lượng platform
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="time-filter">
                                    <button class="btn btn-primary active" data-period="today">Hôm nay</button>
                                    <button class="btn btn-outline-primary" data-period="week">7 ngày</button>
                                    <button class="btn btn-outline-primary" data-period="month">30 ngày</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Alert Banner for High Priority Items -->
                    <c:if test="${highPriorityCount > 0}">
                        <div class="alert alert-banner d-flex align-items-center">
                            <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                            <div>
                                <h5 class="mb-1">Cảnh báo: Có ${highPriorityCount} nội dung ưu tiên cao cần xử lý!</h5>
                                <p class="mb-0">Các nội dung này có thể ảnh hưởng nghiêm trọng đến trải nghiệm người dùng.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/content/moderation?priority=high" 
                               class="btn btn-light ms-auto">
                                <i class="fas fa-arrow-right me-1"></i>Xử lý ngay
                            </a>
                        </div>
                    </c:if>

                    <!-- Key Metrics -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="metric-card">
                                <div class="metric-icon pending">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="metric-number text-warning">${pendingCount != null ? pendingCount : 0}</div>
                                <div class="metric-label">Chờ kiểm duyệt</div>
                                <div class="metric-change change-neutral">
                                    <i class="fas fa-minus me-1"></i>Không đổi
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="metric-card">
                                <div class="metric-icon approved">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="metric-number text-success">${approvedCount != null ? approvedCount : 0}</div>
                                <div class="metric-label">Đã duyệt</div>
                                <div class="metric-change change-positive">
                                    <i class="fas fa-arrow-up me-1"></i>+${approvedGrowth != null ? approvedGrowth : 12}%
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="metric-card">
                                <div class="metric-icon rejected">
                                    <i class="fas fa-times-circle"></i>
                                </div>
                                <div class="metric-number text-danger">${rejectedCount != null ? rejectedCount : 0}</div>
                                <div class="metric-label">Bị từ chối</div>
                                <div class="metric-change change-negative">
                                    <i class="fas fa-arrow-down me-1"></i>-${rejectedGrowth != null ? rejectedGrowth : 8}%
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="metric-card">
                                <div class="metric-icon ai">
                                    <i class="fas fa-robot"></i>
                                </div>
                                <div class="metric-number text-info">${aiDetectedCount != null ? aiDetectedCount : 0}</div>
                                <div class="metric-label">AI phát hiện</div>
                                <div class="metric-change change-positive">
                                    <i class="fas fa-arrow-up me-1"></i>+${aiGrowth != null ? aiGrowth : 25}%
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Performance Overview -->
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <div class="chart-container">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="mb-0">
                                        <i class="fas fa-chart-line me-2 text-primary"></i>Xu hướng kiểm duyệt
                                    </h5>
                                    <div class="d-flex gap-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-success rounded-circle me-2" style="width: 12px; height: 12px;"></div>
                                            <small>Duyệt</small>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-danger rounded-circle me-2" style="width: 12px; height: 12px;"></div>
                                            <small>Từ chối</small>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-warning rounded-circle me-2" style="width: 12px; height: 12px;"></div>
                                            <small>Chờ xử lý</small>
                                        </div>
                                    </div>
                                </div>
                                <canvas id="moderationTrendChart" height="100"></canvas>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="chart-container">
                                <h5 class="mb-4">
                                    <i class="fas fa-chart-pie me-2 text-primary"></i>Phân bố theo loại
                                </h5>
                                <canvas id="contentTypeChart" height="200"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- AI Performance & Moderation Heatmap -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="chart-container">
                                <h5 class="mb-4">
                                    <i class="fas fa-brain me-2 text-primary"></i>Hiệu suất AI
                                </h5>
                                <div class="row text-center">
                                    <div class="col-4">
                                        <div class="mb-2">
                                            <div class="performance-badge performance-excellent">
                                                ${aiAccuracy != null ? aiAccuracy : 87}%
                                            </div>
                                        </div>
                                        <small class="text-muted">Độ chính xác</small>
                                    </div>
                                    <div class="col-4">
                                        <div class="mb-2">
                                            <div class="performance-badge performance-good">
                                                ${aiPrecision != null ? aiPrecision : 92}%
                                            </div>
                                        </div>
                                        <small class="text-muted">Precision</small>
                                    </div>
                                    <div class="col-4">
                                        <div class="mb-2">
                                            <div class="performance-badge performance-average">
                                                ${aiRecall != null ? aiRecall : 78}%
                                            </div>
                                        </div>
                                        <small class="text-muted">Recall</small>
                                    </div>
                                </div>
                                <div class="mt-4">
                                    <canvas id="aiPerformanceChart" height="120"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="moderation-heatmap">
                                <h5 class="mb-4">
                                    <i class="fas fa-calendar-alt me-2 text-primary"></i>Hoạt động 30 ngày qua
                                </h5>
                                <div class="heatmap-container">
                                    <c:forEach begin="0" end="29" var="day">
                                        <c:set var="intensity" value="${moderationHeatmap[day] != null ? moderationHeatmap[day] : 0}" />
                                        <span class="heatmap-cell" 
                                              style="background-color: rgba(40, 167, 69, ${intensity / 100})"
                                              title="Ngày ${30 - day}: ${intensity} hoạt động"
                                              data-bs-toggle="tooltip">
                                        </span>
                                        <c:if test="${(day + 1) % 7 == 0}">
                                            <br>
                                        </c:if>
                                    </c:forEach>
                                </div>
                                <div class="heatmap-legend">
                                    <small class="text-muted">Ít</small>
                                    <div class="heatmap-cell" style="background-color: rgba(40, 167, 69, 0.2)"></div>
                                    <div class="heatmap-cell" style="background-color: rgba(40, 167, 69, 0.4)"></div>
                                    <div class="heatmap-cell" style="background-color: rgba(40, 167, 69, 0.6)"></div>
                                    <div class="heatmap-cell" style="background-color: rgba(40, 167, 69, 0.8)"></div>
                                    <div class="heatmap-cell" style="background-color: rgba(40, 167, 69, 1.0)"></div>
                                    <small class="text-muted">Nhiều</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity & Moderator Leaderboard -->
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <div class="activity-feed">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="mb-0">
                                        <i class="fas fa-history me-2 text-primary"></i>Hoạt động gần đây
                                    </h5>
                                    <a href="${pageContext.request.contextPath}/admin/logs/moderation" 
                                       class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-external-link-alt me-1"></i>Xem tất cả
                                    </a>
                                </div>

                                <c:forEach var="activity" items="${recentActivities}">
                                    <div class="activity-item">
                                        <div class="activity-icon ${activity.action}">
                                            <c:choose>
                                                <c:when test="${activity.action eq 'approve'}">
                                                    <i class="fas fa-check"></i>
                                                </c:when>
                                                <c:when test="${activity.action eq 'reject'}">
                                                    <i class="fas fa-times"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-flag"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <strong>${activity.moderatorName}</strong>
                                                    <c:choose>
                                                        <c:when test="${activity.action eq 'approve'}">
                                                            đã duyệt
                                                        </c:when>
                                                        <c:when test="${activity.action eq 'reject'}">
                                                            đã từ chối
                                                        </c:when>
                                                        <c:otherwise>
                                                            đã đánh dấu
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="text-primary">${activity.contentTitle}</span>
                                                    <div class="d-flex align-items-center mt-1">
                                                        <span class="priority-indicator priority-${fn:toLowerCase(activity.priority)}"></span>
                                                        <small class="text-muted">
                                                            ${activity.contentType} • 
                                                            <fmt:formatDate value="${activity.createdAt}" pattern="HH:mm dd/MM"/>
                                                        </small>
                                                    </div>
                                                </div>
                                                <button class="btn btn-outline-secondary btn-sm quick-action-btn"
                                                        onclick="viewActivity('${activity.contentType}', ${activity.contentId})">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty recentActivities}">
                                    <div class="text-center py-4">
                                        <i class="fas fa-history fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Chưa có hoạt động kiểm duyệt nào gần đây</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="moderator-leaderboard">
                                <h5 class="mb-4">
                                    <i class="fas fa-trophy me-2 text-primary"></i>Bảng xếp hạng
                                </h5>

                                <c:forEach var="moderator" items="${moderatorLeaderboard}" varStatus="status">
                                    <div class="leaderboard-item">
                                        <div class="leaderboard-rank rank-${status.index + 1 <= 3 ? status.index + 1 : 'other'}">
                                            ${status.index + 1}
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-bold">${moderator.name}</div>
                                            <small class="text-muted">
                                                ${moderator.totalActions} hành động • 
                                                ${moderator.accuracyRate}% chính xác
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <div class="badge bg-primary">${moderator.score}</div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty moderatorLeaderboard}">
                                    <div class="text-center py-4">
                                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Chưa có dữ liệu xếp hạng</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row">
                        <div class="col-12">
                            <div class="chart-container">
                                <h5 class="mb-4">
                                    <i class="fas fa-bolt me-2 text-primary"></i>Hành động nhanh
                                </h5>
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/content/moderation?priority=high" 
                                           class="btn btn-danger btn-lg w-100">
                                            <i class="fas fa-exclamation-triangle mb-2"></i>
                                            <div>Ưu tiên cao</div>
                                            <small>${highPriorityCount} mục</small>
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/content/moderation?ai_detected=true" 
                                           class="btn btn-info btn-lg w-100">
                                            <i class="fas fa-robot mb-2"></i>
                                            <div>AI phát hiện</div>
                                            <small>${aiDetectedCount} mục</small>
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/content/delete?tab=reported" 
                                           class="btn btn-warning btn-lg w-100">
                                            <i class="fas fa-flag mb-2"></i>
                                            <div>Bị báo cáo</div>
                                            <small>${reportedCount} mục</small>
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <button class="btn btn-success btn-lg w-100" onclick="showBulkApproval()">
                                            <i class="fas fa-check-double mb-2"></i>
                                            <div>Duyệt hàng loạt</div>
                                            <small>Công cụ</small>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Toast Container -->
        <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                            const contextPath = '${pageContext.request.contextPath}';

                                            // Initialize tooltips
                                            document.addEventListener('DOMContentLoaded', function () {
                                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                                });

                                                initializeCharts();
                                                setupTimeFilters();
                                            });

                                            // Time period filters
                                            function setupTimeFilters() {
                                                const timeButtons = document.querySelectorAll('[data-period]');
                                                timeButtons.forEach(btn => {
                                                    btn.addEventListener('click', function () {
                                                        timeButtons.forEach(b => {
                                                            b.classList.remove('btn-primary');
                                                            b.classList.add('btn-outline-primary');
                                                        });
                                                        this.classList.remove('btn-outline-primary');
                                                        this.classList.add('btn-primary');

                                                        const period = this.dataset.period;
                                                        updateData(period);
                                                    });
                                                });
                                            }

                                            // Initialize charts
                                            function initializeCharts() {
                                                // Moderation Trend Chart
                                                const trendCtx = document.getElementById('moderationTrendChart').getContext('2d');
                                                new Chart(trendCtx, {
                                                    type: 'line',
                                                    data: {
                                                        labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                                                        datasets: [{
                                                                label: 'Duyệt',
                                                                data: [12, 19, 15, 25, 22, 18, 20],
                                                                borderColor: '#28a745',
                                                                backgroundColor: 'rgba(40, 167, 69, 0.1)',
                                                                tension: 0.4
                                                            }, {
                                                                label: 'Từ chối',
                                                                data: [5, 8, 6, 12, 9, 7, 8],
                                                                borderColor: '#dc3545',
                                                                backgroundColor: 'rgba(220, 53, 69, 0.1)',
                                                                tension: 0.4
                                                            }, {
                                                                label: 'Chờ xử lý',
                                                                data: [3, 5, 4, 8, 6, 5, 7],
                                                                borderColor: '#ffc107',
                                                                backgroundColor: 'rgba(255, 193, 7, 0.1)',
                                                                tension: 0.4
                                                            }]
                                                    },
                                                    options: {
                                                        responsive: true,
                                                        maintainAspectRatio: false,
                                                        plugins: {
                                                            legend: {
                                                                display: false
                                                            }
                                                        },
                                                        scales: {
                                                            y: {
                                                                beginAtZero: true,
                                                                grid: {
                                                                    color: 'rgba(0,0,0,0.05)'
                                                                }
                                                            },
                                                            x: {
                                                                grid: {
                                                                    display: false
                                                                }
                                                            }
                                                        }
                                                    }
                                                });

                                                // Content Type Distribution Chart
                                                const typeCtx = document.getElementById('contentTypeChart').getContext('2d');
                                                new Chart(typeCtx, {
                                                    type: 'doughnut',
                                                    data: {
                                                        labels: ['Experience', 'Accommodation', 'Review', 'User Profile'],
                                                        datasets: [{
                                                                data: [45, 30, 20, 5],
                                                                backgroundColor: [
                                                                    '#28a745',
                                                                    '#007bff',
                                                                    '#fd7e14',
                                                                    '#6f42c1'
                                                                ],
                                                                borderWidth: 0
                                                            }]
                                                    },
                                                    options: {
                                                        responsive: true,
                                                        maintainAspectRatio: false,
                                                        plugins: {
                                                            legend: {
                                                                position: 'bottom',
                                                                labels: {
                                                                    usePointStyle: true,
                                                                    padding: 20
                                                                }
                                                            }
                                                        }
                                                    }
                                                });

                                                // AI Performance Chart
                                                const aiCtx = document.getElementById('aiPerformanceChart').getContext('2d');
                                                new Chart(aiCtx, {
                                                    type: 'radar',
                                                    data: {
                                                        labels: ['Spam Detection', 'Inappropriate Content', 'Harassment', 'Fake Info', 'Copyright'],
                                                        datasets: [{
                                                                label: 'AI Performance',
                                                                data: [85, 92, 78, 88, 82],
                                                                borderColor: '#6f42c1',
                                                                backgroundColor: 'rgba(111, 66, 193, 0.1)',
                                                                pointBackgroundColor: '#6f42c1',
                                                                pointBorderColor: '#fff',
                                                                pointHoverBackgroundColor: '#fff',
                                                                pointHoverBorderColor: '#6f42c1'
                                                            }]
                                                    },
                                                    options: {
                                                        responsive: true,
                                                        maintainAspectRatio: false,
                                                        plugins: {
                                                            legend: {
                                                                display: false
                                                            }
                                                        },
                                                        scales: {
                                                            r: {
                                                                beginAtZero: true,
                                                                max: 100,
                                                                grid: {
                                                                    color: 'rgba(0,0,0,0.1)'
                                                                },
                                                                angleLines: {
                                                                    color: 'rgba(0,0,0,0.1)'
                                                                },
                                                                pointLabels: {
                                                                    font: {
                                                                        size: 11
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                });
                                            }

                                            // Update data based on time period
                                            function updateData(period) {
                                                fetch(contextPath + '/admin/moderation/overview/data?period=' + period)
                                                        .then(response => response.json())
                                                        .then(data => {
                                                            if (data.success) {
                                                                updateMetrics(data.metrics);
                                                                updateCharts(data.charts);
                                                                showToast('Đã cập nhật dữ liệu cho ' + period, 'info');
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Error updating data:', error);
                                                            showToast('Có lỗi khi cập nhật dữ liệu', 'error');
                                                        });
                                            }

                                            // Update metric cards
                                            function updateMetrics(metrics) {
                                                document.querySelector('.metric-number.text-warning').textContent = metrics.pending || 0;
                                                document.querySelector('.metric-number.text-success').textContent = metrics.approved || 0;
                                                document.querySelector('.metric-number.text-danger').textContent = metrics.rejected || 0;
                                                document.querySelector('.metric-number.text-info').textContent = metrics.aiDetected || 0;
                                            }

                                            // Update charts with new data
                                            function updateCharts(chartData) {
                                                // Implementation for updating charts with new data
                                                // This would update the existing Chart.js instances
                                            }

                                            // View activity details
                                            function viewActivity(contentType, contentId) {
                                                window.open(contextPath + '/admin/' + contentType.toLowerCase() + 's/' + contentId, '_blank');
                                            }

                                            // Show bulk approval modal
                                            function showBulkApproval() {
                                                if (confirm('Mở công cụ duyệt hàng loạt?')) {
                                                    window.location.href = contextPath + '/admin/content/moderation?bulk=true';
                                                }
                                            }

                                            // Export overview report
                                            function exportOverview() {
                                                window.location.href = contextPath + '/admin/reports/moderation-overview/export';
                                            }

                                            // Show toast notification
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

                                                toast.addEventListener('hidden.bs.toast', function () {
                                                    toast.remove();
                                                });
                                            }

                                            // Escape HTML to prevent XSS
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

                                            // Auto-refresh every 5 minutes
                                            setInterval(function () {
                                                if (document.visibilityState === 'visible') {
                                                    const activePeriod = document.querySelector('[data-period].btn-primary').dataset.period;
                                                    updateData(activePeriod);
                                                }
                                            }, 300000); // 5 minutes

                                            // Real-time updates for high priority alerts
                                            function checkHighPriorityUpdates() {
                                                fetch(contextPath + '/admin/moderation/high-priority/count')
                                                        .then(response => response.json())
                                                        .then(data => {
                                                            if (data.count > 0) {
                                                                const alertBanner = document.querySelector('.alert-banner');
                                                                if (alertBanner) {
                                                                    alertBanner.querySelector('h5').textContent =
                                                                            'Cảnh báo: Có ' + data.count + ' nội dung ưu tiên cao cần xử lý!';
                                                                } else {
                                                                    // Create new alert banner if it doesn't exist
                                                                    createHighPriorityAlert(data.count);
                                                                }
                                                            }
                                                        })
                                                        .catch(error => console.log('High priority check failed:', error));
                                            }

                                            // Create high priority alert banner
                                            function createHighPriorityAlert(count) {
                                                const alertHtml =
                                                        '<div class="alert alert-banner d-flex align-items-center">' +
                                                        '<i class="fas fa-exclamation-triangle fa-2x me-3"></i>' +
                                                        '<div>' +
                                                        '<h5 class="mb-1">Cảnh báo: Có ' + count + ' nội dung ưu tiên cao cần xử lý!</h5>' +
                                                        '<p class="mb-0">Các nội dung này có thể ảnh hưởng nghiêm trọng đến trải nghiệm người dùng.</p>' +
                                                        '</div>' +
                                                        '<a href="' + contextPath + '/admin/content/moderation?priority=high" class="btn btn-light ms-auto">' +
                                                        '<i class="fas fa-arrow-right me-1"></i>Xử lý ngay' +
                                                        '</a>' +
                                                        '</div>';

                                                const overviewHeader = document.querySelector('.overview-header');
                                                overviewHeader.insertAdjacentHTML('afterend', alertHtml);
                                            }

                                            // Check for high priority updates every 2 minutes
                                            setInterval(checkHighPriorityUpdates, 120000); // 2 minutes

                                            // Keyboard shortcuts
                                            document.addEventListener('keydown', function (e) {
                                                if (e.ctrlKey || e.metaKey) {
                                                    switch (e.key) {
                                                        case '1':
                                                            e.preventDefault();
                                                            window.location.href = contextPath + '/admin/content/moderation?priority=high';
                                                            break;
                                                        case '2':
                                                            e.preventDefault();
                                                            window.location.href = contextPath + '/admin/content/moderation?ai_detected=true';
                                                            break;
                                                        case '3':
                                                            e.preventDefault();
                                                            window.location.href = contextPath + '/admin/content/delete?tab=reported';
                                                            break;
                                                        case 'e':
                                                            e.preventDefault();
                                                            exportOverview();
                                                            break;
                                                    }
                                                }
                                            });

                                            // Show keyboard shortcuts on ? key
                                            document.addEventListener('keydown', function (e) {
                                                if (e.key === '?' && !e.ctrlKey && !e.metaKey &&
                                                        document.activeElement.tagName !== 'INPUT' &&
                                                        document.activeElement.tagName !== 'TEXTAREA') {

                                                    const helpMessage =
                                                            'Phím tắt hữu ích:\n' +
                                                            'Ctrl + 1: Xem ưu tiên cao\n' +
                                                            'Ctrl + 2: Xem AI phát hiện\n' +
                                                            'Ctrl + 3: Xem bị báo cáo\n' +
                                                            'Ctrl + E: Xuất báo cáo\n' +
                                                            '?: Hiện trợ giúp này';

                                                    alert(helpMessage);
                                                }
                                            });
        </script>
    </body>
</html>