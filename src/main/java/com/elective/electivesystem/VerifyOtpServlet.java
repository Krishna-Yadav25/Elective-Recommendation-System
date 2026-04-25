package com.elective.electivesystem;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String otp   = request.getParameter("otp");

        try (MongoClient client = MongoClients.create("mongodb://localhost:27017")) {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            Document user = col.find(eq("email", email)).first();

            if (user == null) {
                request.setAttribute("error", "Session expired. Please try again.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            String savedOtp  = user.getString("resetOtp");
            Long   expiry    = user.getLong("otpExpiry");

            if (savedOtp == null || expiry == null) {
                request.setAttribute("error", "OTP not found. Please request a new one.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            if (System.currentTimeMillis() > expiry) {
                request.setAttribute("error", "OTP has expired. Please request a new one.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

            if (!savedOtp.equals(otp)) {
                request.setAttribute("error", "Incorrect OTP. Please try again.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }

          
            col.updateOne(eq("email", email),
                new Document("$unset", new Document("resetOtp", "").append("otpExpiry", "")));

           
            request.setAttribute("email", email);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        }
    }
}