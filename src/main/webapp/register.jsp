<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register - Elective System</title>

<script src="https://cdn.tailwindcss.com"></script>

<script>
function validate() {
    let name = document.getElementsByName("name")[0].value;
    let p = document.getElementsByName("password")[0].value;
    let c = document.getElementsByName("confirm")[0].value;

    if (name.trim() === "") {
        alert("Name cannot be empty!");
        return false;
    }

    if (p !== c) {
        alert("Passwords do not match!");
        return false;
    }

    if (p.length < 6) {
        alert("Password must be at least 6 characters!");
        return false;
    }

    return true;
}
</script>

</head>

<body class="h-screen flex font-sans">

<!-- LEFT -->
<div class="w-1/2 bg-gradient-to-br from-purple-600 to-indigo-500 text-white flex flex-col justify-center items-center p-10">

    <h1 class="text-5xl font-bold mb-4">Elective Navigator🎓</h1>

    <div class="bg-white/20 backdrop-blur-md p-6 rounded-2xl shadow-lg mb-6 text-center">
        <h2 class="text-3xl font-semibold mb-2">Join Us 🚀</h2>
        <p class="text-sm opacity-90">
            Create your account and explore electives smarter
        </p>
    </div>

</div>

<!-- RIGHT -->
<div class="w-1/2 flex justify-center items-center bg-gray-50">

    <div class="bg-white shadow-2xl rounded-2xl p-8 w-96">

        <h2 class="text-2xl font-semibold mb-6 text-center">Create Account ✨</h2>

        <!-- ERROR -->
        <%
            String error = (String) request.getAttribute("error");
            if(error != null){
        %>
            <p class="text-red-500 text-center mb-3"><%= error %></p>
        <%
            }
        %>

        <form action="register" method="post" onsubmit="return validate()" class="space-y-4">

            <div>
                <label class="text-sm text-gray-600">Name</label>
                <input type="text" name="name" required
                    class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <div>
                <label class="text-sm text-gray-600">Student ID</label>
                <input type="text" name="studentId" required
                    class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <div>
                <label class="text-sm text-gray-600">Password</label>
                <input type="password" name="password" required
                    class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <div>
                <label class="text-sm text-gray-600">Confirm Password</label>
                <input type="password" name="confirm" required
                    class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-indigo-400">
            </div>

            <button type="submit"
                class="w-full bg-indigo-500 hover:bg-indigo-600 text-white p-3 rounded-lg font-semibold">
                Register
            </button>

        </form>

        <p class="text-center mt-4 text-sm">
            Already have an account?
            <a href="index.jsp" class="text-indigo-600 font-semibold hover:underline">
                Login
            </a>
        </p>

    </div>

</div>

</body>
</html>