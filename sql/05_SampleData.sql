USE EHRPMS;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '==============================================';
PRINT 'EHRPMS SAMPLE DATA GENERATION STARTED';
PRINT '==============================================';
GO

/* =========================================================
   0. PRE-FLIGHT VALIDATION
   This is the fix: previously, if Branches/Departments/Jobs were
   empty (04_ReferenceData.sql not run yet) or a department had zero
   matching Jobs rows, the big Employees INSERT below either matched
   nothing (silent 0 rows, no error) or hit a divide-by-zero inside
   the JobRN join (which aborts that one statement only - everything
   after it keeps running via GO, silently inserting 0 rows against
   an empty Employees table). SET NOCOUNT ON was hiding the
   "(0 rows affected)" messages that would otherwise have given this
   away immediately. This block fails loudly, up front, instead.
   ========================================================= */

PRINT '0. Validating reference data...';
GO

DECLARE @BranchCount INT = (SELECT COUNT(*) FROM dbo.Branches);
DECLARE @DeptCount   INT = (SELECT COUNT(*) FROM dbo.Departments);
DECLARE @JobCount    INT = (SELECT COUNT(*) FROM dbo.Jobs);
DECLARE @DeptsWithNoJobs INT =
(
    SELECT COUNT(*)
    FROM dbo.Departments D
    WHERE NOT EXISTS (SELECT 1 FROM dbo.Jobs J WHERE J.DepartmentID = D.DepartmentID)
);

PRINT '   Branches: ' + CAST(@BranchCount AS VARCHAR(10));
PRINT '   Departments: ' + CAST(@DeptCount AS VARCHAR(10));
PRINT '   Jobs: ' + CAST(@JobCount AS VARCHAR(10));
PRINT '   Departments with zero jobs: ' + CAST(@DeptsWithNoJobs AS VARCHAR(10));

IF @BranchCount = 0 OR @DeptCount = 0 OR @JobCount = 0
BEGIN
    RAISERROR('Branches, Departments, or Jobs is empty. Run 04_ReferenceData.sql before this script.', 16, 1);
END

IF @DeptsWithNoJobs > 0
BEGIN
    RAISERROR('At least one Department has zero matching Jobs rows - the Employees insert would divide by zero for that department. Fix Jobs/Departments before continuing.', 16, 1);
END
GO

PRINT '   Reference data OK.';
GO

/* =========================================================
   1. GENERATE EMPLOYEES - FIXED
   ========================================================= */

PRINT '1. Generating employees...';
GO

