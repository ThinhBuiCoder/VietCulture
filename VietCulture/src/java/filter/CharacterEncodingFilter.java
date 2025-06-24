package utils;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CharacterEncodingFilter implements Filter {
<<<<<<< HEAD

    private String encoding = "UTF-8";

=======
    private String encoding = "UTF-8";
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.trim().isEmpty()) {
            this.encoding = encodingParam;
        }
    }
<<<<<<< HEAD

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

=======
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Set request encoding
        if (httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(encoding);
        }
<<<<<<< HEAD

        // Set response encoding
        httpResponse.setCharacterEncoding(encoding);
        httpResponse.setContentType("text/html; charset=" + encoding);

        // Continue with the request
        chain.doFilter(request, response);
    }

=======
        
        // Set response encoding
        httpResponse.setCharacterEncoding(encoding);
        httpResponse.setContentType("text/html; charset=" + encoding);
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void destroy() {
        // Cleanup if needed
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
