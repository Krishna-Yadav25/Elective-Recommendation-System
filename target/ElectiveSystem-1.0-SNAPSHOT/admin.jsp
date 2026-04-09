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
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body class="bg-gray-100 font-sans">

<!--  NAVBAR -->
<div class="bg-gradient-to-r from-blue-600 to-cyan-500 text-white px-8 py-4 flex justify-between items-center shadow">

    <div>
        <h2 class="text-2xl font-bold">Elective Recommendation System</h2>
        <p class="text-sm opacity-80">Admin Panel</p>
    </div>

    <div class="flex items-center gap-4">
        <span>Welcome, <%= session.getAttribute("name") %></span>

        <a href="<%= request.getContextPath() %>/logout"
           class="bg-red-500 px-4 py-2 rounded-lg hover:bg-red-600">
            Logout
        </a>
    </div>
</div>

<div class="flex p-6 gap-6">

<!--  SIDEBAR -->
<div class="w-1/4 bg-white shadow rounded-xl p-5">

    <h3 class="text-lg font-semibold mb-2">Admin</h3>
    <p class="text-gray-500 mb-4"><%= session.getAttribute("name") %></p>

    <div class="flex flex-col gap-3">
        <button onclick="showSection('add')" class="bg-blue-600 text-white py-2 rounded-lg">Add</button>
        <button onclick="showSection('delete')" class="bg-gray-200 py-2 rounded-lg">Delete</button>
        <button onclick="showSection('list')" class="bg-gray-200 py-2 rounded-lg">Electives</button>
        <button onclick="showSection('users')" class="bg-gray-200 py-2 rounded-lg">Users</button>
        <button onclick="showSection('queries')" class="bg-gray-200 py-2 rounded-lg">Queries</button>
        <button onclick="showSection('analytics')" class="bg-gray-200 py-2 rounded-lg">Analytics</button>
    </div>

</div>

<!-- MAIN CONTENT -->
<div class="w-3/4 space-y-6">

<!-- ADD -->
<div id="add" class="section bg-white p-6 rounded-xl shadow">
    <h3 class="text-lg font-semibold mb-4">Add Elective</h3>

    <form action="admin" method="post" class="grid grid-cols-2 gap-4">
        <input type="hidden" name="action" value="add">

        <input type="text" name="name" placeholder="Elective Name"
               class="border p-3 rounded-lg col-span-2">

        <select name="category" class="border p-3 rounded-lg">
            <option>AI</option>
            <option>Web</option>
            <option>Cyber</option>
            <option>Data Science</option>
        </select>

        <select name="difficulty" class="border p-3 rounded-lg">
            <option>Easy</option>
            <option>Medium</option>
            <option>Hard</option>
        </select>

        <button class="bg-blue-600 text-white py-3 rounded-lg col-span-2 hover:bg-blue-700">
            Add
        </button>
    </form>
</div>

<!-- DELETE -->
<div id="delete" class="section hidden bg-white p-6 rounded-xl shadow">
    <h3 class="text-lg font-semibold mb-4">Delete Elective</h3>

    <form action="admin" method="post" class="flex gap-3">
        <input type="hidden" name="action" value="delete">
        <input type="text" name="name" placeholder="Elective Name"
               class="border p-3 rounded-lg flex-1">
        <button class="bg-red-500 text-white px-4 rounded-lg">Delete</button>
    </form>
</div>

<!-- ELECTIVES -->
<div id="list" class="section hidden bg-white p-6 rounded-xl shadow">
    <h3 class="text-lg font-semibold mb-4">All Electives</h3>

    <div class="space-y-2">
    <%
        List<Document> electives = (List<Document>) request.getAttribute("electives");
        if (electives != null) {
            for (Document e : electives) {
    %>
        <div class="p-3 border rounded-lg bg-gray-50">
            <b><%= e.getString("name") %></b> |
            <%= e.getString("category") %> |
            <%= e.getString("difficulty") %>
        </div>
    <%
            }
        }
    %>
    </div>
</div>