;WITH Numbers AS
(
    SELECT TOP (2000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects A
    CROSS JOIN sys.all_objects B
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
    CONCAT('EMP', RIGHT('000000' + CAST(N AS VARCHAR(6)), 6)),
    CASE
        WHEN N % 1000 = 1 THEN 'Ahmed'
        WHEN N % 1000 = 2 THEN 'Bassem'
        WHEN N % 1000 = 3 THEN 'Tamer'
        WHEN N % 1000 = 4 THEN 'Ziad'
        WHEN N % 1000 = 5 THEN 'Gamal'
        WHEN N % 1000 = 6 THEN 'Hassan'
        WHEN N % 1000 = 7 THEN 'Khaled'
        WHEN N % 1000 = 8 THEN 'Dalia'
        WHEN N % 1000 = 9 THEN 'Rami'
        WHEN N % 1000 = 10 THEN 'Zain'
        WHEN N % 1000 = 11 THEN 'Sameh'
        WHEN N % 1000 = 12 THEN 'Sherif'
        WHEN N % 1000 = 13 THEN 'Tarek'
        WHEN N % 1000 = 14 THEN 'Amr'
        WHEN N % 1000 = 15 THEN 'Farid'
        WHEN N % 1000 = 16 THEN 'Karim'
        WHEN N % 1000 = 17 THEN 'Laila'
        WHEN N % 1000 = 18 THEN 'Mahmoud'
        WHEN N % 1000 = 19 THEN 'Nour'
        WHEN N % 1000 = 20 THEN 'Omar'
        WHEN N % 1000 = 21 THEN 'Youssef'
        WHEN N % 1000 = 22 THEN 'Bilal'
        WHEN N % 1000 = 23 THEN 'Dina'
        WHEN N % 1000 = 24 THEN 'Fady'
        WHEN N % 1000 = 25 THEN 'Hany'
        WHEN N % 1000 = 26 THEN 'Mariam'
        WHEN N % 1000 = 27 THEN 'Nader'
        WHEN N % 1000 = 28 THEN 'Rania'
        WHEN N % 1000 = 29 THEN 'Salma'
        WHEN N % 1000 = 30 THEN 'Walid'
        WHEN N % 1000 = 31 THEN 'Ayman'
        WHEN N % 1000 = 32 THEN 'Basma'
        WHEN N % 1000 = 33 THEN 'Eslam'
        WHEN N % 1000 = 34 THEN 'Hesham'
        WHEN N % 1000 = 35 THEN 'Kamal'
        WHEN N % 1000 = 36 THEN 'Mona'
        WHEN N % 1000 = 37 THEN 'Nabil'
        WHEN N % 1000 = 38 THEN 'Reem'
        WHEN N % 1000 = 39 THEN 'Samer'
        WHEN N % 1000 = 40 THEN 'Wael'
        WHEN N % 1000 = 41 THEN 'Aya'
        WHEN N % 1000 = 42 THEN 'Fouad'
        WHEN N % 1000 = 43 THEN 'Hana'
        WHEN N % 1000 = 44 THEN 'Magdy'
        WHEN N % 1000 = 45 THEN 'Nada'
        WHEN N % 1000 = 46 THEN 'Rasha'
        WHEN N % 1000 = 47 THEN 'Sayed'
        WHEN N % 1000 = 48 THEN 'Yasser'
        WHEN N % 1000 = 49 THEN 'Ashraf'
        WHEN N % 1000 = 50 THEN 'Bahaa'
        WHEN N % 1000 = 51 THEN 'Fatma'
        WHEN N % 1000 = 52 THEN 'Hossam'
        WHEN N % 1000 = 53 THEN 'Mostafa'
        WHEN N % 1000 = 54 THEN 'Noha'
        WHEN N % 1000 = 55 THEN 'Sara'
        WHEN N % 1000 = 56 THEN 'Wafaa'
        WHEN N % 1000 = 57 THEN 'Aly'
        WHEN N % 1000 = 58 THEN 'Eman'
        WHEN N % 1000 = 59 THEN 'Hiba'
        WHEN N % 1000 = 60 THEN 'Mohamed'
        WHEN N % 1000 = 61 THEN 'Norhan'
        WHEN N % 1000 = 62 THEN 'Sobhy'
        WHEN N % 1000 = 63 THEN 'Wamda'
        WHEN N % 1000 = 64 THEN 'Abeer'
        WHEN N % 1000 = 65 THEN 'Ghada'
        WHEN N % 1000 = 66 THEN 'Hazem'
        WHEN N % 1000 = 67 THEN 'Mahi'
        WHEN N % 1000 = 68 THEN 'Nesreen'
        WHEN N % 1000 = 69 THEN 'Shady'
        WHEN N % 1000 = 70 THEN 'Wesam'
        WHEN N % 1000 = 71 THEN 'Adham'
        WHEN N % 1000 = 72 THEN 'Gehan'
        WHEN N % 1000 = 73 THEN 'Hoda'
        WHEN N % 1000 = 74 THEN 'Manal'
        WHEN N % 1000 = 75 THEN 'Nihal'
        WHEN N % 1000 = 76 THEN 'Soha'
        WHEN N % 1000 = 77 THEN 'Wajdy'
        WHEN N % 1000 = 78 THEN 'Akram'
        WHEN N % 1000 = 79 THEN 'Gabe'
        WHEN N % 1000 = 80 THEN 'Hala'
        WHEN N % 1000 = 81 THEN 'May'
        WHEN N % 1000 = 82 THEN 'Naglaa'
        WHEN N % 1000 = 83 THEN 'Shereen'
        WHEN N % 1000 = 84 THEN 'Waleed'
        WHEN N % 1000 = 85 THEN 'Azza'
        WHEN N % 1000 = 86 THEN 'Ghanem'
        WHEN N % 1000 = 87 THEN 'Hamdy'
        WHEN N % 1000 = 88 THEN 'Mervat'
        WHEN N % 1000 = 89 THEN 'Nehad'
        WHEN N % 1000 = 90 THEN 'Samir'
        WHEN N % 1000 = 91 THEN 'Wasim'
        WHEN N % 1000 = 92 THEN 'Alaa'
        WHEN N % 1000 = 93 THEN 'George'
        WHEN N % 1000 = 94 THEN 'Haithem'
        WHEN N % 1000 = 95 THEN 'Marwa'
        WHEN N % 1000 = 96 THEN 'Nourhan'
        WHEN N % 1000 = 97 THEN 'Sameha'
        WHEN N % 1000 = 98 THEN 'Wagdy'
        WHEN N % 1000 = 99 THEN 'Amal'
        WHEN N % 1000 = 100 THEN 'Habiba'
        WHEN N % 1000 = 101 THEN 'Medhat'
        WHEN N % 1000 = 102 THEN 'Nermin'
        WHEN N % 1000 = 103 THEN 'Sohaib'
        WHEN N % 1000 = 104 THEN 'Ward'
        WHEN N % 1000 = 105 THEN 'Anas'
        WHEN N % 1000 = 106 THEN 'Hamza'
        WHEN N % 1000 = 107 THEN 'Mounir'
        WHEN N % 1000 = 108 THEN 'Nizhar'
        WHEN N % 1000 = 109 THEN 'Suleiman'
        WHEN N % 1000 = 110 THEN 'Wassim'
        WHEN N % 1000 = 111 THEN 'Anwar'
        WHEN N % 1000 = 112 THEN 'Husseyn'
        WHEN N % 1000 = 113 THEN 'Mamdouh'
        WHEN N % 1000 = 114 THEN 'Naseem'
        WHEN N % 1000 = 115 THEN 'Sultan'
        WHEN N % 1000 = 116 THEN 'Wahib'
        WHEN N % 1000 = 117 THEN 'Arwa'
        WHEN N % 1000 = 118 THEN 'Hatem'
        WHEN N % 1000 = 119 THEN 'Moataz'
        WHEN N % 1000 = 200 THEN 'Nabilah'
        WHEN N % 1000 = 201 THEN 'Suhail'
        WHEN N % 1000 = 202 THEN 'Yara'
        WHEN N % 1000 = 203 THEN 'Asmaa'
        WHEN N % 1000 = 204 THEN 'Hanieh'
        WHEN N % 1000 = 205 THEN 'Moustafa'
        WHEN N % 1000 = 206 THEN 'Nadeen'
        WHEN N % 1000 = 207 THEN 'Sami'
        WHEN N % 1000 = 208 THEN 'Yasmine'
        WHEN N % 1000 = 209 THEN 'Atef'
        WHEN N % 1000 = 210 THEN 'Hoda'
        WHEN N % 1000 = 211 THEN 'Milad'
        WHEN N % 1000 = 212 THEN 'Nayla'
        WHEN N % 1000 = 213 THEN 'Shahd'
        WHEN N % 1000 = 214 THEN 'Yosri'
        WHEN N % 1000 = 215 THEN 'Ayman'
        WHEN N % 1000 = 216 THEN 'Hussein'
        WHEN N % 1000 = 217 THEN 'Mazen'
        WHEN N % 1000 = 218 THEN 'Nisreen'
        WHEN N % 1000 = 219 THEN 'Shehab'
        WHEN N % 1000 = 220 THEN 'Younes'
        WHEN N % 1000 = 221 THEN 'Aziz'
        WHEN N % 1000 = 222 THEN 'Haidar'
        WHEN N % 1000 = 223 THEN 'Mina'
        WHEN N % 1000 = 224 THEN 'Naeim'
        WHEN N % 1000 = 225 THEN 'Shaimaa'
        WHEN N % 1000 = 226 THEN 'Yousef'
        WHEN N % 1000 = 227 THEN 'Amin'
        WHEN N % 1000 = 228 THEN 'Helmy'
        WHEN N % 1000 = 229 THEN 'Mido'
        WHEN N % 1000 = 230 THEN 'Nawaf'
        WHEN N % 1000 = 231 THEN 'Sherin'
        WHEN N % 1000 = 232 THEN 'Youssra'
        WHEN N % 1000 = 233 THEN 'Abed'
        WHEN N % 1000 = 234 THEN 'Hafiz'
        WHEN N % 1000 = 235 THEN 'Mansour'
        WHEN N % 1000 = 236 THEN 'Nasser'
        WHEN N % 1000 = 237 THEN 'Sondos'
        WHEN N % 1000 = 238 THEN 'Yehia'
        WHEN N % 1000 = 239 THEN 'Adele'
        WHEN N % 1000 = 240 THEN 'Hassan'
        WHEN N % 1000 = 241 THEN 'Mounia'
        WHEN N % 1000 = 242 THEN 'Nahed'
        WHEN N % 1000 = 243 THEN 'Sabry'
        WHEN N % 1000 = 244 THEN 'Youseff'
        WHEN N % 1000 = 245 THEN 'Afeef'
        WHEN N % 1000 = 246 THEN 'Hala'
        WHEN N % 1000 = 247 THEN 'Maha'
        WHEN N % 1000 = 248 THEN 'Noura'
        WHEN N % 1000 = 249 THEN 'Safwat'
        WHEN N % 1000 = 250 THEN 'Yazid'
        WHEN N % 1000 = 251 THEN 'Ahlam'
        WHEN N % 1000 = 252 THEN 'Hana'
        WHEN N % 1000 = 253 THEN 'Majid'
        WHEN N % 1000 = 254 THEN 'Nidal'
        WHEN N % 1000 = 255 THEN 'Saad'
        WHEN N % 1000 = 256 THEN 'Yousra'
        WHEN N % 1000 = 257 THEN 'Akram'
        WHEN N % 1000 = 258 THEN 'Hedy'
        WHEN N % 1000 = 259 THEN 'Maged'
        WHEN N % 1000 = 260 THEN 'Nizar'
        WHEN N % 1000 = 261 THEN 'Said'
        WHEN N % 1000 = 262 THEN 'Yasin'
        WHEN N % 1000 = 263 THEN 'Areej'
        WHEN N % 1000 = 264 THEN 'Hoda'
        WHEN N % 1000 = 265 THEN 'Makram'
        WHEN N % 1000 = 266 THEN 'Nawel'
        WHEN N % 1000 = 267 THEN 'Salah'
        WHEN N % 1000 = 268 THEN 'Yassen'
        WHEN N % 1000 = 269 THEN 'Aida'
        WHEN N % 1000 = 270 THEN 'Hania'
        WHEN N % 1000 = 271 THEN 'Mokhtar'
        WHEN N % 1000 = 272 THEN 'Nourine'
        WHEN N % 1000 = 273 THEN 'Salem'
        WHEN N % 1000 = 274 THEN 'Yosra'
        WHEN N % 1000 = 275 THEN 'Abla'
        WHEN N % 1000 = 276 THEN 'Habib'
        WHEN N % 1000 = 277 THEN 'Murad'
        WHEN N % 1000 = 278 THEN 'Nabil'
        WHEN N % 1000 = 279 THEN 'Sami'
        WHEN N % 1000 = 280 THEN 'Younas'
        WHEN N % 1000 = 281 THEN 'Abir'
        WHEN N % 1000 = 282 THEN 'Hakim'
        WHEN N % 1000 = 283 THEN 'Mustapha'
        WHEN N % 1000 = 284 THEN 'Naja'
        WHEN N % 1000 = 285 THEN 'Selim'
        WHEN N % 1000 = 286 THEN 'Yousif'
        WHEN N % 1000 = 287 THEN 'Amani'
        WHEN N % 1000 = 288 THEN 'Hassan'
        WHEN N % 1000 = 289 THEN 'Mubarak'
        WHEN N % 1000 = 290 THEN 'Nezar'
        WHEN N % 1000 = 291 THEN 'Shaza'
        WHEN N % 1000 = 292 THEN 'Yacine'
        WHEN N % 1000 = 293 THEN 'Amina'
        WHEN N % 1000 = 294 THEN 'Hayssam'
        WHEN N % 1000 = 295 THEN 'Masoud'
        WHEN N % 1000 = 296 THEN 'Neveen'
        WHEN N % 1000 = 297 THEN 'Samer'
        WHEN N % 1000 = 298 THEN 'Yousef'
        WHEN N % 1000 = 299 THEN 'Amira'
        WHEN N % 1000 = 300 THEN 'Hesham'
        WHEN N % 1000 = 301 THEN 'Mahir'
        WHEN N % 1000 = 302 THEN 'Nagwa'
        WHEN N % 1000 = 303 THEN 'Sami'
        WHEN N % 1000 = 304 THEN 'Yasser'
        WHEN N % 1000 = 305 THEN 'Arif'
        WHEN N % 1000 = 306 THEN 'Hussein'
        WHEN N % 1000 = 307 THEN 'Moneim'
        WHEN N % 1000 = 308 THEN 'Nada'
        WHEN N % 1000 = 309 THEN 'Sameh'
        WHEN N % 1000 = 310 THEN 'Yassin'
        WHEN N % 1000 = 311 THEN 'Afaf'
        WHEN N % 1000 = 312 THEN 'Helmi'
        WHEN N % 1000 = 313 THEN 'Muhammed'
        WHEN N % 1000 = 314 THEN 'Noura'
        WHEN N % 1000 = 315 THEN 'Saeed'
        WHEN N % 1000 = 316 THEN 'Yousef'
        WHEN N % 1000 = 317 THEN 'Ahsan'
        WHEN N % 1000 = 318 THEN 'Hossam'
        WHEN N % 1000 = 319 THEN 'Mayar'
        WHEN N % 1000 = 320 THEN 'Nesrine'
        WHEN N % 1000 = 321 THEN 'Shaker'
        WHEN N % 1000 = 322 THEN 'Yonis'
        WHEN N % 1000 = 323 THEN 'Aiman'
        WHEN N % 1000 = 324 THEN 'Hanzala'
        WHEN N % 1000 = 325 THEN 'Monir'
        WHEN N % 1000 = 326 THEN 'Nida'
        WHEN N % 1000 = 327 THEN 'Soha'
        WHEN N % 1000 = 328 THEN 'Yusef'
        WHEN N % 1000 = 329 THEN 'Amer'
        WHEN N % 1000 = 330 THEN 'Hatem'
        WHEN N % 1000 = 331 THEN 'Milad'
        WHEN N % 1000 = 332 THEN 'Nura'
        WHEN N % 1000 = 333 THEN 'Sulaiman'
        WHEN N % 1000 = 334 THEN 'Yusra'
        WHEN N % 1000 = 335 THEN 'Anis'
        WHEN N % 1000 = 336 THEN 'Hamza'
        WHEN N % 1000 = 337 THEN 'Manar'
        WHEN N % 1000 = 338 THEN 'Nafisa'
        WHEN N % 1000 = 339 THEN 'Sujood'
        WHEN N % 1000 = 340 THEN 'Yusha'
        WHEN N % 1000 = 341 THEN 'Asad'
        WHEN N % 1000 = 342 THEN 'Haroun'
        WHEN N % 1000 = 343 THEN 'Mehmood'
        WHEN N % 1000 = 344 THEN 'Nayeem'
        WHEN N % 1000 = 345 THEN 'Safa'
        WHEN N % 1000 = 346 THEN 'Yousuf'
        WHEN N % 1000 = 347 THEN 'Azhar'
        WHEN N % 1000 = 348 THEN 'Hussam'
        WHEN N % 1000 = 349 THEN 'Mubashir'
        WHEN N % 1000 = 350 THEN 'Nuh'
        WHEN N % 1000 = 351 THEN 'Sana'
        WHEN N % 1000 = 352 THEN 'Yaqoob'
        WHEN N % 1000 = 353 THEN 'Atif'
        WHEN N % 1000 = 354 THEN 'Hisham'
        WHEN N % 1000 = 355 THEN 'Musab'
        WHEN N % 1000 = 356 THEN 'Niamat'
        WHEN N % 1000 = 357 THEN 'Sajid'
        WHEN N % 1000 = 358 THEN 'Yasin'
        WHEN N % 1000 = 359 THEN 'Adnan'
        WHEN N % 1000 = 360 THEN 'Hikmat'
        WHEN N % 1000 = 361 THEN 'Mahran'
        WHEN N % 1000 = 362 THEN 'Nazeer'
        WHEN N % 1000 = 363 THEN 'Subhi'
        WHEN N % 1000 = 364 THEN 'Yousef'
        WHEN N % 1000 = 365 THEN 'Asim'
        WHEN N % 1000 = 366 THEN 'Husain'
        WHEN N % 1000 = 367 THEN 'Marwan'
        WHEN N % 1000 = 368 THEN 'Naeem'
        WHEN N % 1000 = 369 THEN 'Sohail'
        WHEN N % 1000 = 370 THEN 'Yusuf'
        WHEN N % 1000 = 371 THEN 'Akil'
        WHEN N % 1000 = 372 THEN 'Haider'
        WHEN N % 1000 = 373 THEN 'Malik'
        WHEN N % 1000 = 374 THEN 'Naseer'
        WHEN N % 1000 = 375 THEN 'Shafik'
        WHEN N % 1000 = 376 THEN 'Yaser'
        WHEN N % 1000 = 377 THEN 'Aram'
        WHEN N % 1000 = 378 THEN 'Hasan'
        WHEN N % 1000 = 379 THEN 'Mohammad'
        WHEN N % 1000 = 380 THEN 'Nourddine'
        WHEN N % 1000 = 381 THEN 'Shokry'
        WHEN N % 1000 = 382 THEN 'Yaqoub'
        WHEN N % 1000 = 383 THEN 'Ayham'
        WHEN N % 1000 = 384 THEN 'Hazem'
        WHEN N % 1000 = 385 THEN 'Mostafa'
        WHEN N % 1000 = 386 THEN 'Nasir'
        WHEN N % 1000 = 387 THEN 'Samira'
        WHEN N % 1000 = 388 THEN 'Yazied'
        WHEN N % 1000 = 389 THEN 'Azam'
        WHEN N % 1000 = 390 THEN 'Hassan'
        WHEN N % 1000 = 391 THEN 'Mahmoud'
        WHEN N % 1000 = 392 THEN 'Nabil'
        WHEN N % 1000 = 393 THEN 'Sohair'
        WHEN N % 1000 = 394 THEN 'Yuseff'
        WHEN N % 1000 = 395 THEN 'Abdel'
        WHEN N % 1000 = 396 THEN 'Hani'
        WHEN N % 1000 = 397 THEN 'Majed'
        WHEN N % 1000 = 398 THEN 'Najib'
        WHEN N % 1000 = 399 THEN 'Sabri'
        WHEN N % 1000 = 400 THEN 'Yassine'
        WHEN N % 1000 = 401 THEN 'Adil'
        WHEN N % 1000 = 402 THEN 'Habib'
        WHEN N % 1000 = 403 THEN 'Mounir'
        WHEN N % 1000 = 404 THEN 'Nizar'
        WHEN N % 1000 = 405 THEN 'Sirag'
        WHEN N % 1000 = 406 THEN 'Younes'
        WHEN N % 1000 = 407 THEN 'Aref'
        WHEN N % 1000 = 408 THEN 'Haitam'
        WHEN N % 1000 = 409 THEN 'Medhat'
        WHEN N % 1000 = 410 THEN 'Naif'
        WHEN N % 1000 = 411 THEN 'Said'
        WHEN N % 1000 = 412 THEN 'Yousef'
        WHEN N % 1000 = 413 THEN 'Asraf'
        WHEN N % 1000 = 414 THEN 'Helal'
        WHEN N % 1000 = 415 THEN 'Mazin'
        WHEN N % 1000 = 416 THEN 'Nawaf'
        WHEN N % 1000 = 417 THEN 'Samah'
        WHEN N % 1000 = 418 THEN 'Yasser'
        WHEN N % 1000 = 419 THEN 'Ayub'
        WHEN N % 1000 = 420 THEN 'Hesham'
        WHEN N % 1000 = 421 THEN 'Mustafa'
        WHEN N % 1000 = 422 THEN 'Nouri'
        WHEN N % 1000 = 423 THEN 'Saber'
        WHEN N % 1000 = 424 THEN 'Yusuf'
        WHEN N % 1000 = 425 THEN 'Atef'
        WHEN N % 1000 = 426 THEN 'Hossam'
        WHEN N % 1000 = 427 THEN 'Moamen'
        WHEN N % 1000 = 428 THEN 'Nidal'
        WHEN N % 1000 = 429 THEN 'Saleh'
        WHEN N % 1000 = 430 THEN 'Yasin'
        WHEN N % 1000 = 431 THEN 'Aziz'
        WHEN N % 1000 = 432 THEN 'Haidar'
        WHEN N % 1000 = 433 THEN 'Maged'
        WHEN N % 1000 = 434 THEN 'Nasser'
        WHEN N % 1000 = 435 THEN 'Sedky'
        WHEN N % 1000 = 436 THEN 'Yosry'
        WHEN N % 1000 = 437 THEN 'Amer'
        WHEN N % 1000 = 438 THEN 'Hamdi'
        WHEN N % 1000 = 439 THEN 'Mourad'
        WHEN N % 1000 = 440 THEN 'Nabil'
        WHEN N % 1000 = 441 THEN 'Shawky'
        WHEN N % 1000 = 442 THEN 'Yousef'
        WHEN N % 1000 = 443 THEN 'Amjad'
        WHEN N % 1000 = 444 THEN 'Hussein'
        WHEN N % 1000 = 445 THEN 'Milad'
        WHEN N % 1000 = 446 THEN 'Naseem'
        WHEN N % 1000 = 447 THEN 'Shams'
        WHEN N % 1000 = 448 THEN 'Yehia'
        WHEN N % 1000 = 449 THEN 'Ayman'
        WHEN N % 1000 = 450 THEN 'Hassan'
        WHEN N % 1000 = 451 THEN 'Moustafa'
        WHEN N % 1000 = 452 THEN 'Nader'
        WHEN N % 1000 = 453 THEN 'Sherif'
        WHEN N % 1000 = 454 THEN 'Younis'
        WHEN N % 1000 = 455 THEN 'Akram'
        WHEN N % 1000 = 456 THEN 'Hakim'
        WHEN N % 1000 = 457 THEN 'Mina'
        WHEN N % 1000 = 458 THEN 'Nabil'
        WHEN N % 1000 = 459 THEN 'Sameh'
        WHEN N % 1000 = 460 THEN 'Youseff'
        WHEN N % 1000 = 461 THEN 'Arkan'
        WHEN N % 1000 = 462 THEN 'Hatem'
        WHEN N % 1000 = 463 THEN 'Mahmoud'
        WHEN N % 1000 = 464 THEN 'Nezar'
        WHEN N % 1000 = 465 THEN 'Samy'
        WHEN N % 1000 = 466 THEN 'Yasser'
        WHEN N % 1000 = 467 THEN 'Asem'
        WHEN N % 1000 = 468 THEN 'Hesham'
        WHEN N % 1000 = 469 THEN 'Mohamed'
        WHEN N % 1000 = 470 THEN 'Nour'
        WHEN N % 1000 = 471 THEN 'Soliman'
        WHEN N % 1000 = 472 THEN 'Yasin'
        WHEN N % 1000 = 473 THEN 'Ashraf'
        WHEN N % 1000 = 474 THEN 'Hamza'
        WHEN N % 1000 = 475 THEN 'Moataz'
        WHEN N % 1000 = 476 THEN 'Naef'
        WHEN N % 1000 = 477 THEN 'Sultan'
        WHEN N % 1000 = 478 THEN 'Yusef'
        WHEN N % 1000 = 479 THEN 'Awad'
        WHEN N % 1000 = 480 THEN 'Hany'
        WHEN N % 1000 = 481 THEN 'Mamdouh'
        WHEN N % 1000 = 482 THEN 'Nizar'
        WHEN N % 1000 = 483 THEN 'Shaker'
        WHEN N % 1000 = 484 THEN 'Yosif'
        WHEN N % 1000 = 485 THEN 'Azmi'
        WHEN N % 1000 = 486 THEN 'Helmy'
        WHEN N % 1000 = 487 THEN 'Medhat'
        WHEN N % 1000 = 488 THEN 'Nazeer'
        WHEN N % 1000 = 489 THEN 'Sayed'
        WHEN N % 1000 = 490 THEN 'Younes'
        WHEN N % 1000 = 491 THEN 'Atef'
        WHEN N % 1000 = 492 THEN 'Hassan'
        WHEN N % 1000 = 493 THEN 'Mazen'
        WHEN N % 1000 = 494 THEN 'Nabil'
        WHEN N % 1000 = 495 THEN 'Sobhi'
        WHEN N % 1000 = 496 THEN 'Yasser'
        WHEN N % 1000 = 497 THEN 'Alaa'
        WHEN N % 1000 = 498 THEN 'Hussein'
        WHEN N % 1000 = 499 THEN 'Mostafa'
        WHEN N % 1000 = 500 THEN 'Naser'
        WHEN N % 1000 = 501 THEN 'Saad'
        WHEN N % 1000 = 502 THEN 'Yousef'
        WHEN N % 1000 = 503 THEN 'Anas'
        WHEN N % 1000 = 504 THEN 'Haidar'
        WHEN N % 1000 = 505 THEN 'Mounir'
        WHEN N % 1000 = 506 THEN 'Naeem'
        WHEN N % 1000 = 507 THEN 'Salah'
        WHEN N % 1000 = 508 THEN 'Yasin'
        WHEN N % 1000 = 509 THEN 'Amr'
        WHEN N % 1000 = 510 THEN 'Hazem'
        WHEN N % 1000 = 511 THEN 'Maged'
        WHEN N % 1000 = 512 THEN 'Nawaf'
        WHEN N % 1000 = 513 THEN 'Saber'
        WHEN N % 1000 = 514 THEN 'Yehia'
        WHEN N % 1000 = 515 THEN 'Ayman'
        WHEN N % 1000 = 516 THEN 'Hossam'
        WHEN N % 1000 = 517 THEN 'Mohamed'
        WHEN N % 1000 = 518 THEN 'Nidal'
        WHEN N % 1000 = 519 THEN 'Sameh'
        WHEN N % 1000 = 520 THEN 'Yusuf'
        WHEN N % 1000 = 521 THEN 'Akram'
        WHEN N % 1000 = 522 THEN 'Hani'
        WHEN N % 1000 = 523 THEN 'Mahmoud'
        WHEN N % 1000 = 524 THEN 'Nabil'
        WHEN N % 1000 = 525 THEN 'Selim'
        WHEN N % 1000 = 526 THEN 'Yaser'
        WHEN N % 1000 = 527 THEN 'Atef'
        WHEN N % 1000 = 528 THEN 'Hamdi'
        WHEN N % 1000 = 529 THEN 'Mustafa'
        WHEN N % 1000 = 530 THEN 'Nasser'
        WHEN N % 1000 = 531 THEN 'Sharif'
        WHEN N % 1000 = 532 THEN 'Younis'
        WHEN N % 1000 = 533 THEN 'Asim'
        WHEN N % 1000 = 534 THEN 'Hesham'
        WHEN N % 1000 = 535 THEN 'Mina'
        WHEN N % 1000 = 536 THEN 'Nour'
        WHEN N % 1000 = 537 THEN 'Sultan'
        WHEN N % 1000 = 538 THEN 'Yousef'
        WHEN N % 1000 = 539 THEN 'Ahmad'
        WHEN N % 1000 = 540 THEN 'Haidar'
        WHEN N % 1000 = 541 THEN 'Mourad'
        WHEN N % 1000 = 542 THEN 'Naif'
        WHEN N % 1000 = 543 THEN 'Sayed'
        WHEN N % 1000 = 544 THEN 'Yasser'
        WHEN N % 1000 = 545 THEN 'Ali'
        WHEN N % 1000 = 546 THEN 'Hassan'
        WHEN N % 1000 = 547 THEN 'Moataz'
        WHEN N % 1000 = 548 THEN 'Nazar'
        WHEN N % 1000 = 549 THEN 'Sami'
        WHEN N % 1000 = 550 THEN 'Yasin'
        WHEN N % 1000 = 551 THEN 'Amjad'
        WHEN N % 1000 = 552 THEN 'Hussein'
        WHEN N % 1000 = 553 THEN 'Medhat'
        WHEN N % 1000 = 554 THEN 'Nabil'
        WHEN N % 1000 = 555 THEN 'Sobhy'
        WHEN N % 1000 = 556 THEN 'Yusef'
        WHEN N % 1000 = 557 THEN 'Amer'
        WHEN N % 1000 = 558 THEN 'Hossam'
        WHEN N % 1000 = 559 THEN 'Mazen'
        WHEN N % 1000 = 560 THEN 'Naser'
        WHEN N % 1000 = 561 THEN 'Saleh'
        WHEN N % 1000 = 562 THEN 'Yehia'
        WHEN N % 1000 = 563 THEN 'Anas'
        WHEN N % 1000 = 564 THEN 'Hatem'
        WHEN N % 1000 = 565 THEN 'Mohamed'
        WHEN N % 1000 = 566 THEN 'Nawaf'
        WHEN N % 1000 = 567 THEN 'Sherif'
        WHEN N % 1000 = 568 THEN 'Yousef'
        WHEN N % 1000 = 569 THEN 'Akram'
        WHEN N % 1000 = 570 THEN 'Hazem'
        WHEN N % 1000 = 571 THEN 'Mahmoud'
        WHEN N % 1000 = 572 THEN 'Nidal'
        WHEN N % 1000 = 573 THEN 'Saad'
        WHEN N % 1000 = 574 THEN 'Younes'
        WHEN N % 1000 = 575 THEN 'Ayman'
        WHEN N % 1000 = 576 THEN 'Hany'
        WHEN N % 1000 = 577 THEN 'Mostafa'
        WHEN N % 1000 = 578 THEN 'Nabil'
        WHEN N % 1000 = 579 THEN 'Sameh'
        WHEN N % 1000 = 580 THEN 'Yasser'
        WHEN N % 1000 = 581 THEN 'Alaa'
        WHEN N % 1000 = 582 THEN 'Hassan'
        WHEN N % 1000 = 583 THEN 'Maged'
        WHEN N % 1000 = 584 THEN 'Nasser'
        WHEN N % 1000 = 585 THEN 'Salah'
        WHEN N % 1000 = 586 THEN 'Yasin'
        WHEN N % 1000 = 587 THEN 'Atef'
        WHEN N % 1000 = 588 THEN 'Hesham'
        WHEN N % 1000 = 589 THEN 'Mina'
        WHEN N % 1000 = 590 THEN 'Nour'
        WHEN N % 1000 = 591 THEN 'Samy'
        WHEN N % 1000 = 592 THEN 'Yusuf'
        WHEN N % 1000 = 593 THEN 'Amr'
        WHEN N % 1000 = 594 THEN 'Haidar'
        WHEN N % 1000 = 595 THEN 'Mourad'
        WHEN N % 1000 = 596 THEN 'Naif'
        WHEN N % 1000 = 597 THEN 'Saber'
        WHEN N % 1000 = 598 THEN 'Yehia'
        WHEN N % 1000 = 599 THEN 'Asim'
        WHEN N % 1000 = 600 THEN 'Hussein'
        WHEN N % 1000 = 601 THEN 'Medhat'
        WHEN N % 1000 = 602 THEN 'Nabil'
        WHEN N % 1000 = 603 THEN 'Sherif'
        WHEN N % 1000 = 604 THEN 'Yousef'
        WHEN N % 1000 = 605 THEN 'Ahmad'
        WHEN N % 1000 = 606 THEN 'Hossam'
        WHEN N % 1000 = 607 THEN 'Mazen'
        WHEN N % 1000 = 608 THEN 'Naser'
        WHEN N % 1000 = 609 THEN 'Sobhy'
        WHEN N % 1000 = 610 THEN 'Yaser'
        WHEN N % 1000 = 611 THEN 'Ali'
        WHEN N % 1000 = 612 THEN 'Hatem'
        WHEN N % 1000 = 613 THEN 'Mohamed'
        WHEN N % 1000 = 614 THEN 'Nawaf'
        WHEN N % 1000 = 615 THEN 'Sayed'
        WHEN N % 1000 = 616 THEN 'Younis'
        WHEN N % 1000 = 617 THEN 'Amer'
        WHEN N % 1000 = 618 THEN 'Hazem'
        WHEN N % 1000 = 619 THEN 'Mahmoud'
        WHEN N % 1000 = 620 THEN 'Nidal'
        WHEN N % 1000 = 621 THEN 'Sami'
        WHEN N % 1000 = 622 THEN 'Yasser'
        WHEN N % 1000 = 623 THEN 'Anas'
        WHEN N % 1000 = 624 THEN 'Hany'
        WHEN N % 1000 = 625 THEN 'Mostafa'
        WHEN N % 1000 = 626 THEN 'Nabil'
        WHEN N % 1000 = 627 THEN 'Saleh'
        WHEN N % 1000 = 628 THEN 'Yasin'
        WHEN N % 1000 = 629 THEN 'Akram'
        WHEN N % 1000 = 630 THEN 'Hassan'
        WHEN N % 1000 = 631 THEN 'Maged'
        WHEN N % 1000 = 632 THEN 'Nasser'
        WHEN N % 1000 = 633 THEN 'Sameh'
        WHEN N % 1000 = 634 THEN 'Yusef'
        WHEN N % 1000 = 635 THEN 'Ayman'
        WHEN N % 1000 = 636 THEN 'Hesham'
        WHEN N % 1000 = 637 THEN 'Mina'
        WHEN N % 1000 = 638 THEN 'Nour'
        WHEN N % 1000 = 639 THEN 'Salah'
        WHEN N % 1000 = 640 THEN 'Yehia'
        WHEN N % 1000 = 641 THEN 'Alaa'
        WHEN N % 1000 = 642 THEN 'Haidar'
        WHEN N % 1000 = 643 THEN 'Mourad'
        WHEN N % 1000 = 644 THEN 'Naif'
        WHEN N % 1000 = 645 THEN 'Samy'
        WHEN N % 1000 = 646 THEN 'Yousef'
        WHEN N % 1000 = 647 THEN 'Atef'
        WHEN N % 1000 = 648 THEN 'Hussein'
        WHEN N % 1000 = 649 THEN 'Medhat'
        WHEN N % 1000 = 650 THEN 'Nabil'
        WHEN N % 1000 = 651 THEN 'Saber'
        WHEN N % 1000 = 652 THEN 'Younes'
        WHEN N % 1000 = 653 THEN 'Amr'
        WHEN N % 1000 = 654 THEN 'Hossam'
        WHEN N % 1000 = 655 THEN 'Mazen'
        WHEN N % 1000 = 656 THEN 'Naser'
        WHEN N % 1000 = 657 THEN 'Sherif'
        WHEN N % 1000 = 658 THEN 'Yasser'
        WHEN N % 1000 = 659 THEN 'Asim'
        WHEN N % 1000 = 660 THEN 'Hatem'
        WHEN N % 1000 = 661 THEN 'Mohamed'
        WHEN N % 1000 = 662 THEN 'Nawaf'
        WHEN N % 1000 = 663 THEN 'Sobhy'
        WHEN N % 1000 = 664 THEN 'Yasin'
        WHEN N % 1000 = 665 THEN 'Ahmad'
        WHEN N % 1000 = 666 THEN 'Hazem'
        WHEN N % 1000 = 667 THEN 'Mahmoud'
        WHEN N % 1000 = 668 THEN 'Nidal'
        WHEN N % 1000 = 669 THEN 'Sayed'
        WHEN N % 1000 = 670 THEN 'Yusuf'
        WHEN N % 1000 = 671 THEN 'Ali'
        WHEN N % 1000 = 672 THEN 'Hany'
        WHEN N % 1000 = 673 THEN 'Mostafa'
        WHEN N % 1000 = 674 THEN 'Nabil'
        WHEN N % 1000 = 675 THEN 'Sami'
        WHEN N % 1000 = 676 THEN 'Yaser'
        WHEN N % 1000 = 677 THEN 'Amer'
        WHEN N % 1000 = 678 THEN 'Hassan'
        WHEN N % 1000 = 679 THEN 'Maged'
        WHEN N % 1000 = 680 THEN 'Nasser'
        WHEN N % 1000 = 681 THEN 'Saleh'
        WHEN N % 1000 = 682 THEN 'Younis'
        WHEN N % 1000 = 683 THEN 'Anas'
        WHEN N % 1000 = 684 THEN 'Hesham'
        WHEN N % 1000 = 685 THEN 'Mina'
        WHEN N % 1000 = 686 THEN 'Nour'
        WHEN N % 1000 = 687 THEN 'Sameh'
        WHEN N % 1000 = 688 THEN 'Yehia'
        WHEN N % 1000 = 689 THEN 'Akram'
        WHEN N % 1000 = 690 THEN 'Haidar'
        WHEN N % 1000 = 691 THEN 'Mourad'
        WHEN N % 1000 = 692 THEN 'Naif'
        WHEN N % 1000 = 693 THEN 'Salah'
        WHEN N % 1000 = 694 THEN 'Yousef'
        WHEN N % 1000 = 695 THEN 'Ayman'
        WHEN N % 1000 = 696 THEN 'Hussein'
        WHEN N % 1000 = 697 THEN 'Medhat'
        WHEN N % 1000 = 698 THEN 'Nabil'
        WHEN N % 1000 = 699 THEN 'Samy'
        WHEN N % 1000 = 700 THEN 'Yasser'
        WHEN N % 1000 = 701 THEN 'Alaa'
        WHEN N % 1000 = 702 THEN 'Hossam'
        WHEN N % 1000 = 703 THEN 'Mazen'
        WHEN N % 1000 = 704 THEN 'Naser'
        WHEN N % 1000 = 705 THEN 'Saber'
        WHEN N % 1000 = 706 THEN 'Yasin'
        WHEN N % 1000 = 707 THEN 'Atef'
        WHEN N % 1000 = 708 THEN 'Hatem'
        WHEN N % 1000 = 709 THEN 'Mohamed'
        WHEN N % 1000 = 710 THEN 'Nawaf'
        WHEN N % 1000 = 711 THEN 'Sherif'
        WHEN N % 1000 = 712 THEN 'Yusef'
        WHEN N % 1000 = 713 THEN 'Amr'
        WHEN N % 1000 = 714 THEN 'Hazem'
        WHEN N % 1000 = 715 THEN 'Mahmoud'
        WHEN N % 1000 = 716 THEN 'Nidal'
        WHEN N % 1000 = 717 THEN 'Sobhy'
        WHEN N % 1000 = 718 THEN 'Younes'
        WHEN N % 1000 = 719 THEN 'Asim'
        WHEN N % 1000 = 720 THEN 'Hany'
        WHEN N % 1000 = 721 THEN 'Mostafa'
        WHEN N % 1000 = 722 THEN 'Nabil'
        WHEN N % 1000 = 723 THEN 'Sayed'
        WHEN N % 1000 = 724 THEN 'Yusuf'
        WHEN N % 1000 = 725 THEN 'Ahmad'
        WHEN N % 1000 = 726 THEN 'Hassan'
        WHEN N % 1000 = 727 THEN 'Maged'
        WHEN N % 1000 = 728 THEN 'Nasser'
        WHEN N % 1000 = 729 THEN 'Sami'
        WHEN N % 1000 = 730 THEN 'Yaser'
        WHEN N % 1000 = 731 THEN 'Ali'
        WHEN N % 1000 = 732 THEN 'Hesham'
        WHEN N % 1000 = 733 THEN 'Mina'
        WHEN N % 1000 = 734 THEN 'Nour'
        WHEN N % 1000 = 735 THEN 'Saleh'
        WHEN N % 1000 = 736 THEN 'Yehia'
        WHEN N % 1000 = 737 THEN 'Amer'
        WHEN N % 1000 = 738 THEN 'Haidar'
        WHEN N % 1000 = 739 THEN 'Mourad'
        WHEN N % 1000 = 740 THEN 'Naif'
        WHEN N % 1000 = 741 THEN 'Sameh'
        WHEN N % 1000 = 742 THEN 'Yousef'
        WHEN N % 1000 = 743 THEN 'Anas'
        WHEN N % 1000 = 744 THEN 'Hussein'
        WHEN N % 1000 = 745 THEN 'Medhat'
        WHEN N % 1000 = 746 THEN 'Nabil'
        WHEN N % 1000 = 747 THEN 'Salah'
        WHEN N % 1000 = 748 THEN 'Yasser'
        WHEN N % 1000 = 749 THEN 'Akram'
        WHEN N % 1000 = 750 THEN 'Hossam'
        WHEN N % 1000 = 751 THEN 'Mazen'
        WHEN N % 1000 = 752 THEN 'Naser'
        WHEN N % 1000 = 753 THEN 'Samy'
        WHEN N % 1000 = 754 THEN 'Yasin'
        WHEN N % 1000 = 755 THEN 'Ayman'
        WHEN N % 1000 = 756 THEN 'Hatem'
        WHEN N % 1000 = 757 THEN 'Mohamed'
        WHEN N % 1000 = 758 THEN 'Nawaf'
        WHEN N % 1000 = 759 THEN 'Saber'
        WHEN N % 1000 = 760 THEN 'Younes'
        WHEN N % 1000 = 761 THEN 'Alaa'
        WHEN N % 1000 = 762 THEN 'Hazem'
        WHEN N % 1000 = 763 THEN 'Mahmoud'
        WHEN N % 1000 = 764 THEN 'Nidal'
        WHEN N % 1000 = 765 THEN 'Sherif'
        WHEN N % 1000 = 766 THEN 'Yusef'
        WHEN N % 1000 = 767 THEN 'Atef'
        WHEN N % 1000 = 768 THEN 'Hany'
        WHEN N % 1000 = 769 THEN 'Mostafa'
        WHEN N % 1000 = 770 THEN 'Nabil'
        WHEN N % 1000 = 771 THEN 'Sobhy'
        WHEN N % 1000 = 772 THEN 'Yusuf'
        WHEN N % 1000 = 773 THEN 'Amr'
        WHEN N % 1000 = 774 THEN 'Hassan'
        WHEN N % 1000 = 775 THEN 'Maged'
        WHEN N % 1000 = 776 THEN 'Nasser'
        WHEN N % 1000 = 777 THEN 'Sayed'
        WHEN N % 1000 = 778 THEN 'Yehia'
        WHEN N % 1000 = 779 THEN 'Asim'
        WHEN N % 1000 = 780 THEN 'Hesham'
        WHEN N % 1000 = 781 THEN 'Mina'
        WHEN N % 1000 = 782 THEN 'Nour'
        WHEN N % 1000 = 783 THEN 'Sami'
        WHEN N % 1000 = 784 THEN 'Yaser'
        WHEN N % 1000 = 785 THEN 'Ahmad'
        WHEN N % 1000 = 786 THEN 'Haidar'
        WHEN N % 1000 = 787 THEN 'Mourad'
        WHEN N % 1000 = 788 THEN 'Naif'
        WHEN N % 1000 = 789 THEN 'Saleh'
        WHEN N % 1000 = 790 THEN 'Yousef'
        WHEN N % 1000 = 791 THEN 'Ali'
        WHEN N % 1000 = 792 THEN 'Hussein'
        WHEN N % 1000 = 793 THEN 'Medhat'
        WHEN N % 1000 = 794 THEN 'Nabil'
        WHEN N % 1000 = 795 THEN 'Sameh'
        WHEN N % 1000 = 796 THEN 'Yasser'
        WHEN N % 1000 = 797 THEN 'Amer'
        WHEN N % 1000 = 798 THEN 'Hossam'
        WHEN N % 1000 = 799 THEN 'Mazen'
        WHEN N % 1000 = 800 THEN 'Naser'
        WHEN N % 1000 = 801 THEN 'Salah'
        WHEN N % 1000 = 802 THEN 'Yasin'
        WHEN N % 1000 = 803 THEN 'Anas'
        WHEN N % 1000 = 804 THEN 'Hatem'
        WHEN N % 1000 = 805 THEN 'Mohamed'
        WHEN N % 1000 = 806 THEN 'Nawaf'
        WHEN N % 1000 = 807 THEN 'Samy'
        WHEN N % 1000 = 808 THEN 'Younes'
        WHEN N % 1000 = 809 THEN 'Akram'
        WHEN N % 1000 = 810 THEN 'Hazem'
        WHEN N % 1000 = 811 THEN 'Mahmoud'
        WHEN N % 1000 = 812 THEN 'Nidal'
        WHEN N % 1000 = 813 THEN 'Saber'
        WHEN N % 1000 = 814 THEN 'Yusef'
        WHEN N % 1000 = 815 THEN 'Ayman'
        WHEN N % 1000 = 816 THEN 'Hany'
        WHEN N % 1000 = 817 THEN 'Mostafa'
        WHEN N % 1000 = 818 THEN 'Nabil'
        WHEN N % 1000 = 819 THEN 'Sherif'
        WHEN N % 1000 = 820 THEN 'Yusuf'
        WHEN N % 1000 = 821 THEN 'Alaa'
        WHEN N % 1000 = 822 THEN 'Hassan'
        WHEN N % 1000 = 823 THEN 'Maged'
        WHEN N % 1000 = 824 THEN 'Nasser'
        WHEN N % 1000 = 825 THEN 'Sobhy'
        WHEN N % 1000 = 826 THEN 'Yehia'
        WHEN N % 1000 = 827 THEN 'Atef'
        WHEN N % 1000 = 828 THEN 'Hesham'
        WHEN N % 1000 = 829 THEN 'Mina'
        WHEN N % 1000 = 830 THEN 'Nour'
        WHEN N % 1000 = 831 THEN 'Sayed'
        WHEN N % 1000 = 832 THEN 'Yaser'
        WHEN N % 1000 = 833 THEN 'Amr'
        WHEN N % 1000 = 834 THEN 'Haidar'
        WHEN N % 1000 = 835 THEN 'Mourad'
        WHEN N % 1000 = 836 THEN 'Naif'
        WHEN N % 1000 = 837 THEN 'Sami'
        WHEN N % 1000 = 838 THEN 'Yousef'
        WHEN N % 1000 = 839 THEN 'Asim'
        WHEN N % 1000 = 840 THEN 'Hussein'
        WHEN N % 1000 = 841 THEN 'Medhat'
        WHEN N % 1000 = 842 THEN 'Nabil'
        WHEN N % 1000 = 843 THEN 'Saleh'
        WHEN N % 1000 = 844 THEN 'Yasser'
        WHEN N % 1000 = 845 THEN 'Ahmad'
        WHEN N % 1000 = 846 THEN 'Hossam'
        WHEN N % 1000 = 847 THEN 'Mazen'
        WHEN N % 1000 = 848 THEN 'Naser'
        WHEN N % 1000 = 849 THEN 'Sameh'
        WHEN N % 1000 = 850 THEN 'Yasin'
        WHEN N % 1000 = 851 THEN 'Ali'
        WHEN N % 1000 = 852 THEN 'Hatem'
        WHEN N % 1000 = 853 THEN 'Mohamed'
        WHEN N % 1000 = 854 THEN 'Nawaf'
        WHEN N % 1000 = 855 THEN 'Salah'
        WHEN N % 1000 = 856 THEN 'Younes'
        WHEN N % 1000 = 857 THEN 'Amer'
        WHEN N % 1000 = 858 THEN 'Hazem'
        WHEN N % 1000 = 859 THEN 'Mahmoud'
        WHEN N % 1000 = 860 THEN 'Nidal'
        WHEN N % 1000 = 861 THEN 'Samy'
        WHEN N % 1000 = 862 THEN 'Yusef'
        WHEN N % 1000 = 863 THEN 'Anas'
        WHEN N % 1000 = 864 THEN 'Hany'
        WHEN N % 1000 = 865 THEN 'Mostafa'
        WHEN N % 1000 = 866 THEN 'Nabil'
        WHEN N % 1000 = 867 THEN 'Saber'
        WHEN N % 1000 = 868 THEN 'Yusuf'
        WHEN N % 1000 = 869 THEN 'Akram'
        WHEN N % 1000 = 870 THEN 'Hassan'
        WHEN N % 1000 = 871 THEN 'Maged'
        WHEN N % 1000 = 872 THEN 'Nasser'
        WHEN N % 1000 = 873 THEN 'Sherif'
        WHEN N % 1000 = 874 THEN 'Yehia'
        WHEN N % 1000 = 875 THEN 'Ayman'
        WHEN N % 1000 = 876 THEN 'Hesham'
        WHEN N % 1000 = 877 THEN 'Mina'
        WHEN N % 1000 = 878 THEN 'Nour'
        WHEN N % 1000 = 879 THEN 'Sobhy'
        WHEN N % 1000 = 880 THEN 'Yaser'
        WHEN N % 1000 = 881 THEN 'Alaa'
        WHEN N % 1000 = 882 THEN 'Haidar'
        WHEN N % 1000 = 883 THEN 'Mourad'
        WHEN N % 1000 = 884 THEN 'Naif'
        WHEN N % 1000 = 885 THEN 'Sayed'
        WHEN N % 1000 = 886 THEN 'Yousef'
        WHEN N % 1000 = 887 THEN 'Atef'
        WHEN N % 1000 = 888 THEN 'Hussein'
        WHEN N % 1000 = 889 THEN 'Medhat'
        WHEN N % 1000 = 890 THEN 'Nabil'
        WHEN N % 1000 = 891 THEN 'Sami'
        WHEN N % 1000 = 892 THEN 'Yasser'
        WHEN N % 1000 = 893 THEN 'Amr'
        WHEN N % 1000 = 894 THEN 'Hossam'
        WHEN N % 1000 = 895 THEN 'Mazen'
        WHEN N % 1000 = 896 THEN 'Naser'
        WHEN N % 1000 = 897 THEN 'Saleh'
        WHEN N % 1000 = 898 THEN 'Yasin'
        WHEN N % 1000 = 899 THEN 'Asim'
        WHEN N % 1000 = 900 THEN 'Hatem'
        WHEN N % 1000 = 901 THEN 'Mohamed'
        WHEN N % 1000 = 902 THEN 'Nawaf'
        WHEN N % 1000 = 903 THEN 'Sameh'
        WHEN N % 1000 = 904 THEN 'Younes'
        WHEN N % 1000 = 905 THEN 'Ahmad'
        WHEN N % 1000 = 906 THEN 'Hazem'
        WHEN N % 1000 = 907 THEN 'Mahmoud'
        WHEN N % 1000 = 908 THEN 'Nidal'
        WHEN N % 1000 = 909 THEN 'Salah'
        WHEN N % 1000 = 910 THEN 'Yusef'
        WHEN N % 1000 = 911 THEN 'Ali'
        WHEN N % 1000 = 912 THEN 'Hany'
        WHEN N % 1000 = 913 THEN 'Mostafa'
        WHEN N % 1000 = 914 THEN 'Nabil'
        WHEN N % 1000 = 915 THEN 'Samy'
        WHEN N % 1000 = 916 THEN 'Yusuf'
        WHEN N % 1000 = 917 THEN 'Amer'
        WHEN N % 1000 = 918 THEN 'Hassan'
        WHEN N % 1000 = 919 THEN 'Maged'
        WHEN N % 1000 = 920 THEN 'Nasser'
        WHEN N % 1000 = 921 THEN 'Saber'
        WHEN N % 1000 = 922 THEN 'Yehia'
        WHEN N % 1000 = 923 THEN 'Anas'
        WHEN N % 1000 = 924 THEN 'Hesham'
        WHEN N % 1000 = 925 THEN 'Mina'
        WHEN N % 1000 = 926 THEN 'Nour'
        WHEN N % 1000 = 927 THEN 'Sherif'
        WHEN N % 1000 = 928 THEN 'Yaser'
        WHEN N % 1000 = 929 THEN 'Akram'
        WHEN N % 1000 = 930 THEN 'Haidar'
        WHEN N % 1000 = 931 THEN 'Mourad'
        WHEN N % 1000 = 932 THEN 'Naif'
        WHEN N % 1000 = 933 THEN 'Sobhy'
        WHEN N % 1000 = 934 THEN 'Yousef'
        WHEN N % 1000 = 935 THEN 'Ayman'
        WHEN N % 1000 = 936 THEN 'Hussein'
        WHEN N % 1000 = 937 THEN 'Medhat'
        WHEN N % 1000 = 938 THEN 'Nabil'
        WHEN N % 1000 = 939 THEN 'Sayed'
        WHEN N % 1000 = 940 THEN 'Yasser'
        WHEN N % 1000 = 941 THEN 'Alaa'
        WHEN N % 1000 = 942 THEN 'Hossam'
        WHEN N % 1000 = 943 THEN 'Mazen'
        WHEN N % 1000 = 944 THEN 'Naser'
        WHEN N % 1000 = 945 THEN 'Sami'
        WHEN N % 1000 = 946 THEN 'Yasin'
        WHEN N % 1000 = 947 THEN 'Atef'
        WHEN N % 1000 = 948 THEN 'Hatem'
        WHEN N % 1000 = 949 THEN 'Mohamed'
        WHEN N % 1000 = 950 THEN 'Nawaf'
        WHEN N % 1000 = 951 THEN 'Saleh'
        WHEN N % 1000 = 952 THEN 'Younes'
        WHEN N % 1000 = 953 THEN 'Amr'
        WHEN N % 1000 = 954 THEN 'Hazem'
        WHEN N % 1000 = 955 THEN 'Mahmoud'
        WHEN N % 1000 = 956 THEN 'Nidal'
        WHEN N % 1000 = 957 THEN 'Sameh'
        WHEN N % 1000 = 958 THEN 'Yusef'
        WHEN N % 1000 = 959 THEN 'Asim'
        WHEN N % 1000 = 960 THEN 'Hany'
        WHEN N % 1000 = 961 THEN 'Mostafa'
        WHEN N % 1000 = 962 THEN 'Nabil'
        WHEN N % 1000 = 963 THEN 'Salah'
        WHEN N % 1000 = 964 THEN 'Yusuf'
        WHEN N % 1000 = 965 THEN 'Ahmad'
        WHEN N % 1000 = 966 THEN 'Hassan'
        WHEN N % 1000 = 967 THEN 'Maged'
        WHEN N % 1000 = 968 THEN 'Nasser'
        WHEN N % 1000 = 969 THEN 'Samy'
        WHEN N % 1000 = 970 THEN 'Yehia'
        WHEN N % 1000 = 971 THEN 'Ali'
        WHEN N % 1000 = 972 THEN 'Hesham'
        WHEN N % 1000 = 973 THEN 'Mina'
        WHEN N % 1000 = 974 THEN 'Nour'
        WHEN N % 1000 = 975 THEN 'Saber'
        WHEN N % 1000 = 976 THEN 'Yaser'
        WHEN N % 1000 = 977 THEN 'Amer'
        WHEN N % 1000 = 978 THEN 'Haidar'
        WHEN N % 1000 = 979 THEN 'Mourad'
        WHEN N % 1000 = 980 THEN 'Naif'
        WHEN N % 1000 = 981 THEN 'Sherif'
        WHEN N % 1000 = 982 THEN 'Yousef'
        WHEN N % 1000 = 983 THEN 'Anas'
        WHEN N % 1000 = 984 THEN 'Hussein'
        WHEN N % 1000 = 985 THEN 'Medhat'
        WHEN N % 1000 = 986 THEN 'Nabil'
        WHEN N % 1000 = 987 THEN 'Sobhy'
        WHEN N % 1000 = 988 THEN 'Yasser'
        WHEN N % 1000 = 989 THEN 'Akram'
        WHEN N % 1000 = 990 THEN 'Hossam'
        WHEN N % 1000 = 991 THEN 'Mazen'
        WHEN N % 1000 = 992 THEN 'Naser'
        WHEN N % 1000 = 993 THEN 'Sayed'
        WHEN N % 1000 = 994 THEN 'Yasin'
        WHEN N % 1000 = 995 THEN 'Ayman'
        WHEN N % 1000 = 996 THEN 'Hatem'
        WHEN N % 1000 = 997 THEN 'Mohamed'
        WHEN N % 1000 = 998 THEN 'Nawaf'
        WHEN N % 1000 = 999 THEN 'Sami'
        ELSE 'Younes'
    END,
    CASE
        WHEN N % 500 = 1 THEN 'Abdelrahman'
        WHEN N % 500 = 2 THEN 'Bakar'
        WHEN N % 500 = 3 THEN 'Dawood'
        WHEN N % 500 = 4 THEN 'Elsayed'
        WHEN N % 500 = 5 THEN 'Fahmy'
        WHEN N % 500 = 6 THEN 'Ghanem'
        WHEN N % 500 = 7 THEN 'Hassan'
        WHEN N % 500 = 8 THEN 'Ibrahim'
        WHEN N % 500 = 9 THEN 'Jaber'
        WHEN N % 500 = 10 THEN 'Khalil'
        WHEN N % 500 = 11 THEN 'Lotfy'
        WHEN N % 500 = 12 THEN 'Mahmoud'
        WHEN N % 500 = 13 THEN 'Nasser'
        WHEN N % 500 = 14 THEN 'Othman'
        WHEN N % 500 = 15 THEN 'Radwan'
        WHEN N % 500 = 16 THEN 'Salem'
        WHEN N % 500 = 17 THEN 'Taha'
        WHEN N % 500 = 18 THEN 'Wahba'
        WHEN N % 500 = 19 THEN 'Younis'
        WHEN N % 500 = 20 THEN 'Zaki'
        WHEN N % 500 = 21 THEN 'Amer'
        WHEN N % 500 = 22 THEN 'Badawi'
        WHEN N % 500 = 23 THEN 'Darwish'
        WHEN N % 500 = 24 THEN 'Ezzo'
        WHEN N % 500 = 25 THEN 'Fayed'
        WHEN N % 500 = 26 THEN 'Gharib'
        WHEN N % 500 = 27 THEN 'Hussein'
        WHEN N % 500 = 28 THEN 'Ismail'
        WHEN N % 500 = 29 THEN 'Jalal'
        WHEN N % 500 = 30 THEN 'Kamel'
        WHEN N % 500 = 31 THEN 'Labib'
        WHEN N % 500 = 32 THEN 'Mostafa'
        WHEN N % 500 = 33 THEN 'Nabil'
        WHEN N % 500 = 34 THEN 'Omar'
        WHEN N % 500 = 35 THEN 'Rashed'
        WHEN N % 500 = 36 THEN 'Sami'
        WHEN N % 500 = 37 THEN 'Tawfik'
        WHEN N % 500 = 38 THEN 'Wagdy'
        WHEN N % 500 = 39 THEN 'Youssef'
        WHEN N % 500 = 40 THEN 'Zahran'
        WHEN N % 500 = 41 THEN 'Abbas'
        WHEN N % 500 = 42 THEN 'Bishara'
        WHEN N % 500 = 43 THEN 'Diab'
        WHEN N % 500 = 44 THEN 'Elmasry'
        WHEN N % 500 = 45 THEN 'Fouad'
        WHEN N % 500 = 46 THEN 'Gomaa'
        WHEN N % 500 = 47 THEN 'Helmy'
        WHEN N % 500 = 48 THEN 'Issa'
        WHEN N % 500 = 49 THEN 'Jawad'
        WHEN N % 500 = 50 THEN 'Kassab'
        WHEN N % 500 = 51 THEN 'Loutfi'
        WHEN N % 500 = 52 THEN 'Mansour'
        WHEN N % 500 = 53 THEN 'Naguib'
        WHEN N % 500 = 54 THEN 'Obaid'
        WHEN N % 500 = 55 THEN 'Rizk'
        WHEN N % 500 = 56 THEN 'Soliman'
        WHEN N % 500 = 57 THEN 'Tarek'
        WHEN N % 500 = 58 THEN 'Wafik'
        WHEN N % 500 = 59 THEN 'Yasin'
        WHEN N % 500 = 60 THEN 'Zayed'
        WHEN N % 500 = 61 THEN 'Aly'
        WHEN N % 500 = 62 THEN 'Badr'
        WHEN N % 500 = 63 THEN 'Doma'
        WHEN N % 500 = 64 THEN 'Elbaz'
        WHEN N % 500 = 65 THEN 'Farag'
        WHEN N % 500 = 66 THEN 'Ghazal'
        WHEN N % 500 = 67 THEN 'Hafez'
        WHEN N % 500 = 68 THEN 'Imam'
        WHEN N % 500 = 69 THEN 'Jameel'
        WHEN N % 500 = 70 THEN 'Khedr'
        WHEN N % 500 = 71 THEN 'Luqman'
        WHEN N % 500 = 72 THEN 'Metwally'
        WHEN N % 500 = 73 THEN 'Nour'
        WHEN N % 500 = 74 THEN 'Okasha'
        WHEN N % 500 = 75 THEN 'Ragab'
        WHEN N % 500 = 76 THEN 'Sadek'
        WHEN N % 500 = 77 THEN 'Talat'
        WHEN N % 500 = 78 THEN 'Waleed'
        WHEN N % 500 = 79 THEN 'Yousef'
        WHEN N % 500 = 80 THEN 'Zidan'
        WHEN N % 500 = 81 THEN 'Ashraf'
        WHEN N % 500 = 82 THEN 'Bassiouny'
        WHEN N % 500 = 83 THEN 'Dahab'
        WHEN N % 500 = 84 THEN 'Elshamy'
        WHEN N % 500 = 85 THEN 'Farouk'
        WHEN N % 500 = 86 THEN 'Gharib'
        WHEN N % 500 = 87 THEN 'Hamdy'
        WHEN N % 500 = 88 THEN 'Ibrahim'
        WHEN N % 500 = 89 THEN 'Jouda'
        WHEN N % 500 = 90 THEN 'Khaled'
        WHEN N % 500 = 91 THEN 'Lamei'
        WHEN N % 500 = 92 THEN 'Mounir'
        WHEN N % 500 = 93 THEN 'Najeeb'
        WHEN N % 500 = 94 THEN 'Omar'
        WHEN N % 500 = 95 THEN 'Rifaat'
        WHEN N % 500 = 96 THEN 'Said'
        WHEN N % 500 = 97 THEN 'Tayel'
        WHEN N % 500 = 98 THEN 'Wasim'
        WHEN N % 500 = 99 THEN 'Youseff'
        WHEN N % 1000 = 100 THEN 'Zikry'
        WHEN N % 500 = 101 THEN 'Atef'
        WHEN N % 500 = 102 THEN 'Barakat'
        WHEN N % 500 = 103 THEN 'Dawoud'
        WHEN N % 500 = 104 THEN 'Eissa'
        WHEN N % 500 = 105 THEN 'Fahim'
        WHEN N % 500 = 106 THEN 'Gad'
        WHEN N % 500 = 107 THEN 'Hagag'
        WHEN N % 500 = 108 THEN 'Ihab'
        WHEN N % 500 = 109 THEN 'Jabr'
        WHEN N % 1000 = 110 THEN 'Karam'
        WHEN N % 500 = 111 THEN 'Loutfy'
        WHEN N % 500 = 112 THEN 'Makram'
        WHEN N % 500 = 113 THEN 'Niazi'
        WHEN N % 500 = 114 THEN 'Osman'
        WHEN N % 500 = 115 THEN 'Rashad'
        WHEN N % 500 = 116 THEN 'Sobhy'
        WHEN N % 500 = 117 THEN 'Tamer'
        WHEN N % 500 = 118 THEN 'Wafiq'
        WHEN N % 500 = 119 THEN 'Yasser'
        WHEN N % 500 = 120 THEN 'Zaky'
        WHEN N % 500 = 121 THEN 'Aziz'
        WHEN N % 500 = 122 THEN 'Bakar'
        WHEN N % 500 = 123 THEN 'Doma'
        WHEN N % 500 = 124 THEN 'Ebeid'
        WHEN N % 500 = 125 THEN 'Fawzy'
        WHEN N % 500 = 126 THEN 'Gaber'
        WHEN N % 500 = 127 THEN 'Hamad'
        WHEN N % 500 = 128 THEN 'Ismail'
        WHEN N % 500 = 129 THEN 'Jalal'
        WHEN N % 500 = 130 THEN 'Khattab'
        WHEN N % 500 = 131 THEN 'Labib'
        WHEN N % 500 = 132 THEN 'Magdy'
        WHEN N % 500 = 133 THEN 'Nazeer'
        WHEN N % 500 = 134 THEN 'Othman'
        WHEN N % 500 = 135 THEN 'Ramy'
        WHEN N % 500 = 136 THEN 'Sayed'
        WHEN N % 500 = 137 THEN 'Taha'
        WHEN N % 500 = 138 THEN 'Wahid'
        WHEN N % 500 = 139 THEN 'Younis'
        WHEN N % 500 = 140 THEN 'Zidan'
        WHEN N % 500 = 141 THEN 'Adel'
        WHEN N % 500 = 142 THEN 'Bahaa'
        WHEN N % 500 = 143 THEN 'Diab'
        WHEN N % 500 = 144 THEN 'Elsayed'
        WHEN N % 500 = 145 THEN 'Fathy'
        WHEN N % 500 = 146 THEN 'Ghanem'
        WHEN N % 500 = 147 THEN 'Hassan'
        WHEN N % 500 = 148 THEN 'Ibrahim'
        WHEN N % 500 = 149 THEN 'Jaber'
        WHEN N % 500 = 150 THEN 'Khalil'
        WHEN N % 500 = 151 THEN 'Lotfy'
        WHEN N % 500 = 152 THEN 'Mahmoud'
        WHEN N % 500 = 153 THEN 'Nasser'
        WHEN N % 500 = 154 THEN 'Obaid'
        WHEN N % 500 = 155 THEN 'Radwan'
        WHEN N % 500 = 156 THEN 'Salem'
        WHEN N % 500 = 157 THEN 'Tawfik'
        WHEN N % 500 = 158 THEN 'Wagdy'
        WHEN N % 500 = 159 THEN 'Youssef'
        WHEN N % 500 = 160 THEN 'Zaki'
        WHEN N % 500 = 161 THEN 'Amer'
        WHEN N % 500 = 162 THEN 'Badawi'
        WHEN N % 500 = 163 THEN 'Darwish'
        WHEN N % 500 = 164 THEN 'Ezzo'
        WHEN N % 500 = 165 THEN 'Fayed'
        WHEN N % 500 = 166 THEN 'Gharib'
        WHEN N % 500 = 167 THEN 'Hussein'
        WHEN N % 500 = 168 THEN 'Issa'
        WHEN N % 500 = 169 THEN 'Jawad'
        WHEN N % 500 = 170 THEN 'Kamel'
        WHEN N % 500 = 171 THEN 'Loutfi'
        WHEN N % 500 = 172 THEN 'Mostafa'
        WHEN N % 500 = 173 THEN 'Nabil'
        WHEN N % 500 = 174 THEN 'Omar'
        WHEN N % 500 = 175 THEN 'Rashed'
        WHEN N % 500 = 176 THEN 'Sami'
        WHEN N % 500 = 177 THEN 'Tarek'
        WHEN N % 500 = 178 THEN 'Wafik'
        WHEN N % 500 = 179 THEN 'Yasin'
        WHEN N % 500 = 180 THEN 'Zahran'
        WHEN N % 500 = 181 THEN 'Abbas'
        WHEN N % 500 = 182 THEN 'Bishara'
        WHEN N % 500 = 183 THEN 'Dahab'
        WHEN N % 500 = 184 THEN 'Elmasry'
        WHEN N % 500 = 185 THEN 'Fouad'
        WHEN N % 500 = 186 THEN 'Gomaa'
        WHEN N % 500 = 187 THEN 'Helmy'
        WHEN N % 500 = 188 THEN 'Imam'
        WHEN N % 500 = 189 THEN 'Jameel'
        WHEN N % 500 = 190 THEN 'Kassab'
        WHEN N % 500 = 191 THEN 'Luqman'
        WHEN N % 500 = 192 THEN 'Mansour'
        WHEN N % 500 = 193 THEN 'Naguib'
        WHEN N % 500 = 194 THEN 'Okasha'
        WHEN N % 500 = 195 THEN 'Rizk'
        WHEN N % 500 = 196 THEN 'Soliman'
        WHEN N % 500 = 197 THEN 'Talat'
        WHEN N % 500 = 198 THEN 'Waleed'
        WHEN N % 500 = 199 THEN 'Yousef'
        WHEN N % 500 = 200 THEN 'Zayed'
        WHEN N % 500 = 201 THEN 'Aly'
        WHEN N % 500 = 202 THEN 'Badr'
        WHEN N % 500 = 203 THEN 'Dawood'
        WHEN N % 500 = 204 THEN 'Elbaz'
        WHEN N % 500 = 205 THEN 'Farag'
        WHEN N % 500 = 206 THEN 'Ghazal'
        WHEN N % 500 = 207 THEN 'Hafez'
        WHEN N % 500 = 208 THEN 'Ihab'
        WHEN N % 500 = 209 THEN 'Jouda'
        WHEN N % 500 = 210 THEN 'Khedr'
        WHEN N % 500 = 211 THEN 'Lamei'
        WHEN N % 500 = 212 THEN 'Metwally'
        WHEN N % 500 = 213 THEN 'Nour'
        WHEN N % 500 = 214 THEN 'Osman'
        WHEN N % 500 = 215 THEN 'Ragab'
        WHEN N % 500 = 216 THEN 'Sadek'
        WHEN N % 500 = 217 THEN 'Tayel'
        WHEN N % 500 = 218 THEN 'Wasim'
        WHEN N % 500 = 219 THEN 'Youseff'
        WHEN N % 500 = 220 THEN 'Zikry'
        WHEN N % 500 = 221 THEN 'Ashraf'
        WHEN N % 500 = 222 THEN 'Bassiouny'
        WHEN N % 500 = 223 THEN 'Doma'
        WHEN N % 500 = 224 THEN 'Elshamy'
        WHEN N % 500 = 225 THEN 'Farouk'
        WHEN N % 500 = 226 THEN 'Gad'
        WHEN N % 500 = 227 THEN 'Hamdy'
        WHEN N % 500 = 228 THEN 'Ismail'
        WHEN N % 500 = 229 THEN 'Jabr'
        WHEN N % 500 = 230 THEN 'Khaled'
        WHEN N % 500 = 231 THEN 'Loutfy'
        WHEN N % 500 = 232 THEN 'Mounir'
        WHEN N % 500 = 233 THEN 'Najeeb'
        WHEN N % 500 = 234 THEN 'Omar'
        WHEN N % 500 = 235 THEN 'Rifaat'
        WHEN N % 500 = 236 THEN 'Said'
        WHEN N % 500 = 237 THEN 'Tamer'
        WHEN N % 500 = 238 THEN 'Wahba'
        WHEN N % 500 = 239 THEN 'Yasser'
        WHEN N % 500 = 240 THEN 'Zaky'
        WHEN N % 500 = 241 THEN 'Atef'
        WHEN N % 500 = 242 THEN 'Barakat'
        WHEN N % 500 = 243 THEN 'Diab'
        WHEN N % 500 = 244 THEN 'Eissa'
        WHEN N % 500 = 245 THEN 'Fahim'
        WHEN N % 500 = 246 THEN 'Gaber'
        WHEN N % 500 = 247 THEN 'Hagag'
        WHEN N % 500 = 248 THEN 'Ibrahim'
        WHEN N % 500 = 249 THEN 'Jalal'
        WHEN N % 500 = 250 THEN 'Karam'
        WHEN N % 500 = 251 THEN 'Labib'
        WHEN N % 500 = 252 THEN 'Makram'
        WHEN N % 500 = 253 THEN 'Niazi'
        WHEN N % 500 = 254 THEN 'Othman'
        WHEN N % 500 = 255 THEN 'Rashad'
        WHEN N % 500 = 256 THEN 'Sobhy'
        WHEN N % 500 = 257 THEN 'Taha'
        WHEN N % 500 = 258 THEN 'Wafiq'
        WHEN N % 500 = 259 THEN 'Younis'
        WHEN N % 500 = 260 THEN 'Zidan'
        WHEN N % 500 = 261 THEN 'Aziz'
        WHEN N % 500 = 262 THEN 'Bakar'
        WHEN N % 500 = 263 THEN 'Darwish'
        WHEN N % 500 = 264 THEN 'Ebeid'
        WHEN N % 500 = 265 THEN 'Fawzy'
        WHEN N % 500 = 266 THEN 'Ghanem'
        WHEN N % 500 = 267 THEN 'Hamad'
        WHEN N % 500 = 268 THEN 'Issa'
        WHEN N % 500 = 269 THEN 'Jawad'
        WHEN N % 500 = 270 THEN 'Khattab'
        WHEN N % 500 = 271 THEN 'Lotfy'
        WHEN N % 500 = 272 THEN 'Magdy'
        WHEN N % 500 = 273 THEN 'Nazeer'
        WHEN N % 500 = 274 THEN 'Obaid'
        WHEN N % 500 = 275 THEN 'Ramy'
        WHEN N % 500 = 276 THEN 'Sayed'
        WHEN N % 500 = 277 THEN 'Tawfik'
        WHEN N % 500 = 278 THEN 'Wahid'
        WHEN N % 500 = 279 THEN 'Youssef'
        WHEN N % 500 = 280 THEN 'Zaki'
        WHEN N % 500 = 281 THEN 'Adel'
        WHEN N % 500 = 282 THEN 'Bahaa'
        WHEN N % 500 = 283 THEN 'Dahab'
        WHEN N % 500 = 284 THEN 'Elsayed'
        WHEN N % 500 = 285 THEN 'Fathy'
        WHEN N % 500 = 286 THEN 'Gharib'
        WHEN N % 500 = 287 THEN 'Hassan'
        WHEN N % 500 = 288 THEN 'Imam'
        WHEN N % 500 = 289 THEN 'Jaber'
        WHEN N % 500 = 290 THEN 'Khalil'
        WHEN N % 500 = 291 THEN 'Loutfi'
        WHEN N % 500 = 292 THEN 'Mahmoud'
        WHEN N % 500 = 293 THEN 'Nasser'
        WHEN N % 500 = 294 THEN 'Okasha'
        WHEN N % 500 = 295 THEN 'Radwan'
        WHEN N % 500 = 296 THEN 'Salem'
        WHEN N % 500 = 297 THEN 'Tarek'
        WHEN N % 500 = 298 THEN 'Wagdy'
        WHEN N % 500 = 299 THEN 'Yasin'
        WHEN N % 500 = 300 THEN 'Zahran'
        WHEN N % 500 = 301 THEN 'Amer'
        WHEN N % 500 = 302 THEN 'Badawi'
        WHEN N % 500 = 303 THEN 'Dawood'
        WHEN N % 500 = 304 THEN 'Ezzo'
        WHEN N % 500 = 305 THEN 'Fayed'
        WHEN N % 500 = 306 THEN 'Gomaa'
        WHEN N % 500 = 307 THEN 'Hussein'
        WHEN N % 500 = 308 THEN 'Ihab'
        WHEN N % 500 = 309 THEN 'Jameel'
        WHEN N % 500 = 310 THEN 'Kamel'
        WHEN N % 500 = 311 THEN 'Luqman'
        WHEN N % 500 = 312 THEN 'Mostafa'
        WHEN N % 500 = 313 THEN 'Nabil'
        WHEN N % 500 = 314 THEN 'Omar'
        WHEN N % 500 = 315 THEN 'Rashed'
        WHEN N % 500 = 316 THEN 'Sami'
        WHEN N % 500 = 317 THEN 'Talat'
        WHEN N % 500 = 318 THEN 'Wafik'
        WHEN N % 500 = 319 THEN 'Yousef'
        WHEN N % 500 = 320 THEN 'Zayed'
        WHEN N % 500 = 321 THEN 'Abbas'
        WHEN N % 500 = 322 THEN 'Bishara'
        WHEN N % 500 = 323 THEN 'Doma'
        WHEN N % 500 = 324 THEN 'Elmasry'
        WHEN N % 500 = 325 THEN 'Fouad'
        WHEN N % 500 = 326 THEN 'Ghazal'
        WHEN N % 500 = 327 THEN 'Helmy'
        WHEN N % 500 = 328 THEN 'Ismail'
        WHEN N % 500 = 329 THEN 'Jouda'
        WHEN N % 500 = 330 THEN 'Kassab'
        WHEN N % 500 = 331 THEN 'Lamei'
        WHEN N % 500 = 332 THEN 'Mansour'
        WHEN N % 500 = 333 THEN 'Naguib'
        WHEN N % 500 = 334 THEN 'Osman'
        WHEN N % 500 = 335 THEN 'Rizk'
        WHEN N % 500 = 336 THEN 'Soliman'
        WHEN N % 500 = 337 THEN 'Tayel'
        WHEN N % 500 = 338 THEN 'Waleed'
        WHEN N % 500 = 339 THEN 'Youseff'
        WHEN N % 500 = 340 THEN 'Zikry'
        WHEN N % 500 = 341 THEN 'Aly'
        WHEN N % 500 = 342 THEN 'Badr'
        WHEN N % 500 = 343 THEN 'Diab'
        WHEN N % 500 = 344 THEN 'Elbaz'
        WHEN N % 500 = 345 THEN 'Farag'
        WHEN N % 500 = 346 THEN 'Gad'
        WHEN N % 500 = 347 THEN 'Hafez'
        WHEN N % 500 = 348 THEN 'Issa'
        WHEN N % 500 = 349 THEN 'Jabr'
        WHEN N % 500 = 350 THEN 'Khedr'
        WHEN N % 500 = 351 THEN 'Loutfy'
        WHEN N % 500 = 352 THEN 'Metwally'
        WHEN N % 500 = 353 THEN 'Nour'
        WHEN N % 500 = 354 THEN 'Othman'
        WHEN N % 500 = 355 THEN 'Ragab'
        WHEN N % 500 = 356 THEN 'Sadek'
        WHEN N % 500 = 357 THEN 'Tamer'
        WHEN N % 500 = 358 THEN 'Wasim'
        WHEN N % 500 = 359 THEN 'Yasser'
        WHEN N % 500 = 360 THEN 'Zaky'
        WHEN N % 500 = 361 THEN 'Ashraf'
        WHEN N % 500 = 362 THEN 'Bassiouny'
        WHEN N % 500 = 363 THEN 'Darwish'
        WHEN N % 500 = 364 THEN 'Elshamy'
        WHEN N % 500 = 365 THEN 'Farouk'
        WHEN N % 500 = 366 THEN 'Gaber'
        WHEN N % 500 = 367 THEN 'Hamdy'
        WHEN N % 500 = 368 THEN 'Ibrahim'
        WHEN N % 500 = 369 THEN 'Jalal'
        WHEN N % 500 = 370 THEN 'Khaled'
        WHEN N % 500 = 371 THEN 'Labib'
        WHEN N % 500 = 372 THEN 'Mounir'
        WHEN N % 500 = 373 THEN 'Najeeb'
        WHEN N % 500 = 374 THEN 'Obaid'
        WHEN N % 500 = 375 THEN 'Rifaat'
        WHEN N % 500 = 376 THEN 'Said'
        WHEN N % 500 = 377 THEN 'Taha'
        WHEN N % 500 = 378 THEN 'Wahba'
        WHEN N % 500 = 379 THEN 'Younis'
        WHEN N % 500 = 380 THEN 'Zidan'
        WHEN N % 500 = 381 THEN 'Atef'
        WHEN N % 500 = 382 THEN 'Barakat'
        WHEN N % 500 = 383 THEN 'Dahab'
        WHEN N % 500 = 384 THEN 'Eissa'
        WHEN N % 500 = 385 THEN 'Fahim'
        WHEN N % 500 = 386 THEN 'Ghanem'
        WHEN N % 500 = 387 THEN 'Hagag'
        WHEN N % 500 = 388 THEN 'Imam'
        WHEN N % 500 = 389 THEN 'Jawad'
        WHEN N % 500 = 390 THEN 'Karam'
        WHEN N % 500 = 391 THEN 'Lotfy'
        WHEN N % 500 = 392 THEN 'Makram'
        WHEN N % 500 = 393 THEN 'Niazi'
        WHEN N % 500 = 394 THEN 'Okasha'
        WHEN N % 500 = 395 THEN 'Rashad'
        WHEN N % 500 = 396 THEN 'Sobhy'
        WHEN N % 500 = 397 THEN 'Tawfik'
        WHEN N % 500 = 398 THEN 'Wafiq'
        WHEN N % 500 = 399 THEN 'Youssef'
        WHEN N % 500 = 400 THEN 'Zaki'
        WHEN N % 500 = 401 THEN 'Aziz'
        WHEN N % 500 = 402 THEN 'Bakar'
        WHEN N % 500 = 403 THEN 'Dawood'
        WHEN N % 500 = 404 THEN 'Ebeid'
        WHEN N % 500 = 405 THEN 'Fawzy'
        WHEN N % 500 = 406 THEN 'Gharib'
        WHEN N % 500 = 407 THEN 'Hamad'
        WHEN N % 500 = 408 THEN 'Ihab'
        WHEN N % 500 = 409 THEN 'Jaber'
        WHEN N % 500 = 410 THEN 'Khattab'
        WHEN N % 500 = 411 THEN 'Loutfi'
        WHEN N % 500 = 412 THEN 'Magdy'
        WHEN N % 500 = 413 THEN 'Nazeer'
        WHEN N % 500 = 414 THEN 'Omar'
        WHEN N % 500 = 415 THEN 'Ramy'
        WHEN N % 500 = 416 THEN 'Sayed'
        WHEN N % 500 = 417 THEN 'Tarek'
        WHEN N % 500 = 418 THEN 'Wagdy'
        WHEN N % 500 = 419 THEN 'Yasin'
        WHEN N % 500 = 420 THEN 'Zahran'
        WHEN N % 500 = 421 THEN 'Adel'
        WHEN N % 500 = 422 THEN 'Bahaa'
        WHEN N % 500 = 423 THEN 'Doma'
        WHEN N % 500 = 424 THEN 'Elsayed'
        WHEN N % 500 = 425 THEN 'Fathy'
        WHEN N % 500 = 426 THEN 'Gomaa'
        WHEN N % 500 = 427 THEN 'Hassan'
        WHEN N % 500 = 428 THEN 'Ismail'
        WHEN N % 500 = 429 THEN 'Jameel'
        WHEN N % 500 = 430 THEN 'Khalil'
        WHEN N % 500 = 431 THEN 'Luqman'
        WHEN N % 500 = 432 THEN 'Mahmoud'
        WHEN N % 500 = 433 THEN 'Nasser'
        WHEN N % 500 = 434 THEN 'Osman'
        WHEN N % 500 = 435 THEN 'Radwan'
        WHEN N % 500 = 436 THEN 'Salem'
        WHEN N % 500 = 437 THEN 'Talat'
        WHEN N % 500 = 438 THEN 'Waleed'
        WHEN N % 500 = 439 THEN 'Yousef'
        WHEN N % 500 = 440 THEN 'Zayed'
        WHEN N % 500 = 441 THEN 'Amer'
        WHEN N % 500 = 442 THEN 'Badawi'
        WHEN N % 500 = 443 THEN 'Diab'
        WHEN N % 500 = 444 THEN 'Ezzo'
        WHEN N % 500 = 445 THEN 'Fayed'
        WHEN N % 500 = 446 THEN 'Ghazal'
        WHEN N % 500 = 447 THEN 'Hussein'
        WHEN N % 500 = 448 THEN 'Issa'
        WHEN N % 500 = 449 THEN 'Jouda'
        WHEN N % 500 = 450 THEN 'Kamel'
        WHEN N % 500 = 451 THEN 'Lamei'
        WHEN N % 500 = 452 THEN 'Mostafa'
        WHEN N % 500 = 453 THEN 'Nabil'
        WHEN N % 500 = 454 THEN 'Obaid'
        WHEN N % 500 = 455 THEN 'Rashed'
        WHEN N % 500 = 456 THEN 'Sami'
        WHEN N % 500 = 457 THEN 'Tayel'
        WHEN N % 500 = 458 THEN 'Wasim'
        WHEN N % 500 = 459 THEN 'Youseff'
        WHEN N % 500 = 460 THEN 'Zikry'
        WHEN N % 500 = 461 THEN 'Abbas'
        WHEN N % 500 = 462 THEN 'Bishara'
        WHEN N % 500 = 463 THEN 'Dahab'
        WHEN N % 500 = 464 THEN 'Elmasry'
        WHEN N % 500 = 465 THEN 'Fouad'
        WHEN N % 500 = 466 THEN 'Gad'
        WHEN N % 500 = 467 THEN 'Helmy'
        WHEN N % 500 = 468 THEN 'Ibrahim'
        WHEN N % 500 = 469 THEN 'Jabr'
        WHEN N % 500 = 470 THEN 'Kassab'
        WHEN N % 500 = 471 THEN 'Loutfy'
        WHEN N % 500 = 472 THEN 'Mansour'
        WHEN N % 500 = 473 THEN 'Naguib'
        WHEN N % 500 = 474 THEN 'Okasha'
        WHEN N % 500 = 475 THEN 'Rizk'
        WHEN N % 500 = 476 THEN 'Soliman'
        WHEN N % 500 = 477 THEN 'Tamer'
        WHEN N % 500 = 478 THEN 'Wahba'
        WHEN N % 500 = 479 THEN 'Yasser'
        WHEN N % 500 = 480 THEN 'Zaky'
        WHEN N % 500 = 481 THEN 'Aly'
        WHEN N % 500 = 482 THEN 'Badr'
        WHEN N % 500 = 483 THEN 'Dawood'
        WHEN N % 500 = 484 THEN 'Elbaz'
        WHEN N % 500 = 485 THEN 'Farag'
        WHEN N % 500 = 486 THEN 'Gaber'
        WHEN N % 500 = 487 THEN 'Hafez'
        WHEN N % 500 = 488 THEN 'Imam'
        WHEN N % 500 = 489 THEN 'Jalal'
        WHEN N % 500 = 490 THEN 'Khedr'
        WHEN N % 500 = 491 THEN 'Labib'
        WHEN N % 500 = 492 THEN 'Metwally'
        WHEN N % 500 = 493 THEN 'Nour'
        WHEN N % 500 = 494 THEN 'Othman'
        WHEN N % 500 = 495 THEN 'Ragab'
        WHEN N % 500 = 496 THEN 'Sadek'
        WHEN N % 500 = 497 THEN 'Taha'
        WHEN N % 500 = 498 THEN 'Wafiq'
        WHEN N % 500 = 499 THEN 'Younis'
        ELSE 'Zidan'
    END,
    CONCAT('emp', RIGHT('0000' + CAST(N AS VARCHAR(4)), 4), '@company.com'),
    CONCAT('+20-10-', RIGHT('00000000' + CAST(10000000 + N AS VARCHAR(8)), 8)),
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 14000), CAST('2000-01-01' AS DATE)),
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 4000), CAST('2026-01-01' AS DATE)),
    D.DepartmentID,
    J.JobID,
    NULL,
    B.BranchID,
    CASE
        WHEN N % 100 < 82 THEN 'Active'
        WHEN N % 100 < 90 THEN 'OnLeave'
        WHEN N % 100 < 95 THEN 'Inactive'
        WHEN N % 100 < 98 THEN 'Suspended'
        ELSE 'Terminated'
    END
