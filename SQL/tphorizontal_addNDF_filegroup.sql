/* 
http://www.sqlshack.com/database-table-partitioning-sql-server/
*/
alter database employee
	add file
	(
		name = PartJan,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [January]
go

alter database employee
	add file
	(
		name = PartFeb,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee2.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [February]
go

alter database employee
	add file
	(
		name = PartMar,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee3.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [March]
go

alter database employee
	add file
	(
		name = PartApr,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee4.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [April]
go

alter database employee
	add file
	(
		name = PartMay,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee5.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [May]
go

alter database employee
	add file
	(
		name = PartJun,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee6.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [June]
go

alter database employee
	add file
	(
		name = PartJul,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee7.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [July]
go

alter database employee
	add file
	(
		name = PartAug,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee8.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [August]
go

alter database employee
	add file
	(
		name = PartSep,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee9.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [September]
go

alter database employee
	add file
	(
		name = PartOct,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee10.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [October]
go

alter database employee
	add file
	(
		name = PartNov,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee11.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [November]
go

alter database employee
	add file
	(
		name = PartDec,
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Employee12.ndf',
		size = 3072 KB,
		Maxsize = unlimited,
		filegrowth = 1024 Kb
	) to filegroup [December]
go