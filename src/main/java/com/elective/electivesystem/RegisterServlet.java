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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private String hashPassword(String password) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name      = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String password  = request.getParameter("password");
        String email     = request.getParameter("email"); 

        try {
            String hashedPassword = hashPassword(password);
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase db   = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            Document existingUser = col.find(new Document("studentId", studentId)).first();
            if (existingUser != null) {
                request.setAttribute("error", "Student ID already registered!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                client.close();
                return;
            }

            Document doc = new Document("name", name)
                    .append("studentId", studentId)
                    .append("email", email)           
                    .append("password", hashedPassword)
                    .append("role", "student");

            col.insertOne(doc);
            client.close();
            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}