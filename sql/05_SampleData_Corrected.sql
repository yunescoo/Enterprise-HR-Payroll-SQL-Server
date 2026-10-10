/*
=====================================================================
EHRPMS - 05_SampleData.sql
=====================================================================
Purpose:
  Repair/complete the sample data after a partially successful run.

Targets:
  Employees       = 2,000
  SalaryHistory   >= 4,000
  Attendance      >= 400,000
  EmployeeLeaves  = 10,000
  Bonuses         = 15,000
  Deductions      = 20,000
  PayrollPeriods  = Jan-2024 through Sep-2026
  Payroll         = 50,000
  Payments        = one payment per payroll where missing

Name requirements:
  - 500 unique first names
  - 500 unique last names
  - consecutive first-name initials are different
  - consecutive last-name initials are different
  - first and last initials of the same employee are different
  - names are randomized within each initial group

Important:
  This script is designed for the CURRENT partially populated database.
  It does not blindly insert another 2,000 employees or another 50,000
  payroll rows if those targets already exist.
=====================================================================
*/

USE EHRPMS;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '=============================================================';
PRINT 'EHRPMS SAMPLE DATA - REPAIR / COMPLETION STARTED';
PRINT '=============================================================';
GO

/* ===============================================================
   0. NAME POOLS
   =============================================================== */

DROP TABLE IF EXISTS #FirstNames;
DROP TABLE IF EXISTS #LastNames;
DROP TABLE IF EXISTS #FirstPool;
DROP TABLE IF EXISTS #LastPool;
GO

CREATE TABLE #FirstNames
(
    NameID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    Initial CHAR(1) NOT NULL
);

CREATE TABLE #LastNames
(
    NameID INT IDENTITY(1,1) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Initial CHAR(1) NOT NULL
);
GO

INSERT INTO #FirstNames (FirstName, Initial)
SELECT 
    V.FirstName, 
    LEFT(V.FirstName, 1) AS Initial
