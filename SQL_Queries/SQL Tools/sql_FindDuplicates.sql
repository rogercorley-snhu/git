DECLARE @table varchar(max), @sql nvarchar(max)
DECLARE @col1 varchar(max), @col2 varchar(max), @col3 varchar(max)

SET @col1 = 'AccountNo'
SET @col2 = 'LastName'
SET @col3 = 'FirstName'

SET @table = 'tblAccountImport'


SET @sql = '
 SELECT i.'+@col1+', i.'+@col2+', i.'+@col3+'
 FROM ' +@table+ ' AS i
 INNER JOIN (
  SELECT '+@col1+', COUNT(*) AS dupeCount
  FROM ' +@table+ '
  GROUP BY '+@col1+'
  HAVING COUNT(*) > 1
 ) AS c ON i.'+@col1+' = c.'+@col1+'

 ORDER BY '+@col1+'
 '

exec sp_executesql @sql