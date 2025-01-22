CREATE DATABASE UniversityDB;
USE UniversityDB;
CREATE TABLE FacultyMember (
    FacultyMemberID INT PRIMARY KEY AUTO_INCREMENT, 
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    Department VARCHAR(100),
    ContactInfo VARCHAR(255),
    EmploymentStatus VARCHAR(50) CHECK (EmploymentStatus IN ('Работает', 'На пенсии', 'Уволен'))
);


CREATE TABLE Course (
    CourseID INT PRIMARY KEY AUTO_INCREMENT, 
    Name VARCHAR(100) NOT NULL,
    Semester INT CHECK (Semester BETWEEN 1 AND 8),
    Description TEXT
);

CREATE TABLE Curriculum (
    CurriculumID INT PRIMARY KEY AUTO_INCREMENT, 
    FacultyMemberID INT,
    AcademicYear VARCHAR(9) NOT NULL, 
    Program VARCHAR(100) NOT NULL,
    FOREIGN KEY (FacultyMemberID) REFERENCES FacultyMember(FacultyMemberID) ON DELETE SET NULL
);


CREATE TABLE Curriculum_Courses (
    CurriculumID INT,
    CourseID INT,
    PRIMARY KEY (CurriculumID, CourseID),
    FOREIGN KEY (CurriculumID) REFERENCES Curriculum(CurriculumID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE
);


CREATE TABLE Schedule (
    ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
    FacultyMemberID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Room VARCHAR(10),
    CourseID INT NOT NULL,
    FOREIGN KEY (FacultyMemberID) REFERENCES FacultyMember(FacultyMemberID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Program VARCHAR(100) NOT NULL,
    Year INT CHECK (Year BETWEEN 1 AND 6),
    GPA DECIMAL(3,2) CHECK (GPA BETWEEN 0 AND 5),
    Status VARCHAR(50) CHECK (Status IN ('Активный', 'Отчисленный', 'Выпустился'))
);
