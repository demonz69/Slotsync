<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    String ctx  = request.getContextPath();
    User   user = (User) session.getAttribute("user");
    if (user == null || !"employee".equals(user.getRole())) {
        response.sendRedirect(ctx + "/views/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css?v=2">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { display:flex; min-height:100vh; background:#f9fafb; margin:0; font-family:inherit; }

        /* ΓöÇΓöÇ Sidebar ΓöÇΓöÇ */
        .emp-sidebar {
            width:200px; min-height:100vh; background:#fff;
            border-right:1px solid var(--border,#e5e7eb);
            display:flex; flex-direction:column; padding:20px 0;
            position:fixed; top:0; left:0; z-index:100;
        }
        .sidebar-brand {
            display:flex; align-items:center; gap:8px; padding:0 18px 14px;
            text-decoration:none; color:var(--text,#111); font-weight:700; font-size:15px;
            border-bottom:1px solid var(--border,#e5e7eb);
        }
        .sidebar-brand .brand-mark { width:26px; height:26px; border-radius:7px; background:var(--blue,#4F6EF7); flex-shrink:0; }
        .sidebar-portal-badge {
            margin:12px 18px 4px; display:inline-flex; align-items:center; gap:6px;
            font-size:11px; font-weight:600; color:var(--blue,#4F6EF7); background:#e8ecff;
            border-radius:999px; padding:3px 10px; width:fit-content;
        }
        .sidebar-portal-badge::before { content:''; width:6px; height:6px; border-radius:50%; background:var(--blue,#4F6EF7); }
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

        /* ΓöÇΓöÇ Main ΓöÇΓöÇ */
        .emp-main { margin-left:200px; flex:1; padding:36px 40px; }

        /* ΓöÇΓöÇ Page header ΓöÇΓöÇ */
        .sched-title { font-size:22px; font-weight:700; color:var(--text,#111); margin:0 0 4px; }
        .sched-date  { font-size:13px; color:var(--muted,#6b7280); margin:0 0 10px; }
        .status-bar  { display:flex; align-items:center; gap:6px; font-size:13px; color:var(--text,#111); margin-bottom:24px; }
        .status-dot  { width:7px; height:7px; border-radius:50%; background:#22c55e; flex-shrink:0; }

        /* ΓöÇΓöÇ Top row ΓöÇΓöÇ */
        .sched-top-row {
            display:grid; grid-template-columns:1.3fr 1fr;
            gap:20px; margin-bottom:20px;
        }

        /* Card base */
        .sched-card {
            background:#fff; border:1px solid var(--border,#e5e7eb);
            border-radius:12px; padding:20px 22px;
        }
        .card-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:4px; }
        .card-title  { font-size:14.5px; font-weight:700; color:var(--text,#111); margin:0; }
        .card-sub    { font-size:12px; color:var(--muted,#9ca3af); margin:0 0 16px; }

        /* Live badge */
        .live-badge {
            display:inline-flex; align-items:center; gap:5px;
            font-size:11px; font-weight:600; color:var(--blue,#4F6EF7);
            background:#e8ecff; border-radius:999px; padding:3px 10px;
        }
        .live-badge::before { content:''; width:6px; height:6px; border-radius:50%; background:var(--blue,#4F6EF7); }

        /* ΓöÇΓöÇ Appointment rows ΓöÇΓöÇ */
        .appt-row {
            display:flex; align-items:center; gap:14px;
            padding:11px 0; border-top:1px solid var(--border,#e5e7eb);
        }
        .appt-time  { font-size:13px; font-weight:600; color:var(--text,#111); width:44px; flex-shrink:0; font-variant-numeric:tabular-nums; }
        .appt-info  { flex:1; }
        .appt-name  { font-size:13.5px; font-weight:600; color:var(--text,#111); margin:0 0 2px; }
        .appt-svc   { font-size:12px; color:var(--muted,#9ca3af); }
        .status-badge {
            display:inline-flex; align-items:center; gap:5px;
            font-size:11.5px; font-weight:600; border-radius:999px; padding:3px 10px; flex-shrink:0;
        }
        .status-badge::before { content:''; width:6px; height:6px; border-radius:50%; }
        .badge-confirmed { color:#16a34a; background:#f0fdf4; }
        .badge-confirmed::before { background:#22c55e; }
        .badge-pending   { color:#d97706; background:#fffbeb; }
        .badge-pending::before   { background:#f59e0b; }

        /* ΓöÇΓöÇ Bar chart ΓöÇΓöÇ */
        .bar-chart {
            display:flex; align-items:flex-end; gap:8px;
            height:100px; margin-top:12px; padding-bottom:20px; position:relative;
        }
        .bar-col { display:flex; flex-direction:column; align-items:center; flex:1; gap:4px; }
        .bar-count { font-size:10px; font-weight:600; color:var(--text,#111); }
        .bar {
            width:100%; border-radius:5px 5px 0 0;
            background:var(--blue,#4F6EF7); transition:height .3s;
        }
        .bar-label { font-size:10px; color:var(--muted,#9ca3af); position:absolute; bottom:0; width:100%; display:flex; gap:8px; }
        .bar-label span { flex:1; text-align:center; }

        /* ΓöÇΓöÇ Upcoming week table ΓöÇΓöÇ */
        .upcoming-table-wrap { background:#fff; border:1px solid var(--border,#e5e7eb); border-radius:12px; overflow:hidden; }
        .upcoming-header { padding:18px 22px 6px; }
        .upcoming-title  { font-size:14.5px; font-weight:700; color:var(--text,#111); margin:0 0 2px; }
        .upcoming-sub    { font-size:12px; color:var(--muted,#9ca3af); margin:0; }

        .upcoming-table { width:100%; border-collapse:collapse; }
        .upcoming-table thead th {
            padding:10px 22px; text-align:left; font-size:10px; font-weight:700;
            letter-spacing:.07em; text-transform:uppercase; color:var(--muted,#9ca3af);
            border-top:1px solid var(--border,#e5e7eb); border-bottom:1px solid var(--border,#e5e7eb);
            background:#fafafa;
        }
        .upcoming-table thead th.col-bookings,
        .upcoming-table thead th.col-load { text-align:right; }
        .upcoming-table tbody tr { border-bottom:1px solid var(--border,#e5e7eb); }
        .upcoming-table tbody tr:last-child { border-bottom:none; }
        .upcoming-table tbody tr:hover { background:#fafafa; }
        .upcoming-table td { padding:13px 22px; font-size:13.5px; color:var(--text,#111); }
        .td-bookings { text-align:right; font-weight:600; width:80px; }
        .td-load { width:220px; text-align:right; }

        /* Progress bar */
        .load-bar-wrap { display:flex; align-items:center; justify-content:flex-end; }
        .load-bar-track { width:140px; height:4px; background:#e5e7eb; border-radius:999px; overflow:hidden; }
        .load-bar-fill  { height:100%; background:var(--blue,#4F6EF7); border-radius:999px; }

        @media (max-width:800px) {
            .sched-top-row { grid-template-columns:1fr; }
            .emp-main { padding:24px 12px; }
        }
    </style>
</head>
<body>

<%-- ΓòÉΓòÉ SIDEBAR ΓòÉΓòÉ --%>
<aside class="emp-sidebar" id="emp-sidebar">
    <a href="<%= ctx %>/" class="sidebar-brand">
        <div class="brand-mark"></div>SlotSync
    </a>
    <div class="sidebar-portal-badge">Employee Portal</div>
    <div class="sidebar-section-label">My Work</div>
    <nav class="sidebar-nav">
        <a href="<%= ctx %>/views/employee/schedule.jsp" class="sidebar-link active" id="sidebar-schedule">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>
            Schedule
        </a>
        <a href="<%= ctx %>/views/employee/availability.jsp" class="sidebar-link" id="sidebar-availability">
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

<%-- ΓòÉΓòÉ MAIN ΓòÉΓòÉ --%>
<main class="emp-main" id="emp-main">

    <h1 class="sched-title">Today's schedule</h1>
    <p class="sched-date">Mon, May 4 &nbsp;&middot;&nbsp; 4 appointments</p>
    <div class="status-bar">
        <span class="status-dot"></span>
        Working at Sharp Salon &nbsp;&middot;&nbsp; Senior Stylist
    </div>

    <%-- ΓöÇΓöÇ Top row: Today card + Bar chart ΓöÇΓöÇ --%>
    <div class="sched-top-row">

        <%-- TODAY card --%>
        <div class="sched-card" id="today-card">
            <div class="card-header">
                <p class="card-title">Today</p>
                <span class="live-badge" id="live-badge">Live</span>
            </div>
            <p class="card-sub">Your bookings</p>

            <div class="appt-row" id="appt-lina">
                <span class="appt-time">09:30</span>
                <div class="appt-info">
                    <div class="appt-name">Lina Park</div>
                    <div class="appt-svc">Standard Haircut</div>
                </div>
                <span class="status-badge badge-confirmed">confirmed</span>
            </div>

            <div class="appt-row" id="appt-daniel">
                <span class="appt-time">10:30</span>
                <div class="appt-info">
                    <div class="appt-name">Daniel Okafor</div>
                    <div class="appt-svc">Standard Haircut</div>
                </div>
                <span class="status-badge badge-confirmed">confirmed</span>
            </div>

            <div class="appt-row" id="appt-priya">
                <span class="appt-time">12:00</span>
                <div class="appt-info">
                    <div class="appt-name">Priya Sharma</div>
                    <div class="appt-svc">Hair Spa</div>
                </div>
                <span class="status-badge badge-confirmed">confirmed</span>
            </div>

            <div class="appt-row" id="appt-tomas">
                <span class="appt-time">14:00</span>
                <div class="appt-info">
                    <div class="appt-name">Tomas Reiner</div>
                    <div class="appt-svc">Beard Trim</div>
                </div>
                <span class="status-badge badge-pending">pending</span>
            </div>
        </div>

        <%-- THIS WEEK bar chart --%>
        <div class="sched-card" id="week-chart-card">
            <p class="card-title">This week</p>
            <p class="card-sub">Upcoming load</p>

            <%
                int[]    counts = {5, 7, 6, 9, 11, 3};
                String[] labels = {"Tue","Wed","Thu","Fri","Sat","Sun"};
                int      maxVal = 11;
            %>
            <div class="bar-chart" id="week-bar-chart">
                <% for (int i = 0; i < counts.length; i++) {
                       int heightPct = (counts[i] * 72) / maxVal; // max bar height 72px
                %>
                <div class="bar-col">
                    <span class="bar-count"><%= counts[i] %></span>
                    <div class="bar" data-height="<%= heightPct %>" id="bar-<%= labels[i].toLowerCase() %>"></div>
                </div>
                <% } %>
            </div>
            <div style="display:flex; gap:8px; margin-top:6px;">
                <% for (String lbl : labels) { %>
                    <div style="flex:1; text-align:center; font-size:10px; color:var(--muted,#9ca3af);"><%= lbl %></div>
                <% } %>
            </div>
        </div>

    </div><%-- end top row --%>

    <%-- ΓöÇΓöÇ Upcoming week table ΓöÇΓöÇ --%>
    <div class="upcoming-table-wrap" id="upcoming-week-card">
        <div class="upcoming-header">
            <p class="upcoming-title">Upcoming week</p>
            <p class="upcoming-sub">Bookings per day</p>
        </div>
        <table class="upcoming-table" id="upcoming-table">
            <thead>
                <tr>
                    <th>Day</th>
                    <th class="col-bookings">Bookings</th>
                    <th class="col-load">Load</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String[][] weekRows = {
                        {"Tue, May 5",  "5",  "45"},
                        {"Wed, May 6",  "7",  "63"},
                        {"Thu, May 7",  "6",  "54"},
                        {"Fri, May 8",  "9",  "82"},
                        {"Sat, May 9",  "11", "100"},
                        {"Sun, May 10", "3",  "27"}
                    };
                    for (String[] row : weekRows) {
                %>
                <tr>
                    <td><%= row[0] %></td>
                    <td class="td-bookings"><%= row[1] %></td>
                    <td class="td-load">
                        <div class="load-bar-wrap">
                            <div class="load-bar-track">
                                <div class="load-bar-fill" data-width="<%= row[2] %>"></div>
                            </div>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</main>

</body>
<script>
    // Apply bar heights (data-height ΓåÆ style.height)
    document.querySelectorAll('.bar[data-height]').forEach(function(el) {
        el.style.height = el.getAttribute('data-height') + 'px';
    });
    // Apply load bar widths (data-width ΓåÆ style.width)
    document.querySelectorAll('.load-bar-fill[data-width]').forEach(function(el) {
        el.style.width = el.getAttribute('data-width') + '%';
    });
</script>
</html>

