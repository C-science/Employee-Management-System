SELECT * FROM employeedatabase.training_and_development;
USE employeedatabase;

	/*Creation and importing data into Table*/
/*I created the tables with the use of the Table Data Import Wizard*/

-- Check for completeness of each table
SELECT COUNT(*) FROM employee_data;
SELECT COUNT(*) FROM employee_engagement_survey;
SELECT COUNT(*) FROM recruitment_data;
SELECT COUNT(*) FROM training_and_development;

		/* THE PURPOSE OF EACH TABLE*/
-- The Employee data Table provides details about each employee- name, employment date, exit date, and so on
-- The Employee Engagement survey reveals if employees are satisfied and find balance in their work life.
-- The recruitment table helps HR to track the status of applicants
-- The Training & Development table helps the HR department to monitor if required training has been 
-- given to all employees. It also monitors the outcome and cost of training each employee.

 -- Data Dictionary is summarized in an Excel file

-- PHASE2
		/* TABLE RELATIONSHIP */
/* The recruitment_data table gives details of all applicant to the company with the primary key set as 'Applicant ID'
with which it can connect to other tables
The Employee table then show details of all staff onboarded to the company. It unique identification column
 is the EmpID which serves as a foreign key to other tables
The Employee engagement survey data connects to other table through the EmployeeID column
And lastly, the training and development table connects to other tables using the EmployeeID column.
In summary the tables are connected using their ID columns */

		/* CHECK FOR NULL VALUE */
SELECT * FROM employee_data
WHERE EmployeeID IS NULL
	OR FirstName IS NULL
	OR LastName IS NULL
	OR StartDate IS NULL
	OR ExitDate IS NULL
	OR Title IS NULL
	OR Supervisor IS NULL
	OR ADEmail IS NULL
	OR BusinessUnit IS NULL
	OR EmployeeStatus IS NULL
	OR EmployeeType IS NULL
	OR PayZone IS NULL
	OR EmployeeClassificationType IS NULL
	OR TerminationType IS NULL
	OR TerminationDescription IS NULL
	OR DepartmentType IS NULL
	OR Division IS NULL
	OR DOB IS NULL
	OR State IS NULL
	OR JobFunctionDescription IS NULL
	OR GenderCode IS NULL
	OR LocationCode IS NULL
	OR RaceDesc IS NULL
	OR MaritalDesc IS NULL
	OR `Performance Score` IS NULL
	OR `Current Employee Rating` IS NULL;
-- Result of Null Value check is Zero I.e No Null Value in the records    


 SELECT * FROM employee_engagement_survey
 WHERE EmployeeID IS NULL
	OR `Survey Date` IS NULL
    OR `Engagement Score` IS NULL
    OR `Satisfaction Score` IS NULL
    OR `Work-life Balance Score` IS NULL;
-- Result of Null Value check is Zero I.e No Null Value in the records
    
    
SELECT * FROM recruitment_data
WHERE ApplicantID IS NULL
	OR `Application Date` IS NULL
	OR `First Name` IS NULL
	OR `Last Name` IS NULL
	OR Gender IS NULL
	OR `Date of Birth` IS NULL
	OR `Phone Number` IS NULL
	OR Email IS NULL
	OR Address IS NULL
	OR City IS NULL
	OR State IS NULL
	OR `Zip Code` IS NULL
	OR Country IS NULL
	OR `Education Level` IS NULL
	OR `Years of Experience` IS NULL
	OR `Desired Salary` IS NULL
	OR `Job Title` IS NULL
	OR Status IS NULL;
-- Result of Null Value check is Zero I.e No Null Value in the records    


SELECT * FROM training_and_development
WHERE EmployeeID IS NULL
	OR `Training Date` IS NULL
	OR `Training Program Name` IS NULL
	OR `Training Type` IS NULL
	OR `Training Outcome` IS NULL
	OR Location IS NULL
	OR Trainer IS NULL
	OR `Training Duration(Days)` IS NULL
	OR `Training Cost` IS NULL;
 -- Result of Null Value check is Zero I.e No Null Value in the records
 
			-- PHASE 3 FOUNDATIONAL ANALYSIS TASKS
 -- TOTAL EMPLOYEE COUNT BY DEPARTMENT
 SELECT DepartmentType, COUNT(*) AS TotalEmployee FROM employee_data
 GROUP BY DepartmentType
 ORDER BY COUNT(*) ASC;
 -- Result: All employee belong to one of six department. Production has the highest number of 
 -- employee (2,020 employee) while the Executive Office only have 24 staffs.
 
 -- EMPLOYEE DISTRIBUTION BY GENDER
 SELECT Gendercode AS Gender, COUNT(*) AS TotalEmployee FROM employee_data
 GROUP BY Gender;
 -- Result: There are more female employee than Male.
 
 -- AVERAGE SALARY BY DEPARTMENT
 SELECT ED.DepartmentType AS Department,
 AVG(RD.`Desired Salary`) AS Average_salary
 FROM Employee_data ED
 JOIN recruitment_data RD ON ED.EmployeeID = RD.ApplicantID
 GROUP BY ED.DepartmentType
 ORDER BY Average_salary;
 -- The department with the lowest average salary is Executive Office while the Admin Office
 -- department are paid the most on average.
 
 -- HIRING TREND BY YEAR
