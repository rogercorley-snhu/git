INSERT INTO dbo.tblNAME (Field1, field2, etc.)

SELECT Field1, 'NewValue'
FROM dbo.tblName
WHERE field2 = 'originalvalue'