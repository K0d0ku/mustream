-- CREATE SCHEMA IF NOT EXISTS unistud_tempr;

CREATE TABLE unistud_tempr.employee (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    identification_number VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE unistud_tempr.departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

CREATE TABLE unistud_tempr.business_trip (
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    trip_location VARCHAR(100) NOT NULL,
    trip_company_name VARCHAR(100) NOT NULL,
    employee_id INT REFERENCES unistud_tempr.employee(id) ON DELETE CASCADE,
    department_id INT REFERENCES unistud_tempr.departments(id) ON DELETE CASCADE
);

/*Inserting data*/
INSERT INTO unistud_tempr.employee (first_name, last_name, date_of_birth, identification_number)
VALUES
('John', 'Doe', '1985-06-15', 'ID123456789'),
('Jane', 'Smith', '1990-11-20', 'ID987654321'),
('Alice', 'Johnson', '1992-03-05', 'ID564738291'),
('Bob', 'Brown', '1988-07-25', 'ID112233445');

INSERT INTO unistud_tempr.departments (department_name, location)
VALUES
('Human Resources', 'New York'),
('Finance', 'Chicago'),
('Marketing', 'San Francisco'),
('IT', 'Boston');

INSERT INTO unistud_tempr.business_trip (start_date, end_date, trip_location, trip_company_name, employee_id, department_id)
VALUES
('2025-05-01', '2025-05-05', 'London', 'TechCorp', 1, 4),
('2025-06-10', '2025-06-15', 'Paris', 'FinTech Inc.', 2, 2),
('2025-07-01', '2025-07-07', 'Tokyo', 'MarketExperts', 3, 3),
('2025-08-10', '2025-08-12', 'Berlin', 'GlobalHR', 4, 1);

/*queries*/
/*all trips*/
SELECT
    bt.id AS trip_id,
    bt.start_date,
    bt.end_date,
    bt.trip_location,
    bt.trip_company_name,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    d.department_name AS department_name,
    d.location AS department_location
FROM
    unistud_tempr.business_trip bt
JOIN
    unistud_tempr.employee e ON bt.employee_id = e.id
JOIN
    unistud_tempr.departments d ON bt.department_id = d.id
ORDER BY
    bt.start_date;

/*specific person trip*/
SELECT
    bt.id AS trip_id,
    bt.start_date,
    bt.end_date,
    bt.trip_location,
    bt.trip_company_name,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    d.department_name AS department_name,
    d.location AS department_location
FROM
    unistud_tempr.business_trip bt
JOIN
    unistud_tempr.employee e ON bt.employee_id = e.id
JOIN
    unistud_tempr.departments d ON bt.department_id = d.id
WHERE
    e.id = 1  -- Replace '1' with the specific employee's ID
ORDER BY
    bt.start_date;