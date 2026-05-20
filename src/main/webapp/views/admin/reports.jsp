<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%@ page import="model.User" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports | SlotSync Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px; }
        @media(max-width:900px){ .grid-2 { grid-template-columns:1fr; } }
    </style>
</head>
<body>
<div class="dash">
  <aside class="sidebar" id="admin-sidebar">
    <div class="sidebar-brand">
      <a href="<%= ctx %>/" class="brand"><div class="brand-mark"></div><span>SlotSync</span></a>
      <div class="badge badge-blue" style="margin-top:10px;font-size:11px">
        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
        Admin Panel
      </div>
    </div>
    <nav class="col gap-2">
      <div class="sidebar-section">Operations</div>
      <a href="<%= ctx %>/views/admin/dashboard.jsp"        class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>Overview</a>
      <a href="<%= ctx %>/views/admin/manage-businesses.jsp" class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9h18M9 21V9M3 9l2-5h14l2 5M3 9a2 2 0 000 4v7a1 1 0 001 1h16a1 1 0 001-1v-7a2 2 0 000-4"/></svg>Manage Businesses</a>
      <a href="<%= ctx %>/views/admin/manage-users.jsp"     class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>Manage Users</a>
      <a href="<%= ctx %>/views/admin/reports.jsp"          class="sidenav-item active">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3v18h18"/><path d="M7 16l4-4 4 4 4-4"/></svg>Reports</a>
    </nav>
    <div class="sidebar-foot">
      <a href="<%= ctx %>/logout" class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>Sign out</a>
    </div>
  </aside>

  <main class="dash-main">
    <div class="dash-head">
      <div>
        <h1>Analytics &amp; Reports</h1>
        <div class="sub">Live data from your SlotSync database.</div>
      </div>
    </div>

    <div class="stat-row" style="margin-bottom:24px">
      <div class="stat-card">
        <div class="stat-label">Total Appointments</div>
        <div class="stat-value mono">${not empty totalAppointments ? totalAppointments : '—'}</div>
        <div class="stat-delta flat">all time</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Completed</div>
        <div class="stat-value mono">${not empty completedAppointments ? completedAppointments : '—'}</div>
        <div class="stat-delta up">successfully served</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Active Users</div>
        <div class="stat-value mono">${not empty totalActiveUsers ? totalActiveUsers : '—'}</div>
        <div class="stat-delta flat">registered &amp; active</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Revenue</div>
        <div class="stat-value mono">&pound;<c:choose><c:when test="${not empty totalRevenue}"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></c:when><c:otherwise>0.00</c:otherwise></c:choose></div>
        <div class="stat-delta flat">from completed bookings</div>
      </div>
    </div>

    <div class="grid-2">
      <div class="card">
        <div class="between" style="padding:18px 22px;border-bottom:1px solid var(--border)">
          <div><h3 class="h3">Popular Services</h3><div class="muted small" style="margin-top:2px">By completed bookings</div></div>
        </div>
        <table class="table">
          <thead><tr><th>#</th><th>Service</th><th style="text-align:right">Bookings</th><th style="text-align:right">Revenue</th></tr></thead>
          <tbody>
          <c:choose>
            <c:when test="${empty popularServices}">
              <tr><td colspan="4" style="padding:32px;text-align:center;color:var(--text-2)">No data yet.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="s" items="${popularServices}" varStatus="st">
              <tr class="hov">
                <td class="muted small">${st.count}</td>
                <td style="font-weight:500">${s.service_name}</td>
                <td class="mono" style="text-align:right">${s.total_bookings}</td>
                <td class="mono" style="text-align:right">&pound;${s.revenue}</td>
              </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>

      <div class="card">
        <div class="between" style="padding:18px 22px;border-bottom:1px solid var(--border)">
          <div><h3 class="h3">Top Employees</h3><div class="muted small" style="margin-top:2px">By appointments handled</div></div>
        </div>
        <table class="table">
          <thead><tr><th>#</th><th>Name</th><th>Role</th><th style="text-align:right">Total</th></tr></thead>
          <tbody>
          <c:choose>
            <c:when test="${empty topEmployees}">
              <tr><td colspan="4" style="padding:32px;text-align:center;color:var(--text-2)">No data yet.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="e" items="${topEmployees}" varStatus="st">
              <tr class="hov">
                <td class="muted small">${st.count}</td>
                <td style="font-weight:500">${e.name}</td>
                <td class="muted">${e.specialization}</td>
                <td class="mono" style="text-align:right;font-weight:600">${e.total}</td>
              </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <div class="card" style="margin-bottom:20px">
      <div style="padding:18px 22px;border-bottom:1px solid var(--border)">
        <h3 class="h3">Appointments by Status</h3>
      </div>
      <table class="table">
        <thead><tr><th>Status</th><th style="text-align:right">Count</th></tr></thead>
        <tbody>
        <c:choose>
          <c:when test="${empty appointmentsByStatus}">
            <tr><td colspan="2" style="padding:32px;text-align:center;color:var(--text-2)">No data yet.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="row" items="${appointmentsByStatus}">
            <tr class="hov">
              <td>
                <c:choose>
                  <c:when test="${row.status == 'completed'}"><span class="badge badge-green"><span class="badge-dot"></span>completed</span></c:when>
                  <c:when test="${row.status == 'confirmed'}"><span class="badge badge-blue"><span class="badge-dot"></span>confirmed</span></c:when>
                  <c:when test="${row.status == 'pending'}"><span class="badge badge-amber"><span class="badge-dot"></span>pending</span></c:when>
                  <c:otherwise><span class="badge badge-red"><span class="badge-dot"></span>${row.status}</span></c:otherwise>
                </c:choose>
              </td>
              <td class="mono" style="text-align:right;font-weight:600">${row.count}</td>
            </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
  </main>
</div>
</body>
</html>
