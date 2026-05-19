<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.slotsync.dao.UserDAO" %>
<%@ page import="com.slotsync.model.User" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    User user = (User) request.getAttribute("user");
    if (user == null) {
        UserDAO userDAO = new UserDAO();
        user = userDAO.getUserById((int) session.getAttribute("userId"));
    }
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync — My Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="/views/common/navbar.jsp" %>
<main class="container narrow">
    <section class="page-header">
        <h1>My Profile</h1>
        <p class="subtitle">View and update your account information</p>
    </section>

    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>
    <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>

    <div class="card">
        <div class="card-body">
            <div class="profile-avatar">
                <span><%= user != null && user.getName() != null ? user.getName().substring(0, 1).toUpperCase() : "?" %></span>
            </div>
            <% if (user != null) { %>
            <form action="<%= request.getContextPath() %>/UserServlet" method="post" id="profileForm" novalidate>

                <div class="form-group">
                    <label for="name">Full Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name"
                           value="<%= user.getName() != null ? user.getName() : "" %>"
                           class="form-control" required>
                    <span class="error-msg" id="nameError"></span>
                </div>

                <div class="form-group">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input type="email" id="email" name="email"
                           value="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                           class="form-control" required>
                    <span class="error-msg" id="emailError"></span>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone"
                           value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                           class="form-control" placeholder="e.g. 9800000000">
                    <span class="error-msg" id="phoneError"></span>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address"
                           value="<%= user.getAddress() != null ? user.getAddress() : "" %>"
                           class="form-control">
                </div>

                <div class="form-group">
                    <label>Role</label>
                    <input type="text" value="<%= user.getRole() != null ? user.getRole() : "" %>"
                           class="form-control" readonly disabled>
                </div>

                <div class="form-group">
                    <label>Member Since</label>
                    <input type="text"
                           value="<%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "N/A" %>"
                           class="form-control" readonly disabled>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="<%= request.getContextPath() %>/views/client/home.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</main>
<%@ include file="/views/common/footer.jsp" %>
<script src="<%= request.getContextPath() %>/js/validation.js"></script>
</body>
</html>