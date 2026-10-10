/*
=====================================================================
    Enterprise HR & Payroll Management System (EHRPMS)
    SQL Server Database

    Script: 03_Constraints.sql

    Purpose:
        Add database integrity constraints after table creation.

    Includes:
        - UNIQUE constraints
        - CHECK constraints
        - FOREIGN KEY constraints
        - Self-referencing relationships
        - Circular dependency resolution

    Depends On:
        02_CreateTables.sql

=====================================================================
*/

USE EHRPMS;
GO

SET NOCOUNT ON;
GO


/*====================================================================
  1. UNIQUE CONSTRAINTS
====================================================================*/

/*
    Branches
*/

ALTER TABLE dbo.Branches
ADD CONSTRAINT UQ_Branches_BranchName
    UNIQUE (BranchName);
GO


/*
    Departments
*/

ALTER TABLE dbo.Departments
ADD CONSTRAINT UQ_Departments_DepartmentName
    UNIQUE (DepartmentName);
GO

ALTER TABLE dbo.Departments
ADD CONSTRAINT UQ_Departments_DepartmentCode
    UNIQUE (DepartmentCode);
GO


/*
    Leave Types
*/

ALTER TABLE dbo.LeaveTypes
ADD CONSTRAINT UQ_LeaveTypes_LeaveTypeName
    UNIQUE (LeaveTypeName);
GO


/*
    Bonus Types
*/

ALTER TABLE dbo.BonusTypes
ADD CONSTRAINT UQ_BonusTypes_BonusTypeName
    UNIQUE (BonusTypeName);
GO


/*
    Deduction Types
*/

ALTER TABLE dbo.DeductionTypes
ADD CONSTRAINT UQ_DeductionTypes_DeductionTypeName
    UNIQUE (DeductionTypeName);
GO


/*
    Employees
*/

ALTER TABLE dbo.Employees
ADD CONSTRAINT UQ_Employees_EmployeeNumber
    UNIQUE (EmployeeNumber);
GO

ALTER TABLE dbo.Employees
ADD CONSTRAINT UQ_Employees_Email
    UNIQUE (Email);
GO


/*
    Attendance
    One attendance record per employee per date.
*/

ALTER TABLE dbo.Attendance
ADD CONSTRAINT UQ_Attendance_Employee_Date
    UNIQUE (EmployeeID, AttendanceDate);
GO


/*
    Payroll
    One payroll record per employee per payroll period.
*/

ALTER TABLE dbo.Payroll
ADD CONSTRAINT UQ_Payroll_Employee_Period
    UNIQUE (EmployeeID, PayrollPeriodID);
GO


/*====================================================================
  2. CHECK CONSTRAINTS
====================================================================*/


/*
    Jobs
*/

ALTER TABLE dbo.Jobs
ADD CONSTRAINT CK_Jobs_MinSalary_Positive
    CHECK (MinSalary > 0);
GO

ALTER TABLE dbo.Jobs
ADD CONSTRAINT CK_Jobs_MaxSalary_Valid
    CHECK (MaxSalary >= MinSalary);
GO


/*
    Leave Types
*/

ALTER TABLE dbo.LeaveTypes
ADD CONSTRAINT CK_LeaveTypes_MaxDays_NonNegative
    CHECK (MaxDaysPerYear >= 0);
GO


/*
    Employees
*/

ALTER TABLE dbo.Employees
ADD CONSTRAINT CK_Employees_EmploymentStatus
    CHECK
    (
        EmploymentStatus IN
        (
            'Active',
            'Inactive',
            'OnLeave',
            'Terminated',
            'Suspended'
        )
    );
GO


/*
    Employee Salary History
*/

ALTER TABLE dbo.EmployeeSalaryHistory
ADD CONSTRAINT CK_SalaryHistory_Salary_Positive
    CHECK (Salary > 0);
GO

ALTER TABLE dbo.EmployeeSalaryHistory
ADD CONSTRAINT CK_SalaryHistory_EffectiveDates
    CHECK
    (
        EffectiveTo IS NULL
        OR EffectiveTo >= EffectiveFrom
    );
GO


/*
    Attendance
*/

ALTER TABLE dbo.Attendance
ADD CONSTRAINT CK_Attendance_Status
    CHECK
    (
        Status IN
        (
            'Present',
            'Absent',
            'Late',
            'Remote',
            'Holiday'
        )
    );
GO

ALTER TABLE dbo.Attendance
ADD CONSTRAINT CK_Attendance_CheckOut
    CHECK
    (
        CheckOut IS NULL
        OR CheckIn IS NULL
        OR CheckOut >= CheckIn
    );
GO

ALTER TABLE dbo.Attendance
ADD CONSTRAINT CK_Attendance_WorkingHours
    CHECK
    (
        WorkingHours IS NULL
        OR WorkingHours >= 0
    );
