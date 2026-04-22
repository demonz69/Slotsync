<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotSync | Modern Appointment Management</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="glass-background"></div>
    
    <nav>
        <div class="logo">Slot<span>Sync</span></div>
        <div class="nav-links">
            <a href="views/auth/login.jsp" class="nav-item">Login</a>
            <a href="views/auth/register.jsp" class="btn-primary">Get Started</a>
        </div>
    </nav>

    <main>
        <section class="hero">
            <h1 class="animate-up">Master Your <span>Schedule</span></h1>
            <p class="animate-up delay-1">Streamline appointments, manage services, and grow your business with SlotSync's premium scheduling platform.</p>
            <div class="cta-group animate-up delay-2">
                <a href="views/auth/register.jsp" class="btn-hero">Start Free Trial</a>
                <a href="#features" class="btn-secondary">Learn More</a>
            </div>
        </section>

        <section id="features" class="features">
            <div class="feature-card">
                <div class="icon">📅</div>
                <h3>Smart Booking</h3>
                <p>Automated scheduling that works around your life.</p>
            </div>
            <div class="feature-card">
                <div class="icon">👥</div>
                <h3>Team Management</h3>
                <p>Coordinate multiple employees and services seamlessly.</p>
            </div>
            <div class="feature-card">
                <div class="icon">📊</div>
                <h3>Analytics</h3>
                <p>Insights to help you optimize your business performance.</p>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2026 SlotSync. All rights reserved.</p>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const cards = document.querySelectorAll('.feature-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.2}s`;
            });
        });
    </script>
</body>
</html>
