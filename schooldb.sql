/*DROP DATABASE IF EXISTS School_DB;

-- CREATE DATABASE
CREATE DATABASE School_DB;

-- CONFIRM CREATION OF DATABASE
SHOW DATABASES;

-- TO CREATE TEACHERS TABLE
CREATE TABLE teachers (
    Teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR (50) NOT NULL,
    LastName VARCHAR (50) NOT NULL,
    Gender VARCHAR (25) NOT NULL,
    DOB DATE NOT NULL,
    Email VARCHAR (50) NOT NULL,
    Address VARCHAR (255) NOT NULL,
    Highest_Qualification VARCHAR (25) NOT NULL,
    Subject_id INT NOT NULL,
    Date_joined DATETIME NOT NULL DEFAULT NOW()
    );

-- TO CREATE THE STUDENTS TABLE
CREATE TABLE students(
   Student_id INT PRIMARY KEY AUTO_INCREMENT,
   FirstName VARCHAR (50) NOT NULL,
   LastName VARCHAR (50) NOT NULL,
   Gender VARCHAR (25) NOT NULL,
   DOB DATE NOT NULL,
   Class VARCHAR (25) NOT NULL,
   Address VARCHAR (225) NOT NULL,
   Guardian_Contact BIGINT
   );

-- TO CREATE THE SUBJECTS TABLE
DROP TABLE IF EXISTS subjects;

CREATE TABLE subjects(
    Subject_id INT PRIMARY KEY,
    Subject_Name VARCHAR (50) NOT NULL,
    Teacher_id INT NOT NULL,
    Hours_per_week DECIMAL (10,2) NOT NULL
    );

-- TO CREATE THE GRADES TABLE
DROP TABLE IF EXISTS grades;

CREATE TABLE grades(
    Grade_id INT PRIMARY KEY AUTO_INCREMENT,
    Student_id INT NOT NULL,
    Academic_Year VARCHAR (25) NOT NULL,
    Semester VARCHAR (25) NOT NULL,
    Subject_id INT NOT NULL,
    Subject_Name VARCHAR (50) NOT NULL,
    Score INT NOT NULL,
    Grade VARCHAR (5) NOT NULL,
    Remark VARCHAR (255) NOT NULL
    );

 -- INSERT VALUES TO STUDENTS TABLE
INSERT INTO students VALUES
  (DEFAULT, 'Eunice', 'Malachi', 'Female', '2014-12-06', 'Basic 4','55 dick tiger avenue',09154118974), 
  (DEFAULT, 'Samuel', 'Chukwu', 'Male', '2016-06-15', 'Basic 3', '11 ayomide close', 08154657821),
  (DEFAULT, 'Blessing','Chima', 'Female', '2015-12-11', 'Basic 4', '19 owo road', 08035699411), 
  (DEFAULT, 'Sunday', 'Joseph', 'Male', '2012-03-28', 'Basic 5', '24 dick tiger avenue',07064526690),
  (DEFAULT, 'Jude', 'Okeama', 'Male', '2015-05-10', 'Basic 3', '14 osasogie street', 0908864231);
  
-- INSERT VALUES TO TEACHERS TABLE
INSERT INTO teachers (Teacher_id, FirstName, LastName, Gender, DOB, Email, Address, Highest_Qualification, Subject_id, Date_joined) VALUES
(1112, 'annie', 'bosii', 'Female', '2014-12-06', 'annie@email.com', '1st park avenue', 'Basic 4', 11, '2010-01-01'),
(1113, 'hyline', 'kwambi', 'female', '2016-06-15', 'hyline@email.com', '11 limuru Road', 'Basic 3', 12, '2011-02-02'),
(1114, 'Sam', 'Koima', 'Male', '2015-12-11', 'sam@email.com', 'Masaai Road', 'Basic 4', 14, '2012-03-03'),
(1115, 'Sunday', 'Joseph', 'Male', '2012-03-28', 'sunday@email.com', 'kenyatta avenue', 'Basic 5', 13, '2013-04-04'),
(1116, 'Jude', 'Okeama', 'Male', '2015-05-10', 'jude@email.com', '14 osasogie street', 'Basic 3', 15, '2014-05-05');

-- INSERT VALUES TO SUBJECTS TABLE
INSERT INTO subjects(Subject_id, Subject_Name, Teacher_id, Hours_per_week) VALUES
  (11, 'Mathematics', 1, 2.5), 
  (12, 'English ', 2, 4.5), 
  (13, 'Science', 4, 3.5), 
  (14, 'Kiswahili', 4, 3.5),
  (15, 'Social Studies', 5, 3.5);
  
-- INSERT VALUES TO GRADES TABLE
INSERT INTO grades VALUES
(1, 1, '2021/2022', 'Second', 3, 'Science', 68, 'B', 'Good'), 
(DEFAULT, 2, '2021/2022', 'First', 1, 'Mathematics', 55, 'C', 'Satisfactory'), 
(DEFAULT, 2, '2021/2022', 'Third', 5, 'Computer', 78, 'A', 'Excellent'), 
(4, 3, '2022/2023', 'Second', 2, 'English Language', 65, 'B', 'Fair'), 
(5, 4, '2022/2023', 'Third', 4, 'Social Studies', 80, 'A', 'Excellent');

-- TO ENSURE THEY WERE INSERTED
SELECT * FROM students;
SELECT * FROM teachers;
SELECT * FROM grades;
SELECT * FROM subjects;

 -- CREATE VIEW
CREATE OR REPLACE VIEW student_grades AS 
SELECT 
    s.student_id AS Student_ID,
    CONCAT(s.firstname, ' ', s.lastname) AS Student_Name,
    s.gender AS Gender,
    s.class AS Class,
    g.academic_year AS Academic_Year,
    g.semester AS Semester, -- Added missing comma
    g.subject_name AS Subject_name,
    g.score AS Score,
    g.grade AS Grade,
    g.remark AS Remark
FROM 
    students s 
JOIN 
    grades g ON s.student_id = g.student_id
ORDER BY 
    Class, Academic_Year, Semester, Subject_id, Grade DESC, Student_Name;


-- CONFIRM THE CREATED VIEW
SELECT * FROM student_grades;

DROP PROCEDURE IF EXISTS upload_grade;

-- CREATE VIEW
DELIMITER $$
CREATE PROCEDURE upload_grade(
  IN p_Grade_id INT,   
*/
USE School_DB;
 
