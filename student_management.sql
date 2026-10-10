-- Student Management System — MySQL 8+
-- Creates tables, inserts sample records, and demonstrates SQL queries.
-- WARNING: The next line deletes an existing database with this project name.
DROP DATABASE IF EXISTS student_management;
CREATE DATABASE student_management;
USE student_management;

-- 1. Student master table
CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE,
    phone VARCHAR(20)
);

-- 2. Course master table
CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    credits INT NOT NULL CHECK (credits > 0)
);

-- 3. Enrollment connects students and courses (many-to-many)
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    CONSTRAINT uq_student_course_year UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id)
        REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id)
        REFERENCES Course(course_id) ON DELETE CASCADE
);

-- 4. Marks for each enrollment
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL UNIQUE,
    internal_marks DECIMAL(5,2) NOT NULL CHECK (internal_marks BETWEEN 0 AND 100),
    exam_marks DECIMAL(5,2) NOT NULL CHECK (exam_marks BETWEEN 0 AND 100),
    CONSTRAINT fk_marks_enrollment FOREIGN KEY (enrollment_id)
        REFERENCES Enrollment(enrollment_id) ON DELETE CASCADE
);

-- 5. Attendance sessions for each enrollment
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late') NOT NULL,
    CONSTRAINT fk_attendance_enrollment FOREIGN KEY (enrollment_id)
        REFERENCES Enrollment(enrollment_id) ON DELETE CASCADE,
    CONSTRAINT uq_attendance_day UNIQUE (enrollment_id, attendance_date)
);

-- Sample students
INSERT INTO Student (first_name, last_name, email, date_of_birth, phone) VALUES
('Aarav', 'Sharma', 'aarav.sharma@example.com', '2005-03-14', '9000000001'),
('Diya', 'Patel', 'diya.patel@example.com', '2004-11-22', '9000000002'),
('Rohan', 'Kumar', 'rohan.kumar@example.com', '2005-07-09', '9000000003'),
('Ananya', 'Rao', 'ananya.rao@example.com', '2004-01-30', '9000000004'),
('Ishaan', 'Das', 'ishaan.das@example.com', '2005-09-17', '9000000005');

-- Sample courses
INSERT INTO Course (course_name, course_code, credits) VALUES
('Database Management Systems', 'DBMS201', 4),
('Python Programming', 'PY101', 3),
('Data Analytics', 'DA210', 4);

-- Enrollments
INSERT INTO Enrollment (student_id, course_id, enrollment_date, academic_year) VALUES
(1, 1, '2026-06-10', '2026-2027'),
(1, 2, '2026-06-10', '2026-2027'),
(2, 1, '2026-06-11', '2026-2027'),
(2, 3, '2026-06-11', '2026-2027'),
(3, 2, '2026-06-12', '2026-2027'),
(4, 1, '2026-06-12', '2026-2027'),
(4, 3, '2026-06-12', '2026-2027'),
(5, 2, '2026-06-13', '2026-2027');

-- Marks (one record per enrollment)
INSERT INTO Marks (enrollment_id, internal_marks, exam_marks) VALUES
(1, 18, 76),
(2, 20, 88),
(3, 17, 69),
(4, 19, 91),
(5, 15, 72),
(6, 16, 81),
(7, 20, 95),
(8, 18, 79);

-- Attendance sample sessions
INSERT INTO Attendance (enrollment_id, attendance_date, status) VALUES
(1, '2026-07-01', 'Present'),
(1, '2026-07-02', 'Present'),
(1, '2026-07-03', 'Absent'),
(2, '2026-07-01', 'Present'),
(2, '2026-07-02', 'Late'),
(3, '2026-07-01', 'Absent'),
(3, '2026-07-02', 'Present'),
(4, '2026-07-01', 'Present'),
(4, '2026-07-02', 'Present'),
(5, '2026-07-01', 'Present'),
(6, '2026-07-01', 'Late'),
(6, '2026-07-02', 'Present'),
(7, '2026-07-01', 'Present'),
(8, '2026-07-01', 'Absent');

-- =========================================================
-- EXAMPLE QUERIES
-- =========================================================

-- A. Display all students
SELECT * FROM Student;

-- B. Display all courses
SELECT * FROM Course;

-- C. Student names with their enrolled courses (JOIN)
SELECT s.student_id,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name,
       e.academic_year
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON e.course_id = c.course_id
ORDER BY student_name, c.course_name;

-- D. Calculate total marks for each enrollment
SELECT s.student_id,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name,
       m.internal_marks,
       m.exam_marks,
       (m.internal_marks + m.exam_marks) AS total_marks
FROM Marks m
JOIN Enrollment e ON m.enrollment_id = e.enrollment_id
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id
ORDER BY total_marks DESC;

-- E. Average total marks by course (aggregate + GROUP BY)
SELECT c.course_name,
       ROUND(AVG(m.internal_marks + m.exam_marks), 2) AS average_total_marks
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
JOIN Marks m ON e.enrollment_id = m.enrollment_id
GROUP BY c.course_id, c.course_name
ORDER BY average_total_marks DESC;

-- F. Students whose total marks are 90 or above (filtering)
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name,
       (m.internal_marks + m.exam_marks) AS total_marks
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON e.course_id = c.course_id
JOIN Marks m ON e.enrollment_id = m.enrollment_id
WHERE (m.internal_marks + m.exam_marks) >= 90
ORDER BY total_marks DESC;

-- G. Number of students enrolled in each course
SELECT c.course_name,
       COUNT(DISTINCT e.student_id) AS enrolled_students
FROM Course c
LEFT JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY enrolled_students DESC;

-- H. Attendance percentage per student and course
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name,
       COUNT(a.attendance_id) AS recorded_sessions,
       SUM(CASE WHEN a.status IN ('Present', 'Late') THEN 1 ELSE 0 END) AS attended_sessions,
       ROUND(
           100.0 * SUM(CASE WHEN a.status IN ('Present', 'Late') THEN 1 ELSE 0 END)
           / NULLIF(COUNT(a.attendance_id), 0), 2
       ) AS attendance_percentage
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON e.course_id = c.course_id
LEFT JOIN Attendance a ON e.enrollment_id = a.enrollment_id
GROUP BY s.student_id, s.first_name, s.last_name, c.course_id, c.course_name
ORDER BY student_name, c.course_name;

-- I. Find students with no enrollments
SELECT s.student_id, s.first_name, s.last_name
FROM Student s
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;
