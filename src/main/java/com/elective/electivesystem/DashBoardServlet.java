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
import com.mongodb.client.model.ReplaceOptions;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/dashboard")
public class DashBoardServlet extends HttpServlet {

    // ── POST: Save form data 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");

        // Read form fields safely
        String branch      = nullSafe(request.getParameter("branch"));
        String semester    = nullSafe(request.getParameter("semester"));
        String tenth       = nullSafe(request.getParameter("tenth"));
        String twelfth     = nullSafe(request.getParameter("twelfth"));
        String cgpa        = nullSafe(request.getParameter("cgpa"));
        String codingLevel = nullSafe(request.getParameter("codingLevel"));
        String goal        = nullSafe(request.getParameter("goal"));
        String stream      = nullSafe(request.getParameter("stream"));

        // Save to MongoDB
        String mongoUri = System.getenv("MONGO_URI");
     
        try (MongoClient client =MongoClients.create(mongoUri)) {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("student_profile");

            Document doc = new Document("studentId",   studentId)
                    .append("branch",      branch)
                    .append("semester",    semester)
                    .append("tenth",       tenth)
                    .append("twelfth",     twelfth)
                    .append("cgpa",        cgpa)
                    .append("codingLevel", codingLevel)
                    .append("goal",        goal)
                    .append("stream",      stream);

            col.replaceOne(eq("studentId", studentId), doc,
                    new ReplaceOptions().upsert(true));

        } catch (Exception e) {
            e.printStackTrace();
            
            response.sendRedirect(request.getContextPath() + "/dashboard?error=true");
            return;
        }

        
        session.setAttribute("branch",      branch);
        session.setAttribute("semester",    semester);
        session.setAttribute("cgpa",        cgpa);
        session.setAttribute("codingLevel", codingLevel);
        session.setAttribute("goal",        goal);

        
        response.sendRedirect(request.getContextPath() + "/dashboard?saved=true");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
String mongoUri = System.getenv("MONGO_URI");
        try (MongoClient client =MongoClients.create(mongoUri)) {
            MongoDatabase db = client.getDatabase("electiveDB");

            // Load student profile
            MongoCollection<Document> col = db.getCollection("student_profile");
            Document user = col.find(eq("studentId", studentId)).first();

            if (user != null) {
                
                request.setAttribute("branch",      nullSafe(user.getString("branch")));
                request.setAttribute("semester",    nullSafe(user.getString("semester")));
                request.setAttribute("tenth",       nullSafe(user.getString("tenth")));
                request.setAttribute("twelfth",     nullSafe(user.getString("twelfth")));
                request.setAttribute("cgpa",        nullSafe(user.getString("cgpa")));
                request.setAttribute("codingLevel", nullSafe(user.getString("codingLevel")));
                request.setAttribute("goal",        nullSafe(user.getString("goal")));
                request.setAttribute("stream",      nullSafe(user.getString("stream")));

                // Also update session for stat cards
                session.setAttribute("cgpa",        nullSafe(user.getString("cgpa")));
                session.setAttribute("codingLevel", nullSafe(user.getString("codingLevel")));
                session.setAttribute("goal",        nullSafe(user.getString("goal")));
                session.setAttribute("branch",      nullSafe(user.getString("branch")));
                session.setAttribute("semester",    nullSafe(user.getString("semester")));
            }

            // Elective count for analytics / stats
            MongoCollection<Document> electiveCol = db.getCollection("electives");
            long electiveCount = electiveCol.countDocuments();
            request.setAttribute("electiveCount", electiveCount);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

   
    private String nullSafe(String val) {
        return val != null ? val.trim() : "";
    }
}