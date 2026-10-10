/*
=====================================================================
    Enterprise HR & Payroll Management System (EHRPMS)
    SQL Server Database

    Script: 02_CreateTables.sql
    Purpose:
        Create all physical database tables.

    Phase:
        Phase 4 - Physical Database Implementation

    Design:
        - 16 tables
        - 3NF-oriented relational design
        - SQL Server
        - Primary keys defined here
        - Foreign keys and business constraints handled separately
          in 03_Constraints.sql

    Important:
        Departments.ManagerID and Employees.ManagerID are intentionally
        created without foreign keys in this script because of the
        circular/self-referencing dependencies.

=====================================================================
*/

USE EHRPMS;
GO

SET NOCOUNT ON;
GO


/*====================================================================
  1. BRANCHES
====================================================================*/

CREATE TABLE dbo.Branches
(
    BranchID        INT IDENTITY(1,1) NOT NULL,
    BranchName      NVARCHAR(100) NOT NULL,
    City            NVARCHAR(100) NOT NULL,
    Country         NVARCHAR(100) NOT NULL,
    Address         NVARCHAR(250) NULL,

    CONSTRAINT PK_Branches
        PRIMARY KEY (BranchID)
);
GO


/*====================================================================
  2. LEAVE TYPES
====================================================================*/

CREATE TABLE dbo.LeaveTypes
(
    LeaveTypeID      INT IDENTITY(1,1) NOT NULL,
    LeaveTypeName    NVARCHAR(50) NOT NULL,
    MaxDaysPerYear   DECIMAL(5,2) NOT NULL,

    CONSTRAINT PK_LeaveTypes
        PRIMARY KEY (LeaveTypeID)
);
GO


/*====================================================================
  3. BONUS TYPES
====================================================================*/

CREATE TABLE dbo.BonusTypes
(
    BonusTypeID      INT IDENTITY(1,1) NOT NULL,
    BonusTypeName    NVARCHAR(100) NOT NULL,
    Description      NVARCHAR(250) NULL,

    CONSTRAINT PK_BonusTypes
        PRIMARY KEY (BonusTypeID)
);
GO


/*====================================================================
  4. DEDUCTION TYPES
====================================================================*/

CREATE TABLE dbo.DeductionTypes
(
    DeductionTypeID      INT IDENTITY(1,1) NOT NULL,
    DeductionTypeName    NVARCHAR(100) NOT NULL,
    Description          NVARCHAR(250) NULL,

    CONSTRAINT PK_DeductionTypes
        PRIMARY KEY (DeductionTypeID)
);
GO


/*====================================================================
  5. DEPARTMENTS
====================================================================*/

CREATE TABLE dbo.Departments
(
    DepartmentID      INT IDENTITY(1,1) NOT NULL,
    DepartmentName    NVARCHAR(100) NOT NULL,
    DepartmentCode    VARCHAR(20) NOT NULL,

    -- FK to Employees will be added later
    -- because Employees also references Departments.
    ManagerID         INT NULL,

    CONSTRAINT PK_Departments
        PRIMARY KEY (DepartmentID)
);
GO


/*====================================================================
  6. JOBS
====================================================================*/

CREATE TABLE dbo.Jobs
(
    JobID             INT IDENTITY(1,1) NOT NULL,
    JobTitle          NVARCHAR(100) NOT NULL,
    JobLevel          NVARCHAR(50) NOT NULL,
    MinSalary         DECIMAL(18,2) NOT NULL,
    MaxSalary         DECIMAL(18,2) NOT NULL,
    DepartmentID      INT NOT NULL,

    CONSTRAINT PK_Jobs
        PRIMARY KEY (JobID)
);
GO


/*====================================================================
  7. EMPLOYEES
====================================================================*/

CREATE TABLE dbo.Employees
(
    EmployeeID          INT IDENTITY(1,1) NOT NULL,
    EmployeeNumber      VARCHAR(20) NOT NULL,
    FirstName           NVARCHAR(50) NOT NULL,
    LastName            NVARCHAR(50) NOT NULL,
    Email               VARCHAR(150) NOT NULL,
    Phone               VARCHAR(30) NULL,
    DateOfBirth         DATE NULL,
    HireDate            DATE NOT NULL
        CONSTRAINT DF_Employees_HireDate DEFAULT (CONVERT(DATE, GETDATE())),

    DepartmentID        INT NOT NULL,
    JobID               INT NOT NULL,

    -- Self-referencing FK will be added later
    ManagerID           INT NULL,

    BranchID            INT NOT NULL,

    EmploymentStatus    VARCHAR(20) NOT NULL
        CONSTRAINT DF_Employees_EmploymentStatus DEFAULT ('Active'),

    CONSTRAINT PK_Employees
        PRIMARY KEY (EmployeeID)
);
GO


/*====================================================================
  8. EMPLOYEE SALARY HISTORY
====================================================================*/

CREATE TABLE dbo.EmployeeSalaryHistory
(
    SalaryHistoryID       BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeID            INT NOT NULL,
    Salary                DECIMAL(18,2) NOT NULL,
    EffectiveFrom         DATE NOT NULL,
    EffectiveTo           DATE NULL,
    Reason                NVARCHAR(250) NULL,

    -- FK to Employees will be added in 03_Constraints.sql
    ApprovedByEmployeeID  INT NULL,

    CONSTRAINT PK_EmployeeSalaryHistory
        PRIMARY KEY (SalaryHistoryID)
);
GO


/*====================================================================
  9. ATTENDANCE
====================================================================*/

