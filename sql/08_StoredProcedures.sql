USE EHRPMS;
GO

/* ============================================================
   PROJECT 7
   Enterprise HR & Payroll Management System
   PHASE 8 - STORED PROCEDURES
   ============================================================ */

SET NOCOUNT ON;
GO


/* ============================================================
   1. GET EMPLOYEE DETAILS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_GetEmployeeDetails
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.EmployeeID,
        E.EmployeeNumber,
        E.FirstName,
        E.LastName,
        E.Email,
        E.Phone,
        E.DateOfBirth,
        E.HireDate,
        E.EmploymentStatus,

        D.DepartmentID,
        D.DepartmentName,

        J.JobID,
        J.JobTitle,
        J.JobLevel,

        B.BranchID,
        B.BranchName,
        B.City,
        B.Country,

        M.EmployeeNumber AS ManagerEmployeeNumber,
        CONCAT(M.FirstName, ' ', M.LastName) AS ManagerName,

        dbo.fn_GetEmployeeAge(E.DateOfBirth) AS Age,
        dbo.fn_GetYearsOfService(E.HireDate) AS YearsOfService,
        dbo.fn_GetCurrentSalary(E.EmployeeID) AS CurrentSalary

    FROM dbo.Employees AS E

    LEFT JOIN dbo.Departments AS D
        ON E.DepartmentID = D.DepartmentID

    LEFT JOIN dbo.Jobs AS J
        ON E.JobID = J.JobID

    LEFT JOIN dbo.Branches AS B
        ON E.BranchID = B.BranchID

    LEFT JOIN dbo.Employees AS M
        ON E.ManagerID = M.EmployeeID

    WHERE E.EmployeeID = @EmployeeID;
END;
GO


/* ============================================================
   2. ADD EMPLOYEE
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_AddEmployee
    @EmployeeNumber NVARCHAR(20),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(150),
    @Phone NVARCHAR(30) = NULL,
    @DateOfBirth DATE = NULL,
    @HireDate DATE,
    @DepartmentID INT,
    @JobID INT,
    @ManagerID INT = NULL,
    @BranchID INT,
    @EmploymentStatus NVARCHAR(20) = 'Active'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeNumber = @EmployeeNumber
        )
        BEGIN
            THROW 50001, 'Employee number already exists.', 1;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE Email = @Email
        )
        BEGIN
            THROW 50002, 'Employee email already exists.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Departments
            WHERE DepartmentID = @DepartmentID
        )
        BEGIN
            THROW 50003, 'Department does not exist.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Jobs
            WHERE JobID = @JobID
        )
        BEGIN
            THROW 50004, 'Job does not exist.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Branches
            WHERE BranchID = @BranchID
        )
        BEGIN
            THROW 50005, 'Branch does not exist.', 1;
        END;

        INSERT INTO dbo.Employees
        (
            EmployeeNumber,
            FirstName,
            LastName,
            Email,
            Phone,
            DateOfBirth,
            HireDate,
            DepartmentID,
            JobID,
            ManagerID,
            BranchID,
            EmploymentStatus
        )
        VALUES
        (
            @EmployeeNumber,
            @FirstName,
            @LastName,
            @Email,
            @Phone,
            @DateOfBirth,
            @HireDate,
            @DepartmentID,
            @JobID,
            @ManagerID,
            @BranchID,
            @EmploymentStatus
        );

        SELECT
            CAST(SCOPE_IDENTITY() AS INT) AS NewEmployeeID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


/* ============================================================
   3. UPDATE EMPLOYEE STATUS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_UpdateEmployeeStatus
    @EmployeeID INT,
    @NewStatus NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeID = @EmployeeID
        )
        BEGIN
            THROW 50010, 'Employee does not exist.', 1;
        END;

        UPDATE dbo.Employees
        SET EmploymentStatus = @NewStatus
        WHERE EmployeeID = @EmployeeID;

        SELECT
            EmployeeID,
            EmployeeNumber,
            EmploymentStatus
        FROM dbo.Employees
        WHERE EmployeeID = @EmployeeID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


/* ============================================================
   4. CHANGE EMPLOYEE SALARY
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_ChangeEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(18,2),
    @EffectiveFrom DATE,
    @Reason NVARCHAR(250),
    @ApprovedByEmployeeID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeID = @EmployeeID
        )
        BEGIN
            THROW 50020, 'Employee does not exist.', 1;
        END;

        IF @NewSalary <= 0
        BEGIN
            THROW 50021, 'Salary must be greater than zero.', 1;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.EmployeeSalaryHistory
            WHERE EmployeeID = @EmployeeID
              AND EffectiveTo IS NULL
        )
        BEGIN
            UPDATE dbo.EmployeeSalaryHistory
            SET EffectiveTo = DATEADD(DAY, -1, @EffectiveFrom)
            WHERE EmployeeID = @EmployeeID
              AND EffectiveTo IS NULL;
        END;

        INSERT INTO dbo.EmployeeSalaryHistory
        (
            EmployeeID,
            Salary,
            EffectiveFrom,
            EffectiveTo,
            Reason,
            ApprovedByEmployeeID
        )
        VALUES
        (
            @EmployeeID,
            @NewSalary,
            @EffectiveFrom,
            NULL,
            @Reason,
            @ApprovedByEmployeeID
        );

        COMMIT TRANSACTION;

        SELECT
            SalaryHistoryID,
            EmployeeID,
            Salary,
            EffectiveFrom,
            EffectiveTo,
            Reason
        FROM dbo.EmployeeSalaryHistory
        WHERE EmployeeID = @EmployeeID
          AND EffectiveTo IS NULL;

    END TRY

    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO


/* ============================================================
   5. REQUEST LEAVE
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_RequestLeave
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason NVARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeID = @EmployeeID
        )
        BEGIN
            THROW 50030, 'Employee does not exist.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.LeaveTypes
            WHERE LeaveTypeID = @LeaveTypeID
        )
        BEGIN
            THROW 50031, 'Leave type does not exist.', 1;
        END;

        IF @EndDate < @StartDate
        BEGIN
            THROW 50032, 'End date cannot be before start date.', 1;
        END;

        INSERT INTO dbo.EmployeeLeaves
        (
            EmployeeID,
            LeaveTypeID,
            StartDate,
            EndDate,
            Reason,
            Status
        )
        VALUES
        (
            @EmployeeID,
            @LeaveTypeID,
            @StartDate,
            @EndDate,
            @Reason,
            'Pending'
        );

        SELECT
            CAST(SCOPE_IDENTITY() AS BIGINT) AS NewLeaveID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


/* ============================================================
   6. APPROVE / REJECT LEAVE
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_ApproveLeave
    @LeaveID BIGINT,
    @Status NVARCHAR(20),
    @ApprovedByEmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.EmployeeLeaves
            WHERE LeaveID = @LeaveID
        )
        BEGIN
            THROW 50040, 'Leave request does not exist.', 1;
        END;

        IF @Status NOT IN ('Approved', 'Rejected', 'Cancelled')
        BEGIN
            THROW 50041, 'Invalid leave status.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeID = @ApprovedByEmployeeID
        )
        BEGIN
            THROW 50042, 'Approving employee does not exist.', 1;
        END;

        UPDATE dbo.EmployeeLeaves
        SET
            Status = @Status,
            ApprovedByEmployeeID = @ApprovedByEmployeeID
        WHERE LeaveID = @LeaveID;

        SELECT
            LeaveID,
            EmployeeID,
            LeaveTypeID,
            StartDate,
            EndDate,
            Status,
            ApprovedByEmployeeID
        FROM dbo.EmployeeLeaves
        WHERE LeaveID = @LeaveID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


/* ============================================================
   7. ADD BONUS
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_AddBonus
    @EmployeeID INT,
    @BonusTypeID INT,
    @Amount DECIMAL(18,2),
    @BonusDate DATE,
    @Reason NVARCHAR(250),
    @ApprovedByEmployeeID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF @Amount <= 0
        BEGIN
            THROW 50050, 'Bonus amount must be greater than zero.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeID = @EmployeeID
        )
        BEGIN
            THROW 50051, 'Employee does not exist.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.BonusTypes
            WHERE BonusTypeID = @BonusTypeID
        )
        BEGIN
            THROW 50052, 'Bonus type does not exist.', 1;
        END;

        INSERT INTO dbo.Bonuses
        (
            EmployeeID,
            BonusTypeID,
            Amount,
            BonusDate,
            Reason,
            ApprovedByEmployeeID,
            Status
        )
        VALUES
        (
            @EmployeeID,
            @BonusTypeID,
            @Amount,
            @BonusDate,
            @Reason,
            @ApprovedByEmployeeID,
            'Pending'
        );

        SELECT
            CAST(SCOPE_IDENTITY() AS BIGINT) AS NewBonusID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


/* ============================================================
   8. ADD DEDUCTION
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_AddDeduction
    @EmployeeID INT,
    @DeductionTypeID INT,
    @Amount DECIMAL(18,2),
    @DeductionDate DATE,
    @Reason NVARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF @Amount <= 0
        BEGIN
            THROW 50060, 'Deduction amount must be greater than zero.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Employees
            WHERE EmployeeID = @EmployeeID
        )
        BEGIN
            THROW 50061, 'Employee does not exist.', 1;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.DeductionTypes
            WHERE DeductionTypeID = @DeductionTypeID
        )
        BEGIN
            THROW 50062, 'Deduction type does not exist.', 1;
        END;

        INSERT INTO dbo.Deductions
        (
            EmployeeID,
            DeductionTypeID,
            Amount,
            DeductionDate,
            Reason
        )
        VALUES
        (
            @EmployeeID,
            @DeductionTypeID,
            @Amount,
            @DeductionDate,
            @Reason
        );

        SELECT
            CAST(SCOPE_IDENTITY() AS BIGINT) AS NewDeductionID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


/* ============================================================
   9. PROCESS PAYROLL
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_ProcessPayroll
    @PayrollPeriodID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        /* Validate payroll period */

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.PayrollPeriods
            WHERE PayrollPeriodID = @PayrollPeriodID
        )
        BEGIN
            THROW 50070, 'Payroll period does not exist.', 1;
        END;

        /* Prevent processing closed/cancelled periods */

        IF EXISTS
        (
            SELECT 1
            FROM dbo.PayrollPeriods
            WHERE PayrollPeriodID = @PayrollPeriodID
              AND PayrollStatus IN ('Closed', 'Cancelled')
        )
        BEGIN
            THROW 50071, 'Payroll period cannot be processed.', 1;
        END;

        /* Mark period as Processing */

        UPDATE dbo.PayrollPeriods
        SET PayrollStatus = 'Processing'
        WHERE PayrollPeriodID = @PayrollPeriodID;


        /* Insert payroll records */

        INSERT INTO dbo.Payroll
        (
            EmployeeID,
            PayrollPeriodID,
            BasicSalary,
            Overtime,
            Bonuses,
            Deductions,
            NetSalary,
            PayrollStatus,
            ProcessedDate
        )
        SELECT
            E.EmployeeID,

            @PayrollPeriodID,

            ISNULL(S.CurrentSalary, 0) AS BasicSalary,

            0 AS Overtime,

            ISNULL(B.TotalBonuses, 0) AS Bonuses,

            ISNULL(D.TotalDeductions, 0) AS Deductions,

            ISNULL(S.CurrentSalary, 0)
            + 0
            + ISNULL(B.TotalBonuses, 0)
            - ISNULL(D.TotalDeductions, 0) AS NetSalary,

            'Processed',

            SYSDATETIME()

        FROM dbo.Employees AS E

        OUTER APPLY
        (
            SELECT TOP 1
                SH.Salary AS CurrentSalary
            FROM dbo.EmployeeSalaryHistory AS SH
            WHERE SH.EmployeeID = E.EmployeeID
              AND SH.EffectiveTo IS NULL
            ORDER BY SH.EffectiveFrom DESC
        ) AS S

        OUTER APPLY
        (
            SELECT
                SUM(BN.Amount) AS TotalBonuses
            FROM dbo.Bonuses AS BN
            WHERE BN.EmployeeID = E.EmployeeID
              AND BN.Status IN ('Approved', 'Paid')
              AND BN.BonusDate BETWEEN
                  (
                      SELECT PeriodStartDate
                      FROM dbo.PayrollPeriods
                      WHERE PayrollPeriodID = @PayrollPeriodID
                  )
                  AND
                  (
                      SELECT PeriodEndDate
                      FROM dbo.PayrollPeriods
                      WHERE PayrollPeriodID = @PayrollPeriodID
                  )
        ) AS B

        OUTER APPLY
        (
            SELECT
                SUM(DN.Amount) AS TotalDeductions
            FROM dbo.Deductions AS DN
            WHERE DN.EmployeeID = E.EmployeeID
              AND DN.DeductionDate BETWEEN
                  (
                      SELECT PeriodStartDate
                      FROM dbo.PayrollPeriods
                      WHERE PayrollPeriodID = @PayrollPeriodID
                  )
                  AND
                  (
                      SELECT PeriodEndDate
                      FROM dbo.PayrollPeriods
                      WHERE PayrollPeriodID = @PayrollPeriodID
                  )
        ) AS D

        WHERE E.EmploymentStatus IN ('Active', 'OnLeave')
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.Payroll AS ExistingPayroll
              WHERE ExistingPayroll.EmployeeID = E.EmployeeID
                AND ExistingPayroll.PayrollPeriodID = @PayrollPeriodID
          );


        /* Mark payroll period as processed */

        UPDATE dbo.PayrollPeriods
        SET
            PayrollStatus = 'Processed',
            ProcessedDate = SYSDATETIME()
        WHERE PayrollPeriodID = @PayrollPeriodID;


        COMMIT TRANSACTION;

        /* Return processing summary */

        SELECT
            @PayrollPeriodID AS PayrollPeriodID,
            COUNT(*) AS EmployeesProcessed,
            SUM(NetSalary) AS TotalNetPayroll
        FROM dbo.Payroll
        WHERE PayrollPeriodID = @PayrollPeriodID;

    END TRY

    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO


