SELECT Name, Position, Department
FROM FacultyMember;
--Этот запрос выведет имена преподавателей, их должности и кафедры.

SELECT C.Name AS CourseName
FROM Course C
JOIN Curriculum_Courses CC ON C.CourseID = CC.CourseID
JOIN Curriculum CU ON CC.CurriculumID = CU.CurriculumID
WHERE CU.Program = 'Информатика' AND CU.AcademicYear = '2024-2025';
--Этот запрос выбирает все курсы, которые входят в учебный план программы Информатика на учебный год 2024-2025.

SELECT S.Date, S.Time, C.Name AS CourseName, S.Room
FROM Schedule S
JOIN FacultyMember FM ON S.FacultyMemberID = FM.FacultyMemberID
JOIN Course C ON S.CourseID = C.CourseID
WHERE FM.Name = 'Иванов И.И.';
--Этот запрос выводит все занятия для преподавателя Иванов И.И. (с указанием даты, времени, курса и аудитории).

SELECT Name, GPA
FROM Student
WHERE Program = 'Информатика' AND GPA > 4.0;
--Этот запрос выберет студентов, обучающихся по программе Информатика и имеющих средний балл выше 4.0.

SELECT FM.Name, COUNT(CC.CourseID) AS CourseCount
FROM FacultyMember FM
LEFT JOIN Curriculum C ON FM.FacultyMemberID = C.FacultyMemberID
LEFT JOIN Curriculum_Courses CC ON C.CurriculumID = CC.CurriculumID
GROUP BY FM.Name;
--Этот запрос покажет, сколько курсов преподает каждый преподаватель, даже если преподаватель не ведет курсы (будет показано "0").

SELECT DISTINCT FM.Name
FROM FacultyMember FM
JOIN Course C ON FM.FacultyMemberID = C.FacultyMemberID
WHERE C.Semester = 1;
--Этот запрос выбирает преподавателей, которые ведут курсы в первом семестре.


--ОКОННЫЕ ЗАПРОСЫ--
SELECT Name, Program, GPA,
       RANK() OVER (PARTITION BY Program ORDER BY GPA DESC) AS Rank
FROM Student;
--Этот запрос использует оконную функцию RANK(), чтобы присвоить каждому студенту ранг в зависимости от их среднего балла (GPA), внутри каждой программы (Program).

SELECT Year, Name, GPA,
       SUM(GPA) OVER (PARTITION BY Year) AS TotalGPA
FROM Student;
--Этот запрос использует оконную функцию SUM(), чтобы вычислить сумму всех средних баллов (GPA) для студентов внутри каждого года обучения.

SELECT FM.Name AS FacultyName, C.Name AS CourseName,
       ROW_NUMBER() OVER (PARTITION BY FM.Name ORDER BY C.Name) AS CourseNumber
FROM FacultyMember FM
JOIN Course C ON FM.FacultyMemberID = C.FacultyMemberID;
--Этот запрос использует оконную функцию ROW_NUMBER(), чтобы нумеровать курсы, которые преподает каждый преподаватель, в рамках каждого курса



--ЗАПРОСЫ С ПОДЗАПРОСАМИ--
SELECT Name, Program, GPA
FROM Student
WHERE GPA > (
    SELECT AVG(GPA)
    FROM Student S2
    WHERE S2.Program = Student.Program
);
--Этот запрос использует подзапрос для вычисления среднего GPA для каждой программы и затем выбирает студентов, чьи GPA выше этого значения.

SELECT Name
FROM Course
WHERE FacultyMemberID = (
    SELECT FacultyMemberID
    FROM (SELECT FacultyMemberID, COUNT(*) AS CourseCount
          FROM Course
          GROUP BY FacultyMemberID
          ORDER BY CourseCount DESC
          LIMIT 1) AS TopFaculty
);
--Этот запрос сначала использует подзапрос для получения преподавателя с максимальным количеством курсов, а затем извлекает курсы этого преподавателя.

SELECT Name
FROM Student
WHERE StudentID IN (
    SELECT DISTINCT S.StudentID
    FROM Student S
    JOIN Schedule Sch ON S.StudentID = Sch.StudentID
    WHERE Sch.Room = '101'
);
--Этот запрос использует подзапрос для выбора студентов, которые посещают курсы в аудитории "101".



--ЗАПРОСЫ С МАТЕРИАЛИЗАЦИЕЙ--
CREATE MATERIALIZED VIEW AvgGPAByProgram AS
SELECT Program, AVG(GPA) AS AvgGPA
FROM Student
GROUP BY Program;

SELECT Program, AvgGPA
FROM AvgGPAByProgram
WHERE AvgGPA > 4.0;
--Этот запрос извлекает программы, где средний GPA больше 4.0 из уже вычисленного и сохраненного в AvgGPAByProgram материала.

CREATE MATERIALIZED VIEW CourseEnrollment AS
SELECT C.CourseID, C.Name AS CourseName, COUNT(S.StudentID) AS EnrollmentCount
FROM Course C
LEFT JOIN Schedule Sch ON C.CourseID = Sch.CourseID
LEFT JOIN Student S ON Sch.StudentID = S.StudentID
GROUP BY C.CourseID, C.Name;

SELECT CourseName, EnrollmentCount
FROM CourseEnrollment
WHERE EnrollmentCount > 50;
--Этот запрос выбирает курсы, на которые записано больше 50 студентов, из материализованного представления CourseEnrollment.


