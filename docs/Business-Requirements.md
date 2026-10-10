   **`docs/Business-Requirements.md`** 

# Enterprise HR & Payroll Management System (EHRPMS)
## Business Requirements Specification

---

## 1. Project Information

| Item | Details |
|---|---|
| **Project Name** | Enterprise HR & Payroll Management System |
| **Database Platform** | Microsoft SQL Server |
| **Database Language** | T-SQL |
| **Project Type** | Database Engineering / DBA |


### Project Objective

Design and implement a centralized relational database for managing employees, organizational structure, attendance, leave, compensation, payroll processing, payroll payments, auditing, security, reporting, and database administration operations.

The project is designed as an enterprise-style SQL Server database project rather than a simple academic CRUD database.

---

# 2. Business Scenario

A multinational company operates multiple branches across different cities and countries.

The organization contains several departments, including:

- IT
- Human Resources
- Finance
- Sales
- Marketing
- Operations

Each department contains employees with different job positions and reporting relationships.

The company requires a centralized HR and Payroll database capable of managing employee information throughout the employee lifecycle.

Employees may:

- Work at different branches
- Belong to departments
- Hold specific job positions
- Report to managers
- Have salary changes over time
- Record attendance
- Request leave
- Receive bonuses
- Receive deductions
- Receive monthly payroll
- Receive payroll payments

The system must support both operational processing and management reporting.

---

# 3. Business Problem

Without a centralized and properly designed HR and Payroll database, an organization may experience:

- Duplicate employee records
- Inconsistent employee information
- Difficulty tracking organizational hierarchy
- Loss of historical salary information
- Incorrect payroll calculations
- Poor attendance tracking
- Difficulty calculating leave balances
- Limited visibility into bonuses and deductions
- Weak auditability of sensitive changes
- Slow reporting on large datasets
- Weak security around salary and payroll information
- Difficulty recovering from data loss

---

# 4. Project Scope

## 4.1 In Scope

The system will manage the following areas.

### Organization Management

- Departments
- Branches
- Job positions
- Employee reporting hierarchy

### Employee Management

- Employee information
- Employee number
- Contact information
- Hire date
- Employment status
- Department assignment
- Job assignment
- Branch assignment
- Manager assignment

### Attendance Management

- Daily attendance
- Check-in time
- Check-out time
- Attendance status
- Working hours

### Leave Management

- Leave types
- Annual leave allowance
- Leave requests
- Leave approval
- Leave rejection
- Leave usage
- Leave balance

### Compensation Management

- Employee salary history
- Salary changes
- Bonuses
- Deductions

### Payroll Management

- Monthly payroll processing
- Basic salary
- Overtime
- Bonuses
- Deductions
- Net salary
- Payroll status

### Payroll Payments

- Payment records
- Payment date
- Payment method
- Payment amount
- Payment status
- Transaction reference

### Governance and Administration

- Audit logging
- Role-based security
- Permission management
- Database backup
- Database recovery
- Indexing
- Performance testing

### Reporting and Analytics

- Employee reports
- Department reports
- Attendance reports
- Leave reports
- Salary reports
- Payroll reports
- HR analytics

---

## 4.2 Out of Scope

The first version of EHRPMS will not include:

- Recruitment management
- Applicant tracking
- Interview scheduling
- Employee mobile applications
- Employee self-service web portals
- Real bank integration
- Real payment gateway integration
- Real tax authority integration
- Real employee personal data
- Real employee bank account numbers
- Real national identification numbers
- Real passwords

All project sample data will be fictional.

---

# 5. System Users

## 5.1 HR Administrator

The HR Administrator is responsible for:

- Managing employee information
- Managing departments
- Managing job positions
- Managing employee status
- Reviewing attendance
- Managing leave information

---

## 5.2 HR Manager

The HR Manager is responsible for:

- Reviewing employee information
- Reviewing department information
- Approving or rejecting leave requests
- Reviewing salary history
- Accessing HR reports
- Reviewing workforce analytics

---

## 5.3 Payroll Officer

The Payroll Officer is responsible for:

- Managing bonuses
- Managing deductions
- Processing payroll
- Reviewing payroll records
- Creating payroll payments

---

## 5.4 Auditor

The Auditor is responsible for:

- Reviewing audit logs
- Investigating sensitive changes
- Reviewing payroll modifications
- Reviewing salary changes

The Auditor should primarily have read-only access.

