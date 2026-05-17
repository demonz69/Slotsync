<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Business, dao.BusinessDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp"); return; }
    if (!"admin".equals(user.getRole())) { response.sendRedirect(request.getContextPath() + "/views/user/home.jsp"); return; }
    BusinessDAO bizDAO = new BusinessDAO();
    List<Business> businesses = bizDAO.getAllBusinesses();
    int totalBiz = businesses.size();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Businesses | SlotSync Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .biz-cell{display:flex;align-items:center;gap:11px}
        .biz-cell-icon{width:32px;height:32px;border-radius:7px;flex-shrink:0;background:var(--bg-alt);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:14px}
        .biz-cell-name{font-weight:600;font-size:14px;color:var(--text)}
        .action-group{display:flex;gap:6px;justify-content:flex-end}
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
            <a href="${pageContext.request.contextPath}/views/admin/manage-businesses.jsp" class="sidenav-item active" id="sidenav-businesses">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9h18M9 21V9M3 9l2-5h14l2 5M3 9a2 2 0 000 4v7a1 1 0 001 1h16a1 1 0 001-1v-7a2 2 0 000-4"/></svg>
                Manage Businesses
            </a>
            <a href="${pageContext.request.contextPath}/views/admin/manage-users.jsp" class="sidenav-item" id="sidenav-users">
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
            <div><h1>Manage businesses</h1><div class="sub"><%= totalBiz %> business<%= totalBiz != 1 ? "es" : "" %> on the platform</div></div>
        </div>
        <% if ("approve".equals(msg)) { %><div class="msg-success animate-in" id="msg-box">Business approved.</div>
        <% } else if ("suspend".equals(msg)) { %><div class="msg-error animate-in" id="msg-box">Business suspended.</div>
        <% } else if ("reject".equals(msg) || "delete".equals(msg)) { %><div class="msg-error animate-in" id="msg-box">Business removed.</div><% } %>
        <div class="card animate-in animate-in-delay-1" id="card-businesses-table">
            <table class="table" id="table-businesses">
                <thead><tr><th>Business</th><th style="color:var(--blue-700)">Owner</th><th>Address</th><th>Status</th><th style="text-align:right">Actions</th></tr></thead>
                <tbody>
                <% if (businesses.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;color:var(--text-2);padding:40px">No businesses registered yet.</td></tr>
                <% } else {
                    String[] icons = {"&#9986;","&#127807;","&#128295;","&#128134;","&#127947;","&#128133;"};
                    int idx = 0;
                    for (Business b : businesses) {
                        String status = b.getStatus() != null ? b.getStatus() : "active";
                        String icon = icons[idx % icons.length]; idx++;
                %>
                    <tr class="hov" id="biz-row-<%= b.getBusinessId() %>">
                        <td><div class="biz-cell"><div class="biz-cell-icon"><%= icon %></div><span class="biz-cell-name"><%= b.getName() != null ? b.getName() : "&#8212;" %></span></div></td>
                        <td style="color:var(--blue);font-size:14px"><%= b.getOwnerName() != null ? b.getOwnerName() : "&#8212;" %></td>
                        <td style="font-size:14px;color:var(--text-2)"><%= b.getAddress() != null ? b.getAddress() : "&#8212;" %></td>
                        <td>
                            <% if ("active".equals(status)) { %><span class="badge badge-green" id="biz-status-<%= b.getBusinessId() %>"><span class="badge-dot"></span> active</span>
                            <% } else if ("pending".equals(status)) { %><span class="badge badge-amber" id="biz-status-<%= b.getBusinessId() %>"><span class="badge-dot"></span> pending</span>
                            <% } else { %><span class="badge" id="biz-status-<%= b.getBusinessId() %>"><span class="badge-dot"></span> <%= status %></span><% } %>
                        </td>
                        <td><div class="action-group">
                            <% if ("active".equals(status)) { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/business/suspend" style="display:inline">
                                    <input type="hidden" name="id" value="<%= b.getBusinessId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" id="btn-suspend-<%= b.getBusinessId() %>">Suspend</button>
                                </form>
                            <% } else if ("pending".equals(status)) { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/business/approve" style="display:inline">
                                    <input type="hidden" name="id" value="<%= b.getBusinessId() %>">
                                    <button type="submit" class="btn btn-success btn-sm" id="btn-approve-<%= b.getBusinessId() %>">&#10003; Approve</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/business/reject" style="display:inline">
                                    <input type="hidden" name="id" value="<%= b.getBusinessId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" id="btn-reject-<%= b.getBusinessId() %>">&#10007; Reject</button>
                                </form>
                            <% } else { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/business/approve" style="display:inline">
                                    <input type="hidden" name="id" value="<%= b.getBusinessId() %>">
                                    <button type="submit" class="btn btn-success btn-sm" id="btn-reactivate-<%= b.getBusinessId() %>">Reactivate</button>
                                </form>
                            <% } %>
                        </div></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </main>
</div>
</body>
</html>
