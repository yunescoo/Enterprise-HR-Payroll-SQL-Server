/* ============================================================================
   01_CreateDatabase.sql
   EHRPMS - Enterprise HR & Payroll Management System
   Phase 3 - Database Creation Script

   ============================================================================ */

USE master;
GO

/* ----------------------------------------------------------------------------
   0. Drop and recreate if it already exists (dev/test convenience).
      Remove this block before running against an environment with real data.
   ---------------------------------------------------------------------------- */
IF DB_ID(N'EHRPMS') IS NOT NULL
BEGIN
    ALTER DATABASE EHRPMS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EHRPMS;
END
GO

/* ----------------------------------------------------------------------------
   1. Create the database with explicit data/log file placement and sizing.
   ---------------------------------------------------------------------------- */
CREATE DATABASE EHRPMS
ON PRIMARY
(
    NAME       = N'EHRPMS_Data',
    FILENAME   = N'D:\HR MANAGEMENT SYSTEM\EHRPMS_Data.mdf',
    SIZE       = 512MB,
    MAXSIZE    = UNLIMITED,
    FILEGROWTH = 128MB
)
LOG ON
(
    NAME       = N'EHRPMS_Log',
    FILENAME   = N'D:\HR MANAGEMENT SYSTEM\EHRPMS_Log.ldf',
    SIZE       = 128MB,
    MAXSIZE    = UNLIMITED,
    FILEGROWTH = 64MB
);
GO

/* ----------------------------------------------------------------------------
   2. Database-level settings.
   ---------------------------------------------------------------------------- */
ALTER DATABASE EHRPMS SET RECOVERY FULL;                         -- point-in-time restore for payroll data
ALTER DATABASE EHRPMS SET COMPATIBILITY_LEVEL = 160;              -- SQL Server 2022
ALTER DATABASE EHRPMS COLLATE SQL_Latin1_General_CP1_CI_AS;       -- case-insensitive, accent-sensitive
ALTER DATABASE EHRPMS SET AUTO_CLOSE OFF;
ALTER DATABASE EHRPMS SET AUTO_SHRINK OFF;
ALTER DATABASE EHRPMS SET AUTO_CREATE_STATISTICS ON;
ALTER DATABASE EHRPMS SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE EHRPMS SET READ_COMMITTED_SNAPSHOT ON;             -- reduces blocking on payroll runs
ALTER DATABASE EHRPMS SET ANSI_NULLS ON;
ALTER DATABASE EHRPMS SET ANSI_PADDING ON;
ALTER DATABASE EHRPMS SET ANSI_WARNINGS ON;
ALTER DATABASE EHRPMS SET ARITHABORT ON;
ALTER DATABASE EHRPMS SET CONCAT_NULL_YIELDS_NULL ON;
ALTER DATABASE EHRPMS SET QUOTED_IDENTIFIER ON;
ALTER DATABASE EHRPMS SET NUMERIC_ROUNDABORT OFF;
GO

/* ----------------------------------------------------------------------------
   3. Switch context for subsequent scripts.
   ---------------------------------------------------------------------------- */
USE EHRPMS;
GO

PRINT 'EHRPMS database created successfully.';
GO
