<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>E-Commerce Home</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function () {
        const token = localStorage.getItem("jwtToken");
        if (token) {
            $.ajax({
                url: "/api/users/me",
                type: "GET",
                headers: { "Authorization": "Bearer " + token },
                success: function (data) {
                    $("#welcomeMessage").text("Welcome, " + data.username + "!");
                },
                error: function () {
                    $("#welcomeMessage").text("Welcome, Guest!");
                }
            });
        } else {
            $("#welcomeMessage").text("Welcome, Guest!");
        }
        $("#logoutBtn").click(function() {
                alert('lggg');
                window.location.href = "/auth/logout";
         });
    });
</script>
</head>
<body>
<h2> Welcome to E-commerce app!</h2>
<div id="welcomeMessage"></div>
<h3>Please click <a href="${pageContext.request.contextPath}/login">here</a> to login to the application.</h3>
<h3>Please click <button id="logoutBtn">Logout</button> to logout of the application.</h3>
</body>
</html>
