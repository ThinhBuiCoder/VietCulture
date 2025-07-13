<%@ page import="dao.ReportDAO" %>
<%@ page import="model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/plain;charset=UTF-8");

    // Chỉ cho phép POST
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(405); // Method Not Allowed
        out.print("Chỉ hỗ trợ POST");
        return;
    }

    // Kiểm tra đăng nhập
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.setStatus(401); // Unauthorized
        out.print("Bạn cần đăng nhập để báo cáo");
        return;
    }

    String contentType = request.getParameter("contentType");
    String contentIdStr = request.getParameter("contentId");
    String reason = request.getParameter("reason");
    String description = request.getParameter("description");

    if (contentType == null || contentIdStr == null || reason == null) {
        response.setStatus(400); // Bad Request
        out.print("Thiếu tham số bắt buộc");
        return;
    }

    try {
        int contentId = Integer.parseInt(contentIdStr);
        int reporterId = user.getUserId();
        ReportDAO dao = new ReportDAO();
        dao.addReport(contentType, contentId, reporterId, reason, description);
        response.setStatus(200); // OK
        out.print("Báo cáo thành công");
    } catch (NumberFormatException e) {
        response.setStatus(400);
        out.print("contentId không hợp lệ");
    } catch (Exception e) {
        response.setStatus(500);
        out.print("Lỗi hệ thống: " + e.getMessage());
    }
%>
