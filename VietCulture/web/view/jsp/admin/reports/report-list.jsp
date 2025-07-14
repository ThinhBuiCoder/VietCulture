<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../includes/admin-sidebar.jsp" %>
<%@ page import="model.Report" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khiếu nại - Admin</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/view/assets/css/enhanced-components.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 24px;
            margin-top: 32px;
        }
        .table {
            width: 100%;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
        }
        .table th, .table td {
            padding: 12px 10px;
            text-align: left;
        }
        .table th {
            background: #f6f8fa;
            font-weight: 600;
        }
        .badge-status {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 0.9em;
            color: #fff;
        }
        .badge-pending { background: #f1c40f; }
        .badge-approved { background: #27ae60; }
        .badge-rejected { background: #e74c3c; }
        @media (max-width: 900px) {
            .card { padding: 10px; }
            .table th, .table td { padding: 6px 4px; font-size: 0.95em; }
        }
    </style>
</head>
<body style="background: #f4f6fb;">
<div class="container-fluid">
    <div class="card">
        <h2 class="mb-4"><i class="fas fa-flag me-2"></i> Danh sách Khiếu nại của người dùng</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Loại nội dung</th>
                    <th>Lý do</th>
                    <th>Mô tả</th>
                    <th>Người báo cáo (ID)</th>
                    <th>Ngày tạo</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
            <% 
                List<Report> reports = (List<Report>) request.getAttribute("reports");
                if (reports != null && !reports.isEmpty()) {
                    for (Report r : reports) {
                        String status = r.getAdminApprovalStatus() != null ? r.getAdminApprovalStatus() : "PENDING";
                        String badgeClass = "badge-status ";
                        if ("PENDING".equals(status)) badgeClass += "badge-pending";
                        else if ("APPROVED".equals(status)) badgeClass += "badge-approved";
                        else if ("REJECTED".equals(status)) badgeClass += "badge-rejected";
            %>
                <tr>
                    <td><%= r.getReportId() %></td>
                    <td><%= r.getContentTypeText() %></td>
                    <td><%= r.getReason() %></td>
                    <td><%= r.getShortDescription(40) %></td>
                    <td><%= r.getReporterId() %></td>
                    <td><%= r.getCreatedAt() %></td>
                    <td><span class="<%= badgeClass %>"><%= status %></span></td>
                    <td>
                        <a class="btn btn-sm btn-outline-primary" href="<%=request.getContextPath()%>/admin/reports/<%=r.getReportId()%>"><i class="fas fa-eye"></i> Xem</a>
                    </td>
                </tr>
            <% 
                    }
                } else {
            %>
                <tr><td colspan="8" style="text-align:center; color:#888;">Không có báo cáo nào chờ duyệt.</td></tr>
            <% 
                }
            %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html> 