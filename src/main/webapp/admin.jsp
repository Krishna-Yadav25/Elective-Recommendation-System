<%-- 
    Document   : admin
    Created on : 23 Mar 2026, 3:42:21 pm
    Author     : krish
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, org.bson.Document" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="dashboard.css">
</head>

<body>

<div class="topbar">

    <div>
        <h2 style="margin:0; font-size:28px;">Elective Recommendation System</h2>
        <small style="font-size:16px;">Admin Panel</small>
    </div>

    <div class="right-section">
        <span>Welcome, <%= session.getAttribute("name") %></span>

        <div class="menu-container">
            <button onclick="toggleMenu()">⋮</button>

            <div id="dropdown" class="dropdown">
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </div>

</div>

<div class="main">

    <div class="profile-card">
        <h3>Admin</h3>
        <p><%= session.getAttribute("name") %></p>
    </div>

    <div class="dashboard">

        <div class="menu">
            <button onclick="showSection('add')">Add</button>
            <button onclick="showSection('delete')">Delete</button>
            <button onclick="showSection('list')">Electives</button>
            <button onclick="showSection('users')">Users</button>
            <button onclick="showSection('queries')">Queries</button>
            <button onclick="showSection('analytics')">Analytics</button>
        </div>

        <div class="content">

            <!-- ADD -->
            <div id="add" class="section active">
                <h3>Add Elective</h3>
                <form action="admin" method="post">
                    <input type="hidden" name="action" value="add">

                    <input type="text" name="name" placeholder="Elective Name" required>

                    <select name="category">
                        <option>AI</option>
                        <option>Web</option>
                        <option>Cyber</option>
                        <option>Data Science</option>
                    </select>

                    <select name="difficulty">
                        <option>Easy</option>
                        <option>Medium</option>
                        <option>Hard</option>
                    </select>

                    <button>Add</button>
                </form>
            </div>

            <!-- DELETE -->
            <div id="delete" class="section">
                <h3>Delete Elective</h3>
                <form action="admin" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="text" name="name" placeholder="Elective Name" required>
                    <button>Delete</button>
                </form>
            </div>

            <!-- ELECTIVES -->
            <div id="list" class="section">
                <h3>All Electives</h3>

                <%
                    List<Document> electives = (List<Document>) request.getAttribute("electives");

                    if (electives != null) {
                        for (Document e : electives) {
                %>
                    <p>
                        <b><%= e.getString("name") %></b> |
                        <%= e.getString("category") %> |
                        <%= e.getString("difficulty") %>
                    </p>
                <%
                        }
                    }
                %>
            </div>

            <!-- USERS (UPDATED 🔥) -->
            <div id="users" class="section">
                <h3>Users</h3>

                <form action="admin" method="get">
                    <input type="hidden" name="action" value="users">
                    <button>Load Users</button>
                </form>

                <%
                    List<Document> users = (List<Document>) request.getAttribute("users");

                    if(users != null && !users.isEmpty()){
                %>

                <table style="width:100%; margin-top:15px; border-collapse: collapse;">
                    <tr style="background:#0072ff; color:white;">
                        <th style="padding:10px;">Name</th>
                        <th style="padding:10px;">Student ID</th>
                        <th style="padding:10px;">Role</th>
                    </tr>

                    <%
                        for(Document u : users){
                    %>
                    <tr style="text-align:center; border-bottom:1px solid #ddd;">
                        <td style="padding:10px;"><%= u.getString("name") %></td>
                        <td style="padding:10px;">
                            <%= u.getString("studentId") != null ? u.getString("studentId") : "-" %>
                        </td>
                        <td style="padding:10px;">
                            <%= u.getString("role") != null ? u.getString("role") : "student" %>
                        </td>
                    </tr>
                    <%
                        }
                    %>

                </table>

                <%
                    }
                %>
            </div>

            <!-- QUERIES -->
            <div id="queries" class="section">
                <h3>Student Queries</h3>

                <%
                    try {
                        com.mongodb.client.MongoClient client =
                                com.mongodb.client.MongoClients.create("mongodb://localhost:27017");

                        com.mongodb.client.MongoDatabase db =
                                client.getDatabase("electiveDB");

                        com.mongodb.client.MongoCollection<Document> col =
                                db.getCollection("queries");

                        List<Document> list =
                                col.find().into(new ArrayList<>());

                        for(Document q : list){
                %>

                <div style="border:1px solid #ccc; padding:12px; margin-bottom:12px; border-radius:10px;">
                    <p><b>Student:</b> <%= q.getString("studentId") %></p>
                    <p><b>Query:</b> <%= q.getString("query") %></p>

                    <p><b>Answer:</b>
                        <%= q.getString("answer") != null ? q.getString("answer") : "Not answered yet" %>
                    </p>

                    <% if (q.getString("answer") == null) { %>

                    <form action="answer" method="post">
                        <input type="hidden" name="id" value="<%= q.getObjectId("_id") %>">
                        <input type="text" name="answer" placeholder="Write answer..." required>
                        <button type="submit">Submit Answer</button>
                    </form>

                    <% } else { %>

                        <p><b>Status:</b> <%= q.getString("satisfaction") != null ? q.getString("satisfaction") : "Waiting..." %></p>

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

            <!-- ANALYTICS -->
            <div id="analytics" class="section">
    <h3>Analytics</h3>

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

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
window.onload = function () {

    let cgpa = 8;
    let codingScore = 7;

    // BAR
    new Chart(document.getElementById("cgpaChart"), {
        type: 'bar',
        data: {
            labels: ["CGPA"],
            datasets: [{
                label: "CGPA",
                data: [cgpa]
            }]
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
                    9,
                    7,
                    8
                ]
            }]
        }
    });

};
</script>

</body>
</html>