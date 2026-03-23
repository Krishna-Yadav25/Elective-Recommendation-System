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
//
//@WebServlet("/dashboard")
//public class DashBoardServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("studentId") == null) {
//            response.sendRedirect("index.html");
//            return;
//        }
//
//        String studentId = (String) session.getAttribute("studentId");
//
//        // get values (may be null)
//        String branch = request.getParameter("branch");
//        String semester = request.getParameter("semester");
//        String interest = request.getParameter("interest");
//
//        try {
//            MongoClient client = MongoClients.create("mongodb://localhost:27017");
//            MongoDatabase db = client.getDatabase("electiveDB");
//            MongoCollection<Document> col = db.getCollection("student_profile");
//
//            Document existing = col.find(new Document("studentId", studentId)).first();
//
//            if (existing == null) {
//                existing = new Document("studentId", studentId);
//            }
//
//            // update only non-null fields
//            if (branch != null) existing.append("branch", branch);
//            if (semester != null) existing.append("semester", semester);
//            if (interest != null) existing.append("interest", interest);
//
//            // delete old & insert updated
//            col.deleteMany(new Document("studentId", studentId));
//            col.insertOne(existing);
//
//            client.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//       response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
//    }
//}
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
//@MultipartConfig
//@WebServlet("/dashboard")
//public class DashBoardServlet extends HttpServlet {
//
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
//        
//        String branch = request.getParameter("branch");
//        String semester = request.getParameter("semester");
//        String tenth = request.getParameter("tenth");
//        String twelfth = request.getParameter("twelfth");
//        String cgpa = request.getParameter("cgpa");
//        String codingLevel = request.getParameter("codingLevel");
//        String goal = request.getParameter("goal");
//        //String interest = request.getParameter("interest");
//
//       
//        Part filePart = request.getPart("photo");
//        String fileName = filePart != null ? filePart.getSubmittedFileName() : null;
//
//        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
//        File uploadDir = new File(uploadPath);
//        if (!uploadDir.exists()) uploadDir.mkdir();
//
//        if (fileName != null && !fileName.isEmpty()) {
//            filePart.write(uploadPath + File.separator + fileName);
//            session.setAttribute("photo", fileName);
//        }
//
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
//                .append("goal", goal)
//                //.append("interest", interest)
//                .append("photo", fileName);
//
//        
//        col.replaceOne(eq("studentId", studentId), doc, new com.mongodb.client.model.ReplaceOptions().upsert(true));
//
//        response.sendRedirect("dashboard.jsp");
//    }
//}



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
//@MultipartConfig
//@WebServlet("/dashboard")
//public class DashBoardServlet extends HttpServlet {
//
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
//        
//        String branch = request.getParameter("branch");
//        String semester = request.getParameter("semester");
//        String tenth = request.getParameter("tenth");
//        String twelfth = request.getParameter("twelfth");
//        String cgpa = request.getParameter("cgpa");
//        String codingLevel = request.getParameter("codingLevel");
//        String goal = request.getParameter("goal");
//        //String interest = request.getParameter("interest");
//
//       
//        Part filePart = request.getPart("photo");
//        String fileName = filePart != null ? filePart.getSubmittedFileName() : null;
//
//        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
//        File uploadDir = new File(uploadPath);
//        if (!uploadDir.exists()) uploadDir.mkdir();
//
//        if (fileName != null && !fileName.isEmpty()) {
//            filePart.write(uploadPath + File.separator + fileName);
//            session.setAttribute("photo", fileName);
//        }
//
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
//                .append("goal", goal)
//                //.append("interest", interest)
//                .append("photo", fileName);
//
//        
//        col.replaceOne(eq("studentId", studentId), doc, new com.mongodb.client.model.ReplaceOptions().upsert(true));
//
//        response.sendRedirect(request.getContextPath() + "/dashboard");
//    }
//}


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
//@MultipartConfig
//@WebServlet("/dashboard")
//public class DashBoardServlet extends HttpServlet {
//
//   
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
//
//        String branch = request.getParameter("branch");
//        String semester = request.getParameter("semester");
//        String tenth = request.getParameter("tenth");
//        String twelfth = request.getParameter("twelfth");
//        String cgpa = request.getParameter("cgpa");
//        String codingLevel = request.getParameter("codingLevel");
//        String goal = request.getParameter("goal");
//
//        
//        Part filePart = request.getPart("photo");
//        String fileName = filePart != null ? filePart.getSubmittedFileName() : null;
//
//        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
//        File uploadDir = new File(uploadPath);
//        if (!uploadDir.exists()) uploadDir.mkdir();
//
//        if (fileName != null && !fileName.isEmpty()) {
//            filePart.write(uploadPath + File.separator + fileName);
//            session.setAttribute("photo", fileName);
//        }
//
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
//                .append("goal", goal)
//                .append("photo", fileName);
//
//        
//        col.replaceOne(eq("studentId", studentId), doc,
//                new com.mongodb.client.model.ReplaceOptions().upsert(true));
//
//        client.close();
//
//     
//        response.sendRedirect(request.getContextPath() + "/dashboard");
//    }
//
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//System.out.println("Servlet is running...");
//        HttpSession session = request.getSession(false);
//
//        if (session == null || session.getAttribute("studentId") == null) {
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String studentId = (String) session.getAttribute("studentId");
//
//       
//        MongoClient client = MongoClients.create("mongodb://localhost:27017");
//        MongoDatabase db = client.getDatabase("electiveDB");
//        MongoCollection<Document> col = db.getCollection("student_profile");
//
//        Document user = col.find(eq("studentId", studentId)).first();
//
//        if (user != null) {
//            request.setAttribute("branch", user.getString("branch"));
//            request.setAttribute("semester", user.getString("semester"));
//            request.setAttribute("cgpa", user.getString("cgpa"));
//            request.setAttribute("codingLevel", user.getString("codingLevel"));
//            request.setAttribute("goal", user.getString("goal"));
//            request.setAttribute("photo", user.getString("photo"));
//        }
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

