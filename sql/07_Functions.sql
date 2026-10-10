USE EHRPMS;
GO

/* ============================================================
   PROJECT 7
   Enterprise HR & Payroll Management System
   PHASE 7 - USER DEFINED FUNCTIONS
   ============================================================ */

SET NOCOUNT ON;
GO


/* ============================================================
   1. GET EMPLOYEE AGE
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetEmployeeAge
(
    @DateOfBirth DATE
)
RETURNS INT
AS
BEGIN

    IF @DateOfBirth IS NULL
        RETURN NULL;

    DECLARE @Age INT;

    SET @Age =
        DATEDIFF(YEAR, @DateOfBirth, GETDATE())
        -
        CASE
            WHEN DATEADD(
                    YEAR,
                    DATEDIFF(YEAR, @DateOfBirth, GETDATE()),
                    @DateOfBirth
                 ) > GETDATE()
            THEN 1
            ELSE 0
        END;

    RETURN @Age;

END;
GO


/* ============================================================
   2. GET YEARS OF SERVICE
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetYearsOfService
(
    @HireDate DATE
)
RETURNS INT
AS
BEGIN

    IF @HireDate IS NULL
        RETURN NULL;

    DECLARE @Years INT;

    SET @Years =
        DATEDIFF(YEAR, @HireDate, GETDATE())
        -
        CASE
            WHEN DATEADD(
                    YEAR,
                    DATEDIFF(YEAR, @HireDate, GETDATE()),
                    @HireDate
                 ) > GETDATE()
            THEN 1
            ELSE 0
        END;

    RETURN @Years;

END;
GO


/* ============================================================
   3. GET CURRENT SALARY
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetCurrentSalary
(
    @EmployeeID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @CurrentSalary DECIMAL(18,2);

    SELECT TOP 1
        @CurrentSalary = Salary
    FROM dbo.EmployeeSalaryHistory
    WHERE EmployeeID = @EmployeeID
      AND EffectiveTo IS NULL
    ORDER BY EffectiveFrom DESC;

    RETURN @CurrentSalary;

END;
GO


/* ============================================================
   4. CALCULATE LEAVE DAYS
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetLeaveDays
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS INT
AS
BEGIN

    IF @StartDate IS NULL OR @EndDate IS NULL
        RETURN NULL;

    IF @EndDate < @StartDate
        RETURN NULL;

    RETURN DATEDIFF(DAY, @StartDate, @EndDate) + 1;

END;
GO


/* ============================================================
   5. CALCULATE NET SALARY
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_CalculateNetSalary
(
    @BasicSalary DECIMAL(18,2),
    @Overtime DECIMAL(18,2),
    @Bonuses DECIMAL(18,2),
    @Deductions DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    RETURN
        ISNULL(@BasicSalary, 0)
        + ISNULL(@Overtime, 0)
        + ISNULL(@Bonuses, 0)
        - ISNULL(@Deductions, 0);

END;
GO


/* ============================================================
   6. GET EMPLOYEE ATTENDANCE
   INLINE TABLE-VALUED FUNCTION
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetEmployeeAttendance
(
    @EmployeeID INT,
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        A.AttendanceID,
        A.EmployeeID,
        A.AttendanceDate,
        A.CheckIn,
        A.CheckOut,
        A.Status,
        A.WorkingHours
    FROM dbo.Attendance AS A
    WHERE A.EmployeeID = @EmployeeID
      AND A.AttendanceDate BETWEEN @StartDate AND @EndDate
);
GO


/* ============================================================
   7. GET EMPLOYEE SALARY HISTORY
   INLINE TABLE-VALUED FUNCTION
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetSalaryHistory
(
    @EmployeeID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        SH.SalaryHistoryID,
        SH.EmployeeID,
        SH.Salary,
        SH.EffectiveFrom,
        SH.EffectiveTo,
        SH.Reason,
        SH.ApprovedByEmployeeID,

        CASE
            WHEN SH.EffectiveTo IS NULL
                THEN 'Current'
            ELSE 'Historical'
        END AS SalaryStatus

    FROM dbo.EmployeeSalaryHistory AS SH
    WHERE SH.EmployeeID = @EmployeeID
);
GO


/* ============================================================
   8. GET PAYROLL BY PERIOD
   INLINE TABLE-VALUED FUNCTION
   ============================================================ */

CREATE OR ALTER FUNCTION dbo.fn_GetPayrollByPeriod
(
    @PayrollPeriodID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.PayrollID,
        P.EmployeeID,
        E.EmployeeNumber,
        E.FirstName,
        E.LastName,

        P.PayrollPeriodID,
        PP.PeriodStartDate,
        PP.PeriodEndDate,

        P.BasicSalary,
        P.Overtime,
        P.Bonuses,
        P.Deductions,
        P.NetSalary,
        P.PayrollStatus,
        P.ProcessedDate

    FROM dbo.Payroll AS P

    INNER JOIN dbo.Employees AS E
        ON P.EmployeeID = E.EmployeeID

    INNER JOIN dbo.PayrollPeriods AS PP
        ON P.PayrollPeriodID = PP.PayrollPeriodID

    WHERE P.PayrollPeriodID = @PayrollPeriodID
);
GO


PRINT '============================================================';
PRINT 'PHASE 7 - FUNCTIONS CREATED SUCCESSFULLY';
PRINT '============================================================';
GO