FROM (VALUES
    (N'Tariq'), (N'Sami'), (N'Karem'), (N'Yasmin'), (N'Farida'), (N'Omar'), (N'Zainab'), (N'Dalia'), (N'Layla'), (N'Bassem'),
    (N'Nour'), (N'Amir'), (N'Mariam'), (N'Rami'), (N'Hassan'), (N'Maya'), (N'Khalid'), (N'Salma'), (N'Ziad'), (N'Fady'),
    (N'Amina'), (N'Bilal'), (N'Hoda'), (N'Youssef'), (N'Reem'), (N'Tamer'), (N'Nadia'), (N'Karim'), (N'Lina'), (N'Walid'),
    (N'Soraya'), (N'Mona'), (N'Hamza'), (N'Dina'), (N'Farouk'), (N'Aida'), (N'Rania'), (N'Sherif'), (N'Hana'), (N'Habiba'),
    (N'Mazin'), (N'Aya'), (N'Nabil'), (N'Samar'), (N'Wael'), (N'Laila'), (N'Eman'), (N'Sultan'), (N'Ghanem'), (N'Farah'),
    (N'Anas'), (N'Nada'), (N'Bassam'), (N'Zahra'), (N'Jamal'), (N'Khadija'), (N'Ramy'), (N'Ehab'), (N'Malak'), (N'Yaser'),
    (N'Fatima'), (N'Adel'), (N'Dania'), (N'Rayan'), (N'Safa'), (N'Mahmoud'), (N'Heba'), (N'Hussein'), (N'Nisreen'), (N'Samer'),
    (N'Amira'), (N'Ibrahim'), (N'Ghada'), (N'Tamim'), (N'May'), (N'Zaher'), (N'Rashed'), (N'Layan'), (N'Kaled'), (N'Rawan'),
    (N'Yasin'), (N'Asma'), (N'Eissa'), (N'Noura'), (N'Badr'), (N'Hala'), (N'Waleed'), (N'Amal'), (N'Hisham'), (N'Zeina'),
    (N'Faris'), (N'Sarah'), (N'Ihab'), (N'Rola'), (N'Naser'), (N'Jana'), (N'Nidal'), (N'Hani'), (N'Esraa'), (N'Ayman'),
    (N'Sahar'), (N'Zayd'), (N'Maha'), (N'Kamal'), (N'Fatma'), (N'Hassanin'), (N'Dona'), (N'Rida'), (N'Lujain'), (N'Mostafa'),
    (N'Sondos'), (N'Nasser'), (N'Lila'), (N'Bahaa'), (N'Amani'), (N'Zander'), (N'Ranim'), (N'Nizar'), (N'Sana'), (N'Feras'),
    (N'Dalal'), (N'Haytham'), (N'Ghalia'), (N'Ahmed'), (N'Rehab'), (N'Rashid'), (N'Nima'), (N'Hassanat'), (N'Karam'), (N'Yara'),
    (N'Suleiman'), (N'Najeeb'), (N'Lutfi'), (N'Inas'), (N'Samir'), (N'Zoya'), (N'Bassel'), (N'Maysaa'), (N'Raed'), (N'Ola'),
    (N'Hamed'), (N'Abeer'), (N'Khaled'), (N'Shaimaa'), (N'Hazem'), (N'Samia'), (N'Ismael'), (N'Roba'), (N'Sameh'), (N'Rowan'),
    (N'Gamer'), (N'Joud'), (N'Rana'), (N'Salem'), (N'Yazid'), (N'Ayman'), (N'Faten'), (N'Bisan'), (N'Reda'), (N'Hassan'),
    (N'Mira'), (N'Maged'), (N'Alaa'), (N'Yusuf'), (N'Doha'), (N'Nasser'), (N'Zahira'), (N'Eyad'), (N'Safia'), (N'Kader'),
    (N'Abrar'), (N'Kinan'), (N'Nada'), (N'Ghiath'), (N'Shaza'), (N'Hadi'), (N'Zubair'), (N'Mona'), (N'Saad'), (N'Batoul'),
    (N'Fahad'), (N'Reem'), (N'Sami'), (N'Ghaida'), (N'Imad'), (N'Sama'), (N'Wassim'), (N'Yuki'), (N'Ghazal'), (N'Mazen'),
    (N'Jasmine'), (N'Naji'), (N'Lina'), (N'Bisher'), (N'Razan'), (N'Amer'), (N'Dalia'), (N'Rayan'), (N'Kouther'), (N'Saif'),
    (N'Ayla'), (N'Zaky'), (N'Salsabil'), (N'Majid'), (N'Eman'), (N'Nader'), (N'Rawaa'), (N'Zahir'), (N'Haya'), (N'Gaby'),
    (N'Yusra'), (N'Mustafa'), (N'Farah'), (N'Karam'), (N'Mena'), (N'Aseel'), (N'Bashar'), (N'Hana'), (N'Nabil'), (N'Marilyn'),
    (N'Tarek'), (N'Safa'), (N'Yazan'), (N'Sondos'), (N'Darius'), (N'Amjad'), (N'Lilia'), (N'Reda'), (N'Kamil'), (N'Reem'),
    (N'Hassan'), (N'Jude'), (N'Safwan'), (N'Rasha'), (N'Ghaith'), (N'Dina'), (N'Mansour'), (N'Afnan'), (N'Zaki'), (N'Dania'),
    (N'Suhail'), (N'Nisreen'), (N'Ramez'), (N'Lina'), (N'Baqer'), (N'Sondos'), (N'Mervat'), (N'Nia'), (N'Khaleel'), (N'Tala'),
    (N'Ziyad'), (N'Yara'), (N'Hussein'), (N'Mayar'), (N'Gouda'), (N'Dina'), (N'Atef'), (N'Rola'), (N'Nizar'), (N'Samira'),
    (N'Zaid'), (N'Ruba'), (N'Ibrahim'), (N'Dalia'), (N'Kareem'), (N'Safaa'), (N'Luay'), (N'Maymouna'), (N'Ahmad'), (N'Ghalia'),
    (N'Riad'), (N'Layan'), (N'Faris'), (N'Zein'), (N'Dorra'), (N'Shadi'), (N'Haneen'), (N'Karam'), (N'Maha'), (N'Bassam'),
    (N'Rawan'), (N'Osama'), (N'Nour'), (N'Zahra'), (N'Isam'), (N'Dana'), (N'Ghassan'), (N'Nada'), (N'Rida'), (N'Lana'),
    (N'Taha'), (N'Jana'), (N'Mansoor'), (N'Ghada'), (N'Akram'), (N'Sama'), (N'Fahd'), (N'Zain'), (N'Khadija'), (N'Rakan'),
    (N'Bess'), (N'Maya'), (N'Ehab'), (N'Naya'), (N'Waleed'), (N'Aisha'), (N'Zouhair'), (N'Lamar'), (N'Mustafa'), (N'Sahar'),
    (N'Kais'), (N'Roba'), (N'Anwar'), (N'Rehab'), (N'Dhia'), (N'Amel'), (N'Sameh'), (N'Nouran'), (N'Ghani'), (N'Salma'),
    (N'Rayan'), (N'Tamera'), (N'Hossam'), (N'Zainab'), (N'Kaled'), (N'Dima'), (N'Baha'), (N'Malak'), (N'Ayman'), (N'Rita'),
    (N'Moataz'), (N'Nada'), (N'Zaki'), (N'Ghayda'), (N'Ibrahim'), (N'Sondos'), (N'Eyad'), (N'Lina'), (N'Ramy'), (N'Safia'),
    (N'Karem'), (N'Tania'), (N'Wassim'), (N'Nawal'), (N'Hadi'), (N'Reem'), (N'Zaher'), (N'Mona'), (N'Badr'), (N'Jude'),
    (N'Sayed'), (N'Aya'), (N'Fouad'), (N'Layan'), (N'Khattab'), (N'Mervat'), (N'Rashed'), (N'Safa'), (N'Zaid'), (N'Doha'),
    (N'Ameer'), (N'Nasma'), (N'Ghaith'), (N'Rowan'), (N'Haitham'), (N'Zeina'), (N'Ismail'), (N'Maya'), (N'Khalil'), (N'Dania'),
    (N'Ramez'), (N'Sherin'), (N'Bassem'), (N'Lamar'), (N'Thamer'), (N'Ola'), (N'Anas'), (N'Khadija'), (N'Zuhair'), (N'Rida'),
    (N'Safwan'), (N'Tala'), (N'Hamid'), (N'Eman'), (N'Yousef'), (N'Nour'), (N'Gaby'), (N'Maha'), (N'Karam'), (N'Dalia'),
    (N'Rayan'), (N'Salma'), (N'Tariq'), (N'Yasmin'), (N'Basma'), (N'Hazem'), (N'Rania'), (N'Kassim'), (N'Lila'), (N'Ziad'),
    (N'Afnan'), (N'Badr'), (N'Nadia'), (N'Sherif'), (N'Ghalia'), (N'Hamza'), (N'Lana'), (N'Rami'), (N'Dina'), (N'Mazin'),
    (N'Zahra'), (N'Anwar'), (N'Rawan'), (N'Kinan'), (N'Siham'), (N'Yasin'), (N'Faten'), (N'Bess'), (N'Maya'), (N'Reda'),
    (N'Habiba'), (N'Kamal'), (N'Hana'), (N'Nabil'), (N'Eman'), (N'Samer'), (N'Zainab'), (N'Amir'), (N'Ghada'), (N'Tamer'),
    (N'Layan'), (N'Kaled'), (N'Doha'), (N'Rashed'), (N'Safa'), (N'Youssef'), (N'Mona'), (N'Bassem'), (N'Nada'), (N'Hassan'),
    (N'Aida'), (N'Ruba'), (N'Ziad'), (N'Farida'), (N'Karem'), (N'Lina'), (N'Maysaa'), (N'Taha'), (N'Nour'), (N'Sherif'),
    (N'Asma'), (N'Wael'), (N'Reem'), (N'Ghaith'), (N'Hamid'), (N'Sondos'), (N'Zayid'), (N'Dalia'), (N'Rayan'), (N'Layan'),
    (N'Khadija'), (N'Amira'), (N'Bassel'), (N'Nada'), (N'Eyad'), (N'Safa'), (N'Zaher'), (N'Mona'), (N'Hani'), (N'Rola'),
    (N'Ayman'), (N'Dina'), (N'Nasser'), (N'Zeina'), (N'Karam'), (N'Lujain'), (N'Reda'), (N'Tamera'), (N'Yara'), (N'Bassam'),
    (N'Ghada'), (N'Samer'), (N'Nouran'), (N'Zaki'), (N'Rana'), (N'Ibrahim'), (N'Dania'), (N'Khattab'), (N'Maha'), (N'Afnan'),
    (N'Shadi'), (N'Layla'), (N'Ehab'), (N'Rowan'), (N'Hassan'), (N'Zahra'), (N'Basma'), (N'Nader'), (N'Ghaida'), (N'Tariq')
) AS V(FirstName);
GO

