<%-- 
    Document   : dashboard.jsp
    Created on : 19 Mar 2026, 8:38:57 pm
    Author     : krish
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.servlet.http.*" %>

<%
    String name = (String) session.getAttribute("name");
    String studentId = (String) session.getAttribute("studentId");

    if(name == null){
        response.sendRedirect("index.jsp");   // FIXED
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="dashboard.css?v=3">
</head>

<body>

<!-- ================= TOP BAR ================= -->
<div class="topbar">
    <h2>Elective Recommendation System</h2>

    <div class="right-section">
        <span>Welcome, <%= name %></span>

        <!-- 3 DOT MENU -->
        <div class="menu-container">
            <button onclick="toggleMenu()">⋮</button>

            <div id="dropdown" class="dropdown">
                <a href="<%= request.getContextPath() %>/register.html">Register</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </div>
</div>

<!-- ================= MAIN ================= -->
<div class="main">

    <!-- ===== PROFILE CARD ===== -->
    <div class="profile-card">
        <img src="images/default.jpeg" class="profile-pic">
        <h3><%= name %></h3>
        <p>ID: <%= studentId %></p>
        <p>Course: B.Tech</p>
        <p>Branch: CSE</p>
    </div>

    <!-- ===== DASHBOARD CONTENT ===== -->
    <div class="dashboard">

        <!-- MENU -->
        <div class="menu">
            <button onclick="showSection('academic')">Academic</button>
            <button onclick="showSection('interest')">Interest</button>
            <button onclick="showSection('recommend')">Recommend</button>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- ================= ACADEMIC ================= -->
            <div id="academic" class="section active">
                <h3>Academic Details</h3>

                <form action="<%= request.getContextPath() %>/dashboard" method="post" enctype="multipart/form-data">

                    <input type="text" name="branch" placeholder="Branch" required>
                    <input type="text" name="semester" placeholder="Current Semester" required>

                    <input type="number" name="tenth" placeholder="10th %" required>
                    <input type="number" name="twelfth" placeholder="12th %" required>

                    <input type="number" step="0.01" name="cgpa" placeholder="CGPA" required>

                    <select name="codingLevel">
                        <option>Beginner</option>
                        <option>Intermediate</option>
                        <option>Advanced</option>
                    </select>

                    <select name="goal">
                        <option>Placement</option>
                        <option>Higher Studies</option>
                        <option>Startup</option>
                    </select>

                    <input type="file" name="photo">

                    <button type="submit">Save</button>
                </form>
            </div>

            <!-- ================= INTEREST ================= -->
            <div id="interest" class="section">
                <h3>Interest</h3>

                <form action="<%= request.getContextPath() %>/dashboard" method="post">

                    <select name="interest" required>
                        <option value="">Select Interest</option>
                        <option>AI</option>
                        <option>Web Development</option>
                        <option>Cyber Security</option>
                        <option>Data Science</option>
                        <option>Mobile App Development</option>
                        <option>Cloud Computing</option>
                        <option>Game Development</option>
                        <option>Blockchain Development</option>
                    </select>

                    <button type="submit">Save</button>
                </form>
            </div>

            <!-- ================= RECOMMEND ================= -->
            <div id="recommend" class="section">
                <h3>Recommendation</h3>

                <!-- ✅ FIXED: NOW PASSING DATA -->
                <form action="<%= request.getContextPath() %>/recommend" method="post">

                    <!-- Interest -->
                    <select name="interest" required>
                        <option value="">Select Interest</option>
                        <option>AI</option>
                        <option>Web Development</option>
                        <option>Cyber Security</option>
                        <option>Data Science</option>
                        <option>Emerging Tech</option>
                    </select>

                    <!-- CGPA -->
                    <input type="number" step="0.01" name="cgpa" placeholder="Enter CGPA" required>

                    <button type="submit">Get Top Electives</button>
                </form>
            </div>

        </div>

    </div>

</div>

<script src="dashboard.js?v=3"></script>

</body>
</html>