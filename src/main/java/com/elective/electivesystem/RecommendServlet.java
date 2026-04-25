/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


package com.elective.electivesystem;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;

@WebServlet("/recommend")
public class RecommendServlet extends HttpServlet {

    // Elective Class
    class Elective {
        String name;
        String category;
        int difficulty;

        Elective(String name, String category, int difficulty) {
            this.name = name;
            this.category = category;
            this.difficulty = difficulty;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ==========================
            // 1. GET FORM DATA
            // ==========================
            String interest = request.getParameter("interest");
            double cgpa = Double.parseDouble(request.getParameter("cgpa"));

            HttpSession session = request.getSession();
            String studentId = (String) session.getAttribute("studentId");

            // ==========================
            // 2. FETCH SWING DATA (MongoDB)
            // ==========================
            String swingInterests = "";
            String goal = "";
            String frequency = "";

            MongoClient client = MongoClients.create("mongodb+srv://yadavkkrishna005_db_user:08IqQu4F1dUXlkao@cluster0.wfbiz1o.mongodb.net/electiveDB?appName=Cluster0");
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("codingProfiles");

            Document profile = col.find(eq("studentId", studentId)).first();

            if (profile != null) {
                swingInterests = profile.getString("interests");
                goal = profile.getString("goal");
                frequency = profile.getString("frequency");
            }

            // ==========================
            // 3. ELECTIVE LIST
            // ==========================
            List<Elective> electives = new ArrayList<>();

            electives.add(new Elective("Fundamentals of Computer Vision and AI", "AI", 10));
            electives.add(new Elective("Machine Learning", "AI", 10));
            electives.add(new Elective("Linear Algebra", "AI", 7));

            electives.add(new Elective("Statistical Data Analysis using R", "Data Science", 9));
            electives.add(new Elective("Big Data Analytics", "Data Science", 9));

            electives.add(new Elective("Foundation of Cyber Security", "Cyber Security", 8));
            electives.add(new Elective("Ethical Hacking", "Cyber Security", 9));

            electives.add(new Elective("Virtualization and Cloud Computing", "Web Development", 8));
            electives.add(new Elective("DevOps", "Web Development", 8));

            electives.add(new Elective("Blockchain and its Applications", "Emerging Tech", 9));
            electives.add(new Elective("Internet of Things (IoT)", "Emerging Tech", 7));

            // ==========================
            // 4. SCORE BASED LOGIC 
            // ==========================
            Map<Elective, Integer> scoreMap = new HashMap<>();

            for (Elective e : electives) {
                int score = 0;

                // Interest match (highest weight)
                if (e.category.equalsIgnoreCase(interest)) {
                    score += 5;
                }

                // Swing interests
                if (swingInterests != null && swingInterests.contains(e.category)) {
                    score += 3;
                }

                // Goal based
                if ("Placement".equalsIgnoreCase(goal)) {
                    if (e.category.equalsIgnoreCase("AI") || e.name.contains("Data")) {
                        score += 4;
                    }
                }

                if ("Projects".equalsIgnoreCase(goal)) {
                    if (e.category.equalsIgnoreCase("Web Development")) {
                        score += 4;
                    }
                }

                // CGPA vs Difficulty
                if (cgpa >= 8.5 && e.difficulty >= 8) {
                    score += 3;
                } else if (cgpa < 7 && e.difficulty <= 7) {
                    score += 3;
                }

                // Activity level
                if ("Rarely".equalsIgnoreCase(frequency) && e.difficulty <= 7) {
                    score += 2;
                }

                scoreMap.put(e, score);
            }

            // ==========================
            // 5. SORT BY SCORE
            // ==========================
            List<Elective> finalList = new ArrayList<>(scoreMap.keySet());

            Collections.sort(finalList, (a, b) -> scoreMap.get(b) - scoreMap.get(a));

            // ==========================
            // 6. TOP 3 RESULTS
            // ==========================
            List<String> result = new ArrayList<>();

            for (int i = 0; i < Math.min(3, finalList.size()); i++) {
                result.add(finalList.get(i).name);
            }

            // ==========================
            // 7. SEND TO JSP
            // ==========================
            request.setAttribute("recommendations", result);
            request.setAttribute("goal", goal);
            request.setAttribute("frequency", frequency);

            request.getRequestDispatcher("recommend.jsp").forward(request, response);

            client.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error in recommendation module");
        }
    }
}