<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "About Us | SlotSync");
    request.setAttribute("pageDesc",  "Six engineers, one booking platform. Learn about the team behind SlotSync.");
    String ctx = request.getContextPath();
%>
<%-- ===== PAGE HEADER (html + head + navbar) ===== --%>
<jsp:include page="/views/common/header.jsp" />

<main id="about-page">

    <%-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
         HERO
    ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ --%>
    <section class="about-hero">
        <div class="container about-hero-inner">
            <div class="section-eyebrow">About us</div>
            <h1 class="about-headline">Six engineers, one booking platform.</h1>
            <p class="about-sub">
                We started SlotSync because every booking tool we tried felt designed for the
                business, not the person clicking through it.
            </p>
        </div>
    </section>

    <%-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
         TEAM GRID
    ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ --%>
    <section class="about-team-section">
        <div class="container">
            <div class="team-grid">

                <!-- TB -->
                <div class="team-card" id="team-tiraj">
                    <div class="team-avatar">TB</div>
                    <div class="team-name">Tiraj Basnet</div>
                    <div class="team-role">Auth &amp; Architecture</div>
                </div>

                <!-- ST -->
                <div class="team-card" id="team-siddhant">
                    <div class="team-avatar">ST</div>
                    <div class="team-name">Siddhant Tamrakar</div>
                    <div class="team-role">Database</div>
                </div>

                <!-- MS -->
                <div class="team-card" id="team-mausam">
                    <div class="team-avatar">MS</div>
                    <div class="team-name">Mausam Shrestha</div>
                    <div class="team-role">Frontend</div>
                </div>

                <!-- AM -->
                <div class="team-card" id="team-aanand">
                    <div class="team-avatar">AM</div>
                    <div class="team-name">Aanand Mandal</div>
                    <div class="team-role">Appointments</div>
                </div>

                <!-- RC -->
                <div class="team-card" id="team-rose">
                    <div class="team-avatar">RC</div>
                    <div class="team-name">Rose Chaudhary</div>
                    <div class="team-role">Testing</div>
                </div>

                <!-- AK -->
                <div class="team-card" id="team-avani">
                    <div class="team-avatar">AK</div>
                    <div class="team-name">Avani Karki</div>
                    <div class="team-role">Booking Flow</div>
                </div>

            </div>
        </div>
    </section>

</main>

<style>
/* ΓöÇΓöÇ About Hero ΓöÇΓöÇ */
.about-hero {
    padding: 80px 0 56px;
    text-align: center;
}
.about-hero-inner {
    max-width: 680px;
    margin: 0 auto;
}
.about-hero .section-eyebrow {
    margin-bottom: 16px;
}
.about-headline {
    font-size: clamp(32px, 5vw, 52px);
    font-weight: 800;
    line-height: 1.15;
    letter-spacing: -1.5px;
    color: var(--text, #111);
    margin: 0 0 20px;
}
.about-sub {
    font-size: 16px;
    color: var(--muted, #6b7280);
    line-height: 1.7;
    max-width: 500px;
    margin: 0 auto;
}

/* ΓöÇΓöÇ Team Section ΓöÇΓöÇ */
.about-team-section {
    padding: 16px 0 96px;
}

/* 3-column grid */
.team-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    max-width: 860px;
    margin: 0 auto;
}

/* Card */
.team-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 36px 24px 32px;
    background: #fff;
    border: 1px solid var(--border, #e5e7eb);
    border-radius: 14px;
    text-align: center;
    transition: box-shadow .2s, transform .2s;
}
.team-card:hover {
    box-shadow: 0 8px 28px rgba(79, 110, 247, .10);
    transform: translateY(-3px);
}

/* Avatar circle */
.team-avatar {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: #e8ecff;
    color: var(--blue, #4F6EF7);
    font-size: 20px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 18px;
    letter-spacing: .5px;
}

/* Name */
.team-name {
    font-size: 15px;
    font-weight: 600;
    color: var(--text, #111);
    margin-bottom: 4px;
}

/* Role */
.team-role {
    font-size: 13px;
    color: var(--muted, #6b7280);
}

/* ΓöÇΓöÇ Responsive ΓöÇΓöÇ */
@media (max-width: 640px) {
    .team-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}
@media (max-width: 400px) {
    .team-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<%-- ===== PAGE FOOTER ===== --%>
<jsp:include page="/views/common/footer.jsp" />

</body>
</html>
