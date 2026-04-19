package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import com.mongodb.client.*;
import org.bson.Document;

@WebServlet("/announcement")
public class AnnouncementServlet extends HttpServlet {

    // Admin posts a new announcement
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String title   = request.getParameter("title");
        String message = request.getParameter("message");
        String type    = request.getParameter("type");   // info | warning | success

        if (title == null || title.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            response.sendRedirect("admin.jsp?error=true");
            return;
        }

        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase db   = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("announcements");

            Document ann = new Document()
                .append("title",     title.trim())
                .append("message",   message.trim())
                .append("type",      type != null ? type : "info")
                .append("postedBy",  (String) session.getAttribute("name"))
                .append("timestamp", new java.util.Date().toString())
                .append("active",    true);

            col.insertOne(ann);
            client.close();

            response.sendRedirect("admin.jsp?saved=true&section=announce");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
        }
    }

    // Admin deletes an announcement
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(403);
            return;
        }

        String id = request.getParameter("id");
        if (id == null) { response.setStatus(400); return; }

        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            client.getDatabase("electiveDB")
                  .getCollection("announcements")
                  .deleteOne(new Document("_id", new org.bson.types.ObjectId(id)));
            client.close();
            response.setStatus(200);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        }
    }
}