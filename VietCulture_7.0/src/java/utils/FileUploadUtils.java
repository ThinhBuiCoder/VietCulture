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
    private static final String AVATAR_UPLOAD_DIR = "view/assets/images/avatars";
    private static final String EXPERIENCE_UPLOAD_DIR = "view/assets/images/experiences";
    private static final String ACCOMMODATION_UPLOAD_DIR = "view/assets/images/accommodations";

    // Maximum file size (10MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    // Prevent instantiation
    private FileUploadUtils() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Upload avatar image
     */
    public static String uploadAvatar(Part filePart, HttpServletRequest request) {
        System.out.println("╔═══════════════════════════════════════════════════════════════════╗");
        System.out.println("║                      UPLOADAVATAR CALLED                         ║");
        System.out.println("╚═══════════════════════════════════════════════════════════════════╝");
        LOGGER.info("=== uploadAvatar called ===");
        return uploadImage(filePart, request, AVATAR_UPLOAD_DIR, "avatar");
    }

    /**
     * Upload experience image
     */
    public static String uploadExperienceImage(Part filePart, HttpServletRequest request) {
        return uploadImage(filePart, request, EXPERIENCE_UPLOAD_DIR, "experience");
    }

    /**
     * Upload accommodation image
     */
    public static String uploadAccommodationImage(Part filePart, HttpServletRequest request) {
        return uploadImage(filePart, request, ACCOMMODATION_UPLOAD_DIR, "accommodation");
    }

    /**
     * Generic image upload method
     */
    private static String uploadImage(Part filePart, HttpServletRequest request,
            String uploadDir, String prefix) {

        System.out.println("╔═══════════════════════════════════════════════════════════════════╗");
        System.out.println("║                        UPLOADIMAGE START                         ║");
        System.out.println("╚═══════════════════════════════════════════════════════════════════╝");
        System.out.println("Upload directory: " + uploadDir);
        System.out.println("File prefix: " + prefix);

        LOGGER.info("=== uploadImage START ===");
        LOGGER.info("Upload directory: " + uploadDir);
        LOGGER.info("File prefix: " + prefix);

        if (filePart == null) {
            System.out.println("ERROR: File part is null");
            LOGGER.warning("File part is null");
            return null;
        }

        if (filePart.getSize() == 0) {
            System.out.println("ERROR: File part size is 0");
            LOGGER.warning("File part size is 0");
            return null;
        }

        try {
            // Get and validate original filename
            String originalFileName = getFileName(filePart);
            System.out.println("Original filename: " + originalFileName);
            LOGGER.info("Original filename: " + originalFileName);

            // Validate file type
            if (!isValidImageType(originalFileName)) {
                System.out.println("ERROR: Invalid file type: " + originalFileName);
                LOGGER.warning("Invalid file type: " + originalFileName);
                return null;
            }

            // Validate file size
            long fileSize = filePart.getSize();
            System.out.println("File size: " + fileSize + " bytes");
            LOGGER.info("File size: " + fileSize + " bytes");
            if (fileSize > MAX_FILE_SIZE) {
                System.out.println("ERROR: File size too large: " + fileSize + " bytes (max: " + MAX_FILE_SIZE + ")");
                LOGGER.warning("File size too large: " + fileSize + " bytes (max: " + MAX_FILE_SIZE + ")");
                return null;
            }

            // Get file extension
            String fileExtension = getFileExtension(originalFileName);
            System.out.println("File extension: " + fileExtension);
            LOGGER.info("File extension: " + fileExtension);

            // Generate unique filename
            String fileName = prefix + "_" + UUID.randomUUID().toString() + fileExtension;
            System.out.println("Generated filename: " + fileName);
            LOGGER.info("Generated filename: " + fileName);

            // Get upload directory path
            String uploadPath = getUploadPath(request, uploadDir);
            System.out.println("Full upload path: " + uploadPath);
            LOGGER.info("Full upload path: " + uploadPath);

            // Create directory if it doesn't exist
            File uploadDirFile = new File(uploadPath);
            System.out.println("Upload directory object created: " + uploadDirFile.getAbsolutePath());

            if (!uploadDirFile.exists()) {
                System.out.println("Directory doesn't exist, creating: " + uploadPath);
                LOGGER.info("Directory doesn't exist, creating: " + uploadPath);
                boolean created = uploadDirFile.mkdirs();
                System.out.println("Directory creation result: " + created);
                LOGGER.info("Directory creation result: " + created);
                if (!created) {
                    System.out.println("CRITICAL ERROR: Failed to create upload directory: " + uploadPath);
                    LOGGER.severe("Failed to create upload directory: " + uploadPath);
                    return null;
                }
            } else {
                System.out.println("Directory already exists: " + uploadPath);
            }

            // Check directory properties
            System.out.println("=== DIRECTORY PROPERTIES ===");
            System.out.println("Directory exists: " + uploadDirFile.exists());
            System.out.println("Directory is directory: " + uploadDirFile.isDirectory());
            System.out.println("Directory readable: " + uploadDirFile.canRead());
            System.out.println("Directory writable: " + uploadDirFile.canWrite());
            System.out.println("Absolute path: " + uploadDirFile.getAbsolutePath());

            LOGGER.info("Directory exists: " + uploadDirFile.exists());
            LOGGER.info("Directory is directory: " + uploadDirFile.isDirectory());
            LOGGER.info("Directory readable: " + uploadDirFile.canRead());
            LOGGER.info("Directory writable: " + uploadDirFile.canWrite());

            if (!uploadDirFile.canWrite()) {
                System.out.println("CRITICAL ERROR: Upload directory is not writable: " + uploadPath);
                LOGGER.severe("Upload directory is not writable: " + uploadPath);
                return null;
            }

            // Save file using NIO
            Path filePath = Paths.get(uploadPath, fileName);
            System.out.println("=== SAVING FILE ===");
            System.out.println("Target file path: " + filePath.toString());
            System.out.println("Target file absolute path: " + filePath.toAbsolutePath().toString());
            LOGGER.info("Target file path: " + filePath.toString());

            try (InputStream inputStream = filePart.getInputStream()) {
                System.out.println("Got input stream from part, size available: " + inputStream.available());
                long bytesCopied = Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Files.copy completed, bytes copied: " + bytesCopied);
                LOGGER.info("Files.copy completed, bytes copied: " + bytesCopied);
            } catch (IOException copyEx) {
                System.out.println("CRITICAL ERROR during Files.copy: " + copyEx.getMessage());
                copyEx.printStackTrace();
                LOGGER.log(Level.SEVERE, "Error during Files.copy: " + copyEx.getMessage(), copyEx);
                return null;
            }

            // Verify file was created
            File savedFile = filePath.toFile();
            System.out.println("=== FILE VERIFICATION ===");
            System.out.println("Saved file exists: " + savedFile.exists());
            System.out.println("Saved file length: " + savedFile.length());
            System.out.println("Saved file path: " + savedFile.getAbsolutePath());
            System.out.println("Saved file readable: " + savedFile.canRead());

            if (savedFile.exists() && savedFile.length() > 0) {
                System.out.println("SUCCESS: File uploaded successfully: " + fileName + " (size: " + savedFile.length() + " bytes)");
                LOGGER.info("SUCCESS: File uploaded successfully: " + fileName + " (size: " + savedFile.length() + " bytes)");
                System.out.println("╚═══════════════════════════════════════════════════════════════════╝");
                return fileName;
            } else {
                System.out.println("CRITICAL ERROR: File was not saved properly: " + fileName);
                LOGGER.severe("File was not saved properly: " + fileName);
                System.out.println("╚═══════════════════════════════════════════════════════════════════╝");
                return null;
            }

        } catch (Exception e) {
            System.out.println("CRITICAL ERROR: Unexpected error during file upload: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Unexpected error during file upload: " + e.getMessage(), e);
            return null;
        } finally {
            System.out.println("╚═══════════════════════════════════════════════════════════════════╝");
            LOGGER.info("=== uploadImage END ===");
        }
    }

    /**
     * Check if file type is allowed
     */
    private static boolean isValidImageType(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            System.out.println("File name is null or empty for validation");
            LOGGER.warning("File name is null or empty");
            return false;
        }

        String extension = getFileExtension(fileName).toLowerCase();
        System.out.println("Checking file extension: " + extension);

        String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".tiff", ".svg"};
        for (String ext : allowedExtensions) {
            if (extension.equals(ext)) {
                System.out.println("File extension is valid: " + extension);
                return true;
            }
        }

        System.out.println("Invalid file extension: " + extension);
        return false;
    }

    /**
     * Get filename from Part header
     */
    private static String getFileName(Part part) {
        System.out.println("Getting filename from part...");

        // Try getSubmittedFileName() first (newer method)
        String submittedFileName = part.getSubmittedFileName();
        if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
            System.out.println("Found submitted filename: " + submittedFileName);
            return submittedFileName;
        }

        // Fallback to content-disposition header
        String contentDispositionHeader = part.getHeader("content-disposition");
        System.out.println("Content-disposition header: " + contentDispositionHeader);

        if (contentDispositionHeader == null) {
            System.out.println("Content disposition header is null, using default");
            return "unknown.jpg";
        }

        String[] elements = contentDispositionHeader.split(";");
        for (String element : elements) {
            element = element.trim();
            if (element.startsWith("filename")) {
                String fileName = element.substring(element.indexOf('=') + 1).trim()
                        .replace("\"", "");
                System.out.println("Extracted filename from header: " + fileName);
                return fileName.isEmpty() ? "unknown.jpg" : fileName;
            }
        }

        System.out.println("Filename not found in content disposition, using default");
        return "unknown.jpg";
    }

    /**
     * Get file extension from filename
     */
    private static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            System.out.println("File name is null or empty for extension extraction");
            return ".jpg";
        }

        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1) {
            System.out.println("No extension found for file: " + fileName);
            return ".jpg";
        }

        String extension = fileName.substring(lastDotIndex).toLowerCase();
        System.out.println("Extracted extension: " + extension);
        return extension;
    }

    /**
     * Get absolute upload path
     */
    private static String getUploadPath(HttpServletRequest request, String uploadDir) {
        String webappPath = request.getServletContext().getRealPath("/");
        System.out.println("Webapp real path: " + webappPath);

        if (webappPath == null) {
            System.out.println("WARNING: getRealPath returned null, using temporary directory");
            webappPath = System.getProperty("java.io.tmpdir") + File.separator + "uploads" + File.separator;
        }

        // Ensure webappPath ends with separator
        if (!webappPath.endsWith(File.separator)) {
            webappPath += File.separator;
        }

        String fullPath = webappPath + uploadDir.replace("/", File.separator);
        System.out.println("Resolved full upload path: " + fullPath);
        return fullPath;
    }

    /**
     * Delete file from upload directory
     */
    public static boolean deleteFile(HttpServletRequest request, String uploadDir, String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            System.out.println("File name is null or empty for deletion");
            LOGGER.warning("File name is null or empty for deletion");
            return false;
        }

        try {
            String uploadPath = getUploadPath(request, uploadDir);
            Path filePath = Paths.get(uploadPath, fileName);

            System.out.println("Attempting to delete file: " + filePath.toString());
            LOGGER.info("Attempting to delete file: " + filePath.toString());

            if (Files.exists(filePath)) {
                Files.delete(filePath);
                System.out.println("File deleted successfully: " + fileName);
                LOGGER.info("File deleted successfully: " + fileName);
                return true;
            } else {
                System.out.println("File not found for deletion: " + fileName);
                LOGGER.warning("File not found for deletion: " + fileName);
                return false;
            }

        } catch (IOException e) {
            System.out.println("Error deleting file: " + fileName + ", message: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error deleting file: " + fileName + ", message: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Delete avatar image
     */
    public static boolean deleteAvatar(HttpServletRequest request, String fileName) {
        System.out.println("Deleting avatar: " + fileName);
        LOGGER.info("Deleting avatar: " + fileName);
        return deleteFile(request, AVATAR_UPLOAD_DIR, fileName);
    }

    /**
     * Delete experience image
     */
    public static boolean deleteExperienceImage(HttpServletRequest request, String fileName) {
        return deleteFile(request, EXPERIENCE_UPLOAD_DIR, fileName);
    }

    /**
     * Delete accommodation image
     */
    public static boolean deleteAccommodationImage(HttpServletRequest request, String fileName) {
        return deleteFile(request, ACCOMMODATION_UPLOAD_DIR, fileName);
    }
}
