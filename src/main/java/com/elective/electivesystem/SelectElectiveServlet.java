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

@WebServlet("/selectElective")
public class SelectElectiveServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        String name = request.getParameter("name");
        String domain = request.getParameter("domain");

        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");

        MongoCollection<Document> col = db.getCollection("selected_electives");

        Document doc = new Document("studentId", studentId)
                .append("name", name)
                .append("domain", domain);

        col.insertOne(doc);   

        client.close();

        response.sendRedirect("dashboard");
    }
}