---

## 5.5 Database Administrator

The Database Administrator is responsible for:

- Database availability
- Database security
- Permission management
- Backup operations
- Restore operations
- Index maintenance
- Performance monitoring
- Query optimization
- Database maintenance
- Recovery planning

---

# 6. Core Business Modules

The system consists of the following major modules:

```text
Organization Management
        |
        v
Employee Management
        |
        +-------------------+-------------------+
        |                   |                   |
        v                   v                   v
   Attendance          Leave Management    Salary Management
                                                |
                                                v
                                          Compensation
                                          /          \
                                         v            v
                                      Bonuses      Deductions
                                          \          /
                                           v        v
                                            Payroll
                                               |
                                               v
                                        Payroll Payments
                                               |
                                               v
                                           Reporting
````

---

# 7. Functional Requirements

## FR-01 — Employee Management

The system shall allow authorized users to:

* Create employees
* Update employee information
* View employee information
* Assign employees to departments
* Assign employees to jobs
* Assign employees to branches
* Assign managers
* Change employee employment status

Possible employment statuses include:

* Active
* Suspended
* Terminated
* Resigned
* On Leave

The final list of controlled status values will be defined during database design.

---

## FR-02 — Department Management

The system shall maintain:

* Department name
* Department code
* Department manager

The system must support reporting such as:

> How many employees work in each department?

> Which departments have no employees?

> What is the payroll cost for each department?

---

## FR-03 — Branch Management

The system shall maintain company branches.

Each branch should include:

* Branch name
* City
* Country
* Address

Example branch locations may include:

* Cairo
* Alexandria
* Dubai
* Riyadh
* Jeddah

The branch structure supports multinational and Gulf-market business scenarios.

---

## FR-04 — Job Management

The system shall maintain job positions.

Each job should include:

* Job title
* Job level
* Minimum salary
* Maximum salary
* Associated department

Examples include:

* Junior Database Administrator
* Senior Database Administrator
* Software Engineer
* HR Specialist
* Accountant
* Sales Representative

The salary range may later be used to validate salary-related business rules.

---

## FR-05 — Employee Reporting Hierarchy

Employees may report to other employees.

Example hierarchy:

```text
CEO
|
+-- IT Manager
|    |
|    +-- Senior DBA
|    +-- Junior DBA
|    +-- Software Engineer
|
+-- HR Manager
     |
     +-- HR Specialist
     +-- Recruiter
```

The database must support a self-referencing employee relationship.

The system must later support displaying the complete organizational hierarchy.

---

## FR-06 — Salary Management

The system shall maintain employee salary history.

Salary information must preserve historical records rather than only storing a single current salary value.

Each salary history record should include:

* Employee
* Salary amount
* Effective start date
* Effective end date
* Reason for salary change
* Approver

The system should support questions such as:

> What was an employee's salary on a specific date?

> What is the employee's current salary?

> How much did the employee's salary increase?

Example:

| Period       | Salary |
| ------------ | -----: |
| January 2025 |    800 |
| January 2026 |  1,000 |
| July 2026    |  1,200 |

---

## FR-07 — Attendance Management

The system shall record employee attendance.

Attendance information includes:

* Employee
* Attendance date
* Check-in time
* Check-out time
* Attendance status
* Working hours

Possible attendance statuses include:

* Present
* Absent
* Late
* Remote
* Holiday

The system should support reports such as:

* Employees absent this month
* Employees with excessive lateness
* Employee working hours
* Department attendance statistics

---

## FR-08 — Leave Management

The system shall support multiple leave types.

Examples include:

* Annual Leave
* Sick Leave
* Emergency Leave
* Unpaid Leave
* Maternity Leave

Each leave type may have a maximum annual allowance.

Employees shall be able to request leave.

A leave request may follow the workflow:

```text
Pending
   |
   +----> Approved
   |
   +----> Rejected
```

The system must support calculation of:

```text
Allowed Days
     -
Used Days
     =
