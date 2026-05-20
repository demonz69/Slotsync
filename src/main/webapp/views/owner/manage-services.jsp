<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Service, model.Business, model.User" %>
<%@ page import="dao.ServiceDAO, dao.BusinessDAO" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"owner".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    ServiceDAO  serviceDAO  = new ServiceDAO();
    BusinessDAO businessDAO = new BusinessDAO();
    List<Business> businesses = businessDAO.getBusinessesByOwner(currentUser.getUserId());

    int selectedBizId = 0;
    try { selectedBizId = Integer.parseInt(request.getParameter("businessId")); } catch (Exception e) {}
    if (selectedBizId == 0 && !businesses.isEmpty()) selectedBizId = businesses.get(0).getBusinessId();

    List<Service> services = serviceDAO.getServicesByBusiness(selectedBizId);

    Service editService = null;
    if ("edit".equals(request.getParameter("action"))) {
        try { editService = serviceDAO.getServiceById(Integer.parseInt(request.getParameter("id"))); } catch (Exception e) {}
    }

    String successParam = request.getParameter("success"), errorParam = request.getParameter("error");
    String successMsg = "created".equals(successParam) ? "Service added." : "updated".equals(successParam) ? "Service updated." : "deleted".equals(successParam) ? "Service deleted." : null;
    String errorMsg   = errorParam != null ? "Operation failed. Check your input." : null;
    String uri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        .form-grid .full { grid-column:1/-1; }
        @media(max-width:640px){ .form-grid { grid-template-columns:1fr; } .form-grid .full { grid-column:1; } }
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
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
        Overview</a>
      <a href="<%= ctx %>/views/owner/manage-services.jsp"  class="sidenav-item active">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2M3 13h18"/></svg>
        Services</a>
      <a href="<%= ctx %>/views/owner/manage-employees.jsp" class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>
        Employees</a>
      <a href="<%= ctx %>/views/owner/appointments.jsp"     class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>
        Appointments</a>
      <a href="<%= ctx %>/views/owner/settings.jsp"         class="sidenav-item">
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
        <h1>Services</h1>
        <div class="sub"><%= services.size() %> service<%= services.size() != 1 ? "s" : "" %> available for booking</div>
      </div>
    </div>

    <% if (successMsg != null) { %>
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div style="background:var(--red-50);border:1px solid #fecaca;color:#b91c1c;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= errorMsg %></div>
    <% } %>

    <%-- Business tabs --%>
    <% if (businesses.size() > 1) { %>
    <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:20px">
      <% for (Business biz : businesses) { %>
      <a href="?businessId=<%= biz.getBusinessId() %>"
         class="btn <%= biz.getBusinessId() == selectedBizId ? "btn-primary" : "btn-secondary" %> btn-sm">
        <%= biz.getBusinessName() %>
      </a>
      <% } %>
    </div>
    <% } %>

    <%-- Add / Edit form --%>
    <div class="card card-pad" style="margin-bottom:20px">
      <h3 class="h3" style="margin-bottom:16px"><%= editService != null ? "Edit Service" : "Add New Service" %></h3>
      <form action="<%= ctx %>/services" method="post" onsubmit="return validateSvcForm()">
        <input type="hidden" name="action" value="<%= editService != null ? "update" : "create" %>">
        <% if (editService != null) { %>
        <input type="hidden" name="serviceId" value="<%= editService.getServiceId() %>">
        <% } else { %>
        <input type="hidden" name="businessId" value="<%= selectedBizId %>">
        <% } %>
        <div class="form-grid">
          <div class="field">
            <label>Service Name</label>
            <input class="input" type="text" name="serviceName" required placeholder="e.g. Haircut &amp; Blow Dry"
                   value="<%= editService != null ? editService.getServiceName() : "" %>">
          </div>
          <div class="field">
            <label>Category</label>
            <select class="select" name="categoryId" required>
              <option value="">-- Select --</option>
              <option value="1" <%= editService != null && editService.getCategoryId()==1 ? "selected" : "" %>>Hair</option>
              <option value="2" <%= editService != null && editService.getCategoryId()==2 ? "selected" : "" %>>Wellness</option>
              <option value="3" <%= editService != null && editService.getCategoryId()==3 ? "selected" : "" %>>Skin</option>
              <option value="4" <%= editService != null && editService.getCategoryId()==4 ? "selected" : "" %>>Auto</option>
              <option value="5" <%= editService != null && editService.getCategoryId()==5 ? "selected" : "" %>>Beauty</option>
            </select>
          </div>
          <div class="field">
            <label>Duration (minutes)</label>
            <input class="input" type="number" name="durationMin" min="5" max="480" required placeholder="e.g. 45"
                   value="<%= editService != null ? editService.getDurationMin() : "" %>">
          </div>
          <div class="field">
            <label>Price (&pound;)</label>
            <input class="input" type="number" name="price" min="0" step="0.01" required placeholder="e.g. 25.00"
                   value="<%= editService != null ? editService.getPrice() : "" %>">
          </div>
          <div class="field full">
            <label>Description <span class="muted small">(optional)</span></label>
            <textarea class="textarea" name="description" style="min-height:72px" placeholder="Brief description..."><%= editService != null && editService.getDescription() != null ? editService.getDescription() : "" %></textarea>
          </div>
        </div>
        <div class="row gap-3" style="margin-top:16px">
          <button class="btn btn-primary" type="submit"><%= editService != null ? "Save changes" : "Add service" %></button>
          <% if (editService != null) { %>
          <a href="<%= ctx %>/views/owner/manage-services.jsp?businessId=<%= selectedBizId %>" class="btn btn-secondary">Cancel</a>
          <% } %>
        </div>
      </form>
    </div>

    <%-- Services table --%>
    <div class="card">
      <div style="padding:18px 22px;border-bottom:1px solid var(--border)">
        <h3 class="h3">Current Services (<%= services.size() %>)</h3>
      </div>
      <% if (services.isEmpty()) { %>
      <div style="padding:40px;text-align:center;color:var(--text-2);font-size:14px">No services yet. Use the form above to add one.</div>
      <% } else { %>
      <table class="table">
        <thead><tr><th>Name</th><th>Category</th><th>Duration</th><th style="text-align:right">Price</th><th>Status</th><th style="text-align:right">Actions</th></tr></thead>
        <tbody>
        <% int i = 1; for (Service svc : services) { %>
        <tr class="hov">
          <td style="font-weight:500">
            <%= svc.getServiceName() %>
            <% if (svc.getDescription() != null && !svc.getDescription().isEmpty()) { %>
            <div class="muted tiny"><%= svc.getDescription().length() > 55 ? svc.getDescription().substring(0,55)+"…" : svc.getDescription() %></div>
            <% } %>
          </td>
          <td><%= svc.getCategoryName() != null ? svc.getCategoryName() : "—" %></td>
          <td class="mono small"><%= svc.getDurationMin() %> min</td>
          <td class="mono" style="text-align:right;font-weight:500">&pound;<%= String.format("%.2f", svc.getPrice()) %></td>
          <td><span class="badge <%= svc.isActive() ? "badge-green" : "badge-red" %>"><span class="badge-dot"></span><%= svc.isActive() ? "Active" : "Inactive" %></span></td>
          <td style="text-align:right">
            <div class="row gap-2" style="justify-content:flex-end">
              <a href="<%= ctx %>/views/owner/manage-services.jsp?action=edit&id=<%= svc.getServiceId() %>&businessId=<%= selectedBizId %>" class="btn btn-secondary btn-sm">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 20h4L20 8l-4-4L4 16v4z"/></svg>
                Edit</a>
              <form style="display:inline" action="<%= ctx %>/services" method="post"
                    onsubmit="return confirm('Delete this service?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="serviceId" value="<%= svc.getServiceId() %>">
                <button class="btn btn-danger btn-sm" type="submit">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h16M9 7V4h6v3M6 7l1 13a2 2 0 002 2h6a2 2 0 002-2l1-13"/></svg>
                </button>
              </form>
            </div>
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
function validateSvcForm() {
  var n = document.querySelector('[name=serviceName]').value.trim();
  var c = document.querySelector('[name=categoryId]').value;
  var d = document.querySelector('[name=durationMin]').value;
  var p = document.querySelector('[name=price]').value;
  if (!n) { alert('Service name required.'); return false; }
  if (!c) { alert('Please select a category.'); return false; }
  if (!d || parseInt(d) < 5) { alert('Duration must be at least 5 minutes.'); return false; }
  if (!p || parseFloat(p) < 0) { alert('Price must be 0 or more.'); return false; }
  return true;
}
</script>
</body>
</html>
