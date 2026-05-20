<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="model.Appointment, model.User" %>
<%@ page import="dao.AppointmentDAO" %>
<%
    User owner = (User) session.getAttribute("user");
    if (owner == null || !"owner".equals(owner.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    Object bizIdObj = session.getAttribute("businessId");
    int businessId = (bizIdObj != null) ? (int) bizIdObj : 0;

    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> all = appointmentDAO.getAppointmentsByBusiness(businessId);

    String filterStatus = request.getParameter("status");
    if (filterStatus == null) filterStatus = "all";

    List<Appointment> appointments = new ArrayList<>();
    int total = 0, pending = 0, confirmed = 0, completed = 0, cancelled = 0;
    for (Appointment a : all) {
        total++;
        String s = a.getStatus() != null ? a.getStatus().toLowerCase() : "";
        if ("pending".equals(s))   pending++;
        if ("confirmed".equals(s)) confirmed++;
        if ("completed".equals(s)) completed++;
        if ("cancelled".equals(s)) cancelled++;
        if ("all".equals(filterStatus) || filterStatus.equalsIgnoreCase(s)) appointments.add(a);
    }

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<div class="dash">
  <aside class="sidebar">
    <div class="sidebar-brand">
      <a href="<%= ctx %>/" class="brand"><div class="brand-mark"></div><span>SlotSync</span></a>
      <div class="badge badge-blue" style="margin-top:10px;font-size:11px">Owner Portal</div>
    </div>
    <nav class="col gap-2">
      <div class="sidebar-section">My Business</div>
      <a href="<%= ctx %>/views/owner/dashboard.jsp"        class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>Overview</a>
      <a href="<%= ctx %>/views/owner/manage-services.jsp"  class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2M3 13h18"/></svg>Services</a>
      <a href="<%= ctx %>/views/owner/manage-employees.jsp" class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>Employees</a>
      <a href="<%= ctx %>/views/owner/appointments.jsp"     class="sidenav-item active">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>Appointments</a>
      <a href="<%= ctx %>/views/owner/settings.jsp"         class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>Settings</a>
    </nav>
    <div class="sidebar-foot">
      <a href="<%= ctx %>/logout" class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>Sign out</a>
    </div>
  </aside>

  <main class="dash-main">
    <div class="dash-head">
      <div>
        <h1>Appointments</h1>
        <div class="sub"><%= total %> total &middot; showing <%= appointments.size() %></div>
      </div>
    </div>

    <% if (successMsg != null) { %>
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= successMsg %></div>
    <% } %>

    <div class="stat-row" style="margin-bottom:20px">
      <div class="stat-card"><div class="stat-label">Total</div><div class="stat-value mono"><%= total %></div></div>
      <div class="stat-card"><div class="stat-label">Pending</div><div class="stat-value mono"><%= pending %></div></div>
      <div class="stat-card"><div class="stat-label">Confirmed</div><div class="stat-value mono"><%= confirmed %></div></div>
      <div class="stat-card"><div class="stat-label">Completed</div><div class="stat-value mono"><%= completed %></div></div>
    </div>

    <div class="card">
      <div class="row gap-2 items-center" style="padding:14px 18px;border-bottom:1px solid var(--border);flex-wrap:wrap">
        <% String[] statuses = {"all","pending","confirmed","completed","cancelled"}; %>
        <% for (String s : statuses) { %>
        <a href="?status=<%= s %>"
           class="btn btn-sm <%= s.equals(filterStatus) ? "btn-primary" : "btn-secondary" %>"
           style="text-transform:capitalize"><%= s %></a>
        <% } %>
      </div>

      <% if (appointments.isEmpty()) { %>
      <div style="padding:40px;text-align:center;color:var(--text-2);font-size:14px">No appointments found for this filter.</div>
      <% } else { %>
      <table class="table">
        <thead><tr><th>Client</th><th>Service</th><th>Employee</th><th>Date</th><th>Time</th><th>Status</th><th style="text-align:right">Actions</th></tr></thead>
        <tbody>
        <% for (Appointment a : appointments) {
               String st = a.getStatus() != null ? a.getStatus().toLowerCase() : "";
               String badgeCls = "confirmed".equals(st) ? "badge-blue" : "completed".equals(st) ? "badge-green" : "pending".equals(st) ? "badge-amber" : "badge-red";
        %>
        <tr class="hov">
          <td style="font-weight:500"><%= a.getClientName() != null ? a.getClientName() : "—" %></td>
          <td><%= a.getServiceName() != null ? a.getServiceName() : "—" %></td>
          <td><%= a.getEmployeeName() != null ? a.getEmployeeName() : "—" %></td>
          <td><%= a.getAppointmentDate() %></td>
          <td class="mono small"><%= a.getStartTime() %></td>
          <td><span class="badge <%= badgeCls %>"><span class="badge-dot"></span><%= a.getStatus() %></span></td>
          <td style="text-align:right">
            <% if ("pending".equals(st)) { %>
            <form style="display:inline" action="<%= ctx %>/appointment" method="post">
              <input type="hidden" name="action"        value="updateStatus">
              <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">
              <input type="hidden" name="status"        value="confirmed">
              <button class="btn btn-success btn-sm" type="submit">Confirm</button>
            </form>
            <% } %>
            <% if (!"cancelled".equals(st) && !"completed".equals(st)) { %>
            <form style="display:inline" action="<%= ctx %>/appointment" method="post"
                  onsubmit="return confirm('Cancel this appointment?')">
              <input type="hidden" name="action"        value="updateStatus">
              <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">
              <input type="hidden" name="status"        value="cancelled">
              <button class="btn btn-danger btn-sm" type="submit">Cancel</button>
            </form>
            <% } %>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
      <% } %>
    </div>
  </main>
</div>
</body>
</html>
