<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    if (!"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/user/home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SlotSync Admin — Platform overview of businesses, users, and bookings.">
    <title>Overview | SlotSync Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .activity-list { display: flex; flex-direction: column; }
        .activity-item {
            display: flex; align-items: center; gap: 12px;
            padding: 13px 20px; border-bottom: 1px solid var(--border);
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-avatar {
            width: 34px; height: 34px; border-radius: 50%; flex-shrink: 0;
            background: var(--blue-50); color: var(--blue-700); border: 1px solid #bfdbfe;
            display: flex; align-items: center; justify-content: center;
            font-size: 11px; font-weight: 700; letter-spacing: 0.02em;
        }
        .activity-body { flex: 1; min-width: 0; }
        .activity-body .line { font-size: 13.5px; color: var(--text); line-height: 1.4; }
        .activity-body .line strong { font-weight: 600; }
        .activity-body .line a { color: var(--blue); }
        .activity-body .time { font-size: 12px; color: var(--text-3); margin-top: 2px; }
        .badge-activity {
            font-size: 11px; font-weight: 500; padding: 3px 10px; border-radius: 999px;
            background: var(--amber-50); color: #b45309; border: 1px solid #fde68a;
            white-space: nowrap; flex-shrink: 0;
        }
        .biz-list { display: flex; flex-direction: column; }
        .biz-item {
            display: flex; align-items: center; gap: 12px;
            padding: 13px 20px; border-bottom: 1px solid var(--border);
        }
        .biz-item:last-child { border-bottom: none; }
        .biz-icon {
            width: 34px; height: 34px; border-radius: 8px; flex-shrink: 0;
            background: var(--bg-alt); border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center; font-size: 15px;
        }
        .biz-info { flex: 1; min-width: 0; }
        .biz-name { font-size: 13.5px; font-weight: 600; color: var(--text); }
        .biz-owner { font-size: 12px; color: var(--text-2); margin-top: 1px; }
        .panel-row { display: grid; grid-template-columns: 1.4fr 1fr; gap: 20px; margin-bottom: 24px; }
        .stat-delta.neutral { color: var(--text-2); }
        @media (max-width: 900px) { .panel-row { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="dash">
    <aside class="sidebar" id="admin-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/" class="brand" id="nav-brand">
                <div class="brand-mark"></div>
                <span>SlotSync</span>
            </a>
            <div class="badge badge-blue" style="margin-top:10px; font-size:11px">
                <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Admin Panel
            </div>
        </div>
        <nav class="col gap-2">
            <div class="sidebar-section">Operations</div>
            <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="sidenav-item active" id="sidenav-overview">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Overview
            </a>
            <a href="${pageContext.request.contextPath}/views/admin/manage-businesses.jsp" class="sidenav-item" id="sidenav-businesses">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9h18M9 21V9M3 9l2-5h14l2 5M3 9a2 2 0 000 4v7a1 1 0 001 1h16a1 1 0 001-1v-7a2 2 0 000-4"/></svg>
                Manage Businesses
            </a>
            <a href="${pageContext.request.contextPath}/views/admin/manage-users.jsp" class="sidenav-item" id="sidenav-users">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>
                Manage Users
            </a>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout" class="sidenav-item" id="sidenav-logout">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                Sign out
            </a>
        </div>
    </aside>

    <main class="dash-main" id="admin-main">
        <div class="dash-head animate-in">
            <div>
                <h1>Platform overview</h1>
                <div class="sub">Live snapshot of every business and user on SlotSync.</div>
            </div>
        </div>

        <div class="stat-row animate-in">
            <div class="stat-card" id="stat-businesses">
                <div class="stat-label">Total Businesses</div>
                <div class="stat-value mono">3</div>
                <div class="stat-delta up">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                    +1 this month
                </div>
            </div>
            <div class="stat-card" id="stat-users">
                <div class="stat-label">Total Users</div>
                <div class="stat-value mono">1,284</div>
                <div class="stat-delta up">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                    +38 this week
                </div>
            </div>
            <div class="stat-card" id="stat-bookings">
                <div class="stat-label">Total Bookings</div>
                <div class="stat-value mono">4,712</div>
                <div class="stat-delta up">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M6 11l6-6 6 6"/></svg>
                    +12.4%
                </div>
            </div>
            <div class="stat-card" id="stat-pending">
                <div class="stat-label">Pending Approvals</div>
                <div class="stat-value mono">2</div>
                <div class="stat-delta neutral">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
                    <a href="${pageContext.request.contextPath}/views/admin/manage-businesses.jsp" style="color:inherit; text-decoration:none">check review</a>
                </div>
            </div>
        </div>

        <div class="panel-row animate-in animate-in-delay-1">
            <div class="card" id="card-activity">
                <div class="between" style="padding:16px 20px; border-bottom:1px solid var(--border)">
                    <div>
                        <h3 class="h3" style="font-size:15px">Recent activity</h3>
                        <div class="muted tiny" style="margin-top:2px">Across the platform</div>
                    </div>
                    <button class="btn btn-secondary btn-sm" id="btn-export">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                        Export
                    </button>
                </div>
                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-avatar">RK</div>
                        <div class="activity-body">
                            <div class="line"><strong>Rajan Karki</strong> registered <a href="#">Fixit Garage</a></div>
                            <div class="time">7h ago</div>
                        </div>
                        <span class="badge-activity">activity</span>
                    </div>
                    <div class="activity-item">
                        <div class="activity-avatar">LP</div>
                        <div class="activity-body">
                            <div class="line"><strong>Lina Park</strong> completed booking at <a href="#">Sharp Salon</a></div>
                            <div class="time">9h ago</div>
                        </div>
                        <span class="badge-activity">activity</span>
                    </div>
                    <div class="activity-item">
                        <div class="activity-avatar">AM</div>
                        <div class="activity-body">
                            <div class="line"><strong>Anusha Maharjan</strong> added a new service at <a href="#">Zen Healing</a></div>
                            <div class="time">7h ago</div>
                        </div>
                        <span class="badge-activity">activity</span>
                    </div>
                    <div class="activity-item">
                        <div class="activity-avatar">TR</div>
                        <div class="activity-body">
                            <div class="line"><strong>Tomas Reiner</strong> created a client account</div>
                            <div class="time">1d ago</div>
                        </div>
                        <span class="badge-activity">activity</span>
                    </div>
                    <div class="activity-item">
                        <div class="activity-avatar">MS</div>
                        <div class="activity-body">
                            <div class="line"><strong>Mausam Shrestha</strong> updated availability</div>
                            <div class="time">1d ago</div>
                        </div>
                        <span class="badge-activity">activity</span>
                    </div>
                </div>
            </div>

            <div class="card" id="card-businesses">
                <div style="padding:16px 20px; border-bottom:1px solid var(--border)">
                    <h3 class="h3" style="font-size:15px">Businesses on SlotSync</h3>
                    <div class="muted tiny" style="margin-top:2px">3 total</div>
                </div>
                <div class="biz-list">
                    <div class="biz-item">
                        <div class="biz-icon">&#9986;&#65039;</div>
                        <div class="biz-info">
                            <div class="biz-name">Sharp Salon</div>
                            <div class="biz-owner">Tiraj Basnet</div>
                        </div>
                        <span class="badge badge-green"><span class="badge-dot"></span> active</span>
                    </div>
                    <div class="biz-item">
                        <div class="biz-icon">&#127807;</div>
                        <div class="biz-info">
                            <div class="biz-name">Zen Healing</div>
                            <div class="biz-owner">Anusha Maharjan</div>
                        </div>
                        <span class="badge badge-green"><span class="badge-dot"></span> active</span>
                    </div>
                    <div class="biz-item">
                        <div class="biz-icon">&#128295;</div>
                        <div class="biz-info">
                            <div class="biz-name">Fixit Garage</div>
                            <div class="biz-owner">Rajan Karki</div>
                        </div>
                        <span class="badge badge-amber"><span class="badge-dot"></span> pending</span>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
