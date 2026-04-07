/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


//package com.elective.electivesystem;
//
//import java.io.*;
//import javax.servlet.*;
//import javax.servlet.http.*;
//import javax.servlet.annotation.*;
//
//import com.mongodb.client.*;
//import org.bson.Document;
//import static com.mongodb.client.model.Filters.eq;
//
//@WebServlet("/dashboard")
//public class DashBoardServlet extends HttpServlet {
//
//    // ================= SAVE FORM DATA =================
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("studentId") == null) {
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String studentId = (String) session.getAttribute("studentId");
//
//        String branch = request.getParameter("branch");
//        String semester = request.getParameter("semester");
//        String tenth = request.getParameter("tenth");
//        String twelfth = request.getParameter("twelfth");
//        String cgpa = request.getParameter("cgpa");
//        String codingLevel = request.getParameter("codingLevel");
//        String goal = request.getParameter("goal");
//
//        MongoClient client = MongoClients.create("mongodb://localhost:27017");
//        MongoDatabase db = client.getDatabase("electiveDB");
//        MongoCollection<Document> col = db.getCollection("student_profile");
//
//        Document doc = new Document("studentId", studentId)
//                .append("branch", branch)
//                .append("semester", semester)
//                .append("tenth", tenth)
//                .append("twelfth", twelfth)
//                .append("cgpa", cgpa)
//                .append("codingLevel", codingLevel)
//                .append("goal", goal);
//
//        col.replaceOne(eq("studentId", studentId), doc,
//                new com.mongodb.client.model.ReplaceOptions().upsert(true));
//
//        client.close();
//
//        response.sendRedirect(request.getContextPath() + "/dashboard");
//    }
//
//    // ================= LOAD DASHBOARD =================
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("studentId") == null) {
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String studentId = (String) session.getAttribute("studentId");
//
//        MongoClient client = MongoClients.create("mongodb://localhost:27017");
//        MongoDatabase db = client.getDatabase("electiveDB");
//
//        MongoCollection<Document> col = db.getCollection("student_profile");
//        MongoCollection<Document> electiveCol = db.getCollection("electives");
//
//        // ===== Elective Count =====
//        long electiveCount = electiveCol.countDocuments();
//        request.setAttribute("electiveCount", electiveCount);
//
//        // ===== Fetch student profile =====
//        Document user = col.find(eq("studentId", studentId)).first();
//
//        int tenthVal = 0;
//        int twelfthVal = 0;
//        double cgpaVal = 0;
//
//        if (user != null) {
//
//            String tenthStr = user.getString("tenth");
//            String twelfthStr = user.getString("twelfth");
//            String cgpaStr = user.getString("cgpa");
//
//            // Safe parsing (avoid crash)
//            try {
//                if (tenthStr != null && !tenthStr.isEmpty())
//                    tenthVal = Integer.parseInt(tenthStr);
//            } catch (Exception ignored) {}
//
//            try {
//                if (twelfthStr != null && !twelfthStr.isEmpty())
//                    twelfthVal = Integer.parseInt(twelfthStr);
//            } catch (Exception ignored) {}
//
//            try {
//                if (cgpaStr != null && !cgpaStr.isEmpty())
//                    cgpaVal = Double.parseDouble(cgpaStr);
//            } catch (Exception ignored) {}
//
//            // Existing attributes (for form)
//            request.setAttribute("branch", user.getString("branch"));
//            request.setAttribute("semester", user.getString("semester"));
//            request.setAttribute("tenth", tenthStr);
//            request.setAttribute("twelfth", twelfthStr);
//            request.setAttribute("cgpa", cgpaStr);
//            request.setAttribute("codingLevel", user.getString("codingLevel"));
//            request.setAttribute("goal", user.getString("goal"));
//        }
//
//        // ===== Send numeric data for charts =====
//        request.setAttribute("tenthVal", tenthVal);
//        request.setAttribute("twelfthVal", twelfthVal);
//        request.setAttribute("cgpaVal", cgpaVal);
//
//        client.close();
//
//        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
//    }
//}

package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/dashboard")
public class DashBoardServlet extends HttpServlet {

    // ? SAVE FORM DATA
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Session check
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");

        //  Get form data (NORMAL FORM - NO multipart)
        String branch = request.getParameter("branch");
        String semester = request.getParameter("semester");
        String tenth = request.getParameter("tenth");
        String twelfth = request.getParameter("twelfth");
        String cgpa = request.getParameter("cgpa");
        String codingLevel = request.getParameter("codingLevel");
        String goal = request.getParameter("goal");

        //  MongoDB Connection
        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");
        MongoCollection<Document> col = db.getCollection("student_profile");

        //  Create document
        Document doc = new Document("studentId", studentId)
                .append("branch", branch)
                .append("semester", semester)
                .append("tenth", tenth)
                .append("twelfth", twelfth)
                .append("cgpa", cgpa)
                .append("codingLevel", codingLevel)
                .append("goal", goal);

        //  Insert / Update (Upsert)
        col.replaceOne(eq("studentId", studentId), doc,
                new com.mongodb.client.model.ReplaceOptions().upsert(true));

        client.close();

        //  Redirect back
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }


    //  LOAD DATA ON DASHBOARD
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");

        //  MongoDB fetch
        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");
        MongoCollection<Document> col = db.getCollection("student_profile");
        
MongoCollection<Document> electiveCol = db.getCollection("electives");
long electiveCount = electiveCol.countDocuments();


request.setAttribute("electiveCount", electiveCount);

        Document user = col.find(eq("studentId", studentId)).first();

        if (user != null) {
            request.setAttribute("branch", user.getString("branch"));
            request.setAttribute("semester", user.getString("semester"));
            request.setAttribute("tenth", user.getString("tenth"));
            request.setAttribute("twelfth", user.getString("twelfth"));
            request.setAttribute("cgpa", user.getString("cgpa"));
            request.setAttribute("codingLevel", user.getString("codingLevel"));
            request.setAttribute("goal", user.getString("goal"));
        }

        client.close();

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}