/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/traveler/upgrade-to-host")
public class UpgradeToHostServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UpgradeToHostServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");

        // Check if user is logged in
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is TRAVELER
        if (!"TRAVELER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            // Check if user can become host
            boolean canUpgrade = userDAO.canBecomeHost(currentUser.getUserId());
            request.setAttribute("canUpgrade", canUpgrade);
            
            if (!canUpgrade) {
                request.setAttribute("errorMessage", "Bạn không đủ điều kiện để nâng cấp lên Host. Hãy đảm bảo tài khoản đã được xác thực email.");
            }

            request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in upgrade to host check", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi kiểm tra điều kiện nâng cấp.");
            request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");

        // Check if user is logged in
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is TRAVELER
        if (!"TRAVELER".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");

        if ("upgrade".equals(action)) {
            handleUpgrade(request, response, currentUser, session);
        } else if ("complete".equals(action)) {
            handleCompleteProfile(request, response, currentUser, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/traveler/upgrade-to-host");
        }
    }

    private void handleUpgrade(HttpServletRequest request, HttpServletResponse response, 
                              User currentUser, HttpSession session)
            throws ServletException, IOException {
        
        try {
            // Check if user can become host
            if (!userDAO.canBecomeHost(currentUser.getUserId())) {
                request.setAttribute("errorMessage", "Bạn không đủ điều kiện để nâng cấp lên Host.");
                request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                       .forward(request, response);
                return;
            }

            // Upgrade user to HOST
            boolean upgraded = userDAO.upgradeUserToHost(currentUser.getUserId());

            if (upgraded) {
                // Update session with fresh user data from database
                updateUserSession(session, currentUser.getUserId());

                // Set success message and redirect to complete profile
                request.setAttribute("successMessage", "Chúc mừng! Bạn đã trở thành Host thành công!");
                request.setAttribute("showCompleteProfile", true);
                request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                       .forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi nâng cấp tài khoản. Vui lòng thử lại.");
                request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during user upgrade", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi nâng cấp tài khoản.");
            request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                   .forward(request, response);
        }
    }

    private void handleCompleteProfile(HttpServletRequest request, HttpServletResponse response, 
                                     User currentUser, HttpSession session)
            throws ServletException, IOException {
        
        // Get form parameters
        String businessName = request.getParameter("businessName");
        String businessType = request.getParameter("businessType");
        String businessAddress = request.getParameter("businessAddress");
        String businessDescription = request.getParameter("businessDescription");
        String taxId = request.getParameter("taxId");
        String skills = request.getParameter("skills");
        String region = request.getParameter("region");

        // Validate required fields
        if (businessName == null || businessName.trim().isEmpty() ||
            businessType == null || businessType.trim().isEmpty() ||
            region == null || region.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc.");
            request.setAttribute("showCompleteProfile", true);
            request.setAttribute("businessName", businessName);
            request.setAttribute("businessType", businessType);
            request.setAttribute("businessAddress", businessAddress);
            request.setAttribute("businessDescription", businessDescription);
            request.setAttribute("taxId", taxId);
            request.setAttribute("skills", skills);
            request.setAttribute("region", region);
            request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                   .forward(request, response);
            return;
        }

        try {
            // Update host business information
            boolean updated = userDAO.updateHostBusinessInfo(
                currentUser.getUserId(),
                businessName.trim(),
                businessType.trim(),
                businessAddress != null ? businessAddress.trim() : null,
                businessDescription != null ? businessDescription.trim() : null,
                taxId != null ? taxId.trim() : null,
                skills != null ? skills.trim() : null,
                region.trim()
            );

            if (updated) {
                // Update session with fresh user data from database
                updateUserSession(session, currentUser.getUserId());

                // Redirect to host dashboard
                response.sendRedirect(request.getContextPath() + "/host/dashboard?upgraded=true");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin doanh nghiệp.");
                request.setAttribute("showCompleteProfile", true);
                request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating host business info", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin.");
            request.setAttribute("showCompleteProfile", true);
            request.getRequestDispatcher("/view/jsp/traveler/upgrade-to-host.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Helper method to safely update user session with fresh data from database
     */
    private void updateUserSession(HttpSession session, int userId) {
        try {
            // Get complete user data from database
            User updatedUser = userDAO.getUserByEmail(((User) session.getAttribute("user")).getEmail());
            
            if (updatedUser != null) {
                // Update session with fresh user data
                session.setAttribute("user", updatedUser);
                LOGGER.info("User session updated successfully: " + userId);
            } else {
                LOGGER.warning("Could not retrieve updated user data for session update: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to update user session: " + userId, e);
            // In case of error, try to keep the session valid by not modifying it
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Unexpected error updating user session: " + userId, e);
        }
    }
}