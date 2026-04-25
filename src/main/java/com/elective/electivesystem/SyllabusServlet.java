package com.elective.electivesystem;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;
import com.mongodb.client.model.Updates;

@WebServlet("/syllabus")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 10 * 1024 * 1024,
    maxRequestSize    = 20 * 1024 * 1024
)
public class SyllabusServlet extends HttpServlet {

   
    private static final String UPLOAD_FOLDER = "C:/ElectiveUploads/syllabi";

    @Override
    public void init() throws ServletException {
        File dir = new File(UPLOAD_FOLDER);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        System.out.println("========================================");
        System.out.println("[SyllabusServlet] Upload folder: " + UPLOAD_FOLDER);
        System.out.println("[SyllabusServlet] Folder exists: " + dir.exists());
        System.out.println("[SyllabusServlet] Writable:      " + dir.canWrite());
        System.out.println("========================================");
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String electiveName = request.getParameter("electiveName");
        if (electiveName == null || electiveName.trim().isEmpty()) {
            response.sendRedirect("admin.jsp?error=true");
            return;
        }

        Part filePart = request.getPart("syllabusFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("admin.jsp?error=true");
            return;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.equalsIgnoreCase("application/pdf")) {
            response.sendRedirect("admin.jsp?error=notpdf");
            return;
        }

        
        String slug     = electiveName.trim().toLowerCase().replaceAll("[^a-z0-9]+", "_");
        String fileName = slug + ".pdf";
        String filePath = UPLOAD_FOLDER + File.separator + fileName;

        System.out.println("[SyllabusServlet] Saving to: " + filePath);

        
        new File(UPLOAD_FOLDER).mkdirs();

       
        filePart.write(filePath);

     
        File saved = new File(filePath);
        if (!saved.exists() || saved.length() == 0) {
            System.err.println("[SyllabusServlet] FAILED to save file at: " + filePath);
            response.sendRedirect("admin.jsp?error=true");
            return;
        }

        System.out.println("[SyllabusServlet] Saved OK — " + saved.length() + " bytes");

      
        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            client.getDatabase("electiveDB")
                  .getCollection("electives")
                  .updateOne(
                      eq("name", electiveName.trim()),
                      Updates.set("syllabusFile", fileName)
                  );
            client.close();
            System.out.println("[SyllabusServlet] MongoDB updated: " + electiveName + " → " + fileName);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin.jsp?saved=true&section=syllabus");
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("name") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String electiveName = request.getParameter("electiveName");
        if (electiveName == null || electiveName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Elective name missing");
            return;
        }

        
        String fileName = null;
        try {
            MongoClient client = MongoClients.create("mongodb://localhost:27017");
            Document doc = client.getDatabase("electiveDB")
                                 .getCollection("electives")
                                 .find(eq("name", electiveName.trim()))
                                 .first();
            if (doc != null) fileName = doc.getString("syllabusFile");
            client.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Syllabus not uploaded yet");
            return;
        }

        String filePath = UPLOAD_FOLDER + File.separator + fileName;
        File   pdfFile  = new File(filePath);

        System.out.println("[SyllabusServlet] Requested: " + filePath);
        System.out.println("[SyllabusServlet] Exists:    " + pdfFile.exists());

        if (!pdfFile.exists()) {
            System.err.println("[SyllabusServlet] File missing! folder=" + UPLOAD_FOLDER);
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                "Syllabus file not found on server. Please re-upload from admin panel.");
            return;
        }

      
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        response.setContentLengthLong(pdfFile.length());

        try (FileInputStream fis = new FileInputStream(pdfFile);
             OutputStream    os  = response.getOutputStream()) {
            byte[] buf = new byte[8192];
            int    n;
            while ((n = fis.read(buf)) != -1) os.write(buf, 0, n);
            os.flush();
        }
    }
}