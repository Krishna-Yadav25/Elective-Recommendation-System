/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
//package com.elective.electivesystem;
//
//import java.io.*;
//import javax.servlet.*;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import com.mongodb.client.*;
//import org.bson.Document;
//
//@WebServlet("/register")
//public class RegisterServlet extends HttpServlet {
//
//    private String hashPassword(String password) throws Exception {
//        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
//        byte[] hash = md.digest(password.getBytes());
//
//        StringBuilder hex = new StringBuilder();
//        for (byte b : hash) {
//            hex.append(String.format("%02x", b));
//        }
//        return hex.toString();
//    }
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String studentId = request.getParameter("studentId");
//        String password = request.getParameter("password");
//
//        try {
//            String hashedPassword = hashPassword(password);
//
//            MongoClient client = MongoClients.create("mongodb://localhost:27017");
//            MongoDatabase db = client.getDatabase("electiveDB");
//            MongoCollection<Document> col = db.getCollection("users");
//
//            Document doc = new Document("studentId", studentId)
//                    .append("password", hashedPassword);
//
//            col.insertOne(doc);
//
//            PrintWriter out = response.getWriter();
//            out.println("<h2>Registered Successfully!</h2>");
//            out.println("<a href='index.html'>Login</a>");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//}

package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import com.mongodb.client.*;
import org.bson.Document;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    // SHA-256 hashing
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

        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String password = request.getParameter("password");

        try {
            String hashedPassword = hashPassword(password);

            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            // check if user already exists
            Document existingUser = col.find(new Document("studentId", studentId)).first();

            if (existingUser != null) {
                response.getWriter().println("<h3>User already exists!</h3>");
                return;
            }

            Document doc = new Document("name", name)
                    .append("studentId", studentId)
                    .append("password", hashedPassword);

            col.insertOne(doc);

            client.close();

            response.sendRedirect("index.html");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}