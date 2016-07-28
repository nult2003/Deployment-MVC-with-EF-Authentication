/*reference: https://www.simple-talk.com/sql/backup-and-recovery/partial-backup-and-restore/ */
USE [master]
GO

CREATE DATABASE [DatabaseForPartialBackups] ON PRIMARY 
(   NAME = N'DatabaseForPartialBackups'
  , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data\DatabaseForPartialBackups.mdf' 
  , SIZE = 10240KB , FILEGROWTH = 10240KB ), FILEGROUP [Archive] 
(   NAME = N'DatabaseForPartialBackups_ReadOnly'
  , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data\DatabaseForPartialBackups_ReadOnly.ndf' 
  , SIZE = 10240KB , FILEGROWTH = 10240KB ) LOG ON 
(   NAME = N'DatabaseForPartialBackups_log'
  , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data\DatabaseForPartialBackups_log.ldf' 
  , SIZE = 10240KB , FILEGROWTH = 10240KB )
GO

ALTER DATABASE [DatabaseForPartialBackups] SET RECOVERY SIMPLE
GO
/////////////////////////////////
USE [DatabaseForPartialBackups]
GO

CREATE TABLE dbo.MainData
    (
      ID INT NOT NULL
             IDENTITY(1, 1) ,
      Message NVARCHAR(50) NOT NULL
    )
ON  [PRIMARY]
GO

CREATE TABLE dbo.ArchiveData
    (
      ID INT NOT NULL ,
      Message NVARCHAR(50) NOT NULL
    )
ON  [Archive]
GO

INSERT  INTO dbo.MainData
VALUES  ( 'Data for initial database load: Data 1' )
INSERT  INTO dbo.MainData
VALUES  ( 'Data for initial database load: Data 2' )
INSERT  INTO dbo.MainData
VALUES  ( 'Data for initial database load: Data 3' )
GO

///////////////////////////////////////////
USE [DatabaseForPartialBackups] 
GO

INSERT  INTO dbo.ArchiveData
        SELECT  ID ,
                Message
        FROM    MainData
GO

ALTER DATABASE [DatabaseForPartialBackups] MODIFY FILEGROUP [Archive] READONLY
GO

DELETE  FROM dbo.MainData
GO

INSERT  INTO dbo.MainData
VALUES  ( 'Data for second database load: Data 4' )
INSERT  INTO dbo.MainData
VALUES  ( 'Data for second database load: Data 5' )
INSERT  INTO dbo.MainData
VALUES  ( 'Data for second database load: Data 6' )
GO

////////////////////////////////
USE [master]
GO

BACKUP DATABASE DatabaseForPartialBackups
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_FULL.bak'
GO

INSERT  INTO DatabaseForPartialBackups.dbo.MainData
VALUES  ( 'Data for third database load: Data 7' )
INSERT  INTO DatabaseForPartialBackups.dbo.MainData
VALUES  ( 'Data for third database load: Data 8' )
INSERT  INTO DatabaseForPartialBackups.dbo.MainData
VALUES  ( 'Data for third database load: Data 9' )
GO

////////////////////

BACKUP DATABASE DatabaseForPartialBackups READ_WRITE_FILEGROUPS
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_PARTIAL_Full.bak'
GO
///////////////////

USE [DatabaseForPartialBackups]
GO

INSERT  INTO MainData
VALUES  ( 'Data for fourth database load: Data 10' )
INSERT  INTO MainData
VALUES  ( 'Data for fourth database load: Data 11' )
INSERT  INTO MainData
VALUES  ( 'Data for fourth database load: Data 12' )
GO

//
USE [master]
GO

BACKUP DATABASE [DatabaseForPartialBackups] READ_WRITE_FILEGROUPS
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_PARTIAL_Diff.bak'
WITH DIFFERENTIAL
GO

/*//////// RESTORE */
USE [master]
GO

RESTORE DATABASE [DatabaseForPartialBackups]
FROM DISK =
    N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_FULL.bak'
WITH NORECOVERY
GO

RESTORE DATABASE [DatabaseForPartialBackups]
FROM DISK =
    N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_PARTIAL_Full.bak'
WITH RECOVERY
GO
////////////////////////////////
USE [master]
GO

RESTORE DATABASE [DatabaseForPartialBackups]
FROM DISK =
    N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_FULL.bak'
WITH NORECOVERY
GO

RESTORE DATABASE [DatabaseForPartialBackups]
FROM DISK =
    N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_PARTIAL_Full.bak'
WITH NORECOVERY 
GO

RESTORE DATABASE [DatabaseForPartialBackups]
FROM DISK =
    N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\backup\DatabaseForPartialBackups_PARTIAL_Diff.bak'
WITH RECOVERY
GO

