<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="dash">
    <!-- Sidebar -->
    <aside class="sidebar" id="user-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <div class="brand-mark"></div>
                <span>SlotSync</span>
            </a>
            <div class="badge badge-amber" style="margin-top:10px; font-size:11px">
                <%= user.getRole().substring(0, 1).toUpperCase() + user.getRole().substring(1) %> Portal
            </div>
        </div>
        <nav class="col gap-2">
            <div class="sidebar-section">Menu</div>
            <a href="${pageContext.request.contextPath}/views/user/home.jsp" class="sidenav-item active">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/views/user/profile.jsp" class="sidenav-item">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                My Profile
            </a>
            <% if ("client".equals(user.getRole())) { %>
            <a href="${pageContext.request.contextPath}/search" class="sidenav-item">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                Book Service
            </a>
            <% } %>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout" class="sidenav-item">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                Sign out
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="dash-main">
        <div class="dash-head animate-in">
            <div>
                <h1>Welcome back, <%= user.getFullName() %></h1>
                <div class="sub">Here is a quick overview of your account.</div>
            </div>
            <% if ("client".equals(user.getRole())) { %>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Book New Appointment</a>
            <% } %>
        </div>

        <div class="card animate-in animate-in-delay-1" style="padding: 30px; text-align: center; margin-top: 20px;">
            <div style="font-size: 48px; margin-bottom: 15px;">&#128197;</div>
            <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 8px;">No upcoming appointments</h3>
            <p class="muted" style="max-width: 400px; margin: 0 auto; line-height: 1.5;">
                <% if ("client".equals(user.getRole())) { %>
                    You don't have any services booked yet. Browse local businesses and book your first appointment today!
                <% } else { %>
                    Your schedule is clear. Check back later for upcoming client appointments.
                <% } %>
            </p>
        </div>
    </main>
</div>
</body>
</html>
