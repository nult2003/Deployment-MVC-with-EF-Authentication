select name
from sys.filegroups
where type = 'FG'
go

select name, physical_name
from sys.database_files
where type_desc = 'ROWS'
go