-- TO SEE LIST OF PRIVILEGES
SHOW PRIVILEGES;

-- TO CREATE BOTH USERS
CREATE USER 'school_admin'@'localhost' IDENTIFIED BY 'school_admin';
CREATE USER 'teacher'@'localhost' IDENTIFIED BY 'teacher';
FLUSH PRIVILEGES;

-- TO GRANT USERS ACCESS AND PRIVILEGES
-- FOR ADMIN
GRANT ALL PRIVILEGES ON school_db.* TO 'school_admin'@'localhost';
GRANT SELECT, UPDATE, DELETE ON school_db.grades TO 'teacher'@'localhost';
GRANT EXECUTE ON PROCEDURE school_db.upload_grade TO 'teacher'@'localhost';
FLUSH PRIVILEGES;

-- TO CHECK FOR ACCURACY
SHOW GRANTS FOR 'school_admin'@'localhost';
SHOW GRANTS FOR 'teacher'@'localhost';

  
  
  
  
  IN p_Student_id INT,
  IN p_Academic_Year VARCHAR(25),
  IN p_Semester VARCHAR(25),
  IN p_Subject_id INT,
  IN p_Subject_Name VARCHAR(50),
  IN p_Score INT,
  IN p_Grade VARCHAR (5),
  IN p_Remark VARCHAR (255))
BEGIN
INSERT INTO grades(
  Grade_id, Student_id, Academic_year, Semester, Subject_id, Subject_name, Score, Grade, Remark)
VALUES(
p_Grade_id, p_Student_id, p_academic_year, p_semester, p_subject_id,p_subject_name, p_score, p_grade, p_remark);
END $$
DELIMITER ;

-- MAKING USE OF THE STORED PROCEDURE
CALL upload_grade(6, 1, '2021/2022', 'Second', 1, 'Mathematics', 45,'D', 'You can do better');
SELECT * FROM grades;

