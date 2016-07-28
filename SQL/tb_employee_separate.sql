create table ReportsDesc
(
	ReportId int foreign key references EmployeeReports (reportId),
	ReportDescription varchar(max)
	constraint PK_ReportDesc Primary Key clustered (ReportId)
)

Create table ReportsData
(
	ReportId int not null,
	ReportName varchar(100),
	ReportNumber varchar(20),
	Constraint DReport_PK Primary Key clustered (ReportId)
)

insert into ReportsData
(
	ReportId,
	ReportName,
	ReportNumber
)
select ReportId, ReportName, ReportNumber
from dbo.EmployeeReports
