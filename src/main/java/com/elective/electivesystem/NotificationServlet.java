package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import com.mongodb.client.*;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.and;

/**
 * Handles marking notifications as read for a student.
 * Notifications are auto-created by other servlets
 * (AnswerServlet when admin replies, AnnouncementServlet when admin posts).
 *
 * POST /notification?action=markRead      — mark all as read for this student
 * POST /notification?action=markOne&id=X  — mark one as read
 */
@WebServlet("/notification")
public class NotificationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.setStatus(403);
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String action    = request.getParameter("action");

        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoCollection<Document> col =
                client.getDatabase("electiveDB").getCollection("notifications");

            if ("markRead".equals(action)) {
                // Mark ALL unread notifications for this student as read
                col.updateMany(
                    and(eq("studentId", studentId), eq("read", false)),
                    Updates.set("read", true)
                );
            } else if ("markOne".equals(action)) {
                String id = request.getParameter("id");
                if (id != null) {
                    col.updateOne(
                        eq("_id", new org.bson.types.ObjectId(id)),
                        Updates.set("read", true)
                    );
                }
            }

            client.close();
            response.setStatus(200);
            response.getWriter().write("ok");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        }
    }

    /**
     * Utility method — call this from other servlets to push a notification.
     * Usage:
     *   NotificationServlet.push(studentId, "Admin replied to your query", "query");
     */
    public static void push(String studentId, String message, String type) {
        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            MongoCollection<Document> col =
                client.getDatabase("electiveDB").getCollection("notifications");

            col.insertOne(new Document()
                .append("studentId", studentId)
                .append("message",   message)
                .append("type",      type)       // query | announcement | enrollment
                .append("read",      false)
                .append("timestamp", new java.util.Date().toString()));

            client.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}