USE EHRPMS;
GO

/* ============================================================
   PROJECT 7
   Enterprise HR & Payroll Management System
   PHASE 9 - TRIGGERS
   ============================================================ */

SET NOCOUNT ON;
GO


/* ============================================================
   1. EMPLOYEE STATUS AUDIT
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_Employees_AuditStatus
ON dbo.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditLogs
    (
        UserName,
        Action,
        TableName,
        RecordID,
        OldValue,
        NewValue,
        ActionDate
    )
    SELECT
        SUSER_SNAME(),
        'STATUS_CHANGE',
        'Employees',
        I.EmployeeID,

        D.EmploymentStatus,

        I.EmploymentStatus,

        SYSDATETIME()

    FROM inserted AS I
    INNER JOIN deleted AS D
        ON I.EmployeeID = D.EmployeeID

    WHERE ISNULL(D.EmploymentStatus, '')
       <> ISNULL(I.EmploymentStatus, '');
END;
GO


/* ============================================================
   2. SALARY CHANGE AUDIT
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_SalaryHistory_Audit
ON dbo.EmployeeSalaryHistory
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditLogs
    (
        UserName,
        Action,
        TableName,
        RecordID,
        OldValue,
        NewValue,
        ActionDate
    )
    SELECT
        SUSER_SNAME(),

        'SALARY_CHANGE',

        'EmployeeSalaryHistory',

        I.SalaryHistoryID,

        CASE
            WHEN D.SalaryHistoryID IS NULL
                THEN NULL
            ELSE
                CONCAT(
                    'Salary=',
                    D.Salary,
                    '; EffectiveFrom=',
                    CONVERT(VARCHAR(10), D.EffectiveFrom, 120),
                    '; EffectiveTo=',
                    COALESCE(
                        CONVERT(VARCHAR(10), D.EffectiveTo, 120),
                        'NULL'
                    )
                )
        END,

        CONCAT(
            'Salary=',
            I.Salary,
            '; EffectiveFrom=',
            CONVERT(VARCHAR(10), I.EffectiveFrom, 120),
            '; EffectiveTo=',
            COALESCE(
                CONVERT(VARCHAR(10), I.EffectiveTo, 120),
                'NULL'
            )
        ),

        SYSDATETIME()

    FROM inserted AS I

    LEFT JOIN deleted AS D
        ON I.SalaryHistoryID = D.SalaryHistoryID;
END;
GO


/* ============================================================
   3. BONUS AUDIT
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_Bonuses_Audit
ON dbo.Bonuses
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditLogs
    (
        UserName,
        Action,
        TableName,
        RecordID,
        OldValue,
        NewValue,
        ActionDate
    )
    SELECT
        SUSER_SNAME(),

        CASE
            WHEN D.BonusID IS NULL
                THEN 'INSERT'
            ELSE 'UPDATE'
        END,

        'Bonuses',

        I.BonusID,

        CASE
            WHEN D.BonusID IS NULL
                THEN NULL
            ELSE
                CONCAT(
                    'Amount=', D.Amount,
                    '; Status=', D.Status
                )
        END,

        CONCAT(
            'Amount=', I.Amount,
            '; Status=', I.Status
        ),

        SYSDATETIME()

    FROM inserted AS I

    LEFT JOIN deleted AS D
        ON I.BonusID = D.BonusID;
END;
GO


/* ============================================================
   4. DEDUCTION AUDIT
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_Deductions_Audit
ON dbo.Deductions
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditLogs
    (
        UserName,
        Action,
        TableName,
        RecordID,
        OldValue,
        NewValue,
        ActionDate
    )
    SELECT
        SUSER_SNAME(),

        CASE
            WHEN D.DeductionID IS NULL
                THEN 'INSERT'
            ELSE 'UPDATE'
        END,

        'Deductions',

        I.DeductionID,

        CASE
            WHEN D.DeductionID IS NULL
                THEN NULL
            ELSE
                CONCAT(
                    'Amount=', D.Amount
                )
        END,

        CONCAT(
            'Amount=', I.Amount
        ),

        SYSDATETIME()

    FROM inserted AS I

    LEFT JOIN deleted AS D
        ON I.DeductionID = D.DeductionID;
END;
GO


/* ============================================================
   5. PAYROLL PAYMENT VALIDATION
   ============================================================ */

CREATE OR ALTER TRIGGER dbo.trg_PayrollPayments_Validate
ON dbo.PayrollPayments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    /*
       A payment cannot exceed the payroll net salary.
    */

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS I
        INNER JOIN dbo.Payroll AS P
            ON I.PayrollID = P.PayrollID
        WHERE I.Amount > P.NetSalary
    )
    BEGIN
        THROW 50100,
              'Payment amount cannot exceed payroll net salary.',
              1;
    END;


    /*
       A completed payment should have a payment date.
    */

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE PaymentStatus = 'Completed'
          AND PaymentDate IS NULL
    )
    BEGIN
        THROW 50101,
              'Completed payment must have a payment date.',
              1;
    END;
END;
GO


PRINT '============================================================';
PRINT 'PHASE 9 - TRIGGERS CREATED SUCCESSFULLY';
PRINT '============================================================';
GO