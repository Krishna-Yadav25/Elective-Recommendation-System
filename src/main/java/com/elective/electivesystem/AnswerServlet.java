/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.mongodb.client.*;
import org.bson.Document;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/answer")
public class AnswerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        //  GET studentId instead of id
        String studentId = request.getParameter("studentId");
        String answer = request.getParameter("answer");

        // safety check
        if (studentId == null || answer == null || answer.trim().isEmpty()) {
            response.sendRedirect("admin");
            return;
        }

        MongoClient client = MongoClients.create("mongodb://localhost:27017");

        try {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("queries");

            //  CREATE ADMIN MESSAGE
            Document message = new Document("sender", "admin")
                    .append("text", answer);

            // PUSH INTO messages ARRAY
            col.updateOne(
                    eq("studentId", studentId),
                    new Document("$push", new Document("messages", message))
            );
            // doPost() mein, col.updateOne() ke baad
NotificationServlet.push(studentId, "Admin replied to your query", "query");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            client.close();
        }

        //  Redirect back to queries section
        response.sendRedirect(request.getContextPath() + "/admin?action=queries");
    }
}