<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
.admin-sidebar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: rgba(255,255,255,0.3) transparent;
}

.admin-sidebar::-webkit-scrollbar {
    width: 6px;
}

.admin-sidebar::-webkit-scrollbar-track {
    background: transparent;
}

.admin-sidebar::-webkit-scrollbar-thumb {
    background: rgba(255,255,255,0.3);
    border-radius: 3px;
}

.sidebar-heading {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    font-weight: 600;
}

.nav-link {
    position: relative;
    padding: 0.75rem 1rem;
    border-radius: 0.5rem;
    margin: 0.125rem 0.5rem;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    text-decoration: none;
}

.nav-link:hover {
    background-color: rgba(255,255,255,0.15);
    transform: translateX(3px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.nav-link.active {
    background-color: rgba(255,255,255,0.2);
    border-left: 4px solid #fff;
    transform: translateX(3px);
    box-shadow: 0 2px 12px rgba(0,0,0,0.2);
}

.nav-link i {
    width: 20px;
    text-align: center;
}

.status-indicator {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    display: inline-block;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.5; }
    100% { opacity: 1; }
}

.dropdown-menu-dark {
    background-color: rgba(0,0,0,0.8);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.1);
}

.dropdown-item:hover {
    background-color: rgba(255,255,255,0.1);
}

.badge {
    font-size: 0.6rem;
    padding: 0.25rem 0.5rem;
    border-radius: 10px;
}

.btn-outline-light {
    border-width: 1px;
    transition: all 0.3s ease;
}

.btn-outline-light:hover {
    background-color: rgba(255,255,255,0.2);
    border-color: rgba(255,255,255,0.5);
    transform: translateY(-1px);
}