@MultipartConfig
@WebServlet("/dashboard")
public class DashBoardServlet extends HttpServlet {

   
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");


        String branch = request.getParameter("branch");
        String semester = request.getParameter("semester");
        String tenth = request.getParameter("tenth");
        String twelfth = request.getParameter("twelfth");
        String cgpa = request.getParameter("cgpa");
        String codingLevel = request.getParameter("codingLevel");
        String goal = request.getParameter("goal");

        
        Part filePart = request.getPart("photo");
        String fileName = filePart != null ? filePart.getSubmittedFileName() : null;

        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        if (fileName != null && !fileName.isEmpty()) {
            filePart.write(uploadPath + File.separator + fileName);
            session.setAttribute("photo", fileName);
        }

        
        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");
        MongoCollection<Document> col = db.getCollection("student_profile");

        Document doc = new Document("studentId", studentId)
                .append("branch", branch)
                .append("semester", semester)
                .append("tenth", tenth)
                .append("twelfth", twelfth)
                .append("cgpa", cgpa)
                .append("codingLevel", codingLevel)
                .append("goal", goal)
                .append("photo", fileName);

        
        col.replaceOne(eq("studentId", studentId), doc,
                new com.mongodb.client.model.ReplaceOptions().upsert(true));

        client.close();

     
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
System.out.println("Servlet is running...");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");

       
        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");
        MongoCollection<Document> col = db.getCollection("student_profile");

        Document user = col.find(eq("studentId", studentId)).first();

        if (user != null) {
            request.setAttribute("branch", user.getString("branch"));
            request.setAttribute("semester", user.getString("semester"));
            request.setAttribute("cgpa", user.getString("cgpa"));
            request.setAttribute("codingLevel", user.getString("codingLevel"));
            request.setAttribute("goal", user.getString("goal"));
            request.setAttribute("photo", user.getString("photo"));
        }

        client.close();

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}