SELECT `Application Date` AS YearofApplication, RD.Status
FROM recruitment_data RD
WHERE RD.Status LIKE 'Offered';

				-- PHASE 4 INTERMEDIATE ANALYTICAL QUERIES
-- WHICH DAPERTMENT HAVE THE HIGHEST AVERAGE SALARY
SELECT ED.DepartmentType AS Department,
	ROUND(AVG(RD.`Desired Salary`), 2) AS Average_Salary
FROM Employee_data ED
INNER JOIN Recruitment_data RD ON ED.EmployeeID = RD.ApplicantID
GROUP BY Department
ORDER BY Average_Salary DESC LIMIT 1;

-- WHICH EMPLOYEE EARN THE HIGHEST SALARIES
SELECT ED.FirstName, ED.LastName, 
RD.`Desired Salary` AS Salary
FROM Employee_data ED
INNER JOIN Recruitment_data RD ON ED.EmployeeID = RD.ApplicantID
GROUP BY ED.FirstName, ED.LastName, Salary
ORDER BY Salary DESC LIMIT 1;


-- HOW LONG TERMIATED EMPLOYEES STAYED IN THE ORGANIZATION
SELECT Firstname, lastname, (datediff(Exitdate, Startdate)) AS Days_of_active_service
FROM Employee_data
WHERE StartDate IS NOT NULL AND Exitdate IS NOT NULL
AND (datediff(Exitdate, Startdate)) > 0;

-- WHICH BUSINESS UNIT HIRED THE MOST RECENTLY
SELECT StartDate AS Hire_date, BusinessUnit
FROM Employee_data
ORDER BY Hire_date DESC LIMIT 2;
-- BPC & SVG has the same recent hire date

				-- PHASE 5 MULTI TABLE ANALYSIS
-- JOIN EMPLOYEE DATA WITH RECRUITMENT DATA
SELECT *
FROM Employee_data ED
INNER JOIN recruitment_data RD ON ED.employeeID = RD.applicantID;
 -- The Inner join is used to show all columns in both tables with matching employeeID
 
 -- JOIN EMPLOYEE DATA WITH TRAINING DATA
 SELECT *
 FROM Employee_data ED
 INNER JOIN training_and_development TD ON ED.employeeID = TD.employeeID;
 -- The Inner join is used to show all columns in both tables with matching employeeID
 
 -- TRACK TRAINING PARTICIPATION ACROSS DEPARTMENTS
 SELECT DepartmentType, COUNT(*) AS Employee_in_training
 FROM employee_data ED
 JOIN training_and_development TD on ED.EmployeeID = TD.EmployeeID
 GROUP BY DepartmentType
 ORDER BY Employee_in_training;
 -- All employee in each department has participated in the training.
 
				-- PHASE 6 WINDOW FUNCTION APPLICATION
                -- PHASE 7 DATE AND CONDITIONAL LOGIC
	-- EMPLOYEE TENURE USING HIRING DATES
SELECT YEAR(startdate), Count(*) FROM employee_data AS TENURE
GROUP BY YEAR(startdate)
ORDER BY COUNT(*) ASC;
	-- More number of employee were hired in recent years. This can be due to high employee turnover in the
    -- production department. Over 60% of the workforce were hired in the last 3 years.

	-- CATEGORY OF EMPLOYEES BY TENURE LENGTH
SELECT EmployeeID, firstname, lastname, startdate, exitdate, datediff(exitdate, startdate) 
AS DaysInService,
CASE
	WHEN datediff(exitdate, startdate) < 365 THEN 'ShortTerm'
	WHEN datediff(exitdate, startdate) < 1095 THEN 'MidTerm'
    ELSE 'LongTerm' END
    AS EmployeeCategory
FROM employee_data;

	-- IDENTIFY ACTIVE VERSUS TERMINATED STAFF
SELECT EmployeeID, Firstname, lastname, startdate, exitdate,
CASE
	WHEN exitdate < '1000-01-01' THEN 'Active'
    ELSE 'Terminated' END
    AS EmployeeStatus
    FROM Employee_data;
    
				-- PHASE 8 REPORTING QUETIONS
	-- WHO ARE THE TOP 50 HIGHEST PAID EMPLOYEES
SELECT ApplicantID, `First name`, `Last name`, `Desired Salary`
FROM recruitment_data
ORDER BY `Desired Salary` DESC LIMIT 50;
 -- Most of the highest paid staff are in the software engineering department

    -- WHICH DEPARTMENT EXPERIENCE HIGHER EMPLOYEE EXITS
SELECT departmentType, COUNT(*) AS Exits FROM employee_data
WHERE exitdate > '1000-01-01'
GROUP BY departmentType
ORDER BY COUNT(*) DESC;
-- Production department having the higest number of exits can be due to the type of contract signed
-- with staff. This is not unlikely with production department of companies

	-- WHICH DEPARTMENT RECEIVE MORE TRAINING INVESTMENT
SELECT ED.DepartmentType, ROUND(SUM(TD.`Training Cost`), 2) AS CostofTraining
FROM employee_data ED
JOIN training_and_development TD ON ED.EmployeeID = TD.EmployeeID
GROUP BY ED.DepartmentType
ORDER BY Costoftraining DESC;