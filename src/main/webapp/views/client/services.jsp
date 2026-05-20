<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.ServiceDAO, dao.BusinessDAO, dao.FeedbackDAO, dao.WishlistDAO" %>
<%@ page import="model.Service, model.Business, model.Feedback, model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    String bizIdStr = request.getParameter("businessId");
    if (bizIdStr == null) {
        response.sendRedirect(ctx + "/views/client/home.jsp");
        return;
    }
    int businessId = Integer.parseInt(bizIdStr);
    BusinessDAO businessDAO = new BusinessDAO();
    ServiceDAO  serviceDAO  = new ServiceDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    WishlistDAO wishlistDAO = new WishlistDAO();

    Business       business  = businessDAO.getById(businessId);
    List<Service>  services  = serviceDAO.getByBusinessId(businessId);
    List<Feedback> reviews   = feedbackDAO.getFeedbackByBusiness(businessId);
    double         avgRating = feedbackDAO.getAverageRating(businessId);
    int stars = (int) Math.round(avgRating);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= business != null ? business.getBusinessName() : "Services" %> | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />
<div class="container" style="padding-top:40px;padding-bottom:60px;max-width:980px">

  <%-- Business header --%>
  <% if (business != null) { %>
  <div class="card card-pad" style="margin-bottom:24px">
    <div class="between">
      <div>
        <h1 style="font-size:24px;font-weight:600;margin:0 0 6px"><%= business.getBusinessName() %></h1>
        <% if (business.getAddress() != null && !business.getAddress().isEmpty()) { %>
        <div class="muted small" style="margin-bottom:4px">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle"><path d="M12 21s7-6 7-12a7 7 0 10-14 0c0 6 7 12 7 12z"/><circle cx="12" cy="9" r="2.5"/></svg>
          <%= business.getAddress() %>
        </div>
        <% } %>
        <% if (avgRating > 0) { %>
        <div style="display:flex;align-items:center;gap:6px;margin-top:6px">
          <div class="stars readonly" style="display:flex;gap:3px">
            <% for (int i = 1; i <= 5; i++) { %>
            <span style="color:<%= i <= stars ? "#f59e0b" : "var(--border-strong)" %>">&#9733;</span>
            <% } %>
          </div>
          <span class="muted small"><%= String.format("%.1f", avgRating) %> (<%= reviews.size() %> review<%= reviews.size() != 1 ? "s" : "" %>)</span>
        </div>
        <% } %>
      </div>
      <a href="<%= ctx %>/views/client/home.jsp" class="btn btn-secondary btn-sm">&#8592; Back</a>
    </div>
  </div>
  <% } %>

  <%-- Services grid --%>
  <h2 class="h2" style="margin-bottom:16px">Available Services</h2>
  <% if (services.isEmpty()) { %>
  <div class="card" style="padding:40px;text-align:center;color:var(--text-2);margin-bottom:24px">No services added yet.</div>
  <% } else { %>
  <div class="service-grid" style="margin-bottom:32px">
    <% for (Service svc : services) { %>
    <div class="service-card" style="cursor:default">
      <div class="name"><%= svc.getServiceName() %></div>
      <div class="meta"><%= svc.getDurationMin() %> min<%= svc.getDescription() != null && !svc.getDescription().isEmpty() ? " · " + svc.getDescription() : "" %></div>
      <div class="price mono">&pound;<%= String.format("%.2f", svc.getPrice()) %></div>
      <div style="margin-top:16px;display:flex;gap:8px">
        <a href="<%= ctx %>/views/client/booking.jsp?step=1&serviceId=<%= svc.getServiceId() %>"
           class="btn btn-primary btn-sm" style="flex:1;justify-content:center">Book now</a>
        <% if ("client".equals(currentUser.getRole())) { %>
        <form method="post" action="<%= ctx %>/user" style="display:inline">
          <input type="hidden" name="action"    value="addWishlist">
          <input type="hidden" name="serviceId" value="<%= svc.getServiceId() %>">
          <button class="btn btn-secondary btn-sm" type="submit" title="Save to wishlist">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20s-7-4.5-9.5-9.5C0.5 6 4 3 7 3c2 0 3.5 1 5 3 1.5-2 3-3 5-3 3 0 6.5 3 4.5 7.5C19 15.5 12 20 12 20z"/></svg>
          </button>
        </form>
        <% } %>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>

  <%-- Reviews --%>
  <h2 class="h2" style="margin-bottom:16px">Customer Reviews (<%= reviews.size() %>)</h2>
  <% if (reviews.isEmpty()) { %>
  <div class="card" style="padding:32px;text-align:center;color:var(--text-2)">No reviews yet. Be the first!</div>
  <% } else { %>
  <div class="card">
    <% for (int i = 0; i < reviews.size(); i++) {
           Feedback fb = reviews.get(i);
           int fStars = fb.getRating();
    %>
    <div style="padding:18px 22px;<%= i < reviews.size()-1 ? "border-bottom:1px solid var(--border)" : "" %>">
      <div class="between" style="margin-bottom:6px">
        <div style="font-weight:600;font-size:14px"><%= fb.getClientName() != null ? fb.getClientName() : "Client" %></div>
        <div class="muted tiny mono"><%= fb.getCreatedAt() != null ? fb.getCreatedAt().toString().substring(0, 10) : "" %></div>
      </div>
      <div style="display:flex;gap:2px;margin-bottom:8px">
        <% for (int s = 1; s <= 5; s++) { %>
        <span style="color:<%= s <= fStars ? "#f59e0b" : "var(--border-strong)" %>">&#9733;</span>
        <% } %>
      </div>
      <div style="font-size:14px;color:var(--text)"><%= fb.getComment() != null ? fb.getComment() : "" %></div>
    </div>
    <% } %>
  </div>
  <% } %>
</div>
<jsp:include page="/views/common/footer.jsp" />
</body>
</html>
