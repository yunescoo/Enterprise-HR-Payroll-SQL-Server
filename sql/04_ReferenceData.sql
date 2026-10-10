/*
=====================================================================
    Enterprise HR & Payroll Management System (EHRPMS)

    Script: 04_ReferenceData.sql

    Purpose:
        Populate controlled/reference data used by the HR system.

    Data:
        - 20 Branches
        - 30 Departments
        - 100 Jobs
        - 5 Leave Types
        - 10 Bonus Types
        - 10 Deduction Types
        - 12 Payroll Periods

    IMPORTANT:
        This script assumes a fresh EHRPMS database.

=====================================================================
*/

USE EHRPMS;
GO

SET NOCOUNT ON;
GO

/*====================================================================
  1. BRANCHES
====================================================================*/

PRINT '1. Inserting branches...';
GO

INSERT INTO dbo.Branches
(
    BranchName,
    City,
    Country,
    Address
)
VALUES
('Cairo Head Office',       'Cairo',        'Egypt',          'Nile Business District, Cairo'),
('Alexandria Branch',       'Alexandria',   'Egypt',          'Corniche Road, Alexandria'),
('Giza Branch',             'Giza',         'Egypt',          'Pyramids Business Area, Giza'),
('Ismailia Branch',         'Ismailia',     'Egypt',          'El-Gomhoria Street, Ismailia'),
('Mansoura Branch',         'Mansoura',     'Egypt',          'El-Mashaya Street, Mansoura'),
('Port Said Branch',        'Port Said',    'Egypt',          'Port Said Business District'),
('Aswan Branch',            'Aswan',        'Egypt',          'Nile Street, Aswan'),
('Dubai Branch',             'Dubai',        'UAE',            'Business Bay, Dubai'),
('Abu Dhabi Branch',         'Abu Dhabi',    'UAE',            'Al Maryah Island, Abu Dhabi'),
('Sharjah Branch',           'Sharjah',      'UAE',            'Al Majaz, Sharjah'),
('Riyadh Branch',            'Riyadh',       'Saudi Arabia',   'King Fahd Road, Riyadh'),
('Jeddah Branch',            'Jeddah',       'Saudi Arabia',   'Tahlia Street, Jeddah'),
('Dammam Branch',            'Dammam',       'Saudi Arabia',   'King Saud Street, Dammam'),
('Doha Branch',              'Doha',         'Qatar',          'West Bay, Doha'),
('Kuwait City Branch',       'Kuwait City',  'Kuwait',         'Kuwait City Financial District'),
('Muscat Branch',            'Muscat',       'Oman',            'Al Khuwair Business District'),
('Amman Branch',             'Amman',        'Jordan',         'Abdali Business District'),
('London Branch',            'London',       'United Kingdom', 'Canary Wharf, London'),
('Frankfurt Branch',         'Frankfurt',    'Germany',        'Financial District, Frankfurt'),
('Amsterdam Branch',         'Amsterdam',    'Netherlands',    'Zuidas Business District');

PRINT '20 branches inserted.';
GO


/*====================================================================
  2. DEPARTMENTS
====================================================================*/

PRINT '2. Inserting departments...';
GO

INSERT INTO dbo.Departments
(
    DepartmentName,
    DepartmentCode,
    ManagerID
)
VALUES
('Information Technology',       'IT',       NULL),
('Human Resources',              'HR',       NULL),
('Finance',                      'FIN',      NULL),
('Accounting',                   'ACC',      NULL),
('Sales',                        'SALES',    NULL),
('Marketing',                    'MKT',      NULL),
('Operations',                   'OPS',      NULL),
('Customer Service',             'CS',       NULL),
('Legal',                        'LEGAL',    NULL),
('Procurement',                  'PROC',     NULL),
('Risk Management',              'RISK',     NULL),
('Compliance',                   'COMP',     NULL),
('Internal Audit',               'AUDIT',    NULL),
('Information Security',         'SEC',      NULL),
('Data & Analytics',             'DATA',     NULL),
('Software Engineering',         'SWE',      NULL),
('Infrastructure & Cloud',       'CLOUD',    NULL),
('Database Administration',      'DBA',      NULL),
('Quality Assurance',            'QA',       NULL),
('Project Management',           'PMO',      NULL),
('Research & Development',       'RND',      NULL),
('Business Development',         'BD',       NULL),
('Product Management',           'PROD',     NULL),
('Supply Chain',                 'SCM',      NULL),
('Administration',               'ADMIN',    NULL),
('Facilities Management',        'FAC',      NULL),
('Training & Development',       'LND',      NULL),
('Payroll',                      'PAY',      NULL),
('Treasury',                     'TREAS',    NULL),
('Corporate Strategy',           'STRAT',    NULL);

