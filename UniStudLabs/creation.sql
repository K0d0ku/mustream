-- SELECT current_database();
-- CREATE SCHEMA UniStud;

CREATE TABLE UniStud.Student (
    RollNo SERIAL PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Current_Year INT CHECK (Current_Year BETWEEN 1 AND 5) NOT NULL
);

CREATE TABLE UniStud.Course (
    Course_Code VARCHAR(10) PRIMARY KEY,
    Course_Name VARCHAR(100) NOT NULL
);

CREATE TABLE UniStud.Teacher (
    Teacher_ID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Department VARCHAR(100) NOT NULL
);

CREATE TABLE UniStud.Course_Teacher (
    Course_Code VARCHAR(10) REFERENCES UniStud.Course(Course_Code) ON DELETE CASCADE,
    Teacher_ID INT REFERENCES UniStud.Teacher(Teacher_ID) ON DELETE CASCADE,
    PRIMARY KEY (Course_Code, Teacher_ID)
);

-- CREATE TABLE UniStud.Student_Course (
--     RollNo INT REFERENCES UniStud.Student(RollNo) ON DELETE CASCADE,
--     Course_Code VARCHAR(10) REFERENCES UniStud.Course(Course_Code) ON DELETE CASCADE,
--     System_Used VARCHAR(50) NOT NULL,
--     Total_Hrs INT CHECK (Total_Hrs > 0) NOT NULL,
--     PRIMARY KEY (RollNo, Course_Code)
-- );
-- DROP TABLE UniStud.student_course;
CREATE TABLE UniStud.Student_Course (
    RollNo INT REFERENCES UniStud.Student(RollNo) ON DELETE CASCADE,
    Course_Code VARCHAR(10) REFERENCES UniStud.Course(Course_Code) ON DELETE CASCADE,
    System_ID INT REFERENCES UniStud.Systems(System_ID) ON DELETE SET NULL,
    Total_Hrs INT CHECK (Total_Hrs > 0) NOT NULL,
    PRIMARY KEY (RollNo, Course_Code)
);


-- CREATE TABLE UniStud.Systems (
--     System_Used VARCHAR(50) PRIMARY KEY,
--     Hourly_Rate DECIMAL(10,2) CHECK (Hourly_Rate > 0) NOT NULL
-- );
-- DROP TABLE UniStud.systems;
CREATE TABLE UniStud.Systems (
    System_ID SERIAL PRIMARY KEY,
    System_Used VARCHAR(50) UNIQUE NOT NULL,
    Hourly_Rate DECIMAL(10,2) CHECK (Hourly_Rate > 0) NOT NULL
);

CREATE TABLE UniStud.Student_Group (
    Group_ID SERIAL PRIMARY KEY,
    Group_Name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE UniStud.Advisor (
    Advisor_ID SERIAL PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Office_Location VARCHAR(100) NOT NULL
);

CREATE TABLE UniStud.Student_Group_Mapping (
    RollNo INT REFERENCES UniStud.Student(RollNo) ON DELETE CASCADE,
    Group_ID INT REFERENCES UniStud.Student_Group(Group_ID) ON DELETE CASCADE,
    PRIMARY KEY (RollNo, Group_ID)
);

CREATE TABLE UniStud.Group_Advisor (
    Group_ID INT REFERENCES UniStud.Student_Group(Group_ID) ON DELETE CASCADE,
    Advisor_ID INT REFERENCES UniStud.Advisor(Advisor_ID) ON DELETE CASCADE,
    PRIMARY KEY (Group_ID, Advisor_ID)
);

-- procedure
-- create a viwe to store all info and upon calling the procedure it will show only the desired info
CREATE OR REPLACE VIEW UniStud.student_full_info_view AS
SELECT
    s.RollNo,
    s.First_Name,
    s.Last_Name,
    s.Current_Year,
    c.Course_Name,
    sys.System_Used,
    sc.Total_Hrs,
    sg.Group_Name,
    a.First_Name AS Advisor_First_Name,
    a.Last_Name AS Advisor_Last_Name
FROM UniStud.Student s
LEFT JOIN UniStud.Student_Course sc ON s.RollNo = sc.RollNo
LEFT JOIN UniStud.Course c ON sc.Course_Code = c.Course_Code
LEFT JOIN UniStud.Systems sys ON sc.System_ID = sys.System_ID
LEFT JOIN UniStud.Student_Group_Mapping sgm ON s.RollNo = sgm.RollNo
LEFT JOIN UniStud.Student_Group sg ON sgm.Group_ID = sg.Group_ID
LEFT JOIN UniStud.Group_Advisor ga ON sg.Group_ID = ga.Group_ID
LEFT JOIN UniStud.Advisor a ON ga.Advisor_ID = a.Advisor_ID;

CREATE OR REPLACE PROCEDURE UniStud.get_student_info_proc(student_rollno_param INT)
LANGUAGE plpgsql
AS $$
DECLARE
    record_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO record_count
    FROM UniStud.student_full_info_view
    WHERE RollNo = student_rollno_param;
    -- raise a notice about the count
    IF record_count = 0 THEN
        RAISE NOTICE 'No information found for student with RollNo: %', student_rollno_param;
    ELSE
        RAISE NOTICE 'Found % records for student RollNo: %', record_count, student_rollno_param;

        -- display the actual data (raises a notice with the instruction)
        RAISE NOTICE 'Run: SELECT * FROM UniStud.student_full_info_view WHERE RollNo = %;', student_rollno_param;
    END IF;
END;
$$;

-- call for procedure
CALL UniStud.get_student_info_proc(1);
SELECT * FROM UniStud.student_full_info_view WHERE RollNo = 1;