GO


/*
    Employee Leaves
*/

ALTER TABLE dbo.EmployeeLeaves
ADD CONSTRAINT CK_EmployeeLeaves_Dates
    CHECK (EndDate >= StartDate);
GO

ALTER TABLE dbo.EmployeeLeaves
ADD CONSTRAINT CK_EmployeeLeaves_Status
    CHECK
    (
        Status IN
        (
            'Pending',
            'Approved',
            'Rejected',
            'Cancelled'
        )
    );
GO


/*
    Bonuses
*/

ALTER TABLE dbo.Bonuses
ADD CONSTRAINT CK_Bonuses_Amount_Positive
    CHECK (Amount > 0);
GO

ALTER TABLE dbo.Bonuses
ADD CONSTRAINT CK_Bonuses_Status
    CHECK
    (
        Status IN
        (
            'Pending',
            'Approved',
            'Rejected',
            'Paid',
            'Cancelled'
        )
    );
GO


/*
    Deductions
*/

ALTER TABLE dbo.Deductions
ADD CONSTRAINT CK_Deductions_Amount_Positive
    CHECK (Amount > 0);
GO


/*
    Payroll Periods
*/

ALTER TABLE dbo.PayrollPeriods
ADD CONSTRAINT CK_PayrollPeriods_Dates
    CHECK (PeriodEndDate >= PeriodStartDate);
GO

ALTER TABLE dbo.PayrollPeriods
ADD CONSTRAINT CK_PayrollPeriods_Status
    CHECK
    (
        PayrollStatus IN
        (
            'Open',
            'Processing',
            'Processed',
            'Closed',
            'Cancelled'
        )
    );
GO


/*
    Payroll
*/

ALTER TABLE dbo.Payroll
ADD CONSTRAINT CK_Payroll_BasicSalary
    CHECK (BasicSalary >= 0);
GO

ALTER TABLE dbo.Payroll
ADD CONSTRAINT CK_Payroll_Overtime
    CHECK (Overtime >= 0);
GO

ALTER TABLE dbo.Payroll
ADD CONSTRAINT CK_Payroll_Bonuses
    CHECK (Bonuses >= 0);
GO

ALTER TABLE dbo.Payroll
ADD CONSTRAINT CK_Payroll_Deductions
    CHECK (Deductions >= 0);
GO

ALTER TABLE dbo.Payroll
ADD CONSTRAINT CK_Payroll_NetSalary
    CHECK
    (
        NetSalary = BasicSalary
                  + Overtime
                  + Bonuses
                  - Deductions
    );
GO

ALTER TABLE dbo.Payroll
ADD CONSTRAINT CK_Payroll_Status
    CHECK
    (
        PayrollStatus IN
        (
            'Pending',
            'Processing',
            'Processed',
            'Paid',
            'Cancelled'
        )
    );
GO


/*
    Payroll Payments
*/

ALTER TABLE dbo.PayrollPayments
ADD CONSTRAINT CK_PayrollPayments_Amount
    CHECK (Amount > 0);
GO

ALTER TABLE dbo.PayrollPayments
ADD CONSTRAINT CK_PayrollPayments_Method
    CHECK
    (
        PaymentMethod IN
        (
            'BankTransfer',
            'Cash',
            'Cheque'
        )
    );
GO

ALTER TABLE dbo.PayrollPayments
ADD CONSTRAINT CK_PayrollPayments_Status
    CHECK
    (
        PaymentStatus IN
        (
            'Pending',
            'Processing',
            'Completed',
            'Failed',
            'Cancelled'
        )
    );
GO


/*====================================================================
  3. FOREIGN KEY CONSTRAINTS
====================================================================*/


/*
    Jobs → Departments
*/

ALTER TABLE dbo.Jobs
ADD CONSTRAINT FK_Jobs_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES dbo.Departments(DepartmentID);
GO


/*
    Employees → Departments
*/

ALTER TABLE dbo.Employees
ADD CONSTRAINT FK_Employees_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES dbo.Departments(DepartmentID);
GO


/*
    Employees → Jobs
*/

ALTER TABLE dbo.Employees
ADD CONSTRAINT FK_Employees_Jobs
    FOREIGN KEY (JobID)
    REFERENCES dbo.Jobs(JobID);
GO


/*
    Employees → Branches
*/

ALTER TABLE dbo.Employees
ADD CONSTRAINT FK_Employees_Branches
    FOREIGN KEY (BranchID)
    REFERENCES dbo.Branches(BranchID);
GO


/*
    Employees → Employees
    Self-referencing manager relationship
*/