PRINT '30 departments inserted.';
GO


/*====================================================================
  3. LEAVE TYPES
====================================================================*/

PRINT '3. Inserting leave types...';
GO

INSERT INTO dbo.LeaveTypes
(
    LeaveTypeName,
    MaxDaysPerYear
)
VALUES
('Annual Leave',        21),
('Sick Leave',          15),
('Emergency Leave',      5),
('Unpaid Leave',        30),
('Maternity Leave',     90);

PRINT '5 leave types inserted.';
GO


/*====================================================================
  4. BONUS TYPES
====================================================================*/

PRINT '4. Inserting bonus types...';
GO

INSERT INTO dbo.BonusTypes
(
    BonusTypeName,
    Description
)
VALUES
('Performance Bonus',
    'Award for exceeding individual performance targets.'),

('Annual Bonus',
    'Year-end bonus based on company and employee performance.'),

('Sales Commission',
    'Commission awarded for achieving sales targets.'),

('Project Completion Bonus',
    'Bonus for successfully completing major projects.'),

('Innovation Bonus',
    'Reward for introducing valuable improvements or innovations.'),

('Employee of the Month',
    'Recognition award for outstanding monthly performance.'),

('Referral Bonus',
    'Bonus for successful employee referrals.'),

('Retention Bonus',
    'Bonus provided to retain critical employees.'),

('Overtime Bonus',
    'Additional compensation for approved exceptional overtime.'),

('Special Achievement Bonus',
    'Reward for exceptional business or technical achievement.');

PRINT '10 bonus types inserted.';
GO


/*====================================================================
  5. DEDUCTION TYPES
====================================================================*/

PRINT '5. Inserting deduction types...';
GO

INSERT INTO dbo.DeductionTypes
(
    DeductionTypeName,
    Description
)
VALUES
('Income Tax',
    'Government income tax deduction.'),

('Social Insurance',
    'Employee social insurance contribution.'),

('Health Insurance',
    'Employee health insurance contribution.'),

('Late Penalty',
    'Deduction resulting from repeated lateness.'),

('Unpaid Leave',
    'Salary deduction for approved unpaid leave.'),

('Loan Deduction',
    'Payroll deduction for employee loan repayment.'),

('Absence Penalty',
    'Deduction for unauthorized absence.'),

('Salary Advance',
    'Recovery of previously issued salary advance.'),

('Other Deduction',
    'Other approved payroll deduction.'),

('Benefits Adjustment',
    'Adjustment related to employee benefits.');

PRINT '10 deduction types inserted.';
GO


/*====================================================================
  6. JOB POSITIONS
====================================================================*/

PRINT '6. Inserting job positions...';
GO

INSERT INTO dbo.Jobs
(
    JobTitle,
    JobLevel,
    MinSalary,
    MaxSalary,
    DepartmentID
)
VALUES

/*--------------------------------------------------------------------
  INFORMATION TECHNOLOGY
--------------------------------------------------------------------*/

('IT Support Specialist',             'Junior',       7000,  12000, 1),
('IT Support Engineer',               'Mid',         12000,  20000, 1),
('IT Systems Analyst',                'Mid',         15000,  25000, 1),
('IT Manager',                        'Manager',     28000,  50000, 1),

/*--------------------------------------------------------------------
  HUMAN RESOURCES
--------------------------------------------------------------------*/

('HR Assistant',                      'Junior',       6000,  10000, 2),
('HR Specialist',                     'Mid',         10000,  18000, 2),
('Senior HR Specialist',              'Senior',      18000,  28000, 2),
('HR Manager',                        'Manager',     28000,  50000, 2),

/*--------------------------------------------------------------------
  FINANCE
--------------------------------------------------------------------*/

('Financial Analyst',                 'Junior',       9000,  15000, 3),
('Senior Financial Analyst',           'Senior',      17000,  28000, 3),
('Finance Manager',                   'Manager',     30000,  55000, 3),
('Financial Controller',              'Director',    45000,  75000, 3),

/*--------------------------------------------------------------------
  ACCOUNTING
--------------------------------------------------------------------*/

