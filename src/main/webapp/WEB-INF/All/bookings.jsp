<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
  Integer clientId = (Integer) session.getAttribute("userId");
  String role = (String) session.getAttribute("role");
  if (clientId == null || !"client".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  String successMsg = null;
  String errorMsg = null;
  String action = request.getParameter("action");
  String bookingIdParam = request.getParameter("bookingId");

  if ("cancel".equals(action) && bookingIdParam != null) {
    int bookingId = Integer.parseInt(bookingIdParam);
    BookingDAO cancelDAO = new BookingDAO();
    boolean ok = cancelDAO.cancelBooking(bookingId, clientId);
    if (ok) successMsg = "Booking cancelled successfully.";
    else errorMsg = "Could not cancel this booking.";
  }

  BookingDAO bookingDAO = new BookingDAO();
  List<Booking> bookings = bookingDAO.getByClientId(clientId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Bookings - SlotSync</title>
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
  <a href="booking.jsp" class="btn-new">+ New Booking</a>
</div>

<% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>
<% if (errorMsg != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>

<div class="table-wrap">
  <% if (bookings == null || bookings.isEmpty()) { %>
  <div class="empty">
    <p>You haven't made any bookings yet.</p>
    <a href="booking.jsp" class="btn-book">Book Your First Appointment</a>
  </div>
  <% } else { %>
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
    <% int i = 1; for (Booking b : bookings) {
      String badge = "badge-pending";
      if ("confirmed".equals(b.getStatus())) badge = "badge-confirmed";
      else if ("cancelled".equals(b.getStatus())) badge = "badge-cancelled";
      else if ("completed".equals(b.getStatus())) badge = "badge-completed";
    %>
    <tr>
      <td><%= i++ %></td>
      <td>
        <div class="svc-name"><%= b.getServiceName() %></div>
        <div class="emp-name">with <%= b.getEmployeeName() %></div>
      </td>
      <td><%= b.getSlotDate() %> at <%= b.getSlotTime() %></td>
      <td>£<%= String.format("%.2f", b.getPrice()) %></td>
      <td><span class="badge <%= badge %>"><%= b.getStatus() %></span></td>
      <td>
        <% if ("confirmed".equals(b.getStatus()) || "pending".equals(b.getStatus())) { %>
        <form method="get" action="bookings.jsp" onsubmit="return confirm('Cancel this booking?')">
          <input type="hidden" name="action" value="cancel"/>
          <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>"/>
          <button type="submit" class="btn-cancel">Cancel</button>
        </form>
        <% } else { %>
        <span style="color:#aaa">-</span>
        <% } %>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
  <% } %>
</div>

</body>
</html>
