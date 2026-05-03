<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String userName = user.getFullName() != null ? user.getFullName() : "Admin";
    String userInitials = "";
    if (userName != null && !userName.isEmpty()) {
        String[] parts = userName.split(" ");
        for (String part : parts) {
            if (!part.isEmpty()) userInitials += part.charAt(0);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SlotSync Admin Dashboard — Manage bookings, users, services, and revenue.">
    <title>Admin Dashboard | SlotSync</title>
    <link rel="stylesheet" href="/css/style.css?v=2">
</head>
<body>

    <div class="dash">
        <!-- ===== Sidebar ===== -->
        <aside class="sidebar" id="admin-sidebar">
            <div class="sidebar-brand">
                <a href="${pageContext.request.contextPath}/" class="brand">
                    <div class="brand-mark"></div>
                    <span>SlotSync</span>
                </a>
                <div class="badge badge-blue" style="margin-top:10px; font-size:11px">Admin</div>
            </div>

            <!-- Navigation -->
            <nav class="col gap-2">
                <div class="sidebar-section">Operations</div>

                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="sidenav-item active" id="sidenav-overview">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Overview
                </a>

                <a href="${pageContext.request.contextPath}/views/admin/manage-users.jsp" class="sidenav-item" id="sidenav-users">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>
                    Users
                </a>

                <a href="${pageContext.request.contextPath}/views/admin/manage-services.jsp" class="sidenav-item" id="sidenav-services">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2M3 13h18"/></svg>
                    Services
                </a>

                <div class="sidebar-section">Account</div>

                <a href="${pageContext.request.contextPath}/views/about.jsp" class="sidenav-item" id="sidenav-about">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v4M12 17v4M3 12h4M17 12h4M5.6 5.6l2.8 2.8M15.6 15.6l2.8 2.8M5.6 18.4l2.8-2.8M15.6 8.4l2.8-2.8"/></svg>
                    About
                </a>

                <a href="${pageContext.request.contextPath}/views/contact.jsp" class="sidenav-item" id="sidenav-contact">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg>
                    Contact
                </a>
            </nav>

            <div class="sidebar-foot">
                <a href="${pageContext.request.contextPath}/logout" class="sidenav-item" id="sidenav-logout">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                    Sign out
                </a>
            </div>
        </aside>

        <!-- ===== Main Content ===== -->
        <main class="dash-main" id="admin-main">
            <div class="dash-head">
                <div>
                    <h1>Operations overview</h1>
                    <div class="sub">Live snapshot of bookings, users, and revenue.</div>
                </div>
                <div class="btn btn-secondary">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>
                    This week
                </div>
            </div>

            <!-- ===== Stat Cards ===== -->
            <div class="stat-row animate-in">
                <div class="stat-card" id="stat-bookings">
                    <div class="stat-label">Bookings (week)</div>
                    <div class="stat-value mono">277</div>
                    <div class="stat-delta up">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                        +12.4% vs last week
                    </div>
                </div>
                <div class="stat-card" id="stat-users">
                    <div class="stat-label">Active users</div>
                    <div class="stat-value mono">1,284</div>
                    <div class="stat-delta up">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                        +38 this week
                    </div>
                </div>
                <div class="stat-card" id="stat-revenue">
                    <div class="stat-label">Revenue</div>
                    <div class="stat-value mono">$24,820</div>
                    <div class="stat-delta up">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                        +8.1%
                    </div>
                </div>
                <div class="stat-card" id="stat-noshow">
                    <div class="stat-label">No-show rate</div>
                    <div class="stat-value mono">3.2%</div>
                    <div class="stat-delta up">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                        -0.6 pp
                    </div>
                </div>
            </div>

            <!-- ===== Charts Row ===== -->
            <div style="display:grid; grid-template-columns:1.4fr 1fr; gap:20px; margin-bottom:24px" class="animate-in animate-in-delay-1">
                <!-- Bar Chart -->
                <div class="card" id="chart-bookings">
                    <div class="between" style="padding:18px 22px; border-bottom:1px solid var(--border)">
                        <div>
                            <h3 class="h3">Bookings by day</h3>
                            <div class="muted small" style="margin-top:2px">Last 7 days</div>
                        </div>
                        <span class="badge badge-blue"><span class="badge-dot"></span> This week</span>
                    </div>
                    <div style="padding:8px 22px 22px">
                        <div class="bar-chart" id="bar-chart">
                            <!-- Bars are generated by JS -->
                        </div>
                    </div>
                </div>

                <!-- Top Employees -->
                <div class="card" id="card-employees">
                    <div style="padding:18px 22px; border-bottom:1px solid var(--border)">
                        <h3 class="h3">Top employees</h3>
                        <div class="muted small" style="margin-top:2px">By bookings this month</div>
                    </div>
                    <div class="col" style="padding:6px">
                        <div class="between" style="padding:12px 16px">
                            <div class="row gap-3 items-center">
                                <div class="avatar" style="width:36px; height:36px; font-size:13px">AM</div>
                                <div>
                                    <div style="font-weight:500; font-size:14px">Aanand Mandal</div>
                                    <div class="muted tiny">Senior Stylist</div>
                                </div>
                            </div>
                            <div class="mono small" style="font-weight:600">412</div>
                        </div>
                        <div class="between" style="padding:12px 16px">
                            <div class="row gap-3 items-center">
                                <div class="avatar" style="width:36px; height:36px; font-size:13px">RC</div>
                                <div>
                                    <div style="font-weight:500; font-size:14px">Rose Chaudhary</div>
                                    <div class="muted tiny">Color Specialist</div>
                                </div>
                            </div>
                            <div class="mono small" style="font-weight:600">287</div>
                        </div>
                        <div class="between" style="padding:12px 16px">
                            <div class="row gap-3 items-center">
                                <div class="avatar" style="width:36px; height:36px; font-size:13px">MS</div>
                                <div>
                                    <div style="font-weight:500; font-size:14px">Mausam Shrestha</div>
                                    <div class="muted tiny">Barber</div>
                                </div>
                            </div>
                            <div class="mono small" style="font-weight:600">503</div>
                        </div>
                        <div class="between" style="padding:12px 16px">
                            <div class="row gap-3 items-center">
                                <div class="avatar" style="width:36px; height:36px; font-size:13px">TB</div>
                                <div>
                                    <div style="font-weight:500; font-size:14px">Tiraj Basnet</div>
                                    <div class="muted tiny">Nail Technician</div>
                                </div>
                            </div>
                            <div class="mono small" style="font-weight:600">196</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== Popular Services Table ===== -->
            <div class="card animate-in animate-in-delay-2" id="card-popular-services">
                <div class="between" style="padding:18px 22px; border-bottom:1px solid var(--border)">
                    <div>
                        <h3 class="h3">Most popular services</h3>
                        <div class="muted small" style="margin-top:2px">Sorted by bookings</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/views/admin/manage-services.jsp" class="btn btn-secondary btn-sm">Manage services</a>
                </div>
                <table class="table" id="table-popular">
                    <thead>
                        <tr>
                            <th>Service</th>
                            <th style="text-align:right">Bookings</th>
                            <th style="text-align:right">Revenue</th>
                            <th style="text-align:right">Trend</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="hov">
                            <td style="font-weight:500">Standard Haircut</td>
                            <td class="mono" style="text-align:right">184</td>
                            <td class="mono" style="text-align:right">$5,152</td>
                            <td style="text-align:right"><span class="stat-delta up">+12%</span></td>
                        </tr>
                        <tr class="hov">
                            <td style="font-weight:500">Beard Trim</td>
                            <td class="mono" style="text-align:right">142</td>
                            <td class="mono" style="text-align:right">$2,556</td>
                            <td style="text-align:right"><span class="stat-delta up">+6%</span></td>
                        </tr>
                        <tr class="hov">
                            <td style="font-weight:500">Hair Color</td>
                            <td class="mono" style="text-align:right">96</td>
                            <td class="mono" style="text-align:right">$9,120</td>
                            <td style="text-align:right"><span class="stat-delta up">+18%</span></td>
                        </tr>
                        <tr class="hov">
                            <td style="font-weight:500">Facial Treatment</td>
                            <td class="mono" style="text-align:right">73</td>
                            <td class="mono" style="text-align:right">$5,694</td>
                            <td style="text-align:right"><span class="stat-delta up">+4%</span></td>
                        </tr>
                        <tr class="hov">
                            <td style="font-weight:500">Manicure</td>
                            <td class="mono" style="text-align:right">68</td>
                            <td class="mono" style="text-align:right">$2,176</td>
                            <td style="text-align:right"><span class="stat-delta down">-2%</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- ===== Bar Chart Script ===== -->
    <script>
        const data = [
            { day: 'Mon', count: 28 },
            { day: 'Tue', count: 34 },
            { day: 'Wed', count: 31 },
            { day: 'Thu', count: 42 },
            { day: 'Fri', count: 56 },
            { day: 'Sat', count: 64 },
            { day: 'Sun', count: 22 },
        ];

        const max = Math.max(...data.map(d => d.count));
        const chart = document.getElementById('bar-chart');

        data.forEach(d => {
            const col = document.createElement('div');
            col.className = 'bar-col';

            const wrap = document.createElement('div');
            wrap.className = 'bar-wrap';

            const bar = document.createElement('div');
            bar.className = 'bar';
            bar.style.height = (d.count / max * 100) + '%';

            const val = document.createElement('div');
            val.className = 'bar-value';
            val.textContent = d.count;
            bar.appendChild(val);

            wrap.appendChild(bar);

            const label = document.createElement('div');
            label.className = 'bar-label';
            label.textContent = d.day;

            col.appendChild(wrap);
            col.appendChild(label);
            chart.appendChild(col);
        });
    </script>

</body>
</html>
