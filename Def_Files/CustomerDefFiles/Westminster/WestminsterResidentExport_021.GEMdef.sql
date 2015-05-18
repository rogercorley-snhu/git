--

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @attl AS INT, @acid AS INT, @tcid AS INT, @doffset AS INT;
DECLARE @cycle AS INT, @bdate AS DATETIME, @edate AS DATETIME;
DECLARE @xid AS VARCHAR(10), @dadjust AS DATETIME;
DECLARE @location AS VARCHAR(3);
----------------------------------------------------------------------------------------------------------------


--------------[ User Variables ]-----------------------
SET @tcid		= 10;
SET @acid		= 10;
SET @doffset	= 10;
SET @xid		= 'MTH';
SET @location	= '021';
-------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SET @dadjust	=  GetDate()-@doffset;
SET @cycle		= (SELECT CycleNo FROM tblCycleXlat
						WHERE @dadjust BETWEEN BeginDate AND EndDate AND XlatID = @xid);
SET @bdate		= (SELECT BeginDate FROM tblCycleXlat
						WHERE CycleNo = @cycle AND XlatID = @xid);
SET @edate		= (SELECT EndDate FROM tblCycleXlat
						WHERE CycleNo = @cycle AND XlatID = @xid);
----------------------------------------------------------------------------------------------------------------

SELECT
	SubString( D.AccountNo ,1,3) AS [Location]
	,SubString(D.AccountNo,4,19 ) AS [AccountNo]
	,dbo.fn_WAT_RIGetARType( SubString( D.AccountNo ,1,3) , SubString(D.AccountNo,4,19 ) , D.TransDate ) AS [ARType]
	,O.Category AS [ChargeCode]
	,D.TransTotal AS [TransTotal]
	,D.TransDate AS [TransDate]
----------------------------------------------------------------------------------------------------------------

FROM
	tblDetail  D
	LEFT JOIN tblTransDef	AS TD	ON D.TransID = TD.TransID
	LEFT JOIN tblOutletOHD	AS O	ON O.OutletNo = D.OutletNo
	LEFT JOIN tblTransClass	AS TC	ON TD.TransClassID = TC.TransClassID
	LEFT JOIN tblAccountOHD	AS A	ON D.AccountNo = A.AccountNo
----------------------------------------------------------------------------------------------------------------

WHERE
	TC.TransClassID = @tcid
	AND A.AccountClassID = @acid
	AND D.PostDate  >= @bdate
	AND D.PostDate  <= @edate
	AND SubString( D.AccountNo ,1,3) = @location
	AND D.TransID NOT IN (50,51,56,60)
	AND D.TransID < 500
	AND LEN(D.AccountNO) > 3
----------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--
