USE EHRPMS;
GO

-- 1. Business question: How many employees work in each department?

SELECT
    d.DepartmentID,
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY
    EmployeeCount DESC;
GO


-- 2. Business question: Show employees with department, job, branch, and manager.
SELECT
    e.EmployeeID,
    e.EmployeeNumber,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.Email,
    d.DepartmentName,
    j.JobTitle,
    b.BranchName,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
    e.EmploymentStatus
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
LEFT JOIN Jobs j
    ON e.JobID = j.JobID
LEFT JOIN Branches b
    ON e.BranchID = b.BranchID
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID
ORDER BY
    d.DepartmentName,
    EmployeeName;
GO



-- 3. Headcount by Branch
SELECT
    b.BranchName,
    b.City,
    b.Country,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Branches b
LEFT JOIN Employees e
    ON b.BranchID = e.BranchID
GROUP BY
    b.BranchName,
    b.City,
    b.Country
ORDER BY
    EmployeeCount DESC;
GO


-- 4. Business question: Who currently has the highest salaries?
SELECT TOP 20
    e.EmployeeID,
    e.EmployeeNumber,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    d.DepartmentName,
    j.JobTitle,
    s.Salary
FROM Employees e
INNER JOIN EmployeeSalaryHistory s
    ON e.EmployeeID = s.EmployeeID
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
LEFT JOIN Jobs j
    ON e.JobID = j.JobID
WHERE s.EffectiveTo IS NULL
ORDER BY
    s.Salary DESC;
GO