<%-- 
    Document   : recommend.jsp
    Created on : 21 Mar 2026, 3:40:00 pm
    Author     : krish
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Recommended Electives</title>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI';
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .container {
            width: 500px;
            margin: 80px auto;
            padding: 30px;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            text-align: center;
            color: white;
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }

        h2 {
            margin-bottom: 20px;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        li {
            background: rgba(255,255,255,0.2);
            margin: 10px 0;
            padding: 12px;
            border-radius: 10px;
            font-size: 16px;
            transition: 0.3s;
        }

        li:hover {
            transform: scale(1.05);
            background: rgba(255,255,255,0.3);
        }

        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #00f2fe;
            color: black;
            border-radius: 8px;
            text-decoration: none;
            transition: 0.3s;
        }

        .btn:hover {
            background: #4facfe;
            transform: scale(1.05);
        }

        .empty {
            color: #ffcccc;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>🎯 Recommended Electives</h2>

    <ul>
        <%
            List<String> recs = (List<String>) request.getAttribute("recommendations");

            if (recs != null && !recs.isEmpty()) {
                for (String r : recs) {
        %>
            <li><%= r %></li>
        <%
                }
            } else {
        %>
            <li class="empty">No recommendations available</li>
        <%
            }
        %>
    </ul>

    <!-- BACK BUTTON -->
    <a href="dashboard.jsp" class="btn"> Back to Dashboard</a>

</div>

</body>
</html>
