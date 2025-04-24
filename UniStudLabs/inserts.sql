INSERT INTO UniStud.Student (First_Name, Last_Name, Current_Year)
VALUES
  ('John', 'Doe', 3),
  ('Alice', 'Smith', 2),
  ('Bob', 'Jones', 1),
  ('Charlie', 'Brown', 4),
  ('David', 'Wilson', 5),
  ('Emma', 'White', 3),
  ('Fay', 'Miller', 1),
  ('Grace', 'Taylor', 2),
  ('Henry', 'Anderson', 4),
  ('Isla', 'Thomas', 5),
  ('Jack', 'Martinez', 3),
  ('Kara', 'Robinson', 2),
  ('Liam', 'Clark', 1),
  ('Mona', 'Lee', 4),
  ('Nina', 'King', 5);

INSERT INTO UniStud.Course (Course_Code, Course_Name)
VALUES
  ('CS101', 'Introduction to Computer Science'),
  ('CS102', 'Data Structures and Algorithms'),
  ('CS103', 'Database Systems'),
  ('CS104', 'Operating Systems'),
  ('CS105', 'Computer Networks'),
  ('CS106', 'Web Development'),
  ('CS107', 'Software Engineering'),
  ('CS108', 'Artificial Intelligence'),
  ('CS109', 'Machine Learning'),
  ('CS110', 'Computer Graphics'),
  ('CS111', 'Computer Security'),
  ('CS112', 'Data Science'),
  ('CS113', 'Cloud Computing'),
  ('CS114', 'Mobile App Development'),
  ('CS115', 'Game Development');

-- INSERT INTO UniStud.Teacher (First_Name, Last_Name, Department)
-- VALUES
--   ('Dr. Alice', 'Green', 'Computer Science'),
--   ('Dr. Bob', 'Williams', 'Mathematics'),
--   ('Prof. Carol', 'Moore', 'Engineering'),
--   ('Dr. David', 'Taylor', 'Physics'),
--   ('Prof. Emma', 'Lee', 'Computer Science'),
--   ('Dr. Fay', 'Garcia', 'Mathematics'),
--   ('Dr. Grace', 'Harris', 'Engineering'),
--   ('Prof. Henry', 'Clark', 'Computer Science');

INSERT INTO UniStud.Course_Teacher (Course_Code, Teacher_ID)
VALUES
  ('CS101', 1),
  ('CS102', 2),
  ('CS103', 3),
  ('CS104', 4),
  ('CS105', 5),
  ('CS106', 6),
  ('CS107', 7),
  ('CS108', 8),
  ('CS109', 1),
  ('CS110', 2),
  ('CS111', 3),
  ('CS112', 4),
  ('CS113', 5),
  ('CS114', 6),
  ('CS115', 7);

INSERT INTO UniStud.Systems (System_Used, Hourly_Rate)
VALUES
  ('Linux', 20.00),
  ('Windows', 15.00),
  ('MacOS', 30.00);

INSERT INTO UniStud.Student_Course (RollNo, Course_Code, System_ID, Total_Hrs)
VALUES
  (1, 'CS101', 1, 40),
  (1, 'CS102', 2, 35),
  (2, 'CS103', 3, 50),
  (3, 'CS104', 1, 30),
  (4, 'CS105', 2, 45),
  (5, 'CS106', 3, 50),
  (6, 'CS107', 1, 40),
  (7, 'CS108', 2, 60),
  (8, 'CS109', 3, 45),
  (9, 'CS110', 1, 50),
  (10, 'CS111', 2, 40),
  (11, 'CS112', 3, 35),
  (12, 'CS113', 1, 50),
  (13, 'CS114', 2, 30),
  (14, 'CS115', 3, 45);

INSERT INTO UniStud.Student_Group (Group_Name)
VALUES
  ('Group A'),
  ('Group B'),
  ('Group C'),
  ('Group D'),
  ('Group E');

INSERT INTO UniStud.Advisor (First_Name, Last_Name, Office_Location)
VALUES
  ('Dr. John', 'Adams', 'Building A, Room 101'),
  ('Prof. Sarah', 'Jones', 'Building B, Room 202'),
  ('Dr. Michael', 'Davis', 'Building C, Room 303');

