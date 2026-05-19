<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="dao.BusinessDAO" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="model.Service" %>
<%@ page import="model.Business" %>
<%@ page import="model.Feedback" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    String bizIdStr = request.getParameter("businessId");
    if (bizIdStr == null) {
        response.sendRedirect(request.getContextPath() + "/views/client/home.jsp");
        return;
    }
    int businessId = Integer.parseInt(bizIdStr);
    BusinessDAO businessDAO = new BusinessDAO();
    ServiceDAO serviceDAO   = new ServiceDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    Business business       = businessDAO.getById(businessId);
    List<Service> services  = serviceDAO.getByBusinessId(businessId);
    List<Feedback> reviews  = feedbackDAO.getFeedbackByBusiness(businessId);
    double avgRating        = feedbackDAO.getAverageRating(businessId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync — <%= business != null ? business.getBusinessName() : "Services" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="/views/common/navbar.jsp" %>
<main class="container">

    <% if (business != null) { %>
    <section class="business-header card">
        <div class="business-header-info">
            <h1><%= business.getBusinessName() %></h1>
            <p class="card-info"><%= business.getAddress() != null ? business.getAddress() : "" %></p>
            <p class="card-info"><%= business.getPhone() != null ? business.getPhone() : "" %></p>
            <div class="star-display">
                <% int stars = (int) Math.round(avgRating);
                   for (int i = 1; i <= 5; i++) { %>
                    <span class="star <%= i <= stars ? "filled" : "" %>">&#9733;</span>
                <% } %>
                <span class="rating-value">
                    <%= avgRating > 0 ? String.format("%.1f", avgRating) + " (" + reviews.size() + " reviews)" : "No reviews yet" %>
                </span>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/views/client/home.jsp" class="btn btn-secondary">&#8592; Back</a>
    </section>
    <% } %>

    <section class="section">
        <h2>Available Services</h2>
        <% if (services.isEmpty()) { %>
            <div class="empty-state"><p>This business has not added any services yet.</p></div>
        <% } else { %>
        <div class="card-grid">
            <% for (Service svc : services) { %>
            <div class="card service-card">
                <div class="card-header">
                    <h3 class="card-title"><%= svc.getServiceName() %></h3>
                    <span class="price-badge">Rs. <%= svc.getPrice() %></span>
                </div>
                <div class="card-body">
                    <p><%= svc.getDescription() != null ? svc.getDescription() : "" %></p>
                    <p class="card-info">Duration: <strong><%= svc.getDurationMinutes() %> min</strong></p>
                </div>
                <div class="card-footer">
                    <a href="<%= request.getContextPath() %>/views/client/booking.jsp?serviceId=<%= svc.getServiceId() %>&businessId=<%= businessId %>"
                       class="btn btn-primary btn-full">Book Now</a>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </section>

    <section class="section">
        <h2>Customer Reviews (<%= reviews.size() %>)</h2>
        <% if (reviews.isEmpty()) { %>
            <div class="empty-state"><p>No reviews yet. Be the first to review!</p></div>
        <% } else { %>
            <div class="reviews-list">
                <% for (Feedback fb : reviews) { %>
                <div class="review-card card">
                    <div class="review-header">
                        <strong><%= fb.getClientName() != null ? fb.getClientName() : "Client" %></strong>
                        <div class="star-display small">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <span class="star <%= i <= fb.getRating() ? "filled" : "" %>">&#9733;</span>
                            <% } %>
                        </div>
                    </div>
                    <p class="review-comment"><%= fb.getComment() != null ? fb.getComment() : "" %></p>
                    <small class="review-date"><%= fb.getCreatedAt() != null ? fb.getCreatedAt().toString().substring(0, 10) : "" %></small>
                </div>
                <% } %>
            </div>
        <% } %>
    </section>

</main>
<%@ include file="/views/common/footer.jsp" %>
</body>
</html>