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

@WebServlet("/query")
public class QueryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String queryText = request.getParameter("query");

        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");
        MongoCollection<Document> col = db.getCollection("queries");

        Document doc = new Document("studentId", studentId)
                .append("query", queryText)
                .append("answer", null)
                .append("status", "pending");

        col.insertOne(doc);

        client.close();

        response.sendRedirect("dashboard.jsp");
    }
}