<!-- USERS -->
<div id="users" class="section hidden bg-white p-6 rounded-xl shadow">
    <h3 class="text-lg font-semibold mb-4">Users</h3>

    <form action="admin" method="get">
        <input type="hidden" name="action" value="users">
        <button class="bg-blue-500 text-white px-4 py-2 rounded-lg">Load Users</button>
    </form>

    <%
        List<Document> users = (List<Document>) request.getAttribute("users");
        if(users != null && !users.isEmpty()){
    %>

    <table class="w-full mt-4 border">
        <tr class="bg-blue-600 text-white">
            <th class="p-2">Name</th>
            <th class="p-2">Student ID</th>
            <th class="p-2">Role</th>
        </tr>

        <%
            for(Document u : users){
        %>
        <tr class="text-center border-b">
            <td class="p-2"><%= u.getString("name") %></td>
            <td class="p-2"><%= u.getString("studentId") %></td>
            <td class="p-2"><%= u.getString("role")!=null ? u.getString("role") : "student" %></td>
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
<!-- QUERIES -->
<div id="queries" class="section hidden bg-white p-6 rounded-xl shadow">
    <h3 class="text-lg font-semibold mb-4">Student Queries (Chat)</h3>

<%
try {
    com.mongodb.client.MongoClient client =
            com.mongodb.client.MongoClients.create("mongodb://localhost:27017");

    com.mongodb.client.MongoDatabase db =
            client.getDatabase("electiveDB");

    com.mongodb.client.MongoCollection<Document> col =
            db.getCollection("queries");

    List<Document> list = col.find().into(new ArrayList<>());

    for(Document q : list){

        List<Document> messages = (List<Document>) q.get("messages");
%>

<div class="border p-4 mb-4 rounded-lg">

    <p class="font-bold mb-2">
        Student ID: <%= q.getString("studentId") %>
    </p>

    <!-- CHAT BOX -->
    <div class="mb-3">

    <%
        // ✅ NEW CHAT STRUCTURE
        if (messages != null) {
            for (Document m : messages) {

                String sender = m.getString("sender");
                String text = m.getString("text");

                boolean isAdmin = "admin".equals(sender);
    %>

        <div style="text-align:<%= isAdmin ? "right" : "left" %>; margin:5px 0;">

            <span style="
                display:inline-block;
                padding:8px 12px;
                border-radius:10px;
                background-color:<%= isAdmin ? "#bbf7d0" : "#e5e7eb" %>;
            ">

                <b><%= sender %>:</b> <%= text %>

            </span>

        </div>

    <%
            }
        }

        // ✅ FALLBACK FOR OLD DATA
        else {
    %>

        <div style="text-align:left; margin:5px 0;">
            <span style="background:#e5e7eb; padding:8px; border-radius:10px;">
                <b>student:</b> <%= q.getString("query") %>
            </span>
        </div>

        <div style="text-align:right; margin:5px 0;">
            <span style="background:#bbf7d0; padding:8px; border-radius:10px;">
                <b>admin:</b> 
                <%= q.getString("answer") != null ? q.getString("answer") : "Not answered" %>
            </span>
        </div>

    <%
        }
    %>

    </div>

    <!-- REPLY FORM -->
    <form action="answer" method="post" class="flex gap-2 mt-2">
        <input type="hidden" name="studentId" value="<%= q.getString("studentId") %>">

        <input type="text" name="answer"
               placeholder="Reply..."
               class="border p-2 flex-1 rounded-lg">

        <button class="bg-green-500 text-white px-4 rounded-lg">
            Send
        </button>
    </form>

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
<div id="analytics" class="section hidden bg-white p-6 rounded-xl shadow">
    <h3 class="text-lg font-semibold mb-4">Analytics</h3>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

        <!-- Chart 1 -->
        <div class="bg-gray-50 p-4 rounded-xl h-64">
            <canvas id="cgpaChart"></canvas>
        </div>

        <!-- Chart 2 -->
        <div class="bg-gray-50 p-4 rounded-xl h-64">
            <canvas id="codingChart"></canvas>
        </div>

        <!-- Chart 3 -->
        <div class="bg-gray-50 p-4 rounded-xl h-64">
            <canvas id="radarChart"></canvas>
        </div>

    </div>
</div>

</div>
</div>

<script>
function showSection(id){
document.querySelectorAll(".section").forEach(s=>s.classList.add("hidden"));
document.getElementById(id).classList.remove("hidden");
}

window.onload = function(){

new Chart(document.getElementById("cgpaChart"),{
type:'bar',
data:{labels:["CGPA"],datasets:[{data:[8]}]}
});

new Chart(document.getElementById("codingChart"),{
type:'doughnut',
data:{labels:["Skill","Remaining"],datasets:[{data:[7,3]}]}
});

new Chart(document.getElementById("radarChart"),{
type:'radar',
data:{labels:["Academics","Coding","Goal","Consistency","Growth"],
datasets:[{data:[8,7,9,7,8]}]}
});

}
</script>

</body>
</html> 