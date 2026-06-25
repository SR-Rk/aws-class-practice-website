--Week 5

CREATE DATABASE Week5;

USE Week5;


CREATE TABLE Employee
(
EmployeeID INT PRIMARY KEY,
FullName VARCHAR(50),
Department VARCHAR(30),
Designation VARCHAR(30),
Salary DECIMAL(10,2),
JoiningDate DATE,
City VARCHAR(30)
);
INSERT INTO Employee VALUES
(101,'Ram Sharma','IT','Developer',65000,'2022-01-15','Kathmandu'),
(102,'Sita Karki','HR','Manager',75000,'2020-05-10','Pokhara'),
(103,'Hari Thapa','IT','Developer',60000,'2021-03-12','Kathmandu'),
(104,'Gita Rai','Finance','Accountant',55000,'2023-02-18','Biratnagar'),
(105,'Bikash Gurung','IT','Manager',90000,'2019-07-25','Pokhara'),
(106,'Nabin Shrestha','HR','Officer',45000,'2022-09-15','Kathmandu'),
(107,'Anita Lama','Finance','Manager',85000,'2018-11-05','Lalitpur'),
(108,'Roshan KC','Marketing','Executive',50000,'2021-12-01','Pokhara'),
(109,'Puja Basnet','Marketing','Manager',80000,'2020-08-20','Kathmandu'),
(110,'Kiran Adhikari','IT','Officer',48000,'2023-04-10','Biratnagar');




--Create the stored procedure:

--1. To display all employee records

CREATE PROCEDURE sp_ShowAllEmployees
AS
BEGIN
    SELECT * FROM Employee;
END;

EXEC sp_ShowAllEmployees;

--2. To display the record of employee accepting the employee ID

CREATE PROCEDURE sp_GetEmployeeByID
    @EmployeeID INT
AS
BEGIN
    SELECT * 
    FROM Employee
    WHERE EmployeeID = @EmployeeID;
END;

EXEC sp_GetEmployeeByID 101;

--3. That accepts a salary amount and displays employees earning more than that
--amount

CREATE PROCEDURE sp_SalaryGreaterThan
    @Salary DECIMAL(10,2)
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE Salary > @Salary;
END;

EXEC sp_SalaryGreaterThan 60000;

--4. To display total number of employees

CREATE PROCEDURE sp_TotalEmployees
AS
BEGIN
    SELECT COUNT(*) AS TotalEmployees
    FROM Employee;
END;

EXEC sp_TotalEmployees;

--5. That display employee ordered by department and salary in descending order

CREATE PROCEDURE sp_OrderByDeptSalary
AS
BEGIN
    SELECT *
    FROM Employee
    ORDER BY Department, Salary DESC;
END;

EXEC sp_OrderByDeptSalary;

--6. To display top 3 highest paid employees

CREATE PROCEDURE sp_Top3HighestPaid
AS
BEGIN
    SELECT TOP 3 *
    FROM Employee
    ORDER BY Salary DESC;
END;

EXEC sp_Top3HighestPaid;

--7. To display employee whose name contains ‘sh’

CREATE PROCEDURE sp_NameContainsSH
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE FullName LIKE '%sh%';
END;

EXEC sp_NameContainsSH;

--8. To display employee from IT and Finance Department

CREATE PROCEDURE sp_ITFinanceEmployees
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE Department IN ('IT','Finance');
END;

EXEC sp_ITFinanceEmployees;

--9. To display employee whose designation is not Manager

CREATE PROCEDURE sp_NotManager
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE Designation <> 'Manager';
END;

EXEC sp_NotManager;

--10. To display minimum and maximum salary

CREATE PROCEDURE sp_MinMaxSalary
AS
BEGIN
    SELECT 
        MIN(Salary) AS MinimumSalary,
        MAX(Salary) AS MaximumSalary
    FROM Employee;
END;

EXEC sp_MinMaxSalary;

--11. To display departments having more than 2 employees

CREATE PROCEDURE sp_DepartmentMoreThan2
AS
BEGIN
    SELECT Department,
           COUNT(*) AS TotalEmployees
    FROM Employee
    GROUP BY Department
    HAVING COUNT(*) > 2;
END;

EXEC sp_DepartmentMoreThan2;

--12. To display whether an employee belongs to IT department

CREATE PROCEDURE sp_CheckITDepartment
    @EmployeeID INT
AS
BEGIN
    IF EXISTS
    (
        SELECT *
        FROM Employee
        WHERE EmployeeID=@EmployeeID
        AND Department='IT'
    )
        PRINT 'Employee belongs to IT Department';
    ELSE
        PRINT 'Employee does not belong to IT Department';
END;

EXEC sp_CheckITDepartment 101;

--13. To insert an employee if EmployeeID does not exist and display all employees

CREATE PROCEDURE sp_InsertEmployee
    @EmployeeID INT,
    @FullName VARCHAR(50),
    @Department VARCHAR(30),
    @Designation VARCHAR(30),
    @Salary DECIMAL(10,2),
    @JoiningDate DATE,
    @City VARCHAR(30)
AS
BEGIN
    IF NOT EXISTS
    (
        SELECT *
        FROM Employee
        WHERE EmployeeID=@EmployeeID
    )
    BEGIN
        INSERT INTO Employee
        VALUES
        (
            @EmployeeID,
            @FullName,
            @Department,
            @Designation,
            @Salary,
            @JoiningDate,
            @City
        );

        PRINT 'Employee Inserted';
    END
    ELSE
        PRINT 'EmployeeID Already Exists';

    SELECT * FROM Employee;
