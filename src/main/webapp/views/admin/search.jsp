<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>Search - SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="sidebar-brand">SlotSync</div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/services">Services</a>
            <a href="${pageContext.request.contextPath}/admin/search" class="active">Search</a>
            <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout">Sign out</a>
        </div>
    </aside>

    <main class="main">

        <div class="page-head">
            <div>
                <h1>Search</h1>
                <p>Search across services, users, and businesses.</p>
            </div>
        </div>

        <%-- Search form --%>
        <div class="card" style="margin-bottom:18px;">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/search" method="GET"
                      style="display:flex;gap:10px;align-items:flex-end;">
                    <input type="hidden" name="type" value="${not empty type ? type : 'services'}">
                    <div class="field" style="flex:1;">
                        <label>Search Keyword</label>
                        <input type="text" name="q" value="${keyword}" placeholder="Type to search..." required>
                    </div>
                    <button type="submit" class="btn btn-primary">Search</button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/search" class="btn btn-secondary">Clear</a>
                    </c:if>
                </form>
            </div>
        </div>

        <%-- Tabs --%>
        <div class="tabs">
            <a href="${pageContext.request.contextPath}/admin/search?q=${keyword}&type=services"
               class="tab <c:if test="${empty type || type == 'services'}">active</c:if>">Services</a>
            <a href="${pageContext.request.contextPath}/admin/search?q=${keyword}&type=users"
               class="tab <c:if test="${type == 'users'}">active</c:if>">Users</a>
            <a href="${pageContext.request.contextPath}/admin/search?q=${keyword}&type=businesses"
               class="tab <c:if test="${type == 'businesses'}">active</c:if>">Businesses</a>
        </div>

        <%-- Error --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <%-- Results --%>
        <div class="card">
            <c:choose>

                <%-- No keyword yet --%>
                <c:when test="${empty keyword}">
                    <div class="empty-state">Enter a keyword above and press Search.</div>
                </c:when>

                <%-- No results --%>
                <c:when test="${empty results}">
                    <div class="empty-state">No results found for &quot;<strong>${keyword}</strong>&quot;.</div>
                </c:when>

                <%-- Services results --%>
                <c:when test="${empty type || type == 'services'}">
                    <div class="card-head">
                        <h3>Services</h3>
                        <p>${results.size()} result(s) for &quot;${keyword}&quot;</p>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Service Name</th>
                                <th>Duration</th>
                                <th class="right">Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${results}" varStatus="st">
                                <tr>
                                    <td class="muted small">${st.count}</td>
                                    <td class="bold">${s.serviceName}</td>
                                    <td>${s.durationMin} min</td>
                                    <td class="right">$${s.price}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.active}"><span class="badge badge-green">Active</span></c:when>
                                            <c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <%-- Users results --%>
                <c:when test="${type == 'users'}">
                    <div class="card-head">
                        <h3>Users</h3>
                        <p>${results.size()} result(s) for &quot;${keyword}&quot;</p>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${results}" varStatus="st">
                                <tr>
                                    <td class="muted small">${st.count}</td>
                                    <td class="bold">${u.full_name}</td>
                                    <td class="muted">${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td><span class="badge badge-blue">${u.role}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'active'}"><span class="badge badge-green">active</span></c:when>
                                            <c:when test="${u.status == 'pending'}"><span class="badge badge-amber">pending</span></c:when>
                                            <c:otherwise><span class="badge badge-red">${u.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <%-- Businesses results --%>
                <c:when test="${type == 'businesses'}">
                    <div class="card-head">
                        <h3>Businesses</h3>
                        <p>${results.size()} result(s) for &quot;${keyword}&quot;</p>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Business Name</th>
                                <th>Address</th>
                                <th>Phone</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${results}" varStatus="st">
                                <tr>
                                    <td class="muted small">${st.count}</td>
                                    <td class="bold">${b.business_name}</td>
                                    <td class="muted">${b.address}</td>
                                    <td>${b.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'active'}"><span class="badge badge-green">active</span></c:when>
                                            <c:when test="${b.status == 'pending'}"><span class="badge badge-amber">pending</span></c:when>
                                            <c:otherwise><span class="badge badge-red">${b.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

            </c:choose>
        </div>

    </main>
</div>
</body>
</html>
