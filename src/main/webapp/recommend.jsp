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
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        * { transition: all 0.25s ease; }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center bg-gradient-to-br from-indigo-600 via-indigo-500 to-indigo-700 font-sans">

<div class="w-[420px] bg-white/10 backdrop-blur-xl border border-white/20 shadow-2xl rounded-3xl p-8 text-white">

    <h2 class="text-2xl font-bold text-center mb-6">
        🎯 Recommended Electives
    </h2>

    <div class="space-y-3">

    <%
        List<String> recs = (List<String>) request.getAttribute("recommendations");

        if (recs != null && !recs.isEmpty()) {

            int index = 1;

            for (String r : recs) {

                // 👉 auto-detect domain from name
                String domain = "General";

                if(r.toLowerCase().contains("machine") || r.toLowerCase().contains("ai"))
                    domain = "AI";
                else if(r.toLowerCase().contains("web") || r.toLowerCase().contains("devops"))
                    domain = "Web Development";
                else if(r.toLowerCase().contains("cyber"))
                    domain = "Cyber Security";
                else if(r.toLowerCase().contains("data"))
                    domain = "Data Science";
    %>

        <!-- ITEM -->
        <div class="bg-white/10 p-4 rounded-xl shadow-md hover:bg-white/20">

            <div class="flex items-center justify-between">

                <!-- LEFT -->
                <div class="flex items-center gap-3">
                    <span class="w-6 h-6 flex items-center justify-center bg-indigo-400 text-xs font-bold rounded-full">
                        <%= index++ %>
                    </span>

                    <div>
                        <p class="text-sm font-medium"><%= r %></p>
                        <p class="text-xs text-indigo-200"><%= domain %></p>
                    </div>
                </div>

                <!-- RIGHT BUTTON -->
                <form action="selectElective" method="post">
                    <input type="hidden" name="name" value="<%= r %>">
                    <input type="hidden" name="domain" value="<%= domain %>">

                    <button class="bg-white text-indigo-600 px-3 py-1 rounded-lg text-xs font-semibold hover:bg-indigo-100">
                        Select
                    </button>
                </form>

            </div>

        </div>

    <%
            }
    %>

    <!-- COUNT -->
    <p class="text-center text-sm text-indigo-200 mt-4">
        Total Recommendations: 
        <span class="font-semibold"><%= recs.size() %></span>
    </p>

    <%
        } else {
    %>

    <!-- EMPTY -->
    <div class="text-center bg-red-400/20 p-4 rounded-xl text-red-200">
        ❌ No recommendations available
    </div>

    <%
        }
    %>

    </div>

    <!-- BACK -->
    <a href="<%= request.getContextPath() %>/dashboard"
       class="mt-6 block text-center bg-white text-indigo-600 font-semibold py-3 rounded-xl shadow-lg hover:bg-indigo-100 hover:scale-105">
        ← Back to Dashboard
    </a>

</div>

</body>
</html>