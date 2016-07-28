create partition function PartitioningByMonth (datetime)
as range right for values ('20140201','20140301','20140401','20140501','20140601','20140701','20140801',
'20140901','20141001','20141101','20141201');
go

create partition scheme PartitionBymonth
as partition PartitioningBymonth
to (January, February, March, April, May, June, July,August, September, October, November, December);
go

create table Reports
(
	ReportDate datetime Primary key,
	MonthlyReport varchar(max)
)
on PartitionByMonth(ReportDate);
go

insert into Reports (ReportDate, MonthlyReport)
select '20140105', 'ReportJanuary' Union ALL
select '20140205', 'ReportFeb' Union ALL
select '20140305', 'ReportMar' Union ALL
select '20140405', 'ReportApr' Union ALL
select '20140505', 'ReportMay' Union ALL
select '20140605', 'ReportJun' Union ALL
select '20140705', 'ReportJul' Union ALL
select '20140805', 'ReportAug' Union ALL
select '20140905', 'ReportSep' Union ALL
select '20141005', 'ReportOct' Union ALL
select '20141105', 'ReportNov' Union ALL
select '20141205', 'ReportDec' 

go

select 
	p.partition_number as PartitionNumber,
	f.name as PartitionFilegroup,
	p.rows as NumberOfRows
from sys.partitions p
join sys.destination_data_spaces dds on p.partition_number = dds.destination_id
join sys.filegroups f on dds.data_space_id = f.data_space_id
where OBJECT_NAME(Object_id) = 'ReportsDate'
go

select * from sys.partitions
select * from sys.destination_data_spaces
select * from sys.filegroups
select * from sys.objects where name = 'reports'

create table ReportsDate
(
	ReportDate datetime Primary key,
	MonthlyReport varchar(max)
)

insert into ReportsDate (ReportDate, MonthlyReport)
select '20140105', 'ReportJanuary' Union ALL
select '20140106', 'ReportJanuary' Union ALL
select '20140107', 'ReportJanuary' Union ALL
select '20140205', 'ReportFeb' Union ALL
select '20140305', 'ReportMar' Union ALL
select '20140405', 'ReportApr' Union ALL
select '20140505', 'ReportMay' Union ALL
select '20140605', 'ReportJun' Union ALL
select '20140705', 'ReportJul' Union ALL
select '20140805', 'ReportAug' Union ALL
select '20140905', 'ReportSep' Union ALL
select '20141005', 'ReportOct' Union ALL
select '20141105', 'ReportNov' Union ALL
select '20141205', 'ReportDec' 
go

select '20140205', 'ReportFeb' Union ALL


insert into ReportsDate (ReportDate, MonthlyReport)
select '20140205', 'ReportFeb' 

select * from ReportsDate where MonthlyReport = 'ReportJanuary'
delete from ReportsDate where MonthlyReport = 'ReportJanuary'