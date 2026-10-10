USE EHRPMS;
GO

SET NOCOUNT ON;
GO

PRINT '=============================================================';
PRINT 'EHRPMS PHASE 6 - VIEWS';
PRINT '=============================================================';
GO


/* =============================================================
   1. EMPLOYEE DIRECTORY
   ============================================================= */

PRINT 'Creating vw_EmployeeDirectory...';
GO

CREATE OR ALTER VIEW dbo.vw_EmployeeDirectory
AS
SELECT
    E.EmployeeID,
    E.EmployeeNumber,
    E.FirstName,
    E.LastName,
    CONCAT(E.FirstName, ' ', E.LastName) AS FullName,
    E.Email,
    E.Phone,
    E.DateOfBirth,
    E.HireDate,
    E.EmploymentStatus,

    D.DepartmentID,
    D.DepartmentName,
    D.DepartmentCode,

    J.JobID,
    J.JobTitle,
    J.JobLevel,

    B.BranchID,
    B.BranchName,
    B.City,
    B.Country,

    E.ManagerID,

    CASE
        WHEN M.EmployeeID IS NOT NULL
        THEN CONCAT(M.FirstName, ' ', M.LastName)
        ELSE NULL
    END AS ManagerName

FROM dbo.Employees E

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.Jobs J
    ON J.JobID = E.JobID

INNER JOIN dbo.Branches B
    ON B.BranchID = E.BranchID

LEFT JOIN dbo.Employees M
    ON M.EmployeeID = E.ManagerID;
GO


/* =============================================================
   2. CURRENT EMPLOYEE SALARY
   ============================================================= */

PRINT 'Creating vw_CurrentEmployeeSalary...';
GO

CREATE OR ALTER VIEW dbo.vw_CurrentEmployeeSalary
AS
SELECT
    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,
    J.JobTitle,
    J.JobLevel,

    S.Salary,
    S.EffectiveFrom,
    S.Reason,
    S.ApprovedByEmployeeID

FROM dbo.Employees E

INNER JOIN dbo.EmployeeSalaryHistory S
    ON S.EmployeeID = E.EmployeeID
   AND S.EffectiveTo IS NULL

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.Jobs J
    ON J.JobID = E.JobID;
GO


/* =============================================================
   3. COMPLETE SALARY HISTORY
   ============================================================= */

PRINT 'Creating vw_EmployeeSalaryHistory...';
GO

CREATE OR ALTER VIEW dbo.vw_EmployeeSalaryHistory
AS
SELECT
    S.SalaryHistoryID,

    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,
    J.JobTitle,

    S.Salary,
    S.EffectiveFrom,
    S.EffectiveTo,
    S.Reason,

    CASE
        WHEN S.EffectiveTo IS NULL
            THEN 'Current'
        ELSE 'Historical'
    END AS SalaryStatus

FROM dbo.EmployeeSalaryHistory S

INNER JOIN dbo.Employees E
    ON E.EmployeeID = S.EmployeeID

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.Jobs J
    ON J.JobID = E.JobID;
GO


/* =============================================================
   4. ATTENDANCE SUMMARY
   ============================================================= */

PRINT 'Creating vw_AttendanceSummary...';
GO

CREATE OR ALTER VIEW dbo.vw_AttendanceSummary
AS
SELECT
    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,

    COUNT(A.AttendanceID) AS TotalAttendanceRecords,

    SUM(
        CASE
            WHEN A.Status = 'Present'
                THEN 1
            ELSE 0
        END
    ) AS PresentDays,

    SUM(
        CASE
            WHEN A.Status = 'Absent'
                THEN 1
            ELSE 0
        END
    ) AS AbsentDays,

    SUM(
        CASE
            WHEN A.Status = 'Late'
                THEN 1
            ELSE 0
        END
    ) AS LateDays,

    SUM(
        CASE
            WHEN A.Status = 'Remote'
                THEN 1
            ELSE 0
        END
    ) AS RemoteDays,

    SUM(
        CASE
            WHEN A.Status = 'Holiday'
                THEN 1
            ELSE 0
        END
    ) AS HolidayDays,

    CAST(
        SUM(ISNULL(A.WorkingHours, 0))
        AS DECIMAL(18,2)
    ) AS TotalWorkingHours,

    CAST(
        AVG(
            CASE
                WHEN A.Status <> 'Holiday'
                THEN A.WorkingHours
            END
        )
        AS DECIMAL(5,2)
    ) AS AverageWorkingHours

FROM dbo.Employees E

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

LEFT JOIN dbo.Attendance A
    ON A.EmployeeID = E.EmployeeID

GROUP BY
    E.EmployeeID,
    E.EmployeeNumber,
    E.FirstName,
    E.LastName,
    D.DepartmentName;
GO


/* =============================================================
   5. EMPLOYEE LEAVE SUMMARY
   ============================================================= */

PRINT 'Creating vw_EmployeeLeaveSummary...';
GO

CREATE OR ALTER VIEW dbo.vw_EmployeeLeaveSummary
AS
SELECT
    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,

    LT.LeaveTypeID,
    LT.LeaveTypeName,
    LT.MaxDaysPerYear,

    COUNT(EL.LeaveID) AS LeaveRequests,

    SUM(
        CASE
            WHEN EL.Status = 'Approved'
                THEN DATEDIFF(DAY, EL.StartDate, EL.EndDate) + 1
            ELSE 0
        END
    ) AS ApprovedLeaveDays,

    SUM(
        CASE
            WHEN EL.Status = 'Pending'
                THEN 1
            ELSE 0
        END
    ) AS PendingRequests,

    SUM(
        CASE
            WHEN EL.Status = 'Rejected'
                THEN 1
            ELSE 0
        END
    ) AS RejectedRequests

