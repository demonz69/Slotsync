<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
  Integer clientId = (Integer) session.getAttribute("userId");
  String role = (String) session.getAttribute("role");
  if (clientId == null || !"client".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  String stepParam = request.getParameter("step");
  int step = (stepParam != null) ? Integer.parseInt(stepParam) : 1;

  ServiceDAO serviceDAO = new ServiceDAO();
  EmployeeDAO employeeDAO = new EmployeeDAO();
  SlotDAO slotDAO = new SlotDAO();
  BookingDAO bookingDAO = new BookingDAO();

  int selectedServiceId = 0;
  int selectedEmployeeId = 0;
  int selectedSlotId = 0;

  if (request.getParameter("serviceId") != null) selectedServiceId = Integer.parseInt(request.getParameter("serviceId"));
  if (request.getParameter("employeeId") != null) selectedEmployeeId = Integer.parseInt(request.getParameter("employeeId"));
  if (request.getParameter("slotId") != null) selectedSlotId = Integer.parseInt(request.getParameter("slotId"));

  List<Service> services = (step == 1) ? serviceDAO.getAllActive() : null;
  List<Employee> employees = (step == 2 && selectedServiceId > 0) ? employeeDAO.getByServiceId(selectedServiceId) : null;
  List<Slot> slots = (step == 3 && selectedServiceId > 0 && selectedEmployeeId > 0) ? slotDAO.getAvailableSlots(selectedServiceId, selectedEmployeeId) : null;

  Service selectedService = (step == 4 && selectedServiceId > 0) ? serviceDAO.getById(selectedServiceId) : null;
  Employee selectedEmployee = (step == 4 && selectedEmployeeId > 0) ? employeeDAO.getById(selectedEmployeeId) : null;
  Slot selectedSlot = (step == 4 && selectedSlotId > 0) ? slotDAO.getById(selectedSlotId) : null;

  String errorMsg = null;
  if ("POST".equalsIgnoreCase(request.getMethod()) && step == 4) {
    boolean ok = bookingDAO.createBooking(clientId, selectedServiceId, selectedEmployeeId, selectedSlotId);
    if (ok) { step = 5; }
    else { errorMsg = "Something went wrong. Please try again."; }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Book Appointment - SlotSync</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 30px; }
    h1 { text-align: center; margin-bottom: 10px; }
    .sub { text-align: center; color: #888; margin-bottom: 30px; }
    .stepper { display: flex; justify-content: center; gap: 10px; margin-bottom: 30px; }
    .step { padding: 8px 20px; border-radius: 20px; background: #ddd; font-size: 0.85rem; font-weight: 600; }
    .step.active { background: #1a1714; color: #fff; }
    .step.done { background: #2D6A4F; color: #fff; }
    .card { background: #fff; border-radius: 12px; padding: 30px; max-width: 700px; margin: 0 auto; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    .card h2 { margin-bottom: 5px; }
    .card p { color: #888; margin-bottom: 20px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 12px; }
    .item { border: 2px solid #eee; border-radius: 10px; padding: 16px; text-decoration: none; color: #1a1714; display: block; }
    .item:hover { border-color: #2D6A4F; background: #f0faf5; }
    .item .name { font-weight: 700; margin-bottom: 4px; }
    .item .meta { font-size: 0.82rem; color: #888; }
    .item .price { font-weight: 700; color: #2D6A4F; margin-top: 8px; }
    .slot-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 10px; }
    .slot { border: 2px solid #eee; border-radius: 10px; padding: 12px; text-align: center; text-decoration: none; color: #1a1714; display: block; }
    .slot:hover { border-color: #2D6A4F; background: #f0faf5; }
    .slot .time { font-weight: 700; }
    .slot .date { font-size: 0.75rem; color: #888; margin-top: 3px; }
    table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    td { padding: 12px 0; border-bottom: 1px solid #eee; }
    td:first-child { color: #888; width: 140px; }
    td:last-child { font-weight: 600; }
    .btn-row { display: flex; gap: 10px; margin-top: 15px; }
    .btn { padding: 11px 24px; border-radius: 8px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: none; text-decoration: none; display: inline-block; }
    .btn-dark { background: #1a1714; color: #fff; }
    .btn-outline { background: #fff; color: #1a1714; border: 2px solid #ddd; }
    .btn-green { background: #2D6A4F; color: #fff; }
    .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; background: #fdecea; color: #c0392b; }
    .empty { text-align: center; padding: 40px; color: #888; }
    .success { text-align: center; padding: 20px; }
    .success h2 { margin-bottom: 10px; }
    .success p { color: #888; margin-bottom: 20px; }
  </style>
</head>
<body>

<h1>Book an Appointment</h1>
<p class="sub">Complete the steps below to reserve your slot</p>

<% if (step < 5) { %>
<div class="stepper">
  <div class="step <%= step > 1 ? "done" : step == 1 ? "active" : "" %>">1. Service</div>
  <div class="step <%= step > 2 ? "done" : step == 2 ? "active" : "" %>">2. Employee</div>
  <div class="step <%= step > 3 ? "done" : step == 3 ? "active" : "" %>">3. Slot</div>
  <div class="step <%= step == 4 ? "active" : "" %>">4. Confirm</div>
</div>
<% } %>

<div class="card">

  <% if (errorMsg != null) { %><div class="alert"><%= errorMsg %></div><% } %>

  <% if (step == 1) { %>
  <h2>Choose a Service</h2>
  <p>Select the service you'd like to book</p>
  <% if (services == null || services.isEmpty()) { %>
  <div class="empty">No services available at the moment.</div>
  <% } else { %>
  <div class="grid">
    <% for (Service svc : services) { %>
    <a href="booking.jsp?step=2&serviceId=<%= svc.getServiceId() %>" class="item">
      <div class="name"><%= svc.getServiceName() %></div>
      <div class="meta"><%= svc.getDuration() %> min</div>
      <div class="price">£<%= String.format("%.2f", svc.getPrice()) %></div>
    </a>
    <% } %>
  </div>
  <% } %>

  <% } else if (step == 2) { %>
  <h2>Choose a Staff Member</h2>
  <p>Select who you'd like to be served by</p>
  <% if (employees == null || employees.isEmpty()) { %>
  <div class="empty">No staff available for this service.</div>
  <% } else { %>
  <div class="grid">
    <% for (Employee emp : employees) { %>
    <a href="booking.jsp?step=3&serviceId=<%= selectedServiceId %>&employeeId=<%= emp.getEmployeeId() %>" class="item">
      <div class="name"><%= emp.getFullName() %></div>
      <div class="meta"><%= emp.getJobTitle() %></div>
    </a>
    <% } %>
  </div>
  <% } %>
  <div class="btn-row">
    <a href="booking.jsp?step=1" class="btn btn-outline">Back</a>
  </div>

  <% } else if (step == 3) { %>
  <h2>Pick a Time Slot</h2>
  <p>Choose an available date and time</p>
  <% if (slots == null || slots.isEmpty()) { %>
  <div class="empty">No slots available. Try a different employee.</div>
  <% } else { %>
  <div class="slot-grid">
    <% for (Slot slot : slots) { %>
    <a href="booking.jsp?step=4&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&slotId=<%= slot.getSlotId() %>" class="slot">
      <div class="time"><%= slot.getStartTime() %></div>
      <div class="date"><%= slot.getSlotDate() %></div>
    </a>
    <% } %>
  </div>
  <% } %>
  <div class="btn-row">
    <a href="booking.jsp?step=2&serviceId=<%= selectedServiceId %>" class="btn btn-outline">Back</a>
  </div>

  <% } else if (step == 4) { %>
  <h2>Confirm Your Booking</h2>
  <p>Review the details before confirming</p>
  <table>
    <tr><td>Service</td><td><%= selectedService != null ? selectedService.getServiceName() : "-" %></td></tr>
    <tr><td>Duration</td><td><%= selectedService != null ? selectedService.getDuration() + " min" : "-" %></td></tr>
    <tr><td>Staff</td><td><%= selectedEmployee != null ? selectedEmployee.getFullName() : "-" %></td></tr>
    <tr><td>Date</td><td><%= selectedSlot != null ? selectedSlot.getSlotDate() : "-" %></td></tr>
    <tr><td>Time</td><td><%= selectedSlot != null ? selectedSlot.getStartTime() : "-" %></td></tr>
    <tr><td>Price</td><td><%= selectedService != null ? "£" + String.format("%.2f", selectedService.getPrice()) : "-" %></td></tr>
  </table>
  <form method="post" action="booking.jsp?step=4&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&slotId=<%= selectedSlotId %>">
    <div class="btn-row">
      <a href="booking.jsp?step=3&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>" class="btn btn-outline">Back</a>
      <button type="submit" class="btn btn-green">Confirm Booking</button>
    </div>
  </form>

  <% } else if (step == 5) { %>
  <div class="success">
    <h2>Booking Confirmed!</h2>
    <p>Your appointment has been successfully booked.</p>
    <div class="btn-row" style="justify-content:center">
      <a href="bookings.jsp" class="btn btn-dark">View My Bookings</a>
      <a href="booking.jsp" class="btn btn-outline">Book Another</a>
    </div>
  </div>
  <% } %>

</div>
</body>
</html>
