<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    String ctx  = request.getContextPath();
    User   user = (User) session.getAttribute("user");

    // Guard: redirect to login if not an employee
    if (user == null || !"employee".equals(user.getRole())) {
        response.sendRedirect(ctx + "/views/auth/login.jsp");
        return;
    }

    String success  = (String) request.getAttribute("success");
    String error    = (String) request.getAttribute("error");
    String pwError  = (String) request.getAttribute("pwError");
    String pwSuccess= (String) request.getAttribute("pwSuccess");

    // Initials for avatar
    String initials = "";
    if (user.getFullName() != null && !user.getFullName().isEmpty()) {
        String[] parts = user.getFullName().trim().split("\\s+");
        for (String p : parts) initials += p.charAt(0);
        if (initials.length() > 2) initials = initials.substring(0, 2);
        initials = initials.toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile | SlotSync Employee Portal</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css?v=2">
    <style>
        /* ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
           EMPLOYEE PORTAL LAYOUT
        ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ */
        *, *::before, *::after { box-sizing: border-box; }

        body {
            display: flex;
            min-height: 100vh;
            background: #f9fafb;
            font-family: inherit;
            margin: 0;
        }

        /* ΓöÇΓöÇ Sidebar ΓöÇΓöÇ */
        .emp-sidebar {
            width: 200px;
            min-height: 100vh;
            background: #fff;
            border-right: 1px solid var(--border, #e5e7eb);
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            position: fixed;
            top: 0; left: 0;
            z-index: 100;
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0 18px 14px;
            text-decoration: none;
            color: var(--text, #111);
            font-weight: 700;
            font-size: 15px;
            border-bottom: 1px solid var(--border, #e5e7eb);
        }
        .sidebar-brand .brand-mark {
            width: 26px;
            height: 26px;
            border-radius: 7px;
            background: var(--blue, #4F6EF7);
            flex-shrink: 0;
        }

        .sidebar-portal-badge {
            margin: 12px 18px 4px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            font-weight: 600;
            color: var(--blue, #4F6EF7);
            background: #e8ecff;
            border-radius: 999px;
            padding: 3px 10px;
            width: fit-content;
        }
        .sidebar-portal-badge::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--blue, #4F6EF7);
        }

        .sidebar-section-label {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: .08em;
            text-transform: uppercase;
            color: var(--muted, #9ca3af);
            padding: 20px 18px 6px;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 2px;
            padding: 0 10px;
            flex: 1;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 12px;
            border-radius: 8px;
            font-size: 13.5px;
            color: var(--muted, #6b7280);
            text-decoration: none;
            font-weight: 500;
            transition: background .15s, color .15s;
        }
        .sidebar-link:hover { background: #f3f4f6; color: var(--text, #111); }
        .sidebar-link.active {
            background: #e8ecff;
            color: var(--blue, #4F6EF7);
            font-weight: 600;
        }
        .sidebar-link svg { flex-shrink: 0; opacity: .7; }
        .sidebar-link.active svg { opacity: 1; }

        .sidebar-footer {
            padding: 12px 10px 4px;
            border-top: 1px solid var(--border, #e5e7eb);
            margin-top: auto;
        }
        .sidebar-signout {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 12px;
            border-radius: 8px;
            font-size: 13.5px;
            color: var(--muted, #6b7280);
            text-decoration: none;
            font-weight: 500;
            transition: background .15s, color .15s;
        }
        .sidebar-signout:hover { background: #fef2f2; color: #dc2626; }

        /* ΓöÇΓöÇ Main content ΓöÇΓöÇ */
        .emp-main {
            margin-left: 200px;
            flex: 1;
            padding: 36px 40px;
            max-width: 1100px;
        }

        /* ΓöÇΓöÇ Page header ΓöÇΓöÇ */
        .profile-page-title { font-size: 22px; font-weight: 700; color: var(--text,#111); margin: 0 0 4px; }
        .profile-page-sub   { font-size: 13.5px; color: var(--muted,#6b7280); margin: 0 0 10px; }
        .profile-status-bar {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: var(--text,#111);
            margin-bottom: 28px;
        }
        .status-dot {
            width: 7px; height: 7px;
            border-radius: 50%;
            background: #22c55e;
            flex-shrink: 0;
        }

        /* ΓöÇΓöÇ Top row: profile form + password form ΓöÇΓöÇ */
        .profile-top-row {
            display: grid;
            grid-template-columns: 1.05fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
        }

        /* Card base */
        .profile-card {
            background: #fff;
            border: 1px solid var(--border, #e5e7eb);
            border-radius: 12px;
            padding: 24px;
        }

        /* Avatar row */
        .emp-avatar-row {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 22px;
        }
        .emp-avatar {
            width: 56px; height: 56px;
            border-radius: 50%;
            background: #e8ecff;
            color: var(--blue, #4F6EF7);
            font-size: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .emp-avatar-name {
            font-size: 15px;
            font-weight: 700;
            color: var(--text,#111);
            margin: 0 0 3px;
        }
        .emp-avatar-role {
            font-size: 12.5px;
            color: var(--muted,#6b7280);
        }

        /* Form fields */
        .pf-group { margin-bottom: 14px; }
        .pf-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: var(--text,#111);
            margin-bottom: 5px;
        }
        .pf-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--border, #e5e7eb);
            border-radius: 8px;
            font-size: 13.5px;
            font-family: inherit;
            color: var(--text,#111);
            background: #fff;
            outline: none;
            transition: border-color .18s, box-shadow .18s;
        }
        .pf-group input:focus {
            border-color: var(--blue, #4F6EF7);
            box-shadow: 0 0 0 3px rgba(79,110,247,.12);
        }

        /* Full-width submit */
        .pf-btn {
            display: block;
            width: 100%;
            padding: 11px;
            background: var(--blue, #4F6EF7);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 18px;
            font-family: inherit;
            transition: background .18s, transform .15s;
        }
        .pf-btn:hover { background: #3d5ce8; transform: translateY(-1px); }
        .pf-btn:active { transform: translateY(0); }

        /* Password card headings */
        .pw-title { font-size: 15px; font-weight: 700; color: var(--text,#111); margin: 0 0 4px; }
        .pw-sub   { font-size: 12.5px; color: var(--muted,#6b7280); margin: 0 0 18px; }

        /* ΓöÇΓöÇ Feedback section ΓöÇΓöÇ */
        .feedback-card { background:#fff; border:1px solid var(--border,#e5e7eb); border-radius:12px; padding:24px; }

        .feedback-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .feedback-title { font-size:15px; font-weight:700; color:var(--text,#111); margin:0 0 2px; }
        .feedback-sub   { font-size:12.5px; color:var(--muted,#6b7280); }
        .feedback-rating {
            display:flex; align-items:center; gap:6px;
            font-size:15px; font-weight:700; color:var(--text,#111);
        }
        .stars-gold { color:#f59e0b; letter-spacing:1px; }

        /* Review item */
        .review-item {
            padding: 16px 0;
            border-top: 1px solid var(--border,#e5e7eb);
        }
        .review-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }
        .review-author { font-size:13.5px; font-weight:600; color:var(--text,#111); }
        .review-date   { font-size:12px; color:var(--muted,#9ca3af); }
        .review-stars  { color:#f59e0b; font-size:13px; margin-bottom:6px; }
        .review-stars .star-empty { color:#e5e7eb; }
        .review-text   { font-size:13.5px; color:var(--muted,#374151); line-height:1.6; }
        .review-text em { font-style:normal; color:var(--blue,#4F6EF7); }

        /* Flash alerts */
        .pf-alert {
            padding: 9px 13px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 14px;
        }
        .pf-alert-success { background:#ecfdf5; color:#065f46; border:1px solid #6ee7b7; }
        .pf-alert-error   { background:#fef2f2; color:#991b1b; border:1px solid #fca5a5; }

        /* Responsive */
        @media (max-width: 800px) {
            .profile-top-row { grid-template-columns: 1fr; }
            .emp-main { padding: 24px 16px; }
        }
    </style>
</head>
<body>

<%-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
     SIDEBAR
ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ --%>
<aside class="emp-sidebar" id="emp-sidebar">

    <a href="<%= ctx %>/" class="sidebar-brand" id="sidebar-brand">
        <div class="brand-mark"></div>
        SlotSync
    </a>

    <div class="sidebar-portal-badge" id="sidebar-portal-label">Employee Portal</div>

    <div class="sidebar-section-label">My Work</div>

    <nav class="sidebar-nav" aria-label="Employee navigation">

        <a href="<%= ctx %>/employee?action=list" class="sidebar-link" id="sidebar-schedule">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="5" width="18" height="16" rx="2"/>
                <path d="M3 9h18M8 3v4M16 3v4"/>
            </svg>
            Schedule
        </a>

        <a href="<%= ctx %>/views/employee/availability.jsp" class="sidebar-link" id="sidebar-availability">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
            </svg>
            Set availability
        </a>

        <a href="<%= ctx %>/views/employee/profile.jsp" class="sidebar-link active" id="sidebar-profile">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
            </svg>
            Profile
        </a>

    </nav>

    <div class="sidebar-footer">
        <a href="<%= ctx %>/logout" class="sidebar-signout" id="sidebar-signout">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/>
            </svg>
            Sign out
        </a>
    </div>
</aside>

<%-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
     MAIN CONTENT
ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ --%>
<main class="emp-main" id="emp-main">

    <%-- Page header --%>
    <h1 class="profile-page-title">Profile</h1>
    <p class="profile-page-sub">
        Manage your info and see what clients say.
    </p>
    <div class="profile-status-bar">
        <span class="status-dot"></span>
        Working at Sharp Salon &nbsp;&middot;&nbsp; Senior Stylist
    </div>

    <%-- ΓöÇΓöÇ Top row ΓöÇΓöÇ --%>
    <div class="profile-top-row">

        <%-- LEFT: Profile info form --%>
        <div class="profile-card" id="profile-info-card">

            <%-- Avatar + name --%>
            <div class="emp-avatar-row">
                <div class="emp-avatar" id="profile-avatar"><%= initials %></div>
                <div>
                    <div class="emp-avatar-name" id="profile-display-name"><%= user.getFullName() %></div>
                    <div class="emp-avatar-role">Senior Stylist &nbsp;&middot;&nbsp; Sharp Salon</div>
                </div>
            </div>

            <% if (success != null) { %>
                <div class="pf-alert pf-alert-success" id="profile-success-msg">Γ£ö <%= success %></div>
            <% } %>
            <% if (error != null) { %>
                <div class="pf-alert pf-alert-error" id="profile-error-msg">Γ£û <%= error %></div>
            <% } %>

            <form action="<%= ctx %>/employee?action=updateProfile" method="post" id="profile-info-form">

                <div class="pf-group" id="fg-name">
                    <label for="profile-name">Name</label>
                    <input type="text" id="profile-name" name="fullName"
                           value="<%= user.getFullName() %>"
                           autocomplete="name" required>
                </div>

                <div class="pf-group" id="fg-email">
                    <label for="profile-email">Email</label>
                    <input type="email" id="profile-email" name="email"
                           value="<%= user.getEmail() %>"
                           autocomplete="email" required>
                </div>

                <div class="pf-group" id="fg-phone">
                    <label for="profile-phone">Phone</label>
                    <input type="tel" id="profile-phone" name="phone"
                           value="+977 9801234567"
                           autocomplete="tel">
                </div>

                <button type="submit" class="pf-btn" id="profile-save-btn">Save changes</button>
            </form>
        </div>

        <%-- RIGHT: Change password --%>
        <div class="profile-card" id="profile-pw-card">

            <p class="pw-title">Change password</p>
            <p class="pw-sub">Use 6+ characters.</p>

            <% if (pwSuccess != null) { %>
                <div class="pf-alert pf-alert-success" id="pw-success-msg">Γ£ö <%= pwSuccess %></div>
            <% } %>
            <% if (pwError != null) { %>
                <div class="pf-alert pf-alert-error" id="pw-error-msg">Γ£û <%= pwError %></div>
            <% } %>

            <form action="<%= ctx %>/employee?action=changePassword" method="post" id="profile-pw-form">

                <div class="pf-group" id="fg-current">
                    <label for="pw-current">Current</label>
                    <input type="password" id="pw-current" name="currentPassword"
                           autocomplete="current-password" required>
                </div>

                <div class="pf-group" id="fg-new">
                    <label for="pw-new">New</label>
                    <input type="password" id="pw-new" name="newPassword"
                           autocomplete="new-password" required minlength="6">
                </div>

                <div class="pf-group" id="fg-confirm">
                    <label for="pw-confirm">Confirm</label>
                    <input type="password" id="pw-confirm" name="confirmPassword"
                           autocomplete="new-password" required minlength="6">
                </div>

                <button type="submit" class="pf-btn" id="pw-update-btn">Update password</button>
            </form>
        </div>

    </div><%-- end top row --%>

    <%-- ΓöÇΓöÇ Client Feedback ΓöÇΓöÇ --%>
    <div class="feedback-card" id="feedback-section">

        <div class="feedback-header">
            <div>
                <div class="feedback-title">Client feedback</div>
                <div class="feedback-sub">Reviews left for you</div>
            </div>
            <div class="feedback-rating" id="feedback-avg-rating">
                <span class="stars-gold">&#9733;&#9733;&#9733;&#9733;&#9733;</span>
                4.9
            </div>
        </div>

        <%-- Review: Lina P. --%>
        <div class="review-item" id="review-lina">
            <div class="review-meta">
                <span class="review-author">Lina P.</span>
                <span class="review-date">Apr 28</span>
            </div>
            <div class="review-stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
            <div class="review-text">
                Mausam was great. <em>Listened carefully</em> and the cut was exactly <em>what</em> I asked for.
            </div>
        </div>

        <%-- Review: Marcus F. --%>
        <div class="review-item" id="review-marcus">
            <div class="review-meta">
                <span class="review-author">Marcus F.</span>
                <span class="review-date">Apr 22</span>
            </div>
            <div class="review-stars">&#9733;&#9733;&#9733;&#9733;<span class="star-empty">&#9733;</span></div>
            <div class="review-text">
                Quick and clean, <em>will book again</em>.
            </div>
        </div>

        <%-- Review: Hana Y. --%>
        <div class="review-item" id="review-hana">
            <div class="review-meta">
                <span class="review-author">Hana Y.</span>
                <span class="review-date">Apr 15</span>
            </div>
            <div class="review-stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
            <div class="review-text">
                Best <em>haircut</em> I've had in years.
            </div>
        </div>

    </div><%-- end feedback card --%>

</main>

</body>
</html>
