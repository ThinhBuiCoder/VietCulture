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
<div class="container-fluid" style="margin-left:250px; max-width:calc(100vw - 250px);">
    <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-9 mx-auto">
            <div class="card shadow-sm rounded-4 p-4 mt-5 mb-5">
                <h2 class="mb-4 text-center"><i class="fas fa-flag me-2"></i> Danh sách Khiếu nại của người dùng</h2>
                <div class="table-responsive" style="overflow-x:auto;">
                <table class="table mb-0 align-middle">
                    <thead class="table-light" style="text-align:center; vertical-align:middle;">
                        <tr>
                            <th><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-layer-group"></i> Loại nội dung</th>
                            <th><i class="fas fa-exclamation-circle"></i> Lý do</th>
                            <th><i class="fas fa-align-left"></i> Mô tả</th>
                            <th><i class="fas fa-user"></i> Người báo cáo (ID)</th>
                            <th><i class="fas fa-calendar-alt"></i> Ngày tạo</th>
                            <th><i class="fas fa-info-circle"></i> Trạng thái</th>
                            <th><i class="fas fa-cogs"></i> Hành động</th>
                        </tr>
                    </thead>
                    <tbody style="text-align:center;">
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
                            <td><i class="fas fa-user me-1"></i> <%= r.getReporterId() %></td>
                            <td><i class="fas fa-calendar-alt me-1"></i> <%= r.getCreatedAt() %></td>
                            <td><span class="<%= badgeClass %>"><%= status %></span></td>
                            <td>
                                <a class="btn btn-sm btn-outline-primary" href="<%=request.getContextPath()%>/admin/reports/<%=r.getReportId()%>"><i class="fas fa-eye"></i> Xem</a>
                            </td>
                        </tr>
                    <% 
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="8" class="text-center align-middle" style="height:220px; color:#888; font-size:1.1em; padding:32px 0; vertical-align:middle;">
                                <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%;">
                                    <i class="fas fa-inbox fa-2x mb-2 text-muted"></i>
                                    <span>Không có báo cáo nào chờ duyệt.</span>
                                </div>
                            </td>
                        </tr>
                    <% 
                        }
                    %>
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html> 