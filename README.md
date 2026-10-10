# Enterprise HR & Payroll Management System (EHRPMS)

 project for managing employee information, organizational structure, attendance, leave requests, salary history, bonuses, deductions, payroll processing, payroll payments, auditing, and management reporting.


## Overview

EHRPMS models the main data flows of a medium-to-large organization with multiple branches and departments. It separates employee records from salary history, payroll calculation from payroll payments, and transactional records from reference data. The database is designed to demonstrate relational modeling and practical T-SQL techniques that are relevant to SQL development and junior database administration.

The repository is intended as a learning and portfolio project. It is **not a certified, production-ready payroll platform** and should not be used to process real employee or financial data without additional security, legal, accounting, and operational reviews.

## Business Problem

HR and finance teams need consistent records for employees, jobs, managers, attendance, leave, compensation, payroll periods, and payments. When these processes are maintained in disconnected files, organizations can face duplicate records, inconsistent calculations, weak auditability, and time-consuming reporting.

This project provides a centralized relational data model and T-SQL examples for answering common operational and management questions.

## Objectives

- Design a relational schema with clear primary and foreign key relationships.
- Apply normalization principles and data-integrity constraints.
- Model salary history instead of overwriting historical compensation data.
- Separate payroll calculations from payment transactions.
- Implement reusable views, functions, and stored procedures.
- Demonstrate transaction handling, error handling, and triggers.
- Model role-based access control and audit logging.
- Generate synthetic sample data for repeatable testing.
- Produce HR, payroll, attendance, and management reports.
- Provide a foundation for indexing and performance-analysis exercises.

## Scope and Features

### Employee and organization management

- Branches, departments, and job positions
- Employee records and manager relationships
- Employee employment status
- Salary history with effective dates and approval references

### HR operations

- Attendance records and working-hour summaries
- Leave types, leave requests, approval status, and leave reporting
- Bonus types and bonus records
- Deduction types and deduction records

### Payroll

- Payroll periods and processing statuses
- Payroll records with basic salary, overtime, bonuses, deductions, and net salary
- Separate payroll payment records and payment statuses
- Reports for payroll cost, outstanding payments, and departmental expenses

### Governance and reporting

- Audit log records
- Database roles and permissions
- Views, functions, stored procedures, and triggers
- Business queries for HR, payroll, and management

## Technology Stack

- **Database:** Microsoft SQL Server
- **Query language:** T-SQL
- **Database client:** SQL Server Management Studio (SSMS) 
- **Version control:** Git and GitHub
- **Documentation/diagrams:** Markdown and ERD/architecture diagrams

## Architecture

The schema is organized into logical groups:

| Group | Tables | Purpose |
|---|---|---|
| Organization/reference | `Branches`, `Departments`, `Jobs`, `LeaveTypes`, `BonusTypes`, `DeductionTypes` | Stores organizational and classification data |
| Employee core | `Employees` | Stores employee details and reporting relationships |
| HR operations | `Attendance`, `EmployeeLeaves`, `EmployeeSalaryHistory`, `Bonuses`, `Deductions` | Stores dated employee activity and compensation-related records |
| Payroll | `PayrollPeriods`, `Payroll`, `PayrollPayments` | Separates period processing, payroll calculations, and payments |
| Governance | `AuditLogs` | Stores audit events captured by database logic |

The planned model contains 16 tables. See [`docs/ERD.png`](docs/ERD.png) and [`docs/Database-Architecture.png`](docs/Database-Architecture.png) when those diagram files are present in the repository.

### Important relationships

- One branch can have many employees.
- One department can have many employees and job positions.
- An employee can report to another employee through `Employees.ManagerID`.
- One employee can have many attendance, leave, salary-history, bonus, deduction, and payroll records.
- One leave type can classify many leave requests.
- One bonus or deduction type can classify many corresponding records.
- One payroll period can contain many payroll records.
- One payroll record can have multiple payment records in the current model.

