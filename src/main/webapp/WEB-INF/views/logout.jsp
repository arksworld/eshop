<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Logout</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h2>You are being logged out...</h2>

<script>
    $(document).ready(function() {
        // Clear JWT from localStorage
        localStorage.removeItem("jwtToken");

        // Redirect to login page
        window.location.href = "/login";
    });
</script>
</body>
</html>
