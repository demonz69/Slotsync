<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Appointment, model.User" %>
<%@ page import="dao.AppointmentDAO" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"client".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    AppointmentDAO apptDAO = new AppointmentDAO();
    List<Appointment> bookings = apptDAO.getAppointmentsByUser(currentUser.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />
<div class="container" style="padding-top:40px;padding-bottom:60px;max-width:980px">
    <div class="dash-head" style="margin-bottom:24px">
        <div>
            <h1 style="font-size:26px;font-weight:600;letter-spacing:-0.01em;margin:0 0 4px">My Bookings</h1>
            <div class="muted small">Your appointment history</div>
        </div>
        <a href="<%= ctx %>/views/client/booking.jsp" class="btn btn-primary">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
            New booking
        </a>
    </div>

    <% if ("feedback_submitted".equals(request.getParameter("success"))) { %>
    <div style="background:var(--green-50);border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:6px;margin-bottom:16px;font-size:14px">Thank you for your feedback!</div>
    <% } %>

    <div class="card">
        <% if (bookings.isEmpty()) { %>
        <div style="padding:60px 24px;text-align:center;color:var(--text-2)">
            <div style="font-size:14px;margin-bottom:16px">You haven't made any bookings yet.</div>
            <a href="<%= ctx %>/views/client/booking.jsp" class="btn btn-primary">Book your first appointment</a>
        </div>
        <% } else { %>
        <table class="table">
            <thead>
                <tr><th>Service</th><th>Date</th><th>Time</th><th style="text-align:right">Price</th><th>Status</th><th style="text-align:right">Action</th></tr>
            </thead>
            <tbody>
            <% for (Appointment b : bookings) {
                   String st = b.getStatus() != null ? b.getStatus().toLowerCase() : "";
                   String badgeCls = "confirmed".equals(st) ? "badge-green" : "completed".equals(st) ? "badge-blue" : "pending".equals(st) ? "badge-amber" : "badge-red";
            %>
            <tr class="hov">
                <td>
                    <div style="font-weight:500"><%= b.getServiceName() != null ? b.getServiceName() : "—" %></div>
                    <% if (b.getEmployeeName() != null) { %>
                    <div class="muted tiny" style="margin-top:2px">with <%= b.getEmployeeName() %></div>
                    <% } %>
                </td>
                <td><%= b.getAppointmentDate() %></td>
                <td class="mono small"><%= b.getSlotTime() %></td>
                <td class="mono" style="text-align:right;font-weight:500">&pound;<%= String.format("%.2f", b.getPrice()) %></td>
                <td><span class="badge <%= badgeCls %>"><span class="badge-dot"></span><%= b.getStatus() %></span></td>
                <td style="text-align:right">
                    <% if ("confirmed".equals(st) || "pending".equals(st)) { %>
                    <form style="display:inline" method="post" action="<%= ctx %>/AppointmentServlet"
                          onsubmit="return confirm('Cancel this booking?')">
                        <input type="hidden" name="action"        value="cancel">
                        <input type="hidden" name="appointmentId" value="<%= b.getAppointmentId() %>">
                        <button class="btn btn-danger btn-sm" type="submit">Cancel</button>
                    </form>
                    <% } else if ("completed".equals(st)) { %>
                    <a href="<%= ctx %>/views/client/feedback.jsp?appointmentId=<%= b.getAppointmentId() %>"
                       class="btn btn-secondary btn-sm">Leave review</a>
                    <% } else { %>
                    <span class="muted small">—</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
<jsp:include page="/views/common/footer.jsp" />
</body>
</html>
