<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.AppointmentDAO, dao.FeedbackDAO, dao.EmployeeDAO, dao.ServiceDAO" %>
<%@ page import="model.Appointment, model.User" %>
<%
    User owner = (User) session.getAttribute("user");
    if (owner == null || !"owner".equals(owner.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    Object bizIdObj = session.getAttribute("businessId");
    int businessId = (bizIdObj != null) ? (int) bizIdObj : 0;
    String ctx = request.getContextPath();

    AppointmentDAO appointmentDAO = new AppointmentDAO();
    FeedbackDAO    feedbackDAO    = new FeedbackDAO();
    EmployeeDAO    employeeDAO    = new EmployeeDAO();

    List<Appointment> allAppointments = appointmentDAO.getByBusinessId(businessId);
    double avgRating     = feedbackDAO.getAverageRating(businessId);
    int    totalReviews  = feedbackDAO.getFeedbackByBusiness(businessId).size();
    int    totalEmployees= employeeDAO.getByBusinessId(businessId).size();
    int    totalBookings = allAppointments.size();

    double totalRevenue = 0; int completedCount = 0, pendingCount = 0, cancelledCount = 0;
    for (Appointment a : allAppointments) {
        if ("completed".equalsIgnoreCase(a.getStatus()))     { totalRevenue += a.getPrice(); completedCount++; }
        else if ("pending".equalsIgnoreCase(a.getStatus()) || "confirmed".equalsIgnoreCase(a.getStatus())) pendingCount++;
        else if ("cancelled".equalsIgnoreCase(a.getStatus())) cancelledCount++;
    }
    List<Appointment> recent = allAppointments.subList(0, Math.min(5, allAppointments.size()));
    String uri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | SlotSync</title>
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
      <a href="<%= ctx %>/views/owner/dashboard.jsp"        class="sidenav-item <%= uri.contains("owner/dashboard")        ? "active" : "" %>">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
        Overview</a>
      <a href="<%= ctx %>/views/owner/manage-services.jsp"  class="sidenav-item <%= uri.contains("manage-services")        ? "active" : "" %>">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2M3 13h18"/></svg>
        Services</a>
      <a href="<%= ctx %>/views/owner/manage-employees.jsp" class="sidenav-item <%= uri.contains("manage-employees")       ? "active" : "" %>">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>
        Employees</a>
      <a href="<%= ctx %>/views/owner/appointments.jsp"     class="sidenav-item <%= uri.contains("appointments")          ? "active" : "" %>">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>
        Appointments</a>
      <a href="<%= ctx %>/views/owner/settings.jsp"         class="sidenav-item <%= uri.contains("settings")             ? "active" : "" %>">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
        Settings</a>
    </nav>
    <div class="sidebar-foot">
      <a href="<%= ctx %>/logout" class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
        Sign out</a>
    </div>
  </aside>

  <main class="dash-main">
    <div class="dash-head">
      <div>
        <h1>Dashboard</h1>
        <div class="sub">Welcome back, <%= owner.getFullName() %>. Here's your business at a glance.</div>
      </div>
      <a href="<%= ctx %>/views/owner/appointments.jsp" class="btn btn-secondary btn-sm">View all appointments</a>
    </div>

    <div class="stat-row">
      <div class="stat-card">
        <div class="stat-label">Total Bookings</div>
        <div class="stat-value mono"><%= totalBookings %></div>
        <div class="stat-delta flat"><%= completedCount %> completed</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Revenue</div>
        <div class="stat-value mono">&pound;<%= String.format("%.2f", totalRevenue) %></div>
        <div class="stat-delta flat">from completed bookings</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Employees</div>
        <div class="stat-value mono"><%= totalEmployees %></div>
        <div class="stat-delta flat">active staff</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Avg Rating</div>
        <div class="stat-value mono"><%= avgRating > 0 ? String.format("%.1f", avgRating) : "—" %></div>
        <div class="stat-delta flat"><%= totalReviews %> reviews</div>
      </div>
    </div>

    <div class="card" style="margin-bottom:20px">
      <div class="between" style="padding:18px 22px;border-bottom:1px solid var(--border)">
        <div>
          <h3 class="h3">Recent Appointments</h3>
          <div class="muted small" style="margin-top:2px">Last <%= recent.size() %> bookings</div>
        </div>
        <a href="<%= ctx %>/views/owner/appointments.jsp" class="btn btn-secondary btn-sm">View all</a>
      </div>
      <% if (recent.isEmpty()) { %>
      <div style="padding:40px;text-align:center;color:var(--text-2)">No appointments yet.</div>
      <% } else { %>
      <table class="table">
        <thead><tr><th>Client</th><th>Service</th><th>Employee</th><th>Date</th><th>Time</th><th>Status</th></tr></thead>
        <tbody>
        <% for (Appointment a : recent) { %>
          <tr class="hov">
            <td style="font-weight:500"><%= a.getClientName() != null ? a.getClientName() : "—" %></td>
            <td><%= a.getServiceName() != null ? a.getServiceName() : "—" %></td>
            <td><%= a.getEmployeeName() != null ? a.getEmployeeName() : "—" %></td>
            <td><%= a.getAppointmentDate() %></td>
            <td class="mono small"><%= a.getStartTime() %></td>
            <td>
              <% String st = a.getStatus().toLowerCase(); %>
              <span class="badge <%= "completed".equals(st) ? "badge-green" : "confirmed".equals(st) ? "badge-blue" : "pending".equals(st) ? "badge-amber" : "badge-red" %>">
                <span class="badge-dot"></span><%= a.getStatus() %>
              </span>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

    <div class="stat-row" style="grid-template-columns:repeat(3,1fr)">
      <div class="stat-card">
        <div class="stat-label">Pending / Confirmed</div>
        <div class="stat-value mono"><%= pendingCount %></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Completed</div>
        <div class="stat-value mono"><%= completedCount %></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Cancelled</div>
        <div class="stat-value mono"><%= cancelledCount %></div>
      </div>
    </div>
  </main>
</div>
</body>
</html>
