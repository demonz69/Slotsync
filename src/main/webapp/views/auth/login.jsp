<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Sign in to your SlotSync account to manage bookings and appointments.">
    <title>Sign In | SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- ===== Navigation ===== -->
    <header class="market-nav">
        <div class="container market-nav-inner">
            <a href="${pageContext.request.contextPath}/" class="brand" id="login-nav-brand">
                <div class="brand-mark"></div>
                <span>SlotSync</span>
            </a>
            <div class="market-links">
                <span class="muted small">No account?</span>
                <a href="${pageContext.request.contextPath}/views/auth/register.jsp" class="btn btn-secondary btn-sm" id="login-nav-register">Create one</a>
            </div>
        </div>
    </header>

    <!-- ===== Login Form ===== -->
    <div class="auth-wrap">
        <form class="auth-card animate-in" action="${pageContext.request.contextPath}/login" method="post" id="login-form">
            <h2>Welcome back</h2>
            <p class="sub">Sign in to manage your bookings.</p>

            <div class="col gap-4">
                <!-- Email -->
                <div class="field">
                    <label for="login-email">Email</label>
                    <input class="input" type="email" id="login-email" name="email" placeholder="you@company.com" required>
                </div>

                <!-- Password -->
                <div class="field">
                    <label for="login-password">Password</label>
                    <input class="input" type="password" id="login-password" name="password" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" required>
                </div>

                <!-- Error Message -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="msg-error" id="login-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <!-- Success Message (from registration) -->
                <% if (request.getAttribute("success") != null) { %>
                    <div class="msg-success" id="login-success">
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>

                <!-- Submit -->
                <button class="btn btn-primary btn-lg" type="submit" id="login-submit">
                    Sign in
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
                </button>
            </div>

            <div class="auth-foot">
                New here? <a href="${pageContext.request.contextPath}/views/auth/register.jsp" id="login-link-register">Create an account</a>
            </div>
        </form>
    </div>

    <!-- Client-side validation -->
    <script>
        document.getElementById('login-form').addEventListener('submit', function(e) {
            const email = document.getElementById('login-email').value.trim();
            const password = document.getElementById('login-password').value;

            if (!email.includes('@')) {
                e.preventDefault();
                showError('Enter a valid email address.');
                return;
            }
            if (password.length < 6) {
                e.preventDefault();
                showError('Password must be at least 6 characters.');
                return;
            }
        });

        function showError(msg) {
            let errEl = document.getElementById('login-error');
            if (!errEl) {
                errEl = document.createElement('div');
                errEl.id = 'login-error';
                errEl.className = 'msg-error';
                const submitBtn = document.getElementById('login-submit');
                submitBtn.parentNode.insertBefore(errEl, submitBtn);
            }
            errEl.textContent = msg;
        }
    </script>

</body>
</html>