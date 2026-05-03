<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Create your SlotSync account. Free to start. No credit card required.">
    <title>Create Account | SlotSync</title>
    <link rel="stylesheet" href="/css/style.css?v=2">
</head>
<body>

    <!-- ===== Navigation ===== -->
    <header class="market-nav">
        <div class="container market-nav-inner">
            <a href="${pageContext.request.contextPath}/" class="brand" id="register-nav-brand">
                <div class="brand-mark"></div>
                <span>SlotSync</span>
            </a>
            <div class="market-links">
                <span class="muted small">Have an account?</span>
                <a href="${pageContext.request.contextPath}/views/auth/login.jsp" class="btn btn-secondary btn-sm" id="register-nav-login">Sign in</a>
            </div>
        </div>
    </header>

    <!-- ===== Register Form ===== -->
    <div class="auth-wrap">
        <form class="auth-card animate-in" action="${pageContext.request.contextPath}/register" method="post" id="register-form" style="max-width:500px">
            <h2>Create your account</h2>
            <p class="sub">Free to start. No credit card required.</p>

            <div class="col gap-4">
                <!-- Full Name -->
                <div class="field">
                    <label for="reg-name">Full name</label>
                    <input class="input" type="text" id="reg-name" name="fullName" placeholder="Jane Doe" required>
                    <span class="err" id="err-name" style="display:none"></span>
                </div>

                <!-- Email -->
                <div class="field">
                    <label for="reg-email">Email</label>
                    <input class="input" type="email" id="reg-email" name="email" placeholder="you@company.com" required>
                    <span class="err" id="err-email" style="display:none"></span>
                </div>

                <!-- Phone -->
                <div class="field">
                    <label for="reg-phone">Phone</label>
                    <input class="input" type="tel" id="reg-phone" name="phone" placeholder="+1 (415) 555 0123">
                    <span class="err" id="err-phone" style="display:none"></span>
                </div>

                <!-- Password -->
                <div class="field">
                    <label for="reg-password">Password</label>
                    <input class="input" type="password" id="reg-password" name="password" placeholder="At least 6 characters" required>
                    <span class="err" id="err-password" style="display:none"></span>
                </div>

                <!-- Error / Success Messages from Server -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="msg-error" id="register-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                    <div class="msg-success" id="register-success">
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>

                <!-- Submit -->
                <button class="btn btn-primary btn-lg" type="submit" id="register-submit">
                    Create account
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
                </button>
            </div>

            <div class="auth-foot">
                Already registered? <a href="${pageContext.request.contextPath}/views/auth/login.jsp" id="register-link-login">Sign in</a>
            </div>
        </form>
    </div>

    <!-- Client-side validation -->
    <script>
        const form = document.getElementById('register-form');
        const fields = {
            name: { el: document.getElementById('reg-name'), err: document.getElementById('err-name') },
            email: { el: document.getElementById('reg-email'), err: document.getElementById('err-email') },
            phone: { el: document.getElementById('reg-phone'), err: document.getElementById('err-phone') },
            password: { el: document.getElementById('reg-password'), err: document.getElementById('err-password') },
        };

        function validateField(key) {
            const val = fields[key].el.value.trim();
            let msg = '';

            switch (key) {
                case 'name':
                    if (!/^[A-Za-z][A-Za-z\s'-]{1,}$/.test(val)) msg = 'Letters, spaces, hyphens only.';
                    break;
                case 'email':
                    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) msg = 'Enter a valid email address.';
                    break;
                case 'phone':
                    if (val && !/^[+\d][\d\s\-()]{6,}$/.test(val)) msg = 'Enter a valid phone number.';
                    break;
                case 'password':
                    if (val.length < 6) msg = 'Password must be at least 6 characters.';
                    break;
            }

            if (msg) {
                fields[key].err.textContent = msg;
                fields[key].err.style.display = 'block';
                fields[key].el.classList.add('invalid');
                return false;
            } else {
                fields[key].err.style.display = 'none';
                fields[key].el.classList.remove('invalid');
                return true;
            }
        }

        // Validate on blur
        Object.keys(fields).forEach(key => {
            fields[key].el.addEventListener('blur', () => validateField(key));
        });

        // Validate on submit
        form.addEventListener('submit', function(e) {
            let valid = true;
            ['name', 'email', 'password'].forEach(key => {
                if (!validateField(key)) valid = false;
            });
            // Phone is optional, but validate format if filled
            if (fields.phone.el.value.trim()) {
                if (!validateField('phone')) valid = false;
            }
            if (!valid) e.preventDefault();
        });
    </script>

</body>
</html>