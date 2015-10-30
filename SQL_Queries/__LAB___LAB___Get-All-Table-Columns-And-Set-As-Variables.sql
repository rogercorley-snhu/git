
DROP TABLE _atmptable

DECLARE @i int, @sql nvarchar(1000), @table nvarchar(max);
DECLARE @OBJ_INT int;

CREATE TABLE _atmptable (
	idx smallint Primary Key IDENTITY(1,1),
	name nvarchar(30)
);

SET @table = 'tblAccountImport'

SET @sql = '
		DECLARE @OBJ_ID INT, @result nvarchar(1000)

		SET @result = ''''
		SET @OBJ_ID = (SELECT object_id from SYS.tables where name = '''+@table+''')


		SELECT cn.name
		FROM SYS.tables tn
		join SYS.columns cn on tn.object_id = cn.object_id
		WHERE tn.name = '''+@table+''' and cn.object_id = tn.object_id'

insert _atmptable exec sp_executesql @sql






DECLARE @declnum int, @declname nvarchar(max);

SELECT @declnum = idx from _atmptable





DECLARE @declnum nvarchar(max), @declname nvarchar(max);

SELECT @declnum = '@declnum'
SELECT @declname = ' = '

SELECT ( @declnum + CONVERT(nvarchar(max), idx) + ' = ' + name )
from _atmptable