<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Register</title>
    </head>

    <body>

        <h2>Register</h2>

        <form action="../../register" method="post">

            <label>Full Name:</label>
            <input type="text" name="fullName" required><br><br>

            <label>Email:</label>
            <input type="email" name="email" required><br><br>

            <label>Password:</label>
            <input type="password" name="password" required><br><br>

            <button type="submit">Register</button>
        </form>

        <!-- ERROR MESSAGE -->
        <% if (request.getAttribute("error") !=null) { %>
            <p style="color:red;">
                <%= request.getAttribute("error") %>
            </p>
            <% } %>

                <!-- SUCCESS MESSAGE -->
                <% if (request.getAttribute("success") !=null) { %>
                    <p style="color:green;">
                        <%= request.getAttribute("success") %>
                    </p>
                    <% } %>

    </body>

    </html>