FROM Numbers N
INNER JOIN
(
    -- Rank departments 1..DeptCount by their actual DepartmentID, whatever
    -- those IDs happen to be (no assumption they start at 1 or run 1..30).
    SELECT DepartmentID, ROW_NUMBER() OVER (ORDER BY DepartmentID) AS DeptRN,
           COUNT(*) OVER () AS DeptCount
    FROM dbo.Departments
) D ON D.DeptRN = ((N - 1) % D.DeptCount) + 1
INNER JOIN
(
    -- Rank jobs within each department by their actual JobID, and also
    -- carry each department's own job count so the modulo below can never
    -- divide by zero (a department with 0 jobs already failed the
    -- pre-flight check above, so JobsInDept is always >= 1 here).
    SELECT
        JobID,
        DepartmentID,
        ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY JobID) AS JobRN,
        COUNT(*) OVER (PARTITION BY DepartmentID) AS JobsInDept
    FROM dbo.Jobs
) J ON J.DepartmentID = D.DepartmentID
   AND J.JobRN = ((N - 1) % J.JobsInDept) + 1
INNER JOIN
(
    -- Same rank-based approach for branches.
    SELECT BranchID, ROW_NUMBER() OVER (ORDER BY BranchID) AS BranchRN,
           COUNT(*) OVER () AS BranchCount
    FROM dbo.Branches
) B ON B.BranchRN = ((N - 1) % B.BranchCount) + 1;

