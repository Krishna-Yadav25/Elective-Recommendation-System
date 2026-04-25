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

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;

@WebServlet("/satisfy")
public class SatisfyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get studentId from session
        HttpSession session = request.getSession(false);
        String studentId = (String) session.getAttribute("studentId");

        String status = request.getParameter("status");

        MongoClient client = MongoClients.create("mongodb+srv://yadavkkrishna005_db_user:08IqQu4F1dUXlkao@cluster0.wfbiz1o.mongodb.net/electiveDB?appName=Cluster0");

        try {
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("queries");

            //  Update using studentId
            col.updateOne(
                    eq("studentId", studentId),
                    set("satisfaction", status)
            );

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            client.close();
        }

        //  redirect back to queries section
        response.sendRedirect("dashboard.jsp?section=queries");
    }
}