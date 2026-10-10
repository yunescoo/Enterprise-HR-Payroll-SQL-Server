USE EHRPMS;
GO

SET NOCOUNT ON;
GO

/* ============================================================
   PROJECT 7
   Enterprise HR & Payroll Management System
   PHASE 11 - SECURITY
   ============================================================ */


/* ============================================================
   1. CREATE DATABASE ROLES
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'HR_Admin'
      AND type = 'R'
)
BEGIN
    CREATE ROLE HR_Admin;
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'HR_Manager'
      AND type = 'R'
)
BEGIN
    CREATE ROLE HR_Manager;
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'Payroll_Officer'
      AND type = 'R'
)
BEGIN
    CREATE ROLE Payroll_Officer;
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'Auditor'
      AND type = 'R'
)
BEGIN
    CREATE ROLE Auditor;
END;
GO


/* ============================================================
   2. CREATE DEMONSTRATION DATABASE USERS
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'HRAdminUser'
)
BEGIN
    CREATE USER HRAdminUser WITHOUT LOGIN;
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'HRManagerUser'
)
BEGIN
    CREATE USER HRManagerUser WITHOUT LOGIN;
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'PayrollOfficerUser'
)
BEGIN
    CREATE USER PayrollOfficerUser WITHOUT LOGIN;
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'AuditorUser'
)
BEGIN
    CREATE USER AuditorUser WITHOUT LOGIN;
END;
GO


/* ============================================================
   3. ADD USERS TO ROLES
   ============================================================ */

ALTER ROLE HR_Admin
ADD MEMBER HRAdminUser;
GO

ALTER ROLE HR_Manager
ADD MEMBER HRManagerUser;
GO

ALTER ROLE Payroll_Officer
ADD MEMBER PayrollOfficerUser;
GO

ALTER ROLE Auditor
ADD MEMBER AuditorUser;
GO


/* ============================================================
   4. HR ADMIN PERMISSIONS
   ============================================================ */

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Employees
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.EmployeeSalaryHistory
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.EmployeeLeaves
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Attendance
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Bonuses
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Deductions
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Departments
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Branches
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Jobs
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.LeaveTypes
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.BonusTypes
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.DeductionTypes
TO HR_Admin;

GRANT SELECT
ON dbo.AuditLogs
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.PayrollPeriods
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.Payroll
TO HR_Admin;

GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.PayrollPayments
TO HR_Admin;
GO


/* ============================================================
   5. HR MANAGER PERMISSIONS
   ============================================================ */

GRANT SELECT, INSERT, UPDATE
ON dbo.Employees
TO HR_Manager;

GRANT SELECT
ON dbo.Departments
TO HR_Manager;

GRANT SELECT
ON dbo.Branches
TO HR_Manager;

GRANT SELECT
ON dbo.Jobs
TO HR_Manager;

GRANT SELECT, INSERT, UPDATE
ON dbo.EmployeeLeaves
TO HR_Manager;

GRANT SELECT
ON dbo.LeaveTypes
TO HR_Manager;

GRANT SELECT
ON dbo.Attendance
TO HR_Manager;

GRANT SELECT
ON dbo.Bonuses
TO HR_Manager;

GRANT SELECT
ON dbo.Deductions
TO HR_Manager;
GO


/* ============================================================
   6. PAYROLL OFFICER PERMISSIONS
   ============================================================ */

GRANT SELECT
ON dbo.Employees
TO Payroll_Officer;

GRANT SELECT
ON dbo.EmployeeSalaryHistory
TO Payroll_Officer;

GRANT SELECT
ON dbo.Bonuses
TO Payroll_Officer;

GRANT SELECT
ON dbo.Deductions
TO Payroll_Officer;

GRANT SELECT, INSERT, UPDATE
ON dbo.PayrollPeriods
TO Payroll_Officer;

GRANT SELECT, INSERT, UPDATE
ON dbo.Payroll
TO Payroll_Officer;

GRANT SELECT, INSERT, UPDATE
ON dbo.PayrollPayments
TO Payroll_Officer;
GO


/* ============================================================
   7. AUDITOR PERMISSIONS
   ============================================================ */

GRANT SELECT
ON dbo.Employees
TO Auditor;