DECLARE @EmpInserted INT = @@ROWCOUNT;
PRINT '   Employees inserted: ' + CAST(@EmpInserted AS VARCHAR(10));
IF @EmpInserted = 0
BEGIN
    RAISERROR('Employees insert affected 0 rows - stopping before every downstream table silently inserts nothing. Check the Numbers CTE and the Departments/Jobs/Branches join above.', 16, 1);
END
GO

PRINT 'Employees generated.';
GO

/* =========================================================
   2. GENERATE EMPLOYEE MANAGERS
   ========================================================= */

PRINT '2. Assigning managers...';
GO

;WITH Managers AS
(
    SELECT
        E.EmployeeID,
        E.DepartmentID,
        ROW_NUMBER() OVER (PARTITION BY E.DepartmentID ORDER BY E.EmployeeID) AS RN
    FROM dbo.Employees E
),
ManagerCandidates AS
(
    SELECT EmployeeID, DepartmentID
    FROM Managers
    WHERE RN = 1
)
UPDATE E
SET ManagerID =
(
    SELECT TOP (1) M.EmployeeID
    FROM ManagerCandidates M
    WHERE M.DepartmentID = E.DepartmentID
      AND M.EmployeeID <> E.EmployeeID
)
FROM dbo.Employees E
WHERE E.EmployeeID >
(
    SELECT MIN(M.EmployeeID)
    FROM ManagerCandidates M
    WHERE M.DepartmentID = E.DepartmentID
);
GO