ALTER TABLE dbo.Employees
ADD CONSTRAINT FK_Employees_Manager
    FOREIGN KEY (ManagerID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Departments → Employees
    Circular dependency resolved here.
*/

ALTER TABLE dbo.Departments
ADD CONSTRAINT FK_Departments_Manager
    FOREIGN KEY (ManagerID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Salary History → Employees
*/

ALTER TABLE dbo.EmployeeSalaryHistory
ADD CONSTRAINT FK_SalaryHistory_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO

ALTER TABLE dbo.EmployeeSalaryHistory
ADD CONSTRAINT FK_SalaryHistory_ApprovedBy
    FOREIGN KEY (ApprovedByEmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Attendance → Employees
*/

ALTER TABLE dbo.Attendance
ADD CONSTRAINT FK_Attendance_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Employee Leaves → Employees
*/

ALTER TABLE dbo.EmployeeLeaves
ADD CONSTRAINT FK_EmployeeLeaves_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO

ALTER TABLE dbo.EmployeeLeaves
ADD CONSTRAINT FK_EmployeeLeaves_LeaveTypes
    FOREIGN KEY (LeaveTypeID)
    REFERENCES dbo.LeaveTypes(LeaveTypeID);
GO

ALTER TABLE dbo.EmployeeLeaves
ADD CONSTRAINT FK_EmployeeLeaves_ApprovedBy
    FOREIGN KEY (ApprovedByEmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Bonuses → Employees
*/

ALTER TABLE dbo.Bonuses
ADD CONSTRAINT FK_Bonuses_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Bonuses → BonusTypes
*/

ALTER TABLE dbo.Bonuses
ADD CONSTRAINT FK_Bonuses_BonusTypes
    FOREIGN KEY (BonusTypeID)
    REFERENCES dbo.BonusTypes(BonusTypeID);
GO


/*
    Bonuses → Approver
*/

ALTER TABLE dbo.Bonuses
ADD CONSTRAINT FK_Bonuses_ApprovedBy
    FOREIGN KEY (ApprovedByEmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Deductions → Employees
*/

ALTER TABLE dbo.Deductions
ADD CONSTRAINT FK_Deductions_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Deductions → DeductionTypes
*/

ALTER TABLE dbo.Deductions
ADD CONSTRAINT FK_Deductions_DeductionTypes
    FOREIGN KEY (DeductionTypeID)
    REFERENCES dbo.DeductionTypes(DeductionTypeID);
GO


/*
    Payroll → Employees
*/

ALTER TABLE dbo.Payroll
ADD CONSTRAINT FK_Payroll_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID);
GO


/*
    Payroll → PayrollPeriods
*/

ALTER TABLE dbo.Payroll
ADD CONSTRAINT FK_Payroll_PayrollPeriods
    FOREIGN KEY (PayrollPeriodID)
    REFERENCES dbo.PayrollPeriods(PayrollPeriodID);
GO


/*
    PayrollPayments → Payroll
*/

ALTER TABLE dbo.PayrollPayments
ADD CONSTRAINT FK_PayrollPayments_Payroll
    FOREIGN KEY (PayrollID)
    REFERENCES dbo.Payroll(PayrollID);
GO


/*====================================================================
  4. AUDIT LOG VALIDATION
====================================================================*/

ALTER TABLE dbo.AuditLogs
ADD CONSTRAINT CK_AuditLogs_Action
    CHECK
    (
        Action IN
        (
            'INSERT',
            'UPDATE',
            'DELETE',
            'SALARY_CHANGE',
            'STATUS_CHANGE',
            'PAYROLL_MODIFICATION'
        )
    );
GO


/*====================================================================
  5. FINAL VALIDATION
====================================================================*/

PRINT '=============================================================';
PRINT 'EHRPMS CONSTRAINT CREATION COMPLETED';
PRINT '=============================================================';
GO


/*====================================================================
  VERIFY FOREIGN KEYS
====================================================================*/

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS ParentSchema,
    OBJECT_NAME(fk.parent_object_id) AS ParentTable,
    COL_NAME(
        fkc.parent_object_id,
        fkc.parent_column_id
    ) AS ParentColumn,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(
        fkc.referenced_object_id,
        fkc.referenced_column_id
    ) AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY ParentTable, ForeignKeyName;
GO


/*====================================================================
  VERIFY CHECK CONSTRAINTS
====================================================================*/

SELECT
    OBJECT_SCHEMA_NAME(parent_object_id) AS SchemaName,
    OBJECT_NAME(parent_object_id) AS TableName,
    name AS ConstraintName,
    definition
FROM sys.check_constraints
ORDER BY TableName, ConstraintName;
GO


/*====================================================================
  VERIFY UNIQUE CONSTRAINTS
====================================================================*/

SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
WHERE tc.TABLE_SCHEMA = 'dbo'
  AND tc.CONSTRAINT_TYPE = 'UNIQUE'
ORDER BY tc.TABLE_NAME;
GO