GRANT SELECT
ON dbo.Departments
TO Auditor;

GRANT SELECT
ON dbo.Branches
TO Auditor;

GRANT SELECT
ON dbo.Jobs
TO Auditor;

GRANT SELECT
ON dbo.Attendance
TO Auditor;

GRANT SELECT
ON dbo.EmployeeLeaves
TO Auditor;

GRANT SELECT
ON dbo.EmployeeSalaryHistory
TO Auditor;

GRANT SELECT
ON dbo.Bonuses
TO Auditor;

GRANT SELECT
ON dbo.Deductions
TO Auditor;

GRANT SELECT
ON dbo.PayrollPeriods
TO Auditor;

GRANT SELECT
ON dbo.Payroll
TO Auditor;

GRANT SELECT
ON dbo.PayrollPayments
TO Auditor;

GRANT SELECT
ON dbo.AuditLogs
TO Auditor;
GO


/* ============================================================
   8. PROCEDURE EXECUTION PERMISSIONS
   ============================================================ */

GRANT EXECUTE
ON dbo.usp_GetEmployeeDetails
TO HR_Manager, Payroll_Officer, Auditor;

GRANT EXECUTE
ON dbo.usp_AddEmployee
TO HR_Admin, HR_Manager;

GRANT EXECUTE
ON dbo.usp_UpdateEmployeeStatus
TO HR_Admin, HR_Manager;

GRANT EXECUTE
ON dbo.usp_ChangeEmployeeSalary
TO HR_Admin;

GRANT EXECUTE
ON dbo.usp_RequestLeave
TO HR_Manager;

GRANT EXECUTE
ON dbo.usp_ApproveLeave
TO HR_Manager;

GRANT EXECUTE
ON dbo.usp_AddBonus
TO HR_Admin, HR_Manager;

GRANT EXECUTE
ON dbo.usp_AddDeduction
TO HR_Admin, Payroll_Officer;

GRANT EXECUTE
ON dbo.usp_ProcessPayroll
TO HR_Admin, Payroll_Officer;

GRANT EXECUTE
ON dbo.usp_RecordPayrollPayment
TO HR_Admin, Payroll_Officer;
GO


/* ============================================================
   9. VIEW PERMISSIONS
   ============================================================ */

GRANT SELECT
ON dbo.vw_EmployeeDirectory
TO HR_Manager, Auditor;

GRANT SELECT
ON dbo.vw_CurrentEmployeeSalary
TO HR_Admin, Payroll_Officer;

GRANT SELECT
ON dbo.vw_EmployeeSalaryHistory
TO HR_Admin, Payroll_Officer, Auditor;

GRANT SELECT
ON dbo.vw_AttendanceSummary
TO HR_Manager, Auditor;

GRANT SELECT
ON dbo.vw_EmployeeLeaveSummary
TO HR_Manager, Auditor;

GRANT SELECT
ON dbo.vw_EmployeeBonuses
TO HR_Admin, Payroll_Officer, Auditor;

GRANT SELECT
ON dbo.vw_EmployeeDeductions
TO HR_Admin, Payroll_Officer, Auditor;

GRANT SELECT
ON dbo.vw_PayrollDetails
TO HR_Admin, Payroll_Officer, Auditor;

GRANT SELECT
ON dbo.vw_MonthlyPayrollSummary
TO HR_Admin, Payroll_Officer, Auditor;

GRANT SELECT
ON dbo.vw_PaymentStatus
TO HR_Admin, Payroll_Officer, Auditor;
GO


-- Inspect Permissions

SELECT
    DP.name AS PrincipalName,
    DP.type_desc AS PrincipalType,
    P.permission_name,
    P.state_desc,
    OBJECT_SCHEMA_NAME(P.major_id) AS SchemaName,
    OBJECT_NAME(P.major_id) AS ObjectName
FROM sys.database_principals AS DP
LEFT JOIN sys.database_permissions AS P
    ON DP.principal_id = P.grantee_principal_id
WHERE DP.name IN
(
    'HR_Admin',
    'HR_Manager',
    'Payroll_Officer',
    'Auditor'
)
ORDER BY
    DP.name,
    ObjectName,
    P.permission_name;