/* ============================================================
   10. RECORD PAYROLL PAYMENT
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.usp_RecordPayrollPayment
    @PayrollID BIGINT,
    @PaymentDate DATE,
    @PaymentMethod NVARCHAR(30),
    @Amount DECIMAL(18,2),
    @TransactionReference NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Payroll
            WHERE PayrollID = @PayrollID
        )
        BEGIN
            THROW 50080, 'Payroll record does not exist.', 1;
        END;

        IF @Amount <= 0
        BEGIN
            THROW 50081, 'Payment amount must be greater than zero.', 1;
        END;

        IF @PaymentMethod NOT IN
        (
            'BankTransfer',
            'Cash',
            'Cheque'
        )
        BEGIN
            THROW 50082, 'Invalid payment method.', 1;
        END;

        INSERT INTO dbo.PayrollPayments
        (
            PayrollID,
            PaymentDate,
            PaymentMethod,
            Amount,
            PaymentStatus,
            TransactionReference
        )
        VALUES
        (
            @PayrollID,
            @PaymentDate,
            @PaymentMethod,
            @Amount,
            'Completed',
            @TransactionReference
        );

        UPDATE dbo.Payroll
        SET PayrollStatus = 'Paid'
        WHERE PayrollID = @PayrollID;

        SELECT
            CAST(SCOPE_IDENTITY() AS BIGINT) AS NewPaymentID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO


PRINT '============================================================';
PRINT 'PHASE 8 - STORED PROCEDURES CREATED SUCCESSFULLY';
PRINT '============================================================';
GO