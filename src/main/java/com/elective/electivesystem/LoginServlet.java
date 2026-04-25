/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.elective.electivesystem;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private String hashPassword(String password) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) hex.append(String.format("%02x", b));
        return hex.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role      = request.getParameter("role");
        String password  = request.getParameter("password");
        String studentId = request.getParameter("studentId");
        String username  = request.getParameter("username");

        try {
            String hashedPassword = hashPassword(password);
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase db   = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            Document user = null;
            if ("student".equals(role)) {
                user = col.find(eq("studentId", studentId)).first();
            } else if ("admin".equals(role)) {
                user = col.find(eq("name", username)).first();
            }

            if (user != null && user.getString("password").equals(hashedPassword)) {

              
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                
                HttpSession session = request.getSession(true);

                session.setAttribute("name", user.getString("name"));
                session.setAttribute("role", role);

                String photo = user.getString("photo");
                session.setAttribute("photo", (photo != null && !photo.isEmpty()) ? photo : "");

                if ("student".equals(role)) {
                    session.setAttribute("studentId", user.getString("studentId"));
                    session.setAttribute("cgpa",        nvl(user.getString("cgpa")));
                    session.setAttribute("codingLevel", nvl(user.getString("codingLevel")));
                    session.setAttribute("goal",        nvl(user.getString("goal")));
                    session.setAttribute("branch",      nvl(user.getString("branch")));
                    session.setAttribute("semester",    nvl(user.getString("semester")));

                    
                    String emailInDb = user.getString("email");
                    if (emailInDb == null || emailInDb.isEmpty()) {
                        client.close();
                        response.sendRedirect(request.getContextPath() + "/add-email.jsp");
                        return;
                    }

                  
                    session.setAttribute("email", emailInDb);
                    client.close();
                    response.sendRedirect(request.getContextPath() + "/dashboard");

                } else {
                    client.close();
                    response.sendRedirect("admin.jsp");
                }

            } else {
                client.close();
                request.setAttribute("error", "Invalid Credentials");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // null-safe helper
    private String nvl(String val) {
        return (val != null) ? val : "";
    }
}