Remaining Days
```

The system should identify employees who exceed their leave allowance.

---

## FR-09 — Bonus Management

The system shall allow authorized users to record employee bonuses.

Examples include:

* Performance Bonus
* Annual Bonus
* Sales Bonus
* Project Bonus

Each bonus record should include:

* Employee
* Bonus type
* Amount
* Bonus date
* Reason
* Approver
* Status

The system should support bonus reporting by employee, department, branch, and period.

---

## FR-10 — Deduction Management

The system shall support employee deductions.

Examples include:

* Tax
* Insurance
* Late Penalty
* Loan Deduction
* Unpaid Leave Deduction

Each deduction should include:

* Employee
* Deduction type
* Amount
* Deduction date
* Reason

The system should support deduction reporting and payroll calculations.

---

## FR-11 — Payroll Processing

Payroll is the primary financial processing module.

The system shall calculate employee payroll using:

```text
Basic Salary
      +
Overtime
      +
Bonuses
      -
Deductions
      =
Net Salary
```

A payroll record represents payroll processing for a specific employee and payroll period.

Possible payroll statuses include:

* Pending
* Processed
* Approved
* Paid
* Cancelled

The final controlled values will be defined during implementation.

The system must prevent duplicate payroll processing for the same employee and payroll period.

---

## FR-12 — Payroll Payments

Payroll calculation and payroll payment must remain separate business processes.

The system shall record:

* Payroll record
* Payment date
* Payment method
* Payment amount
* Payment status
* Transaction reference

Business flow:

```text
Employee
   |
   v
Payroll Calculation
   |
   v
Payroll Record
   |
   v
Payroll Payment
```

This separation allows payroll to be calculated, approved, and recorded before payment is completed.

---

## FR-13 — Audit Logging

The system shall maintain an audit trail for important operations.

The audit log should capture:

* User or login
* Action
* Table name
* Record identifier
* Old value
* New value
* Action date and time

Sensitive operations to audit include:

* Employee salary changes
* Employee employment status changes
* Payroll modifications
* Other important HR/payroll changes

---

## FR-14 — Reporting

The system shall support the following categories of reports.

### Employee Reports

* Employees by department
* Employees by branch
* Employees by job
* Employee-manager hierarchy
* Active and inactive employees

### Attendance Reports

* Monthly attendance
* Monthly absences
* Late employees
* Employee working hours
* Department attendance statistics

### Leave Reports

* Leave requests
* Leave usage
* Leave balance
* Employees exceeding leave allowance

### Salary Reports

* Current employee salaries
* Salary history
* Salary growth
* Average salary by department
* Average salary by job

### Payroll Reports

* Monthly payroll expense
* Payroll by department
* Payroll by branch
* Total bonuses
* Total deductions
* Highest-paid employees
* Net payroll expense

---

# 8. Non-Functional Requirements

## NFR-01 — Data Integrity

The database must protect against invalid and inconsistent data using:

* Primary Keys
* Foreign Keys
* UNIQUE constraints
* CHECK constraints
* DEFAULT constraints

---

## NFR-02 — Transaction Consistency

Critical operations must maintain consistency.

Payroll processing must use database transactions to ensure that:

> Either the complete payroll operation succeeds, or the complete operation is rolled back.

Transactions will use concepts including:

* BEGIN TRANSACTION
* COMMIT
* ROLLBACK
* TRY...CATCH

---

## NFR-03 — Security

Sensitive HR and payroll information must be protected using:

* SQL Server authentication and authorization concepts
* Database roles
* Least-privilege permissions
* GRANT permissions
* DENY permissions where appropriate
* Auditing

Potential roles include:

* HR_Admin
* HR_Manager
* Payroll_Officer
* Auditor

---

## NFR-04 — Performance

The system should support realistic volumes of data.

Target development volumes include:

| Table            | Target Records |
| ---------------- | -------------: |
| Departments      |             30 |
| Branches         |             20 |
| Jobs             |            100 |
| Employees        |          2,000 |
| Attendance       |       400,000+ |
| Employee Leaves  |         10,000 |
| Bonuses          |         15,000 |
| Deductions       |         20,000 |
| Payroll          |         50,000 |
| Payroll Payments |         50,000 |

These are implementation and testing targets.

---

## NFR-05 — Availability and Recovery

The project shall include a documented backup and recovery strategy.

The database project will demonstrate:

* Full backups
* Differential backups
* Transaction log backup concepts where applicable
* Database restore procedures
* Restore testing

---

## NFR-06 — Auditability

Important modifications must be traceable.

The system should support questions such as:

> Who changed this record?

> What was the previous value?

> What is the new value?

> When was the change made?

---

# 9. Business Rules

## BR-01

Every employee must belong to a valid department.

## BR-02

Every employee must have a valid job position.

## BR-03

Every employee must be assigned to a valid branch.

## BR-04

An employee may report to another employee.

## BR-05

An employee cannot be their own manager.

## BR-06

Employee numbers must be unique.

## BR-07

Employee email addresses must be unique.

## BR-08

Department codes must be unique.

## BR-09

Salary amounts must be greater than zero.

## BR-10

Bonus amounts must be greater than zero.

## BR-11

Deduction amounts must be greater than zero.

## BR-12

Payroll payment amounts must be greater than zero.

## BR-13

Check-out time cannot occur before check-in time.

## BR-14

A leave request must belong to a valid employee.

## BR-15

A leave request must use a valid leave type.

## BR-16

Leave end dates cannot occur before leave start dates.

## BR-17

A payroll record must belong to a valid employee.

## BR-18

A payroll payment must belong to a valid payroll record.

## BR-19

Only one payroll record should exist for an employee for a specific payroll period.

## BR-20

Processed payroll records must be protected from unauthorized modification.

## BR-21

Salary history must preserve previous salary records.

## BR-22

Only authorized users may access or modify sensitive payroll information.

---

# 10. Data Volume and Growth Requirements

The project will simulate an enterprise environment rather than using only a small demonstration dataset.

Large datasets will be used to test:

* Query performance
* Execution plans
* Logical reads
* CPU time
* Elapsed time
* Index effectiveness

The Attendance table will be one of the primary performance-testing tables.

Performance workflow:

```text
Generate Data
      |
      v