INSERT INTO #LastNames (LastName, Initial)
SELECT 
    V.LastName, 
    LEFT(V.LastName, 1) AS Initial
FROM (VALUES
    (N'Al-Mansoor'), (N'El-Sayed'), (N'Hassan'), (N'Khouri'), (N'Nasser'), (N'Zayd'), (N'Darwish'), (N'Qasim'), (N'Bakir'), (N'Salim'),
    (N'Ghanem'), (N'Tamimi'), (N'Fahmy'), (N'Radwan'), (N'Haddad'), (N'Sabbagh'), (N'Youssef'), (N'Al-Jabri'), (N'Najjar'), (N'Khalil'),
    (N'Bitar'), (N'Mascati'), (N'Gazzar'), (N'Zaher'), (N'Rizk'), (N'Karam'), (N'El-Baz'), (N'Taha'), (N'Suleiman'), (N'Othman'),
    (N'Al-Ahmad'), (N'Naim'), (N'Husseini'), (N'Fawzi'), (N'Kassab'), (N'Ghazal'), (N'Barakat'), (N'Zein'), (N'Dabbagh'), (N'Sharif'),
    (N'Shaban'), (N'Al-Khatib'), (N'Mustafa'), (N'Reda'), (N'Hamed'), (N'Zaki'), (N'El-Masry'), (N'Khoury'), (N'Saleh'), (N'Gharib'),
    (N'Tariq'), (N'Sarkis'), (N'Al-Farsi'), (N'Bazzi'), (N'Nassar'), (N'Hariri'), (N'El-Din'), (N'Sayegh'), (N'Kanaan'), (N'Zahran'),
    (N'Ammar'), (N'Daher'), (N'Quraishi'), (N'Badawi'), (N'Sultan'), (N'Ghosn'), (N'Kabbani'), (N'Al-Hassan'), (N'Yassin'), (N'Moussa'),
    (N'Nader'), (N'El-Gohary'), (N'Hussein'), (N'Safadi'), (N'Khoury'), (N'Gheith'), (N'Bitar'), (N'Zreik'), (N'Sami'), (N'Al-Rashid'),
    (N'Hamdan'), (N'Farah'), (N'Kassem'), (N'Tamer'), (N'Obaid'), (N'Sweis'), (N'Naseer'), (N'Gala'), (N'Al-Zahrani'), (N'Mubarak'),
    (N'Khoury'), (N'Dajani'), (N'Siam'), (N'Beshara'), (N'Al-Malki'), (N'Zeidan'), (N'Nahas'), (N'Fakhoury'), (N'Ramses'), (N'Ghandour'),
    (N'Habeeb'), (N'Sami'), (N'Al-Harbi'), (N'Boulos'), (N'Nouri'), (N'Khouri'), (N'Diab'), (N'Zahr'), (N'Sadek'), (N'Ghabour'),
    (N'Abo-Zaid'), (N'Mousa'), (N'Shakir'), (N'El-Demerdash'), (N'Khaled'), (N'Tawil'), (N'Qadir'), (N'Bishara'), (N'Al-Otaibi'), (N'Safi'),
    (N'Gomaa'), (N'Hamed'), (N'Younes'), (N'Kassir'), (N'Nassar'), (N'Zein'), (N'Darwish'), (N'Al-Saadi'), (N'Rashid'), (N'Saleh'),
    (N'Basha'), (N'Fahim'), (N'Gabr'), (N'Sayegh'), (N'Khatib'), (N'Ebeid'), (N'Al-Ghamdi'), (N'Zeidan'), (N'Nader'), (N'Hassan'),
    (N'Moosa'), (N'Karam'), (N'Gharib'), (N'Sultan'), (N'Badr'), (N'Al-Shehri'), (N'Yousef'), (N'Najm'), (N'Khoury'), (N'Sadek'),
    (N'Farahat'), (N'Tawfik'), (N'Al-Najar'), (N'Zaher'), (N'Nassif'), (N'Duma'), (N'Shami'), (N'Ganzouri'), (N'Kassab'), (N'Bitar'),
    (N'Husseini'), (N'Saleh'), (N'Al-Obeid'), (N'Mansour'), (N'Zaki'), (N'Naim'), (N'Ghallab'), (N'Fawaz'), (N'Khedr'), (N'Sabbah'),
    (N'Daoud'), (N'Al-Sharif'), (N'Boulos'), (N'Qasim'), (N'Zein'), (N'Moussa'), (N'Kattaneh'), (N'Haddad'), (N'Safar'), (N'Ghazali'),
    (N'El-Khoury'), (N'Nassar'), (N'Karam'), (N'Barakat'), (N'Zahran'), (N'Sweis'), (N'Al-Khafaji'), (N'Dahbour'), (N'Rashed'), (N'Ghanem'),
    (N'Yacoub'), (N'Malki'), (N'Sami'), (N'Al-Sayed'), (N'Kanaan'), (N'Fadel'), (N'Badran'), (N'Zahr'), (N'Nasser'), (N'Husseini'),
    (N'Gaza'), (N'Saliba'), (N'Al-Attar'), (N'Bazzi'), (N'Khoury'), (N'El-Moniem'), (N'Tannous'), (N'Sayegh'), (N'Rizkallah'), (N'Ghandour'),
    (N'Nassif'), (N'Al-Ghamdi'), (N'Kassir'), (N'Hussein'), (N'Bishara'), (N'Zeineddine'), (N'Saba'), (N'Moussa'), (N'Fakih'), (N'Ghanem'),
    (N'Al-Sayed'), (N'Radwan'), (N'Khoury'), (N'Dajani'), (N'Safadi'), (N'Zeidan'), (N'Nahas'), (N'Bitar'), (N'Gharib'), (N'Sabbagh'),
    (N'Malki'), (N'Al-Amri'), (N'Kassab'), (N'Fakhry'), (N'Zaki'), (N'Nassar'), (N'Ghazal'), (N'Tamimi'), (N'Safi'), (N'Basha'),
    (N'Al-Mutairi'), (N'Khaled'), (N'Haddad'), (N'Saleh'), (N'Zahr'), (N'Nassef'), (N'Ghallab'), (N'Bishai'), (N'Kanaan'), (N'Suleiman'),
    (N'Al-Hashemi'), (N'Moussa'), (N'Daher'), (N'Farouk'), (N'Zein'), (N'Nader'), (N'Gabbour'), (N'Kattaneh'), (N'Salam'), (N'Boulos'),
    (N'Al-Mansour'), (N'El-Masry'), (N'Khoury'), (N'Sfeir'), (N'Zahran'), (N'Najjar'), (N'Gabr'), (N'Tamim'), (N'Badr'), (N'Al-Harbi'),
    (N'Kassem'), (N'Hassan'), (N'Fawzi'), (N'Sarkis'), (N'Zreik'), (N'Naim'), (N'Ghosn'), (N'Kaddour'), (N'Sayegh'), (N'Bazzi'),
    (N'Al-Dosari'), (N'Maalouf'), (N'Kanaan'), (N'Farah'), (N'Zeidan'), (N'Nassar'), (N'Ghanem'), (N'Salem'), (N'Bishara'), (N'Al-Hajj'),
    (N'Khoury'), (N'Dahbour'), (N'Safadi'), (N'Zaki'), (N'Nassef'), (N'Ghazal'), (N'Tannous'), (N'Sultan'), (N'Basha'), (N'Al-Khatib'),
    (N'Mansour'), (N'Kassab'), (N'Fawaz'), (N'Zahr'), (N'Naim'), (N'Ghabour'), (N'Saleh'), (N'Boulos'), (N'Al-Ahmad'), (N'Karam'),
    (N'Ebeid'), (N'Zein'), (N'Najjar'), (N'Gharib'), (N'Sayegh'), (N'Bitar'), (N'Al-Shehri'), (N'Khoury'), (N'Dajani'), (N'Saba'),
    (N'Zahran'), (N'Nasser'), (N'Ganzouri'), (N'Tamimi'), (N'Bazi'), (N'Al-Ghamdi'), (N'Kassem'), (N'Farah'), (N'Saliba'), (N'Zeidan'),
    (N'Nassar'), (N'Ghanem'), (N'Sabbagh'), (N'Bishai'), (N'Al-Sayed'), (N'Kannan'), (N'El-Baz'), (N'Sfeir'), (N'Zreik'), (N'Najm'),
    (N'Gabr'), (N'Tariq'), (N'Badr'), (N'Al-Otaibi'), (N'Kassir'), (N'Hassan'), (N'Fakhoury'), (N'Zein'), (N'Naim'), (N'Gheith'),
    (N'Sarkis'), (N'Bishara'), (N'Al-Rashid'), (N'Khaled'), (N'Dabbagh'), (N'Saleh'), (N'Zahr'), (N'Nasser'), (N'Galla'), (N'Tawil'),
    (N'Basha'), (N'Al-Harbi'), (N'Khoury'), (N'El-Din'), (N'Sayegh'), (N'Zeidan'), (N'Najjar'), (N'Gharib'), (N'Salem'), (N'Bazzi'),
    (N'Al-Zahrani'), (N'Kassab'), (N'Fahmy'), (N'Sweis'), (N'Zaki'), (N'Nassar'), (N'Ghanem'), (N'Tamimi'), (N'Boulos'), (N'Al-Sayed'),
    (N'Kanaan'), (N'Daher'), (N'Sabbah'), (N'Zein'), (N'Najm'), (N'Ghandour'), (N'Safadi'), (N'Bitar'), (N'Al-Khatib'), (N'Kassem'),
    (N'El-Masry'), (N'Saba'), (N'Zahran'), (N'Naim'), (N'Gabr'), (N'Tannous'), (N'Bishara'), (N'Al-Mansour'), (N'Khoury'), (N'Farah')
) AS V(LastName);
GO

