/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
//package com.elective.electivesystem;
//
//import java.io.*;
//import java.util.*;
//import javax.servlet.*;
//import javax.servlet.http.*;
//import javax.servlet.annotation.WebServlet;
//
//@WebServlet("/recommend")
//public class RecommendServlet extends HttpServlet {
//
//    
//    class Elective {
//        String name;
//        String category;
//        int difficulty;
//
//        Elective(String name, String category, int difficulty) {
//            this.name = name;
//            this.category = category;
//            this.difficulty = difficulty;
//        }
//    }
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        try {
//
//            
//            String interest = request.getParameter("interest");
//            double cgpa = Double.parseDouble(request.getParameter("cgpa"));
//
//            
//            List<Elective> electives = new ArrayList<>();
//
//          
//            electives.add(new Elective("Fundamentals of Computer Vision and AI", "AI", 10));
//            electives.add(new Elective("Machine Learning", "AI", 10));
//            electives.add(new Elective("Linear Algebra", "AI", 7));
//
//            
//            electives.add(new Elective("Statistical Data Analysis using R", "Data Science", 9));
//            electives.add(new Elective("Big Data Analytics", "Data Science", 9));
//
//            
//            electives.add(new Elective("Foundation of Cyber Security", "Cyber Security", 8));
//            electives.add(new Elective("Ethical Hacking", "Cyber Security", 9));
//
//            
//            electives.add(new Elective("Virtualization and Cloud Computing", "Web Development", 8));
//            electives.add(new Elective("DevOps", "Web Development", 8));
//
//           
//            electives.add(new Elective("Blockchain and its Applications", "Emerging Tech", 9));
//            electives.add(new Elective("Internet of Things (IoT)", "Emerging Tech", 7));
//
//            
//            List<Elective> filtered = new ArrayList<>();
//
//            for (Elective e : electives) {
//
//              
//                if (e.category.equalsIgnoreCase(interest)) {
//                    filtered.add(e);
//                }
//
//                
//                if ((interest.equalsIgnoreCase("AI") || interest.equalsIgnoreCase("Data Science"))
//                        && e.name.contains("Linear Algebra")) {
//                    filtered.add(e);
//                }
//
//                
//                if (cgpa >= 8.5 && e.difficulty >= 9) {
//                    filtered.add(e);
//                }
//
//              
//                if (cgpa < 7 && e.difficulty <= 7) {
//                    filtered.add(e);
//                }
//            }
//
//           
//            Set<String> unique = new HashSet<>();
//            List<Elective> finalList = new ArrayList<>();
//
//            for (Elective e : filtered) {
//                if (!unique.contains(e.name)) {
//                    unique.add(e.name);
//                    finalList.add(e);
//                }
//            }
//
//            
//            Collections.sort(finalList, (a, b) -> b.difficulty - a.difficulty);
//
//            
//            List<String> result = new ArrayList<>();
//
//            for (int i = 0; i < Math.min(3, finalList.size()); i++) {
//                result.add(finalList.get(i).name);
//            }
//
//         
//            request.setAttribute("recommendations", result);
//            request.getRequestDispatcher("recommend.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.getWriter().println("Error in recommendation module");
//        }
//    }
//}



package com.elective.electivesystem;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/recommend")
public class RecommendServlet extends HttpServlet {

    
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

            
            String interest = request.getParameter("interest");
            double cgpa = Double.parseDouble(request.getParameter("cgpa"));

            
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

            
            List<Elective> filtered = new ArrayList<>();

            for (Elective e : electives) {

              
                if (e.category.equalsIgnoreCase(interest)) {
                    filtered.add(e);
                }

                
                if ((interest.equalsIgnoreCase("AI") || interest.equalsIgnoreCase("Data Science"))
                        && e.name.contains("Linear Algebra")) {
                    filtered.add(e);
                }

                
                if (cgpa >= 8.5 && e.difficulty >= 9) {
                    filtered.add(e);
                }

              
                if (cgpa < 7 && e.difficulty <= 7) {
                    filtered.add(e);
                }
            }

           
            Set<String> unique = new HashSet<>();
            List<Elective> finalList = new ArrayList<>();

            for (Elective e : filtered) {
                if (!unique.contains(e.name)) {
                    unique.add(e.name);
                    finalList.add(e);
                }
            }

            
            Collections.sort(finalList, (a, b) -> b.difficulty - a.difficulty);

            
            List<String> result = new ArrayList<>();

            for (int i = 0; i < Math.min(3, finalList.size()); i++) {
                result.add(finalList.get(i).name);
            }

         
            request.setAttribute("recommendations", result);
            request.getRequestDispatcher("recommend.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error in recommendation module");
        }
    }
}