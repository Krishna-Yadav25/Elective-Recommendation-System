package com.elective.electivesystem;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/openSwing")
public class OpenSwingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Open Swing UI in separate thread
        new Thread(() -> {
            new StudentInterestForm();
        }).start();

        // Redirect back to dashboard
        response.sendRedirect("dashboard");
    }
}