## Database Schema

The planned schema contains the following tables:

1. `Branches`
2. `Departments`
3. `Jobs`
4. `LeaveTypes`
5. `Employees`
6. `EmployeeSalaryHistory`
7. `Attendance`
8. `EmployeeLeaves`
9. `Bonuses`
10. `Deductions`
11. `PayrollPeriods`
12. `Payroll`
13. `PayrollPayments`
14. `AuditLogs`
15. `BonusTypes`
16. `DeductionTypes`

Key integrity rules include unique employee numbers and email addresses, one attendance record per employee/date, one payroll record per employee/payroll period, valid statuses, positive salary/bonus/deduction/payment amounts, valid date ranges, and a payroll net-salary formula check.

## Key SQL Server Concepts

The project scripts are intended to demonstrate:

- Relational database design and normalization
- Primary keys, foreign keys, unique constraints, and check constraints
- Default constraints and identity columns
- Views for reusable reporting logic
- Scalar functions and inline table-valued functions
- Stored procedures with parameters and validation
- `TRY...CATCH`, `THROW`, and transaction handling
- Triggers using the `inserted` and `deleted` logical tables
- Common table expressions (CTEs), joins, grouping, and window functions
- Role-based database permissions
- Audit logging


## Security and Auditing

The design includes example database roles:

- `HR_Admin`
- `HR_Manager`
- `Payroll_Officer`
- `Auditor`

The security script may create demonstration database users using `WITHOUT LOGIN`. These are test identities for permission demonstrations; they are not application authentication accounts and do not represent a complete production identity-management design.

Salary, payroll, deductions, bonuses, payment records, and audit logs should be treated as sensitive data. Use only synthetic data in this repository. Do not commit real employee details, passwords, access tokens, bank information, or production connection strings.

## Business Reports

The business-query script is intended to answer questions such as:

- How many employees work in each department or branch?
- Which employees have the highest current salaries?
- What is an employee's salary history?
- What are monthly attendance and absence trends?
- Which leave requests are pending, and which employees may exceed leave allowances?
- What are bonus expenses by type and department?
- What is payroll cost by period and department?
- Which payroll records have outstanding payments?
- How are salaries distributed across employee groups?
- What headline metrics belong on an HR/payroll dashboard?

Reports should be interpreted according to the project's sample-data rules and business assumptions. For example, leave-year overlap and payment reconciliation need careful handling in a production implementation.

## Repository Structure

The intended repository layout is:

```text
Enterprise-HR-Payroll-SQL-Server/
├── README.md
├── .gitignore
├── docs/
│   ├── Business-Requirements.md
│   ├── ERD.png
│   └── Database-Architecture.png
├── sql/
│   ├── 01_CreateDatabase.sql
│   ├── 02_CreateTables.sql
│   ├── 03_Constraints.sql
│   ├── 04_ReferenceData.sql
│   ├── 05_SampleData.sql
│   ├── 06_Views.sql
│   ├── 07_Functions.sql
│   ├── 08_StoredProcedures.sql
│   ├── 09_Triggers.sql
│   ├── 10_Transactions.sql
│   ├── 11_Security.sql
│   ├── 12_BusinessQueries.sql
└── screenshots/
```

Only include files that actually exist and have been reviewed. If a planned file is not ready, either finish it before upload or clearly label it as planned rather than leaving a broken execution sequence in the README.

## Prerequisites

- A supported Microsoft SQL Server instance
- SQL Server Management Studio (SSMS) or another SQL Server client
- Permission to create a database and database users/roles on your development instance
- Git, if using the command line
- A GitHub account

The scripts use SQL Server-specific T-SQL syntax. They are not intended to run unchanged on MySQL, PostgreSQL, or SQLite.

## Installation and Execution

> **Important:** Run the scripts against a development/test SQL Server instance, not a production database. Review each script before executing it. Some setup scripts create a database, constraints, users, roles, or triggers.

