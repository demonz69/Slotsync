<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BusinessDAO, model.Business, model.User" %>
<%
    User owner = (User) session.getAttribute("user");
    if (owner == null || !"owner".equals(owner.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    Object bizIdObj = session.getAttribute("businessId");
    int businessId = (bizIdObj != null) ? (int) bizIdObj : 0;
    BusinessDAO businessDAO = new BusinessDAO();
    Business business = businessDAO.getById(businessId);

    String error = null, success = null;
    if ("POST".equalsIgnoreCase(request.getMethod()) && business != null) {
        String bizName = request.getParameter("businessName");
        if (bizName == null || bizName.trim().isEmpty()) {
            error = "Business name cannot be empty.";
        } else {
            business.setBusinessName(bizName.trim());
            business.setEmail(request.getParameter("email") != null ? request.getParameter("email").trim() : "");
            business.setPhone(request.getParameter("phone") != null ? request.getParameter("phone").trim() : "");
            business.setAddress(request.getParameter("address") != null ? request.getParameter("address").trim() : "");
            business.setCategory(request.getParameter("category") != null ? request.getParameter("category").trim() : "");
            if (businessDAO.update(business)) {
                success = "Business settings updated successfully.";
            } else {
                error = "Failed to update settings. Please try again.";
            }
        }
    }
    String[] categories = {"Salon","Barbershop","Spa","Clinic","Gym","Dental","Garage","Consulting","Other"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings | SlotSync</title>
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
      <a href="<%= ctx %>/views/owner/appointments.jsp"     class="sidenav-item">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>Appointments</a>
      <a href="<%= ctx %>/views/owner/settings.jsp"         class="sidenav-item active">
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
        <h1>Business Settings</h1>
        <div class="sub">Update your business information</div>
      </div>
    </div>

    <% if (success != null) { %>
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
    <div style="background:var(--red-50);border:1px solid #fecaca;color:#b91c1c;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= error %></div>
    <% } %>

    <% if (business == null) { %>
    <div class="card card-pad" style="color:var(--text-2)">Business not found. Please contact admin.</div>
    <% } else { %>
    <div class="card card-pad" style="max-width:640px">
      <form action="<%= ctx %>/views/owner/settings.jsp" method="post">
        <div class="col gap-4">
          <div class="field">
            <label>Business Name <span style="color:var(--red)">*</span></label>
            <input class="input" type="text" name="businessName" required
                   value="<%= business.getBusinessName() != null ? business.getBusinessName() : "" %>">
          </div>
          <div class="field">
            <label>Category</label>
            <select class="select" name="category">
              <% for (String cat : categories) { %>
              <option value="<%= cat %>" <%= cat.equals(business.getCategory()) ? "selected" : "" %>><%= cat %></option>
              <% } %>
            </select>
          </div>
          <div class="field">
            <label>Business Email</label>
            <input class="input" type="email" name="email"
                   value="<%= business.getEmail() != null ? business.getEmail() : "" %>">
          </div>
          <div class="field">
            <label>Business Phone</label>
            <input class="input" type="text" name="phone"
                   value="<%= business.getPhone() != null ? business.getPhone() : "" %>">
          </div>
          <div class="field">
            <label>Business Address</label>
            <input class="input" type="text" name="address"
                   value="<%= business.getAddress() != null ? business.getAddress() : "" %>">
          </div>
          <div class="field">
            <label>Status</label>
            <input class="input" type="text" value="<%= business.getStatus() != null ? business.getStatus() : "N/A" %>" readonly disabled>
            <span class="hint">Status is managed by the admin.</span>
          </div>
          <div class="row gap-3">
            <button class="btn btn-primary" type="submit">Save changes</button>
            <a href="<%= ctx %>/views/owner/dashboard.jsp" class="btn btn-secondary">Back to dashboard</a>
          </div>
        </div>
      </form>
    </div>
    <% } %>
  </main>
</div>
</body>
</html>