INSERT INTO UniStud.Student_Group_Mapping (RollNo, Group_ID)
VALUES
  (1, 1),
  (2, 1),
  (3, 2),
  (4, 2),
  (5, 3),
  (6, 3),
  (7, 4),
  (8, 4),
  (9, 5),
  (10, 5),
  (11, 1),
  (12, 2),
  (13, 3),
  (14, 4),
  (15, 5);

INSERT INTO UniStud.Group_Advisor (Group_ID, Advisor_ID)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 1),
  (5, 2);


INSERT INTO UniStud.Course (Course_Code, Course_Name) VALUES
('CS101', 'Introduction to Computer Science'),
('MATH201', 'Calculus II'),
('BUS105', 'Principles of Management');

INSERT INTO UniStud.Course_Offering (Course_Code, Teacher_ID, Semester_ID, Room, Schedule) VALUES
('CS101', 1, 1, 'Room 101', 'Mon-Wed 10:00-11:30'),
('MATH201', 2, 1, 'Room 202', 'Tue-Thu 14:00-15:30'),
('BUS105', 3, 2, 'Room B1', 'Mon-Wed 12:00-13:30');

INSERT INTO UniStud.Evaluation (RollNo, Course_Code, Evaluation_Type, Score, Max_Score, Evaluation_Date) VALUES
(1, 'CS101', 'Assignment', 85, 100, '2024-02-15'),
(1, 'CS101', 'Midterm Exam', 78, 100, '2024-03-15'),
(1, 'CS101', 'Final Exam', 90, 100, '2024-05-10'),
(1, 'MATH201', 'Quiz', 18, 20, '2024-02-10'),
(1, 'MATH201', 'Final Exam', 82, 100, '2024-05-08');

INSERT INTO UniStud.Attendance (RollNo, Course_Code, Attendance_Date, Present) VALUES
(1, 'CS101', '2024-01-15', TRUE),
(1, 'CS101', '2024-01-17', FALSE),
(1, 'CS101', '2024-01-19', TRUE),
(1, 'MATH201', '2024-01-16', TRUE),
(1, 'MATH201', '2024-01-18', TRUE);



INSERT INTO UniStud.Department (Department_Name, Building_Name) VALUES
('Computer Science', 'Engineering Block A'),
('Mathematics', 'Science Building'),
('Physics', 'Lab Complex'),
('Literature', 'Arts Block'),
('Business Administration', 'Commerce Wing');

-- Let's pretend Teacher_IDs 1 to 3 exist
UPDATE UniStud.Teacher SET Department_ID = 1 WHERE Teacher_ID = 1; -- CS
UPDATE UniStud.Teacher SET Department_ID = 2 WHERE Teacher_ID = 2; -- Math
UPDATE UniStud.Teacher SET Department_ID = 5 WHERE Teacher_ID = 3; -- Biz Admin

INSERT INTO UniStud.Semester (Year, Term, Start_Date, End_Date) VALUES
(2024, 'Spring', '2024-01-10', '2024-05-15'),
(2024, 'Fall', '2024-08-20', '2024-12-15'),
(2025, 'Spring', '2025-01-15', '2025-05-20');

-- Course: CS101, Teacher: 1, Semester: Spring 2024
INSERT INTO UniStud.Course_Offering (Course_Code, Teacher_ID, Semester_ID, Room, Schedule) VALUES
('CS101', 1, 1, 'Room 101', 'Mon-Wed 10:00-11:30'),
('MATH201', 2, 1, 'Room 202', 'Tue-Thu 14:00-15:30'),
('BUS105', 3, 2, 'Room B1', 'Mon-Wed 12:00-13:30');

INSERT INTO UniStud.Evaluation (RollNo, Course_Code, Evaluation_Type, Score, Max_Score, Evaluation_Date) VALUES
(1, 'CS101', 'Assignment', 85, 100, '2024-02-15'),
(1, 'CS101', 'Midterm Exam', 78, 100, '2024-03-15'),
(1, 'CS101', 'Final Exam', 90, 100, '2024-05-10'),
(1, 'MATH201', 'Quiz', 18, 20, '2024-02-10'),
(1, 'MATH201', 'Final Exam', 82, 100, '2024-05-08');

INSERT INTO UniStud.Attendance (RollNo, Course_Code, Attendance_Date, Present) VALUES
(1, 'CS101', '2024-01-15', TRUE),
(1, 'CS101', '2024-01-17', FALSE),
(1, 'CS101', '2024-01-19', TRUE),
(1, 'MATH201', '2024-01-16', TRUE),
(1, 'MATH201', '2024-01-18', TRUE);
