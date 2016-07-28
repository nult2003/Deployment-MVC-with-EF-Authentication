/*Reference: http://stackoverflow.com/questions/25841822/backup-and-restore-sql-server-database-filegroup */
/*First create the test database:-*/
use master
CREATE DATABASE [FGRestoreTEST]
 ON  PRIMARY 
( NAME = N'FGRestoreTEST', FILENAME = N'C:\SQLServer\Data\FGRestoreTEST.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FG2010] 
( NAME = N'FG2010', FILENAME = N'C:\SQLServer\Data\FG2010.ndf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FG2011] 
( NAME = N'FG2011', FILENAME = N'C:\SQLServer\Data\FG2011.ndf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FG2012] 
( NAME = N'FG2012', FILENAME = N'C:\SQLServer\Data\FG2012.ndf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FG2013] 
( NAME = N'FG2013', FILENAME = N'C:\SQLServer\Data\FG2013.ndf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FG2014] 
( NAME = N'FG2014', FILENAME = N'C:\SQLServer\Data\FG2014.ndf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'FGRestoreTEST_log', FILENAME = N'C:\SQLServer\Logs\FGRestoreTEST_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

/*Then create tables in each of the filegroups*/
USE [FGRestoreTEST];
GO
CREATE TABLE [PRIMARY_TABLE]
(ID INT,
 NAME CHAR(4)) ON [PRIMARY];

CREATE TABLE [FG2010_TABLE]
(ID INT,
 NAME CHAR(4)) ON [FG2010];

 CREATE TABLE [FG2011_TABLE]
(ID INT,
 NAME CHAR(4)) ON [FG2011];

CREATE TABLE [FG2012_TABLE]
(ID INT,
 NAME CHAR(4)) ON [FG2012];

CREATE TABLE [FG2013_TABLE]
(ID INT,
 NAME CHAR(4)) ON [FG2013];

CREATE TABLE [FG2014_TABLE]
(ID INT,
 NAME CHAR(4)) ON [FG2014];
 GO

 /*Insert data (100 rows) into each of the tables*/
 INSERT INTO [PRIMARY_TABLE]
SELECT 1, 'TEST'
GO 100

INSERT INTO [FG2010_TABLE]
SELECT 1, 'TEST'
GO 100

INSERT INTO [FG2011_TABLE]
SELECT 1, 'TEST'
GO 100

INSERT INTO [FG2012_TABLE]
SELECT 1, 'TEST'
GO 100

INSERT INTO [FG2013_TABLE]
SELECT 1, 'TEST'
GO 100

INSERT INTO [FG2014_TABLE]
SELECT 1, 'TEST'
GO 100

/*Then set certain filegroups to read only*/
ALTER DATABASE [FGRestoreTEST]
MODIFY FILEGROUP [FG2010] READ_ONLY;

ALTER DATABASE [FGRestoreTEST]
MODIFY FILEGROUP [FG2011] READ_ONLY;

ALTER DATABASE [FGRestoreTEST]
MODIFY FILEGROUP [FG2012] READ_ONLY;

ALTER DATABASE [FGRestoreTEST]
MODIFY FILEGROUP [FG2013] READ_ONLY;
GO

USE [master];
GO

/*Take a full backup*/
BACKUP DATABASE [FGRestoreTEST]
TO DISK = N'C:\SQLServer\Backups\FGRestoreTEST.BAK';
GO

/*Then create a development database from the full backup (this will be used to restore the filegroup backups that will be taken further next):-*/
RESTORE DATABASE [FGRestoreTEST_Dev]
FROM DISK = N'C:\SQLServer\Backups\FGRestoreTEST.BAK' WITH
MOVE 'FGRestoreTEST' TO 'C:\SQLServer\Data\FGRestoreTEST_Dev.mdf',
MOVE 'FG2010' TO 'C:\SQLServer\Data\FG2010_Dev.ndf',
MOVE 'FG2011' TO 'C:\SQLServer\Data\FG2011_Dev.ndf',
MOVE 'FG2012' TO 'C:\SQLServer\Data\FG2012_Dev.ndf',
MOVE 'FG2013' TO 'C:\SQLServer\Data\FG2013_Dev.ndf',
MOVE 'FG2014' TO 'C:\SQLServer\Data\FG2014_Dev.ndf',
MOVE 'FGRestoreTEST_log' TO 'C:\SQLServer\Logs\FGRestoreTEST_Dev_log.ldf',
RECOVERY,STATS=5;
GO

/*Take backups of each of the filegroups*/
BACKUP DATABASE [FGRestoreTEST]
   FILEGROUP = 'PRIMARY'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTEST_PRIMARY.bak';

BACKUP DATABASE [FGRestoreTEST]
   FILEGROUP = 'FG2010'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2010.bak';

BACKUP DATABASE [FGRestoreTEST]
   FILEGROUP = 'FG2011'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2011.bak';

BACKUP DATABASE [FGRestoreTEST]
   FILEGROUP = 'FG2012'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2012.bak';

BACKUP DATABASE [FGRestoreTEST]
   FILEGROUP = 'FG2013'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2013.bak';

BACKUP DATABASE [FGRestoreTEST]
   FILEGROUP = 'FG2014'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2014.bak';
GO

/*Now we will modify data in the Primary & FG2014 filegroups*/
USE [FGRestoreTEST];
GO

INSERT INTO [PRIMARY_TABLE]
SELECT 1, 'TEST'
GO 100

TRUNCATE TABLE [FG2014_TABLE];
GO

/*Take differential backups of the filegroups:-*/
BACKUP DATABASE [FGRestoreTest]
   FILEGROUP = 'PRIMARY'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTest_PRIMARYDIFF.bak'
   WITH DIFFERENTIAL;

BACKUP DATABASE [FGRestoreTest]
   FILEGROUP = 'FG2014'
   TO DISK = 'C:\SQLServer\Backups\FGRestoreTest_FG2014DIFF.bak'
   WITH DIFFERENTIAL;
GO

/*Again, modify the data*/
USE [FGRestoreTEST];
GO

INSERT INTO [PRIMARY_TABLE]
SELECT 1, 'TEST'
GO 100

INSERT INTO [FG2014_TABLE]
SELECT 1, 'NEW'
GO 300

/*Backup the transaction log (you will probably have more than one of these in a real life environment, but for demo purposes I'm just taking one):-*/
USE [master];
GO

BACKUP LOG [FGRestoreTEST]
TO DISK = 'C:\SQLServer\Backups\FGRestoreTest_LogBackup.trn';
GO

/* ******quan trong******* OK, now we can restore the development database. First we take a Tail Log backup, putting the database into recovery. Note:- we will not use this backup!*/
BACKUP LOG [FGRestoreTEST_Dev]
TO DISK = 'C:\SQLServer\Backups\FGRestoreTest_TailLogBackup.trn'
WITH NORECOVERY;
GO

/*Now we can restore the full backups of the read-write filegroups*/
RESTORE DATABASE [FGRestoreTEST_Dev]
   FILEGROUP = 'PRIMARY'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTEST_PRIMARY.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_Dev]
   FILEGROUP = 'FG2014'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2014.bak'
   WITH NORECOVERY;
GO

/*Then the differential backups*/
RESTORE DATABASE [FGRestoreTEST_Dev]
   FILEGROUP = 'PRIMARY'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTest_PRIMARYDIFF.bak'
   WITH NORECOVERY;
GO

--Restore FG2014 differential backup
RESTORE DATABASE [FGRestoreTEST_Dev]
   FILEGROUP = 'FG2014'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTest_FG2014DIFF.bak'
   WITH NORECOVERY;
GO

/*Then the transaction log backup*/
RESTORE LOG [FGRestoreTEST_Dev]
FROM DISK = 'C:\SQLServer\Backups\FGRestoreTest_LogBackup.trn'
WITH NORECOVERY;
GO

/*Finally, the database can be recovered*/
RESTORE DATABASE [FGRestoreTest_DEV] WITH RECOVERY;
GO

RESTORE DATABASE [FGRestoreTest] WITH RECOVERY;
GO

/*LESSON 1*/
RESTORE DATABASE [FGRestoreTEST_less1]
FROM DISK = N'C:\SQLServer\Backups\FGRestoreTEST.BAK' WITH
MOVE 'FGRestoreTEST' TO 'C:\SQLServer\Data\FGRestoreTEST_less1.mdf',
MOVE 'FG2010' TO 'C:\SQLServer\Data\FG2010_less1.ndf',
MOVE 'FG2011' TO 'C:\SQLServer\Data\FG2011_less1.ndf',
MOVE 'FG2012' TO 'C:\SQLServer\Data\FG2012_less1.ndf',
MOVE 'FG2013' TO 'C:\SQLServer\Data\FG2013_less1.ndf',
MOVE 'FG2014' TO 'C:\SQLServer\Data\FG2014_less1.ndf',
MOVE 'FGRestoreTEST_log' TO 'C:\SQLServer\Logs\FGRestoreTEST_less1_log.ldf',
RECOVERY,STATS=5;
GO

RESTORE DATABASE [FGRestoreTEST_less1]
   FILEGROUP = 'PRIMARY'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTEST_PRIMARY.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less1]
   FILEGROUP = 'FG2014'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTEST_FG2014.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less1]
   FILEGROUP = 'PRIMARY'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTest_PRIMARYDIFF.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less1]
   FILEGROUP = 'FG2014'
   FROM DISK = 'C:\SQLServer\Backups\FGRestoreTest_FG2014DIFF.bak'
   WITH NORECOVERY;
GO

RESTORE LOG [FGRestoreTEST_less1]
FROM DISK = 'C:\SQLServer\Backups\FGRestoreTest_LogBackup.trn'
WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less3] WITH RECOVERY;
GO

/*LESSON 3: backup by tool and restore by T-SQL */
BACKUP LOG [FGRestoreTEST_less3]
TO DISK = 'C:\SQLServer\Backups\RestoreTest_TailLogBackup_less3.trn'
WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less3]
   FILEGROUP = 'PRIMARY'
   FROM DISK = 'C:\SQLServer\Backups\RestoreTestFG_primary.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less3]
   FILEGROUP = 'FG2014'
   FROM DISK = 'C:\SQLServer\Backups\RestoreTestFG_2014.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less3]
   FILEGROUP = 'PRIMARY'
   FROM DISK = 'C:\SQLServer\Backups\RestoreTestFG_primarydiff.bak'
   WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less3]
   FILEGROUP = 'FG2014'
   FROM DISK = 'C:\SQLServer\Backups\RestoreTestFG_2014diff.bak'
   WITH NORECOVERY;
GO

RESTORE LOG [FGRestoreTEST_less3]
FROM DISK = 'C:\SQLServer\Backups\RestoreTest_LogBackup.trn'
WITH NORECOVERY;
GO

RESTORE DATABASE [FGRestoreTEST_less3] WITH RECOVERY;
GO