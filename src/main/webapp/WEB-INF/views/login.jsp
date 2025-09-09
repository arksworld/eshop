<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login - E-Commerce</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h2>Login</h2>

<form id="loginForm">
    <label>Username:</label>
    <input type="text" id="username" required /><br/><br/>

    <label>Password:</label>
    <input type="password" id="password" autocomplete="new-password" required /><br/><br/>

    <button type="submit">Login</button>
</form>

<div id="error" style="color: red; display: none;"></div>

<script>
    $(document).ready(function() {
        $("#loginForm").submit(function(event) {
            event.preventDefault();

            const user = {
                username: $("#username").val(),
                password: $("#password").val()
            };

            $.ajax({
                url: "/api/auth/login",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify(user),
                success: function(response) {
                    // assuming response = { token: "JWT_TOKEN_HERE" }
                    localStorage.setItem("jwtToken", response.token);
                    window.location.href = "/";  // redirect to index.jsp
                },
                error: function(xhr) {
                    $("#error").text("Invalid credentials!").show();
                }
            });
        });
    });
</script>
</body>
</html>
