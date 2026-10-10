USE EHRPMS;
GO

/* ============================================================
   PROJECT 7
   Enterprise HR & Payroll Management System
   PHASE 10 - TRANSACTIONS & CONCURRENCY
   ============================================================ */

SET NOCOUNT ON;
GO


/*
	COMMIT
	We'll update an employee and deliberately commit the change.
*/

BEGIN TRANSACTION;

UPDATE dbo.Employees
SET EmploymentStatus = 'OnLeave'
WHERE EmployeeID = 1;

COMMIT TRANSACTION;
GO

-- verify
SELECT
    EmployeeID,
    EmployeeNumber,
    EmploymentStatus
FROM dbo.Employees
WHERE EmployeeID = 1;


/*
    ROLLBACK
    make a change and cancel it.
*/

BEGIN TRANSACTION;

UPDATE dbo.Employees
SET EmploymentStatus = 'Terminated'
WHERE EmployeeID = 1;

SELECT
    EmployeeID,
    EmploymentStatus
FROM dbo.Employees
WHERE EmployeeID = 1;

ROLLBACK TRANSACTION;
GO

-- verify
SELECT
    EmployeeID,
    EmploymentStatus
FROM dbo.Employees
WHERE EmployeeID = 1;


/*
    TRY/CATCH Transaction
    This is the pattern you should use for important business operations.
*/

BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE dbo.Employees
    SET EmploymentStatus = 'OnLeave'
    WHERE EmployeeID = 1;

    /*
       Intentional error for demonstration.
    */

    INSERT INTO dbo.EmployeeSalaryHistory
    (
        EmployeeID,
        Salary,
        EffectiveFrom,
        Reason
    )
    VALUES
    (
        1,
        -5000,
        GETDATE(),
        'Invalid salary test'
    );

    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;
GO



-- Salary Change
    BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @EmployeeID INT = 1;
    DECLARE @NewSalary DECIMAL(18,2) = 30000;
    DECLARE @EffectiveFrom DATE = '2026-10-01';

    UPDATE dbo.EmployeeSalaryHistory
    SET EffectiveTo = DATEADD(DAY, -1, @EffectiveFrom)
    WHERE EmployeeID = @EmployeeID
      AND EffectiveTo IS NULL;

    INSERT INTO dbo.EmployeeSalaryHistory
    (
        EmployeeID,
        Salary,
        EffectiveFrom,
        EffectiveTo,
        Reason
    )
    VALUES
    (
        @EmployeeID,
        @NewSalary,
        @EffectiveFrom,
        NULL,
        'Transaction test salary change'
    );

    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO

SELECT *
FROM dbo.EmployeeSalaryHistory
WHERE EmployeeID = 1
ORDER BY EffectiveFrom DESC;