<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.UserDAO, model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserById(currentUser.getUserId());
    if (user == null) user = currentUser;

    String error   = (String) request.getAttribute("error");
    String success  = (String) request.getAttribute("success");

    // Initials
    String initials = "?";
    if (user.getFullName() != null && !user.getFullName().isEmpty()) {
        String[] parts = user.getFullName().trim().split("\\s+");
        initials = parts.length >= 2
            ? ("" + parts[0].charAt(0) + parts[parts.length-1].charAt(0)).toUpperCase()
            : ("" + parts[0].charAt(0)).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />
<div class="container" style="padding-top:40px;padding-bottom:60px;max-width:860px">
    <div class="dash-head" style="margin-bottom:28px">
        <div>
            <h1 style="font-size:26px;font-weight:600;letter-spacing:-0.01em;margin:0 0 4px">Profile</h1>
            <div class="muted small">Manage your account details.</div>
        </div>
    </div>

    <% if (error != null) { %>
    <div style="background:var(--red-50);border:1px solid #fecaca;color:#b91c1c;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= error %></div>
    <% } %>
    <% if (success != null) { %>
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= success %></div>
    <% } %>

    <div class="card card-pad">
        <div class="row gap-4 items-center" style="margin-bottom:24px">
            <div class="avatar avatar-lg"><%= initials %></div>
            <div>
                <div style="font-weight:600;font-size:16px"><%= user.getFullName() != null ? user.getFullName() : "—" %></div>
                <div class="muted small" style="margin-top:2px;text-transform:capitalize"><%= user.getRole() %> account</div>
            </div>
        </div>

        <form action="<%= ctx %>/user?action=updateProfile" method="post">
            <div class="col gap-4">
                <div class="field">
                    <label>Full Name</label>
                    <input class="input" type="text" name="fullName" required
                           value="<%= user.getFullName() != null ? user.getFullName() : "" %>">
                </div>
                <div class="field">
                    <label>Email Address</label>
                    <input class="input" type="email" name="email" required
                           value="<%= user.getEmail() != null ? user.getEmail() : "" %>">
                </div>
                <div class="field">
                    <label>Phone Number</label>
                    <input class="input" type="text" name="phone"
                           value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                           placeholder="e.g. 07700900000">
                </div>
                <div class="field">
                    <label>Role</label>
                    <input class="input" type="text" value="<%= user.getRole() != null ? user.getRole() : "" %>"
                           readonly disabled style="text-transform:capitalize">
                </div>
                <div class="row gap-3">
                    <button class="btn btn-primary" type="submit">Save changes</button>
                    <a href="<%= ctx %>/views/client/home.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/views/common/footer.jsp" />
</body>
</html>
