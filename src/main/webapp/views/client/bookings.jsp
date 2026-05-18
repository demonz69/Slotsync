<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%
    if (session.getAttribute("userId") == null || !"client".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Bookings - SlotSync</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 30px; }
    .header { display: flex; justify-content: space-between; align-items: center; max-width: 860px; margin: 0 auto 24px; }
    .header h1 { margin: 0; }
    .header p { color: #888; margin: 4px 0 0; font-size: 0.9rem; }
    .btn-new { background: #1a1714; color: #fff; padding: 10px 22px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 0.9rem; }
    .alert { max-width: 860px; margin: 0 auto 16px; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
    .alert-success { background: #d8ede4; color: #1b5e3b; }
    .alert-error { background: #fdecea; color: #c0392b; }
    .table-wrap { max-width: 860px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); overflow: hidden; }
    table { width: 100%; border-collapse: collapse; }
    thead tr { background: #f5f5f5; }
    th { padding: 13px 16px; text-align: left; font-size: 0.78rem; text-transform: uppercase; color: #888; }
    td { padding: 15px 16px; border-top: 1px solid #eee; font-size: 0.92rem; vertical-align: middle; }
    .svc-name { font-weight: 600; }
    .emp-name { color: #888; font-size: 0.83rem; margin-top: 2px; }
    .badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
    .badge-confirmed { background: #d8ede4; color: #1b5e3b; }
    .badge-pending { background: #fff3cd; color: #856404; }
    .badge-cancelled { background: #f5e0e0; color: #8b1a1a; }
    .badge-completed { background: #e3e8ff; color: #2d3acc; }
    .btn-cancel { background: transparent; border: 1.5px solid #c0392b; color: #c0392b; padding: 6px 14px; border-radius: 7px; font-size: 0.82rem; font-weight: 600; cursor: pointer; }
    .btn-cancel:hover { background: #c0392b; color: #fff; }
    .btn-feedback { background: #0d9488; color: #fff; border: none; padding: 6px 14px; border-radius: 7px; font-size: 0.82rem; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; }
    .empty { text-align: center; padding: 60px 20px; color: #888; }
    .empty p { margin-bottom: 16px; }
    .btn-book { background: #1a1714; color: #fff; padding: 11px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; }
  </style>
</head>
<body>

<div class="header">
  <div>
    <h1>My Bookings</h1>
    <p>View and manage your appointment history</p>
  </div>
  <a href="${pageContext.request.contextPath}/views/client/booking.jsp" class="btn-new">+ New Booking</a>
</div>

<c:if test="${param.success == 'feedback_submitted'}">
  <div class="alert alert-success">Thank you for your feedback!</div>
</c:if>
<c:if test="${not empty param.error}">
  <div class="alert alert-error">An error occurred: ${param.error}</div>
</c:if>

<div class="table-wrap">
  <c:choose>
    <c:when test="${empty bookings}">
      <div class="empty">
        <p>You haven't made any bookings yet.</p>
        <a href="${pageContext.request.contextPath}/views/client/booking.jsp" class="btn-book">Book Your First Appointment</a>
      </div>
    </c:when>
    <c:otherwise>
      <table>
        <thead>
        <tr>
          <th>#</th>
          <th>Service</th>
          <th>Date & Time</th>
          <th>Price</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="b" items="${bookings}" varStatus="st">
        <tr>
          <td>${st.count}</td>
          <td>
            <div class="svc-name">${b.serviceName}</div>
            <div class="emp-name">with ${b.employeeName}</div>
          </td>
          <td>${b.appointmentDate} at ${b.slotTime}</td>
          <td>&pound;<fmt:formatNumber value="${b.price}" pattern="#,##0.00"/></td>
          <td>
            <c:choose>
                <c:when test="${b.status == 'confirmed'}"><span class="badge badge-confirmed">Confirmed</span></c:when>
                <c:when test="${b.status == 'pending'}"><span class="badge badge-pending">Pending</span></c:when>
                <c:when test="${b.status == 'completed'}"><span class="badge badge-completed">Completed</span></c:when>
                <c:otherwise><span class="badge badge-cancelled">Cancelled</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
                <c:when test="${b.status == 'confirmed' || b.status == 'pending'}">
                    <form method="post" action="${pageContext.request.contextPath}/AppointmentServlet" onsubmit="return confirm('Cancel this booking?')">
                      <input type="hidden" name="action" value="cancel"/>
                      <input type="hidden" name="appointmentId" value="${b.appointmentId}"/>
                      <button type="submit" class="btn-cancel">Cancel</button>
                    </form>
                </c:when>
                <c:when test="${b.status == 'completed'}">
                    <a href="${pageContext.request.contextPath}/views/client/feedback.jsp?id=${b.appointmentId}&service=${b.serviceName}" class="btn-feedback">Leave Feedback</a>
                </c:when>
                <c:otherwise>
                    <span style="color:#aaa">-</span>
                </c:otherwise>
            </c:choose>
          </td>
        </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

</body>
</html>
