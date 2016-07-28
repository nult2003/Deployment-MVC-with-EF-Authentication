set statistics io on
set statistics time on
select reportid, reportname, reportnumber
from reportsdata
where reportnumber like '%33%'
set statistics io off
set statistics time off