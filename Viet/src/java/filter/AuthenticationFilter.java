package utils;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

public class AuthenticationFilter implements Filter {
<<<<<<< HEAD

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
            "/static/"
    );

=======
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
        "/static/"
    );
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("AuthenticationFilter initialized");
    }
<<<<<<< HEAD

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

=======
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Skip filter for excluded paths
        if (isExcludedPath(path)) {
            chain.doFilter(request, response);
            return;
        }
<<<<<<< HEAD

        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("user") != null;

=======
        
        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        if (!isLoggedIn) {
            // Store the original URL for redirect after login
            String returnUrl = requestURI;
            if (httpRequest.getQueryString() != null) {
                returnUrl += "?" + httpRequest.getQueryString();
            }
<<<<<<< HEAD

            LOGGER.info("Unauthorized access attempt to: " + requestURI);

            // Redirect to login with return URL
            httpResponse.sendRedirect(contextPath + "/login?returnUrl="
                    + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

=======
            
            LOGGER.info("Unauthorized access attempt to: " + requestURI);
            
            // Redirect to login with return URL
            httpResponse.sendRedirect(contextPath + "/login?returnUrl=" + 
                java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Check user role for admin/host specific paths
        String userType = (String) session.getAttribute("userType");
        if (!hasRequiredRole(path, userType)) {
            LOGGER.warning("Access denied for user type " + userType + " to path: " + path);
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }
<<<<<<< HEAD

        // Continue with the request
        chain.doFilter(request, response);
    }

=======
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void destroy() {
        LOGGER.info("AuthenticationFilter destroyed");
    }
<<<<<<< HEAD

=======
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Check if the path is in excluded list
     */
    private boolean isExcludedPath(String path) {
<<<<<<< HEAD
        return EXCLUDED_PATHS.stream().anyMatch(excluded
                -> path.startsWith(excluded) || path.equals(excluded)
        );
    }

=======
        return EXCLUDED_PATHS.stream().anyMatch(excluded -> 
            path.startsWith(excluded) || path.equals(excluded)
        );
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    /**
     * Check if user has required role for the path
     */
    private boolean hasRequiredRole(String path, String userType) {
        if (userType == null) {
            return false;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Admin paths
        if (path.startsWith("/admin/")) {
            return "ADMIN".equals(userType);
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Host paths  
        if (path.startsWith("/host/")) {
            return "HOST".equals(userType) || "ADMIN".equals(userType);
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // User paths (accessible by all authenticated users)
        if (path.startsWith("/user/")) {
            return true; // All authenticated users can access
        }
<<<<<<< HEAD

        // Default: allow access
        return true;
    }
}
=======
        
        // Default: allow access
        return true;
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
