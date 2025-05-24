package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailUtils for OTP-based registration system
 * Simple and efficient email sending with OTP codes
 */
public class EmailUtils {
    private static final Logger LOGGER = Logger.getLogger(EmailUtils.class.getName());

    // Email configuration
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "kienltde180359@gmail.com";
    private static final String EMAIL_PASSWORD = "psdn iaup muru voex";
    private static final String FROM_EMAIL = "kienltde180359@gmail.com";
    private static final String FROM_NAME = "VietCulture";

    private EmailUtils() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Generate 6-digit OTP code
     */
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // 6-digit number
        return String.valueOf(otp);
    }

    /**
     * Test SMTP connection
     */
    public static boolean testSMTPConnection() {
        LOGGER.info("🔗 Testing SMTP connection...");
        
        try {
            Properties props = getSmtpProperties();
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });

            try (Transport transport = session.getTransport("smtp")) {
                transport.connect();
                LOGGER.info("✅ SMTP connection successful!");
                return true;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ SMTP connection failed: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Configure SMTP properties
     */
    private static Properties getSmtpProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        props.put("mail.smtp.connectiontimeout", "30000");
        props.put("mail.smtp.timeout", "60000");
        return props;
    }

    /**
     * Create email session
     */
    private static Session getEmailSession() {
        return Session.getInstance(getSmtpProperties(), new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
    }

    /**
     * Send OTP email for registration
     */
    public static boolean sendRegistrationOTP(String toEmail, String userName, String otpCode) {
        LOGGER.info("📧 Sending registration OTP to: " + toEmail);
        
        try {
            Session session = getEmailSession();
            MimeMessage message = new MimeMessage(session);
            
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Mã xác thực đăng ký VietCulture", "UTF-8");
            
            String htmlContent = createOTPEmailTemplate(userName, otpCode);
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            LOGGER.info("✅ Registration OTP sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Failed to send registration OTP to: " + toEmail, e);
            return false;
        }
    }

    /**
     * Send welcome email after successful registration
     */
    public static boolean sendWelcomeEmail(String toEmail, String userName) {
        LOGGER.info("🎉 Sending welcome email to: " + toEmail);
        
        try {
            Session session = getEmailSession();
            MimeMessage message = new MimeMessage(session);
            
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Chào mừng bạn đến với VietCulture!", "UTF-8");
            
            String htmlContent = createWelcomeEmailTemplate(userName);
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            LOGGER.info("✅ Welcome email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Failed to send welcome email to: " + toEmail, e);
            return false;
        }
    }

    /**
     * Send password reset OTP
     */
    public static boolean sendPasswordResetOTP(String toEmail, String userName, String otpCode) {
        LOGGER.info("🔐 Sending password reset OTP to: " + toEmail);
        
        try {
            Session session = getEmailSession();
            MimeMessage message = new MimeMessage(session);
            
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Mã xác thực đặt lại mật khẩu VietCulture", "UTF-8");
            
            String htmlContent = createPasswordResetOTPTemplate(userName, otpCode);
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            LOGGER.info("✅ Password reset OTP sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Failed to send password reset OTP to: " + toEmail, e);
            return false;
        }
    }

    /**
     * Create OTP email template
     */
    private static String createOTPEmailTemplate(String userName, String otpCode) {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>Mã xác thực đăng ký VietCulture</title>
                <style>
                    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
                    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                    .header { background: linear-gradient(135deg, #10466C, #83C5BE); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                    .content { background: #f9f9f9; padding: 40px 30px; text-align: center; }
                    .otp-code { 
                        background: #fff; 
                        border: 3px dashed #10466C; 
                        font-size: 36px; 
                        font-weight: bold; 
                        color: #10466C; 
                        padding: 20px; 
                        margin: 30px 0; 
                        border-radius: 10px;
                        letter-spacing: 8px;
                    }
                    .warning { 
                        background: #fff3cd; 
                        border-left: 4px solid #ffc107; 
                        color: #856404; 
                        padding: 15px; 
                        margin: 20px 0; 
                        border-radius: 5px; 
                    }
                    .footer { background: #333; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; font-size: 14px; }
                    .highlight { color: #10466C; font-weight: bold; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>🔐 Mã Xác Thực Đăng Ký</h1>
                        <p>VietCulture - Nền tảng du lịch cộng đồng</p>
                    </div>
                    <div class="content">
                        <h2>Xin chào <span class="highlight">%s</span>!</h2>
                        <p>Cảm ơn bạn đã đăng ký tài khoản VietCulture. Để hoàn tất quá trình đăng ký, vui lòng nhập mã xác thực bên dưới:</p>
                        
                        <div class="otp-code">%s</div>
                        
                        <p><strong>Mã này có hiệu lực trong 10 phút.</strong></p>
                        
                        <div class="warning">
                            <strong>⚠️ Lưu ý bảo mật:</strong><br>
                            • Không chia sẻ mã này với bất kỳ ai<br>
                            • VietCulture sẽ không bao giờ yêu cầu mã qua điện thoại<br>
                            • Nếu bạn không đăng ký, vui lòng bỏ qua email này
                        </div>
                        
                        <p>Sau khi xác thực thành công, bạn có thể:</p>
                        <p>🌟 Khám phá trải nghiệm độc đáo | 🏠 Tìm nơi lưu trú | 🤝 Kết nối cộng đồng</p>
                    </div>
                    <div class="footer">
                        <p>© 2025 VietCulture. Email tự động - vui lòng không trả lời.</p>
                        <p>Hỗ trợ: kienltde180359@gmail.com | 1900 1234</p>
                    </div>
                </div>
            </body>
            </html>
            """.formatted(userName, otpCode);
    }

    /**
     * Create password reset OTP email template
     */
    private static String createPasswordResetOTPTemplate(String userName, String otpCode) {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>Mã xác thực đặt lại mật khẩu</title>
                <style>
                    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
                    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                    .header { background: linear-gradient(135deg, #FF385C, #FF6B6B); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                    .content { background: #f9f9f9; padding: 40px 30px; text-align: center; }
                    .otp-code { 
                        background: #fff; 
                        border: 3px dashed #FF385C; 
                        font-size: 36px; 
                        font-weight: bold; 
                        color: #FF385C; 
                        padding: 20px; 
                        margin: 30px 0; 
                        border-radius: 10px;
                        letter-spacing: 8px;
                    }
                    .warning { 
                        background: #f8d7da; 
                        border-left: 4px solid #dc3545; 
                        color: #721c24; 
                        padding: 15px; 
                        margin: 20px 0; 
                        border-radius: 5px; 
                    }
                    .footer { background: #333; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; font-size: 14px; }
                    .highlight { color: #FF385C; font-weight: bold; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>🔐 Đặt Lại Mật Khẩu</h1>
                        <p>VietCulture</p>
                    </div>
                    <div class="content">
                        <h2>Xin chào <span class="highlight">%s</span>!</h2>
                        <p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Vui lòng nhập mã xác thực bên dưới:</p>
                        
                        <div class="otp-code">%s</div>
                        
                        <p><strong>Mã này có hiệu lực trong 10 phút.</strong></p>
                        
                        <div class="warning">
                            <strong>🚨 Cảnh báo bảo mật:</strong><br>
                            • Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này<br>
                            • Không chia sẻ mã này với bất kỳ ai<br>
                            • Liên hệ ngay với chúng tôi nếu có hoạt động đáng ngờ
                        </div>
                    </div>
                    <div class="footer">
                        <p>© 2025 VietCulture. Email tự động - vui lòng không trả lời.</p>
                        <p>Hỗ trợ: kienltde180359@gmail.com | 1900 1234</p>
                    </div>
                </div>
            </body>
            </html>
            """.formatted(userName, otpCode);
    }

    /**
     * Create welcome email template
     */
    private static String createWelcomeEmailTemplate(String userName) {
        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>Chào mừng đến với VietCulture</title>
                <style>
                    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
                    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                    .header { background: linear-gradient(135deg, #83C5BE, #006D77); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                    .content { background: #f9f9f9; padding: 30px; }
                    .feature { background: white; margin: 15px 0; padding: 20px; border-radius: 8px; border-left: 4px solid #83C5BE; }
                    .cta-button { 
                        display: inline-block; 
                        background: #10466C; 
                        color: white; 
                        padding: 15px 30px; 
                        text-decoration: none; 
                        border-radius: 25px; 
                        margin: 20px 0; 
                        font-weight: bold;
                    }
                    .footer { background: #333; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>🎉 Chào mừng %s!</h1>
                        <p>Bạn đã đăng ký thành công tại VietCulture</p>
                    </div>
                    <div class="content">
                        <h2>Cảm ơn bạn đã tham gia cộng đồng VietCulture!</h2>
                        <p>Chúc mừng! Bạn đã chính thức trở thành thành viên của nền tảng du lịch cộng đồng hàng đầu Việt Nam.</p>
                        
                        <div class="feature">
                            <h3>🌟 Khám phá trải nghiệm</h3>
                            <p>Tìm hiểu hàng nghìn trải nghiệm độc đáo từ ẩm thực, văn hóa đến phiêu lưu khắp Việt Nam.</p>
                        </div>
                        
                        <div class="feature">
                            <h3>🏠 Tìm nơi lưu trú</h3>
                            <p>Khám phá homestay ấm cúng, khách sạn tiện nghi từ Bắc đến Nam.</p>
                        </div>
                        
                        <div class="feature">
                            <h3>💼 Trở thành Host</h3>
                            <p>Chia sẻ trải nghiệm độc đáo và kiếm thêm thu nhập từ đam mê của bạn.</p>
                        </div>
                        
                        <div class="feature">
                            <h3>🤝 Kết nối cộng đồng</h3>
                            <p>Gặp gỡ những người bạn mới và chia sẻ những câu chuyện du lịch thú vị.</p>
                        </div>
                        
                        <div style="text-align: center;">
                            <a href="#" class="cta-button">🚀 Bắt Đầu Khám Phá</a>
                        </div>
                        
                        <p style="text-align: center;">Bạn đã sẵn sàng cho cuộc phiêu lưu tiếp theo chưa?</p>
                    </div>
                    <div class="footer">
                        <p>© 2025 VietCulture - Nền tảng trải nghiệm du lịch cộng đồng</p>
                        <p>Cần hỗ trợ? Liên hệ: kienltde180359@gmail.com | 1900 1234</p>
                    </div>
                </div>
            </body>
            </html>
            """.formatted(userName);
    }
}