FROM dbo.Employees E

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

LEFT JOIN dbo.EmployeeLeaves EL
    ON EL.EmployeeID = E.EmployeeID

LEFT JOIN dbo.LeaveTypes LT
    ON LT.LeaveTypeID = EL.LeaveTypeID

GROUP BY
    E.EmployeeID,
    E.EmployeeNumber,
    E.FirstName,
    E.LastName,
    D.DepartmentName,
    LT.LeaveTypeID,
    LT.LeaveTypeName,
    LT.MaxDaysPerYear;
GO


/* =============================================================
   6. EMPLOYEE BONUSES
   ============================================================= */

PRINT 'Creating vw_EmployeeBonuses...';
GO

CREATE OR ALTER VIEW dbo.vw_EmployeeBonuses
AS
SELECT
    B.BonusID,

    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,

    BT.BonusTypeID,
    BT.BonusTypeName,

    B.Amount,
    B.BonusDate,
    B.Reason,
    B.Status,

    B.ApprovedByEmployeeID

FROM dbo.Bonuses B

INNER JOIN dbo.Employees E
    ON E.EmployeeID = B.EmployeeID

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.BonusTypes BT
    ON BT.BonusTypeID = B.BonusTypeID;
GO


/* =============================================================
   7. EMPLOYEE DEDUCTIONS
   ============================================================= */

PRINT 'Creating vw_EmployeeDeductions...';
GO

CREATE OR ALTER VIEW dbo.vw_EmployeeDeductions
AS
SELECT
    DED.DeductionID,

    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,

    DT.DeductionTypeID,
    DT.DeductionTypeName,

    DED.Amount,
    DED.DeductionDate,
    DED.Reason

FROM dbo.Deductions DED

INNER JOIN dbo.Employees E
    ON E.EmployeeID = DED.EmployeeID

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.DeductionTypes DT
    ON DT.DeductionTypeID = DED.DeductionTypeID;
GO


/* =============================================================
   8. PAYROLL DETAILS
   ============================================================= */

PRINT 'Creating vw_PayrollDetails...';
GO

CREATE OR ALTER VIEW dbo.vw_PayrollDetails
AS
SELECT
    P.PayrollID,

    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,
    J.JobTitle,

    PP.PayrollPeriodID,
    PP.PeriodStartDate,
    PP.PeriodEndDate,
    PP.PayrollStatus AS PeriodStatus,

    P.BasicSalary,
    P.Overtime,
    P.Bonuses,
    P.Deductions,
    P.NetSalary,

    P.PayrollStatus,
    P.ProcessedDate

FROM dbo.Payroll P

INNER JOIN dbo.Employees E
    ON E.EmployeeID = P.EmployeeID

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.Jobs J
    ON J.JobID = E.JobID

INNER JOIN dbo.PayrollPeriods PP
    ON PP.PayrollPeriodID = P.PayrollPeriodID;
GO


/* =============================================================
   9. MONTHLY PAYROLL SUMMARY
   ============================================================= */

PRINT 'Creating vw_MonthlyPayrollSummary...';
GO

CREATE OR ALTER VIEW dbo.vw_MonthlyPayrollSummary
AS
SELECT
    PP.PayrollPeriodID,
    PP.PeriodStartDate,
    PP.PeriodEndDate,
    PP.PayrollStatus,

    COUNT(P.PayrollID) AS EmployeePayrollCount,

    CAST(
        SUM(P.BasicSalary)
        AS DECIMAL(18,2)
    ) AS TotalBasicSalary,

    CAST(
        SUM(P.Overtime)
        AS DECIMAL(18,2)
    ) AS TotalOvertime,

    CAST(
        SUM(P.Bonuses)
        AS DECIMAL(18,2)
    ) AS TotalBonuses,

    CAST(
        SUM(P.Deductions)
        AS DECIMAL(18,2)
    ) AS TotalDeductions,

    CAST(
        SUM(P.NetSalary)
        AS DECIMAL(18,2)
    ) AS TotalNetPayroll

FROM dbo.Payroll P

INNER JOIN dbo.PayrollPeriods PP
    ON PP.PayrollPeriodID = P.PayrollPeriodID

GROUP BY
    PP.PayrollPeriodID,
    PP.PeriodStartDate,
    PP.PeriodEndDate,
    PP.PayrollStatus;
GO


/* =============================================================
   10. PAYROLL PAYMENT STATUS
   ============================================================= */

PRINT 'Creating vw_PaymentStatus...';
GO

CREATE OR ALTER VIEW dbo.vw_PaymentStatus
AS
SELECT
    PP.PaymentID,

    P.PayrollID,

    E.EmployeeID,
    E.EmployeeNumber,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    D.DepartmentName,

    PR.PayrollPeriodID,
    PR.PeriodStartDate,
    PR.PeriodEndDate,

    PP.PaymentDate,
    PP.PaymentMethod,
    PP.Amount,
    PP.PaymentStatus,
    PP.TransactionReference

FROM dbo.PayrollPayments PP

INNER JOIN dbo.Payroll P
    ON P.PayrollID = PP.PayrollID

INNER JOIN dbo.Employees E
    ON E.EmployeeID = P.EmployeeID

INNER JOIN dbo.Departments D
    ON D.DepartmentID = E.DepartmentID

INNER JOIN dbo.PayrollPeriods PR
    ON PR.PayrollPeriodID = P.PayrollPeriodID;
GO


PRINT '=============================================================';
PRINT 'ALL PHASE 6 VIEWS CREATED SUCCESSFULLY';
PRINT '=============================================================';
GO