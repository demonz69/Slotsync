<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
  Integer clientId = (Integer) session.getAttribute("userId");
  String role = (String) session.getAttribute("role");
  if (clientId == null || !"client".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    return;
  }

  String stepParam = request.getParameter("step");
  int step = (stepParam != null) ? Integer.parseInt(stepParam) : 1;

  ServiceDAO serviceDAO = new ServiceDAO();
  EmployeeDAO employeeDAO = new EmployeeDAO();
  AppointmentDAO appointmentDAO = new AppointmentDAO();

  int selectedServiceId = 0;
  int selectedEmployeeId = 0;
  String selectedDate = request.getParameter("date");
  String selectedSlot = request.getParameter("slotTime");

  if (request.getParameter("serviceId") != null && !request.getParameter("serviceId").isEmpty()) {
      selectedServiceId = Integer.parseInt(request.getParameter("serviceId"));
  }
  if (request.getParameter("employeeId") != null && !request.getParameter("employeeId").isEmpty()) {
      selectedEmployeeId = Integer.parseInt(request.getParameter("employeeId"));
  }

  if (selectedDate == null || selectedDate.isEmpty()) {
      selectedDate = java.time.LocalDate.now().toString();
  }

  List<Service> services = (step == 1) ? serviceDAO.getAllActive() : null;
  Service selectedService = (selectedServiceId > 0) ? serviceDAO.getServiceById(selectedServiceId) : null;
  
  List<Employee> employees = null;
  if (step == 2 && selectedService != null) {
      employees = employeeDAO.getByBusinessId(selectedService.getBusinessId());
  }
  Employee selectedEmployee = (selectedEmployeeId > 0) ? employeeDAO.getById(selectedEmployeeId) : null;

  List<String> slots = null;
  if (step >= 3 && selectedEmployeeId > 0) {
      slots = appointmentDAO.getAvailableSlots(selectedEmployeeId, selectedDate);
  }

  String errorMsg = null;
  if ("POST".equalsIgnoreCase(request.getMethod()) && step == 5) {
      try {
          Appointment apt = new Appointment();
          apt.setClientId(clientId);
          apt.setEmployeeId(selectedEmployeeId);
          apt.setServiceId(selectedServiceId);
          apt.setBusinessId(selectedService.getBusinessId());
          apt.setAppointmentDate(selectedDate);
          apt.setSlotTime(selectedSlot);
          apt.setStatus("pending");
          apt.setNotes("");
          
          boolean ok = appointmentDAO.createAppointment(apt);
          if (ok) { 
              response.sendRedirect(request.getContextPath() + "/user?action=bookings&success=booked");
              return;
          } else { 
              errorMsg = "Something went wrong. Please try again."; 
          }
      } catch(Exception e) {
          e.printStackTrace();
          errorMsg = "Error creating appointment.";
      }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Book Appointment - SlotSync</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 30px; }
    h1 { text-align: center; margin-bottom: 10px; }
    .sub { text-align: center; color: #888; margin-bottom: 30px; }
    .stepper { display: flex; justify-content: center; gap: 10px; margin-bottom: 30px; }
    .step { padding: 8px 20px; border-radius: 20px; background: #ddd; font-size: 0.85rem; font-weight: 600; }
    .step.active { background: #1a1714; color: #fff; }
    .step.done { background: #0d9488; color: #fff; }
    .card { background: #fff; border-radius: 12px; padding: 30px; max-width: 700px; margin: 0 auto; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    .card h2 { margin-bottom: 5px; }
    .card p { color: #888; margin-bottom: 20px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 12px; }
    .item { border: 2px solid #eee; border-radius: 10px; padding: 16px; text-decoration: none; color: #1a1714; display: block; }
    .item:hover { border-color: #0d9488; background: #f0fdfa; }
    .item .name { font-weight: 700; margin-bottom: 4px; }
    .item .meta { font-size: 0.82rem; color: #888; }
    .item .price { font-weight: 700; color: #0d9488; margin-top: 8px; }
    .slot-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 10px; margin-top: 20px;}
    .slot { border: 2px solid #eee; border-radius: 10px; padding: 12px; text-align: center; text-decoration: none; color: #1a1714; display: block; }
    .slot:hover { border-color: #0d9488; background: #f0fdfa; }
    .slot .time { font-weight: 700; }
    table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    td { padding: 12px 0; border-bottom: 1px solid #eee; }
    td:first-child { color: #888; width: 140px; }
    td:last-child { font-weight: 600; }
    .btn-row { display: flex; gap: 10px; margin-top: 15px; }
    .btn { padding: 11px 24px; border-radius: 8px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: none; text-decoration: none; display: inline-block; }
    .btn-dark { background: #1a1714; color: #fff; }
    .btn-outline { background: #fff; color: #1a1714; border: 2px solid #ddd; }
    .btn-green { background: #0d9488; color: #fff; }
    .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; background: #fdecea; color: #c0392b; }
    .empty { text-align: center; padding: 40px; color: #888; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: 600; font-size: 0.9rem; color: #555; }
    .form-group input[type="date"] { padding: 10px; border: 1.5px solid #ddd; border-radius: 6px; font-size: 1rem; outline: none; }
    .form-group input[type="date"]:focus { border-color: #0d9488; }
    .btn-submit { padding: 10px 18px; background: #1a1714; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-weight:600;}
  </style>
</head>
<body>

<h1>Book an Appointment</h1>
<p class="sub">Complete the steps below to reserve your slot</p>

<div class="stepper">
  <div class="step <%= step > 1 ? "done" : step == 1 ? "active" : "" %>">1. Service</div>
  <div class="step <%= step > 2 ? "done" : step == 2 ? "active" : "" %>">2. Employee</div>
  <div class="step <%= step > 3 ? "done" : step == 3 ? "active" : "" %>">3. Time Slot</div>
  <div class="step <%= step == 4 || step == 5 ? "active" : "" %>">4. Confirm</div>
</div>

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
    <a href="?step=2&serviceId=<%= svc.getServiceId() %>" class="item">
      <div class="name"><%= svc.getServiceName() %></div>
      <div class="meta"><%= svc.getDuration() %> min</div>
      <div class="price">&pound;<%= String.format("%.2f", svc.getPrice()) %></div>
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
    <a href="?step=3&serviceId=<%= selectedServiceId %>&employeeId=<%= emp.getEmployeeId() %>" class="item">
      <div class="name"><%= emp.getFullName() != null ? emp.getFullName() : "Staff #"+emp.getEmployeeId() %></div>
      <div class="meta"><%= emp.getDesignation() %></div>
    </a>
    <% } %>
  </div>
  <% } %>
  <div class="btn-row">
    <a href="?step=1" class="btn btn-outline">Back</a>
  </div>

  <% } else if (step == 3) { %>
  <h2>Pick a Date & Time Slot</h2>
  <p>Choose an available date and time</p>
  
  <form method="get" action="booking.jsp" style="display:flex; gap:10px; align-items:flex-end;">
      <input type="hidden" name="step" value="3">
      <input type="hidden" name="serviceId" value="<%= selectedServiceId %>">
      <input type="hidden" name="employeeId" value="<%= selectedEmployeeId %>">
      <div class="form-group" style="margin:0;">
          <label>Select Date:</label>
          <input type="date" name="date" value="<%= selectedDate %>" min="<%= java.time.LocalDate.now().toString() %>" required>
      </div>
      <button type="submit" class="btn-submit">Check Availability</button>
  </form>

  <% if (slots == null || slots.isEmpty()) { %>
  <div class="empty" style="padding:20px;">No slots available on this date. Try another date.</div>
  <% } else { %>
  <div class="slot-grid">
    <% for (String slotTime : slots) { %>
    <a href="?step=4&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&date=<%= selectedDate %>&slotTime=<%= slotTime %>" class="slot">
      <div class="time"><%= slotTime %></div>
    </a>
    <% } %>
  </div>
  <% } %>
  <div class="btn-row" style="margin-top:25px;">
    <a href="?step=2&serviceId=<%= selectedServiceId %>" class="btn btn-outline">Back</a>
  </div>

  <% } else if (step == 4 || step == 5) { %>
  <h2>Confirm Your Booking</h2>
  <p>Review the details before confirming</p>
  <table>
    <tr><td>Service</td><td><%= selectedService != null ? selectedService.getServiceName() : "-" %></td></tr>
    <tr><td>Duration</td><td><%= selectedService != null ? selectedService.getDuration() + " min" : "-" %></td></tr>
    <tr><td>Staff</td><td><%= selectedEmployee != null && selectedEmployee.getFullName() != null ? selectedEmployee.getFullName() : "-" %></td></tr>
    <tr><td>Date</td><td><%= selectedDate %></td></tr>
    <tr><td>Time</td><td><%= selectedSlot %></td></tr>
    <tr><td>Price</td><td><%= selectedService != null ? "&pound;" + String.format("%.2f", selectedService.getPrice()) : "-" %></td></tr>
  </table>
  <form method="post" action="?step=5&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&date=<%= selectedDate %>&slotTime=<%= selectedSlot %>">
    <div class="btn-row">
      <a href="?step=3&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&date=<%= selectedDate %>" class="btn btn-outline">Back</a>
      <button type="submit" class="btn btn-green">Confirm Booking</button>
    </div>
  </form>

  <% } %>

</div>
</body>
</html>
