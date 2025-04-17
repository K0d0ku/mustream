-- Get all students and their courses
SELECT
    s.First_Name || ' ' || s.Last_Name AS Student_Name,
    c.Course_Name,
    sys.System_Used,
    sc.Total_Hrs
FROM
    UniStud.Student s
JOIN
    UniStud.Student_Course sc ON s.RollNo = sc.RollNo
JOIN
    UniStud.Course c ON sc.Course_Code = c.Course_Code
LEFT JOIN
    UniStud.Systems sys ON sc.System_ID = sys.System_ID;

-- Find all courses a student is enrolled in
SELECT
    c.Course_Name
FROM
    UniStud.Student_Course sc
JOIN
    UniStud.Course c ON sc.Course_Code = c.Course_Code
WHERE
    sc.RollNo = 1;

-- Count students per course
SELECT
    c.Course_Name,
    COUNT(sc.RollNo) AS Student_Count
FROM
    UniStud.Student_Course sc
JOIN
    UniStud.Course c ON sc.Course_Code = c.Course_Code
GROUP BY
    c.Course_Name;

-- Find a student’s group and advisor
SELECT
    s.First_Name || ' ' || s.Last_Name AS Student_Name,
    g.Group_Name,
    a.First_Name || ' ' || a.Last_Name AS Advisor_Name
FROM
    UniStud.Student s
JOIN
    UniStud.Student_Group_Mapping sg ON s.RollNo = sg.RollNo
JOIN
    UniStud.Student_Group g ON sg.Group_ID = g.Group_ID
JOIN
    UniStud.Group_Advisor ga ON g.Group_ID = ga.Group_ID
JOIN
    UniStud.Advisor a ON ga.Advisor_ID = a.Advisor_ID
WHERE
    s.RollNo = 1;
