package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import com.mongodb.client.*;
import org.bson.Document;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId    = (String) session.getAttribute("studentId");
        String studentName  = (String) session.getAttribute("name");
        String electiveName = request.getParameter("electiveName");
        String rating       = request.getParameter("rating");
        String comment      = request.getParameter("comment");

        // Basic validation
        if (electiveName == null || electiveName.trim().isEmpty() ||
            rating == null       || rating.trim().isEmpty()) {
            response.sendRedirect("dashboard?error=true");
            return;
        }

        try {
            String mongoUri=System.getenv("MONGO_URI");
            MongoClient client =MongoClients.create(mongoUri);
            MongoDatabase db   = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("feedback");

            Document feedback = new Document()
                .append("studentId",    studentId)
                .append("studentName",  studentName)
                .append("electiveName", electiveName.trim())
                .append("rating",       Integer.parseInt(rating))
                .append("comment",      comment != null ? comment.trim() : "")
                .append("timestamp",    new java.util.Date().toString());

            col.insertOne(feedback);
            client.close();

            response.sendRedirect("dashboard?saved=true&section=feedback");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=true");
        }
    }
}
