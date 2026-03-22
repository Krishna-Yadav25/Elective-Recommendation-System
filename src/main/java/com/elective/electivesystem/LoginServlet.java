/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

//package com.elective.electivesystem;
//
//import java.io.*;
//import javax.servlet.*;
//import javax.servlet.http.*;
//import javax.servlet.annotation.WebServlet;
//
//import com.mongodb.client.*;
//import org.bson.Document;
//import static com.mongodb.client.model.Filters.eq;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
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
//            Document user = col.find(eq("studentId", studentId)).first();
//
//            if (user != null && user.getString("password").equals(hashedPassword)) {
//
//                HttpSession session = request.getSession();
//
//                // store user info
//                session.setAttribute("studentId", studentId);
//                session.setAttribute("name", user.getString("name"));
//
//                response.sendRedirect("dashboard.jsp");
//
//            } else {
//                response.getWriter().println("<h3>Invalid Credentials</h3>");
//            }
//
//            client.close();
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
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

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

        String studentId = request.getParameter("studentId");
        String password = request.getParameter("password");

        try {
            String hashedPassword = hashPassword(password);

            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            Document user = col.find(eq("studentId", studentId)).first();

            if (user != null && user.getString("password").equals(hashedPassword)) {

                HttpSession session = request.getSession();

                session.setAttribute("studentId", studentId);
                session.setAttribute("name", user.getString("name"));

                response.sendRedirect("dashboard.jsp");

            } else {
              
                request.setAttribute("error", "Invalid Student ID or Password!");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

            client.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}