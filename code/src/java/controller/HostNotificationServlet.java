package controller;

import com.chatbot.model.Notification;
import com.chatbot.dao.NotificationDAO;
import dao.ReportDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/host/notification-detail", "/host/notification-appeal"})
public class HostNotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"HOST".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("/host/notification-detail".equals(path)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Notification noti = notificationDAO.getNotificationById(id);
            if (noti == null || noti.getUserId() != currentUser.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập thông báo này");
                return;
            }
            request.setAttribute("notification", noti);
            request.getRequestDispatcher("/view/jsp/host/notification-detail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"HOST".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("/host/notification-appeal".equals(path)) {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            String appealMessage = request.getParameter("appealMessage");
            Notification noti = notificationDAO.getNotificationById(notificationId);
            // Lưu kháng cáo vào bảng Reports để admin xem được
            if (noti != null) {
                // Debug log
                System.out.println("[APPEAL] contentType=" + noti.getContentType() + ", contentId=" + noti.getContentId());
                if (noti.getContentType() == null || noti.getContentType().isEmpty() || noti.getContentId() == 0) {
                    request.setAttribute("appealError", "Không xác định được nội dung gốc để kháng cáo. Vui lòng liên hệ admin.");
                } else {
                    reportDAO.addReport(
                        noti.getContentType(),
                        noti.getContentId(),
                        currentUser.getUserId(),
                        "APPEAL", // Lý do: kháng cáo
                        appealMessage
                    );
                    request.setAttribute("appealSuccess", true);
                }
            }
            request.setAttribute("notification", noti);
            request.getRequestDispatcher("/view/jsp/host/notification-detail.jsp").forward(request, response);
        }
    }
} 