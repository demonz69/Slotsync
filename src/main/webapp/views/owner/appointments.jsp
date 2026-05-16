<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Appointment" %>
<%@ page import="dao.AppointmentDAO" %>
<%@ page import="dao.EmployeeDAO" %>
<%@ page import="model.Employee" %>

<%
    // Session check — only owner can access this page
    if (session == null || session.getAttribute("userId") == null
            || !"owner".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int businessId = (int) session.getAttribute("businessId");

    // Load all appointments for this business
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> appointments = appointmentDAO.getAppointmentsByBusiness(businessId);

    // Load all employees for assign dropdown
    EmployeeDAO employeeDAO = new EmployeeDAO();
    List<Employee> employees = employeeDAO.getByBusinessId(businessId);

    // Get success/error messages from session
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");

    // Get filter param — filter by status if provided
    String filterStatus = request.getParameter("status");
    if (filterStatus == null) filterStatus = "all";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments — SlotSync</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .page-wrapper {
            padding: 2rem;
            max-width: 1100px;
            margin: 0 auto;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: var(--text-primary, #fff);
        }

        /* ── Messages ── */
        .msg {
            padding: 0.8rem 1.2rem;
            border-radius: 6px;
            margin-bottom: 1.2rem;
            font-size: 0.95rem;
        }
        .msg-success { background: #1a3a1a; color: #5adb5a; border: 1px solid #2d6b2d; }
        .msg-error   { background: #3a1a1a; color: #db5a5a; border: 1px solid #6b2d2d; }

        /* ── Filter bar ── */
        .filter-bar {
            display: flex;
            gap: 0.6rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .filter-bar a {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.88rem;
            border: 1px solid #444;
            color: #ccc;
            transition: 0.2s;
        }

        .filter-bar a.active,
        .filter-bar a:hover {
            background: #6c63ff;
            color: #fff;
            border-color: #6c63ff;
        }

        /* ── Table ── */
        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        thead tr {
            background: #1e1e2e;
            color: #aaa;
            text-transform: uppercase;
            font-size: 0.78rem;
            letter-spacing: 0.05em;
        }

        thead th {
            padding: 0.9rem 1rem;
            text-align: left;
            border-bottom: 1px solid #333;
        }

        tbody tr {
            border-bottom: 1px solid #2a2a2a;
            transition: background 0.15s;
        }

        tbody tr:hover { background: #1a1a2a; }

        tbody td {
            padding: 0.85rem 1rem;
            color: #ddd;
            vertical-align: middle;
        }

        /* ── Status badges ── */
        .badge {
            display: inline-block;
            padding: 0.25rem 0.7rem;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 600;
            text-transform: capitalize;
        }
        .badge-pending   { background: #3a3010; color: #f5c842; }
        .badge-confirmed { background: #102a10; color: #4cdc4c; }
        .badge-cancelled { background: #2a1010; color: #e05555; }
        .badge-completed { background: #102030; color: #4ab8f5; }

        /* ── Action buttons ── */
        .btn {
            display: inline-block;
            padding: 0.35rem 0.8rem;
            border-radius: 5px;
            font-size: 0.82rem;
            cursor: pointer;
            border: none;
            text-decoration: none;
            margin-right: 0.3rem;
        }
        .btn-confirm  { background: #2d6b2d; color: #fff; }
        .btn-cancel   { background: #6b2d2d; color: #fff; }
        .btn-complete { background: #2d4a6b; color: #fff; }
        .btn:hover    { opacity: 0.85; }

        /* ── Assign form ── */
        .assign-form {
            display: flex;
            gap: 0.4rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .assign-form select {
            padding: 0.3rem 0.5rem;
            border-radius: 5px;
            background: #1e1e2e;
            color: #ddd;
            border: 1px solid #444;
            font-size: 0.82rem;
        }

        .btn-assign {
            background: #6c63ff;
            color: #fff;
            padding: 0.3rem 0.7rem;
            border-radius: 5px;
            border: none;
            font-size: 0.82rem;
            cursor: pointer;
        }
        .btn-assign:hover { opacity: 0.85; }

        /* ── Empty state ── */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
            font-size: 1rem;
        }

        /* ── Summary cards ── */
        .summary-cards {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .summary-card {
            flex: 1;
            min-width: 140px;
            background: #1e1e2e;
            border-radius: 8px;
            padding: 1rem 1.2rem;
            border: 1px solid #333;
        }

        .summary-card .count {
            font-size: 1.8rem;
            font-weight: 700;
            color: #6c63ff;
        }

        .summary-card .label {
            font-size: 0.82rem;
            color: #888;
            margin-top: 0.2rem;
        }
    </style>
</head>
<body>

    <%-- Navbar --%>
    <jsp:include page="/views/common/navbar.jsp" />

    <div class="page-wrapper">

        <h1 class="page-title">All Appointments</h1>

        <%-- Success / Error messages --%>
        <% if (successMsg != null) { %>
            <div class="msg msg-success"><%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="msg msg-error"><%= errorMsg %></div>
        <% } %>

        <%-- Summary count cards --%>
        <%
            int totalCount     = 0;
            int pendingCount   = 0;
            int confirmedCount = 0;
            int cancelledCount = 0;
            int completedCount = 0;

            for (Appointment a : appointments) {
                totalCount++;
                switch (a.getStatus()) {
                    case "pending":   pendingCount++;   break;
                    case "confirmed": confirmedCount++; break;
                    case "cancelled": cancelledCount++; break;
                    case "completed": completedCount++; break;
                }
            }
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="count"><%= totalCount %></div>
                <div class="label">Total</div>
            </div>
            <div class="summary-card">
                <div class="count"><%= pendingCount %></div>
                <div class="label">Pending</div>
            </div>
            <div class="summary-card">
                <div class="count"><%= confirmedCount %></div>
                <div class="label">Confirmed</div>
            </div>
            <div class="summary-card">
                <div class="count"><%= completedCount %></div>
                <div class="label">Completed</div>
            </div>
            <div class="summary-card">
                <div class="count"><%= cancelledCount %></div>
                <div class="label">Cancelled</div>
            </div>
        </div>

        <%-- Filter bar --%>
        <div class="filter-bar">
            <a href="?status=all"       class="<%= "all".equals(filterStatus)       ? "active" : "" %>">All</a>
            <a href="?status=pending"   class="<%= "pending".equals(filterStatus)   ? "active" : "" %>">Pending</a>
            <a href="?status=confirmed" class="<%= "confirmed".equals(filterStatus) ? "active" : "" %>">Confirmed</a>
            <a href="?status=completed" class="<%= "completed".equals(filterStatus) ? "active" : "" %>">Completed</a>
            <a href="?status=cancelled" class="<%= "cancelled".equals(filterStatus) ? "active" : "" %>">Cancelled</a>
        </div>

        <%-- Appointments table --%>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Client ID</th>
                        <th>Service ID</th>
                        <th>Employee</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasRows = false;
                    for (Appointment apt : appointments) {

                        // Apply filter
                        if (!"all".equals(filterStatus) &&
                            !filterStatus.equals(apt.getStatus())) {
                            continue;
                        }

                        hasRows = true;
                %>
                    <tr>
                        <td><%= apt.getAppointmentId() %></td>
                        <td><%= apt.getClientId() %></td>
                        <td><%= apt.getServiceId() %></td>

                        <%-- Assign employee dropdown --%>
                        <td>
                            <form class="assign-form"
                                  action="<%= request.getContextPath() %>/AppointmentServlet"
                                  method="post">
                                <input type="hidden" name="action"        value="assign" />
                                <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>" />
                                <select name="employeeId">
                                    <% for (Employee emp : employees) { %>
                                        <option value="<%= emp.getEmployeeId() %>"
                                            <%= emp.getEmployeeId() == apt.getEmployeeId()
                                                ? "selected" : "" %>>
                                            <%= emp.getDesignation() %>
                                        </option>
                                    <% } %>
                                </select>
                                <button type="submit" class="btn-assign">Assign</button>
                            </form>
                        </td>

                        <td><%= apt.getAppointmentDate() %></td>
                        <td><%= apt.getSlotTime() %></td>

                        <%-- Status badge --%>
                        <td>
                            <span class="badge badge-<%= apt.getStatus() %>">
                                <%= apt.getStatus() %>
                            </span>
                        </td>

                        <%-- Action buttons --%>
                        <td>
                            <% if ("pending".equals(apt.getStatus())) { %>

                                <%-- Confirm button --%>
                                <form style="display:inline"
                                      action="<%= request.getContextPath() %>/AppointmentServlet"
                                      method="post">
                                    <input type="hidden" name="action"        value="updateStatus" />
                                    <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>" />
                                    <input type="hidden" name="status"        value="confirmed" />
                                    <button type="submit" class="btn btn-confirm">Confirm</button>
                                </form>

                            <% } %>

                            <% if ("confirmed".equals(apt.getStatus())) { %>

                                <%-- Mark Complete button --%>
                                <form style="display:inline"
                                      action="<%= request.getContextPath() %>/AppointmentServlet"
                                      method="post">
                                    <input type="hidden" name="action"        value="updateStatus" />
                                    <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>" />
                                    <input type="hidden" name="status"        value="completed" />
                                    <button type="submit" class="btn btn-complete">Complete</button>
                                </form>

                            <% } %>

                            <% if (!"cancelled".equals(apt.getStatus()) &&
                                   !"completed".equals(apt.getStatus())) { %>

                                <%-- Cancel button --%>
                                <form style="display:inline"
                                      action="<%= request.getContextPath() %>/AppointmentServlet"
                                      method="post"
                                      onsubmit="return confirm('Cancel this appointment?')">
                                    <input type="hidden" name="action"        value="cancel" />
                                    <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>" />
                                    <button type="submit" class="btn btn-cancel">Cancel</button>
                                </form>

                            <% } %>
                        </td>
                    </tr>
                <%
                    } // end for

                    if (!hasRows) {
                %>
                    <tr>
                        <td colspan="8" class="empty-state">
                            No appointments found for this filter.
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <%-- Footer --%>
    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>