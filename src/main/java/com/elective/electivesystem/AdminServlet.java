/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.mongodb.client.*;
import org.bson.Document;

import java.util.ArrayList;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

      String mongoUri = System.getenv("MONGO_URI");
      MongoClient client = MongoClients.create(mongoUri);

        try {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("electives");

            if ("add".equals(action)) {

                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String difficulty = request.getParameter("difficulty");

                if (name == null || name.trim().isEmpty()) {
                    response.sendRedirect("admin.jsp?error=empty");
                    return;
                }

                Document doc = new Document("name", name)
                        .append("category", category)
                        .append("difficulty", difficulty);

                col.insertOne(doc);

            } else if ("delete".equals(action)) {

                String name = request.getParameter("name");

                if (name != null && !name.trim().isEmpty()) {
                    col.deleteMany(eq("name", name));
                }
            }

        } finally {
            client.close();
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=list");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "load";
        }

      String mongoUri = System.getenv("MONGO_URI");
      MongoClient client = MongoClients.create(mongoUri);

        try {
            MongoDatabase db = client.getDatabase("electiveDB");

            // USERS
            if ("users".equals(action)) {

                MongoCollection<Document> usersCol = db.getCollection("users");

                request.setAttribute("users",
                        usersCol.find()
                                .sort(new Document("name", 1))
                                .into(new ArrayList<>())
                );

                request.setAttribute("action", "users");
                request.getRequestDispatcher("admin.jsp").forward(request, response);
                return;
            }

            // ELECTIVES
            MongoCollection<Document> electivesCol = db.getCollection("electives");

            request.setAttribute("electives",
                    electivesCol.find()
                            .sort(new Document("name", 1))
                            .into(new ArrayList<>())
            );

            request.setAttribute("totalElectives", electivesCol.countDocuments());

            // QUERIES
            MongoCollection<Document> queryCol = db.getCollection("queries");

            request.setAttribute("queries",
                    queryCol.find()
                            .sort(new Document("_id", -1))
                            .into(new ArrayList<>())
            );

            request.setAttribute("action", action);

            request.getRequestDispatcher("admin.jsp").forward(request, response);

        } finally {
            client.close();
        }
    }
}