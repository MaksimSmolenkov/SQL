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