DECLARE @Chk_Employees INT = (SELECT COUNT(*) FROM dbo.Employees WHERE ManagerID IS NOT NULL);
PRINT '   Employees with a manager assigned: ' + CAST(@Chk_Employees AS VARCHAR(10));
GO

PRINT 'Managers assigned.';
GO


/* =========================================================
   3. GENERATE SALARY HISTORY
   ========================================================= */

PRINT '3. Generating salary history...';
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
    CAST(4000 + (ABS(CHECKSUM(NEWID())) % 46000) AS DECIMAL(18,2)),
    DATEADD(MONTH, -24, E.HireDate),
    DATEADD(MONTH, -12, E.HireDate),
    'Initial salary assignment',
    NULL
FROM dbo.Employees E
WHERE E.HireDate <= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE));

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
    CAST(5000 + (ABS(CHECKSUM(NEWID())) % 55000) AS DECIMAL(18,2)),
    DATEADD(MONTH, -12, CAST(GETDATE() AS DATE)),
    NULL,
    CASE E.EmployeeID % 4
        WHEN 0 THEN 'Annual salary review'
        WHEN 1 THEN 'Promotion'
        WHEN 2 THEN 'Market adjustment'
        ELSE 'Performance increase'
    END,
    NULL
FROM dbo.Employees E;
GO

