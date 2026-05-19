<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.AppointmentDAO" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="dao.EmployeeDAO" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Feedback" %>
<%
    if (session.getAttribute("userId") == null || !"owner".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    int businessId = (int) session.getAttribute("businessId");

    AppointmentDAO appointmentDAO = new AppointmentDAO();
    FeedbackDAO    feedbackDAO    = new FeedbackDAO();
    EmployeeDAO    employeeDAO    = new EmployeeDAO();
    ServiceDAO     serviceDAO     = new ServiceDAO();

    List<Appointment> allAppointments = appointmentDAO.getByBusinessId(businessId);
    List<Feedback>    allFeedback     = feedbackDAO.getFeedbackByBusiness(businessId);
    double            avgRating       = feedbackDAO.getAverageRating(businessId);

    int totalBookings  = allAppointments.size();
    int totalEmployees = employeeDAO.getByBusinessId(businessId).size();
    int totalReviews   = allFeedback.size();

    double totalRevenue   = 0;
    int    completedCount = 0;
    int    pendingCount   = 0;
    int    cancelledCount = 0;

    for (Appointment a : allAppointments) {
        String status = a.getStatus();
        if ("completed".equalsIgnoreCase(status)) {
            totalRevenue += a.getPrice();
            completedCount++;
        } else if ("pending".equalsIgnoreCase(status) || "confirmed".equalsIgnoreCase(status)) {
            pendingCount++;
        } else if ("cancelled".equalsIgnoreCase(status)) {
            cancelledCount++;
        }
    }

    List<Appointment> recentAppointments = allAppointments.subList(0, Math.min(5, allAppointments.size()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync — Owner Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="/views/common/navbar.jsp" %>
<main class="container">

    <section class="page-header">
        <h1>Owner Dashboard</h1>
        <p class="subtitle">Welcome back, <%= session.getAttribute("userName") %>!</p>
    </section>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">&#128197;</div>
            <div class="stat-info">
                <span class="stat-value"><%= totalBookings %></span>
                <span class="stat-label">Total Bookings</span>
            </div>
        </div>
        <div class="stat-card stat-green">
            <div class="stat-icon">&#128176;</div>
            <div class="stat-info">
                <span class="stat-value">Rs. <%= String.format("%,.2f", totalRevenue) %></span>
                <span class="stat-label">Total Revenue</span>
            </div>
        </div>
        <div class="stat-card stat-blue">
            <div class="stat-icon">&#128100;</div>
            <div class="stat-info">
                <span class="stat-value"><%= totalEmployees %></span>
                <span class="stat-label">Employees</span>
            </div>
        </div>
        <div class="stat-card stat-purple">
            <div class="stat-icon">&#9733;</div>
            <div class="stat-info">
                <span class="stat-value"><%= avgRating > 0 ? String.format("%.1f", avgRating) : "N/A" %></span>
                <span class="stat-label">Avg Rating (<%= totalReviews %> reviews)</span>
            </div>
        </div>
    </div>

    <div class="card section">
        <h2>Appointment Breakdown</h2>
        <div class="status-breakdown">
            <div class="status-item status-completed">
                <span class="status-count"><%= completedCount %></span>
                <span class="status-label">Completed</span>
            </div>
            <div class="status-item status-pending">
                <span class="status-count"><%= pendingCount %></span>
                <span class="status-label">Pending / Confirmed</span>
            </div>
            <div class="status-item status-cancelled">
                <span class="status-count"><%= cancelledCount %></span>
                <span class="status-label">Cancelled</span>
            </div>
        </div>
    </div>

    <div class="card section">
        <div class="card-header-row">
            <h2>Recent Appointments</h2>
            <a href="<%= request.getContextPath() %>/views/owner/appointments.jsp" class="btn btn-secondary btn-sm">View All</a>
        </div>
        <% if (recentAppointments.isEmpty()) { %>
            <div class="empty-state"><p>No appointments yet.</p></div>
        <% } else { %>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>#</th><th>Client</th><th>Service</th><th>Employee</th><th>Date</th><th>Time</th><th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Appointment a : recentAppointments) { %>
                    <tr>
                        <td><%= a.getAppointmentId() %></td>
                        <td><%= a.getClientName() != null ? a.getClientName() : "—" %></td>
                        <td><%= a.getServiceName() != null ? a.getServiceName() : "—" %></td>
                        <td><%= a.getEmployeeName() != null ? a.getEmployeeName() : "—" %></td>
                        <td><%= a.getAppointmentDate() %></td>
                        <td><%= a.getStartTime() %></td>
                        <td><span class="badge badge-<%= a.getStatus().toLowerCase() %>"><%= a.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <div class="quick-links card section">
        <h2>Quick Actions</h2>
        <div class="quick-link-grid">
            <a href="<%= request.getContextPath() %>/views/owner/manage-services.jsp" class="quick-link-btn">&#9881; Manage Services</a>
            <a href="<%= request.getContextPath() %>/views/owner/manage-employees.jsp" class="quick-link-btn">&#128100; Manage Employees</a>
            <a href="<%= request.getContextPath() %>/views/owner/appointments.jsp" class="quick-link-btn">&#128197; All Appointments</a>
            <a href="<%= request.getContextPath() %>/views/owner/settings.jsp" class="quick-link-btn">&#9881; Business Settings</a>
        </div>
    </div>

</main>
<%@ include file="/views/common/footer.jsp" %>
</body>
</html>