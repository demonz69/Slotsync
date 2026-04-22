# SlotSync 📅

SlotSync is a premium appointment and service management platform built with Java, Jakarta EE, and MySQL.

## 🚀 Features
- **Dynamic Scheduling**: Manage appointments and availability in real-time.
- **Role-based Access**: Separate dashboards for Admins, Employees, and Clients.
- **Secure Auth**: SHA-256 password encryption and session-based security filters.
- **Modern UI**: Dark-mode design system with premium glassmorphism aesthetics.

---

## 🛠️ Prerequisites
Before running the project, ensure you have the following installed:
1.  **JDK 17 or higher**
2.  **MySQL Server 8.0**
3.  **Apache Maven 3.9+** (Installed in `PATH`)

---

## 🏗️ Getting Started

### 1. Database Configuration
1.  Open your MySQL client and create the database:
    ```sql
    CREATE DATABASE syncslot;
    ```
2.  Execute the table creation script (or use the one in `database/slotsync.sql` if provided):
    ```sql
    USE syncslot;
    CREATE TABLE users (
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        full_name VARCHAR(100),
        email VARCHAR(100) UNIQUE,
        password VARCHAR(255),
        role VARCHAR(20),
        status VARCHAR(20) DEFAULT 'active'
    );
    ```

### 2. Configure the Application
Open `src/main/java/dao/DBConnection.java` and update the database credentials to match your local setup:
```java
private static final String URL = "jdbc:mysql://localhost:3306/syncslot";
private static final String USER = "your_username";
private static final String PASSWORD = "your_password";
```

### 3. Run the Project
We use the **Jetty Maven Plugin** to simplify local development. You don't need a separate Tomcat installation.

Run the following command in the project root:
```bash
mvn jetty:run
```
The server will start at: **[http://localhost:8081](http://localhost:8081)**

---

## 👨‍💻 Development
- **Build**: `mvn clean compile`
- **Package**: `mvn package` (Generates a WAR file in `target/`)
- **Port**: Currently configured to **8081** to avoid common conflicts with other local servers. Change this in `pom.xml` if needed.

---

## 🔒 Security
The project includes an `AuthFilter` that protects the `/views/*` paths. Public access is granted to `/views/auth/` for login and registration.
