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
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(urlPatterns = {"/images/avatars/*", "/images/experiences/*", "/images/accommodations/*"})
public class ImageServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ImageServlet.class.getName());
    
    // COPY CONSTANTS TỪ FileUploadUtils - ĐỒNG NHẤT
    private static final String AVATAR_DIR = "view/assets/images/avatars";
    private static final String EXPERIENCE_DIR = "view/assets/images/experiences";
    private static final String ACCOMMODATION_DIR = "view/assets/images/accommodations";
    
    private static final String[] ALLOWED_EXTENSIONS = {
        ".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".tiff", ".svg"
    };
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String requestURI = request.getRequestURI();
        
        LOGGER.info("ImageServlet - Processing request: " + requestURI + ", pathInfo: " + pathInfo);
        
        // Kiểm tra pathInfo
        if (pathInfo == null || pathInfo.length() <= 1) {
            LOGGER.warning("Invalid pathInfo: " + pathInfo);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String fileName = pathInfo.substring(1); // Remove leading "/"
        
        // Kiểm tra security: không cho phép ../ trong fileName
        if (fileName.contains("..") || fileName.contains("\\") || fileName.contains("//")) {
            LOGGER.warning("Security violation - Invalid fileName: " + fileName);
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Nếu là URL (avatar Google, Facebook,...) thì redirect luôn
        if (fileName.startsWith("http://") || fileName.startsWith("https://")) {
            LOGGER.info("Redirecting to external URL: " + fileName);
            response.sendRedirect(fileName);
            return;
        }
        
        // Validate file extension
        if (!isValidImageFile(fileName)) {
            LOGGER.warning("Invalid file extension: " + fileName);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Xác định upload directory từ URL - SỬ DỤNG CONSTANTS TRỰC TIẾP
        String uploadDir = determineUploadDir(requestURI);
        if (uploadDir == null) {
            LOGGER.warning("Cannot determine upload directory for URI: " + requestURI);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Get file path - ĐỒNG NHẤT VỚI FileUploadUtils.getUploadPath()
        String filePath = getFilePath(request, uploadDir, fileName);
        File file = new File(filePath);
        
        LOGGER.info("Looking for file: " + file.getAbsolutePath());
        
        // Kiểm tra file tồn tại
        if (!file.exists() || !file.isFile()) {
            LOGGER.warning("File not found: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Kiểm tra file có nằm trong thư mục được phép không (security)
        if (!isFileInAllowedDirectory(file, request, uploadDir)) {
            LOGGER.warning("Security violation - File outside allowed directory: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Set content type
        String contentType = determineContentType(fileName);
        response.setContentType(contentType);
        
        // Set cache headers
        response.setHeader("Cache-Control", "public, max-age=3600"); // 1 hour
        response.setDateHeader("Last-Modified", file.lastModified());
        response.setContentLength((int) file.length());
        
        LOGGER.info("Serving file: " + fileName + " (" + file.length() + " bytes)");
        
        // Serve file
        try (FileInputStream fis = new FileInputStream(file); 
             OutputStream os = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192]; // Larger buffer
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
            os.flush();
            
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error serving file: " + fileName, e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
    
    /**
     * Xác định upload directory từ request URI - SỬ DỤNG CONSTANTS TRỰC TIẾP
     */
    private String determineUploadDir(String requestURI) {
        if (requestURI.contains("/images/avatars/")) {
            return AVATAR_DIR;
        } else if (requestURI.contains("/images/experiences/")) {
            return EXPERIENCE_DIR;
        } else if (requestURI.contains("/images/accommodations/")) {
            return ACCOMMODATION_DIR;
        }
        return null;
    }
    
    /**
     * Get file path - COPY TỪ FileUploadUtils.getUploadPath() ĐỂ ĐỒNG NHẤT
     */
    private String getFilePath(HttpServletRequest request, String uploadDir, String fileName) {
        String webappPath = request.getServletContext().getRealPath("/");
        
        if (webappPath == null) {
            LOGGER.warning("getRealPath returned null, using temporary directory");
            webappPath = System.getProperty("java.io.tmpdir") + File.separator + "uploads" + File.separator;
        }
        
        // Ensure webappPath ends with separator
        if (!webappPath.endsWith(File.separator)) {
            webappPath += File.separator;
        }
        
        String fullUploadPath = webappPath + uploadDir.replace("/", File.separator);
        return fullUploadPath + File.separator + fileName;
    }
    
    /**
     * Kiểm tra file có extension hợp lệ không
     */
    private boolean isValidImageFile(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return false;
        }
        
        String lowerFileName = fileName.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Xác định content type
     */
    private String determineContentType(String fileName) {
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType != null) {
            return contentType;
        }
        
        // Fallback manual mapping
        String lowerFileName = fileName.toLowerCase();
        if (lowerFileName.endsWith(".png")) {
            return "image/png";
        } else if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (lowerFileName.endsWith(".gif")) {
            return "image/gif";
        } else if (lowerFileName.endsWith(".webp")) {
            return "image/webp";
        } else if (lowerFileName.endsWith(".svg")) {
            return "image/svg+xml";
        } else if (lowerFileName.endsWith(".bmp")) {
            return "image/bmp";
        } else if (lowerFileName.endsWith(".tiff")) {
            return "image/tiff";
        }
        
        return "application/octet-stream";
    }
    
    /**
     * Kiểm tra file có nằm trong thư mục được phép không (bảo mật)
     */
    private boolean isFileInAllowedDirectory(File file, HttpServletRequest request, String uploadDir) {
        try {
            String allowedPath = getFilePath(request, uploadDir, "").replace(File.separator + File.separator, File.separator);
            String actualPath = file.getCanonicalPath();
            String allowedCanonicalPath = new File(allowedPath).getCanonicalPath();
            
            return actualPath.startsWith(allowedCanonicalPath);
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Error checking file path security", e);
            return false;
        }
    }
}