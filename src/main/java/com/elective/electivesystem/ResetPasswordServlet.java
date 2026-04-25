package com.elective.electivesystem;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private String hashPassword(String password) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) hex.append(String.format("%02x", b));
        return hex.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email           = request.getParameter("email");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        try (MongoClient client = MongoClients.create("mongodb+srv://yadavkkrishna005_db_user:08IqQu4F1dUXlkao@cluster0.wfbiz1o.mongodb.net/electiveDB?appName=Cluster0")) {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            String hashed = hashPassword(newPassword);
            col.updateOne(eq("email", email),
                new Document("$set", new Document("password", hashed)));

            // Redirect to login with success message
            response.sendRedirect(request.getContextPath() + "/index.jsp?reset=success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to reset password. Try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}