CREATE TABLE dbo.Attendance
(
    AttendanceID       BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeID         INT NOT NULL,
    AttendanceDate     DATE NOT NULL,
    CheckIn            TIME(0) NULL,
    CheckOut           TIME(0) NULL,

    Status             VARCHAR(20) NOT NULL,

    WorkingHours      DECIMAL(5,2) NULL,

    CONSTRAINT PK_Attendance
        PRIMARY KEY (AttendanceID)
);
GO


/*====================================================================
  10. EMPLOYEE LEAVES
====================================================================*/

CREATE TABLE dbo.EmployeeLeaves
(
    LeaveID               BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeID            INT NOT NULL,
    LeaveTypeID           INT NOT NULL,
    StartDate             DATE NOT NULL,
    EndDate               DATE NOT NULL,
    Reason                NVARCHAR(500) NULL,

    Status                VARCHAR(20) NOT NULL
        CONSTRAINT DF_EmployeeLeaves_Status DEFAULT ('Pending'),

    ApprovedByEmployeeID  INT NULL,

    CONSTRAINT PK_EmployeeLeaves
        PRIMARY KEY (LeaveID)
);
GO


/*====================================================================
  11. BONUSES
====================================================================*/

CREATE TABLE dbo.Bonuses
(
    BonusID               BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeID            INT NOT NULL,
    BonusTypeID           INT NOT NULL,
    Amount                DECIMAL(18,2) NOT NULL,
    BonusDate             DATE NOT NULL,
    Reason                NVARCHAR(250) NULL,
    ApprovedByEmployeeID  INT NULL,

    Status                VARCHAR(20) NOT NULL
        CONSTRAINT DF_Bonuses_Status DEFAULT ('Pending'),

    CONSTRAINT PK_Bonuses
        PRIMARY KEY (BonusID)
);
GO


/*====================================================================
  12. DEDUCTIONS
====================================================================*/

CREATE TABLE dbo.Deductions
(
    DeductionID          BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeID           INT NOT NULL,
    DeductionTypeID      INT NOT NULL,
    Amount               DECIMAL(18,2) NOT NULL,
    DeductionDate        DATE NOT NULL,
    Reason               NVARCHAR(250) NULL,

    CONSTRAINT PK_Deductions
        PRIMARY KEY (DeductionID)
);
GO


/*====================================================================
  13. PAYROLL PERIODS
====================================================================*/

CREATE TABLE dbo.PayrollPeriods
(
    PayrollPeriodID      INT IDENTITY(1,1) NOT NULL,
    PeriodStartDate      DATE NOT NULL,
    PeriodEndDate        DATE NOT NULL,

    PayrollStatus        VARCHAR(20) NOT NULL
        CONSTRAINT DF_PayrollPeriods_Status DEFAULT ('Open'),

    ProcessedDate        DATETIME2(0) NULL,

    CONSTRAINT PK_PayrollPeriods
        PRIMARY KEY (PayrollPeriodID)
);
GO


/*====================================================================
  14. PAYROLL
====================================================================*/

CREATE TABLE dbo.Payroll
(
    PayrollID             BIGINT IDENTITY(1,1) NOT NULL,
    EmployeeID            INT NOT NULL,
    PayrollPeriodID       INT NOT NULL,

    BasicSalary            DECIMAL(18,2) NOT NULL,
    Overtime               DECIMAL(18,2) NOT NULL,
    Bonuses                DECIMAL(18,2) NOT NULL,
    Deductions             DECIMAL(18,2) NOT NULL,

    -- Historical payroll snapshot
    NetSalary              DECIMAL(18,2) NOT NULL,

    PayrollStatus          VARCHAR(20) NOT NULL
        CONSTRAINT DF_Payroll_Status DEFAULT ('Pending'),

    ProcessedDate          DATETIME2(0) NULL,

    CONSTRAINT PK_Payroll
        PRIMARY KEY (PayrollID)
);
GO


/*====================================================================
  15. PAYROLL PAYMENTS
====================================================================*/

CREATE TABLE dbo.PayrollPayments
(
    PaymentID              BIGINT IDENTITY(1,1) NOT NULL,
    PayrollID              BIGINT NOT NULL,

    PaymentDate            DATETIME2(0) NOT NULL,
    PaymentMethod          VARCHAR(30) NOT NULL,
    Amount                 DECIMAL(18,2) NOT NULL,

    PaymentStatus          VARCHAR(20) NOT NULL
        CONSTRAINT DF_PayrollPayments_Status DEFAULT ('Pending'),

    TransactionReference   VARCHAR(100) NULL,

    CONSTRAINT PK_PayrollPayments
        PRIMARY KEY (PaymentID)
);
GO


/*====================================================================
  16. AUDIT LOGS
====================================================================*/

CREATE TABLE dbo.AuditLogs
(
    AuditID        BIGINT IDENTITY(1,1) NOT NULL,

    UserName       NVARCHAR(128) NOT NULL,
    Action         VARCHAR(30) NOT NULL,
    TableName      SYSNAME NOT NULL,

    RecordID       VARCHAR(100) NULL,

    OldValue       NVARCHAR(MAX) NULL,
    NewValue       NVARCHAR(MAX) NULL,

    ActionDate     DATETIME2(0) NOT NULL
        CONSTRAINT DF_AuditLogs_ActionDate DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_AuditLogs
        PRIMARY KEY (AuditID)
);
GO


/*====================================================================
  VALIDATION
====================================================================*/

PRINT '=============================================================';
PRINT 'EHRPMS TABLE CREATION COMPLETED';
PRINT '=============================================================';
GO


/*====================================================================
  VERIFY CREATED TABLES
====================================================================*/

SELECT
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName
FROM sys.tables AS t
WHERE t.schema_id = SCHEMA_ID('dbo')
ORDER BY t.name;
GO


/*====================================================================
  VERIFY PRIMARY KEYS
====================================================================*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
GO