DECLARE @Chk_EmployeeSalaryHistory INT = (SELECT COUNT(*) FROM dbo.EmployeeSalaryHistory);
PRINT '   EmployeeSalaryHistory rows: ' + CAST(@Chk_EmployeeSalaryHistory AS VARCHAR(10));
GO

PRINT 'Salary history generated.';
GO


/* =========================================================
   4. GENERATE ATTENDANCE
   Target: 400,000+
   ========================================================= */

PRINT '4. Generating attendance records...';
GO

;WITH Dates AS
(
    SELECT DATEADD(DAY, -(N - 1), CAST(GETDATE() AS DATE)) AS AttendanceDate
    FROM
    (
        SELECT TOP (240) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
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
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 8 THEN NULL
        ELSE CAST(DATEADD(MINUTE, 450 + (ABS(CHECKSUM(NEWID())) % 120), CAST('00:00:00' AS DATETIME)) AS TIME(0))
    END,
    CASE
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 8 THEN NULL
        ELSE CAST(DATEADD(MINUTE, 930 + (ABS(CHECKSUM(NEWID())) % 150), CAST('00:00:00' AS DATETIME)) AS TIME(0))
    END,
    CASE
        WHEN DATEPART(WEEKDAY, D.AttendanceDate) IN (1,7) THEN 'Holiday'
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 7 THEN 'Absent'
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 14 THEN 'Late'
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 20 THEN 'Remote'
        ELSE 'Present'
    END,
    CAST(6 + (ABS(CHECKSUM(NEWID())) % 300) / 100.0 AS DECIMAL(5,2))
FROM dbo.Employees E
CROSS JOIN Dates D;
GO

DECLARE @Chk_Attendance INT = (SELECT COUNT(*) FROM dbo.Attendance);
PRINT '   Attendance rows: ' + CAST(@Chk_Attendance AS VARCHAR(10));
GO

PRINT 'Attendance generated.';
GO



/* =========================================================
   5. GENERATE EMPLOYEE LEAVES - FIXED
   Target: 10,000
   ========================================================= */

PRINT '5. Generating employee leaves...';
GO

-- Get actual employee count
DECLARE @EmpCount INT;
SELECT @EmpCount = COUNT(*) FROM dbo.Employees;

-- If no employees exist, skip this section
IF @EmpCount > 0
BEGIN
    ;WITH Numbers AS
    (
        SELECT TOP (10000)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
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
        ((N - 1) % @EmpCount) + 1,
        ((N - 1) % 5) + 1,
        LeaveDates.StartDate,
        DATEADD(DAY, LeaveDates.DurationDays, LeaveDates.StartDate) AS EndDate,
        CASE N % 6
            WHEN 0 THEN 'Annual vacation'
            WHEN 1 THEN 'Medical leave'
            WHEN 2 THEN 'Family emergency'
            WHEN 3 THEN 'Personal leave'
            WHEN 4 THEN 'Travel'
            ELSE 'Other personal reason'
        END,
        CASE N % 10
            WHEN 0 THEN 'Pending'
            WHEN 1 THEN 'Rejected'
            WHEN 2 THEN 'Cancelled'
            ELSE 'Approved'
        END,
        NULL
    FROM Numbers
    CROSS APPLY
    (
        -- Computed once, so EndDate is always StartDate + a few days,
        -- never an unrelated earlier random date.
        SELECT
            DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 700), CAST(GETDATE() AS DATE)) AS StartDate,
            (ABS(CHECKSUM(NEWID())) % 5) + 1 AS DurationDays
    ) LeaveDates;
END
ELSE
BEGIN
    PRINT '   WARNING: No employees found. Skipping EmployeeLeaves.';
END
GO

DECLARE @Chk_EmployeeLeaves INT = (SELECT COUNT(*) FROM dbo.EmployeeLeaves);
PRINT '   EmployeeLeaves rows: ' + CAST(@Chk_EmployeeLeaves AS VARCHAR(10));
GO

PRINT 'Employee leaves generated.';
GO


/* =========================================================
   6. GENERATE BONUSES - FIXED
   Target: 15,000
   ========================================================= */

PRINT '6. Generating bonuses...';
GO

-- Get actual employee count
DECLARE @EmpCount2 INT;
SELECT @EmpCount2 = COUNT(*) FROM dbo.Employees;

-- If no employees exist, skip this section
IF @EmpCount2 > 0
BEGIN
    ;WITH Numbers AS
    (
        SELECT TOP (15000)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
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
        ((N - 1) % @EmpCount2) + 1,
        ((N - 1) % 10) + 1,
        CAST(500 + (ABS(CHECKSUM(NEWID())) % 19501) AS DECIMAL(18,2)),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 700), CAST(GETDATE() AS DATE)),
        CASE N % 5
            WHEN 0 THEN 'Exceeded quarterly performance target'
            WHEN 1 THEN 'Outstanding project delivery'
            WHEN 2 THEN 'Sales target achievement'
            WHEN 3 THEN 'Innovation contribution'
            ELSE 'Special management recognition'
        END,
        NULL,
        CASE N % 10
            WHEN 0 THEN 'Pending'
            WHEN 1 THEN 'Rejected'
            WHEN 2 THEN 'Cancelled'
            WHEN 3 THEN 'Paid'
            ELSE 'Approved'
        END
    FROM Numbers;
