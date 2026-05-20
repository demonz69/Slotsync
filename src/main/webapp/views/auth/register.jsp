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
                <!-- Account Type -->
                <div class="field">
                    <label>Account Type</label>
                    <div class="role-chips">
                        <label class="role-chip active">
                            <input type="radio" name="role" value="client" checked> Client
                        </label>
                        <label class="role-chip">
                            <input type="radio" name="role" value="employee"> Business
                        </label>
                    </div>
                </div>

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
                    <div style="position: relative;">
                        <input class="input" type="password" id="reg-password" name="password" placeholder="At least 6 characters" style="width: 100%; padding-right: 40px;" required>
                        <button type="button" id="toggle-password" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #888;" title="Toggle Password Visibility">
                            <svg id="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                        </button>
                    </div>
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

        // Handle role chips selection
        document.querySelectorAll('input[name="role"]').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.role-chip').forEach(chip => chip.classList.remove('active'));
                if (this.checked) {
                    this.parentElement.classList.add('active');
                }
            });
        });

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

        // Toggle password visibility
        document.getElementById('toggle-password').addEventListener('click', function() {
            const pwdInput = document.getElementById('reg-password');
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