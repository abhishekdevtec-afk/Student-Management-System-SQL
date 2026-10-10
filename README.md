# Student-Management-System-SQL
A MySQL-based Student Management System demonstrating relational database design, joins, aggregate queries, marks, and attendance.

## Project features
- Relational tables: `Student`, `Course`, `Enrollment`, `Marks`, and `Attendance`
- Primary keys and foreign key relationships
- Sample records for testing
- SQL queries for joins, counts, averages, filtering, and attendance summaries
- ER diagram written in Mermaid syntax

## Requirements
- MySQL Server 8.0 or compatible
- MySQL Workbench (recommended) or another MySQL client

## How to run the project
1. Install MySQL Server and MySQL Workbench if you do not already have them.
2. Open MySQL Workbench and connect to your local MySQL server.
3. Choose **File → Open SQL Script** and open `student_management.sql` from this project folder.
4. Click the lightning-bolt **Execute** button to run the script.
5. The script creates the `student_management` database, tables, sample data, and example queries.
6. To rerun from scratch, execute the script again; it drops and recreates the project database.

> Warning: The script includes `DROP DATABASE IF EXISTS student_management;`. Do not use that line on a database containing data you need to keep.

## Files
- `student_management.sql` — creates the database, tables, sample data, and runs example queries
- `queries.sql` — extra useful SQL queries to try separately
- `ER_Diagram.md` — ER diagram in Mermaid format
- `screenshots/README.md` — suggestions for screenshots to add to your GitHub repository

## Database relationships
- One student can have many enrollments.
- One course can have many enrollments.
- Each enrollment can have a marks record.
- Each enrollment can have many attendance records.

## Example questions answered by the queries
- Which students are enrolled in which courses?
- What is the average mark for each course?
- Which students scored 80 or more?
- How many students are enrolled in each course?
- What is each student's attendance percentage?

