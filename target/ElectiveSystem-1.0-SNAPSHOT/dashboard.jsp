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
<meta charset="UTF-8">
<title>Dashboard</title>

<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
* { transition: all 0.2s ease-in-out; }
.btn {
    background:#6366f1;
    color:white;
    padding:10px;
    border-radius:10px;
}
.input {
    padding:10px;
    border:1px solid #ccc;
    border-radius:8px;
}
</style>
</head>

<body class="bg-indigo-50 font-sans">

<!-- NAVBAR -->
<div class="bg-white shadow px-6 py-4 flex justify-between items-center">

    <h1 class="text-xl font-bold text-indigo-600">
        Elective Recommendation System
    </h1>

    <div class="flex items-center gap-4">
        <span>Welcome, <%= name %></span>

        <a href="logout"
           class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg text-sm shadow">
            Logout
        </a>
    </div>

</div>

<div class="flex p-6 gap-6">

<!-- PROFILE -->
<div class="w-1/4 bg-indigo-600 text-white rounded-xl p-6 text-center">
    <h2 class="text-xl font-bold"><%= name %></h2>
    <p>ID: <%= studentId %></p>
    <p>Branch: CSE</p>
</div>

<!-- CONTENT -->
<div class="w-3/4">

<!-- MENU -->
<div class="flex gap-3 mb-6 flex-wrap">
    <button onclick="showSection('academic')" class="btn">Academic</button>
    <button onclick="showSection('recommend')" class="btn">Recommend</button>
    <button onclick="showSection('analytics')" class="btn">Analytics</button>
    <button onclick="showSection('query')" class="btn">Query</button>
    <button onclick="showSection('answers')" class="btn">My Queries</button>
    <button onclick="showSection('electives')" class="btn">Electives</button>
    <button onclick="showSection('selected')" class="btn">My Electives</button>
</div>

<div class="bg-white p-6 rounded-xl shadow">

<!-- ACADEMIC -->
<div id="academic" class="section">
    <h2 class="text-lg font-semibold mb-4">Academic Details</h2>

    <form action="dashboard" method="post" class="grid grid-cols-2 gap-4">
        <input type="text" name="branch" placeholder="Branch" class="input">
        <input type="text" name="semester" placeholder="Semester" class="input">
        <input type="number" name="tenth" placeholder="10th %" class="input">
        <input type="number" name="twelfth" placeholder="12th %" class="input">

        <input type="number" step="0.01" name="cgpa" placeholder="CGPA" class="input col-span-2">

        <select name="codingLevel" class="input">
            <option>Beginner</option>
            <option>Intermediate</option>
            <option>Advanced</option>
        </select>

        <select name="goal" class="input">
            <option>Placement</option>
            <option>Higher Studies</option>
        </select>

        <button class="btn col-span-2">Save</button>
    </form>
</div>

<!-- RECOMMEND -->
<div id="recommend" class="section hidden">
    <h2 class="text-lg font-semibold mb-4">Recommendation</h2>

    <form action="recommend" method="post" class="space-y-4">
        <select name="interest" class="input w-full">
            <option>Select Interest</option>
            <option>AI</option>
            <option>Web</option>
            <option>Cyber</option>
            <option>Data Science</option>
        </select>

        <input type="number" step="0.01" name="cgpa" class="input w-full" placeholder="Enter CGPA">

        <button class="btn w-full">Get Top Electives</button>
    </form>
</div>

<!-- ANALYTICS -->
<div id="analytics" class="section hidden">
    <h2 class="text-lg font-semibold mb-6">Analytics Dashboard</h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

        <div class="bg-gray-50 p-4 rounded-xl shadow">
            <canvas id="barChart"></canvas>
        </div>

        <div class="bg-gray-50 p-4 rounded-xl shadow">
            <canvas id="pieChart"></canvas>
        </div>

        <div class="bg-gray-50 p-4 rounded-xl shadow col-span-2">
            <canvas id="lineChart"></canvas>
        </div>

    </div>
