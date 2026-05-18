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
    <title>Manage Services - SlotSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="sidebar-brand">SlotSync</div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/services" class="active">Services</a>
            <a href="${pageContext.request.contextPath}/admin/search">Search</a>
            <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
        </nav>
        <div class="sidebar-foot">
            <a href="${pageContext.request.contextPath}/logout">Sign out</a>
        </div>
    </aside>

    <main class="main">

        <div class="page-head">
            <div>
                <h1>Manage Services</h1>
                <p>Add, edit or delete services offered by the business.</p>
            </div>
            <button class="btn btn-primary" onclick="openModal('addModal')">+ Add Service</button>
        </div>

        <%-- Messages --%>
        <c:if test="${msg == 'added'}">
            <div class="alert alert-success">Service added successfully.</div>
        </c:if>
        <c:if test="${msg == 'updated'}">
            <div class="alert alert-success">Service updated successfully.</div>
        </c:if>
        <c:if test="${msg == 'deleted'}">
            <div class="alert alert-success">Service deleted.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <%-- Table --%>
        <div class="card">
            <div class="search-bar">
                <input type="text" id="filterInput" placeholder="Filter services..." onkeyup="filterTable()">
            </div>
            <table id="svcTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Service Name</th>
                        <th>Category</th>
                        <th>Duration</th>
                        <th class="right">Price</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th class="right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty services}">
                            <tr><td colspan="8"><div class="empty-state">No services yet. Click &quot;+ Add Service&quot; to get started.</div></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${services}" varStatus="st">
                                <tr>
                                    <td class="muted small">${st.count}</td>
                                    <td class="bold">${s.serviceName}</td>
                                    <td class="muted">${s.categoryId}</td>
                                    <td>${s.durationMin} min</td>
                                    <td class="right bold">$<fmt:formatNumber value="${s.price}" pattern="#,##0.00"/></td>
                                    <td class="muted small">${s.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.active}"><span class="badge badge-green">Active</span></c:when>
                                            <c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="right">
                                        <div style="display:flex;gap:6px;justify-content:flex-end;">
                                            <button class="btn btn-secondary btn-sm"
                                                onclick="openEdit(${s.serviceId},'${s.serviceName}',${s.categoryId},${s.durationMin},${s.price},'${s.description}')">
                                                Edit
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/services?action=delete&id=${s.serviceId}"
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Delete this service?')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </main>
</div>

<%-- ADD Modal --%>
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <div class="modal-head">
            <h3>Add New Service</h3>
            <button class="modal-close" onclick="closeModal('addModal')">&#215;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/services" method="post">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="field">
                    <label>Service Name</label>
                    <input type="text" name="serviceName" placeholder="e.g. Haircut" required>
                </div>
                <div class="row-fields">
                    <div class="field">
                        <label>Category</label>
                        <select name="categoryId" required>
                            <option value="1">Hair</option>
                            <option value="2">Wellness</option>
                            <option value="3">Skin</option>
                            <option value="4">Auto</option>
                            <option value="5">Beauty</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Duration</label>
                        <select name="durationMin">
                            <option value="15">15 min</option>
                            <option value="20">20 min</option>
                            <option value="30" selected>30 min</option>
                            <option value="45">45 min</option>
                            <option value="60">60 min</option>
                            <option value="90">90 min</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Price</label>
                        <input type="number" name="price" step="0.01" min="0" placeholder="0.00" required>
                    </div>
                </div>
                <div class="field">
                    <label>Description</label>
                    <textarea name="description" placeholder="Brief description of this service..."></textarea>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Service</button>
            </div>
        </form>
    </div>
</div>

<%-- EDIT Modal --%>
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-head">
            <h3>Edit Service</h3>
            <button class="modal-close" onclick="closeModal('editModal')">&#215;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/services" method="post">
            <input type="hidden" name="action"    value="update">
            <input type="hidden" name="serviceId" id="editId">
            <div class="modal-body">
                <div class="field">
                    <label>Service Name</label>
                    <input type="text" name="serviceName" id="editName" required>
                </div>
                <div class="row-fields">
                    <div class="field">
                        <label>Category</label>
                        <select name="categoryId" id="editCat">
                            <option value="1">Hair</option>
                            <option value="2">Wellness</option>
                            <option value="3">Skin</option>
                            <option value="4">Auto</option>
                            <option value="5">Beauty</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Duration</label>
                        <select name="durationMin" id="editDur">
                            <option value="15">15 min</option>
                            <option value="20">20 min</option>
                            <option value="30">30 min</option>
                            <option value="45">45 min</option>
                            <option value="60">60 min</option>
                            <option value="90">90 min</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Price</label>
                        <input type="number" name="price" id="editPrice" step="0.01" min="0" required>
                    </div>
                </div>
                <div class="field">
                    <label>Description</label>
                    <textarea name="description" id="editDesc"></textarea>
                </div>
            </div>
            <div class="modal-foot">
                <button type="button" class="btn btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }

function openEdit(id, name, cat, dur, price, desc) {
    document.getElementById('editId').value    = id;
    document.getElementById('editName').value  = name;
    document.getElementById('editCat').value   = cat;
    document.getElementById('editDur').value   = dur;
    document.getElementById('editPrice').value = price;
    document.getElementById('editDesc').value  = desc;
    openModal('editModal');
}

document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) { if (e.target === this) closeModal(this.id); });
});

function filterTable() {
    var q = document.getElementById('filterInput').value.toLowerCase();
    document.querySelectorAll('#svcTable tbody tr').forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}

setTimeout(function() {
    document.querySelectorAll('.alert').forEach(function(a) {
        a.style.opacity = '0'; a.style.transition = 'opacity 0.5s';
        setTimeout(function() { a.remove(); }, 500);
    });
}, 4000);
</script>
</body>
</html>
