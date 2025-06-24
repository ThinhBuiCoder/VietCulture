package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(urlPatterns = {"/images/avatars/*", "/images/experiences/*", "/images/accommodations/*"})
public class ImageServlet extends HttpServlet {
<<<<<<< HEAD

    private static final String AVATAR_DIR = "view/assets/images/avatars";
    private static final String EXPERIENCE_DIR = "view/assets/images/experiences";
    private static final String ACCOMMODATION_DIR = "view/assets/images/accommodations";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

=======
    
    private static final String AVATAR_DIR = "view/assets/images/avatars";
    private static final String EXPERIENCE_DIR = "view/assets/images/experiences";
    private static final String ACCOMMODATION_DIR = "view/assets/images/accommodations";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
<<<<<<< HEAD

        String fileName = pathInfo.substring(1); // Remove leading "/"
        String requestURI = request.getRequestURI();

=======
        
        String fileName = pathInfo.substring(1); // Remove leading "/"
        String requestURI = request.getRequestURI();
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        String uploadDir;
        if (requestURI.contains("/images/avatars/")) {
            uploadDir = AVATAR_DIR;
        } else if (requestURI.contains("/images/experiences/")) {
            uploadDir = EXPERIENCE_DIR;
        } else if (requestURI.contains("/images/accommodations/")) {
            uploadDir = ACCOMMODATION_DIR;
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Get file path
        String webappPath = request.getServletContext().getRealPath("/");
        Path filePath = Paths.get(webappPath, uploadDir, fileName);
        File file = filePath.toFile();
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        // Set content type
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
<<<<<<< HEAD

        // Set cache headers để tránh cache quá lâu
        response.setHeader("Cache-Control", "public, max-age=3600"); // 1 hour
        response.setDateHeader("Last-Modified", file.lastModified());

        // Serve file
        try (FileInputStream fis = new FileInputStream(file); OutputStream os = response.getOutputStream()) {

=======
        
        // Set cache headers để tránh cache quá lâu
        response.setHeader("Cache-Control", "public, max-age=3600"); // 1 hour
        response.setDateHeader("Last-Modified", file.lastModified());
        
        // Serve file
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
