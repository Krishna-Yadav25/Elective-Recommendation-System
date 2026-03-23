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
    
    <!-- LEFT SIDE -->
    <div>
        <h2 style="margin:0;">Elective Recommendation System</h2>
        <small style="opacity:0.9;">Admin Panel</small>
    </div>

    <!-- RIGHT SIDE -->
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

        <!-- MENU -->
        <div class="menu">
            <button onclick="showSection('add')">Add</button>
            <button onclick="showSection('delete')">Delete</button>
            <button onclick="showSection('list')">Electives</button>
            <button onclick="showSection('users')">Users</button>
            <button onclick="showSection('analytics')">Analytics</button>
        </div>

        <!-- CONTENT -->
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

            <!-- 🔥 ELECTIVES LIST (ADDED HERE) -->
            <div id="list" class="section">
                <h3>All Electives</h3>

                <%
                    List<org.bson.Document> electives =
                        (List<org.bson.Document>) request.getAttribute("electives");

                    if (electives != null && !electives.isEmpty()) {
                        for (org.bson.Document e : electives) {
                %>
                    <p>
                        <b><%= e.getString("name") %></b> |
                        <%= e.getString("category") %> |
                        <%= e.getString("difficulty") %>
                    </p>
                <%
                        }
                    } else {
                %>
                    <p>No electives found</p>
                <%
                    }
                %>
            </div>

            <!-- USERS -->
            <div id="users" class="section">
                <h3>Users List</h3>

                <form action="admin" method="get">
                    <input type="hidden" name="action" value="users">
                    <button>Load Users</button>
                </form>

                <%
                    List<Document> users = (List<Document>) request.getAttribute("users");

                    if(users != null){
                        for(Document u : users){
                %>
                    <p>
                        <b><%= u.getString("name") %></b> -
                        <%= u.getString("studentId") %>
                    </p>
                <%
                        }
                    }
                %>
            </div>

            <!-- ANALYTICS -->
            <div id="analytics" class="section">
                <h3>Analytics</h3>
                <canvas id="chart" width="300" height="150"></canvas>
            </div>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
function showSection(id) {
    document.querySelectorAll(".section").forEach(s => s.classList.remove("active"));
    document.getElementById(id).classList.add("active");
}

const ctx = document.getElementById('chart').getContext('2d');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['AI', 'Web', 'Cyber', 'Data Science'],
        datasets: [{
            label: 'Electives',
            data: [4, 3, 2, 1]
        }]
    }
});
</script>
<script>
function toggleMenu() {
    let dropdown = document.getElementById("dropdown");

    if (dropdown.style.display === "block") {
        dropdown.style.display = "none";
    } else {
        dropdown.style.display = "block";
    }
}
</script>
</body>
</html>