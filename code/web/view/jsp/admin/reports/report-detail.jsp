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
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background: #f7f9fb;
        }
        .admin-report-detail-container {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 80vh;
            padding-top: 40px;
        }
        .report-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 36px 40px 28px 40px;
            min-width: 400px;
            max-width: 480px;
            width: 100%;
        }
        .report-header {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1976d2;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
        }
        .report-info {
            font-size: 1.08rem;
            color: #333;
            margin-bottom: 32px;
        }
        .report-info div {
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
        }
        .report-info span:first-child {
            font-weight: 600;
            color: #555;
        }
        .badge {
            display: inline-block;
            padding: 4px 14px;
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 600;
            margin-left: 8px;
        }
        .badge-pending { background: #ffe082; color: #a67c00; }
        .badge-approved { background: #81c784; color: #1b5e20; }
        .badge-rejected { background: #e57373; color: #b71c1c; }
        .report-actions {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-top: 12px;
        }
        .btn {
            border: none;
            border-radius: 8px;
            padding: 10px 22px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-approve {
            background: #1976d2;
            color: #fff;
        }
        .btn-approve:hover {
            background: #1565c0;
        }
        .btn-reject {
            background: #fff;
            color: #d32f2f;
            border: 1.5px solid #d32f2f;
        }
        .btn-reject:hover {
            background: #d32f2f;
            color: #fff;
        }
        .back-link {
            margin-left: auto;
            color: #1976d2;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.2s;
        }
        .back-link:hover {
            color: #0d47a1;
        }
        @media (max-width: 600px) {
            .report-card { padding: 16px 6px; min-width: unset; max-width: 98vw; }
            .report-header { font-size: 1.1rem; }
        }
    </style>
</head>
<body>
<div class="admin-report-detail-container">
  <div class="report-card">
    <div class="report-header">
      <i class="fa-solid fa-flag"></i>
      <span>Chi tiết Khiếu nại</span>
    </div>
    <%
        model.Report report = (model.Report) request.getAttribute("report");
        if (report != null) {
            String status = report.getAdminApprovalStatus() != null ? report.getAdminApprovalStatus() : "PENDING";
            String badgeClass = "badge ";
            if ("PENDING".equals(status)) badgeClass += "badge-pending";
            else if ("APPROVED".equals(status)) badgeClass += "badge-approved";
            else if ("REJECTED".equals(status)) badgeClass += "badge-rejected";
    %>
    <div class="report-info">
      <div><span>ID Khiếu nại:</span> <%= report.getReportId() %></div>
      <div><span>ID nội dung:</span> <%= report.getContentId() %></div>
      <div><span>Loại nội dung:</span> <%= report.getContentTypeText() %></div>
      <div><span>Lý do:</span> <%= report.getReason() %></div>
      <div><span>Mô tả:</span> <%= report.getDescription() %></div>
      <div><span>Người báo cáo (ID):</span> <%= report.getReporterId() %></div>
      <div><span>Ngày tạo:</span> <%= report.getCreatedAt() %></div>
      <div>
        <span>Trạng thái:</span>
        <span class="<%= badgeClass %>"><%= status %></span>
      </div>
    </div>
    <% if (report != null && "PENDING".equals(status)) { %>
    <div class="report-actions">
      <form method="post" action="<%=request.getContextPath()%>/admin/reports/<%= report.getReportId() %>/approve">
        <input type="hidden" name="reportId" value="<%= report.getReportId() %>"/>
        <button type="submit" name="action" value="approve" class="btn btn-approve">
          <i class="fa-solid fa-check"></i> Duyệt
        </button>
      </form>
      <form method="post" action="<%=request.getContextPath()%>/admin/reports/<%= report.getReportId() %>/reject">
        <input type="hidden" name="reportId" value="<%= report.getReportId() %>"/>
        <button type="submit" name="action" value="reject" class="btn btn-reject">
          <i class="fa-solid fa-xmark"></i> Từ chối
        </button>
      </form>
    </div>
    <% } %>
    <% } else { %>
    <div style="color: #888; margin-bottom: 24px;">Không tìm thấy thông tin báo cáo.</div>
    <% } %>
    <a href="<%=request.getContextPath()%>/admin/reports" class="back-link" style="margin-top: 32px;">
      <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
    </a>
  </div>
</div>
</body>
</html>