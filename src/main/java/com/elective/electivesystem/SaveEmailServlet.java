package com.elective.electivesystem;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/save-email")
public class SaveEmailServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String email = request.getParameter("email").trim();

        if (email.isEmpty()) {
            request.setAttribute("error", "Email cannot be empty.");
            request.getRequestDispatcher("add-email.jsp").forward(request, response);
            return;
        }
            String mongoUri=System.getenv("MONGO_URI");
           
        try (MongoClient client =MongoClients.create(mongoUri)) {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("users");

            // Check if email already used by another student
            Document existing = col.find(eq("email", email)).first();
            if (existing != null && !existing.getString("studentId").equals(studentId)) {
                request.setAttribute("error", "This email is already linked to another account.");
                request.getRequestDispatcher("add-email.jsp").forward(request, response);
                return;
            }

            // Save email to this student's document
            col.updateOne(eq("studentId", studentId),
                new Document("$set", new Document("email", email)));

            // Also save in session
            session.setAttribute("email", email);

            // Continue to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Try again.");
            request.getRequestDispatcher("add-email.jsp").forward(request, response);
        }
    }
}