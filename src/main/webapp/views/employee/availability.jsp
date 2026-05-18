<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    String ctx  = request.getContextPath();
    User   user = (User) session.getAttribute("user");
    if (user == null || !"employee".equals(user.getRole())) {
        response.sendRedirect(ctx + "/views/auth/login.jsp");
        return;
    }
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set Availability | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css?v=2">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { display:flex; min-height:100vh; background:#f9fafb; margin:0; font-family:inherit; }

        /* ── Sidebar (same as profile.jsp) ── */
        .emp-sidebar {
            width:200px; min-height:100vh; background:#fff;
            border-right:1px solid var(--border,#e5e7eb);
            display:flex; flex-direction:column; padding:20px 0;
            position:fixed; top:0; left:0; z-index:100;
        }
        .sidebar-brand {
            display:flex; align-items:center; gap:8px;
            padding:0 18px 14px; text-decoration:none;
            color:var(--text,#111); font-weight:700; font-size:15px;
            border-bottom:1px solid var(--border,#e5e7eb);
        }
        .sidebar-brand .brand-mark {
            width:26px; height:26px; border-radius:7px;
            background:var(--blue,#4F6EF7); flex-shrink:0;
        }
        .sidebar-portal-badge {
            margin:12px 18px 4px; display:inline-flex; align-items:center;
            gap:6px; font-size:11px; font-weight:600; color:var(--blue,#4F6EF7);
            background:#e8ecff; border-radius:999px; padding:3px 10px; width:fit-content;
        }
        .sidebar-portal-badge::before {
            content:''; width:6px; height:6px; border-radius:50%; background:var(--blue,#4F6EF7);
        }
        .sidebar-section-label {
            font-size:10px; font-weight:700; letter-spacing:.08em;
            text-transform:uppercase; color:var(--muted,#9ca3af); padding:20px 18px 6px;
        }
        .sidebar-nav { display:flex; flex-direction:column; gap:2px; padding:0 10px; flex:1; }
        .sidebar-link {
            display:flex; align-items:center; gap:10px; padding:9px 12px;
            border-radius:8px; font-size:13.5px; color:var(--muted,#6b7280);
            text-decoration:none; font-weight:500; transition:background .15s,color .15s;
        }
        .sidebar-link:hover { background:#f3f4f6; color:var(--text,#111); }
        .sidebar-link.active { background:#e8ecff; color:var(--blue,#4F6EF7); font-weight:600; }
        .sidebar-footer { padding:12px 10px 4px; border-top:1px solid var(--border,#e5e7eb); margin-top:auto; }
        .sidebar-signout {
            display:flex; align-items:center; gap:10px; padding:9px 12px;
            border-radius:8px; font-size:13.5px; color:var(--muted,#6b7280);
            text-decoration:none; font-weight:500; transition:background .15s,color .15s;
        }
        .sidebar-signout:hover { background:#fef2f2; color:#dc2626; }

        /* ── Main ── */
        .emp-main { margin-left:200px; flex:1; padding:36px 40px; }

        /* ── Page header ── */
        .avail-header {
            display:flex; align-items:flex-start; justify-content:space-between;
            margin-bottom:6px;
        }
        .avail-title { font-size:22px; font-weight:700; color:var(--text,#111); margin:0; }
        .save-btn {
            padding:9px 20px; background:var(--blue,#4F6EF7); color:#fff;
            border:none; border-radius:8px; font-size:13.5px; font-weight:600;
            cursor:pointer; font-family:inherit; transition:background .18s,transform .15s;
            white-space:nowrap;
        }
        .save-btn:hover { background:#3d5ce8; transform:translateY(-1px); }
        .avail-sub { font-size:13px; color:var(--muted,#6b7280); margin:0 0 10px; }
        .avail-sub a { color:var(--blue,#4F6EF7); text-decoration:none; }
        .status-bar {
            display:flex; align-items:center; gap:6px;
            font-size:13px; color:var(--text,#111); margin-bottom:28px;
        }
        .status-dot { width:7px; height:7px; border-radius:50%; background:#22c55e; flex-shrink:0; }

        /* Flash */
        .av-alert { padding:9px 13px; border-radius:7px; font-size:13px; font-weight:500; margin-bottom:16px; }
        .av-alert-success { background:#ecfdf5; color:#065f46; border:1px solid #6ee7b7; }
        .av-alert-error   { background:#fef2f2; color:#991b1b; border:1px solid #fca5a5; }

        /* ── Availability table ── */
        .avail-table-wrap {
            background:#fff; border:1px solid var(--border,#e5e7eb);
            border-radius:12px; overflow:hidden;
        }
        .avail-table {
            width:100%; border-collapse:collapse;
        }
        .avail-table thead th {
            padding:10px 20px; text-align:left;
            font-size:10.5px; font-weight:700; letter-spacing:.07em;
            text-transform:uppercase; color:var(--muted,#9ca3af);
            background:#fafafa; border-bottom:1px solid var(--border,#e5e7eb);
        }
        .avail-table tbody tr {
            border-bottom:1px solid var(--border,#e5e7eb);
            transition:background .15s;
        }
        .avail-table tbody tr:last-child { border-bottom:none; }
        .avail-table tbody tr:hover { background:#fafafa; }
        .avail-table td { padding:14px 20px; vertical-align:middle; }

        /* Day label */
        .day-label { font-size:14px; font-weight:600; color:var(--text,#111); width:70px; }

        /* Toggle switch */
        .toggle-wrap { width:80px; }
        .toggle-label { display:inline-flex; align-items:center; cursor:pointer; }
        .toggle-input { display:none; }
        .toggle-track {
            width:40px; height:22px; border-radius:999px;
            background:#d1d5db; position:relative; transition:background .2s;
        }
        .toggle-input:checked + .toggle-track { background:var(--blue,#4F6EF7); }
        .toggle-thumb {
            position:absolute; top:3px; left:3px;
            width:16px; height:16px; border-radius:50%;
            background:#fff; transition:left .2s;
            box-shadow:0 1px 3px rgba(0,0,0,.2);
        }
        .toggle-input:checked + .toggle-track .toggle-thumb { left:21px; }

        /* Time input cell */
        .time-cell { display:flex; align-items:center; gap:8px; }
        .time-input-wrap { position:relative; display:inline-flex; align-items:center; }
        .time-input {
            padding:7px 36px 7px 12px; border:1px solid var(--border,#e5e7eb);
            border-radius:8px; font-size:13.5px; font-family:inherit;
            color:var(--text,#111); background:#fff; outline:none;
            width:130px; transition:border-color .18s,box-shadow .18s;
        }
        .time-input:focus { border-color:var(--blue,#4F6EF7); box-shadow:0 0 0 3px rgba(79,110,247,.12); }
        .time-icon {
            position:absolute; right:10px; color:var(--muted,#9ca3af); pointer-events:none;
        }

        /* Disabled row (Sun) */
        .row-disabled .time-input { background:#f9fafb; color:#9ca3af; }
        .row-disabled .day-label  { color:#9ca3af; }

        @media (max-width:700px) {
            .emp-main { padding:24px 12px; }
            .time-input { width:100px; }
        }
    </style>
</head>
<body>

<%-- ══ SIDEBAR ══ --%>
<aside class="emp-sidebar" id="emp-sidebar">
    <a href="<%= ctx %>/" class="sidebar-brand">
        <div class="brand-mark"></div>SlotSync
    </a>
    <div class="sidebar-portal-badge">Employee Portal</div>
    <div class="sidebar-section-label">My Work</div>
    <nav class="sidebar-nav">
        <a href="<%= ctx %>/employee?action=list" class="sidebar-link" id="sidebar-schedule">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>
            Schedule
        </a>
        <a href="<%= ctx %>/views/employee/availability.jsp" class="sidebar-link active" id="sidebar-availability">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            Set availability
        </a>
        <a href="<%= ctx %>/views/employee/profile.jsp" class="sidebar-link" id="sidebar-profile">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Profile
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= ctx %>/logout" class="sidebar-signout" id="sidebar-signout">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
            Sign out
        </a>
    </div>
</aside>

<%-- ══ MAIN ══ --%>
<main class="emp-main" id="emp-main">

    <div class="avail-header">
        <h1 class="avail-title">Set availability</h1>
        <button type="submit" form="avail-form" class="save-btn" id="avail-save-btn">Save changes</button>
    </div>
    <p class="avail-sub">Toggle days and set hours. Clients see only available slots.</p>
    <div class="status-bar">
        <span class="status-dot"></span>
        Working at Sharp Salon &nbsp;&middot;&nbsp; Senior Stylist
    </div>

    <% if (success != null) { %>
        <div class="av-alert av-alert-success">✔ <%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="av-alert av-alert-error">✖ <%= error %></div>
    <% } %>

    <form action="<%= ctx %>/employee?action=saveAvailability" method="post" id="avail-form">
    <div class="avail-table-wrap">
        <table class="avail-table" id="avail-table">
            <thead>
                <tr>
                    <th>Day</th>
                    <th>Available</th>
                    <th>Start</th>
                    <th>End</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String[][] days = {
                        {"Mon","mon","09:00","18:00","on"},
                        {"Tue","tue","09:00","18:00","on"},
                        {"Wed","wed","09:00","18:00","on"},
                        {"Thu","thu","09:00","18:00","on"},
                        {"Fri","fri","09:00","18:00","on"},
                        {"Sat","sat","09:00","14:00","on"},
                        {"Sun","sun","09:00","18:00","off"}
                    };
                    for (String[] d : days) {
                        boolean isOn = "on".equals(d[4]);
                        String rowClass = isOn ? "" : "row-disabled";
                %>
                <tr class="<%= rowClass %>" id="row-<%= d[1] %>">
                    <td><span class="day-label"><%= d[0] %></span></td>
                    <td class="toggle-wrap">
                        <label class="toggle-label" aria-label="<%= d[0] %> available">
                            <input type="checkbox" name="avail_<%= d[1] %>" class="toggle-input day-toggle"
                                   data-row="row-<%= d[1] %>" <%= isOn ? "checked" : "" %>>
                            <span class="toggle-track">
                                <span class="toggle-thumb"></span>
                            </span>
                        </label>
                    </td>
                    <td>
                        <div class="time-cell">
                            <div class="time-input-wrap">
                                <input type="time" name="start_<%= d[1] %>" value="<%= d[2] %>"
                                       class="time-input" id="start-<%= d[1] %>">
                                <svg class="time-icon" width="15" height="15" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                </svg>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="time-cell">
                            <div class="time-input-wrap">
                                <input type="time" name="end_<%= d[1] %>" value="<%= d[3] %>"
                                       class="time-input" id="end-<%= d[1] %>">
                                <svg class="time-icon" width="15" height="15" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                </svg>
                            </div>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    </form>

</main>

<script>
    // Toggle row disabled state when day checkbox is clicked
    document.querySelectorAll('.day-toggle').forEach(function(cb) {
        cb.addEventListener('change', function() {
            var row = document.getElementById(this.dataset.row);
            if (this.checked) {
                row.classList.remove('row-disabled');
                row.querySelectorAll('.time-input').forEach(function(i){ i.disabled = false; });
            } else {
                row.classList.add('row-disabled');
                row.querySelectorAll('.time-input').forEach(function(i){ i.disabled = true; });
            }
        });
        // Apply initial disabled state
        if (!cb.checked) {
            var row = document.getElementById(cb.dataset.row);
            row.querySelectorAll('.time-input').forEach(function(i){ i.disabled = true; });
        }
    });
</script>

</body>
</html>
