package com.elective.electivesystem;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import org.bson.Document;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/uploadPhoto")
@MultipartConfig
public class UploadPhotoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get uploaded file
       Part filePart = request.getPart("photo");


if (filePart == null || filePart.getSize() == 0 || filePart.getSubmittedFileName().isEmpty()) {
    response.sendRedirect("dashboard.jsp");
    return;
}

        // Generate unique filename
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        // Path to save image
        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";

        // Create folder if not exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Save file
        filePart.write(uploadPath + File.separator + fileName);

        // Get session
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        // MongoDB connection
        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("electiveDB");
        MongoCollection<Document> col = db.getCollection("users");

        // Update photo in DB
        col.updateOne(eq("studentId", studentId),
                new Document("$set", new Document("photo", fileName)));

        // Save photo in session
        session.setAttribute("photo", fileName);

        client.close();

        // Redirect back to dashboard
        response.sendRedirect("dashboard.jsp");
    }
}