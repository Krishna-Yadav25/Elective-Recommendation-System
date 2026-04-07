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
//
//import java.util.ArrayList;
//
//import static com.mongodb.client.model.Filters.eq;
//
//@WebServlet("/admin")
//public class AdminServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || !"admin".equals(session.getAttribute("role"))) {
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String action = request.getParameter("action");
//
//        if (action == null) {
//            response.sendRedirect("admin.jsp");
//            return;
//        }
//
//        MongoClient client = MongoClients.create("mongodb://localhost:27017");
//
//        try {
//            MongoDatabase db = client.getDatabase("electiveDB");
//            MongoCollection<Document> col = db.getCollection("electives");
//
//            if ("add".equals(action)) {
//
//                String name = request.getParameter("name");
//                String category = request.getParameter("category");
//                String difficulty = request.getParameter("difficulty");
//
//                if (name == null || name.trim().isEmpty()) {
//                    response.sendRedirect("admin.jsp?error=empty");
//                    return;
//                }
//
//                Document doc = new Document("name", name)
//                        .append("category", category)
//                        .append("difficulty", difficulty);
//
//                col.insertOne(doc);
//
//            } else if ("delete".equals(action)) {
//
//                String name = request.getParameter("name");
//
//                if (name != null && !name.trim().isEmpty()) {
//                    col.deleteMany(eq("name", name));
//                }
//            }
//
//        } finally {
//            client.close();
//        }
//
//        response.sendRedirect(request.getContextPath() + "/admin");
//    }
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//
//        if (session == null || !"admin".equals(session.getAttribute("role"))) {
//            response.sendRedirect("index.jsp");
//            return;
//        }
//
//        String action = request.getParameter("action");
//
//        MongoClient client = MongoClients.create("mongodb://localhost:27017");
//
//        try {
//            MongoDatabase db = client.getDatabase("electiveDB");
//
//            if ("users".equals(action)) {
//
//                MongoCollection<Document> usersCol = db.getCollection("users");
//
//                request.setAttribute("users",
//                        usersCol.find()
//                                .sort(new Document("name", 1))
//                                .into(new ArrayList<>())
//                );
//
//                request.getRequestDispatcher("users.jsp").forward(request, response);
//                return;
//            }
//
//            MongoCollection<Document> col = db.getCollection("electives");
//
//            request.setAttribute("electives",
//                    col.find()
//                            .sort(new Document("name", 1))
//                            .into(new ArrayList<>())
//            );
//
//            request.getRequestDispatcher("admin.jsp").forward(request, response);
//
//        } finally {
//            client.close();
//        }
//    }
//}

package com.elective.electivesystem;

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

        MongoClient client = MongoClients.create("mongodb://localhost:27017");

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

        response.sendRedirect(request.getContextPath() + "/admin");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        MongoClient client = MongoClients.create("mongodb://localhost:27017");

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

            //  QUERIES (NEW ADD)
            MongoCollection<Document> queryCol = db.getCollection("queries");

            request.setAttribute("queries",
                    queryCol.find()
                            .sort(new Document("_id", -1))
                            .into(new ArrayList<>())
            );

            request.getRequestDispatcher("admin.jsp").forward(request, response);

        } finally {
            client.close();
        }
    }
}