CREATE TABLE #FirstPool
(
    Initial CHAR(1) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    NameRN INT NOT NULL,
    NameCount INT NOT NULL
);

CREATE TABLE #LastPool
(
    Initial CHAR(1) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    NameRN INT NOT NULL,
    NameCount INT NOT NULL
);
GO

INSERT INTO #FirstPool
(
    Initial,
    FirstName,
    NameRN,
    NameCount
)
SELECT
    Initial,
    FirstName,
    ROW_NUMBER() OVER
    (
        PARTITION BY Initial
        ORDER BY NEWID()
    ),
    COUNT(*) OVER
    (
        PARTITION BY Initial
    )
FROM #FirstNames;
GO

INSERT INTO #LastPool
(
    Initial,
    LastName,
    NameRN,
    NameCount
)
SELECT
    Initial,
    LastName,
    ROW_NUMBER() OVER
    (
        PARTITION BY Initial
        ORDER BY NEWID()
    ),
    COUNT(*) OVER
    (
        PARTITION BY Initial
    )
FROM #LastNames;
GO

PRINT '500 first names and 500 last names loaded.';
GO


/* ===============================================================
   1. COMPLETE EMPLOYEES TO 2,000
   =============================================================== */

PRINT '1. Checking employees...';
GO

DECLARE @EmployeeCount INT;
SELECT @EmployeeCount = COUNT(*) FROM dbo.Employees;

