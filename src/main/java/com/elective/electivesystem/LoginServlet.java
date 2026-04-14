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
//        String role = request.getParameter("role");
//        String password = request.getParameter("password");
//
//        String studentId = request.getParameter("studentId");
//        String username = request.getParameter("username");
//
//        try {
//            String hashedPassword = hashPassword(password);
//
//            MongoClient client = MongoClients.create("mongodb://localhost:27017");
//            MongoDatabase db = client.getDatabase("electiveDB");
//            MongoCollection<Document> col = db.getCollection("users");
//
//            Document user = null;
//
//            // ROLE BASED LOGIN
//            if ("student".equals(role)) {
//                user = col.find(eq("studentId", studentId)).first();
//            } else if ("admin".equals(role)) {
//                user = col.find(eq("name", username)).first();
//            }
//
//            if (user != null && user.getString("password").equals(hashedPassword)) {
//
//                HttpSession session = request.getSession();
//                session.setAttribute("name", user.getString("name"));
//                session.setAttribute("role", role);
//
//                if ("student".equals(role)) {
//                    session.setAttribute("studentId", user.getString("studentId"));
//                    response.sendRedirect(request.getContextPath() + "/dashboard");
//                } else {
//                    response.sendRedirect("admin.jsp");
//                }
//
//            } else {
//                request.setAttribute("error", "Invalid Credentials");
//                request.getRequestDispatcher("index.jsp").forward(request, response);
//            }
//
//            client.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//}
//
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
//        String role = request.getParameter("role");
//        String password = request.getParameter("password");
//
//        String studentId = request.getParameter("studentId");
//        String username = request.getParameter("username");
//
//        try {
//            String hashedPassword = hashPassword(password);
//
//            MongoClient client = MongoClients.create("mongodb://localhost:27017");
//            MongoDatabase db = client.getDatabase("electiveDB");
//
//            // ✅ IMPORTANT: use SAME collection everywhere
//            MongoCollection<Document> col = db.getCollection("users");
//
//            Document user = null;
//
//            // ROLE BASED LOGIN
//            if ("student".equals(role)) {
//                user = col.find(eq("studentId", studentId)).first();
//            } else if ("admin".equals(role)) {
//                user = col.find(eq("name", username)).first();
//            }
//
//            if (user != null && user.getString("password").equals(hashedPassword)) {
//
//                HttpSession session = request.getSession();
//
//                // Basic info
//                session.setAttribute("name", user.getString("name"));
//                session.setAttribute("role", role);
//
//                // ✅ PHOTO HANDLING (NEW)
//                String photo = user.getString("photo");
//                if (photo == null || photo.isEmpty()) {
//                    photo = "default.png";
//                }
//                session.setAttribute("photo", photo);
//
//                if ("student".equals(role)) {
//                    session.setAttribute("studentId", user.getString("studentId"));
//                    response.sendRedirect(request.getContextPath() + "/dashboard");
//                } else {
//                    response.sendRedirect("admin.jsp");
//                }
//
//            } else {
//                request.setAttribute("error", "Invalid Credentials");
//                request.getRequestDispatcher("index.jsp").forward(request, response);
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

                // ✅ FIX 1: Purana session completely destroy karo
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                // ✅ FIX 2: Bilkul naya session banao
                HttpSession session = request.getSession(true);

                // ✅ FIX 3: Sirf is user ka data set karo
                session.setAttribute("name", user.getString("name"));
                session.setAttribute("role", role);

                // Photo: sirf is user ki, default nahi deni agar DB mein nahi hai
                String photo = user.getString("photo");
                session.setAttribute("photo", (photo != null && !photo.isEmpty()) ? photo : "");

                if ("student".equals(role)) {
                    session.setAttribute("studentId", user.getString("studentId"));

                    // ✅ FIX 4: Academic fields bhi session mein rakho taaki dashboard
                    //           pe purane user ka data na dikhe
                    session.setAttribute("cgpa",        nvl(user.getString("cgpa")));
                    session.setAttribute("codingLevel", nvl(user.getString("codingLevel")));
                    session.setAttribute("goal",        nvl(user.getString("goal")));
                    session.setAttribute("branch",      nvl(user.getString("branch")));
                    session.setAttribute("semester",    nvl(user.getString("semester")));

                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect("admin.jsp");
                }

            } else {
                request.setAttribute("error", "Invalid Credentials");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

            client.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // null-safe helper — empty string return karta hai agar DB field null ho
    private String nvl(String val) {
        return (val != null) ? val : "";
    }
}