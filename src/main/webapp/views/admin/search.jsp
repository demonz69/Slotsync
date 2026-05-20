<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String role = user.getRole();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search | SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .tabs {
            display: flex;
            gap: 6px;
            margin-bottom: 24px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 8px;
        }
        .tab {
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 6px;
            color: var(--text-2);
            transition: all 0.15s ease;
            text-decoration: none;
        }
        .tab:hover {
            color: var(--text);
            background: var(--bg-alt);
            text-decoration: none;
        }
        .tab.active {
            color: var(--blue-700);
            background: var(--blue-50);
            font-weight: 600;
        }
        .search-container {
            background: white;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .search-form-row {
            display: flex;
            gap: 12px;
            align-items: flex-end;
        }
        .search-form-row .field {
            flex: 1;
        }
        @media (max-width: 640px) {
            .search-form-row {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
<div class="dash">
    <!-- Sidebar -->
    <aside class="sidebar" id="app-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <div class="brand-mark"></div>
                <span>SlotSync</span>
            </a>
            <div class="badge badge-amber" style="margin-top:10px; font-size:11px">
                <%= role.substring(0, 1).toUpperCase() + role.substring(1) %> Portal
            </div>
        </div>
        <nav class="col gap-2">
            <div class="sidebar-section">Menu</div>
            
            <% if ("admin".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Overview
                </a>
                <a href="${pageContext.request.contextPath}/views/admin/manage-businesses.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9h18M9 21V9M3 9l2-5h14l2 5M3 9a2 2 0 000 4v7a1 1 0 001 1h16a1 1 0 001-1v-7a2 2 0 000-4"/></svg>
                    Manage Businesses
                </a>
                <a href="${pageContext.request.contextPath}/views/admin/manage-users.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 11a4 4 0 10-8 0 4 4 0 008 0z"/><path d="M2 21a8 8 0 0120 0"/></svg>
                    Manage Users
                </a>
                <a href="${pageContext.request.contextPath}/search" class="sidenav-item active">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Search
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                    Reports
                </a>
            <% } else if ("client".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/views/user/home.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/views/user/profile.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    My Profile
                </a>
                <a href="${pageContext.request.contextPath}/search" class="sidenav-item active">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Book Service
                </a>
            <% } else if ("owner".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/views/owner/dashboard.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/views/owner/appointments.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    Appointments
                </a>
                <a href="${pageContext.request.contextPath}/views/owner/manage-employees.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    Employees
                </a>
                <a href="${pageContext.request.contextPath}/search" class="sidenav-item active">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Search
                </a>
                <a href="${pageContext.request.contextPath}/views/owner/settings.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                    Settings
                </a>
            <% } else if ("employee".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/views/employee/schedule.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    My Schedule
                </a>
                <a href="${pageContext.request.contextPath}/views/employee/availability.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    Availability
                </a>
                <a href="${pageContext.request.contextPath}/views/employee/profile.jsp" class="sidenav-item">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    Profile
                </a>
                <a href="${pageContext.request.contextPath}/search" class="sidenav-item active">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Search
                </a>
            <% } %>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout" class="sidenav-item">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                Sign out
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="dash-main animate-in">
        <div class="dash-head">
            <div>
                <h1><%= "client".equals(role) ? "Book a Service" : "Search" %></h1>
                <p class="sub"><%= "client".equals(role) ? "Search and book your appointment with top local providers." : "Search across services, users, and businesses." %></p>
            </div>
        </div>

        <%-- Search form --%>
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="search-form-row">
                <input type="hidden" name="type" value="${not empty type ? type : 'services'}">
                <div class="field">
                    <label>Search Keyword</label>
                    <input type="text" name="q" value="${keyword}" class="input" placeholder="Type name, description, or keyword..." required autocomplete="off">
                </div>
                <div style="display:flex; gap:8px;">
                    <button type="submit" class="btn btn-primary">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-svg"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        Search
                    </button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/search?type=${type}" class="btn btn-secondary">Clear</a>
                    </c:if>
                </div>
            </form>
        </div>

        <%-- Tabs (Only admins see tabs. Clients only search services) --%>
        <% if ("admin".equals(role)) { %>
            <div class="tabs">
                <a href="${pageContext.request.contextPath}/search?q=${keyword}&type=services"
                   class="tab <c:if test="${empty type || type == 'services'}">active</c:if>">Services</a>
                <a href="${pageContext.request.contextPath}/search?q=${keyword}&type=users"
                   class="tab <c:if test="${type == 'users'}">active</c:if>">Users</a>
                <a href="${pageContext.request.contextPath}/search?q=${keyword}&type=businesses"
                   class="tab <c:if test="${type == 'businesses'}">active</c:if>">Businesses</a>
            </div>
        <% } %>

        <%-- Error Alert --%>
        <c:if test="${not empty error}">
            <div class="msg-error animate-in">${error}</div>
        </c:if>

        <%-- Results Card --%>
        <div class="card animate-in animate-in-delay-1">
            <c:choose>

                <%-- No keyword yet --%>
                <c:when test="${empty keyword}">
                    <div class="card-pad" style="text-align: center; padding: 48px 24px;">
                        <div style="font-size: 40px; margin-bottom: 12px;">🔍</div>
                        <h3 class="h3" style="margin-bottom: 8px;">Start Searching</h3>
                        <p class="muted small" style="max-width: 320px; margin: 0 auto;">Enter a search keyword above to scan our database of providers.</p>
                    </div>
                </c:when>

                <%-- No results found --%>
                <c:when test="${empty results}">
                    <div class="card-pad" style="text-align: center; padding: 48px 24px;">
                        <div style="font-size: 40px; margin-bottom: 12px;">📭</div>
                        <h3 class="h3" style="margin-bottom: 8px;">No Results Found</h3>
                        <p class="muted small" style="max-width: 320px; margin: 0 auto;">We couldn't find matches for &quot;<strong>${keyword}</strong>&quot;. Try checking spelling or using broader terms.</p>
                    </div>
                </c:when>

                <%-- Services results --%>
                <c:when test="${empty type || type == 'services'}">
                    <div class="card-pad-sm" style="border-bottom: 1px solid var(--border); background: var(--bg-soft); display:flex; justify-content:space-between; align-items:center;">
                        <h3 class="h3" style="font-size: 14px; font-weight: 600; text-transform: uppercase; color: var(--text-2); letter-spacing: 0.04em;">Matched Services</h3>
                        <span class="badge badge-blue">${results.size()} Matches</span>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Service Name</th>
                                <th>Duration</th>
                                <th style="text-align: right;">Price</th>
                                <th>Status</th>
                                <c:if test="${role == 'client'}">
                                    <th style="text-align: right;">Action</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${results}" varStatus="st">
                                <tr class="hov">
                                    <td class="muted tiny mono">${st.count}</td>
                                    <td class="bold">${s.serviceName}</td>
                                    <td>${s.durationMin} min</td>
                                    <td style="text-align: right;" class="mono bold">$${s.price}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.active}">
                                                <span class="badge badge-green"><span class="badge-dot"></span>Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-red"><span class="badge-dot"></span>Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <c:if test="${role == 'client'}">
                                        <td style="text-align: right;">
                                            <a href="${pageContext.request.contextPath}/views/client/booking.jsp?step=2&serviceId=${s.serviceId}" class="btn btn-sm btn-primary">
                                                Book Now
                                            </a>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <%-- Users results (Admin only) --%>
                <c:when test="${type == 'users'}">
                    <div class="card-pad-sm" style="border-bottom: 1px solid var(--border); background: var(--bg-soft); display:flex; justify-content:space-between; align-items:center;">
                        <h3 class="h3" style="font-size: 14px; font-weight: 600; text-transform: uppercase; color: var(--text-2); letter-spacing: 0.04em;">Matched Users</h3>
                        <span class="badge badge-blue">${results.size()} Matches</span>
                    </div>
                    <table class="table">
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
                                <tr class="hov">
                                    <td class="muted tiny mono">${st.count}</td>
                                    <td class="bold">${u.full_name}</td>
                                    <td class="muted small">${u.email}</td>
                                    <td class="small">${u.phone}</td>
                                    <td>
                                        <span class="badge badge-blue">${u.role}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'active'}">
                                                <span class="badge badge-green"><span class="badge-dot"></span>Active</span>
                                            </c:when>
                                            <c:when test="${u.status == 'pending'}">
                                                <span class="badge badge-amber"><span class="badge-dot"></span>Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-red"><span class="badge-dot"></span>${u.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <%-- Businesses results (Admin only) --%>
                <c:when test="${type == 'businesses'}">
                    <div class="card-pad-sm" style="border-bottom: 1px solid var(--border); background: var(--bg-soft); display:flex; justify-content:space-between; align-items:center;">
                        <h3 class="h3" style="font-size: 14px; font-weight: 600; text-transform: uppercase; color: var(--text-2); letter-spacing: 0.04em;">Matched Businesses</h3>
                        <span class="badge badge-blue">${results.size()} Matches</span>
                    </div>
                    <table class="table">
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
                                <tr class="hov">
                                    <td class="muted tiny mono">${st.count}</td>
                                    <td class="bold">${b.business_name}</td>
                                    <td class="muted small">${b.address}</td>
                                    <td class="small">${b.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'active'}">
                                                <span class="badge badge-green"><span class="badge-dot"></span>Active</span>
                                            </c:when>
                                            <c:when test="${b.status == 'pending'}">
                                                <span class="badge badge-amber"><span class="badge-dot"></span>Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-red"><span class="badge-dot"></span>${b.status}</span>
                                            </c:otherwise>
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
