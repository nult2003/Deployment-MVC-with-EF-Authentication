
set statistics io on
set statistics time on
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ReportId]
      ,[ReportName]
      ,[ReportNumber]
      ,[ReportDescription]
  FROM [Employee].[dbo].[EmployeeReports]
  where reportNumber like '%33%'

  set statistics io off
  set statistics time off