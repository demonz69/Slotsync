<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ page import="java.io.PrintWriter, java.io.StringWriter" %>
<%
    // Collect error details ΓÇö works both as an error page and with request attributes
    Integer    statusCode  = (Integer)    request.getAttribute("javax.servlet.error.status_code");
    String     errorMsg    = (String)     request.getAttribute("javax.servlet.error.message");
    Throwable  throwable   = (Throwable)  request.getAttribute("javax.servlet.error.exception");
    String     requestUri  = (String)     request.getAttribute("javax.servlet.error.request_uri");

    // Fallback: manual attributes set by servlets (e.g. request.setAttribute("error", "..."))
    if (errorMsg == null || errorMsg.isEmpty()) {
        Object attrError = request.getAttribute("error");
        if (attrError != null) errorMsg = attrError.toString();
    }

    if (statusCode == null) statusCode = 500;
    if (errorMsg   == null || errorMsg.isEmpty()) {
        switch (statusCode) {
            case 400: errorMsg = "Bad request ΓÇö the server couldn't understand your request."; break;
            case 403: errorMsg = "You don't have permission to access this page."; break;
            case 404: errorMsg = "The page you're looking for doesn't exist."; break;
            case 500: errorMsg = "Something went wrong on our end. Please try again shortly."; break;
            default:  errorMsg = "An unexpected error occurred."; break;
        }
    }

    // Stack trace (only shown in development ΓÇö remove in production)
    String stackTrace = "";
    boolean isDev = "development".equalsIgnoreCase(System.getProperty("slotsync.env", "development"));
    if (isDev && throwable != null) {
        StringWriter sw = new StringWriter();
        throwable.printStackTrace(new PrintWriter(sw));
        stackTrace = sw.toString();
    }

    String ctx = request.getContextPath();

    // Human-friendly title per status
    String title = "Oops ΓÇö Something went wrong";
    String icon  = "ΓÜá";
    if (statusCode == 404) { title = "Page Not Found";      icon = "≡ƒöì"; }
    if (statusCode == 403) { title = "Access Denied";       icon = "≡ƒöÆ"; }
    if (statusCode == 400) { title = "Bad Request";         icon = "ΓÜí"; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= statusCode %> ΓÇö <%= title %> | SlotSync</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css?v=2">
    <style>
        /* ΓöÇΓöÇ Error Page Layout ΓöÇΓöÇ */
        .error-page {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .error-body {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 24px;
        }

        .error-card {
            max-width: 520px;
            width: 100%;
            text-align: center;
        }

        .error-code {
            font-size: clamp(72px, 14vw, 120px);
            font-weight: 800;
            line-height: 1;
            letter-spacing: -4px;
            background: linear-gradient(135deg, var(--blue, #4F6EF7) 0%, #818cf8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .error-icon {
            font-size: 36px;
            margin-bottom: 16px;
            display: block;
        }

        .error-title {
            font-size: 26px;
            font-weight: 700;
            color: var(--text, #111);
            margin: 0 0 12px;
        }

        .error-message {
            font-size: 15px;
            color: var(--muted, #6b7280);
            line-height: 1.65;
            margin: 0 0 32px;
        }

        .error-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Stack trace block (dev only) */
        .error-trace {
            margin-top: 40px;
            text-align: left;
            background: #fafafa;
            border: 1px solid var(--border, #e5e7eb);
            border-radius: 8px;
            padding: 16px;
            overflow-x: auto;
        }

        .error-trace summary {
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            color: var(--muted, #6b7280);
            text-transform: uppercase;
            letter-spacing: .05em;
            margin-bottom: 8px;
        }

        .error-trace pre {
            font-size: 11px;
            line-height: 1.6;
            color: #dc2626;
            white-space: pre-wrap;
            word-break: break-all;
            margin: 0;
        }

        /* Request URI pill */
        .error-uri {
            display: inline-block;
            font-family: monospace;
            font-size: 12px;
            background: var(--surface, #f3f4f6);
            border: 1px solid var(--border, #e5e7eb);
            border-radius: 999px;
            padding: 4px 12px;
            color: var(--muted, #6b7280);
            margin-bottom: 24px;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body class="error-page">

    <%-- ===== Shared Header ===== --%>
    <jsp:include page="/views/common/navbar.jsp" />

    <%-- ===== Error Content ===== --%>
    <main class="error-body" id="error-content">
        <div class="error-card">

            <span class="error-icon"><%= icon %></span>
            <div class="error-code" id="error-status-code"><%= statusCode %></div>
            <h1 class="error-title" id="error-title"><%= title %></h1>

            <% if (requestUri != null && !requestUri.isEmpty()) { %>
                <div class="error-uri" title="<%= requestUri %>"><%= requestUri %></div>
            <% } %>

            <p class="error-message" id="error-message"><%= errorMsg %></p>

            <div class="error-actions">
                <a href="<%= ctx %>/" class="btn btn-primary btn-sm" id="error-btn-home">
                    ΓåÉ Back to Home
                </a>
                <button onclick="history.back()" class="btn btn-secondary btn-sm" id="error-btn-back">
                    Go Back
                </button>
            </div>

            <%-- Dev-only stack trace --%>
            <% if (isDev && !stackTrace.isEmpty()) { %>
                <details class="error-trace">
                    <summary>Stack Trace (dev mode)</summary>
                    <pre><%= stackTrace %></pre>
                </details>
            <% } %>

        </div>
    </main>

    <%-- ===== Shared Footer ===== --%>
    <jsp:include page="/views/common/footer.jsp" />

</body>
</html>