('Junior Accountant',                 'Junior',       6500,  10000, 4),
('Accountant',                        'Mid',         10000,  18000, 4),
('Senior Accountant',                 'Senior',      18000,  30000, 4),
('Accounting Manager',                'Manager',     30000,  55000, 4),

/*--------------------------------------------------------------------
  SALES
--------------------------------------------------------------------*/

('Sales Representative',              'Junior',       7000,  12000, 5),
('Senior Sales Representative',        'Senior',      12000,  22000, 5),
('Sales Supervisor',                  'Lead',        20000,  32000, 5),
('Sales Manager',                     'Manager',     30000,  55000, 5),

/*--------------------------------------------------------------------
  MARKETING
--------------------------------------------------------------------*/

('Marketing Coordinator',             'Junior',       7000,  12000, 6),
('Digital Marketing Specialist',      'Mid',         12000,  22000, 6),
('Marketing Analyst',                 'Mid',         13000,  23000, 6),
('Marketing Manager',                 'Manager',     28000,  50000, 6),

/*--------------------------------------------------------------------
  OPERATIONS
--------------------------------------------------------------------*/

('Operations Coordinator',            'Junior',       7000,  12000, 7),
('Operations Analyst',                'Mid',         12000,  22000, 7),
('Operations Supervisor',             'Lead',        20000,  32000, 7),
('Operations Manager',                'Manager',     30000,  55000, 7),

/*--------------------------------------------------------------------
  CUSTOMER SERVICE
--------------------------------------------------------------------*/

('Customer Service Representative',   'Junior',       6000,  10000, 8),
('Senior Customer Service Agent',     'Senior',      10000,  17000, 8),
('Customer Service Supervisor',       'Lead',        17000,  28000, 8),
('Customer Service Manager',          'Manager',     28000,  48000, 8),

/*--------------------------------------------------------------------
  LEGAL
--------------------------------------------------------------------*/

('Legal Assistant',                   'Junior',       8000,  13000, 9),
('Legal Specialist',                  'Mid',         13000,  23000, 9),
('Corporate Lawyer',                  'Senior',      22000,  40000, 9),
('Legal Manager',                     'Manager',     35000,  60000, 9),

/*--------------------------------------------------------------------
  PROCUREMENT
--------------------------------------------------------------------*/

('Procurement Officer',               'Junior',       7000,  12000, 10),
('Senior Procurement Officer',        'Senior',      12000,  22000, 10),
('Procurement Analyst',               'Mid',         13000,  24000, 10),
('Procurement Manager',               'Manager',     28000,  50000, 10),

/*--------------------------------------------------------------------
  RISK MANAGEMENT
--------------------------------------------------------------------*/

('Risk Analyst',                      'Junior',       9000,  15000, 11),
('Senior Risk Analyst',               'Senior',      16000,  28000, 11),
('Risk Specialist',                   'Senior',      18000,  30000, 11),
('Risk Manager',                      'Manager',     32000,  58000, 11),

/*--------------------------------------------------------------------
  COMPLIANCE
--------------------------------------------------------------------*/

('Compliance Officer',                'Junior',       8000,  14000, 12),
('Compliance Specialist',             'Mid',         14000,  24000, 12),
('Senior Compliance Officer',         'Senior',      22000,  35000, 12),
('Compliance Manager',                'Manager',     32000,  58000, 12),

/*--------------------------------------------------------------------
  INTERNAL AUDIT
--------------------------------------------------------------------*/

('Internal Audit Associate',          'Junior',       8000,  14000, 13),
('Internal Auditor',                  'Mid',         14000,  24000, 13),
('Senior Internal Auditor',           'Senior',      22000,  35000, 13),
('Internal Audit Manager',            'Manager',     32000,  58000, 13),

/*--------------------------------------------------------------------
  INFORMATION SECURITY
--------------------------------------------------------------------*/

('Cybersecurity Analyst',             'Junior',      10000,  18000, 14),
('Security Engineer',                 'Mid',         17000,  30000, 14),
('Security Architect',                'Senior',      28000,  48000, 14),
('Information Security Manager',      'Manager',     35000,  65000, 14),

/*--------------------------------------------------------------------
  DATA & ANALYTICS
--------------------------------------------------------------------*/

('Junior Data Analyst',               'Junior',       9000,  15000, 15),
('Data Analyst',                      'Mid',         14000,  24000, 15),
('Data Engineer',                     'Mid',         18000,  30000, 15),
('Senior Data Scientist',             'Senior',      25000,  45000, 15),

