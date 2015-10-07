declare @t datetime, @da int
set @da = 10;
set @t = LEFT(CONVERT(nvarchar, DATEADD(DAY, -@da, GETDATE()), 120), 11) + N'23:59:59';
SELECT @t


select * from tblCycleXlat where xlatID = 'BIWK' and BeginDate BETWEEN '2015-09-19' and '2015-09-25'
