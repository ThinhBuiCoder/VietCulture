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
    // Add this method to your EmailUtils class

/**
 * Send password reset confirmation email
 */
public static boolean sendPasswordResetConfirmation(String toEmail, String userName) {
    LOGGER.info("🔐 Sending password reset confirmation to: " + toEmail);
    
    try {
        Session session = getEmailSession();
        MimeMessage message = new MimeMessage(session);
        
        message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("Mật khẩu đã được đặt lại thành công - VietCulture", "UTF-8");
        
        String htmlContent = createPasswordResetConfirmationTemplate(userName);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
        
        Transport.send(message);
        LOGGER.info("✅ Password reset confirmation sent successfully to: " + toEmail);
        return true;
        
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "❌ Failed to send password reset confirmation to: " + toEmail, e);
        return false;
    }
}

/**
 * Create password reset confirmation email template
 */
private static String createPasswordResetConfirmationTemplate(String userName) {
    return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Mật khẩu đã được đặt lại thành công</title>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background: linear-gradient(135deg, #10B981, #059669); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                .content { background: #f9f9f9; padding: 40px 30px; text-align: center; }
                .success-icon { 
                    background: #fff; 
                    border: 3px solid #10B981; 
                    font-size: 48px; 
                    color: #10B981; 
                    padding: 20px; 
                    margin: 30px auto; 
                    border-radius: 50%;
                    width: 80px;
                    height: 80px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .info-box { 
                    background: #e6f7ff; 
                    border-left: 4px solid #1890ff; 
                    color: #0050b3; 
                    padding: 15px; 
                    margin: 20px 0; 
                    border-radius: 5px; 
                }
                .security-tips {
                    background: #fff;
                    border: 1px solid #d9d9d9;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                    text-align: left;
                }
                .tip {
                    display: flex;
                    align-items: flex-start;
                    margin-bottom: 10px;
                    gap: 10px;
                }
                .footer { background: #333; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; font-size: 14px; }
                .highlight { color: #10B981; font-weight: bold; }
                .cta-button { 
                    display: inline-block; 
                    background: #10B981; 
                    color: white; 
                    padding: 12px 24px; 
                    text-decoration: none; 
                    border-radius: 6px; 
                    margin: 20px 0; 
                    font-weight: bold;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>✅ Mật Khẩu Đã Được Đặt Lại</h1>
                    <p>VietCulture</p>
                </div>
                <div class="content">
                    <div class="success-icon">✓</div>
                    
                    <h2>Xin chào <span class="highlight">%s</span>!</h2>
                    <p>Mật khẩu cho tài khoản VietCulture của bạn đã được đặt lại thành công.</p>
                    
                    <div class="info-box">
                        <strong>🕐 Thời gian:</strong> %s<br>
                        <strong>🔐 Trạng thái:</strong> Đặt lại thành công
                    </div>
                    
                    <div class="security-tips">
                        <h3>💡 Lời khuyên bảo mật:</h3>
                        <div class="tip">
                            <span>🔒</span>
                            <span>Sử dụng mật khẩu mạnh và độc nhất cho mỗi tài khoản</span>
                        </div>
                        <div class="tip">
                            <span>🚫</span>
                            <span>Không chia sẻ mật khẩu với bất kỳ ai</span>
                        </div>
                        <div class="tip">
                            <span>🔍</span>
                            <span>Kiểm tra thường xuyên hoạt động tài khoản</span>
                        </div>
                        <div class="tip">
                            <span>📱</span>
                            <span>Bật xác thực 2 yếu tố khi có thể</span>
                        </div>
                    </div>
                    
                    <p>Nếu bạn không thực hiện thao tác này, vui lòng liên hệ với chúng tôi ngay lập tức.</p>
                    
                    <a href="#" class="cta-button">🏠 Về Trang Chủ</a>
                </div>
                <div class="footer">
                    <p>© 2025 VietCulture. Email tự động - vui lòng không trả lời.</p>
                    <p>Hỗ trợ khẩn cấp: kienltde180359@gmail.com | 1900 1234</p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(userName, java.time.LocalDateTime.now().format(
            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
}
/**
 * Send booking confirmation email
 */
public static boolean sendBookingConfirmationEmail(String toEmail, String customerName, 
                                                 int bookingId, String serviceName, 
                                                 String bookingDate, String timeSlot, 
                                                 int numberOfPeople, String totalPrice) {
    LOGGER.info("📧 Sending booking confirmation to: " + toEmail);
    
    try {
        Session session = getEmailSession();
        MimeMessage message = new MimeMessage(session);
        
        message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("Xác nhận đặt chỗ thành công - VietCulture", "UTF-8");
        
        String htmlContent = createBookingConfirmationTemplate(
            customerName, bookingId, serviceName, bookingDate, 
            timeSlot, numberOfPeople, totalPrice);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
        
        Transport.send(message);
        LOGGER.info("✅ Booking confirmation sent successfully to: " + toEmail);
        return true;
        
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "❌ Failed to send booking confirmation to: " + toEmail, e);
        return false;
    }
}

/**
 * Create booking confirmation email template
 */
private static String createBookingConfirmationTemplate(String customerName, int bookingId, 
                                                      String serviceName, String bookingDate, 
                                                      String timeSlot, int numberOfPeople, 
                                                      String totalPrice) {
    return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Xác nhận đặt chỗ thành công</title>
            <style>
                body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f5f5f5; }
                .container { max-width: 600px; margin: 0 auto; background: white; }
                .header { 
                    background: linear-gradient(135deg, #10466C, #83C5BE); 
                    color: white; 
                    padding: 30px; 
                    text-align: center; 
                    border-radius: 0;
                }
                .content { padding: 30px; }
                .booking-card {
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    padding: 25px;
                    margin: 20px 0;
                }
                .booking-id {
                    background: #10466C;
                    color: white;
                    padding: 8px 16px;
                    border-radius: 20px;
                    font-weight: bold;
                    display: inline-block;
                    margin-bottom: 20px;
                }
                .service-name {
                    font-size: 24px;
                    font-weight: bold;
                    color: #10466C;
                    margin-bottom: 15px;
                }
                .detail-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 12px 0;
                    border-bottom: 1px solid #e9ecef;
                }
                .detail-row:last-child {
                    border-bottom: none;
                }
                .detail-label {
                    font-weight: 600;
                    color: #666;
                }
                .detail-value {
                    font-weight: bold;
                    color: #333;
                }
                .total-price {
                    background: #e8f5e8;
                    border: 2px solid #10466C;
                    border-radius: 8px;
                    padding: 15px;
                    text-align: center;
                    margin: 20px 0;
                }
                .total-price .amount {
                    font-size: 28px;
                    font-weight: bold;
                    color: #10466C;
                }
                .status-badge {
                    background: #28a745;
                    color: white;
                    padding: 6px 12px;
                    border-radius: 15px;
                    font-weight: bold;
                    font-size: 14px;
                }
                .next-steps {
                    background: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 20px;
                    margin: 25px 0;
                    border-radius: 0 8px 8px 0;
                }
                .cta-section {
                    text-align: center;
                    margin: 30px 0;
                }
                .cta-button {
                    display: inline-block;
                    background: #10466C;
                    color: white;
                    padding: 15px 30px;
                    text-decoration: none;
                    border-radius: 25px;
                    font-weight: bold;
                    margin: 10px;
                }
                .contact-info {
                    background: #e3f2fd;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                    text-align: center;
                }
                .footer { 
                    background: #333; 
                    color: white; 
                    padding: 25px; 
                    text-align: center; 
                    font-size: 14px; 
                }
                .highlight { color: #10466C; font-weight: bold; }
                .icon { font-size: 18px; margin-right: 8px; }
                
                @media (max-width: 600px) {
                    .detail-row { flex-direction: column; align-items: flex-start; }
                    .detail-value { margin-top: 5px; }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🎉 Đặt Chỗ Thành Công!</h1>
                    <p>VietCulture - Trải nghiệm đáng nhớ đang chờ bạn</p>
                </div>
                
                <div class="content">
                    <h2>Xin chào <span class="highlight">%s</span>!</h2>
                    <p>Cảm ơn bạn đã đặt chỗ với VietCulture. Đơn đặt chỗ của bạn đã được xác nhận thành công!</p>
                    
                    <div class="booking-card">
                        <div class="booking-id">📋 Mã đặt chỗ: #%d</div>
                        <div class="status-badge">✅ Đã xác nhận</div>
                        
                        <div class="service-name">🌟 %s</div>
                        
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">📅</span>Ngày:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">⏰</span>Thời gian:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">👥</span>Số người:</span>
                            <span class="detail-value">%d người</span>
                        </div>
                        
                        <div class="total-price">
                            <div>💰 Tổng thanh toán</div>
                            <div class="amount">%s</div>
                        </div>
                    </div>
                    
                    <div class="next-steps">
                        <h3>📋 Các bước tiếp theo:</h3>
                        <ul>
                            <li><strong>Chuẩn bị:</strong> Vui lòng có mặt đúng giờ đã đặt</li>
                            <li><strong>Liên hệ:</strong> Host sẽ liên hệ với bạn trước 24h</li>
                            <li><strong>Thay đổi:</strong> Liên hệ với chúng tôi nếu cần điều chỉnh</li>
                            <li><strong>Đánh giá:</strong> Chia sẻ trải nghiệm sau chuyến đi</li>
                        </ul>
                    </div>
                    
                    <div class="cta-section">
                        <a href="#" class="cta-button">📱 Xem Chi Tiết</a>
                        <a href="#" class="cta-button">💬 Liên Hệ Host</a>
                    </div>
                    
                    <div class="contact-info">
                        <h3>🆘 Cần hỗ trợ?</h3>
                        <p><strong>Hotline:</strong> 1900 1234 (24/7)<br>
                        <strong>Email:</strong> support@vietculture.com<br>
                        <strong>Live Chat:</strong> Trên website VietCulture</p>
                    </div>
                    
                    <p style="text-align: center; color: #666; font-style: italic;">
                        Chúc bạn có những trải nghiệm tuyệt vời cùng VietCulture! 🎊
                    </p>
                </div>
                
                <div class="footer">
                    <p><strong>© 2025 VietCulture</strong> - Nền tảng trải nghiệm du lịch cộng đồng</p>
                    <p>Email tự động - vui lòng không trả lời trực tiếp</p>
                    <p>Mã đặt chỗ: #%d | Ngày gửi: %s</p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(
            customerName,           // %s - tên khách hàng
            bookingId,             // %d - mã đặt chỗ
            serviceName,           // %s - tên dịch vụ
            bookingDate,           // %s - ngày đặt
            timeSlot,              // %s - khung giờ
            numberOfPeople,        // %d - số người
            totalPrice,            // %s - tổng tiền
            bookingId,             // %d - mã đặt chỗ (footer)
            java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))  // ngày gửi
        );
}
/**
 * Send payment success email
 */
public static boolean sendPaymentSuccessEmail(String toEmail, String userName, 
                                            int bookingId, String serviceName, 
                                            String bookingDate, String bookingTime, 
                                            int numberOfPeople, String totalPrice, 
                                            String paymentMethod) {
    LOGGER.info("💳 Sending payment success email to: " + toEmail);
    
    try {
        Session session = getEmailSession();
        MimeMessage message = new MimeMessage(session);
        
        message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("✅ Thanh toán thành công - VietCulture", "UTF-8");
        
        String htmlContent = createPaymentSuccessTemplate(
            userName, bookingId, serviceName, bookingDate, 
            bookingTime, numberOfPeople, totalPrice, paymentMethod);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
        
        Transport.send(message);
        LOGGER.info("✅ Payment success email sent successfully to: " + toEmail);
        return true;
        
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "❌ Failed to send payment success email to: " + toEmail, e);
        return false;
    }
}

/**
 * Send payment failure email
 */
public static boolean sendPaymentFailureEmail(String toEmail, String userName, 
                                            int bookingId, String serviceName, 
                                            String totalPrice, String failureReason, 
                                            String paymentMethod) {
    LOGGER.info("❌ Sending payment failure email to: " + toEmail);
    
    try {
        Session session = getEmailSession();
        MimeMessage message = new MimeMessage(session);
        
        message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("❌ Thanh toán không thành công - VietCulture", "UTF-8");
        
        String htmlContent = createPaymentFailureTemplate(
            userName, bookingId, serviceName, totalPrice, 
            failureReason, paymentMethod);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
        
        Transport.send(message);
        LOGGER.info("✅ Payment failure email sent successfully to: " + toEmail);
        return true;
        
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "❌ Failed to send payment failure email to: " + toEmail, e);
        return false;
    }
}

/**
 * Create payment success email template
 */
private static String createPaymentSuccessTemplate(String userName, int bookingId, 
                                                 String serviceName, String bookingDate, 
                                                 String bookingTime, int numberOfPeople, 
                                                 String totalPrice, String paymentMethod) {
    return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Thanh toán thành công</title>
            <style>
                body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f5f5f5; }
                .container { max-width: 600px; margin: 0 auto; background: white; }
                .header { 
                    background: linear-gradient(135deg, #10B981, #059669); 
                    color: white; 
                    padding: 30px; 
                    text-align: center; 
                    border-radius: 0;
                }
                .content { padding: 30px; }
                .success-banner {
                    background: #ecfdf5;
                    border: 2px solid #10B981;
                    border-radius: 12px;
                    padding: 20px;
                    text-align: center;
                    margin: 20px 0;
                }
                .success-icon {
                    background: #10B981;
                    color: white;
                    width: 60px;
                    height: 60px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 30px;
                    margin: 0 auto 15px;
                }
                .payment-details {
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    padding: 25px;
                    margin: 20px 0;
                }
                .booking-summary {
                    background: #fff;
                    border: 2px solid #e9ecef;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                }
                .detail-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 8px 0;
                    border-bottom: 1px solid #e9ecef;
                }
                .detail-row:last-child {
                    border-bottom: none;
                    font-weight: bold;
                    background: #f8f9fa;
                    margin: 10px -10px -10px;
                    padding: 15px 10px;
                    border-radius: 6px;
                }
                .detail-label {
                    font-weight: 600;
                    color: #666;
                }
                .detail-value {
                    font-weight: bold;
                    color: #333;
                }
                .amount-highlight {
                    color: #10B981;
                    font-size: 20px;
                }
                .status-badge {
                    background: #10B981;
                    color: white;
                    padding: 6px 12px;
                    border-radius: 15px;
                    font-weight: bold;
                    font-size: 14px;
                    display: inline-block;
                }
                .next-steps {
                    background: #fffbeb;
                    border-left: 4px solid #f59e0b;
                    padding: 20px;
                    margin: 25px 0;
                    border-radius: 0 8px 8px 0;
                }
                .cta-section {
                    text-align: center;
                    margin: 30px 0;
                }
                .cta-button {
                    display: inline-block;
                    background: #10B981;
                    color: white;
                    padding: 15px 30px;
                    text-decoration: none;
                    border-radius: 25px;
                    font-weight: bold;
                    margin: 10px;
                }
                .support-info {
                    background: #f1f5f9;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                    text-align: center;
                }
                .footer { 
                    background: #333; 
                    color: white; 
                    padding: 25px; 
                    text-align: center; 
                    font-size: 14px; 
                }
                .highlight { color: #10B981; font-weight: bold; }
                .icon { font-size: 18px; margin-right: 8px; }
                
                @media (max-width: 600px) {
                    .detail-row { flex-direction: column; align-items: flex-start; }
                    .detail-value { margin-top: 5px; }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🎉 Thanh Toán Thành Công!</h1>
                    <p>VietCulture - Cảm ơn bạn đã tin tưởng</p>
                </div>
                
                <div class="content">
                    <div class="success-banner">
                        <div class="success-icon">✓</div>
                        <h2>Giao dịch hoàn tất!</h2>
                        <p>Chúng tôi đã nhận được thanh toán của bạn thành công</p>
                        <div class="status-badge">✅ Đã thanh toán</div>
                    </div>
                    
                    <h2>Xin chào <span class="highlight">%s</span>!</h2>
                    <p>Cảm ơn bạn đã hoàn tất thanh toán cho đơn đặt chỗ. Dưới đây là thông tin chi tiết:</p>
                    
                    <div class="payment-details">
                        <h3>💳 Thông tin thanh toán</h3>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">🔢</span>Mã đặt chỗ:</span>
                            <span class="detail-value">#%d</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">💰</span>Số tiền:</span>
                            <span class="detail-value amount-highlight">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">💳</span>Phương thức:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">⏰</span>Thời gian:</span>
                            <span class="detail-value">%s</span>
                        </div>
                    </div>
                    
                    <div class="booking-summary">
                        <h3>📋 Thông tin đặt chỗ</h3>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">🌟</span>Dịch vụ:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">📅</span>Ngày:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">🕐</span>Giờ:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">👥</span>Số người:</span>
                            <span class="detail-value">%d người</span>
                        </div>
                    </div>
                    
                    <div class="next-steps">
                        <h3>📋 Các bước tiếp theo:</h3>
                        <ul>
                            <li><strong>Email xác nhận:</strong> Bạn sẽ nhận được email xác nhận chi tiết trong vài phút</li>
                            <li><strong>Liên hệ Host:</strong> Host sẽ liên hệ với bạn trước 24h</li>
                            <li><strong>Chuẩn bị:</strong> Vui lòng có mặt đúng giờ đã đặt</li>
                            <li><strong>Hỗ trợ:</strong> Liên hệ hotline nếu cần hỗ trợ</li>
                        </ul>
                    </div>
                    
                    <div class="cta-section">
                        <a href="#" class="cta-button">📱 Xem Chi Tiết Đơn Hàng</a>
                        <a href="#" class="cta-button">🏠 Về Trang Chủ</a>
                    </div>
                    
                    <div class="support-info">
                        <h3>🆘 Cần hỗ trợ?</h3>
                        <p><strong>Hotline:</strong> 1900 1234 (24/7)<br>
                        <strong>Email:</strong> support@vietculture.com<br>
                        <strong>Live Chat:</strong> Trên website VietCulture</p>
                    </div>
                    
                    <p style="text-align: center; color: #666; font-style: italic;">
                        Chúc bạn có những trải nghiệm tuyệt vời cùng VietCulture! 🎊
                    </p>
                </div>
                
                <div class="footer">
                    <p><strong>© 2025 VietCulture</strong> - Nền tảng trải nghiệm du lịch cộng đồng</p>
                    <p>Email tự động - vui lòng không trả lời trực tiếp</p>
                    <p>Mã giao dịch: #%d | Ngày: %s</p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(
            userName,                    // %s - tên khách hàng
            bookingId,                   // %d - mã đặt chỗ
            totalPrice,                  // %s - số tiền
            paymentMethod,               // %s - phương thức thanh toán
            java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")), // thời gian thanh toán
            serviceName,                 // %s - tên dịch vụ
            bookingDate,                 // %s - ngày đặt
            bookingTime,                 // %s - giờ đặt
            numberOfPeople,              // %d - số người
            bookingId,                   // %d - mã giao dịch (footer)
            java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))  // ngày gửi
        );
}

/**
 * Create payment failure email template
 */
private static String createPaymentFailureTemplate(String userName, int bookingId, 
                                                 String serviceName, String totalPrice, 
                                                 String failureReason, String paymentMethod) {
    return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Thanh toán không thành công</title>
            <style>
                body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f5f5f5; }
                .container { max-width: 600px; margin: 0 auto; background: white; }
                .header { 
                    background: linear-gradient(135deg, #EF4444, #DC2626); 
                    color: white; 
                    padding: 30px; 
                    text-align: center; 
                    border-radius: 0;
                }
                .content { padding: 30px; }
                .failure-banner {
                    background: #fef2f2;
                    border: 2px solid #EF4444;
                    border-radius: 12px;
                    padding: 20px;
                    text-align: center;
                    margin: 20px 0;
                }
                .failure-icon {
                    background: #EF4444;
                    color: white;
                    width: 60px;
                    height: 60px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 30px;
                    margin: 0 auto 15px;
                }
                .failure-details {
                    background: #fef2f2;
                    border: 1px solid #fecaca;
                    border-radius: 8px;
                    padding: 25px;
                    margin: 20px 0;
                }
                .booking-info {
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                }
                .detail-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 8px 0;
                    border-bottom: 1px solid #e9ecef;
                }
                .detail-row:last-child {
                    border-bottom: none;
                }
                .detail-label {
                    font-weight: 600;
                    color: #666;
                }
                .detail-value {
                    font-weight: bold;
                    color: #333;
                }
                .amount-highlight {
                    color: #EF4444;
                    font-size: 18px;
                }
                .status-badge {
                    background: #EF4444;
                    color: white;
                    padding: 6px 12px;
                    border-radius: 15px;
                    font-weight: bold;
                    font-size: 14px;
                    display: inline-block;
                }
                .retry-section {
                    background: #fffbeb;
                    border-left: 4px solid #f59e0b;
                    padding: 20px;
                    margin: 25px 0;
                    border-radius: 0 8px 8px 0;
                }
                .cta-section {
                    text-align: center;
                    margin: 30px 0;
                }
                .cta-button {
                    display: inline-block;
                    background: #10B981;
                    color: white;
                    padding: 15px 30px;
                    text-decoration: none;
                    border-radius: 25px;
                    font-weight: bold;
                    margin: 10px;
                }
                .retry-button {
                    background: #f59e0b;
                }
                .support-info {
                    background: #f1f5f9;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                    text-align: center;
                }
                .common-issues {
                    background: #e0f2fe;
                    border-radius: 8px;
                    padding: 20px;
                    margin: 20px 0;
                }
                .issue-item {
                    display: flex;
                    align-items: flex-start;
                    margin-bottom: 10px;
                    gap: 10px;
                }
                .footer { 
                    background: #333; 
                    color: white; 
                    padding: 25px; 
                    text-align: center; 
                    font-size: 14px; 
                }
                .highlight { color: #EF4444; font-weight: bold; }
                .icon { font-size: 18px; margin-right: 8px; }
                
                @media (max-width: 600px) {
                    .detail-row { flex-direction: column; align-items: flex-start; }
                    .detail-value { margin-top: 5px; }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>❌ Thanh Toán Không Thành Công</h1>
                    <p>VietCulture - Đừng lo lắng, chúng tôi sẽ hỗ trợ bạn</p>
                </div>
                
                <div class="content">
                    <div class="failure-banner">
                        <div class="failure-icon">✗</div>
                        <h2>Giao dịch thất bại</h2>
                        <p>Rất tiếc, thanh toán của bạn không thể hoàn tất</p>
                        <div class="status-badge">❌ Thất bại</div>
                    </div>
                    
                    <h2>Xin chào <span class="highlight">%s</span>!</h2>
                    <p>Chúng tôi rất tiếc khi thông báo rằng giao dịch thanh toán của bạn không thành công. Đừng lo lắng, bạn có thể thử lại hoặc sử dụng phương thức thanh toán khác.</p>
                    
                    <div class="failure-details">
                        <h3>❌ Chi tiết lỗi</h3>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">🔢</span>Mã đặt chỗ:</span>
                            <span class="detail-value">#%d</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">💰</span>Số tiền:</span>
                            <span class="detail-value amount-highlight">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">💳</span>Phương thức:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">❗</span>Lý do:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">⏰</span>Thời gian:</span>
                            <span class="detail-value">%s</span>
                        </div>
                    </div>
                    
                    <div class="booking-info">
                        <h3>📋 Thông tin đặt chỗ</h3>
                        <div class="detail-row">
                            <span class="detail-label"><span class="icon">🌟</span>Dịch vụ:</span>
                            <span class="detail-value">%s</span>
                        </div>
                        <p style="margin-top: 15px; color: #666; font-style: italic;">
                            * Đặt chỗ của bạn vẫn được giữ chỗ trong 30 phút để bạn có thể thử thanh toán lại
                        </p>
                    </div>
                    
                    <div class="common-issues">
                        <h3>🔍 Nguyên nhân thường gặp:</h3>
                        <div class="issue-item">
                            <span>💳</span>
                            <span>Thông tin thẻ không chính xác hoặc thẻ hết hạn</span>
                        </div>
                        <div class="issue-item">
                            <span>💰</span>
                            <span>Số dư tài khoản không đủ</span>
                        </div>
                        <div class="issue-item">
                            <span>🔒</span>
                            <span>Thẻ bị khóa hoặc hạn chế giao dịch online</span>
                        </div>
                        <div class="issue-item">
                            <span>🌐</span>
                            <span>Lỗi kết nối mạng trong quá trình giao dịch</span>
                        </div>
                    </div>
                    
                    <div class="retry-section">
                        <h3>🔄 Cách khắc phục:</h3>
                        <ul>
                            <li><strong>Kiểm tra thông tin thẻ:</strong> Đảm bảo số thẻ, ngày hết hạn và CVV chính xác</li>
                            <li><strong>Kiểm tra số dư:</strong> Đảm bảo tài khoản có đủ số dư</li>
                            <li><strong>Liên hệ ngân hàng:</strong> Xác nhận thẻ không bị khóa giao dịch online</li>
                            <li><strong>Thử phương thức khác:</strong> Sử dụng thẻ khác hoặc ví điện tử</li>
                            <li><strong>Thử lại sau:</strong> Đôi khi lỗi tạm thời sẽ tự khắc phục</li>
                        </ul>
                    </div>
                    
                    <div class="cta-section">
                        <a href="#" class="cta-button retry-button">🔄 Thử Lại Thanh Toán</a>
                        <a href="#" class="cta-button">💬 Liên Hệ Hỗ Trợ</a>
                    </div>
                    
                    <div class="support-info">
                        <h3>🆘 Cần hỗ trợ ngay?</h3>
                        <p><strong>Hotline:</strong> 1900 1234 (24/7)<br>
                        <strong>Email:</strong> support@vietculture.com<br>
                        <strong>Live Chat:</strong> Trên website VietCulture</p>
                        <p style="margin-top: 10px; font-size: 14px; color: #666;">
                            Nhân viên hỗ trợ sẽ giúp bạn xử lý ngay lập tức
                        </p>
                    </div>
                    
                    <p style="text-align: center; color: #666; font-style: italic;">
                        Cảm ơn bạn đã kiên nhẫn. Chúng tôi luôn sẵn sàng hỗ trợ! 🙏
                    </p>
                </div>
                
                <div class="footer">
                    <p><strong>© 2025 VietCulture</strong> - Nền tảng trải nghiệm du lịch cộng đồng</p>
                    <p>Email tự động - vui lòng không trả lời trực tiếp</p>
                    <p>Mã giao dịch: #%d | Ngày: %s</p>
                </div>
            </div>
        </body>
        </html>
        """.formatted(
            userName,                    // %s - tên khách hàng
            bookingId,                   // %d - mã đặt chỗ
            totalPrice,                  // %s - số tiền
            paymentMethod,               // %s - phương thức thanh toán
            failureReason,               // %s - lý do thất bại
            java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")), // thời gian
            serviceName,                 // %s - tên dịch vụ
            bookingId,                   // %d - mã giao dịch (footer)
            java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))  // ngày gửi
        );
}
}