1. Clone or download this repository.
2. Open SSMS and connect to your local SQL Server instance.
3. Review `sql/01_CreateDatabase.sql` and execute it to create `EHRPMS`.
4. Execute the remaining scripts in dependency order, only when each file exists and has been reviewed:

   1. `02_CreateTables.sql`
   2. `03_Constraints.sql`
   3. `04_ReferenceData.sql`
   4. `05_SampleData.sql`
   5. `06_Views.sql`
   6. `07_Functions.sql`
   7. `08_StoredProcedures.sql`
   8. `09_Triggers.sql`
   9. `10_Transactions.sql`
   10. `11_Security.sql`
   11. `12_BusinessQueries.sql`

5. Check the Messages and Results tabs after each script. Resolve errors before proceeding.
6. Run the validation queries and inspect key reports.
7. Capture screenshots only after confirming the outputs are correct; remove or obscure any sensitive information.

Some scripts may require an elevated database permission or a fresh database. Check each script's comments before running it. The sample-data script should be treated as data-generation logic, not as a harmless script to rerun without checking its insert/update behavior.

## Validation and Testing

Before calling the project complete, verify the following:

- [ ] All expected tables exist in `EHRPMS`.
- [ ] Foreign keys, unique constraints, and check constraints are enabled and trusted where appropriate.
- [ ] Reference data inserts without errors.
- [ ] Sample data satisfies foreign keys and date constraints.
- [ ] Row counts are plausible and align with the sample-data targets documented in the scripts.
- [ ] Views return expected columns and results.
- [ ] Functions return correct values for representative cases.
- [ ] Stored procedures handle valid and invalid inputs appropriately.
- [ ] Transactions commit valid work and roll back failed work.
- [ ] Triggers work with multi-row statements, not only single-row examples.
- [ ] Role permissions are tested with `EXECUTE AS USER` and restored with `REVERT`.
- [ ] Business queries return sensible results and handle empty or incomplete data.
- [ ] Index and performance scripts are tested and their findings documented, if included.
- [ ] The scripts run in order on a clean test database.

## Performance and DBA Work

The project is also a starting point for demonstrating database administration skills. A strong final portfolio version should include evidence of:

- Baseline query performance before adding selected indexes
- Execution plans for representative reporting queries
- Logical reads and elapsed-time comparisons using `SET STATISTICS IO, TIME ON`
- Index choices tied to actual query predicates and joins
- Index maintenance and statistics considerations
- Backup and restore practice on a test database
- Validation of restore success, not just successful backup creation

Do not claim a query is optimized based on an index existing alone. Compare the execution plan and measured workload before and after the change, and document the test environment.

## Limitations and Design Notes

- This is a portfolio/learning implementation, not a production payroll product.
- Payroll and leave policies vary by country and employer. Tax, social-insurance, overtime, leave accrual, and legal calculations are not universal and must not be assumed correct for a real organization.
- The current model permits multiple payment records per payroll record. A production implementation should reconcile the sum of completed payments against the payroll amount and define rules for partial, failed, reversed, and duplicate payments.
- Leave reports must account for leave dates spanning calendar years and must apply the organization's actual leave policy.
- The model should be reviewed for currency, precision, effective-date rules, time zones, concurrency, and retention policies before production use.
- Database permissions and audit triggers are examples and require a security review before being used with sensitive data.

## Future Improvements

- Complete and document index and performance-testing scripts.
- Add a repeatable clean-install test for the full script sequence.
- Add a documented backup/restore exercise and recovery objectives.
- Improve payroll-payment reconciliation and idempotency.
- Implement year-overlap-aware leave calculations and policy-specific leave accrual.
- Add automated data-quality tests and deployment checks.
- Add anonymized screenshots of the ERD, reporting results, security checks, and execution-plan comparisons.
- Consider CI checks for SQL style, script ordering, and documentation completeness.

## Author

**Mahmoud Younis**  
Database Engineering 


