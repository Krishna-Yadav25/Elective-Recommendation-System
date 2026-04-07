<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Elective System</title>

<!-- Tailwind CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<script>
function toggleFields() {
    let role = document.getElementById("role").value;

    document.getElementById("studentBox").style.display = "none";
    document.getElementById("adminBox").style.display = "none";

    if (role === "student") {
        document.getElementById("studentBox").style.display = "block";
    } else if (role === "admin") {
        document.getElementById("adminBox").style.display = "block";
    }
}
</script>

</head>

<body class="h-screen flex font-sans">

<!-- LEFT SIDE -->
<div class="w-1/2 bg-gradient-to-br from-purple-600 to-indigo-500 text-white flex flex-col justify-center items-center p-10">

    <h1 class="text-5xl font-bold mb-4">Elective Navigator 🎓</h1>

    <div class="bg-white/20 backdrop-blur-md p-6 rounded-2xl shadow-lg mb-6 text-center">
        <h2 class="text-3xl font-semibold mb-2">Welcome Back 👋</h2>
        <p class="text-sm opacity-90">
            Choose your electives smartly and plan your future 🚀
        </p>
    </div>

    <div class="mt-6 text-lg animate-pulse">
        💡 Tip: Pick subjects based on interest, not trend
    </div>

</div>

<!-- RIGHT SIDE -->
<div class="w-1/2 flex justify-center items-center bg-gray-50">

    <div class="bg-white shadow-2xl rounded-2xl p-8 w-96 transition hover:scale-105 duration-300">

        <h2 class="text-2xl font-semibold mb-6 text-center">Login ✨</h2>

        <!-- ERROR MESSAGE -->
        <%
            String error = (String) request.getAttribute("error");
            if(error != null){
        %>
            <p class="text-red-500 text-center mb-3"><%= error %></p>
        <%
            }
        %>

        <form action="login" method="post" class="space-y-4">

            <!-- ROLE -->
            <div>
                <label class="text-sm text-gray-600">Login As</label>
                <select name="role" id="role" onchange="toggleFields()" required
                    class="w-full p-3 mt-1 border rounded-lg focus:ring-2 focus:ring-indigo-400">
                    <option value="">Select Role</option>
                    <option value="student">Student</option>
                    <option value="admin">Admin</option>
                </select>
            </div>

            <!-- STUDENT ID -->
            <div id="studentBox" style="display:none;">
                <label class="text-sm text-gray-600">Student ID</label>
                <input type="text" name="studentId"
                    class="w-full p-3 mt-1 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <!-- ADMIN USERNAME -->
            <div id="adminBox" style="display:none;">
                <label class="text-sm text-gray-600">Username</label>
                <input type="text" name="username"
                    class="w-full p-3 mt-1 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <!-- PASSWORD -->
            <div>
                <label class="text-sm text-gray-600">Password</label>
                <input type="password" name="password" required
                    class="w-full p-3 mt-1 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <!-- BUTTON -->
            <button type="submit"
                class="w-full bg-indigo-500 hover:bg-indigo-600 text-white p-3 rounded-lg font-semibold transition duration-300">
                Login
            </button>

        </form>

        <!-- REGISTER -->
        <p class="text-center mt-4 text-sm">
            New user?
            <a href="<%= request.getContextPath() %>/register.jsp"
               class="text-indigo-600 font-semibold hover:underline">
               Register
            </a>
        </p>

    </div>

</div>

</body>
</html>