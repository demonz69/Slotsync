<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Contact | SlotSync");
    request.setAttribute("pageDesc",  "Talk to a human. We answer every message, usually within a few hours.");

    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    String ctx     = request.getContextPath();
%>
<jsp:include page="/views/common/header.jsp" />

<main id="contact-page">
    <section class="contact-section">
        <div class="container contact-wrapper">

            <%-- ΓòÉΓòÉ LEFT: heading + info cards ΓòÉΓòÉ --%>
            <div class="contact-left">

                <div class="section-eyebrow" style="margin-bottom:12px">Contact</div>
                <h1 class="contact-headline">Talk to a human.</h1>
                <p class="contact-sub">We answer every message, usually within a few hours.</p>

                <%-- Flash messages --%>
                <% if (success != null) { %>
                    <div class="contact-alert contact-alert-success" id="contact-success-msg" role="alert">
                        Γ£ö <%= success %>
                    </div>
                <% } %>
                <% if (error != null) { %>
                    <div class="contact-alert contact-alert-error" id="contact-error-msg" role="alert">
                        Γ£û <%= error %>
                    </div>
                <% } %>

                <%-- Info Cards --%>
                <div class="info-cards">

                    <div class="info-card" id="info-email">
                        <div class="info-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="1.8"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <rect x="2" y="4" width="20" height="16" rx="2"/>
                                <path d="M2 7l10 7 10-7"/>
                            </svg>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Email</div>
                            <div class="info-value">hello@slotsync.app</div>
                        </div>
                    </div>

                    <div class="info-card" id="info-phone">
                        <div class="info-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="1.8"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 16.92v3a2 2 0 01-2.18 2 19.8 19.8 0 01-8.63-3.07A19.5 19.5 0 013.07 10.8 19.8 19.8 0 01.01 2.18 2 2 0 012 0h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.09 7.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 14.92z"/>
                            </svg>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Phone</div>
                            <div class="info-value">+977 9801 555000</div>
                        </div>
                    </div>

                    <div class="info-card" id="info-location">
                        <div class="info-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="1.8"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/>
                                <circle cx="12" cy="10" r="3"/>
                            </svg>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Location</div>
                            <div class="info-value">Lazimpat, Kathmandu</div>
                        </div>
                    </div>

                    <div class="info-card" id="info-hours">
                        <div class="info-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="1.8"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"/>
                                <polyline points="12 6 12 12 16 14"/>
                            </svg>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Hours</div>
                            <div class="info-value">Mon&ndash;Fri &middot; 9:00 &ndash; 18:00</div>
                        </div>
                    </div>

                </div>
            </div>

            <%-- ΓòÉΓòÉ RIGHT: contact form ΓòÉΓòÉ --%>
            <div class="contact-right">
                <form action="<%= ctx %>/contact" method="post" id="contact-form" novalidate>

                    <div class="form-group" id="fg-name">
                        <label for="contact-name">Name</label>
                        <input type="text"  id="contact-name"    name="name"
                               autocomplete="name" required>
                    </div>

                    <div class="form-group" id="fg-email">
                        <label for="contact-email">Email</label>
                        <input type="email" id="contact-email"   name="email"
                               autocomplete="email" required>
                    </div>

                    <div class="form-group" id="fg-subject">
                        <label for="contact-subject">Subject</label>
                        <input type="text"  id="contact-subject" name="subject">
                    </div>

                    <div class="form-group" id="fg-message">
                        <label for="contact-message">Message</label>
                        <textarea id="contact-message" name="message" rows="6"
                                  required style="resize:vertical"></textarea>
                    </div>

                    <button type="submit" class="contact-submit-btn" id="contact-submit">
                        Send inquiry &nbsp;&rarr;
                    </button>

                </form>
            </div>

        </div>
    </section>
</main>

<style>
/* ΓöÇΓöÇ Page layout ΓöÇΓöÇ */
.contact-section {
    padding: 64px 0 96px;
}
.contact-wrapper {
    display: grid;
    grid-template-columns: 1fr 1.15fr;
    gap: 48px;
    max-width: 960px;
    align-items: start;
}

/* ΓöÇΓöÇ Left column ΓöÇΓöÇ */
.contact-headline {
    font-size: clamp(28px, 4vw, 42px);
    font-weight: 800;
    letter-spacing: -1px;
    color: var(--text, #111);
    margin: 0 0 10px;
    line-height: 1.15;
}
.contact-sub {
    font-size: 14px;
    color: var(--muted, #6b7280);
    margin: 0 0 32px;
    line-height: 1.6;
}

/* ΓöÇΓöÇ Flash alerts ΓöÇΓöÇ */
.contact-alert {
    padding: 11px 14px;
    border-radius: 8px;
    font-size: 13.5px;
    font-weight: 500;
    margin-bottom: 20px;
}
.contact-alert-success { background:#ecfdf5; color:#065f46; border:1px solid #6ee7b7; }
.contact-alert-error   { background:#fef2f2; color:#991b1b; border:1px solid #fca5a5; }

/* ΓöÇΓöÇ Info cards ΓöÇΓöÇ */
.info-cards {
    display: flex;
    flex-direction: column;
    gap: 12px;
}
.info-card {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 18px 20px;
    background: #fff;
    border: 1px solid var(--border, #e5e7eb);
    border-radius: 12px;
    transition: box-shadow .2s;
}
.info-card:hover {
    box-shadow: 0 4px 16px rgba(79,110,247,.09);
}
.info-icon {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: #e8ecff;
    color: var(--blue, #4F6EF7);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.info-label {
    font-size: 10px;
    font-weight: 700;
    letter-spacing: .08em;
    text-transform: uppercase;
    color: var(--muted, #6b7280);
    margin-bottom: 3px;
}
.info-value {
    font-size: 14.5px;
    font-weight: 500;
    color: var(--text, #111);
}

/* ΓöÇΓöÇ Right column: form ΓöÇΓöÇ */
.contact-right {
    background: #fff;
    border: 1px solid var(--border, #e5e7eb);
    border-radius: 14px;
    padding: 32px 28px;
}
.contact-right .form-group {
    margin-bottom: 18px;
}
.contact-right .form-group label {
    display: block;
    font-size: 13.5px;
    font-weight: 500;
    color: var(--text, #111);
    margin-bottom: 6px;
}
.contact-right .form-group input,
.contact-right .form-group textarea {
    width: 100%;
    box-sizing: border-box;
    padding: 9px 12px;
    border: 1px solid var(--border, #e5e7eb);
    border-radius: 8px;
    font-size: 14px;
    font-family: inherit;
    color: var(--text, #111);
    background: #fff;
    outline: none;
    transition: border-color .18s, box-shadow .18s;
}
.contact-right .form-group input:focus,
.contact-right .form-group textarea:focus {
    border-color: var(--blue, #4F6EF7);
    box-shadow: 0 0 0 3px rgba(79,110,247,.12);
}

/* Full-width submit button */
.contact-submit-btn {
    display: block;
    width: 100%;
    padding: 13px;
    background: var(--blue, #4F6EF7);
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    transition: background .18s, transform .15s;
    margin-top: 4px;
    font-family: inherit;
}
.contact-submit-btn:hover {
    background: #3d5ce8;
    transform: translateY(-1px);
}
.contact-submit-btn:active {
    transform: translateY(0);
}

/* ΓöÇΓöÇ Responsive ΓöÇΓöÇ */
@media (max-width: 720px) {
    .contact-wrapper {
        grid-template-columns: 1fr;
    }
}
</style>

<jsp:include page="/views/common/footer.jsp" />

</body>
</html>
