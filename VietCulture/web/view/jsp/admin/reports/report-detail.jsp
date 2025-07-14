<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../includes/admin-sidebar.jsp" %>
<%@ page import="model.Report" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
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
    <div class="row">
        <%-- Sidebar đã include ở trên --%>
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="card" style="max-width: 600px; margin: 40px auto;">
                <h2 class="mb-4"><i class="fas fa-flag me-2"></i> Chi tiết Khiếu nại</h2>
                <%
                    model.Report report = (model.Report) request.getAttribute("report");
                    if (report != null) {
                        String status = report.getAdminApprovalStatus() != null ? report.getAdminApprovalStatus() : "PENDING";
                        String badgeClass = "badge-status ";
                        if ("PENDING".equals(status)) badgeClass += "badge-pending";
                        else if ("APPROVED".equals(status)) badgeClass += "badge-approved";
                        else if ("REJECTED".equals(status)) badgeClass += "badge-rejected";
                %>
                <table class="table table-bordered">
                    <tr>
                        <th>ID Khiếu nại</th>
                        <td><%= report.getReportId() %></td>
                    </tr>
                    <tr>
                        <th>ID nội dung</th>
                        <td><%= report.getContentId() %></td>
                    </tr>
                    <tr>
                        <th>Loại nội dung</th>
                        <td><%= report.getContentTypeText() %></td>
                    </tr>
                    <tr>
                        <th>Lý do</th>
                        <td><%= report.getReason() %></td>
                    </tr>
                    <tr>
                        <th>Mô tả</th>
                        <td><%= report.getDescription() %></td>
                    </tr>
                    <tr>
                        <th>Người báo cáo (ID)</th>
                        <td><%= report.getReporterId() %></td>
                    </tr>
                    <tr>
                        <th>Ngày tạo</th>
                        <td><%= report.getCreatedAt() %></td>
                    </tr>
                    <tr>
                        <th>Trạng thái</th>
                        <td><span class="<%= badgeClass %>"><%= status %></span></td>
                    </tr>
                </table>
                <% if (report != null && "PENDING".equals(status)) { %>
                    <form method="post" action="<%=request.getContextPath()%>/admin/reports/<%= report.getReportId() %>/approve" class="mb-3">
                        <input type="hidden" name="reportId" value="<%= report.getReportId() %>"/>
                        <button type="submit" name="action" value="approve" class="btn btn-success me-2">
                            <i class="fas fa-check"></i> Duyệt
                        </button>
                    </form>
                    <form method="post" action="<%=request.getContextPath()%>/admin/reports/<%= report.getReportId() %>/reject" class="mb-3 d-inline">
                        <input type="hidden" name="reportId" value="<%= report.getReportId() %>"/>
                        <button type="submit" name="action" value="reject" class="btn btn-danger">
                            <i class="fas fa-times"></i> Từ chối
                        </button>
                    </form>
                <% } %>
                <% } else { %>
                <div style="color: #888;">Không tìm thấy thông tin báo cáo.</div>
                <% } %>
                <a href="<%=request.getContextPath()%>/admin/reports" class="btn btn-secondary mt-4">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </main>
    </div>
</div>
</body>
</html>