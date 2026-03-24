<%-- 
    Document   : dashboard.jsp
    Created on : 19 Mar 2026, 8:38:57 pm
    Author     : krish
--%>
<!--
-->
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, org.bson.Document" %>

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

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<div class="topbar">
    <h2>Elective Recommendation System</h2>

    <div class="right-section">
        <span>Welcome, <%= name %> (<%= role %>)</span>

        <div class="menu-container">
            <button onclick="toggleMenu()">⋮</button>

            <div id="dropdown" class="dropdown">
                <% if ("admin".equals(role)) { %>
                    <a href="admin.jsp">Admin Panel</a>
                <% } %>
                <a href="logout">Logout</a>
            </div>
        </div>
    </div>
</div>

<div class="main">

    <div class="profile-card">
        <img src="images/default.jpeg" class="profile-pic">
        <h3><%= name %></h3>

        <% if ("student".equals(role)) { %>
            <p>ID: <%= studentId %></p>
        <% } else { %>
            <p>Role: Admin</p>
        <% } %>

        <p>Course: B.Tech</p>
        <p>Branch: CSE</p>
    </div>

    <div class="dashboard">

        <div class="menu">
            <button onclick="showSection('academic')">Academic</button>
            <button onclick="showSection('recommend')">Recommend</button>
            <button onclick="showSection('analytics')">Analytics</button>
            <button onclick="showSection('query')">Query</button>
            <button onclick="showSection('answers')">My Queries</button>
        </div>

        <div class="content">

            <div id="academic" class="section active">
                <h3>Academic Details</h3>

                <form action="dashboard" method="post" enctype="multipart/form-data">
                    <input type="text" name="branch" placeholder="Branch" required>
                    <input type="text" name="semester" placeholder="Semester" required>

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
                    </select>

                    <button type="submit">Save</button>
                </form>
            </div>

            <div id="recommend" class="section">
                <h3>Recommendation</h3>

                <form action="recommend" method="post">
                    <select name="interest" required>
                        <option value="">Select Interest</option>
                        <option value="AI">AI</option>
                        <option value="Web">Web</option>
                        <option value="Cyber">Cyber</option>
                        <option value="Data Science">Data Science</option>
                    </select>

                    <input type="number" step="0.01" name="cgpa" placeholder="Enter CGPA" required>

                    <button type="submit">Get Top Electives</button>
                </form>
            </div>

            <!-- 🔥 FIXED ANALYTICS SECTION -->
            <div id="analytics" class="section">
                <h3>Student Analytics</h3>

                <%
                    String cgpaStr = (String) request.getAttribute("cgpa");
                    String codingLevel = (String) request.getAttribute("codingLevel");

                    if(cgpaStr == null) cgpaStr = "0";
                    if(codingLevel == null) codingLevel = "Beginner";
                %>

                <p><b>CGPA:</b> <%= cgpaStr %></p>
                <p><b>Coding Level:</b> <%= codingLevel %></p>

                <div style="display:flex; gap:30px; flex-wrap:wrap; justify-content:center;">

                    <div style="width:250px;">
                        <canvas id="cgpaChart"></canvas>
                    </div>

                    <div style="width:250px;">
                        <canvas id="codingChart"></canvas>
                    </div>

                    <div style="width:300px;">
                        <canvas id="radarChart"></canvas>
                    </div>

                </div>
            </div>

            <div id="query" class="section">
                <h3>Ask Query</h3>

                <form action="query" method="post">
                    <textarea name="query" placeholder="Write your query..." required style="grid-column: span 2;"></textarea>
                    <button type="submit">Submit</button>
                </form>
            </div>

            <div id="answers" class="section">
                <h3>Your Queries</h3>

                <%
                    try {
                        com.mongodb.client.MongoClient client =
                                com.mongodb.client.MongoClients.create("mongodb://localhost:27017");

                        com.mongodb.client.MongoDatabase db =
                                client.getDatabase("electiveDB");

                        com.mongodb.client.MongoCollection<Document> col =
                                db.getCollection("queries");

                        List<Document> list =
                                col.find(new Document("studentId", studentId))
                                   .into(new ArrayList<>());

                        for(Document q : list){
                %>

                    <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px; border-radius:8px;">
                        <p><b>Q:</b> <%= q.getString("query") %></p>

                        <p><b>A:</b>
                            <%= q.getString("answer") != null ? q.getString("answer") : "Pending..." %>
                        </p>

                        <% if ("answered".equals(q.getString("status"))) { %>
                            <form action="satisfy" method="post">
                                <input type="hidden" name="id" value="<%= q.getObjectId("_id") %>">

                                <button name="status" value="yes">Satisfied</button>
                                <button name="status" value="no">Not Satisfied</button>
                            </form>
                        <% } %>
                    </div>

                <%
                        }
                        client.close();
                    } catch(Exception e){
                        out.println("Error loading queries");
                    }
                %>
            </div>

        </div>
    </div>

</div>

<script>

function showSection(id) {
    document.querySelectorAll(".section").forEach(sec => {
        sec.classList.remove("active");
    });
    document.getElementById(id).classList.add("active");
}

function toggleMenu() {
    let dropdown = document.getElementById("dropdown");
    dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
}

document.addEventListener("DOMContentLoaded", function () {

    let cgpa = <%= request.getAttribute("cgpa") != null ? request.getAttribute("cgpa") : 0 %>;
    let coding = "<%= request.getAttribute("codingLevel") != null ? request.getAttribute("codingLevel") : "Beginner" %>";

    let codingScore = 3;
    if (coding === "Intermediate") codingScore = 6;
    if (coding === "Advanced") codingScore = 9;

    new Chart(document.getElementById("cgpaChart"), {
        type: 'bar',
        data: {
            labels: ["CGPA"],
            datasets: [{
                data: [cgpa]
            }]
        }
    });

    new Chart(document.getElementById("codingChart"), {
        type: 'doughnut',
        data: {
            labels: ["Skill", "Remaining"],
            datasets: [{
                data: [codingScore, 10 - codingScore]
            }]
        }
    });

    new Chart(document.getElementById("radarChart"), {
        type: 'radar',
        data: {
            labels: ["Academics", "Coding", "Goal", "Consistency", "Growth"],
            datasets: [{
                data: [cgpa, codingScore, 8, 7, 9]
            }]
        }
    });

});
</script>

</body>
</html>