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

INSERT INTO UniStud.Teacher (First_Name, Last_Name, Department)
VALUES
  ('Dr. Alice', 'Green', 'Computer Science'),
  ('Dr. Bob', 'Williams', 'Mathematics'),
  ('Prof. Carol', 'Moore', 'Engineering'),
  ('Dr. David', 'Taylor', 'Physics'),
  ('Prof. Emma', 'Lee', 'Computer Science'),
  ('Dr. Fay', 'Garcia', 'Mathematics'),
  ('Dr. Grace', 'Harris', 'Engineering'),
  ('Prof. Henry', 'Clark', 'Computer Science');

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
