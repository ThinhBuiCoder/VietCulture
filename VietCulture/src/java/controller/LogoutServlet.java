package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
<<<<<<< HEAD

    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

=======
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        if (session != null) {
            String userEmail = "Unknown";
            if (session.getAttribute("user") != null) {
                userEmail = ((model.User) session.getAttribute("user")).getEmail();
            }
<<<<<<< HEAD

            // Invalidate session
            session.invalidate();

            LOGGER.info("User logged out: " + userEmail);
        }

        // Redirect to login page with logout message
        response.sendRedirect(request.getContextPath() + "/view/jsp/home/home.jsp?message=logout");
    }
}
=======
            
            // Invalidate session
            session.invalidate();
            
            LOGGER.info("User logged out: " + userEmail);
        }
        
        // Redirect to login page with logout message
response.sendRedirect(request.getContextPath() + "/view/jsp/home/home.jsp?message=logout");
    }
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
