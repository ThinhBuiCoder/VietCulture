package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FileUploadUtils {
    private static final Logger LOGGER = Logger.getLogger(FileUploadUtils.class.getName());
    
    // Upload directories
    private static final String AVATAR_UPLOAD_DIR = "assets/images/avatars";
    private static final String EXPERIENCE_UPLOAD_DIR = "assets/images/experiences";
    private static final String ACCOMMODATION_UPLOAD_DIR = "assets/images/accommodations";
    
    // Allowed file types
    private static final String[] ALLOWED_IMAGE_TYPES = {
        "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    };
    
    // Maximum file size (10MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;
    
    // Prevent instantiation
    private FileUploadUtils() {
        throw new IllegalStateException("Utility class");
    }
    
    /**
     * Upload avatar image
     * @param filePart File part from multipart request
     * @param request HttpServletRequest to get real path
     * @return Generated filename or null if upload failed
     */
    public static String uploadAvatar(Part filePart, HttpServletRequest request) {
        return uploadImage(filePart, request, AVATAR_UPLOAD_DIR, "avatar");
    }
    
    /**
     * Upload experience image
     * @param filePart File part from multipart request
     * @param request HttpServletRequest to get real path
     * @return Generated filename or null if upload failed
     */
    public static String uploadExperienceImage(Part filePart, HttpServletRequest request) {
        return uploadImage(filePart, request, EXPERIENCE_UPLOAD_DIR, "experience");
    }
    
    /**
     * Upload accommodation image
     * @param filePart File part from multipart request
     * @param request HttpServletRequest to get real path
     * @return Generated filename or null if upload failed
     */
    public static String uploadAccommodationImage(Part filePart, HttpServletRequest request) {
        return uploadImage(filePart, request, ACCOMMODATION_UPLOAD_DIR, "accommodation");
    }
    
    /**
     * Generic image upload method
     * @param filePart File part from multipart request
     * @param request HttpServletRequest to get real path
     * @param uploadDir Upload directory relative to webapp root
     * @param prefix Filename prefix
     * @return Generated filename or null if upload failed
     */
    private static String uploadImage(Part filePart, HttpServletRequest request, 
                                    String uploadDir, String prefix) {
        
        if (filePart == null || filePart.getSize() == 0) {
            LOGGER.warning("File part is null or empty");
            return null;
        }
        
        try {
            // Validate file type
            String contentType = filePart.getContentType();
            if (!isValidImageType(contentType)) {
                LOGGER.warning("Invalid file type: " + contentType);
                return null;
            }
            
            // Validate file size
            if (filePart.getSize() > MAX_FILE_SIZE) {
                LOGGER.warning("File size too large: " + filePart.getSize());
                return null;
            }
            
            // Get file extension
            String originalFileName = getFileName(filePart);
            String fileExtension = getFileExtension(originalFileName);
            
            // Generate unique filename
            String fileName = prefix + "_" + UUID.randomUUID().toString() + fileExtension;
            
            // Get upload directory path
            String uploadPath = getUploadPath(request, uploadDir);
            
            // Create directory if it doesn't exist
            File uploadDirFile = new File(uploadPath);
            if (!uploadDirFile.exists()) {
                boolean created = uploadDirFile.mkdirs();
                if (!created) {
                    LOGGER.severe("Failed to create upload directory: " + uploadPath);
                    return null;
                }
            }
            
            // Save file
            Path filePath = Paths.get(uploadPath, fileName);
            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            LOGGER.info("File uploaded successfully: " + fileName);
            return fileName;
            
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error uploading file", e);
            return null;
        }
    }
    
    /**
     * Check if file type is allowed
     * @param contentType MIME type of the file
     * @return true if allowed, false otherwise
     */
    private static boolean isValidImageType(String contentType) {
        if (contentType == null) {
            return false;
        }
        
        for (String allowedType : ALLOWED_IMAGE_TYPES) {
            if (contentType.toLowerCase().startsWith(allowedType)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Get filename from Part header
     * @param part File part
     * @return Original filename or default if not found
     */
    private static String getFileName(Part part) {
        String contentDispositionHeader = part.getHeader("content-disposition");
        if (contentDispositionHeader == null) {
            return "unknown.jpg";
        }
        
        String[] elements = contentDispositionHeader.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                String fileName = element.substring(element.indexOf('=') + 1).trim()
                                         .replace("\"", "");
                return fileName.isEmpty() ? "unknown.jpg" : fileName;
            }
        }
        return "unknown.jpg";
    }
    
    /**
     * Get file extension from filename
     * @param fileName Original filename
     * @return File extension with dot (e.g., ".jpg")
     */
    private static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return ".jpg";
        }
        
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1) {
            return ".jpg";
        }
        
        return fileName.substring(lastDotIndex).toLowerCase();
    }
    
    /**
     * Get absolute upload path
     * @param request HttpServletRequest
     * @param uploadDir Relative upload directory
     * @return Absolute path to upload directory
     */
    private static String getUploadPath(HttpServletRequest request, String uploadDir) {
        // In development, use webapp directory
        String webappPath = request.getServletContext().getRealPath("/");
        return webappPath + uploadDir.replace("/", File.separator);
    }
    
    /**
     * Delete file from upload directory
     * @param request HttpServletRequest
     * @param uploadDir Upload directory
     * @param fileName File to delete
     * @return true if deleted successfully, false otherwise
     */
    public static boolean deleteFile(HttpServletRequest request, String uploadDir, String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        
        try {
            String uploadPath = getUploadPath(request, uploadDir);
            Path filePath = Paths.get(uploadPath, fileName);
            
            if (Files.exists(filePath)) {
                Files.delete(filePath);
                LOGGER.info("File deleted successfully: " + fileName);
                return true;
            } else {
                LOGGER.warning("File not found for deletion: " + fileName);
                return false;
            }
            
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error deleting file: " + fileName, e);
            return false;
        }
    }
    
    /**
     * Delete avatar image
     * @param request HttpServletRequest
     * @param fileName Avatar filename to delete
     * @return true if deleted successfully
     */
    public static boolean deleteAvatar(HttpServletRequest request, String fileName) {
        return deleteFile(request, AVATAR_UPLOAD_DIR, fileName);
    }
    
    /**
     * Delete experience image
     * @param request HttpServletRequest
     * @param fileName Experience image filename to delete
     * @return true if deleted successfully
     */
    public static boolean deleteExperienceImage(HttpServletRequest request, String fileName) {
        return deleteFile(request, EXPERIENCE_UPLOAD_DIR, fileName);
    }
    
    /**
     * Delete accommodation image
     * @param request HttpServletRequest
     * @param fileName Accommodation image filename to delete
     * @return true if deleted successfully
     */
    public static boolean deleteAccommodationImage(HttpServletRequest request, String fileName) {
        return deleteFile(request, ACCOMMODATION_UPLOAD_DIR, fileName);
    }
}