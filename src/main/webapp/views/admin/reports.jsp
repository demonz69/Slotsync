<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="sidebar-brand">SlotSync</div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/services">Services</a>
            <a href="${pageContext.request.contextPath}/admin/search">Search</a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="active">Reports</a>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout">Sign out</a>
        </div>
    </aside>

    <main class="main">

        <div class="page-head">
            <div>
                <h1>Analytics &amp; Reports</h1>
                <p>Live data from your SlotSync database.</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <%-- Stat Cards --%>
        <div class="stat-row">
            <div class="stat-card">
                <div class="s-label">Total Appointments</div>
                <div class="s-value">${totalAppointments}</div>
                <div class="s-sub">All time</div>
            </div>
            <div class="stat-card">
                <div class="s-label">Completed</div>
                <div class="s-value">${completedAppointments}</div>
                <div class="s-sub">Successfully served</div>
            </div>
            <div class="stat-card">
                <div class="s-label">Active Users</div>
                <div class="s-value">${totalActiveUsers}</div>
                <div class="s-sub">Registered and active</div>
            </div>
            <div class="stat-card">
                <div class="s-label">Total Revenue</div>
                <div class="s-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
                <div class="s-sub">From completed bookings</div>
            </div>
        </div>

        <%-- Popular Services + Top Employees --%>
        <div class="grid-2">

            <div class="card">
                <div class="card-head">
                    <h3>Most Popular Services</h3>
                    <p>Ranked by completed bookings</p>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Service</th>
                            <th class="right">Bookings</th>
                            <th class="right">Revenue</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty popularServices}">
                                <tr><td colspan="4"><div class="empty-state">No data yet.</div></td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${popularServices}" varStatus="st">
                                    <tr>
                                        <td class="muted small">${st.count}</td>
                                        <td class="bold">${s.service_name}</td>
                                        <td class="right">${s.total_bookings}</td>
                                        <td class="right">$${s.revenue}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="card">
                <div class="card-head">
                    <h3>Top Employees</h3>
                    <p>By appointments handled</p>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Specialization</th>
                            <th class="right">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty topEmployees}">
                                <tr><td colspan="4"><div class="empty-state">No data yet.</div></td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="e" items="${topEmployees}" varStatus="st">
                                    <tr>
                                        <td class="muted small">${st.count}</td>
                                        <td class="bold">${e.name}</td>
                                        <td class="muted">${e.specialization}</td>
                                        <td class="right bold">${e.total}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </div>

        <%-- Appointments by Status --%>
        <div class="card">
            <div class="card-head">
                <h3>Appointments by Status</h3>
                <p>Count of all appointment statuses</p>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Status</th>
                        <th class="right">Count</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty appointmentsByStatus}">
                            <tr><td colspan="2"><div class="empty-state">No data yet.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="row" items="${appointmentsByStatus}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${row.status == 'completed'}"><span class="badge badge-green">completed</span></c:when>
                                            <c:when test="${row.status == 'confirmed'}"><span class="badge badge-blue">confirmed</span></c:when>
                                            <c:when test="${row.status == 'pending'}"><span class="badge badge-amber">pending</span></c:when>
                                            <c:otherwise><span class="badge badge-red">${row.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="right bold">${row.count}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- Average Ratings --%>
        <div class="card">
            <div class="card-head">
                <h3>Average Service Ratings</h3>
                <p>Based on client feedback</p>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Service</th>
                        <th class="center">Avg Rating</th>
                        <th class="right">Reviews</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty averageRatings}">
                            <tr><td colspan="3"><div class="empty-state">No ratings yet.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${averageRatings}">
                                <tr>
                                    <td class="bold">${r.service_name}</td>
                                    <td class="center"><span class="stars">&#9733;</span> ${r.avg_rating}</td>
                                    <td class="right muted">${r.total_reviews} reviews</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </main>
</div>
</body>
</html>
