<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
<style>
.admin-sidebar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    width: 250px;
    min-height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    display: flex;
    flex-direction: column;
    z-index: 1040;
    font-family: 'Inter', Arial, Helvetica, sans-serif;
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
}
.admin-sidebar .sidebar-header {
    text-align: center;
    margin: 32px 0 24px 0;
}
.admin-sidebar .sidebar-header img {
    border-radius: 8px;
    margin-bottom: 8px;
    height: 60px;
}
.admin-sidebar .sidebar-header h5 {
    color: #fff;
    margin-top: 8px;
    font-weight: 600;
    font-size: 18px;
    letter-spacing: 1px;
}
.admin-sidebar .nav {
    flex-direction: column;
    padding-left: 0;
    margin-bottom: 0;
}
.admin-sidebar .nav-link {
    color: #fff;
    padding: 12px 28px;
    border-radius: 8px;
    margin: 4px 12px;
    font-size: 16px;
    font-weight: 500;
    transition: background 0.2s, color 0.2s;
    text-decoration: none;
    background: none;
    display: block;
}
.admin-sidebar .nav-link.active, .admin-sidebar .nav-link:hover {
    background: rgba(255,255,255,0.18);
    color: #fff;
}
.admin-sidebar .sidebar-footer {
    margin-top: auto;
    text-align: center;
    color: #e0e0e0;
    font-size: 14px;
    padding: 18px 0 12px 0;
}
.admin-sidebar .sidebar-footer a {
    color: #e0e0e0;
    text-decoration: none;
    display: block;
    margin-top: 8px;
    font-weight: 500;
}
</style>
<nav class="admin-sidebar">
    <div class="sidebar-header">
        <img src="https://github.com/ThinhBuiCoder/VietCulture/blob/main/VietCulture/build/web/view/assets/home/img/logo1.jpg?raw=true" alt="Logo">
        <h5>ADMIN VIETCULTURE</h5>
    </div>
    <ul class="nav">
        <li class="nav-item">
            <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-chart-bar me-2"></i> Thống kê
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/users') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users me-2"></i> Quản lý Users
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/content/approval') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/content/approval">
                <i class="fas fa-shield-alt me-2"></i> Kiểm duyệt nội dung
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/content/delete') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/content/delete">
                <i class="fas fa-ban me-2"></i> Quản lý nội dung vi phạm
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/bookings') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings">
                <i class="fas fa-calendar-alt me-2"></i> Tất cả Bookings
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${fn:contains(pageContext.request.requestURI, '/admin/reports') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports">
                <i class="fas fa-exclamation-triangle me-2"></i> Khiếu nại
            </a>
        </li>
    </ul>
    <div class="sidebar-footer">
        <div>Admin</div>
        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
    </div>
</nav>