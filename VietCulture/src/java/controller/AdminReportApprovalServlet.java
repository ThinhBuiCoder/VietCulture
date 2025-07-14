package controller;

import dao.ReportDAO;
import dao.ExperienceDAO;
import dao.AccommodationDAO;
import model.Report;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminReportApprovalServlet", urlPatterns = {"/admin/reports", "/admin/reports/*"})
public class AdminReportApprovalServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminReportApprovalServlet.class.getName());
    private ReportDAO reportDAO = new ReportDAO();
    private ExperienceDAO experienceDAO = new ExperienceDAO();
    private AccommodationDAO accommodationDAO = new AccommodationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String pathInfo = request.getPathInfo();
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Danh sách report PENDING
                List<Report> pendingReports = reportDAO.getReportsByStatus("PENDING");
                request.setAttribute("reports", pendingReports);
                request.getRequestDispatcher("/view/jsp/admin/reports/report-list.jsp").forward(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Chi tiết report
                int reportId = Integer.parseInt(pathInfo.substring(1));
                Report report = reportDAO.getReportById(reportId);
                if (report == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy báo cáo");
                    return;
                }
                request.setAttribute("report", report);
                request.getRequestDispatcher("/view/jsp/admin/reports/report-detail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AdminReportApprovalServlet GET", e);
            e.printStackTrace(); // Thêm dòng này để log lỗi ra console
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String pathInfo = request.getPathInfo();
        try {
            if (pathInfo == null || !pathInfo.matches("/\\d+/(approve|reject)")) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            String[] parts = pathInfo.split("/");
            int reportId = Integer.parseInt(parts[1]);
            String action = parts[2];
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            boolean success = false;
            if ("approve".equals(action)) {
                String notes = request.getParameter("notes");
                success = reportDAO.approveReport(reportId, admin.getUserId(), notes);
                // Ẩn nội dung nếu là trải nghiệm
                Report report = reportDAO.getReportById(reportId);
                if (report != null) {
                    if ("experience".equalsIgnoreCase(report.getContentType())) {
                        experienceDAO.updateExperienceStatus(report.getContentId(), false); // ẩn trải nghiệm
                    } else if ("accommodation".equalsIgnoreCase(report.getContentType())) {
                        accommodationDAO.updateAccommodationStatus(report.getContentId(), false); // ẩn chỗ ở
                    }
                }
            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");
                String notes = request.getParameter("notes");
                success = reportDAO.rejectReport(reportId, admin.getUserId(), reason, notes);
            }
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/reports");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể cập nhật trạng thái báo cáo");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AdminReportApprovalServlet POST", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }

    private boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
} 