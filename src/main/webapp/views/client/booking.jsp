<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"client".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String ctx = request.getContextPath();

    String stepParam = request.getParameter("step");
    int step = (stepParam != null) ? Integer.parseInt(stepParam) : 1;

    ServiceDAO     serviceDAO     = new ServiceDAO();
    EmployeeDAO    employeeDAO    = new EmployeeDAO();
    AppointmentDAO appointmentDAO = new AppointmentDAO();

    int    selectedServiceId  = 0;
    int    selectedEmployeeId = 0;
    String selectedDate  = request.getParameter("date");
    String selectedSlot  = request.getParameter("slotTime");

    try { selectedServiceId  = Integer.parseInt(request.getParameter("serviceId")); }  catch (Exception e) {}
    try { selectedEmployeeId = Integer.parseInt(request.getParameter("employeeId")); } catch (Exception e) {}
    if (selectedDate == null || selectedDate.isEmpty())
        selectedDate = java.time.LocalDate.now().toString();

    List<Service>  services = (step == 1) ? serviceDAO.getAllActive() : null;
    Service  selectedService  = (selectedServiceId  > 0) ? serviceDAO.getServiceById(selectedServiceId)   : null;
    Employee selectedEmployee = (selectedEmployeeId > 0) ? employeeDAO.getById(selectedEmployeeId)        : null;

    List<Employee> employees = null;
    if (step == 2 && selectedService != null)
        employees = employeeDAO.getByBusinessId(selectedService.getBusinessId());

    List<String> slots = null;
    if (step >= 3 && selectedEmployeeId > 0)
        slots = appointmentDAO.getAvailableSlots(selectedEmployeeId, selectedDate);

    String errorMsg = null;
    if ("POST".equalsIgnoreCase(request.getMethod()) && step == 5) {
        try {
            Appointment apt = new Appointment();
            apt.setClientId(currentUser.getUserId());
            apt.setEmployeeId(selectedEmployeeId);
            apt.setServiceId(selectedServiceId);
            apt.setBusinessId(selectedService.getBusinessId());
            apt.setAppointmentDate(selectedDate);
            apt.setSlotTime(selectedSlot);
            apt.setStatus("pending");
            apt.setNotes("");
            if (appointmentDAO.bookAppointment(apt)) {
                response.sendRedirect(ctx + "/views/client/bookings.jsp?success=booked");
                return;
            } else {
                errorMsg = "Booking failed — slot may have been taken. Please try another.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "An error occurred. Please try again.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book an Appointment | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<jsp:include page="/views/common/navbar.jsp" />

<div class="booking-wrap">

  <%-- Stepper --%>
  <div class="steps">
    <% String[] stepLabels = {"Service","Employee","Time slot","Confirm"};
       for (int i = 1; i <= 4; i++) {
           String cls = i < step ? "done" : i == step ? "active" : "";
    %>
    <div class="step <%= cls %>">
      <div class="step-circle">
        <% if (i < step) { %>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l4 4L19 6"/></svg>
        <% } else { %><%= i %><% } %>
      </div>
      <div class="step-label"><%= stepLabels[i-1] %></div>
    </div>
    <% if (i < 4) { %><div class="step-line <%= i < step ? "done" : "" %>"></div><% } %>
    <% } %>
  </div>

  <% if (errorMsg != null) { %>
  <div style="background:var(--red-50);border:1px solid #fecaca;color:#b91c1c;padding:12px 16px;border-radius:6px;margin-bottom:20px;font-size:14px"><%= errorMsg %></div>
  <% } %>

  <%-- Step 1: Service --%>
  <% if (step == 1) { %>
  <h2 class="h2" style="margin-bottom:6px">Pick a service</h2>
  <p class="muted" style="margin-bottom:24px">What can we help you with today?</p>
  <% if (services == null || services.isEmpty()) { %>
  <div style="text-align:center;padding:40px;color:var(--text-2)">No services available at the moment.</div>
  <% } else { %>
  <div class="service-grid">
    <% for (Service svc : services) { %>
    <a href="?step=2&serviceId=<%= svc.getServiceId() %>" class="service-card">
      <div class="check"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l4 4L19 6"/></svg></div>
      <div class="name"><%= svc.getServiceName() %></div>
      <div class="meta"><%= svc.getDurationMin() %> min<% if (svc.getDescription() != null && !svc.getDescription().isEmpty()) { %> &middot; <%= svc.getDescription().length() > 30 ? svc.getDescription().substring(0,30)+"…" : svc.getDescription() %><% } %></div>
      <div class="price mono">&pound;<%= String.format("%.2f", svc.getPrice()) %></div>
    </a>
    <% } %>
  </div>
  <% } %>

  <%-- Step 2: Employee --%>
  <% } else if (step == 2) { %>
  <h2 class="h2" style="margin-bottom:6px">Choose an employee</h2>
  <p class="muted" style="margin-bottom:24px">Pick a preferred specialist.</p>
  <% if (employees == null || employees.isEmpty()) { %>
  <div style="text-align:center;padding:40px;color:var(--text-2)">No staff available for this service. Please check back later.</div>
  <% } else { %>
  <div class="employee-grid">
    <% for (Employee emp : employees) {
           String initials = emp.getFullName() != null && !emp.getFullName().isEmpty()
               ? emp.getFullName().trim().split("\\s+").length > 1
                 ? ("" + emp.getFullName().trim().split("\\s+")[0].charAt(0) + emp.getFullName().trim().split("\\s+")[1].charAt(0)).toUpperCase()
                 : ("" + emp.getFullName().charAt(0)).toUpperCase()
               : "?";
    %>
    <a href="?step=3&serviceId=<%= selectedServiceId %>&employeeId=<%= emp.getEmployeeId() %>" class="employee-card">
      <div class="avatar"><%= initials %></div>
      <div class="grow">
        <div style="font-weight:600"><%= emp.getFullName() != null ? emp.getFullName() : "Staff #"+emp.getEmployeeId() %></div>
        <div class="muted small"><%= emp.getDesignation() %></div>
      </div>
    </a>
    <% } %>
  </div>
  <% } %>
  <div class="between" style="margin-top:24px;padding-top:20px;border-top:1px solid var(--border)">
    <a href="?step=1" class="btn btn-secondary">&#8592; Back</a>
  </div>

  <%-- Step 3: Date & Slot --%>
  <% } else if (step == 3) { %>
  <h2 class="h2" style="margin-bottom:6px">Pick a time</h2>
  <p class="muted" style="margin-bottom:20px">Available slots with <%= selectedEmployee != null && selectedEmployee.getFullName() != null ? selectedEmployee.getFullName() : "your specialist" %>.</p>

  <form method="get" action="<%= ctx %>/views/client/booking.jsp" style="display:flex;gap:10px;align-items:flex-end;margin-bottom:24px">
    <input type="hidden" name="step"       value="3">
    <input type="hidden" name="serviceId"  value="<%= selectedServiceId %>">
    <input type="hidden" name="employeeId" value="<%= selectedEmployeeId %>">
    <div class="field" style="margin:0">
      <label>Select Date</label>
      <input class="input" type="date" name="date" value="<%= selectedDate %>" min="<%= java.time.LocalDate.now().toString() %>" required>
    </div>
    <button class="btn btn-primary" type="submit">Check availability</button>
  </form>

  <% if (slots == null || slots.isEmpty()) { %>
  <div style="text-align:center;padding:32px;color:var(--text-2);border:1px solid var(--border);border-radius:8px">No slots available on this date. Try a different date.</div>
  <% } else { %>
  <div class="slot-grid">
    <% for (String slotTime : slots) { %>
    <a href="?step=4&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&date=<%= selectedDate %>&slotTime=<%= slotTime %>"
       class="slot"><%= slotTime %></a>
    <% } %>
  </div>
  <% } %>
  <div class="between" style="margin-top:24px;padding-top:20px;border-top:1px solid var(--border)">
    <a href="?step=2&serviceId=<%= selectedServiceId %>" class="btn btn-secondary">&#8592; Back</a>
  </div>

  <%-- Step 4/5: Confirm --%>
  <% } else if (step == 4 || step == 5) { %>
  <h2 class="h2" style="margin-bottom:6px">Review your booking</h2>
  <p class="muted" style="margin-bottom:24px">One last look before we confirm.</p>

  <div class="summary" style="max-width:540px;margin-bottom:20px">
    <div class="summary-row"><span class="lbl">Service</span><span class="val"><%= selectedService != null ? selectedService.getServiceName() : "—" %></span></div>
    <div class="summary-row"><span class="lbl">Duration</span><span class="val mono"><%= selectedService != null ? selectedService.getDurationMin()+" min" : "—" %></span></div>
    <div class="summary-row"><span class="lbl">With</span>
      <span class="val">
        <% if (selectedEmployee != null) { %>
        <span style="display:inline-flex;align-items:center;gap:8px">
          <% String ei = selectedEmployee.getFullName() != null && !selectedEmployee.getFullName().isEmpty() ? (selectedEmployee.getFullName().trim().split("\\s+").length > 1 ? ("" + selectedEmployee.getFullName().trim().split("\\s+")[0].charAt(0) + selectedEmployee.getFullName().trim().split("\\s+")[1].charAt(0)).toUpperCase() : ("" + selectedEmployee.getFullName().charAt(0)).toUpperCase()) : "?"; %>
          <span class="avatar" style="width:24px;height:24px;font-size:11px"><%= ei %></span>
          <%= selectedEmployee.getFullName() %>
        </span>
        <% } else { %>—<% } %>
      </span>
    </div>
    <div class="summary-row"><span class="lbl">Date</span><span class="val"><%= selectedDate %></span></div>
    <div class="summary-row"><span class="lbl">Time</span><span class="val mono"><%= selectedSlot %></span></div>
    <div class="summary-row summary-total">
      <span class="lbl" style="font-weight:500;color:var(--text)">Total</span>
      <span class="val">&pound;<%= selectedService != null ? String.format("%.2f", selectedService.getPrice()) : "—" %></span>
    </div>
  </div>

  <p class="muted small" style="max-width:540px;margin-bottom:20px">By confirming, you agree to SlotSync's cancellation policy. Free reschedule up to 4 hours before.</p>

  <form method="post" action="<%= ctx %>/views/client/booking.jsp?step=5&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&date=<%= selectedDate %>&slotTime=<%= selectedSlot %>">
    <div class="between" style="padding-top:20px;border-top:1px solid var(--border)">
      <a href="?step=3&serviceId=<%= selectedServiceId %>&employeeId=<%= selectedEmployeeId %>&date=<%= selectedDate %>" class="btn btn-secondary">&#8592; Back</a>
      <button class="btn btn-primary btn-lg" type="submit">Confirm booking &#8594;</button>
    </div>
  </form>
  <% } %>

</div>
</body>
</html>
