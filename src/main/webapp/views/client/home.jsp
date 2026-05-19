<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.slotsync.dao.BusinessDAO" %>
<%@ page import="com.slotsync.dao.FeedbackDAO" %>
<%@ page import="com.slotsync.model.Business" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    BusinessDAO businessDAO = new BusinessDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    String search = request.getParameter("search");
    List<Business> businesses;
    if (search != null && !search.trim().isEmpty()) {
        businesses = businessDAO.searchByName(search.trim());
    } else {
        businesses = businessDAO.getAllApprovedBusinesses();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync — Browse Businesses</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="/views/common/navbar.jsp" %>
<main class="container">
    <section class="page-header">
        <h1>Find a Service</h1>
        <p class="subtitle">Browse businesses and book your appointment</p>
    </section>

    <form class="search-bar" action="<%= request.getContextPath() %>/views/client/home.jsp" method="get">
        <input type="text" name="search" placeholder="Search businesses..."
               value="<%= search != null ? search : "" %>" class="search-input">
        <button type="submit" class="btn btn-primary">Search</button>
        <% if (search != null && !search.isEmpty()) { %>
            <a href="<%= request.getContextPath() %>/views/client/home.jsp" class="btn btn-secondary">Clear</a>
        <% } %>
    </form>

    <p class="results-count">
        <% if (search != null && !search.isEmpty()) { %>
            Showing results for "<strong><%= search %></strong>" —
        <% } %>
        <%= businesses.size() %> business<%= businesses.size() != 1 ? "es" : "" %> found
    </p>

    <div class="card-grid">
        <% if (businesses.isEmpty()) { %>
            <div class="empty-state"><p>No businesses found. Try a different search term.</p></div>
        <% } else {
            for (Business biz : businesses) {
                double avgRating = feedbackDAO.getAverageRating(biz.getBusinessId());
                int stars = (int) Math.round(avgRating);
        %>
        <div class="card business-card">
            <div class="card-header">
                <h2 class="card-title"><%= biz.getBusinessName() %></h2>
                <span class="badge badge-category"><%= biz.getCategory() != null ? biz.getCategory() : "General" %></span>
            </div>
            <div class="card-body">
                <p class="card-info"><%= biz.getAddress() != null ? biz.getAddress() : "N/A" %></p>
                <p class="card-info"><%= biz.getPhone() != null ? biz.getPhone() : "N/A" %></p>
                <div class="star-display">
                    <% for (int i = 1; i <= 5; i++) { %>
                        <span class="star <%= i <= stars ? "filled" : "" %>">&#9733;</span>
                    <% } %>
                    <span class="rating-value">
                        <%= avgRating > 0 ? String.format("%.1f", avgRating) : "No reviews yet" %>
                    </span>
                </div>
            </div>
            <div class="card-footer">
                <a href="<%= request.getContextPath() %>/views/client/services.jsp?businessId=<%= biz.getBusinessId() %>"
                   class="btn btn-primary btn-full">View Services</a>
            </div>
        </div>
        <% } } %>
    </div>
</main>
<%@ include file="/views/common/footer.jsp" %>
</body>
</html>