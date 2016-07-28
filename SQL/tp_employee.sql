Create table EmployeeReports
(
	ReportId int identity (1,1) not null,
	ReportName varchar(100),
	ReportNumber varchar(20),
	ReportDescription varchar(max)
	constraint EReport_PK primary key clustered (ReportId)
)

declare @i int
set @i = 1

begin tran
while @i < 100000
begin
	insert into EmployeeReports
	(
		ReportName,
		ReportNumber,
		ReportDescription
	)
	values
	(
		'ReportName',
		CONVERT(varchar(20), @i),
		REPLICATE('Report', 1000)
	)
	set @i = @i +1
end

commit tran