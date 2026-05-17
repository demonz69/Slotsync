<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, dao.UserDAO, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp"); return; }
    if (!"admin".equals(currentUser.getRole())) { response.sendRedirect(request.getContextPath() + "/views/user/home.jsp"); return; }
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAllUsers();
    int totalUsers = users.size();
    int pendingUsers = userDAO.countByStatus("pending");
    String msg = request.getParameter("msg");
    String filterRole = request.getParameter("role"); if (filterRole == null) filterRole = "All";
    String searchQ = request.getParameter("q"); if (searchQ == null) searchQ = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | SlotSync Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .user-cell{display:flex;align-items:center;gap:11px}
        .user-initials{width:34px;height:34px;border-radius:50%;flex-shrink:0;background:var(--blue-50);color:var(--blue-700);border:1px solid #bfdbfe;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700}
        .user-cell-name{font-weight:500;font-size:14px}
        .role-badge{display:inline-block;padding:2px 10px;border-radius:999px;font-size:12px;font-weight:500;border:1px solid}
        .role-client{background:var(--bg-alt);color:var(--text-2);border-color:var(--border-strong)}
        .role-owner{background:var(--blue-50);color:var(--blue-700);border-color:#bfdbfe}
        .role-employee{background:var(--green-50);color:#15803d;border-color:#bbf7d0}
        .role-admin{background:#f5f3ff;color:#5b21b6;border-color:#ddd6fe}
        .filter-bar{display:flex;gap:12px;align-items:center;padding:14px 16px;border-bottom:1px solid var(--border)}
        .filter-bar input[type=text]{flex:1;padding:9px 12px 9px 36px;border:1px solid var(--border);border-radius:6px;font-size:14px;color:var(--text);background:white;outline:none}
        .filter-bar input[type=text]:focus{border-color:var(--blue);box-shadow:0 0 0 3px var(--blue-50)}
        .filter-bar select{padding:9px 32px 9px 12px;border:1px solid var(--border);border-radius:6px;font-size:14px;color:var(--text);background:white;outline:none;min-width:100px;cursor:pointer}
        .action-group{display:flex;gap:6px;justify-content:flex-end}
        .search-wrap{position:relative;flex:1}
        .search-wrap .ic{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--text-3);pointer-events:none}
    </style>
</head>
<body>
<div class="dash">
    <aside class="sidebar" id="admin-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/" class="brand" id="nav-brand"><div class="brand-mark"></div><span>SlotSync</span></a>
            <div class="badge badge-blue" style="margin-top:10px;font-size:11px">Admin Panel</div>
        </div>
        <nav class="col gap-2">
            <div class="sidebar-section">Operations</div>
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="sidenav-item" id="sidenav-overview">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Overview
            </a>
            <a href="${pageContext.request.contextPath}/views/admin/manage-businesses.jsp" class="sidenav-item" id="sidenav-businesses">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9h18M9 21V9M3 9l2-5h14l2 5M3 9a2 2 0 000 4v7a1 1 0 001 1h16a1 1 0 001-1v-7a2 2 0 000-4"/></svg>
                Manage Businesses
            </a>
            <a href="${pageContext.request.contextPath}/views/admin/manage-users.jsp" class="sidenav-item active" id="sidenav-users">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>
                Manage Users
            </a>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout" class="sidenav-item" id="sidenav-logout">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                Sign out
            </a>
        </div>
    </aside>
    <main class="dash-main" id="admin-main">
        <div class="dash-head animate-in">
            <div><h1>Manage users</h1>
                <div class="sub"><span><%= totalUsers %> total</span><% if (pendingUsers > 0) { %>&nbsp;&middot;&nbsp;<span style="color:var(--amber)"><%= pendingUsers %> pending</span><% } %></div>
            </div>
        </div>
        <% if ("activate".equals(msg)) { %><div class="msg-success animate-in" id="msg-box">User activated.</div>
        <% } else if ("deactivate".equals(msg)) { %><div class="msg-error animate-in" id="msg-box">User suspended.</div>
        <% } else if ("delete".equals(msg)) { %><div class="msg-error animate-in" id="msg-box">User deleted.</div><% } %>
        <div class="card animate-in animate-in-delay-1" id="card-users-table">
            <form method="get" action="" id="filter-form">
                <div class="filter-bar">
                    <div class="search-wrap">
                        <svg class="ic" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" name="q" id="search-users" placeholder="Search by name or email..." value="<%= searchQ %>">
                    </div>
                    <select name="role" id="filter-role" onchange="document.getElementById('filter-form').submit()">
                        <option value="All" <%= "All".equals(filterRole) ? "selected" : "" %>>All</option>
                        <option value="client"   <%= "client".equals(filterRole)   ? "selected" : "" %>>Client</option>
                        <option value="owner"    <%= "owner".equals(filterRole)    ? "selected" : "" %>>Owner</option>
                        <option value="employee" <%= "employee".equals(filterRole) ? "selected" : "" %>>Employee</option>
                        <option value="admin"    <%= "admin".equals(filterRole)    ? "selected" : "" %>>Admin</option>
                    </select>
                </div>
            </form>
            <table class="table" id="table-users">
                <thead><tr><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th style="text-align:right">Actions</th></tr></thead>
                <tbody id="users-tbody">
                <% if (users.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;color:var(--text-2);padding:40px">No users found.</td></tr>
                <% } else {
                    for (User u : users) {
                        String uName = u.getFullName() != null ? u.getFullName() : "?";
                        String uInitials = "";
                        for (String part : uName.split(" ")) {
                            if (!part.isEmpty()) uInitials += part.charAt(0);
                            if (uInitials.length() >= 2) break;
                        }
                        String uRole   = u.getRole()   != null ? u.getRole()   : "client";
                        String uStatus = u.getStatus() != null ? u.getStatus() : "active";
                        String uEmail  = u.getEmail()  != null ? u.getEmail()  : "&#8212;";
                        if (!"All".equals(filterRole) && !filterRole.equals(uRole)) continue;
                        String sq = searchQ.toLowerCase();
                        if (!sq.isEmpty() && !uName.toLowerCase().contains(sq) && !uEmail.toLowerCase().contains(sq)) continue;
                        String roleCls;
                        if ("owner".equals(uRole)) { roleCls = "role-owner"; }
                        else if ("employee".equals(uRole)) { roleCls = "role-employee"; }
                        else if ("admin".equals(uRole)) { roleCls = "role-admin"; }
                        else { roleCls = "role-client"; }
                        String safeName = uName.replace("'", "");
                        String roleLabel = uRole.substring(0,1).toUpperCase() + uRole.substring(1);
                %>
                    <tr class="hov" id="user-row-<%= u.getUserId() %>">
                        <td><div class="user-cell"><div class="user-initials"><%= uInitials.toUpperCase() %></div><span class="user-cell-name"><%= uName %></span></div></td>
                        <td style="font-size:14px;color:var(--blue)"><%= uEmail %></td>
                        <td><span class="role-badge <%= roleCls %>"><%= roleLabel %></span></td>
                        <td>
                            <% if ("active".equals(uStatus)) { %><span class="badge badge-green" id="user-status-<%= u.getUserId() %>"><span class="badge-dot"></span> active</span>
                            <% } else if ("pending".equals(uStatus)) { %><span class="badge badge-amber" id="user-status-<%= u.getUserId() %>"><span class="badge-dot"></span> pending</span>
                            <% } else { %><span class="badge badge-red" id="user-status-<%= u.getUserId() %>"><span class="badge-dot"></span> <%= uStatus %></span><% } %>
                        </td>
                        <td><div class="action-group">
                            <% if (!"active".equals(uStatus)) { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/user/activate" style="display:inline">
                                    <input type="hidden" name="id" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-success btn-sm" id="btn-activate-<%= u.getUserId() %>">Activate</button>
                                </form>
                            <% } else { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/user/deactivate" style="display:inline">
                                    <input type="hidden" name="id" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-secondary btn-sm" id="btn-deactivate-<%= u.getUserId() %>">Suspend</button>
                                </form>
                            <% } %>
                            <form method="post" action="${pageContext.request.contextPath}/admin/user/delete" style="display:inline" class="delete-user-form">
                                <input type="hidden" name="id" value="<%= u.getUserId() %>">
                                <button type="submit" class="btn btn-danger btn-sm" data-name="<%= safeName %>" id="btn-delete-<%= u.getUserId() %>">Delete</button>
                            </form>
                        </div></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </main>
</div>
<script>
    document.getElementById('search-users').addEventListener('input', function() {
        var q = this.value.toLowerCase();
        var rows = document.getElementById('users-tbody').getElementsByTagName('tr');
        for (var i = 0; i < rows.length; i++) {
            rows[i].style.display = (rows[i].textContent.toLowerCase().indexOf(q) > -1) ? '' : 'none';
        }
    });
    var deleteForms = document.getElementsByClassName('delete-user-form');
    for (var d = 0; d < deleteForms.length; d++) {
        deleteForms[d].addEventListener('submit', function(e) {
            var btn = this.querySelector('button[data-name]');
            var name = btn ? btn.getAttribute('data-name') : 'this user';
            if (!confirm('Delete ' + name + '? This cannot be undone.')) { e.preventDefault(); }
        });
    }
</script>
</body>
</html>
