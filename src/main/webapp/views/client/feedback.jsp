<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.slotsync.dao.AppointmentDAO" %>
<%@ page import="com.slotsync.model.Appointment" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    String apptIdStr = request.getParameter("appointmentId");
    if (apptIdStr == null) {
        response.sendRedirect(request.getContextPath() + "/views/client/bookings.jsp");
        return;
    }
    int appointmentId = Integer.parseInt(apptIdStr);
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    Appointment appt = appointmentDAO.getById(appointmentId);
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync ΓÇö Leave Feedback</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .star-rating { display: flex; gap: 8px; flex-direction: row-reverse; justify-content: flex-end; margin: 8px 0; }
        .star-rating input { display: none; }
        .star-rating label { font-size: 2rem; cursor: pointer; color: #555; transition: color 0.2s; }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label { color: #f5c518; }
    </style>
</head>
<body>
<%@ include file="/views/common/navbar.jsp" %>
<main class="container narrow">
    <section class="page-header">
        <h1>Leave a Review</h1>
        <p class="subtitle">Share your experience with others</p>
    </section>

    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <div class="card">
        <div class="card-body">
            <% if (appt != null) { %>
                <p class="appointment-info">
                    Reviewing appointment on <strong><%= appt.getAppointmentDate() %></strong>
                </p>
            <% } %>

            <form action="<%= request.getContextPath() %>/FeedbackServlet" method="post" id="feedbackForm">
                <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
                <input type="hidden" name="businessId" value="<%= appt != null ? appt.getBusinessId() : "" %>">

                <div class="form-group">
                    <label>Your Rating <span class="required">*</span></label>
                    <div class="star-rating" id="starRating">
                        <input type="radio" id="star5" name="rating" value="5">
                        <label for="star5" title="5 stars">&#9733;</label>
                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4" title="4 stars">&#9733;</label>
                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3" title="3 stars">&#9733;</label>
                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2" title="2 stars">&#9733;</label>
                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1" title="1 star">&#9733;</label>
                    </div>
                    <span class="error-msg" id="ratingError"></span>
                </div>

                <div class="form-group">
                    <label for="comment">Your Review</label>
                    <textarea id="comment" name="comment" class="form-control"
                              rows="5" placeholder="Tell others about your experience..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Submit Review</button>
                    <a href="<%= request.getContextPath() %>/views/client/bookings.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/views/common/footer.jsp" %>
<script>
    document.getElementById('feedbackForm').addEventListener('submit', function(e) {
        var selected = document.querySelector('input[name="rating"]:checked');
        var err = document.getElementById('ratingError');
        if (!selected) {
            e.preventDefault();
            err.textContent = 'Please select a star rating.';
            err.style.display = 'block';
        } else {
            err.style.display = 'none';
        }
    });
</script>
</body>
</html>
