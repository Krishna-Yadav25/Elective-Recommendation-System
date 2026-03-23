<%-- 
    Document   : users
    Created on : 23 Mar 2026, 3:50:01 pm
    Author     : krish
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, org.bson.Document" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Users</title>

    <style>
        body {
            font-family: Arial;
            background: #f4f6f9;
            margin: 0;
        }

        .container {
            width: 80%;
            margin: 40px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        th {
            background: #0072ff;
            color: white;
        }

        tr:hover {
            background: #f1f1f1;
        }

        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background: #0072ff;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .btn:hover {
            background: #0056cc;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>👥 All Users</h2>

    <table>
        <tr>
            <th>Name</th>
            <th>Student ID</th>
        </tr>

        <%
            List<Document> users = (List<Document>) request.getAttribute("users");

            if (users != null && !users.isEmpty()) {
                for (Document u : users) {
        %>
        <tr>
            <td><%= u.getString("name") %></td>
            <td><%= u.getString("studentId") %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="2">No users found</td>
        </tr>
        <%
            }
        %>

    </table>

    <a href="admin.jsp" class="btn">⬅ Back to Admin</a>

</div>

</body>
</html>