Run Representative Query
      |
      v
Capture Execution Plan
      |
      v
Measure Performance
      |
      v
Create/Test Index
      |
      v
Run Query Again
      |
      v
Compare Before vs After
```

---

# 11. Security Requirements

The project will demonstrate role-based access control.

## HR_Admin

May manage HR-related entities.

Examples:

* Employees
* Departments
* Jobs
* Attendance
* Leave

## HR_Manager

May review HR information and approve authorized operations.

## Payroll_Officer

May perform authorized operations related to:

* Bonuses
* Deductions
* Payroll
* Payroll payments

## Auditor

May review:

* Audit logs
* Authorized business records

The Auditor should not normally modify business or audit records.

The security model will follow the principle of:

> Least Privilege

Users should receive only the permissions necessary for their responsibilities.

---

# 12. Backup and Recovery Requirements

The database must support documented backup and recovery operations.

## Full Backup

A complete backup of the database.

Potential use cases:

* Regular baseline backup
* Major recovery scenarios

## Differential Backup

Captures changes since the most recent full backup.

Potential use case:

* Reducing backup and restore workload between full backups

## Transaction Log Backup

Where the recovery model and configuration support it, transaction log backups can be used as part of point-in-time recovery strategies.

## Restore Testing

Backup scripts alone are not sufficient.

The project should demonstrate the ability to restore and validate a database backup.

---

# 13. Performance Requirements

The project will demonstrate evidence-based indexing.

Indexes will not be created blindly.

The process will be:

1. Identify a realistic query.
2. Execute the query without the proposed index where appropriate.
3. Review the execution plan.
4. Measure logical reads, CPU time, and elapsed time.
5. Create or test an appropriate index.
6. Execute the query again.
7. Compare results.
8. Document the reason for the index.

Potential indexing candidates include:

* Employee department relationships
* Employee manager relationships
* Attendance employee/date searches
* Leave employee/date searches
* Payroll employee/month searches
* Salary history employee/effective date searches

Final indexes will be based on actual query patterns and testing.

---

# 14. Reporting Requirements

The HR department should be able to answer questions including:

## Employees

* How many employees work in each department?
* How many employees work in each branch?
* Who reports to each manager?
* Which departments have no employees?

## Attendance

* Who was absent this month?
* Which employees were late most frequently?
* What are the total working hours per employee?
* Which department has the highest absenteeism?

## Leave

* What is each employee's leave balance?
* Which employees exceeded their leave allowance?
* Which employees have not used annual leave?
* Which employees have excessive unpaid leave?

## Salary

* What is each employee's current salary?
* What was an employee's salary on a specific date?
* Which employees received the largest salary increases?
* What is the average salary by department?

## Payroll

* What is the company's monthly payroll expense?
* Which department has the highest payroll cost?
* What is the payroll cost per branch?
* Who are the highest-paid employees?
* How much was paid in bonuses?
* How much was deducted?
* What is the total net payroll expense?

---

# 15. Advanced SQL Requirements

The final project must demonstrate practical use of:

* INNER JOIN
* LEFT JOIN
* RIGHT JOIN where appropriate for demonstration
* FULL OUTER JOIN where appropriate for demonstration
* Aggregate functions
* Subqueries
* Correlated subqueries where appropriate
* Common Table Expressions
* Recursive CTEs
* Window functions
* ROW_NUMBER()
* RANK()
* DENSE_RANK()
* LAG()
* LEAD()
* CASE expressions
* Views
* Scalar functions
* Table-valued functions
* Stored procedures
* Triggers
* Transactions
* TRY...CATCH error handling

---

# 16. Database Administration Requirements

The project will demonstrate DBA-related responsibilities including:

## Database Design

* Normalization to Third Normal Form
* Primary key design
* Foreign key relationships
* Data integrity constraints

## Security

* Database roles
* Permissions
* Least privilege

## Performance

* Index design
* Query analysis
* Execution plans
* Performance comparison

## Recovery

* Backup procedures
* Restore procedures
* Recovery documentation

## Maintenance

The project documentation should explain appropriate maintenance considerations for:

* Indexes
* Statistics
* Database backups
* Transaction logs
* Data growth

---

# 17. Success Criteria

The project will be considered complete when it demonstrates the following.

## Database Design

* [ ] Normalized relational schema
* [ ] Approximately 15–20 meaningful tables
* [ ] Primary and foreign keys
* [ ] Self-referencing employee hierarchy
* [ ] Documented ERD

## Data Integrity

* [ ] PRIMARY KEY constraints
* [ ] FOREIGN KEY constraints
* [ ] UNIQUE constraints
* [ ] CHECK constraints
* [ ] DEFAULT constraints

## SQL

* [ ] JOIN queries
* [ ] Aggregate queries
* [ ] Subqueries
* [ ] CTEs
* [ ] Recursive CTE
* [ ] Window functions

## T-SQL Programmability

* [ ] Views
* [ ] Scalar functions
* [ ] Table-valued functions
* [ ] Stored procedures
* [ ] Triggers
* [ ] Transactions
* [ ] TRY...CATCH error handling

## DBA Operations

* [ ] Security roles
* [ ] Permission management
* [ ] Audit logging
* [ ] Indexing
* [ ] Execution plan analysis
* [ ] Performance testing
* [ ] Backup scripts
* [ ] Restore scripts

## Portfolio Documentation

* [ ] Professional README
* [ ] Business requirements document
* [ ] ERD
* [ ] Database architecture documentation
* [ ] Organized SQL scripts
* [ ] Screenshots
* [ ] Performance testing evidence
* [ ] Testing evidence

---

# 18. Future Enhancements

Potential future versions may include:

* Recruitment and applicant tracking
* Employee self-service portal
* Web API integration
* Power BI dashboards
* Automated scheduled reports
* Advanced payroll rules
* Tax calculations by country
* Multi-currency support
* Employee performance management
* Training management
* Document management
* Automated database maintenance jobs
* SQL Server Agent jobs
* High availability and disaster recovery architecture

---

# 19. Key Design Principles

The EHRPMS project will follow these principles:

1. **Data Integrity First**
   Invalid data should be prevented as close to the database layer as possible.

2. **Normalization**
   The database will target Third Normal Form where appropriate.

3. **Historical Accuracy**
   Salary and payroll information must preserve meaningful historical records.

4. **Transactional Safety**
   Critical payroll operations must be atomic.

5. **Security by Least Privilege**
   Users should receive only the permissions required for their role.

6. **Auditability**
   Important changes must be traceable.

7. **Performance by Evidence**
   Indexes and optimizations should be based on actual workload testing.

8. **Recoverability**
   Backup and restore procedures must be documented and tested.

9. **Portfolio Quality**
   Every major design decision should be understandable and defensible during a technical interview.

---

# 20. Phase 1 Completion

Phase 1 is complete when this Business Requirements Specification has been reviewed and approved as the foundation for database design.

The next phase is:

> **Phase 2 — Database Architecture & Data Model**

Phase 2 will define:

* Final database modules
* Final table list
* Core tables
* Reference tables
* Transaction tables
* Audit tables
* Primary keys
* Foreign key relationships
* Relationship cardinality
* Dependency order
* Major database design decisions

No production table implementation should begin until the architecture and data model have been finalized.

```
```