</div>
<!-- MY SELECTED ELECTIVES -->
<div id="selected" class="section hidden">
    <h2 class="text-lg font-semibold mb-4">My Selected Electives</h2>

    <%
        try {
            com.mongodb.client.MongoClient client =
                com.mongodb.client.MongoClients.create("mongodb://localhost:27017");

            com.mongodb.client.MongoDatabase db =
                client.getDatabase("electiveDB");

            com.mongodb.client.MongoCollection<org.bson.Document> col =
                db.getCollection("selected_electives");

            java.util.List<org.bson.Document> list =
                col.find(new org.bson.Document("studentId", studentId))
                   .into(new java.util.ArrayList<>());

            if(list.isEmpty()){
    %>

    <p class="text-gray-500">No electives selected yet.</p>

    <%
            } else {
                for(org.bson.Document e : list){
    %>

    <div class="border p-3 mb-2 bg-green-50 rounded">
        <b><%= e.getString("name") %></b>
        <p><%= e.getString("domain") %></p>
    </div>

    <%
                }
            }

            client.close();
        } catch(Exception e){
            out.println("Error loading electives");
        }
    %>
</div>

<!-- QUERY -->
<div id="query" class="section hidden">
    <h2 class="text-lg font-semibold mb-4">Ask Query</h2>

    <form action="query" method="post">
        <textarea name="query" class="input w-full"></textarea>
        <button class="btn w-full mt-2">Submit</button>
    </form>
</div>

<!-- ANSWERS -->
<div id="answers" class="section hidden">
    <h2 class="text-lg font-semibold mb-4">Your Queries</h2>

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

    <div class="border p-4 mb-3">
        <p><b>Q:</b> <%= q.getString("query") %></p>
        <p><b>A:</b> <%= q.getString("answer") != null ? q.getString("answer") : "Pending..." %></p>
    </div>

    <%
            }
            client.close();
        } catch(Exception e){
            out.println("Error loading queries");
        }
    %>
</div>

<!-- ELECTIVES -->
<div id="electives" class="section hidden">
    <h2 class="text-lg font-semibold mb-4">Available Electives</h2>

    <%
        try {
            com.mongodb.client.MongoClient client =
                com.mongodb.client.MongoClients.create("mongodb://localhost:27017");

            com.mongodb.client.MongoDatabase db =
                client.getDatabase("electiveDB");

            com.mongodb.client.MongoCollection<Document> col =
                db.getCollection("electives");

            List<Document> list = col.find().into(new ArrayList<>());

            for(Document e : list){
    %>

    <div class="border p-4 mb-3 bg-gray-50 rounded">
        <h3 class="text-indigo-600 font-bold"><%= e.getString("name") %></h3>
        <p>Domain: <%= e.getString("domain") %></p>
        <p>Difficulty: <%= e.getString("difficulty") %></p>
        <p><%= e.getString("description") %></p>
    </div>

    <%
            }
            client.close();
        } catch(Exception e){
            out.println("Error loading electives");
        }
    %>
</div>

</div>
</div>
</div>

<script>
let chartsLoaded = false;

function showSection(id) {
    document.querySelectorAll(".section").forEach(sec => sec.classList.add("hidden"));
    document.getElementById(id).classList.remove("hidden");

    if (id === "analytics" && !chartsLoaded) {
        loadCharts();
        chartsLoaded = true;
    }
}

function loadCharts() {

    new Chart(document.getElementById("barChart"), {
        type: 'bar',
        data: {
            labels: ['10th', '12th', 'CGPA'],
            datasets: [{
                label: 'Academic Performance',
                data: [85, 88, 8.5],
                backgroundColor: ['#6366f1','#818cf8','#4f46e5']
            }]
        }
    });

    new Chart(document.getElementById("pieChart"), {
        type: 'pie',
        data: {
            labels: ['AI', 'Web', 'Cyber', 'Data Science'],
            datasets: [{
                data: [30, 25, 20, 25],
                backgroundColor: ['#6366f1','#818cf8','#4f46e5','#a5b4fc']
            }]
        }
    });

    new Chart(document.getElementById("lineChart"), {
        type: 'line',
        data: {
            labels: ['Sem1', 'Sem2', 'Sem3', 'Sem4'],
            datasets: [{
                label: 'CGPA Trend',
                data: [7.5, 8.0, 8.3, 8.5],
                borderColor: '#6366f1',
                fill: false
            }]
        }
    });
}
</script>

</body>
</html>