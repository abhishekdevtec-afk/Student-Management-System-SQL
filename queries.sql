-- Extra queries: run after selecting the student_management database.
USE student_management;

-- 1. Search for a student by first name
SELECT * FROM Student
WHERE first_name LIKE 'A%';

-- 2. Show courses with at least two enrollments
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM Course c
LEFT JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) >= 2;

-- 3. Highest total mark for each course
SELECT c.course_name, MAX(m.internal_marks + m.exam_marks) AS highest_total
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
JOIN Marks m ON e.enrollment_id = m.enrollment_id
GROUP BY c.course_id, c.course_name;

-- 4. Count attendance statuses
SELECT status, COUNT(*) AS number_of_records
FROM Attendance
GROUP BY status
ORDER BY number_of_records DESC;

-- 5. Student count
SELECT COUNT(*) AS total_students FROM Student;

-- 6. Students who have at least one absent attendance record
SELECT DISTINCT s.student_id, s.first_name, s.last_name
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Attendance a ON e.enrollment_id = a.enrollment_id
WHERE a.status = 'Absent';

-- 7. Update a student's phone number (example)
-- Uncomment and change the ID/number before running:
-- UPDATE Student SET phone = '9111111111' WHERE student_id = 1;

-- 8. Delete an enrollment (example; cascades to its marks and attendance)
-- Uncomment only if you want to delete enrollment ID 8:
-- DELETE FROM Enrollment WHERE enrollment_id = 8;
