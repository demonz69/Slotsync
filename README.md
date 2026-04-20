# SlotSync

SlotSync is a Java-based web application for managing appointments, services, and users. It uses Servlets, JSP, and MySQL for the backend database.

## Prerequisites

- **Java Development Kit (JDK):** Version 11 or higher.
- **Servlet Container:** Apache Tomcat (version 9 or 10 recommended).
- **Database:** MySQL Server.
- **IDE:** Eclipse IDE for Enterprise Java and Web Developers, IntelliJ IDEA Ultimate, or VS Code (with Java extensions).

## Setup Instructions

### 1. Database Setup
1. Ensure MySQL is installed and running on your system.
2. Open your preferred database tool (e.g., MySQL Workbench, phpMyAdmin, or command line).
3. Execute the SQL script provided in `database/slotsync.sql` to create the required database schemas and tables.
4. Update the database credentials in the application. Open `src/main/java/dao/DBConnection.java` and modify the connection string, username, and password to match your local MySQL configuration.

### 2. Project Setup in IDE
**For Eclipse/IntelliJ:**
1. Clone or download the repository to your local machine.
2. Import the project as a "Dynamic Web Project" (Eclipse) or a "Java Enterprise/Web Application" (IntelliJ).
3. Ensure your IDE is configured with Apache Tomcat as the server.
4. Add the necessary libraries (like `mysql-connector-java.jar` and `servlet-api.jar`) to the `WEB-INF/lib` directory (you will need to create `WEB-INF/lib` if it doesn't exist).


### 3. Running the Application
1. Add the project to your configured Tomcat Server in your IDE.
2. Start the Tomcat Server.
3. Open a web browser and navigate to the application URL, typically:
   `http://localhost:8080/Slotsync` (the exact URL may vary depending on your Tomcat and context root configuration).

## Features
- User authentication (Login/Register/Logout)
- Appointment booking and scheduling
- Service management
- Admin dashboard
- Feedback submission