IF @EmployeeCount < 2000
BEGIN
    DECLARE @EmployeesToCreate INT = 2000 - @EmployeeCount;

    ;WITH Numbers AS
    (
        SELECT TOP (@EmployeesToCreate)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
    ),
    DepartmentList AS
    (
        SELECT
            DepartmentID,
            ROW_NUMBER() OVER (ORDER BY DepartmentID) AS RN
        FROM dbo.Departments
    ),
    BranchList AS
    (
        SELECT
            BranchID,
            ROW_NUMBER() OVER (ORDER BY BranchID) AS RN
        FROM dbo.Branches
    ),
    JobList AS
    (
        SELECT
            JobID,
            DepartmentID,
            ROW_NUMBER() OVER
            (
                PARTITION BY DepartmentID
                ORDER BY JobID
            ) AS JobRN
        FROM dbo.Jobs
    ),
    JobCounts AS
    (
        SELECT
            DepartmentID,
            COUNT(*) AS JobCount
        FROM dbo.Jobs
        GROUP BY DepartmentID
    ),
    EmployeeSequence AS
    (
        SELECT
            @EmployeeCount + N AS SequenceNumber
        FROM Numbers
    )
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
    SELECT
        CONCAT(
            'EMP',
            RIGHT('000000' + CAST(S.SequenceNumber AS VARCHAR(6)), 6)
        ),

        FP.FirstName,
        LP.LastName,

        CONCAT(
            'employee',
            RIGHT('000000' + CAST(S.SequenceNumber AS VARCHAR(6)), 6),
            '@company.com'
        ),

        CONCAT(
            '+20-10-',
            RIGHT(
                '00000000' +
                CAST(10000000 + S.SequenceNumber AS VARCHAR(8)),
                8
            )
        ),

        DATEADD(
            DAY,
            -(ABS(CHECKSUM(NEWID())) % 14000),
            CAST('2000-01-01' AS DATE)
        ),

        DATEADD(
            DAY,
            -(ABS(CHECKSUM(NEWID())) % 4000),
            CAST('2026-01-01' AS DATE)
        ),

        D.DepartmentID,
        J.JobID,
        NULL,
        B.BranchID,

        CASE S.SequenceNumber % 100
            WHEN 0 THEN 'Terminated'
            WHEN 1 THEN 'Suspended'
            WHEN 2 THEN 'Inactive'
            WHEN 3 THEN 'OnLeave'
            WHEN 4 THEN 'OnLeave'
            WHEN 5 THEN 'Inactive'
            ELSE 'Active'
        END

    FROM EmployeeSequence S

    INNER JOIN DepartmentList D
        ON D.RN = ((S.SequenceNumber - 1) % 30) + 1

    INNER JOIN JobCounts JC
        ON JC.DepartmentID = D.DepartmentID

    INNER JOIN JobList J
        ON J.DepartmentID = D.DepartmentID
       AND J.JobRN = ((S.SequenceNumber - 1) % JC.JobCount) + 1

    INNER JOIN BranchList B
        ON B.RN = ((S.SequenceNumber - 1) % 20) + 1

    CROSS APPLY
    (
        SELECT
            CHAR(65 + ((S.SequenceNumber - 1) % 26)) AS FirstInitial,
            CHAR(65 + ((S.SequenceNumber + 12) % 26)) AS LastInitial
    ) I

    CROSS APPLY
    (
        SELECT TOP (1)
            F.FirstName
        FROM #FirstPool F
        WHERE F.Initial = I.FirstInitial
        ORDER BY
            ((F.NameRN + S.SequenceNumber - 1) % F.NameCount)
    ) FP

    CROSS APPLY
    (
        SELECT TOP (1)
            L.LastName
        FROM #LastPool L
        WHERE L.Initial = I.LastInitial
        ORDER BY
            ((L.NameRN + S.SequenceNumber - 1) % L.NameCount)
    ) LP;
END;
GO

PRINT 'Employees ready.';
SELECT COUNT(*) AS EmployeeCount FROM dbo.Employees;
GO


/* ===============================================================
   2. ASSIGN DEPARTMENT MANAGERS
   =============================================================== */

PRINT '2. Assigning managers...';
GO

;WITH DepartmentManagers AS
(
    SELECT
        EmployeeID,
        DepartmentID,
        ROW_NUMBER() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY EmployeeID
        ) AS RN
    FROM dbo.Employees
)
UPDATE E
SET ManagerID = M.EmployeeID
FROM dbo.Employees E
INNER JOIN DepartmentManagers M
    ON M.DepartmentID = E.DepartmentID
   AND M.RN = 1
WHERE E.EmployeeID <> M.EmployeeID
  AND E.ManagerID IS NULL;
GO

PRINT 'Managers ready.';
GO


/* ===============================================================
   3. APPLY 500-NAME VARIETY
   =============================================================== */

PRINT '3. Applying 500-name pools...';
GO

;WITH EmployeeSequence AS
(
    SELECT
        EmployeeID,
        ROW_NUMBER() OVER (ORDER BY EmployeeID) AS RN
    FROM dbo.Employees
),
Assignments AS
(
    SELECT
        E.EmployeeID,
        FP.FirstName,
        LP.LastName
    FROM EmployeeSequence E

    CROSS APPLY
    (
        SELECT
            CHAR(65 + ((E.RN - 1) % 26)) AS FirstInitial,
            CHAR(65 + ((E.RN + 12) % 26)) AS LastInitial
    ) I

    CROSS APPLY
    (
        SELECT TOP (1)
            F.FirstName
        FROM #FirstPool F
        WHERE F.Initial = I.FirstInitial
        ORDER BY
            ((F.NameRN + E.RN - 1) % F.NameCount)
    ) FP

    CROSS APPLY
    (
        SELECT TOP (1)
            L.LastName
        FROM #LastPool L
        WHERE L.Initial = I.LastInitial
        ORDER BY
            ((L.NameRN + E.RN - 1) % L.NameCount)
    ) LP
)
UPDATE E
SET
    FirstName = A.FirstName,
    LastName = A.LastName
FROM dbo.Employees E
INNER JOIN Assignments A
    ON A.EmployeeID = E.EmployeeID;
GO

PRINT '500-name variety applied.';
GO


/* ===============================================================
   4. SALARY HISTORY
   =============================================================== */

PRINT '4. Checking salary history...';
GO

INSERT INTO dbo.EmployeeSalaryHistory
(
    EmployeeID,
    Salary,
    EffectiveFrom,
    EffectiveTo,
    Reason,
    ApprovedByEmployeeID
)
SELECT
    E.EmployeeID,

    CAST(
        5000 + (ABS(CHECKSUM(NEWID())) % 55001)
        AS DECIMAL(18,2)
    ),

    DATEADD(
        MONTH,
        -12,
        CAST(GETDATE() AS DATE)
    ),

    NULL,

    CASE E.EmployeeID % 4
        WHEN 0 THEN 'Annual salary review'
        WHEN 1 THEN 'Promotion'
        WHEN 2 THEN 'Market adjustment'
        ELSE 'Performance increase'
    END,

    NULL
FROM dbo.Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.EmployeeSalaryHistory S
    WHERE S.EmployeeID = E.EmployeeID
      AND S.EffectiveTo IS NULL
);
GO

PRINT 'Salary history ready.';
GO


/* ===============================================================
   5. ATTENDANCE
   =============================================================== */

