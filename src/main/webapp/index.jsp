<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SlotSync — Booking infrastructure for modern service businesses. Fewer no-shows, smarter staff utilization, and a checkout that actually converts.">
    <title>SlotSync | Modern Appointment Booking</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- ===== Navigation ===== -->
    <header class="market-nav">
        <div class="container market-nav-inner">
            <a href="${pageContext.request.contextPath}/" class="brand" id="nav-brand">
                <div class="brand-mark"></div>
                <span>SlotSync</span>
            </a>
            <div class="market-links">
                <a href="${pageContext.request.contextPath}/views/about.jsp" id="nav-about">About</a>
                <a href="${pageContext.request.contextPath}/views/contact.jsp" id="nav-contact">Contact</a>
                <a href="${pageContext.request.contextPath}/views/auth/login.jsp" id="nav-signin">Sign in</a>
                <a href="${pageContext.request.contextPath}/views/auth/register.jsp" class="btn btn-primary btn-sm" id="nav-getstarted">Get started</a>
            </div>
        </div>
    </header>

    <!-- ===== Hero Section ===== -->
    <section class="hero" id="hero">
        <div class="container">
            <span class="hero-eyebrow animate-in">
                <span class="badge-dot" style="background:var(--blue)"></span>
                Now in open beta &bull; v1.4
            </span>
            <h1 class="animate-in animate-in-delay-1">Booking that respects your time &mdash; and theirs.</h1>
            <p class="lede animate-in animate-in-delay-2">
                SlotSync is a booking platform for service businesses that want fewer no-shows,
                smarter staff utilization, and a checkout that actually converts.
            </p>
            <div class="hero-actions animate-in animate-in-delay-3">
                <a href="${pageContext.request.contextPath}/views/auth/register.jsp" class="btn btn-primary btn-lg" id="hero-cta-register">
                    Create an account
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
                </a>
                <a href="${pageContext.request.contextPath}/views/auth/login.jsp" class="btn btn-secondary btn-lg" id="hero-cta-login">
                    Sign in to dashboard
                </a>
            </div>

            <!-- Mockup Preview -->
            <div class="hero-mockup animate-in animate-in-delay-3">
                <div class="hero-mockup-head">
                    <span class="hero-mockup-dot"></span>
                    <span class="hero-mockup-dot"></span>
                    <span class="hero-mockup-dot"></span>
                </div>
                <div style="display:grid; grid-template-columns:1fr 1.6fr; gap:18px" class="hero-mockup-grid">
                    <div class="card card-pad-sm">
                        <div class="tiny muted" style="margin-bottom:8px">UPCOMING</div>
                        <div class="col gap-2">
                            <div style="padding:10px 0; border-bottom:1px solid var(--border)">
                                <div style="font-weight:500; font-size:13px">Standard Haircut</div>
                                <div class="tiny muted mono">May 6, 2026 &bull; 10:30 AM</div>
                            </div>
                            <div style="padding:10px 0; border-bottom:1px solid var(--border)">
                                <div style="font-weight:500; font-size:13px">Hair Color</div>
                                <div class="tiny muted mono">May 12, 2026 &bull; 2:00 PM</div>
                            </div>
                            <div style="padding:10px 0">
                                <div style="font-weight:500; font-size:13px">Manicure</div>
                                <div class="tiny muted mono">May 18, 2026 &bull; 11:00 AM</div>
                            </div>
                        </div>
                    </div>
                    <div class="card card-pad-sm">
                        <div class="tiny muted" style="margin-bottom:10px">WED, MAY 6 &mdash; AVAILABLE</div>
                        <div class="slot-grid">
                            <div class="slot">09:30</div>
                            <div class="slot">10:00</div>
                            <div class="slot selected">10:30</div>
                            <div class="slot">11:00</div>
                            <div class="slot">11:30</div>
                            <div class="slot">12:00</div>
                            <div class="slot">13:30</div>
                            <div class="slot">14:00</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== Features Section ===== -->
    <section class="section" id="features">
        <div class="container">
            <div class="section-head">
                <div class="section-eyebrow">Built for service teams</div>
                <h2 class="h1" style="font-size:36px">Three things we obsess over.</h2>
            </div>
            <div class="feature-grid">
                <div class="feature-card animate-in">
                    <div class="feature-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>
                    </div>
                    <h3>Real-time availability</h3>
                    <p>Slots reflect every employee&rsquo;s live schedule. No double-bookings, no awkward callbacks.</p>
                </div>
                <div class="feature-card animate-in animate-in-delay-1">
                    <div class="feature-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 8a6 6 0 1112 0c0 5 2 6 2 6H4s2-1 2-6z"/><path d="M10 19a2 2 0 004 0"/></svg>
                    </div>
                    <h3>Smart reminders</h3>
                    <p>Email and SMS nudges sent at the moments most likely to bring people through the door.</p>
                </div>
                <div class="feature-card animate-in animate-in-delay-2">
                    <div class="feature-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    </div>
                    <h3>Operations dashboard</h3>
                    <p>Approve users, manage services, and see what&rsquo;s working &mdash; all from one clean view.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== Footer ===== -->
    <footer class="footer" id="footer">
        <div class="container">
            <div class="footer-inner">
                <div style="max-width:280px">
                    <a href="${pageContext.request.contextPath}/" class="brand">
                        <div class="brand-mark"></div>
                        <span>SlotSync</span>
                    </a>
                    <p class="muted small" style="margin-top:12px">Booking infrastructure for modern service businesses.</p>
                </div>
                <div class="footer-cols">
                    <div class="footer-col">
                        <h4>Product</h4>
                        <a href="${pageContext.request.contextPath}/views/auth/register.jsp">Booking</a>
                        <a href="${pageContext.request.contextPath}/views/auth/login.jsp">Dashboard</a>
                    </div>
                    <div class="footer-col">
                        <h4>Company</h4>
                        <a href="${pageContext.request.contextPath}/views/about.jsp">About</a>
                        <a href="${pageContext.request.contextPath}/views/contact.jsp">Contact</a>
                    </div>
                    <div class="footer-col">
                        <h4>Legal</h4>
                        <a href="#">Privacy</a>
                        <a href="#">Terms</a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <span>&copy; 2026 SlotSync, Inc.</span>
                <span class="mono">v1.4.0</span>
            </div>
        </div>
    </footer>

</body>
</html>