/*--------------------------------------------------------------------
  SOFTWARE ENGINEERING
--------------------------------------------------------------------*/

('Junior Software Engineer',          'Junior',      10000,  17000, 16),
('Software Engineer',                 'Mid',         17000,  28000, 16),
('Senior Software Engineer',          'Senior',      26000,  42000, 16),
('Software Engineering Manager',      'Manager',     40000,  70000, 16),

/*--------------------------------------------------------------------
  INFRASTRUCTURE & CLOUD
--------------------------------------------------------------------*/

('System Administrator',              'Junior',       9000,  16000, 17),
('Network Engineer',                  'Mid',         14000,  25000, 17),
('Cloud Engineer',                    'Mid',         18000,  30000, 17),
('Cloud Infrastructure Manager',      'Manager',     35000,  62000, 17),

/*--------------------------------------------------------------------
  DATABASE ADMINISTRATION
--------------------------------------------------------------------*/

('Junior Database Administrator',     'Junior',      10000,  17000, 18),
('SQL Server Database Administrator', 'Mid',         18000,  30000, 18),
('Senior Database Administrator',     'Senior',      28000,  45000, 18),
('Database Manager',                  'Manager',     38000,  65000, 18),

/*--------------------------------------------------------------------
  QUALITY ASSURANCE
--------------------------------------------------------------------*/

('QA Tester',                         'Junior',       8000,  14000, 19),
('QA Engineer',                       'Mid',         14000,  24000, 19),
('Senior QA Engineer',                'Senior',      22000,  35000, 19),
('QA Manager',                        'Manager',     32000,  55000, 19),

/*--------------------------------------------------------------------
  PROJECT MANAGEMENT
--------------------------------------------------------------------*/

('Project Coordinator',               'Junior',       9000,  15000, 20),
('Project Manager',                   'Mid',         18000,  32000, 20),
('Senior Project Manager',            'Senior',      28000,  45000, 20),
('Program Manager',                   'Manager',     40000,  70000, 20),

/*--------------------------------------------------------------------
  RESEARCH & DEVELOPMENT
--------------------------------------------------------------------*/

('Research Assistant',                'Junior',       8000,  14000, 21),
('Research Analyst',                  'Mid',         14000,  24000, 21),
('Research Engineer',                 'Senior',      22000,  38000, 21),
('R&D Manager',                       'Manager',     32000,  58000, 21),

/*--------------------------------------------------------------------
  BUSINESS DEVELOPMENT
--------------------------------------------------------------------*/

('Business Development Associate',    'Junior',       8000,  14000, 22),
('Business Development Executive',    'Mid',         14000,  25000, 22),
('Senior Business Development Executive',
                                       'Senior',      22000,  38000, 22),
('Business Development Manager',      'Manager',     32000,  60000, 22),

/*--------------------------------------------------------------------
  PRODUCT MANAGEMENT
--------------------------------------------------------------------*/

('Product Analyst',                   'Junior',      10000,  17000, 23),
('Product Specialist',                'Mid',         16000,  28000, 23),
('Product Manager',                   'Senior',      25000,  42000, 23),
('Senior Product Manager',            'Manager',     35000,  65000, 23),

/*--------------------------------------------------------------------
  SUPPLY CHAIN
--------------------------------------------------------------------*/

('Supply Chain Coordinator',          'Junior',       7000,  12000, 24),
('Supply Chain Analyst',              'Mid',         12000,  22000, 24),
('Supply Chain Specialist',           'Senior',      18000,  30000, 24),
('Supply Chain Manager',              'Manager',     30000,  55000, 24),

/*--------------------------------------------------------------------
  ADMINISTRATION
--------------------------------------------------------------------*/

('Administrative Assistant',          'Junior',       6000,  10000, 25),
('Administrative Officer',            'Mid',         10000,  17000, 25),
('Senior Administrative Officer',     'Senior',      16000,  26000, 25),
('Administration Manager',            'Manager',     26000,  45000, 25),

/*--------------------------------------------------------------------
  FACILITIES
--------------------------------------------------------------------*/

('Facilities Coordinator',            'Junior',       7000,  12000, 26),
('Facilities Engineer',               'Mid',         12000,  22000, 26),
('Facilities Supervisor',             'Senior',      18000,  30000, 26),
('Facilities Manager',                'Manager',     28000,  50000, 26),

