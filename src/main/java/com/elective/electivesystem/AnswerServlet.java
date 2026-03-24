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
import org.bson.types.ObjectId;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.*;

@WebServlet("/answer")
public class AnswerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String id = request.getParameter("id");
        String answer = request.getParameter("answer");

        MongoClient client = MongoClients.create("mongodb://localhost:27017");

        try {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("queries");

            col.updateOne(
                    eq("_id", new ObjectId(id)),
                    combine(
                            set("answer", answer),
                            set("status", "answered")
                    )
            );

        } finally {
            client.close();
        }

        response.sendRedirect(request.getContextPath() + "/admin");
    }
}