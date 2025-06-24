package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.logging.Logger;
import java.util.logging.Level;

public class PasswordUtils {
<<<<<<< HEAD

    private static final Logger LOGGER = Logger.getLogger(PasswordUtils.class.getName());

    // Salt length for password hashing
    private static final int SALT_LENGTH = 16;

    // Algorithm for hashing
    private static final String HASH_ALGORITHM = "SHA-256";

=======
    private static final Logger LOGGER = Logger.getLogger(PasswordUtils.class.getName());
    
    // Salt length for password hashing
    private static final int SALT_LENGTH = 16;
    
    // Algorithm for hashing
    private static final String HASH_ALGORITHM = "SHA-256";
    
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
    // Prevent instantiation
    private PasswordUtils() {
        throw new IllegalStateException("Utility class");
    }
<<<<<<< HEAD

    /**
     * Generate a random salt
     *
=======
    
    /**
     * Generate a random salt
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @return Base64 encoded salt string
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
<<<<<<< HEAD

    /**
     * Hash password with salt using SHA-256
     *
=======
    
    /**
     * Hash password with salt using SHA-256
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param password Plain text password
     * @param salt Salt string
     * @return Hashed password
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
<<<<<<< HEAD

            // Add salt to password
            String saltedPassword = password + salt;

            // Hash the salted password
            byte[] hashedBytes = md.digest(saltedPassword.getBytes());

=======
            
            // Add salt to password
            String saltedPassword = password + salt;
            
            // Hash the salted password
            byte[] hashedBytes = md.digest(saltedPassword.getBytes());
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
            // Convert to hex string
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
<<<<<<< HEAD

            return sb.toString();

=======
            
            return sb.toString();
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        } catch (NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "Hashing algorithm not found", e);
            throw new RuntimeException("Error hashing password", e);
        }
    }
<<<<<<< HEAD

    /**
     * Hash password with auto-generated salt
     *
=======
    
    /**
     * Hash password with auto-generated salt
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param password Plain text password
     * @return Salt + Hashed password separated by :
     */
    public static String hashPasswordWithSalt(String password) {
        String salt = generateSalt();
        String hashedPassword = hashPassword(password, salt);
        return salt + ":" + hashedPassword;
    }
<<<<<<< HEAD

    /**
     * Verify password against stored hash
     *
=======
    
    /**
     * Verify password against stored hash
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param password Plain text password to verify
     * @param storedPassword Stored password (salt:hash format)
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedPassword) {
        try {
            // Split stored password into salt and hash
            String[] parts = storedPassword.split(":", 2);
            if (parts.length != 2) {
                // Handle legacy passwords without salt (for backward compatibility)
                return password.equals(storedPassword);
            }
<<<<<<< HEAD

            String salt = parts[0];
            String storedHash = parts[1];

            // Hash the input password with the stored salt
            String inputHash = hashPassword(password, salt);

            // Compare hashes
            return storedHash.equals(inputHash);

=======
            
            String salt = parts[0];
            String storedHash = parts[1];
            
            // Hash the input password with the stored salt
            String inputHash = hashPassword(password, salt);
            
            // Compare hashes
            return storedHash.equals(inputHash);
            
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying password", e);
            return false;
        }
    }
<<<<<<< HEAD

    /**
     * Generate a random password for temporary use
     *
=======
    
    /**
     * Generate a random password for temporary use
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param length Password length
     * @return Random password string
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
<<<<<<< HEAD

        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }

        return password.toString();
    }

    /**
     * Generate a secure random token for email verification
     *
=======
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    /**
     * Generate a secure random token for email verification
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @return Random token string
     */
    public static String generateVerificationToken() {
        SecureRandom random = new SecureRandom();
        byte[] token = new byte[32];
        random.nextBytes(token);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(token);
    }
<<<<<<< HEAD

    /**
     * Validate password strength
     *
=======
    
    /**
     * Validate password strength
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param password Password to validate
     * @return true if password meets strength requirements
     */
    public static boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;
<<<<<<< HEAD

=======
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecial = true;
            }
        }
<<<<<<< HEAD

        // Require at least 3 out of 4 character types
        int typeCount = 0;
        if (hasUpper) {
            typeCount++;
        }
        if (hasLower) {
            typeCount++;
        }
        if (hasDigit) {
            typeCount++;
        }
        if (hasSpecial) {
            typeCount++;
        }

        return typeCount >= 3;
    }

    /**
     * Get password strength description
     *
=======
        
        // Require at least 3 out of 4 character types
        int typeCount = 0;
        if (hasUpper) typeCount++;
        if (hasLower) typeCount++;
        if (hasDigit) typeCount++;
        if (hasSpecial) typeCount++;
        
        return typeCount >= 3;
    }
    
    /**
     * Get password strength description
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
     * @param password Password to check
     * @return Strength description
     */
    public static String getPasswordStrengthText(String password) {
        if (password == null || password.length() < 6) {
            return "Quá yếu - Cần ít nhất 6 ký tự";
        }
<<<<<<< HEAD

        if (password.length() < 8) {
            return "Yếu - Nên có ít nhất 8 ký tự";
        }

=======
        
        if (password.length() < 8) {
            return "Yếu - Nên có ít nhất 8 ký tự";
        }
        
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
        if (isPasswordStrong(password)) {
            return "Mạnh - Mật khẩu tốt";
        } else {
            return "Trung bình - Nên thêm chữ hoa, số hoặc ký tự đặc biệt";
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> f936304b2ac538e93c06857b86ec5748682be34b
