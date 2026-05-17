<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Employee" %>
<%@ page import="dao.EmployeeDAO" %>

<%
    // Session check — only owner
    if (session == null || session.getAttribute("userId") == null
            || !"owner".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int businessId = (int) session.getAttribute("businessId");

    EmployeeDAO employeeDAO = new EmployeeDAO();
    List<Employee> employees = employeeDAO.getByBusinessId(businessId);

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Employees — SlotSync</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .page-wrapper {
            padding: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: var(--text-primary, #fff);
        }

        .msg {
            padding: 0.8rem 1.2rem;
            border-radius: 6px;
            margin-bottom: 1.2rem;
            font-size: 0.95rem;
        }
        .msg-success { background: #1a3a1a; color: #5adb5a; border: 1px solid #2d6b2d; }
        .msg-error   { background: #3a1a1a; color: #db5a5a; border: 1px solid #6b2d2d; }

        /* ── Add Employee Form ── */
        .card {
            background: #1e1e2e;
            border: 1px solid #333;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .card h2 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1.2rem;
            color: #ccc;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .form-group label {
            font-size: 0.85rem;
            color: #888;
        }

        .form-group input,
        .form-group select {
            padding: 0.6rem 0.8rem;
            border-radius: 6px;
            background: #12121e;
            border: 1px solid #444;
            color: #ddd;
            font-size: 0.9rem;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #6c63ff;
        }

        .btn-submit {
            margin-top: 1rem;
            padding: 0.65rem 1.8rem;
            background: #6c63ff;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 0.95rem;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-submit:hover { opacity: 0.88; }

        /* ── Employee Table ── */
        .table-wrapper { overflow-x: auto; }

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

        .badge {
            display: inline-block;
            padding: 0.25rem 0.7rem;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 600;
        }
        .badge-active   { background: #102a10; color: #4cdc4c; }
        .badge-inactive { background: #2a1010; color: #e05555; }

        .btn {
            display: inline-block;
            padding: 0.35rem 0.8rem;
            border-radius: 5px;
            font-size: 0.82rem;
            cursor: pointer;
            border: none;
            margin-right: 0.3rem;
            text-decoration: none;
        }
        .btn-remove  { background: #6b2d2d; color: #fff; }
        .btn:hover   { opacity: 0.85; }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <jsp:include page="/views/common/navbar.jsp" />

    <div class="page-wrapper">

        <h1 class="page-title">Manage Employees</h1>

        <% if (successMsg != null) { %>
            <div class="msg msg-success"><%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="msg msg-error"><%= errorMsg %></div>
        <% } %>

        <%-- Add Employee Form --%>
        <div class="card">
            <h2>Add New Employee</h2>
            <form action="<%= request.getContextPath() %>/EmployeeServlet"
                  method="post"
                  onsubmit="return validateEmployeeForm()">

                <input type="hidden" name="action"     value="add" />
                <input type="hidden" name="businessId" value="<%= businessId %>" />

                <div class="form-grid">

                    <div class="form-group">
                        <label for="userId">User ID (Employee's registered ID)</label>
                        <input type="number"
                               id="userId"
                               name="userId"
                               placeholder="e.g. 5"
                               required />
                    </div>

                    <div class="form-group">
                        <label for="designation">Designation</label>
                        <input type="text"
                               id="designation"
                               name="designation"
                               placeholder="e.g. Hairstylist"
                               required />
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text"
                               id="phone"
                               name="phone"
                               placeholder="e.g. 9800000000"
                               required />
                    </div>

                </div>

                <button type="submit" class="btn-submit">Add Employee</button>
            </form>
        </div>

        <%-- Employee List Table --%>
        <div class="card">
            <h2>Current Employees (<%= employees.size() %>)</h2>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Employee ID</th>
                            <th>User ID</th>
                            <th>Designation</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (employees.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" class="empty-state">
                                No employees added yet.
                            </td>
                        </tr>
                    <%
                        } else {
                            int i = 1;
                            for (Employee emp : employees) {
                    %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><%= emp.getEmployeeId() %></td>
                            <td><%= emp.getUserId() %></td>
                            <td><%= emp.getDesignation() %></td>
                            <td><%= emp.getPhone() %></td>
                            <td>
                                <span class="badge badge-<%= emp.getStatus() %>">
                                    <%= emp.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <%-- Remove (soft delete) button --%>
                                <form style="display:inline"
                                      action="<%= request.getContextPath() %>/EmployeeServlet"
                                      method="post"
                                      onsubmit="return confirm('Remove this employee?')">
                                    <input type="hidden" name="action"     value="remove" />
                                    <input type="hidden" name="employeeId" value="<%= emp.getEmployeeId() %>" />
                                    <button type="submit" class="btn btn-remove">Remove</button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <jsp:include page="/views/common/footer.jsp" />

    <script>
        function validateEmployeeForm() {
            var userId      = document.getElementById('userId').value.trim();
            var designation = document.getElementById('designation').value.trim();
            var phone       = document.getElementById('phone').value.trim();

            if (userId === '' || designation === '' || phone === '') {
                alert('All fields are required.');
                return false;
            }

            if (isNaN(userId) || parseInt(userId) <= 0) {
                alert('User ID must be a valid number.');
                return false;
            }

            if (!/^\d{10}$/.test(phone)) {
                alert('Phone number must be 10 digits.');
                return false;
            }

            if (/\d/.test(designation)) {
                alert('Designation cannot contain numbers.');
                return false;
            }

            return true;
        }
    </script>

</body>
</html>