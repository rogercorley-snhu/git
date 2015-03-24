-------------------------------------------------------------------------------------------------------------------------------------
/*				.DEF FILE SQL QUERY																									*/
-------------------------------------------------------------------------------------------------------------------------------------


DECLARE			@TDATE AS DATETIME, @BEG_DATE AS DATETIME, @END_DATE AS DATETIME;
DECLARE 		@YEAR_NO AS VARCHAR(2), @XLAT_ID AS VARCHAR(8);
DECLARE 		@PERIOD_NO AS int, @CYCLEADJ AS int;

SET 			@CYCLEADJ = 178;
SET 			@XLAT_ID = 'BIWK2';

SET				@TDATE = GETDATE() - 10;
SET				@BEG_DATE = (SELECT BeginDate FROM tblCycleXLAT WHERE @TDATE BETWEEN BeginDate AND EndDate AND XlatID = @XLAT_ID);
SET				@END_DATE = (SELECT EndDate FROM tblCycleXLAT WHERE @TDATE BETWEEN BeginDate AND EndDate AND XlatID = @XLAT_ID);
SET				@YEAR_NO = (SELECT CONVERT(VARCHAR(2),@TDATE,2) AS [YY]);
SET 			@PERIOD_NO = (SELECT CycleNo from tblCycleXLAT WHERE @BEG_DATE = BeginDate AND XlatID = @XLAT_ID) - @CYCLEADJ;


SELECT			DTL.AccountNo
				,CONVERT(MONEY,SUM(TransTotal),0) as TOTAL
				,@YEAR_NO as YEARNO
				,@PERIOD_NO as PERIOD

FROM			tblDetail as DTL
					LEFT JOIN tblAccountOHD as OHD ON DTL.AccountNo = OHD.AccountNo

WHERE			DTL.TransDate BETWEEN @BEG_DATE AND @END_DATE 

				/*	Ignore any potential payments that may exist in search results.
					=============================================================== */
					AND DTL.OutletNo NOT LIKE '1000' 


				/*	Configure any special includes or excludes for this batch.
					=============================================================== */
					AND OHD.Fax NOT LIKE 'DIETARY'


				/*	Configure TransIDs used for this batch.
					=============================================================== */
					AND DTL.TransID IN (1,7)


				/*	Configure AccountClassID used for this batch.
					=============================================================== */
					AND OHD.AccountClassID IN (10,20)

GROUP BY		DTL.AccountNo
ORDER BY		DTL.AccountNo

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
/*				DATE CALCULATIONS																									*/
-------------------------------------------------------------------------------------------------------------------------------------

DECLARE 		@NOW_DATE AS DATETIME, @TDATE AS DATETIME, @BEGIN_DATE AS DATETIME, @END_DATE AS DATETIME;
DECLARE			@GD_ADJ AS INT;

SET 			@GD_ADJ = '10';

SET				@NOW_DATE = GETDATE();
SET 			@TDATE = @NOW_DATE - @GD_ADJ;
SET 			@BEGIN_DATE = (SELECT BeginDate FROM tblCycleXLAT WHERE @TDATE BETWEEN BeginDate AND EndDate);
SET 			@END_DATE = (SELECT EndDate FROM tblCycleXLAT WHERE @TDATE BETWEEN BeginDate AND EndDate);

SELECT 	 		 @NOW_DATE AS RightNow
				,@TDATE AS TransactionDate
				,@BEGIN_DATE AS CycleBeginDate
				,@END_DATE AS CycleEndDate

FROM			tblCycleXLAT