END
ELSE
BEGIN
    PRINT '   WARNING: No employees found. Skipping Bonuses.';
END
GO

DECLARE @Chk_Bonuses INT = (SELECT COUNT(*) FROM dbo.Bonuses);
PRINT '   Bonuses rows: ' + CAST(@Chk_Bonuses AS VARCHAR(10));
GO

PRINT 'Bonuses generated.';
GO


/* =========================================================
   7. GENERATE DEDUCTIONS - FIXED
   Target: 20,000
   ========================================================= */

PRINT '7. Generating deductions...';
GO

-- Get actual employee count
DECLARE @EmpCount3 INT;
SELECT @EmpCount3 = COUNT(*) FROM dbo.Employees;

-- If no employees exist, skip this section
IF @EmpCount3 > 0
BEGIN
    ;WITH Numbers AS
    (
        SELECT TOP (20000)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
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
        ((N - 1) % @EmpCount3) + 1,
        ((N - 1) % 10) + 1,
        CAST(100 + (ABS(CHECKSUM(NEWID())) % 4901) AS DECIMAL(18,2)),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 700), CAST(GETDATE() AS DATE)),
        CASE N % 6
            WHEN 0 THEN 'Income tax'
            WHEN 1 THEN 'Insurance contribution'
            WHEN 2 THEN 'Late attendance'
            WHEN 3 THEN 'Loan repayment'
            WHEN 4 THEN 'Salary advance'
            ELSE 'Other payroll deduction'
        END
    FROM Numbers;
