<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BusinessDAO" %>
<%@ page import="model.Business" %>
<%
    if (session.getAttribute("userId") == null || !"owner".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    int businessId = (int) session.getAttribute("businessId");
    BusinessDAO businessDAO = new BusinessDAO();
    Business business = businessDAO.getById(businessId);

    String error   = null;
    String success = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String bizName  = request.getParameter("businessName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");
        String category = request.getParameter("category");

        if (bizName == null || bizName.trim().isEmpty()) {
            error = "Business name cannot be empty.";
        } else {
            business.setBusinessName(bizName.trim());
            business.setEmail(email != null ? email.trim() : "");
            business.setPhone(phone != null ? phone.trim() : "");
            business.setAddress(address != null ? address.trim() : "");
            business.setCategory(category != null ? category.trim() : "");

            boolean updated = businessDAO.update(business);
            if (updated) {
                success = "Business settings updated successfully.";
                session.setAttribute("businessName", bizName.trim());
            } else {
                error = "Failed to update settings. Please try again.";
            }
        }
    }

    String[] categories = {"Salon", "Barbershop", "Spa", "Clinic", "Gym", "Dental", "Legal", "Consulting", "Other"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync — Business Settings</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="/views/common/navbar.jsp" %>
<main class="container narrow">
    <section class="page-header">
        <h1>Business Settings</h1>
        <p class="subtitle">Update your business information</p>
    </section>

    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>
    <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>

    <div class="card">
        <div class="card-body">
            <% if (business != null) { %>
            <form action="<%= request.getContextPath() %>/views/owner/settings.jsp" method="post" id="settingsForm" novalidate>

                <div class="form-group">
                    <label for="businessName">Business Name <span class="required">*</span></label>
                    <input type="text" id="businessName" name="businessName"
                           value="<%= business.getBusinessName() != null ? business.getBusinessName() : "" %>"
                           class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category" class="form-control">
                        <% for (String cat : categories) { %>
                            <option value="<%= cat %>" <%= cat.equals(business.getCategory()) ? "selected" : "" %>><%= cat %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="email">Business Email</label>
                    <input type="email" id="email" name="email"
                           value="<%= business.getEmail() != null ? business.getEmail() : "" %>"
                           class="form-control">
                </div>

                <div class="form-group">
                    <label for="phone">Business Phone</label>
                    <input type="text" id="phone" name="phone"
                           value="<%= business.getPhone() != null ? business.getPhone() : "" %>"
                           class="form-control">
                </div>

                <div class="form-group">
                    <label for="address">Business Address</label>
                    <input type="text" id="address" name="address"
                           value="<%= business.getAddress() != null ? business.getAddress() : "" %>"
                           class="form-control">
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <input type="text" value="<%= business.getStatus() != null ? business.getStatus() : "N/A" %>"
                           class="form-control" readonly disabled>
                    <small class="form-hint">Status is managed by the admin.</small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="<%= request.getContextPath() %>/views/owner/dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                </div>
            </form>
            <% } else { %>
                <div class="empty-state"><p>Business not found. Please contact admin.</p></div>
            <% } %>
        </div>
    </div>
</main>
<%@ include file="/views/common/footer.jsp" %>
<script src="<%= request.getContextPath() %>/js/validation.js"></script>
</body>
</html>