PRINT '5. Checking attendance...';
GO

DECLARE @AttendanceCount BIGINT;
SELECT @AttendanceCount = COUNT(*) FROM dbo.Attendance;

IF @AttendanceCount < 400000
BEGIN

    ;WITH Dates AS
    (
        SELECT TOP (240)
            DATEADD(
                DAY,
                -(N - 1),
                CAST(GETDATE() AS DATE)
            ) AS AttendanceDate
        FROM
        (
            SELECT TOP (240)
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
            FROM sys.all_objects
        ) X
    )
    INSERT INTO dbo.Attendance
    (
        EmployeeID,
        AttendanceDate,
        CheckIn,
        CheckOut,
        Status,
        WorkingHours
    )
    SELECT
        E.EmployeeID,
        D.AttendanceDate,

        CASE
            WHEN R.AbsentFlag = 1 THEN NULL
            ELSE CAST(
                DATEADD(
                    MINUTE,
                    450 + R.LateMinutes,
                    CAST('00:00:00' AS DATETIME)
                ) AS TIME(0)
            )
        END,

        CASE
            WHEN R.AbsentFlag = 1 THEN NULL
            ELSE CAST(
                DATEADD(
                    MINUTE,
                    930 + (R.LateMinutes % 90),
                    CAST('00:00:00' AS DATETIME)
                ) AS TIME(0)
            )
        END,

        CASE
            WHEN DATEPART(WEEKDAY, D.AttendanceDate) IN (1,7)
                THEN 'Holiday'
            WHEN R.AbsentFlag = 1
                THEN 'Absent'
            WHEN R.LateFlag = 1
                THEN 'Late'
            WHEN R.RemoteFlag = 1
                THEN 'Remote'
            ELSE 'Present'
        END,

        CASE
            WHEN R.AbsentFlag = 1 THEN 0
            ELSE CAST(
                7 + (ABS(CHECKSUM(NEWID())) % 201) / 100.0
                AS DECIMAL(5,2)
            )
        END

    FROM dbo.Employees E
    CROSS JOIN Dates D

    CROSS APPLY
    (
        SELECT
            ABS(CHECKSUM(NEWID())) % 100 AS R1,
            ABS(CHECKSUM(NEWID())) % 100 AS R2,
            ABS(CHECKSUM(NEWID())) % 100 AS R3,
            ABS(CHECKSUM(NEWID())) % 90 AS LateMinutes
    ) R0

    CROSS APPLY
    (
        SELECT
            CASE WHEN R0.R1 < 7 THEN 1 ELSE 0 END AS AbsentFlag,
            CASE WHEN R0.R2 < 10 THEN 1 ELSE 0 END AS LateFlag,
            CASE WHEN R0.R3 < 8 THEN 1 ELSE 0 END AS RemoteFlag,
            R0.LateMinutes
    ) R

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Attendance A
        WHERE A.EmployeeID = E.EmployeeID
          AND A.AttendanceDate = D.AttendanceDate
    );
END;
GO

PRINT 'Attendance ready.';
GO


/* ===============================================================
   6. EMPLOYEE LEAVES
   =============================================================== */

PRINT '6. Checking employee leaves...';
GO

DECLARE @LeaveCount BIGINT;
SELECT @LeaveCount = COUNT(*) FROM dbo.EmployeeLeaves;

IF @LeaveCount < 10000
BEGIN

    DECLARE @LeavesToCreate INT =
        10000 - CONVERT(INT, @LeaveCount);

    ;WITH Numbers AS
    (
        SELECT TOP (@LeavesToCreate)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
    ),
    EmployeeList AS
    (
        SELECT
            EmployeeID,
            ROW_NUMBER() OVER (ORDER BY EmployeeID) AS RN
        FROM dbo.Employees
    )
    INSERT INTO dbo.EmployeeLeaves
    (
        EmployeeID,
        LeaveTypeID,
        StartDate,
        EndDate,
        Reason,
        Status,
        ApprovedByEmployeeID
    )
    SELECT
        E.EmployeeID,
        ((N.N - 1) % 5) + 1,
        X.StartDate,
        DATEADD(DAY, (N.N % 5) + 1, X.StartDate),

        CASE N.N % 6
            WHEN 0 THEN 'Annual vacation'
            WHEN 1 THEN 'Medical leave'
            WHEN 2 THEN 'Family emergency'
            WHEN 3 THEN 'Personal leave'
            WHEN 4 THEN 'Travel'
            ELSE 'Other personal reason'
        END,

        CASE N.N % 10
            WHEN 0 THEN 'Pending'
            WHEN 1 THEN 'Rejected'
            WHEN 2 THEN 'Cancelled'
            ELSE 'Approved'
        END,

        NULL

    FROM Numbers N

    INNER JOIN EmployeeList E
        ON E.RN =
            ((N.N - 1) %
                (SELECT COUNT(*) FROM dbo.Employees)
            ) + 1

    CROSS APPLY
    (
        SELECT DATEADD(
            DAY,
            -(ABS(CHECKSUM(NEWID())) % 700),
            CAST(GETDATE() AS DATE)
        ) AS StartDate
    ) X;
END;
GO

PRINT 'Employee leaves ready.';
GO


/* ===============================================================
   7. BONUSES
   =============================================================== */

PRINT '7. Checking bonuses...';
GO

DECLARE @BonusCount BIGINT;
SELECT @BonusCount = COUNT(*) FROM dbo.Bonuses;

IF @BonusCount < 15000
BEGIN

    DECLARE @BonusesToCreate INT =
        15000 - CONVERT(INT, @BonusCount);

    ;WITH Numbers AS
    (
        SELECT TOP (@BonusesToCreate)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
    ),
    EmployeeList AS
    (
        SELECT
            EmployeeID,
            ROW_NUMBER() OVER (ORDER BY EmployeeID) AS RN
        FROM dbo.Employees
    )
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
    SELECT
        E.EmployeeID,
        ((N.N - 1) % 10) + 1,

        CAST(
            500 + (ABS(CHECKSUM(NEWID())) % 19501)
            AS DECIMAL(18,2)
        ),

        DATEADD(
            DAY,
            -(ABS(CHECKSUM(NEWID())) % 700),
            CAST(GETDATE() AS DATE)
        ),

        CASE N.N % 5
            WHEN 0 THEN 'Exceeded quarterly performance target'
            WHEN 1 THEN 'Outstanding project delivery'
            WHEN 2 THEN 'Sales target achievement'
            WHEN 3 THEN 'Innovation contribution'
            ELSE 'Special management recognition'
        END,

        NULL,

        CASE N.N % 10
            WHEN 0 THEN 'Pending'
            WHEN 1 THEN 'Rejected'
            WHEN 2 THEN 'Cancelled'
            WHEN 3 THEN 'Paid'
            ELSE 'Approved'
        END

    FROM Numbers N

    INNER JOIN EmployeeList E
        ON E.RN =
            ((N.N - 1) %
                (SELECT COUNT(*) FROM dbo.Employees)
            ) + 1;
