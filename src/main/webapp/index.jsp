<%-- 
    Document   : index.jsp
    Created on : 21 Mar 2026, 12:39:20 pm
    Author     : krish
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="style.css">

    <script>
        function toggleFields() {
            let role = document.getElementById("role").value;

            if (role === "student") {
                document.getElementById("studentBox").style.display = "block";
                document.getElementById("adminBox").style.display = "none";
            } else if (role === "admin") {
                document.getElementById("studentBox").style.display = "none";
                document.getElementById("adminBox").style.display = "block";
            } else {
                document.getElementById("studentBox").style.display = "none";
                document.getElementById("adminBox").style.display = "none";
            }
        }
    </script>
</head>
<body>

<h1 class="title">Elective Recommendation System</h1>

<div class="container animate">

    <h2>Welcome Back</h2>

    <!-- ERROR MESSAGE -->
    <%
        String error = (String) request.getAttribute("error");
        if(error != null){
    %>
        <p class="error-msg"><%= error %></p>
    <%
        }
    %>

    <!-- LOGIN FORM -->
    <form action="login" method="post">

        <!-- ROLE SELECT -->
        <div class="input-box">
            <select name="role" id="role" onchange="toggleFields()" required>
                <option value="">Login As</option>
                <option value="student">Student</option>
                <option value="admin">Admin</option>
            </select>
        </div>

        <!-- STUDENT ID -->
        <div class="input-box" id="studentBox" style="display:none;">
            <input type="text" name="studentId">
            <label>Student ID</label>
        </div>

        <!-- ADMIN USERNAME -->
        <div class="input-box" id="adminBox" style="display:none;">
            <input type="text" name="username">
            <label>Username</label>
        </div>

        <!-- PASSWORD -->
        <div class="input-box">
            <input type="password" name="password" required>
            <label>Password</label>
        </div>

        <button type="submit">Login</button>

    </form>

    <!-- REGISTER LINK -->
    <p>New user? 
        <a href="<%= request.getContextPath() %>/register.html">Register</a>
    </p>

</div>

<script src="script.js"></script>

</body>
</html>
