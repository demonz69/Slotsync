<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Employee, model.User" %>
<%@ page import="dao.EmployeeDAO" %>
<%
    User owner = (User) session.getAttribute("user");
    if (owner == null || !"owner".equals(owner.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    Object bizIdObj = session.getAttribute("businessId");
    int businessId = (bizIdObj != null) ? (int) bizIdObj : 0;

    EmployeeDAO employeeDAO = new EmployeeDAO();
    List<Employee> employees = employeeDAO.getByBusinessId(businessId);

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
    <title>Employees | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        @media(max-width:640px){ .form-grid { grid-template-columns:1fr; } }
    </style>
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
      <a href="<%= ctx %>/views/owner/manage-employees.jsp" class="sidenav-item active">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>Employees</a>
      <a href="<%= ctx %>/views/owner/appointments.jsp"     class="sidenav-item">
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
        <h1>Employees</h1>
        <div class="sub"><%= employees.size() %> staff member<%= employees.size() != 1 ? "s" : "" %></div>
      </div>
    </div>

    <% if (successMsg != null) { %>
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div style="background:var(--red-50);border:1px solid #fecaca;color:#b91c1c;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= errorMsg %></div>
    <% } %>

    <div class="card card-pad" style="margin-bottom:20px">
      <h3 class="h3" style="margin-bottom:16px">Add New Employee</h3>
      <form action="<%= ctx %>/EmployeeServlet" method="post" onsubmit="return validateEmpForm()">
        <input type="hidden" name="action"     value="add">
        <input type="hidden" name="businessId" value="<%= businessId %>">
        <div class="form-grid">
          <div class="field">
            <label>User ID <span class="muted small">(employee's registered ID)</span></label>
            <input class="input" type="number" id="userId" name="userId" placeholder="e.g. 5" required>
          </div>
          <div class="field">
            <label>Designation</label>
            <input class="input" type="text" id="designation" name="designation" placeholder="e.g. Hairstylist" required>
          </div>
          <div class="field">
            <label>Phone</label>
            <input class="input" type="text" id="phone" name="phone" placeholder="e.g. 07700900000" required>
          </div>
        </div>
        <div style="margin-top:14px">
          <button class="btn btn-primary" type="submit">Add employee</button>
        </div>
      </form>
    </div>

    <div class="card">
      <div style="padding:18px 22px;border-bottom:1px solid var(--border)">
        <h3 class="h3">Current Employees (<%= employees.size() %>)</h3>
      </div>
      <% if (employees.isEmpty()) { %>
      <div style="padding:40px;text-align:center;color:var(--text-2);font-size:14px">No employees added yet.</div>
      <% } else { %>
      <table class="table">
        <thead><tr><th>#</th><th>Employee ID</th><th>User ID</th><th>Designation</th><th>Phone</th><th>Status</th><th style="text-align:right">Action</th></tr></thead>
        <tbody>
        <% int i = 1; for (Employee emp : employees) { %>
        <tr class="hov">
          <td class="muted small"><%= i++ %></td>
          <td class="mono small"><%= emp.getEmployeeId() %></td>
          <td class="mono small"><%= emp.getUserId() %></td>
          <td style="font-weight:500"><%= emp.getDesignation() %></td>
          <td><%= emp.getPhone() %></td>
          <td><span class="badge <%= "active".equals(emp.getStatus()) ? "badge-green" : "badge-red" %>"><span class="badge-dot"></span><%= emp.getStatus() %></span></td>
          <td style="text-align:right">
            <form style="display:inline" action="<%= ctx %>/EmployeeServlet" method="post"
                  onsubmit="return confirm('Remove this employee?')">
              <input type="hidden" name="action"     value="remove">
              <input type="hidden" name="employeeId" value="<%= emp.getEmployeeId() %>">
              <button class="btn btn-danger btn-sm" type="submit">Remove</button>
            </form>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
      <% } %>
    </div>
  </main>
</div>
<script>
function validateEmpForm() {
  var uid = document.getElementById('userId').value.trim();
  var des = document.getElementById('designation').value.trim();
  var ph  = document.getElementById('phone').value.trim();
  if (!uid || isNaN(uid) || parseInt(uid) <= 0) { alert('Enter a valid User ID.'); return false; }
  if (!des) { alert('Designation is required.'); return false; }
  if (!ph)  { alert('Phone is required.'); return false; }
  return true;
}
</script>
</body>
</html>
