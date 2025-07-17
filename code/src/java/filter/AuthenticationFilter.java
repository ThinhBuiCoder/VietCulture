package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

public class AuthenticationFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(AuthenticationFilter.class.getName());
    
    // Các URL không cần xác thực
    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
        "/login",
        "/register", 
        "/auth/google",
        "/verify-email",
        "/forgot-password",
        "/reset-password",
        "/css/",
        "/js/",
        "/images/",
        "/assets/",
        "/static/",
        "/home",
        "/view/assets/images/" // Thêm dòng này để loại trừ ảnh exp
    );
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("AuthenticationFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Skip filter for excluded paths
        if (isExcludedPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        if (user == null) {
            // Store the original URL for redirect after login
            String returnUrl = requestURI;
            if (httpRequest.getQueryString() != null) {
                returnUrl += "?" + httpRequest.getQueryString();
            }
            
            LOGGER.info("Unauthorized access attempt to: " + requestURI);
            
            // Redirect to login with return URL
            httpResponse.sendRedirect(contextPath + "/login?returnUrl=" + 
                java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }
        
        // Check if user account is active (not locked)
        if (!user.isActive()) {
            LOGGER.warning("Locked user attempting access: " + user.getEmail() + " to path: " + path);
            
            // Invalidate session for locked user
            session.invalidate();
            
            // Redirect to login with error message
            httpResponse.sendRedirect(contextPath + "/login?error=account_locked");
            return;
        }
        
        // Check user role for admin/host specific paths
        String userRole = user.getRole();
        if (!hasRequiredRole(path, userRole)) {
            LOGGER.warning("Access denied for user role " + userRole + " to path: " + path);
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        LOGGER.info("AuthenticationFilter destroyed");
    }
    
    /**
     * Check if the path is in excluded list
     */
    private boolean isExcludedPath(String path) {
        return EXCLUDED_PATHS.stream().anyMatch(excluded -> 
            path.startsWith(excluded) || path.equals(excluded)
        );
    }
    
    /**
     * Check if user has required role for the path
     */
    private boolean hasRequiredRole(String path, String userRole) {
        if (userRole == null) {
            return false;
        }
        
        // Admin paths
        if (path.startsWith("/admin/")) {
            return "ADMIN".equals(userRole);
        }
        
        // Host paths  
        if (path.startsWith("/host/")) {
            return "HOST".equals(userRole) || "ADMIN".equals(userRole);
        }
        
        // User paths (accessible by all authenticated users)
        if (path.startsWith("/user/")) {
            return true; // All authenticated users can access
        }
        
        // Default: allow access
        return true;
    }
}