END;


--14. To increase the salary of all employees by a given percentage

CREATE PROCEDURE sp_IncreaseSalary
    @Percentage DECIMAL(5,2)
AS
BEGIN
    UPDATE Employee
    SET Salary = Salary + (Salary * @Percentage / 100);

    SELECT * FROM Employee;
END;

EXEC sp_IncreaseSalary 10;

--15. To delete employee by EmployeeID

CREATE PROCEDURE sp_DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM Employee
    WHERE EmployeeID=@EmployeeID;
END;

EXEC sp_DeleteEmployee 110;

--16. That checks existence before deleting employee

CREATE PROCEDURE sp_CheckDeleteEmployee
    @EmployeeID INT
AS
BEGIN
    IF EXISTS
    (
        SELECT *
        FROM Employee
        WHERE EmployeeID=@EmployeeID
    )
    BEGIN
        DELETE FROM Employee
        WHERE EmployeeID=@EmployeeID;

        PRINT 'Employee Deleted';
    END
    ELSE
        PRINT 'Employee Not Found';
END;

EXEC sp_CheckDeleteEmployee 110;


--Scenario-Based Questions

--1. Employee Search System

CREATE PROCEDURE sp_FindEmployee
    @EmployeeID INT
AS
BEGIN
    IF EXISTS
    (
        SELECT *
        FROM Employee
        WHERE EmployeeID=@EmployeeID
    )
        SELECT *
        FROM Employee
        WHERE EmployeeID=@EmployeeID;
    ELSE
        PRINT 'Employee Not Found';
END;

EXEC sp_FindEmployee 101;


--2 New Employee Recruitment

CREATE PROCEDURE sp_RecruitEmployee
    @EmployeeID INT,
    @FullName VARCHAR(50),
    @Department VARCHAR(30),
    @Designation VARCHAR(30),
    @Salary DECIMAL(10,2),
    @JoiningDate DATE,
    @City VARCHAR(30)
AS
BEGIN
    IF EXISTS
    (
        SELECT *
        FROM Employee
        WHERE EmployeeID=@EmployeeID
    )
        PRINT 'EmployeeID Already Exists';
    ELSE
    BEGIN
        INSERT INTO Employee
        VALUES
        (
            @EmployeeID,
            @FullName,
            @Department,
            @Designation,
            @Salary,
            @JoiningDate,
            @City
        );

        PRINT 'Employee Added Successfully';
    END
END;


-- 3. Employee Bonus System

DROP PROCEDURE IF EXISTS sp_EmployeeBonus;
GO

CREATE PROCEDURE sp_EmployeeBonus
    @EmployeeID INT
AS
BEGIN
    DECLARE @Salary DECIMAL(10,2);
    DECLARE @Designation VARCHAR(30);
    DECLARE @Bonus DECIMAL(10,2);

    IF EXISTS
    (
        SELECT *
        FROM Employee
        WHERE EmployeeID = @EmployeeID
    )
    BEGIN
        SELECT
            @Salary = Salary,
            @Designation = Designation
        FROM Employee
        WHERE EmployeeID = @EmployeeID;

        IF @Designation = 'Manager'
            SET @Bonus = @Salary * 0.20;
        ELSE IF @Designation = 'Developer'
            SET @Bonus = @Salary * 0.15;
        ELSE
            SET @Bonus = @Salary * 0.10;

        SELECT
            EmployeeID,
            FullName,
            Designation,
            Salary,
            @Bonus AS BonusAmount
        FROM Employee
        WHERE EmployeeID = @EmployeeID;
    END
    ELSE
    BEGIN
        SELECT 'Employee Not Found' AS Result;
    END
END;
GO

EXEC sp_EmployeeBonus 105;



--4. Department Salary Report

DROP PROCEDURE IF EXISTS sp_DepartmentSalaryReport;
GO

CREATE PROCEDURE sp_DepartmentSalaryReport
AS
BEGIN
    SELECT
        Department,
        SUM(Salary) AS TotalSalary,
        AVG(Salary) AS AverageSalary
    FROM Employee
    GROUP BY Department;

    SELECT * FROM Employee;
END;
GO

EXEC sp_DepartmentSalaryReport;

--5. Annual Salary Calculator Using WHILE Loop

DROP PROCEDURE IF EXISTS sp_AnnualSalary;
GO

CREATE PROCEDURE sp_AnnualSalary
AS
BEGIN
    DECLARE @ID INT;

    CREATE TABLE #AnnualSalaryReport
    (
        EmployeeID INT,
        FullName VARCHAR(50),
        AnnualSalary DECIMAL(12,2)
    );

    SET @ID =
    (
        SELECT MIN(EmployeeID)
        FROM Employee
    );

    WHILE @ID IS NOT NULL
    BEGIN
        INSERT INTO #AnnualSalaryReport
        SELECT
            EmployeeID,
            FullName,
            Salary * 12
        FROM Employee
        WHERE EmployeeID = @ID;

        SET @ID =
        (
            SELECT MIN(EmployeeID)
            FROM Employee
            WHERE EmployeeID > @ID
        );
    END

    SELECT * FROM #AnnualSalaryReport;

    SELECT * FROM Employee;

    DROP TABLE #AnnualSalaryReport;
END;
GO

EXEC sp_AnnualSalary;