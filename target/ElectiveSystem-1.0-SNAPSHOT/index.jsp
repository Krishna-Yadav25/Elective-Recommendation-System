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
</head>
<body>

<h1 class="title">Elective Recommendation System</h1>

<div class="container animate">

    <h2>Welcome Back</h2>

    <!-- ✅ ERROR MESSAGE (CORRECT POSITION) -->
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
        <div class="input-box">
            <input type="text" name="studentId" required>
            <label>Student ID</label>
        </div>

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