/*--------------------------------------------------------------------
  TRAINING & DEVELOPMENT
--------------------------------------------------------------------*/

('Training Coordinator',              'Junior',       7000,  12000, 27),
('Learning Specialist',               'Mid',         12000,  22000, 27),
('Training Manager',                  'Manager',     26000,  48000, 27),

/*--------------------------------------------------------------------
  PAYROLL
--------------------------------------------------------------------*/

('Payroll Specialist',                'Junior',       8000,  14000, 28),
('Senior Payroll Specialist',         'Senior',      14000,  24000, 28),
('Payroll Supervisor',                'Lead',        20000,  32000, 28),
('Payroll Manager',                   'Manager',     30000,  55000, 28),

/*--------------------------------------------------------------------
  TREASURY
--------------------------------------------------------------------*/

('Treasury Analyst',                 'Junior',      10000,  17000, 29),
('Treasury Specialist',              'Mid',         16000,  28000, 29),
('Senior Treasury Analyst',           'Senior',      24000,  40000, 29),
('Treasury Manager',                  'Manager',     35000,  62000, 29),

/*--------------------------------------------------------------------
  CORPORATE STRATEGY
--------------------------------------------------------------------*/

('Strategy Analyst',                  'Junior',      12000,  20000, 30),
('Business Strategy Analyst',         'Mid',         18000,  30000, 30),
('Senior Strategy Consultant',        'Senior',      28000,  45000, 30),
('Corporate Strategy Manager',         'Manager',     40000,  70000, 30);

PRINT 'Job positions inserted.';
GO


/*====================================================================
  7. PAYROLL PERIODS
====================================================================*/

PRINT '7. Inserting payroll periods...';
GO

INSERT INTO dbo.PayrollPeriods
(
    PeriodStartDate,
    PeriodEndDate,
    PayrollStatus,
    ProcessedDate
)
VALUES
('2026-01-01', '2026-01-31', 'Processed', '2026-02-01 09:00:00'),
('2026-02-01', '2026-02-28', 'Processed', '2026-03-01 09:00:00'),
('2026-03-01', '2026-03-31', 'Processed', '2026-04-01 09:00:00'),
('2026-04-01', '2026-04-30', 'Processed', '2026-05-01 09:00:00'),
('2026-05-01', '2026-05-31', 'Processed', '2026-06-01 09:00:00'),
('2026-06-01', '2026-06-30', 'Processed', '2026-07-01 09:00:00'),
('2026-07-01', '2026-07-31', 'Processed', '2026-08-01 09:00:00'),
('2026-08-01', '2026-08-31', 'Processed', '2026-09-01 09:00:00'),
('2026-09-01', '2026-09-30', 'Open',      NULL),
('2026-10-01', '2026-10-31', 'Open',      NULL),
('2026-11-01', '2026-11-30', 'Open',      NULL),
('2026-12-01', '2026-12-31', 'Open',      NULL);

PRINT '12 payroll periods inserted.';
GO


/*====================================================================
  8. VALIDATION
====================================================================*/

PRINT '=============================================================';
PRINT 'REFERENCE DATA VALIDATION';
PRINT '=============================================================';
GO


/* Branch count */

SELECT
    'Branches' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.Branches;


/* Department count */

SELECT
    'Departments' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.Departments;


/* Job count */

SELECT
    'Jobs' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.Jobs;


/* Leave types */

SELECT
    'Leave Types' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.LeaveTypes;


/* Bonus types */

SELECT
    'Bonus Types' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.BonusTypes;


/* Deduction types */

SELECT
    'Deduction Types' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.DeductionTypes;


/* Payroll periods */

SELECT
    'Payroll Periods' AS DataSet,
    COUNT(*) AS RecordCount
FROM dbo.PayrollPeriods;
GO


/*====================================================================
  9. REFERENCE DATA REPORT
====================================================================*/

SELECT
    DepartmentID,
    DepartmentCode,
    DepartmentName
FROM dbo.Departments
ORDER BY DepartmentID;
GO


SELECT
    JobID,
    JobTitle,
    JobLevel,
    MinSalary,
    MaxSalary,
    DepartmentID
FROM dbo.Jobs
ORDER BY DepartmentID, JobID;
GO


SELECT
    BranchID,
    BranchName,
    City,
    Country
FROM dbo.Branches
ORDER BY BranchID;
GO