END
ELSE
BEGIN
    PRINT '   WARNING: No employees found. Skipping Deductions.';
END
GO

DECLARE @Chk_Deductions INT = (SELECT COUNT(*) FROM dbo.Deductions);
PRINT '   Deductions rows: ' + CAST(@Chk_Deductions AS VARCHAR(10));
GO

PRINT 'Deductions generated.';
GO

/* =========================================================
   8. MAKE SURE WE HAVE ENOUGH PAYROLL PERIODS
   ========================================================= */

PRINT '8. Checking payroll periods...';
GO

DECLARE @CurrentPeriodStart DATE = '2024-01-01';

WHILE @CurrentPeriodStart <= '2026-09-01'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.PayrollPeriods WHERE PeriodStartDate = @CurrentPeriodStart)
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
            @CurrentPeriodStart,
            EOMONTH(@CurrentPeriodStart),
            CASE WHEN @CurrentPeriodStart < '2026-09-01' THEN 'Processed' ELSE 'Open' END,
            CASE WHEN @CurrentPeriodStart < '2026-09-01' THEN DATEADD(DAY, 1, CAST(EOMONTH(@CurrentPeriodStart) AS DATETIME2)) ELSE NULL END
        );
    END;
    SET @CurrentPeriodStart = DATEADD(MONTH, 1, @CurrentPeriodStart);
END;
GO

DECLARE @Chk_PayrollPeriods INT = (SELECT COUNT(*) FROM dbo.PayrollPeriods);
PRINT '   PayrollPeriods rows: ' + CAST(@Chk_PayrollPeriods AS VARCHAR(10));
GO

PRINT 'Payroll periods ready.';
GO


/* =========================================================
   9. GENERATE PAYROLL
   Target: 50,000
   25 periods × 2,000 employees
   ========================================================= */

PRINT '9. Generating payroll records...';
GO

;WITH PayrollRows AS
(
    SELECT TOP (50000)
        E.EmployeeID,
        P.PayrollPeriodID,
        CAST(5000 + (ABS(CHECKSUM(NEWID())) % 55001) AS DECIMAL(18,2)) AS BasicSalary
    FROM dbo.Employees E
    CROSS JOIN
    (
        SELECT TOP (25) PayrollPeriodID
        FROM dbo.PayrollPeriods
        ORDER BY PeriodStartDate
    ) P
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
    pr.EmployeeID,
    pr.PayrollPeriodID,
    pr.BasicSalary,
    Amounts.Overtime,
    Amounts.Bonuses,
    Amounts.Deductions,
    pr.BasicSalary + Amounts.Overtime + Amounts.Bonuses - Amounts.Deductions AS NetSalary,
    CASE WHEN PayrollPeriodID % 10 = 0 THEN 'Paid' ELSE 'Processed' END,
    SYSDATETIME()
FROM PayrollRows pr
CROSS APPLY
(
    -- Computed once, so NetSalary is built from the exact same numbers
    -- stored in Overtime/Bonuses/Deductions, not a fresh independent roll.
    SELECT
        CAST(ABS(CHECKSUM(NEWID())) % 5001 AS DECIMAL(18,2)) AS Overtime,
        CAST(ABS(CHECKSUM(NEWID())) % 8001 AS DECIMAL(18,2)) AS Bonuses,
        -- Capped at ~8% of BasicSalary (not a flat 0-6000) so Deductions
        -- can never exceed Basic+Overtime+Bonuses and push NetSalary
        -- negative - that would pass CK_Payroll_NetSalary (it only checks
        -- the formula, not the sign) but then fail CK_PayrollPayments_Amount
        -- (Amount > 0) once PayrollPayments tries to copy NetSalary in step 10.
        CAST(ABS(CHECKSUM(NEWID())) % (CAST(pr.BasicSalary * 0.08 AS INT) + 1) AS DECIMAL(18,2)) AS Deductions
) Amounts;
GO

DECLARE @Chk_Payroll INT = (SELECT COUNT(*) FROM dbo.Payroll);
PRINT '   Payroll rows: ' + CAST(@Chk_Payroll AS VARCHAR(10));
GO

PRINT 'Payroll generated.';
GO


/* =========================================================
   10. GENERATE PAYROLL PAYMENTS
   ========================================================= */

PRINT '10. Generating payroll payments...';
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
    DATEADD(DAY, 2, CAST(PR.PeriodEndDate AS DATETIME2)),
    CASE P.PayrollID % 3 WHEN 0 THEN 'BankTransfer' WHEN 1 THEN 'Cash' ELSE 'Cheque' END,
    P.NetSalary,
    CASE WHEN P.PayrollStatus = 'Paid' THEN 'Completed' ELSE 'Pending' END,
    CONCAT('PAY-', RIGHT('0000000000' + CAST(P.PayrollID AS VARCHAR(10)), 10))
FROM dbo.Payroll P
INNER JOIN dbo.PayrollPeriods PR ON PR.PayrollPeriodID = P.PayrollPeriodID;
GO

DECLARE @Chk_PayrollPayments INT = (SELECT COUNT(*) FROM dbo.PayrollPayments);
PRINT '   PayrollPayments rows: ' + CAST(@Chk_PayrollPayments AS VARCHAR(10));
GO

PRINT 'Payroll payments generated.';
GO


/* =========================================================
   11. DATA VALIDATION
   ========================================================= */

PRINT '==============================================';
PRINT 'DATA VALIDATION';
PRINT '==============================================';
GO

SELECT 'Branches' AS TableName, COUNT(*) AS Row_Count FROM dbo.Branches
UNION ALL
SELECT 'Departments', COUNT(*) FROM dbo.Departments
UNION ALL
SELECT 'Jobs', COUNT(*) FROM dbo.Jobs
UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL
SELECT 'SalaryHistory', COUNT(*) FROM dbo.EmployeeSalaryHistory
UNION ALL
SELECT 'Attendance', COUNT(*) FROM dbo.Attendance
UNION ALL
SELECT 'EmployeeLeaves', COUNT(*) FROM dbo.EmployeeLeaves
UNION ALL
SELECT 'Bonuses', COUNT(*) FROM dbo.Bonuses
UNION ALL
SELECT 'Deductions', COUNT(*) FROM dbo.Deductions
UNION ALL
SELECT 'PayrollPeriods', COUNT(*) FROM dbo.PayrollPeriods
UNION ALL
SELECT 'Payroll', COUNT(*) FROM dbo.Payroll
UNION ALL
SELECT 'PayrollPayments', COUNT(*) FROM dbo.PayrollPayments
UNION ALL
SELECT 'AuditLogs', COUNT(*) FROM dbo.AuditLogs;
GO


/* =========================================================
   12. BUSINESS-DATA QUALITY CHECKS
   ========================================================= */

PRINT 'Checking data quality...';
GO

-- Employees without department
SELECT COUNT(*) AS EmployeesWithoutDepartment
FROM dbo.Employees
WHERE DepartmentID IS NULL;

-- Employees without branch
SELECT COUNT(*) AS EmployeesWithoutBranch
FROM dbo.Employees
WHERE BranchID IS NULL;

-- Employees without job
SELECT COUNT(*) AS EmployeesWithoutJob
FROM dbo.Employees
WHERE JobID IS NULL;

-- Invalid salary ranges
SELECT COUNT(*) AS InvalidSalaryHistory
FROM dbo.EmployeeSalaryHistory
WHERE Salary <= 0 OR (EffectiveTo IS NOT NULL AND EffectiveTo < EffectiveFrom);

-- Invalid attendance
SELECT COUNT(*) AS InvalidAttendance
FROM dbo.Attendance
WHERE WorkingHours < 0 OR (CheckIn IS NOT NULL AND CheckOut IS NOT NULL AND CheckOut < CheckIn);

-- Invalid leave dates
SELECT COUNT(*) AS InvalidLeaves
FROM dbo.EmployeeLeaves
WHERE EndDate < StartDate;

-- Invalid payroll calculation
SELECT COUNT(*) AS InvalidPayroll
FROM dbo.Payroll
WHERE NetSalary <> BasicSalary + Overtime + Bonuses - Deductions;

-- Payroll duplicates
SELECT EmployeeID, PayrollPeriodID, COUNT(*) AS DuplicateCount
FROM dbo.Payroll
GROUP BY EmployeeID, PayrollPeriodID
HAVING COUNT(*) > 1;
GO

PRINT '==============================================';
PRINT 'EHRPMS SAMPLE DATA GENERATION COMPLETED';
PRINT '==============================================';
GO