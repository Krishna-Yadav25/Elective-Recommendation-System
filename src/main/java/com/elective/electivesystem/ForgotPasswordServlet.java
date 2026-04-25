
package com.elective.electivesystem;
import java.io.UnsupportedEncodingException;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final String FROM_EMAIL = "krishnayadav250218@gmail.com";
    private static final String APP_PASSWORD = "peizvbjgychztnom";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email").trim();
             String mongoUri=System.getenv("MONGO_URI");
        try (MongoClient client =MongoClients.create(mongoUri)) {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            Document user = col.find(eq("email", email)).first();

            if (user == null) {
                request.setAttribute("error", "No account found with this email.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }

            // Generate 6-digit OTP
            String otp = String.format("%06d", new Random().nextInt(999999));
            long expiry = System.currentTimeMillis() + (5 * 60 * 1000); 

            // Save OTP + expiry in DB first
            col.updateOne(eq("email", email),
                new Document("$set", new Document("resetOtp", otp).append("otpExpiry", expiry)));

            
            try {
                sendOtpEmail(email, otp, user.getString("name"));
            } catch (Exception mailEx) {
                // ✅ Print exact error in NetBeans Output tab
                System.out.println("=== MAIL ERROR ===");
                mailEx.printStackTrace();
                System.out.println("=== END MAIL ERROR ===");

                request.setAttribute("error", "Email sending failed: " + mailEx.getMessage()
                    + " — Check NetBeans Output tab for details.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }

          
            System.out.println("=== OTP SENT SUCCESSFULLY to: " + email + " | OTP: " + otp);
            request.setAttribute("email", email);
            request.setAttribute("success", "OTP sent to " + email);
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("=== DB ERROR ===");
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }

    private void sendOtpEmail(String toEmail, String otp, String name)
            throws MessagingException, UnsupportedEncodingException {

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");  
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");   

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

       
        mailSession.setDebug(true);

        Message msg = new MimeMessage(mailSession);
        msg.setFrom(new InternetAddress(FROM_EMAIL, "Elective Recommendation System"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject("Your Password Reset OTP");

        String html = "<div style='font-family:-apple-system,sans-serif;max-width:480px;margin:auto;background:#fff;border-radius:16px;overflow:hidden;border:1px solid #e8e8f0'>"
            + "<div style='background:#534AB7;padding:28px 32px'>"
            + "<h2 style='color:#fff;margin:0;font-size:20px'>Elective Recommendation System</h2>"
            + "</div>"
            + "<div style='padding:32px'>"
            + "<p style='color:#374151;font-size:15px'>Hi <strong>" + (name != null ? name : "User") + "</strong>,</p>"
            + "<p style='color:#6b7280;font-size:14px;margin-top:8px'>Use the OTP below to reset your password. It is valid for <strong>5 minutes</strong>.</p>"
            + "<div style='margin:28px 0;text-align:center'>"
            + "<span style='font-size:40px;font-weight:800;letter-spacing:12px;color:#534AB7'>" + otp + "</span>"
            + "</div>"
            + "<p style='color:#9ca3af;font-size:12px'>If you didn't request this, please ignore this email.</p>"
            + "</div>"
            + "</div>";

        msg.setContent(html, "text/html; charset=UTF-8");
        Transport.send(msg);
    }
}