END;
GO

PRINT 'Bonuses ready.';
GO


/* ===============================================================
   8. DEDUCTIONS
   =============================================================== */

PRINT '8. Checking deductions...';
GO

DECLARE @DeductionCount BIGINT;
SELECT @DeductionCount = COUNT(*) FROM dbo.Deductions;

IF @DeductionCount < 20000
BEGIN

    DECLARE @DeductionsToCreate INT =
        20000 - CONVERT(INT, @DeductionCount);

    ;WITH Numbers AS
    (
        SELECT TOP (@DeductionsToCreate)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
    ),
    EmployeeList AS
    (
        SELECT
            EmployeeID,
            ROW_NUMBER() OVER (ORDER BY EmployeeID) AS RN
        FROM dbo.Employees
    )
    INSERT INTO dbo.Deductions
    (
        EmployeeID,
        DeductionTypeID,
        Amount,
        DeductionDate,
        Reason
    )
    SELECT
        E.EmployeeID,
        ((N.N - 1) % 10) + 1,

        CAST(
            100 + (ABS(CHECKSUM(NEWID())) % 4901)
            AS DECIMAL(18,2)
        ),

        DATEADD(
            DAY,
            -(ABS(CHECKSUM(NEWID())) % 700),
            CAST(GETDATE() AS DATE)
        ),

        CASE N.N % 6
            WHEN 0 THEN 'Income tax'
            WHEN 1 THEN 'Insurance contribution'
            WHEN 2 THEN 'Late attendance'
            WHEN 3 THEN 'Loan repayment'
            WHEN 4 THEN 'Salary advance'
            ELSE 'Other payroll deduction'
        END

    FROM Numbers N

    INNER JOIN EmployeeList E
        ON E.RN =
            ((N.N - 1) %
                (SELECT COUNT(*) FROM dbo.Employees)
            ) + 1;
END;
GO

PRINT 'Deductions ready.';
GO


/* ===============================================================
   9. PAYROLL PERIODS
   =============================================================== */

PRINT '9. Checking payroll periods...';
GO

DECLARE @PeriodStart DATE = '2024-01-01';

WHILE @PeriodStart <= '2026-09-01'
BEGIN

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.PayrollPeriods
        WHERE PeriodStartDate = @PeriodStart
    )
    BEGIN

        INSERT INTO dbo.PayrollPeriods
        (
            PeriodStartDate,
            PeriodEndDate,
            PayrollStatus,
            ProcessedDate
        )
        VALUES
        (
            @PeriodStart,
            EOMONTH(@PeriodStart),

            CASE
                WHEN @PeriodStart < '2026-09-01'
                    THEN 'Processed'
                ELSE 'Open'
            END,

            CASE
                WHEN @PeriodStart < '2026-09-01'
                    THEN DATEADD(
                        DAY,
                        1,
                        CAST(EOMONTH(@PeriodStart) AS DATETIME2)
                    )
                ELSE NULL
            END
        );
    END;

    SET @PeriodStart =
        DATEADD(MONTH, 1, @PeriodStart);
END;
GO

PRINT 'Payroll periods ready.';
GO


/* ===============================================================
   10. PAYROLL TO 50,000
   =============================================================== */

PRINT '10. Checking payroll...';
GO

DECLARE @PayrollCount BIGINT;
SELECT @PayrollCount = COUNT(*) FROM dbo.Payroll;

IF @PayrollCount < 50000
BEGIN

    DECLARE @PayrollToCreate INT =
        50000 - CONVERT(INT, @PayrollCount);

    ;WITH EmployeeList AS
    (
        SELECT
            EmployeeID,
            ROW_NUMBER() OVER (ORDER BY EmployeeID) AS RN
        FROM dbo.Employees
    ),
    PeriodList AS
    (
        SELECT
            PayrollPeriodID,
            ROW_NUMBER() OVER
            (
                ORDER BY PeriodStartDate
            ) AS RN
        FROM dbo.PayrollPeriods
    ),
    CandidatePairs AS
    (
        SELECT
            E.EmployeeID,
            P.PayrollPeriodID,
            ROW_NUMBER() OVER
            (
                ORDER BY P.PayrollPeriodID, E.EmployeeID
            ) AS PairRN
        FROM EmployeeList E
        CROSS JOIN PeriodList P
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.Payroll X
            WHERE X.EmployeeID = E.EmployeeID
              AND X.PayrollPeriodID = P.PayrollPeriodID
        )
    ),
    PayrollData AS
    (
        SELECT
            C.EmployeeID,
            C.PayrollPeriodID,

            CAST(
                5000 + (ABS(CHECKSUM(NEWID())) % 55001)
                AS DECIMAL(18,2)
            ) AS BasicSalary,

            CAST(
                ABS(CHECKSUM(NEWID())) % 5001
                AS DECIMAL(18,2)
            ) AS Overtime,

            CAST(
                ABS(CHECKSUM(NEWID())) % 8001
                AS DECIMAL(18,2)
            ) AS Bonuses,

            CAST(
                ABS(CHECKSUM(NEWID())) % 6001
                AS DECIMAL(18,2)
            ) AS Deductions

        FROM CandidatePairs C
        WHERE C.PairRN <= @PayrollToCreate
    )
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
        EmployeeID,
        PayrollPeriodID,
        BasicSalary,
        Overtime,
        Bonuses,
        Deductions,

        BasicSalary
            + Overtime
            + Bonuses
            - Deductions,

        'Processed',
        SYSDATETIME()

    FROM PayrollData;
END;
GO

PRINT 'Payroll ready.';
GO


/* ===============================================================
   11. PAYROLL PAYMENTS
   =============================================================== */

