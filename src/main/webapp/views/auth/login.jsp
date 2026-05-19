<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Sign in to your SlotSync account to manage bookings and appointments.">
    <title>Sign In | SlotSync</title>
    <link rel="stylesheet" href="/css/style.css?v=2">
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
                    <div style="position: relative;">
                        <input class="input" type="password" id="login-password" name="password" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" style="width: 100%; padding-right: 40px;" required>
                        <button type="button" id="toggle-password" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #888;" title="Toggle Password Visibility">
                            <svg id="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                        </button>
                    </div>
                </div>

                <!-- Remember Me -->
                <div class="field" style="display: flex; align-items: center; gap: 8px;">
                    <input type="checkbox" id="remember-me" name="remember" value="true">
                    <label for="remember-me" style="margin: 0; font-weight: normal;">Remember me for 30 days</label>
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

        // Toggle password visibility
        document.getElementById('toggle-password').addEventListener('click', function() {
            const pwdInput = document.getElementById('login-password');
            const type = pwdInput.getAttribute('type') === 'password' ? 'text' : 'password';
            pwdInput.setAttribute('type', type);
            
            // Update icon
            if (type === 'text') {
                this.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';
            } else {
                this.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
            }
        });
    </script>

</body>
</html>