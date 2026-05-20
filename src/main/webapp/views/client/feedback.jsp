<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.AppointmentDAO, model.Appointment" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
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
    String ctx   = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave a Review | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        .star-row { display:flex; gap:6px; margin:8px 0; }
        .star-row input { display:none; }
        .star-row label { font-size:2rem; cursor:pointer; color:var(--border-strong); transition:color 0.1s; }
        .star-row label:hover,
        .star-row label:hover ~ label,
        .star-row input:checked ~ label { color:#f59e0b; }
    </style>
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />
<div class="container" style="padding-top:40px;padding-bottom:60px;max-width:640px">
    <div style="margin-bottom:28px">
        <h1 style="font-size:26px;font-weight:600;letter-spacing:-0.01em;margin:0 0 4px">Leave a Review</h1>
        <div class="muted small">Your feedback helps others make informed decisions.</div>
    </div>

    <% if (error != null) { %>
    <div style="background:var(--red-50);border:1px solid #fecaca;color:#b91c1c;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px"><%= error %></div>
    <% } %>

    <div class="card card-pad">
        <% if (appt != null) { %>
        <div style="padding:12px 16px;background:var(--bg-soft);border:1px solid var(--border);border-radius:6px;margin-bottom:20px;font-size:14px">
            Reviewing appointment on <strong><%= appt.getAppointmentDate() %></strong>
            <% if (appt.getServiceName() != null) { %> &mdash; <%= appt.getServiceName() %><% } %>
        </div>
        <% } %>

        <form action="<%= ctx %>/feedback" method="post" id="feedbackForm">
            <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
            <input type="hidden" name="businessId"    value="<%= appt != null ? appt.getBusinessId() : "" %>">

            <div class="col gap-4">
                <div class="field">
                    <label>Rating <span style="color:var(--red)">*</span></label>
                    <div class="star-row" id="starRating">
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
                    <span class="err" id="ratingError" style="display:none">Please select a star rating.</span>
                </div>
                <div class="field">
                    <label>Comment</label>
                    <textarea class="textarea" name="comment" placeholder="Tell others about your experience..."></textarea>
                </div>
                <div class="row gap-3">
                    <button class="btn btn-primary" type="submit">Submit review</button>
                    <a href="<%= ctx %>/views/client/bookings.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/views/common/footer.jsp" />
<script>
document.getElementById('feedbackForm').addEventListener('submit', function(e) {
    var sel = document.querySelector('input[name="rating"]:checked');
    var err = document.getElementById('ratingError');
    if (!sel) { e.preventDefault(); err.style.display = 'block'; }
    else { err.style.display = 'none'; }
});
</script>
</body>
</html>