PRINT '11. Checking payroll payments...';
GO

INSERT INTO dbo.PayrollPayments
(
    PayrollID,
    PaymentDate,
    PaymentMethod,
    Amount,
    PaymentStatus,
    TransactionReference
)
SELECT
    P.PayrollID,

    DATEADD(
        DAY,
        2,
        CAST(PR.PeriodEndDate AS DATETIME2)
    ),

    CASE P.PayrollID % 3
        WHEN 0 THEN 'BankTransfer'
        WHEN 1 THEN 'Cash'
        ELSE 'Cheque'
    END,

    P.NetSalary,

    CASE
        WHEN P.PayrollStatus IN ('Paid','Processed')
            THEN 'Completed'
        ELSE 'Pending'
    END,

    CONCAT(
        'PAY-',
        RIGHT(
            '0000000000' +
            CAST(P.PayrollID AS VARCHAR(10)),
            10
        )
    )

FROM dbo.Payroll P
INNER JOIN dbo.PayrollPeriods PR
    ON PR.PayrollPeriodID = P.PayrollPeriodID
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.PayrollPayments PP
    WHERE PP.PayrollID = P.PayrollID
);
GO

PRINT 'Payroll payments ready.';
GO


/* ===============================================================
   12. FINAL ROW COUNTS
   =============================================================== */

PRINT '=============================================================';
PRINT 'FINAL ROW COUNTS';
PRINT '=============================================================';
GO

SELECT 'Branches' AS TableName, COUNT_BIG(*) AS Row_Count
FROM dbo.Branches
UNION ALL
SELECT 'Departments', COUNT_BIG(*)
FROM dbo.Departments
UNION ALL
SELECT 'Jobs', COUNT_BIG(*)
FROM dbo.Jobs
UNION ALL
SELECT 'Employees', COUNT_BIG(*)
FROM dbo.Employees
UNION ALL
SELECT 'SalaryHistory', COUNT_BIG(*)
FROM dbo.EmployeeSalaryHistory
UNION ALL
SELECT 'Attendance', COUNT_BIG(*)
FROM dbo.Attendance
UNION ALL
SELECT 'EmployeeLeaves', COUNT_BIG(*)
FROM dbo.EmployeeLeaves
UNION ALL
SELECT 'Bonuses', COUNT_BIG(*)
FROM dbo.Bonuses
UNION ALL
SELECT 'Deductions', COUNT_BIG(*)
FROM dbo.Deductions
UNION ALL
SELECT 'PayrollPeriods', COUNT_BIG(*)
FROM dbo.PayrollPeriods
UNION ALL
SELECT 'Payroll', COUNT_BIG(*)
FROM dbo.Payroll
UNION ALL
SELECT 'PayrollPayments', COUNT_BIG(*)
FROM dbo.PayrollPayments
UNION ALL
SELECT 'AuditLogs', COUNT_BIG(*)
FROM dbo.AuditLogs;
GO


/* ===============================================================
   13. DATA QUALITY TESTS
   =============================================================== */

PRINT '=============================================================';
PRINT 'DATA QUALITY TESTS';
PRINT '=============================================================';
GO

SELECT
    'Invalid Leave Dates' AS TestName,
    COUNT_BIG(*) AS ErrorCount
FROM dbo.EmployeeLeaves
WHERE EndDate < StartDate

UNION ALL

SELECT
    'Invalid Payroll Calculation',
    COUNT_BIG(*)
FROM dbo.Payroll
WHERE NetSalary <>
      BasicSalary
      + Overtime
      + Bonuses
      - Deductions

UNION ALL

SELECT
    'Invalid Attendance Times',
    COUNT_BIG(*)
FROM dbo.Attendance
WHERE CheckIn IS NOT NULL
  AND CheckOut IS NOT NULL
  AND CheckOut < CheckIn

UNION ALL

SELECT
    'Payroll Duplicates',
    COUNT_BIG(*)
FROM
(
    SELECT EmployeeID, PayrollPeriodID
    FROM dbo.Payroll
    GROUP BY EmployeeID, PayrollPeriodID
    HAVING COUNT(*) > 1
) X

UNION ALL

SELECT
    'Payroll Without Employee',
    COUNT_BIG(*)
FROM dbo.Payroll P
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Employees E
    WHERE E.EmployeeID = P.EmployeeID
)

UNION ALL

SELECT
    'Payment Without Payroll',
    COUNT_BIG(*)
FROM dbo.PayrollPayments PP
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Payroll P
    WHERE P.PayrollID = PP.PayrollID
);
GO


/* ===============================================================
   14. NAME INITIAL VALIDATION
   =============================================================== */

PRINT '=============================================================';
PRINT 'NAME INITIAL VALIDATION';
PRINT '=============================================================';
GO

;WITH E AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,

        LAG(FirstName)
            OVER (ORDER BY EmployeeID) AS PreviousFirstName,

        LAG(LastName)
            OVER (ORDER BY EmployeeID) AS PreviousLastName

    FROM dbo.Employees
)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    PreviousFirstName,
    PreviousLastName
FROM E
WHERE
    (
        PreviousFirstName IS NOT NULL
        AND LEFT(FirstName,1) =
            LEFT(PreviousFirstName,1)
    )
    OR
    (
        PreviousLastName IS NOT NULL
        AND LEFT(LastName,1) =
            LEFT(PreviousLastName,1)
    );
GO


/* Same employee: first and last initial must differ. */
SELECT
    EmployeeID,
    FirstName,
    LastName
FROM dbo.Employees
WHERE LEFT(FirstName,1) = LEFT(LastName,1);
GO


/* ===============================================================
   15. EMPLOYEE DISTRIBUTION
   =============================================================== */

PRINT '=============================================================';
PRINT 'EMPLOYEE DISTRIBUTION';
PRINT '=============================================================';
GO

SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS EmployeeCount
FROM dbo.Departments D
LEFT JOIN dbo.Employees E
    ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
ORDER BY EmployeeCount DESC;
GO

SELECT
    EmploymentStatus,
    COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY EmploymentStatus
ORDER BY EmployeeCount DESC;
GO


/* ===============================================================
   FINAL STATUS
   =============================================================== */

PRINT '=============================================================';
PRINT 'EHRPMS SAMPLE DATA REPAIR / COMPLETION FINISHED';
PRINT '=============================================================';
GO
