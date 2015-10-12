DECLARE	@dateSearch DATETIME
		,@bDate DATETIME
		,@eDate DATETIME
		,@eDateNo INT
		,@xID VARCHAR(50)
		,@postDate DATETIME

SET		@xID			= 'BIWK'
SET		@dateSearch 		= '2015-09-17';
SET		@bDate		= (SELECT BeginDate FROM tblCycleXLAT WHERE @dateSearch BETWEEN BeginDate AND EndDate AND xlatID = @xID);
SET		@eDate		= (SELECT EndDate FROM tblCycleXLAT WHERE @dateSearch BETWEEN BeginDate AND EndDate AND xlatID = @xID);
SET		@eDateNo		= DATEDIFF(DAY, @eDate, GETDATE())

SET		@postDate		= LEFT(CONVERT(NVARCHAR, DATEADD(DAY, -(@eDateNo +1), GETDATE()), 120), 11) + N'23:59:59';

SELECT		@eDateNo AS [DayCount]
		,*
		,@postDate AS [PostDate]

FROM		tblCycleXLAT

WHERE
		xlatID = @xID
		AND BeginDate = @bDate


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------



DECLARE	@p DATETIME
		,@dayCount INT

SET		@dayCount 	= 14;
SET		@p		= LEFT(CONVERT(NVARCHAR, DATEADD(DAY, -@dayCount, GETDATE()), 120), 11) + N'23:59:59';

SELECT		@dayCount AS [DayCount]
		,@p AS [PostDate]


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
