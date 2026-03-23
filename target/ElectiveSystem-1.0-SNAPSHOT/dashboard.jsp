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
    String role = (String) session.getAttribute("role");

    if(name == null){
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="dashboard.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<!-- ================= TOP BAR ================= -->
<div class="topbar">
    <h2>Elective Recommendation System</h2>

    <div class="right-section">
        <span>Welcome, <%= name %> (<%= role %>)</span>

        <div class="menu-container">
            <button onclick="toggleMenu()">⋮</button>

            <div id="dropdown" class="dropdown">

                <% if("admin".equals(role)) { %>
                    <a href="admin.jsp">Admin Panel</a>
                <% } %>

                <a href="<%= request.getContextPath() %>/register.html">Register</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </div>
</div>

<!-- ================= MAIN ================= -->
<div class="main">

    <!-- PROFILE -->
    <div class="profile-card">
        <img src="images/default.jpeg" class="profile-pic">
        <h3><%= name %></h3>

        <% if("student".equals(role)) { %>
            <p>ID: <%= studentId %></p>
        <% } else { %>
            <p>Role: Admin</p>
        <% } %>

        <p>Course: B.Tech</p>
        <p>Branch: <%= request.getAttribute("branch") != null ? request.getAttribute("branch") : "CSE" %></p>
    </div>

    <!-- DASHBOARD -->
    <div class="dashboard">

        <!-- MENU -->
        <div class="menu">
            <button onclick="showSection('academic')">Academic</button>
            <button onclick="showSection('recommend')">Recommend</button>
            <button onclick="showSection('analytics')">Analytics</button>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- ===== ACADEMIC ===== -->
            <div id="academic" class="section active">
                <h3>Academic Details</h3>

                <form action="<%= request.getContextPath() %>/dashboard" method="post" enctype="multipart/form-data">

                    <input type="text" name="branch" placeholder="Branch" required>
                    <input type="text" name="semester" placeholder="Current Semester" required>

                    <input type="number" name="tenth" placeholder="10th %" required>
                    <input type="number" name="twelfth" placeholder="12th %" required>

                    <input type="number" step="0.01" name="cgpa" placeholder="CGPA" required>

                    <select name="codingLevel">
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                    </select>

                    <select name="goal">
                        <option value="Placement">Placement</option>
                        <option value="Higher Studies">Higher Studies</option>
                        <option value="Startup">Startup</option>
                    </select>

                    <input type="file" name="photo">

                    <button type="submit">Save</button>
                </form>
            </div>

            <!-- ===== RECOMMEND ===== -->
            <div id="recommend" class="section">
                <h3>Recommendation</h3>

                <form action="<%= request.getContextPath() %>/recommend" method="post">

                    <select name="interest" required>
                        <option value="">Select Interest</option>
                        <option value="AI">AI</option>
                        <option value="Web Development">Web Development</option>
                        <option value="Cyber Security">Cyber Security</option>
                        <option value="Data Science">Data Science</option>
                        <option value="Emerging Tech">Emerging Tech</option>
                    </select>

                    <input type="number" step="0.01" name="cgpa" placeholder="Enter CGPA" required>

                    <button type="submit">Get Top Electives</button>
                </form>
            </div>

            <!-- ===== ANALYTICS ===== -->
            <div id="analytics" class="section">
                <h3>📊 Student Analytics Dashboard</h3>

                <%
                    String cgpaStr = (String) request.getAttribute("cgpa");
                    String codingLevel = (String) request.getAttribute("codingLevel");
                    String goal = (String) request.getAttribute("goal");

                    if(cgpaStr == null) cgpaStr = "0";
                    if(codingLevel == null) codingLevel = "Beginner";
                    if(goal == null) goal = "N/A";
                %>

                <p><b>CGPA:</b> <%= cgpaStr %></p>
                <p><b>Goal:</b> <%= goal %></p>
                <p><b>Coding Level:</b> <%= codingLevel %></p>

                <!-- SMALL CHARTS -->
                <div style="display:flex; gap:30px; flex-wrap:wrap; justify-content:center;">

                    <div style="width:250px; height:250px;">
                        <canvas id="cgpaChart"></canvas>
                    </div>

                    <div style="width:250px; height:250px;">
                        <canvas id="codingChart"></canvas>
                    </div>

                    <div style="width:300px; height:300px;">
                        <canvas id="radarChart"></canvas>
                    </div>

                </div>
            </div>

        </div>
    </div>

</div>

<!-- ================= SCRIPT ================= -->
<script>

let cgpa = <%= request.getAttribute("cgpa") != null ? request.getAttribute("cgpa") : 0 %>;
let coding = "<%= request.getAttribute("codingLevel") != null ? request.getAttribute("codingLevel") : "Beginner" %>";

let codingScore = 2;
if(coding === "Intermediate") codingScore = 6;
if(coding === "Advanced") codingScore = 10;

// BAR
new Chart(document.getElementById("cgpaChart"), {
    type: 'bar',
    data: {
        labels: ["CGPA"],
        datasets: [{
            label: "Performance",
            data: [cgpa]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});

// DOUGHNUT
new Chart(document.getElementById("codingChart"), {
    type: 'doughnut',
    data: {
        labels: ["Skill", "Remaining"],
        datasets: [{
            data: [codingScore, 10 - codingScore]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});

// RADAR
new Chart(document.getElementById("radarChart"), {
    type: 'radar',
    data: {
        labels: ["Academics", "Coding", "Goal", "Consistency", "Growth"],
        datasets: [{
            label: "Profile",
            data: [
                cgpa,
                codingScore,
                cgpa > 8 ? 9 : 6,
                cgpa > 7 ? 8 : 5,
                codingScore + 2
            ]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});

</script>

<script src="dashboard.js"></script>

</body>
</html>