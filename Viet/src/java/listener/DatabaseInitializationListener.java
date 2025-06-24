package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import utils.DBUtils;

@WebListener
public class DatabaseInitializationListener implements ServletContextListener {
<<<<<<< HEAD

=======
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("Application starting...");
<<<<<<< HEAD

=======
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            // Test database connection
            if (DBUtils.testConnection()) {
                sce.getServletContext().log("Database connection successful!");
            } else {
                sce.getServletContext().log("Database connection FAILED!");
            }
        } catch (Exception e) {
            sce.getServletContext().log("Initialization error", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application shutting down...");
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