/* Special badge for combined content approval */
.badge-combined {
    background: linear-gradient(45deg, #28a745, #20c997);
    animation: gradient-shift 3s ease-in-out infinite;
}

@keyframes gradient-shift {
    0%, 100% { background: linear-gradient(45deg, #28a745, #20c997); }
    50% { background: linear-gradient(45deg, #20c997, #28a745); }
}

/* Mobile responsive */
@media (max-width: 768px) {
    .admin-sidebar {
        position: fixed;
        top: 0;
        left: -100%;
        width: 280px;
        height: 100vh;
        z-index: 1050;
        transition: left 0.3s ease;
    }
    
    .admin-sidebar.show {
        left: 0;
    }
}

</style>

<!-- Admin Sidebar -->
<nav class="col-md-3 col-lg-2 d-md-block admin-sidebar collapse">
    <div class="position-sticky pt-3">
        <!-- Logo -->
        <div class="text-center mb-4">
<<<<<<< HEAD
            <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/master/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="Logo" style="height: 60px;"
=======
            <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="Logo" style="height: 60px;"
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
            <div style="display: none;">
                <i class="fas fa-mountain fa-3x text-white"></i>
            </div>
            <h5 class="mt-2 text-white">ADMIN VIETCULTURE</h5>
        </div>
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        <!-- Navigation Menu -->
        <ul class="nav flex-column">
            <!-- Dashboard -->
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/dashboard') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i> 
                    <span>Dashboard</span>
                    <c:if test="${not empty pendingTasks and pendingTasks > 0}">
                        <span class="badge bg-warning ms-auto">${pendingTasks}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <!-- User Management -->
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/users') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/users">
                    <i class="fas fa-users me-2"></i> 
                    <span>Quản lý Users</span>
                    <c:if test="${not empty newUsers and newUsers > 0}">
                        <span class="badge bg-info ms-auto">${newUsers}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <!-- Content Moderation Section -->
            <li class="nav-item mt-3">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mb-2 text-white-50">
                    <span><i class="fas fa-shield-alt me-2"></i>Kiểm duyệt nội dung</span>
                </h6>
            </li>
<<<<<<< HEAD

=======
            
            <!-- NEW: Combined Content Approval -->
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/content/approval') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/content/approval">
                    <i class="fas fa-check-double me-2"></i> 
                    <span>Duyệt nội dung tổng hợp</span>
                    <c:set var="totalPending" value="${(not empty pendingExperiences ? pendingExperiences : 0) + (not empty pendingAccommodations ? pendingAccommodations : 0)}" />
                    <c:if test="${totalPending > 0}">
                        <span class="badge badge-combined ms-auto" title="Tổng experiences + accommodations chờ duyệt">${totalPending}</span>
                    </c:if>
                </a>
            </li>
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/content/moderation') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/content/moderation">
                    <i class="fas fa-eye me-2"></i> 
                    <span>Tổng quan kiểm duyệt</span>
                    <c:if test="${not empty pendingModerationCount and pendingModerationCount > 0}">
                        <span class="badge bg-danger ms-auto">${pendingModerationCount}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/experiences') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/experiences/approval">
                    <i class="fas fa-compass me-2"></i> 
                    <span>Duyệt Experiences</span>
=======
            
            <!-- Separated Experience and Accommodation Management (for detailed view) -->
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/experiences') and not fn:contains(pageContext.request.requestURI, '/admin/content/approval') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/experiences/approval">
                    <i class="fas fa-compass me-2"></i> 
                    <span>Chi tiết Experiences</span>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                    <c:if test="${not empty pendingExperiences and pendingExperiences > 0}">
                        <span class="badge bg-warning ms-auto">${pendingExperiences}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/accommodations') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/accommodations/approval">
                    <i class="fas fa-home me-2"></i> 
                    <span>Duyệt Accommodations</span>
=======
            
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/accommodations') and not fn:contains(pageContext.request.requestURI, '/admin/content/approval') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/accommodations/approval">
                    <i class="fas fa-home me-2"></i> 
                    <span>Chi tiết Accommodations</span>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                    <c:if test="${not empty pendingAccommodations and pendingAccommodations > 0}">
                        <span class="badge bg-warning ms-auto">${pendingAccommodations}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/content/delete') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/content/delete">
                    <i class="fas fa-trash me-2"></i> 
                    <span>Xóa nội dung vi phạm</span>
                    <c:if test="${not empty reportedContent and reportedContent > 0}">
                        <span class="badge bg-danger ms-auto">${reportedContent}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <!-- Bookings Section -->
            <li class="nav-item mt-3">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mb-2 text-white-50">
                    <span><i class="fas fa-calendar-check me-2"></i>Quản lý Bookings</span>
                </h6>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/bookings') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/bookings">
                    <i class="fas fa-calendar-alt me-2"></i> 
                    <span>Tất cả Bookings</span>
                    <c:if test="${not empty todayBookings and todayBookings > 0}">
                        <span class="badge bg-success ms-auto">${todayBookings}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <!-- Statistics Section -->
            <li class="nav-item mt-3">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mb-2 text-white-50">
                    <span><i class="fas fa-chart-bar me-2"></i>Thống kê & Báo cáo</span>
                </h6>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/statistics/users') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/statistics/users">
                    <i class="fas fa-users-cog me-2"></i> 
                    <span>Thống kê Users</span>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/statistics/content') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/statistics/content">
                    <i class="fas fa-chart-pie me-2"></i> 
                    <span>Thống kê Content</span>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/statistics/bookings') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/statistics/bookings">
                    <i class="fas fa-chart-line me-2"></i> 
                    <span>Thống kê Bookings</span>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/reports') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/reports/system">
                    <i class="fas fa-file-alt me-2"></i> 
                    <span>Báo cáo hệ thống</span>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <!-- Support Section -->
            <li class="nav-item mt-3">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mb-2 text-white-50">
                    <span><i class="fas fa-life-ring me-2"></i>Hỗ trợ</span>
                </h6>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/complaints') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/complaints">
                    <i class="fas fa-exclamation-triangle me-2"></i> 
                    <span>Khiếu nại</span>
                    <c:if test="${not empty newComplaints and newComplaints > 0}">
                        <span class="badge bg-danger ms-auto">${newComplaints}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/support') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/support/tickets">
                    <i class="fas fa-headset me-2"></i> 
                    <span>Support Tickets</span>
                    <c:if test="${not empty openTickets and openTickets > 0}">
                        <span class="badge bg-info ms-auto">${openTickets}</span>
                    </c:if>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <!-- System Settings -->
            <li class="nav-item mt-3">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mb-2 text-white-50">
                    <span><i class="fas fa-cogs me-2"></i>Cài đặt hệ thống</span>
                </h6>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/settings/general') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/settings/general">
                    <i class="fas fa-cog me-2"></i> 
                    <span>Cài đặt chung</span>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/settings/email') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/settings/email">
                    <i class="fas fa-envelope me-2"></i> 
                    <span>Cài đặt Email</span>
                </a>
            </li>
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            <li class="nav-item">
                <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/settings/payments') ? 'active text-white' : 'text-white-50'}" 
                   href="${pageContext.request.contextPath}/admin/settings/payments">
                    <i class="fas fa-credit-card me-2"></i> 
                    <span>Cài đặt thanh toán</span>
                </a>
            </li>
        </ul>
<<<<<<< HEAD

        <!-- Divider -->
        <hr class="text-white-50 my-4">

=======
        
        <!-- Divider -->
        <hr class="text-white-50 my-4">
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        <!-- Quick Actions -->
        <div class="mb-3">
            <h6 class="sidebar-heading px-3 mb-2 text-white-50">
                <span><i class="fas fa-bolt me-2"></i>Thao tác nhanh</span>
            </h6>
            <div class="px-3">
<<<<<<< HEAD
=======
                <button type="button" class="btn btn-outline-light btn-sm w-100 mb-2" onclick="quickApproveAll()" title="Duyệt tất cả nội dung pending">
                    <i class="fas fa-check-double me-1"></i> Duyệt tất cả
                </button>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                <button type="button" class="btn btn-outline-light btn-sm w-100 mb-2" onclick="quickBackup()" title="Sao lưu dữ liệu hệ thống">
                    <i class="fas fa-database me-1"></i> Backup ngay
                </button>
                <button type="button" class="btn btn-outline-light btn-sm w-100 mb-2" onclick="clearCache()" title="Xóa cache để cải thiện hiệu suất">
                    <i class="fas fa-broom me-1"></i> Xóa Cache
                </button>
                <button type="button" class="btn btn-outline-light btn-sm w-100" onclick="viewLogs()" title="Xem nhật ký hệ thống">
                    <i class="fas fa-list-ul me-1"></i> Xem Logs
                </button>
            </div>
        </div>
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        <!-- System Status -->
        <div class="px-3 mb-3">
            <h6 class="sidebar-heading mb-2 text-white-50">
                <span><i class="fas fa-server me-2"></i>Trạng thái hệ thống</span>
            </h6>
            <div class="d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <span class="status-indicator bg-success me-2" id="systemStatus"></span>
                    <small class="text-white">System Online</small>
                </div>
                <small class="text-white-50" id="uptime">24h</small>
            </div>
            <div class="mt-1">
                <small class="text-white-50">Cập nhật: <span id="lastUpdate"></span></small>
            </div>
<<<<<<< HEAD
        </div>

=======
            <div class="mt-1">
                <small class="text-white-50">Pending: <span id="totalPendingCount">${(not empty pendingExperiences ? pendingExperiences : 0) + (not empty pendingAccommodations ? pendingAccommodations : 0)}</span> nội dung</small>
            </div>
        </div>
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        <!-- User Profile -->
        <div class="dropdown">
            <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle px-3 py-2" 
               data-bs-toggle="dropdown" aria-expanded="false"
               style="border-radius: 8px; background: rgba(255,255,255,0.1);">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.avatar}">
                        <img src="${pageContext.request.contextPath}/assets/images/avatars/${sessionScope.user.avatar}" 
                             alt="Avatar" width="32" height="32" class="rounded-circle me-2"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-block';">
                        <i class="fas fa-user-circle me-2" style="font-size: 32px; display: none;"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-user-circle me-2" style="font-size: 32px;"></i>
                    </c:otherwise>
                </c:choose>
                <div class="flex-grow-1">
                    <div class="fw-bold">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}</div>
                    <small class="text-white-50">Administrator</small>
                </div>
                <i class="fas fa-chevron-down ms-2"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-dark text-small shadow-lg">
                <li>
                    <h6 class="dropdown-header">
                        <i class="fas fa-user me-1"></i> Tài khoản
                    </h6>
                </li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
<<<<<<< HEAD
                        <i class="fas fa-user-edit me-2"></i> Chỉnh sửa Profile
                    </a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/settings/profile">
                        <i class="fas fa-key me-2"></i> Đổi mật khẩu
                    </a></li>
=======
                    <i class="fas fa-user-edit me-2"></i> Chỉnh sửa Profile
                </a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/settings/profile">
                    <i class="fas fa-key me-2"></i> Đổi mật khẩu
                </a></li>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
                <li><hr class="dropdown-divider"></li>
                <li>
                    <h6 class="dropdown-header">
                        <i class="fas fa-shield-alt me-1"></i> Bảo mật
                    </h6>
                </li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/security/sessions">
<<<<<<< HEAD
                        <i class="fas fa-desktop me-2"></i> Quản lý Sessions
                    </a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/security/logs">
                        <i class="fas fa-history me-2"></i> Login History
                    </a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout" onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?')">
                        <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                    </a></li>
=======
                    <i class="fas fa-desktop me-2"></i> Quản lý Sessions
                </a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/security/logs">
                    <i class="fas fa-history me-2"></i> Login History
                </a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/content/approval">
                    <i class="fas fa-check-double me-2"></i> Duyệt nội dung nhanh
                </a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout" onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?')">
                    <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                </a></li>
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            </ul>
        </div>
    </div>
</nav>

<script>
// Context path for consistent URL building
<<<<<<< HEAD
    const contextPath = '${pageContext.request.contextPath}';

// Quick action functions
    function quickBackup() {
        if (confirm('Bạn có chắc chắn muốn thực hiện backup hệ thống?\nQuá trình này có thể mất vài phút.')) {
            const btn = event.target;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang backup...';
            btn.disabled = true;

            fetch(contextPath + '/admin/system/backup', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            showNotification('Backup thành công!', 'success');
                        } else {
                            showNotification('Backup thất bại: ' + (data.message || 'Unknown error'), 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Backup error:', error);
                        showNotification('Lỗi kết nối: ' + error.message, 'error');
                    })
                    .finally(() => {
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    });
        }
    }

    function clearCache() {
        if (confirm('Bạn có chắc chắn muốn xóa cache hệ thống?\nViệc này có thể làm chậm website trong thời gian ngắn.')) {
            const btn = event.target;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang xóa...';
            btn.disabled = true;

            fetch(contextPath + '/admin/system/clear-cache', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            showNotification('Đã xóa cache thành công!', 'success');
                        } else {
                            showNotification('Xóa cache thất bại: ' + (data.message || 'Unknown error'), 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Clear cache error:', error);
                        showNotification('Lỗi kết nối: ' + error.message, 'error');
                    })
                    .finally(() => {
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    });
        }
    }

    function viewLogs() {
        window.open(contextPath + '/admin/system/logs', '_blank');
    }

    function showNotification(message, type) {
        // Remove existing notifications
        const existingToasts = document.querySelectorAll('.admin-notification-toast');
        existingToasts.forEach(toast => toast.remove());

        // Create a simple notification toast
        const toast = document.createElement('div');
        let alertClass = 'alert alert-success position-fixed admin-notification-toast';
        let iconClass = 'fas fa-check-circle me-2';

        if (type === 'error') {
            alertClass = 'alert alert-danger position-fixed admin-notification-toast';
            iconClass = 'fas fa-exclamation-circle me-2';
        } else if (type === 'warning') {
            alertClass = 'alert alert-warning position-fixed admin-notification-toast';
            iconClass = 'fas fa-exclamation-triangle me-2';
        } else if (type === 'info') {
            alertClass = 'alert alert-info position-fixed admin-notification-toast';
            iconClass = 'fas fa-info-circle me-2';
        }

        toast.className = alertClass;
        toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
        toast.innerHTML =
                '<div class="d-flex align-items-center">' +
                '<i class="' + iconClass + '"></i>' +
                '<span>' + escapeHtml(message) + '</span>' +
                '<button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()" aria-label="Close"></button>' +
                '</div>';

        document.body.appendChild(toast);

        // Auto remove after 5 seconds
        setTimeout(function () {
            if (toast.parentElement) {
                toast.remove();
            }
        }, 5000);
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

// Update system status and time
    function updateSystemInfo() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('vi-VN', {
            hour: '2-digit',
            minute: '2-digit'
        });

        const lastUpdateElement = document.getElementById('lastUpdate');
        if (lastUpdateElement) {
            lastUpdateElement.textContent = timeString;
        }

        // Update system status
        const statusElement = document.getElementById('systemStatus');
        if (statusElement) {
            // You can fetch actual system status from server here
            statusElement.className = 'status-indicator bg-success me-2';
        }

        // Update uptime (sample calculation)
        const uptimeElement = document.getElementById('uptime');
        if (uptimeElement) {
            const hours = now.getHours();
            uptimeElement.textContent = hours + 'h';
        }
    }

// Update every minute
    setInterval(updateSystemInfo, 60000);

// Initial call
    document.addEventListener('DOMContentLoaded', function () {
        updateSystemInfo();

        // Handle mobile sidebar toggle
        const sidebar = document.querySelector('.admin-sidebar');
        const toggleBtn = document.querySelector('[data-bs-toggle="collapse"][data-bs-target*="sidebar"]');

        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener('click', function (e) {
                e.preventDefault();
                sidebar.classList.toggle('show');
            });

            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function (e) {
                if (window.innerWidth <= 768 &&
                        sidebar &&
                        !sidebar.contains(e.target) &&
                        toggleBtn &&
                        !toggleBtn.contains(e.target) &&
                        sidebar.classList.contains('show')) {
                    sidebar.classList.remove('show');
                }
            });

            // Handle window resize
            window.addEventListener('resize', function () {
                if (window.innerWidth > 768 && sidebar && sidebar.classList.contains('show')) {
                    sidebar.classList.remove('show');
                }
            });
        }

        // Add smooth scrolling to sidebar links
        const sidebarLinks = document.querySelectorAll('.admin-sidebar .nav-link');
        sidebarLinks.forEach(link => {
            link.addEventListener('click', function (e) {
                // Close mobile sidebar when link is clicked
                if (window.innerWidth <= 768 && sidebar && sidebar.classList.contains('show')) {
                    sidebar.classList.remove('show');
                }
            });
        });
    });
=======
const contextPath = '${pageContext.request.contextPath}';

// NEW: Quick approve all function
function quickApproveAll() {
    if (confirm('Bạn có chắc chắn muốn duyệt TẤT CẢ nội dung đang chờ?\nBao gồm cả experiences và accommodations.')) {
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang duyệt...';
        btn.disabled = true;
        
        fetch(contextPath + '/admin/content/approve-all', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                const count = data.data?.count || 0;
                const total = data.data?.total || 0;
                showNotification('Đã duyệt ' + count + '/' + total + ' nội dung thành công!', 'success');
                
                // Update pending count in sidebar
                const pendingCountElement = document.getElementById('totalPendingCount');
                if (pendingCountElement) {
                    const remaining = total - count;
                    pendingCountElement.textContent = remaining;
                }
                
                // Refresh the page if we're on content approval page
                if (window.location.pathname.includes('/admin/content/approval')) {
                    setTimeout(() => window.location.reload(), 2000);
                }
            } else {
                showNotification('Duyệt thất bại: ' + (data.message || 'Unknown error'), 'error');
            }
        })
        .catch(error => {
            console.error('Approve all error:', error);
            showNotification('Lỗi kết nối: ' + error.message, 'error');
        })
        .finally(() => {
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    }
}

// Quick action functions
function quickBackup() {
    if (confirm('Bạn có chắc chắn muốn thực hiện backup hệ thống?\nQuá trình này có thể mất vài phút.')) {
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang backup...';
        btn.disabled = true;
        
        fetch(contextPath + '/admin/system/backup', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showNotification('Backup thành công!', 'success');
            } else {
                showNotification('Backup thất bại: ' + (data.message || 'Unknown error'), 'error');
            }
        })
        .catch(error => {
            console.error('Backup error:', error);
            showNotification('Lỗi kết nối: ' + error.message, 'error');
        })
        .finally(() => {
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    }
}

function clearCache() {
    if (confirm('Bạn có chắc chắn muốn xóa cache hệ thống?\nViệc này có thể làm chậm website trong thời gian ngắn.')) {
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang xóa...';
        btn.disabled = true;
        
        fetch(contextPath + '/admin/system/clear-cache', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showNotification('Đã xóa cache thành công!', 'success');
            } else {
                showNotification('Xóa cache thất bại: ' + (data.message || 'Unknown error'), 'error');
            }
        })
        .catch(error => {
            console.error('Clear cache error:', error);
            showNotification('Lỗi kết nối: ' + error.message, 'error');
        })
        .finally(() => {
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    }
}

function viewLogs() {
    window.open(contextPath + '/admin/system/logs', '_blank');
}

function showNotification(message, type) {
    // Remove existing notifications
    const existingToasts = document.querySelectorAll('.admin-notification-toast');
    existingToasts.forEach(toast => toast.remove());
    
    // Create a simple notification toast
    const toast = document.createElement('div');
    let alertClass = 'alert alert-success position-fixed admin-notification-toast';
    let iconClass = 'fas fa-check-circle me-2';
    
    if (type === 'error') {
        alertClass = 'alert alert-danger position-fixed admin-notification-toast';
        iconClass = 'fas fa-exclamation-circle me-2';
    } else if (type === 'warning') {
        alertClass = 'alert alert-warning position-fixed admin-notification-toast';
        iconClass = 'fas fa-exclamation-triangle me-2';
    } else if (type === 'info') {
        alertClass = 'alert alert-info position-fixed admin-notification-toast';
        iconClass = 'fas fa-info-circle me-2';
    }
    
    toast.className = alertClass;
    toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
    toast.innerHTML = 
        '<div class="d-flex align-items-center">' +
            '<i class="' + iconClass + '"></i>' +
            '<span>' + escapeHtml(message) + '</span>' +
            '<button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()" aria-label="Close"></button>' +
        '</div>';
    
    document.body.appendChild(toast);
    
    // Auto remove after 5 seconds
    setTimeout(function() {
        if (toast.parentElement) {
            toast.remove();
        }
    }, 5000);
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

// Update system status and time
function updateSystemInfo() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('vi-VN', { 
        hour: '2-digit', 
        minute: '2-digit' 
    });
    
    const lastUpdateElement = document.getElementById('lastUpdate');
    if (lastUpdateElement) {
        lastUpdateElement.textContent = timeString;
    }
    
    // Update system status
    const statusElement = document.getElementById('systemStatus');
    if (statusElement) {
        // You can fetch actual system status from server here
        statusElement.className = 'status-indicator bg-success me-2';
    }
    
    // Update uptime (sample calculation)
    const uptimeElement = document.getElementById('uptime');
    if (uptimeElement) {
        const hours = now.getHours();
        uptimeElement.textContent = hours + 'h';
    }
    
    // Update pending count from server (optional - can be implemented with AJAX)
    updatePendingCount();
}

// Function to update pending content count
function updatePendingCount() {
    // This can be implemented to fetch real-time pending count
    fetch(contextPath + '/admin/api/pending-count', {
        method: 'GET',
        headers: { 
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
    })
    .then(data => {
        if (data && data.totalPending !== undefined) {
            const pendingCountElement = document.getElementById('totalPendingCount');
            if (pendingCountElement) {
                pendingCountElement.textContent = data.totalPending;
            }
            
            // Update badges in sidebar
            const combinedBadge = document.querySelector('a[href*="/admin/content/approval"] .badge-combined');
            if (combinedBadge && data.totalPending > 0) {
                combinedBadge.textContent = data.totalPending;
                combinedBadge.style.display = 'inline-block';
            } else if (combinedBadge && data.totalPending === 0) {
                combinedBadge.style.display = 'none';
            }
        }
    })
    .catch(error => {
        // Silently handle error - don't show notification for background updates
        console.debug('Pending count update failed:', error);
    });
}

// Update every minute
setInterval(updateSystemInfo, 60000);

// Initial call
document.addEventListener('DOMContentLoaded', function() {
    updateSystemInfo();
    
    // Handle mobile sidebar toggle
    const sidebar = document.querySelector('.admin-sidebar');
    const toggleBtn = document.querySelector('[data-bs-toggle="collapse"][data-bs-target*="sidebar"]');
    
    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', function(e) {
            e.preventDefault();
            sidebar.classList.toggle('show');
        });
        
        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', function(e) {
            if (window.innerWidth <= 768 && 
                sidebar && 
                !sidebar.contains(e.target) && 
                toggleBtn && 
                !toggleBtn.contains(e.target) && 
                sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
            }
        });
        
        // Handle window resize
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768 && sidebar && sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
            }
        });
    }
    
    // Add smooth scrolling to sidebar links
    const sidebarLinks = document.querySelectorAll('.admin-sidebar .nav-link');
    sidebarLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Close mobile sidebar when link is clicked
            if (window.innerWidth <= 768 && sidebar && sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
            }
        });
    });
    
    // Add keyboard shortcuts for admin
    document.addEventListener('keydown', function(e) {
        // Ctrl+Shift+A for quick approve all
        if (e.ctrlKey && e.shiftKey && e.key === 'A') {
            e.preventDefault();
            quickApproveAll();
        }
        
        // Ctrl+Shift+C for content approval page
        if (e.ctrlKey && e.shiftKey && e.key === 'C') {
            e.preventDefault();
            window.location.href = contextPath + '/admin/content/approval';
        }
        
        // Ctrl+Shift+D for dashboard
        if (e.ctrlKey && e.shiftKey && e.key === 'D') {
            e.preventDefault();
            window.location.href = contextPath + '/admin/dashboard';
        }
    });
    
    // Add tooltip information for keyboard shortcuts
    const approveAllBtn = document.querySelector('button[onclick*="quickApproveAll"]');
    if (approveAllBtn) {
        approveAllBtn.title += ' (Ctrl+Shift+A)';
    }
    
    // Auto-refresh pending count every 2 minutes if user is active
    let lastActivity = Date.now();
    document.addEventListener('mousemove', () => lastActivity = Date.now());
    document.addEventListener('keypress', () => lastActivity = Date.now());
    
    setInterval(() => {
        // Only update if user was active in the last 5 minutes
        if (Date.now() - lastActivity < 5 * 60 * 1000) {
            updatePendingCount();
        }
    }, 2 * 60 * 1000); // Every 2 minutes
    
    // Show welcome message for new admin sessions
    const isNewSession = sessionStorage.getItem('adminSessionWelcome') !== 'shown';
    if (isNewSession && window.location.pathname.includes('/admin/')) {
        sessionStorage.setItem('adminSessionWelcome', 'shown');
        setTimeout(() => {
            showNotification('Chào mừng đến Admin Panel! Sử dụng Ctrl+Shift+C để mở trang duyệt nội dung nhanh.', 'info');
        }, 1000);
    }
});

// Expose functions globally for onclick handlers
window.quickApproveAll = quickApproveAll;
window.quickBackup = quickBackup;
window.clearCache = clearCache;
window.viewLogs = viewLogs;
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
</script>