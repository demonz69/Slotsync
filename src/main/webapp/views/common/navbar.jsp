<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    // Determine the current page path for active-link highlighting
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();

    // Resolve logged-in user (if any)
    User navUser = (User) session.getAttribute("user");
%>
<header class="market-nav" id="site-header">
    <div class="container market-nav-inner">

        <%-- ===== Brand ===== --%>
        <a href="<%= ctx %>/" class="brand" id="nav-brand">
            <div class="brand-mark"></div>
            <span>SlotSync</span>
        </a>

        <%-- ===== Nav Links ===== --%>
        <nav class="market-links" aria-label="Main navigation">

            <a href="<%= ctx %>/"
               id="nav-home"
               class="<%= currentUri.equals(ctx + "/") || currentUri.endsWith("index.jsp") ? "nav-active" : "" %>">
                Home
            </a>

            <a href="<%= ctx %>/views/about.jsp"
               id="nav-about"
               class="<%= currentUri.contains("about") ? "nav-active" : "" %>">
                About
            </a>

            <a href="<%= ctx %>/contact"
               id="nav-contact"
               class="<%= currentUri.contains("contact") ? "nav-active" : "" %>">
                Contact
            </a>

            <% if (navUser != null) { %>
                <%-- Logged-in: show role-appropriate dashboard link instead of Sign in --%>
                <% if ("admin".equals(navUser.getRole())) { %>
                    <a href="<%= ctx %>/views/admin/dashboard.jsp" id="nav-dashboard">Dashboard</a>
                <% } else if ("employee".equals(navUser.getRole())) { %>
                    <a href="<%= ctx %>/views/employee/schedule.jsp" id="nav-dashboard">My Schedule</a>
                <% } else { %>
                    <a href="<%= ctx %>/views/user/home.jsp" id="nav-dashboard">My Bookings</a>
                <% } %>
                <a href="<%= ctx %>/logout" class="btn btn-primary btn-sm" id="nav-logout">Sign out</a>
            <% } else { %>
                <a href="<%= ctx %>/views/auth/login.jsp"
                   id="nav-signin"
                   class="<%= currentUri.contains("login") ? "nav-active" : "" %>">
                    Sign in
                </a>
                <a href="<%= ctx %>/views/auth/register.jsp"
                   class="btn btn-primary btn-sm"
                   id="nav-getstarted">
                    Get started
                </a>
            <% } %>
        </nav>

        <%-- ===== Mobile hamburger (progressive enhancement) ===== --%>
        <button class="nav-toggle" id="nav-toggle" aria-label="Toggle menu" aria-expanded="false">
            <span></span><span></span><span></span>
        </button>
    </div>
</header>

<style>
    /* ΓöÇΓöÇ Active nav link indicator ΓöÇΓöÇ */
    .market-links .nav-active {
        color: var(--blue, #4F6EF7);
        font-weight: 600;
    }

    /* ΓöÇΓöÇ Mobile toggle button ΓöÇΓöÇ */
    .nav-toggle {
        display: none;
        flex-direction: column;
        gap: 5px;
        background: none;
        border: none;
        cursor: pointer;
        padding: 4px;
    }
    .nav-toggle span {
        display: block;
        width: 22px;
        height: 2px;
        background: var(--text, #111);
        border-radius: 2px;
        transition: transform .25s, opacity .25s;
    }

    @media (max-width: 680px) {
        .nav-toggle { display: flex; }

        .market-links {
            display: none;
            flex-direction: column;
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #fff;
            border-top: 1px solid var(--border, #e5e7eb);
            padding: 16px 24px;
            gap: 12px;
            z-index: 999;
            box-shadow: 0 8px 24px rgba(0,0,0,.08);
        }
        .market-links.open { display: flex; }

        .market-nav-inner { position: relative; }
    }
</style>

<script>
    (function () {
        const toggle = document.getElementById('nav-toggle');
        const links  = document.querySelector('.market-links');
        if (!toggle || !links) return;
        toggle.addEventListener('click', function () {
            const open = links.classList.toggle('open');
            toggle.setAttribute('aria-expanded', open);
        });
    })();
</script>
