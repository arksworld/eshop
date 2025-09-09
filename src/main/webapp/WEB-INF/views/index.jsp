<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>E-Commerce Home</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $("#logoutBtn").click(function() {
        alert('lggg');
        window.location.href = "/logout";
    });
</script>
</head>
<body>
<h2> Welcome to E-commerce app!</h2>
<h3>Please click <a href="${pageContext.request.contextPath}/login">here</a> to login to the application.</h3>
<h3>Please click <button id="logoutBtn">Logout</button> to logout of the application.</h3>
</body>
</html>
