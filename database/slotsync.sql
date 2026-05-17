CREATE DATABASE IF NOT EXISTS Slotsync;
USE slotsync;

CREATE DATABASE IF NOT EXISTS slotsync;
USE slotsync;

CREATE TABLE IF NOT EXISTS roles (
    role_id     INT          AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS users (
    user_id    INT           AUTO_INCREMENT PRIMARY KEY,
    full_name  VARCHAR(100)  NOT NULL,
    email      VARCHAR(100)  NOT NULL UNIQUE,
    phone      VARCHAR(20)   NOT NULL UNIQUE,
    password   VARCHAR(255)  NOT NULL,
    role_id    INT           NOT NULL,
    status     ENUM('pending','active','suspended') NOT NULL DEFAULT 'pending',
    created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE IF NOT EXISTS businesses (
    business_id   INT           AUTO_INCREMENT PRIMARY KEY,
    business_name VARCHAR(150)  NOT NULL,
    owner_id      INT           NOT NULL,
    email         VARCHAR(100)  NOT NULL,
    phone         VARCHAR(20),
    address       VARCHAR(255),
    description   TEXT,
    status        ENUM('pending','active','suspended') NOT NULL DEFAULT 'pending',
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_biz_owner FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id    INT          AUTO_INCREMENT PRIMARY KEY,
    user_id        INT          NOT NULL UNIQUE,
    business_id    INT          NOT NULL,
    specialization VARCHAR(150) NOT NULL,
    bio            TEXT,
    CONSTRAINT fk_emp_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_emp_biz  FOREIGN KEY (business_id) REFERENCES businesses(business_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS service_categories (
    category_id   INT         AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE,
    description   VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS services (
    service_id   INT            AUTO_INCREMENT PRIMARY KEY,
    business_id  INT            NOT NULL,
    service_name VARCHAR(100)   NOT NULL,
    category_id  INT            NOT NULL,
    duration_min INT            NOT NULL,
    price        DECIMAL(8,2)   NOT NULL,
    description  TEXT,
    is_active    BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_svc_biz      FOREIGN KEY (business_id) REFERENCES businesses(business_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_svc_category FOREIGN KEY (category_id) REFERENCES service_categories(category_id),
    CONSTRAINT uq_svc_per_biz  UNIQUE (business_id, service_name)
);

CREATE TABLE IF NOT EXISTS availability (
    availability_id INT      AUTO_INCREMENT PRIMARY KEY,
    employee_id     INT      NOT NULL,
    day_of_week     TINYINT  NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time      TIME     NOT NULL,
    end_time        TIME     NOT NULL,
    is_available    BOOLEAN  NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_avail_emp FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id) ON DELETE CASCADE,
    CONSTRAINT uq_avail UNIQUE (employee_id, day_of_week, start_time)
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT      AUTO_INCREMENT PRIMARY KEY,
    business_id    INT      NOT NULL,
    client_id      INT      NOT NULL,
    employee_id    INT      NOT NULL,
    service_id     INT      NOT NULL,
    appt_date      DATE     NOT NULL,
    start_time     TIME     NOT NULL,
    end_time       TIME     NOT NULL,
    status         ENUM('pending','confirmed','completed','cancelled')
                            NOT NULL DEFAULT 'pending',
    notes          TEXT,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_appt_biz     FOREIGN KEY (business_id) REFERENCES businesses(business_id),
    CONSTRAINT fk_appt_client  FOREIGN KEY (client_id)   REFERENCES users(user_id),
    CONSTRAINT fk_appt_emp     FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_appt_service FOREIGN KEY (service_id)  REFERENCES services(service_id)
);

CREATE TABLE IF NOT EXISTS feedback (
    feedback_id     INT      AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT      NOT NULL UNIQUE,
    client_id       INT      NOT NULL,
    rating          TINYINT  NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fb_appt   FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    CONSTRAINT fk_fb_client FOREIGN KEY (client_id)
        REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS wishlist (
    client_id  INT      NOT NULL,
    service_id INT      NOT NULL,
    added_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (client_id, service_id),
    CONSTRAINT fk_wl_client  FOREIGN KEY (client_id)  REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_wl_service FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS contact_inquiries (
    inquiry_id   INT          AUTO_INCREMENT PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    subject      VARCHAR(200) NOT NULL,
    message      TEXT         NOT NULL,
    is_read      BOOLEAN      NOT NULL DEFAULT FALSE,
    submitted_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email       ON users(email);
CREATE INDEX idx_users_status      ON users(status);
CREATE INDEX idx_biz_owner         ON businesses(owner_id);
CREATE INDEX idx_biz_status        ON businesses(status);
CREATE INDEX idx_emp_biz           ON employees(business_id);
CREATE INDEX idx_svc_biz           ON services(business_id);
CREATE INDEX idx_appt_biz          ON appointments(business_id);
CREATE INDEX idx_appt_client       ON appointments(client_id);
CREATE INDEX idx_appt_emp          ON appointments(employee_id);
CREATE INDEX idx_appt_date         ON appointments(appt_date);
CREATE INDEX idx_avail_emp         ON availability(employee_id);
CREATE INDEX idx_feedback_appt     ON feedback(appointment_id);


INSERT INTO roles (role_name, description) VALUES
('admin',    'Platform administrator — manages all businesses and users'),
('owner',    'Business owner — manages own business, employees, services'),
('employee', 'Works for a business — views own schedule, sets availability'),
('client',   'End user — browses businesses, books appointments');

-- Passwords: BCrypt hash of 'password123' (replace with real hashes)
INSERT INTO users (full_name, email, phone, password, role_id, status) VALUES
-- Admin (platform)
('Platform Admin',     'admin@slotsync.com',     '9800000000', '$2a$10$hashadmin000',     1, 'active'),
-- Owners
('Ramesh Shrestha',    'ramesh@sharpsalon.com',   '9800000001', '$2a$10$hashramesh01',     2, 'active'),
('Anjali Thapa',       'anjali@zenhealing.com',   '9800000002', '$2a$10$hashanjali02',     2, 'active'),
('Bikram Gurung',      'bikram@fixitgarage.com',  '9800000003', '$2a$10$hashbikram03',     2, 'active'),
-- Employees
('Alex Brown',         'alex@sharpsalon.com',     '9800000010', '$2a$10$hashalex010',      3, 'active'),
('Maya Rai',           'maya@sharpsalon.com',     '9800000011', '$2a$10$hashmaya011',      3, 'active'),
('Sara Magar',         'sara@zenhealing.com',     '9800000012', '$2a$10$hashsara012',      3, 'active'),
('Dev Tamang',         'dev@fixitgarage.com',     '9800000013', '$2a$10$hashdev0013',      3, 'active'),
-- Clients
('Aarav Sharma',       'aarav@gmail.com',         '9800000020', '$2a$10$hashaarav20',      4, 'active'),
('Priya Karki',        'priya@gmail.com',         '9800000021', '$2a$10$hashpriya21',      4, 'active'),
('Tiraj Basnet',       'tiraj@gmail.com',         '9800000022', '$2a$10$hashtiraj22',      4, 'active'),
('Sita Tamang',        'sita@gmail.com',          '9800000023', '$2a$10$hashsita023',      4, 'pending'),
('Ravi Nepal',         'ravi@gmail.com',          '9800000024', '$2a$10$hashravi024',      4, 'pending');


INSERT INTO businesses (business_name, owner_id, email, phone, address, description, status) VALUES
('Sharp Salon',    2, 'info@sharpsalon.com',  '025-580001', 'Itahari-6, Sunsari',       'Premium hair and grooming salon',               'active'),
('Zen Healing',    3, 'info@zenhealing.com',  '025-580002', 'Itahari-8, Sunsari',       'Wellness center — massage, facial, skincare',   'active'),
('FixIt Garage',   4, 'info@fixitgarage.com', '025-580003', 'Dharan Road, Sunsari',     'Vehicle repair and maintenance appointments',   'active');


INSERT INTO employees (user_id, business_id, specialization, bio) VALUES
(5, 1, 'Haircut, Beard Trim',       'Senior barber with 5 years experience'),
(6, 1, 'Hair Color, Styling',       'Color specialist and stylist'),
(7, 2, 'Deep Tissue, Swedish',      'Certified massage therapist'),
(8, 3, 'Engine, Brakes, Electrical', 'Certified mechanic — 8 years experience');


INSERT INTO service_categories (category_name, description) VALUES
('Hair',       'Haircut, styling, and coloring services'),
('Wellness',   'Massage and relaxation services'),
('Skin',       'Facial and skin treatment services'),
('Auto',       'Vehicle repair and maintenance'),
('Beauty',     'Nail and beauty care services');


INSERT INTO services (business_id, service_name, category_id, duration_min, price, description) VALUES
(1, 'Haircut',        1, 30, 500.00,  'Classic haircut and styling'),
(1, 'Beard Trim',     1, 15, 200.00,  'Precision beard shaping and trim'),
(1, 'Hair Color',     1, 60, 1500.00, 'Full hair coloring service'),
(1, 'Head Massage',   2, 20, 300.00,  'Relaxing scalp and head massage');


INSERT INTO services (business_id, service_name, category_id, duration_min, price, description) VALUES
(2, 'Swedish Massage',    2, 60, 2000.00, 'Full body relaxation massage'),
(2, 'Deep Tissue',        2, 60, 2500.00, 'Targeted deep pressure massage'),
(2, 'Facial',             3, 45, 1800.00, 'Deep cleansing facial treatment'),
(2, 'Aromatherapy',       2, 45, 1500.00, 'Essential oil relaxation session');


INSERT INTO services (business_id, service_name, category_id, duration_min, price, description) VALUES
(3, 'Oil Change',          4, 30, 800.00,   'Full synthetic oil change'),
(3, 'Brake Inspection',    4, 45, 500.00,   'Brake pad and disc inspection'),
(3, 'Engine Diagnostic',   4, 60, 1200.00,  'Full OBD-II diagnostic scan'),
(3, 'Tire Rotation',       4, 30, 600.00,   'Four-wheel tire rotation and balance');


INSERT INTO availability (employee_id, day_of_week, start_time, end_time) VALUES
(1, 1, '09:00:00', '17:00:00'),
(1, 2, '09:00:00', '17:00:00'),
(1, 3, '09:00:00', '17:00:00'),
(1, 4, '09:00:00', '17:00:00'),
(1, 5, '09:00:00', '17:00:00');


INSERT INTO availability (employee_id, day_of_week, start_time, end_time) VALUES
(2, 2, '10:00:00', '18:00:00'),
(2, 3, '10:00:00', '18:00:00'),
(2, 4, '10:00:00', '18:00:00'),
(2, 5, '10:00:00', '18:00:00'),
(2, 6, '10:00:00', '16:00:00');


INSERT INTO availability (employee_id, day_of_week, start_time, end_time) VALUES
(3, 1, '09:00:00', '17:00:00'),
(3, 2, '09:00:00', '17:00:00'),
(3, 3, '09:00:00', '17:00:00'),
(3, 4, '09:00:00', '17:00:00'),
(3, 5, '09:00:00', '17:00:00');


INSERT INTO availability (employee_id, day_of_week, start_time, end_time) VALUES
(4, 1, '08:00:00', '16:00:00'),
(4, 2, '08:00:00', '16:00:00'),
(4, 3, '08:00:00', '16:00:00'),
(4, 4, '08:00:00', '16:00:00'),
(4, 5, '08:00:00', '16:00:00'),
(4, 6, '08:00:00', '14:00:00');


INSERT INTO appointments (business_id, client_id, employee_id, service_id, appt_date, start_time, end_time, status) VALUES
-- Sharp Salon
(1, 9,  1, 1, '2026-05-03', '10:00:00', '10:30:00', 'confirmed'),
(1, 10, 2, 3, '2026-05-05', '14:00:00', '15:00:00', 'pending'),
(1, 11, 1, 1, '2026-04-20', '11:00:00', '11:30:00', 'completed'),
(1, 9,  1, 2, '2026-04-15', '09:30:00', '09:45:00', 'completed'),
-- Zen Healing
(2, 10, 3, 5, '2026-05-04', '10:00:00', '11:00:00', 'confirmed'),
(2, 11, 3, 7, '2026-04-18', '14:00:00', '14:45:00', 'completed'),
-- FixIt Garage
(3, 9,  4, 9, '2026-05-06', '08:00:00', '08:30:00', 'pending'),
(3, 11, 4, 11, '2026-04-22', '09:00:00', '10:00:00', 'completed');


INSERT INTO feedback (appointment_id, client_id, rating, comment) VALUES
(3, 11, 5, 'Alex did a great haircut, very professional!'),
(4, 9,  4, 'Quick and clean beard trim. Will visit again.'),
(6, 11, 5, 'Best facial I have ever had. Highly recommend Zen Healing.'),
(8, 11, 4, 'Thorough diagnostic. Found the issue quickly.');


INSERT INTO wishlist (client_id, service_id) VALUES
(9,  5),   -- Aarav wishlisted Swedish Massage
(9,  7),   -- Aarav wishlisted Facial
(10, 1),   -- Priya wishlisted Haircut
(11, 6),   -- Tiraj wishlisted Deep Tissue
(11, 9);   -- Tiraj wishlisted Oil Change
