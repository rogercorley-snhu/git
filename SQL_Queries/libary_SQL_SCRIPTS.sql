-------------------------------------------------------------------------------------------------------------------------------------
/*				.DEF FILE SQL QUERY																									*/
-------------------------------------------------------------------------------------------------------------------------------------


DECLARE	@TDATE AS DATETIME, @BEG_DATE AS DATETIME, @END_DATE AS DATETIME;
DECLARE	@YEAR_NO AS VARCHAR(2), @XLAT_ID AS VARCHAR(8);
DECLARE	@PERIOD_NO AS int, @CYCLEADJ AS int;

SET	@CYCLEADJ  = 178;
SET	@XLAT_ID   = 'BIWK2';

SET	@TDATE     = GETDATE() - 10;
SET	@BEG_DATE  = (SELECT BeginDate FROM tblCycleXLAT WHERE @TDATE BETWEEN BeginDate AND EndDate AND XlatID = @XLAT_ID);
SET	@END_DATE  = (SELECT EndDate FROM tblCycleXLAT WHERE @TDATE BETWEEN BeginDate AND EndDate AND XlatID = @XLAT_ID);
SET	@YEAR_NO   = (SELECT CONVERT(VARCHAR(2),@TDATE,2) AS [YY]);
SET	@PERIOD_NO = (SELECT CycleNo from tblCycleXLAT WHERE @BEG_DATE = BeginDate AND XlatID = @XLAT_ID) - @CYCLEADJ;


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

/*
------------------------------------------------------------------------------------------------------------------
[	BALANCE RESET QUERIES - TEMPLATE				]
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
------------------------------------------------------------------------------------------------------------------

Author:		Roger Corley
Created:	March 31, 2015

Description:

Set of SQL queries created to completed the following tasks:

1.)		Allow the technician to set a payment post transaction date  for variable @_TDATE.
2.)		Use @_TDATE to automatically determine Cycle BeginDate and EndDate.
3.)		Assign Cycle BeginDate to @_BEGINDATE and Cycle EndDate to @_ENDDATE.
4.)		Use dates and following filters to caclulate all existing transactions, within the date range,
for each account.
a.)	@_PAYTID 	= Payment TransID - Must align with @_CHGTID(s)
b.)	@_CHGTID 	= Charge TransID that are found in tblDetail.
c.)	@_ACID 		= AccountClassID(s) for the accounts to be searched.
5.)		INSERTS results INTO a temporary table named RESETS with @_BadgeNo NULL.
6.)		Second query matches all AccountNo(s) with corresponding BadgeNo(s) and
then SETS corresponding row in RESETS with the correct BadgeNo.


------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
------------------------------------------------------------------------------------------------------------------
*/

USE [GEMdb];
GO

DECLARE		@_TDATE datetime, @_BEGINDATE datetime, @_ENDDATE datetime;
DECLARE		@_CID int, @_OUTNO int, @_PAYTID int;
DECLARE		@_BID char(8), @_REFNO char(4), @_CHKNO char(6);
DECLARE		@_ACID varchar(50), @_CHGTID varchar(50);
DECLARE		@_BadgeNo char(19);


------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
------------------------------------------------------------------------------------------------------------------

/*
------------------------------------------------------------------------------------------------------------------
[	QUERY VARIABLES:	MODIFY VALUES AS NEEDED		]
------------------------------------------------------------------------------------------------------------------
*/

SET		@_TDATE		= '03-26-2015 23:59:59';
/*					MODIFY DATE VALUE ONLY!! DO NOT MODIFY TIME VALUE!!
-- The date MUST MATCH the LAST day of the cycle.
-- The last day of the cycle is the night before
-- the BeginDate of the next cycle.

Enclose with single quotes ('').				*/


SET		@_BID		= 'Payments';
/*		 		 	!! DO NOT MODIFY !!								*/


SET		@_CID		= 1;
/* 					!! DO NOT MODIFY !!								*/


SET		@_OUTNO		= 1000;
/*					No single quotes ('').
MODIFY ONLY IF REQUIRED. 						*/


SET		@_PAYTID	= 501;
/*					No single quotes ('').

This value MUST MATCH THE CORRECT
-- Payment TransID for any charge TransID(s)
-- listed in the WHERE clause.
-- ( e.g. '501' <--> '10'; '502' <--> '20' )	*/


SET		@_REFNO		= 'AUTO';
/*					Enclose with single quotes ('').
MODIFY ONLY IF REQUIRED. 						*/


SET		@_CHKNO		= 'BIWK';
/* 					Enclose with single quotes ('').
This value MUST MATCH THE CORRECT XLATID
for this payment type.
( e.g. 'BIWK'; 'BIWK2'; 'MTH' ) 				*/


SET		@_BadgeNo	= NULL;
/*					!! DO NOT MODIFY !! EVER !!!					*/


SET 	@_CHGTID 	= ',1,2,4,15,';
/*					Enclose with single quotes ('').
MUST BEGIN AND END with commas (,1,2,3,).		*/

SET 	@_ACID		= ',10,40,';
/*					Enclose with single quotes ('').
MUST BEGIN AND END with commas (,10,20,30,).	*/


------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
------------------------------------------------------------------------------------------------------------------

/*
------------------------------------------------------------------------------------------------------------------
[	FIRST SECTION OF BALANCE RESET QUERY 			]
------------------------------------------------------------------------------------------------------------------
*/



SET		@_BEGINDATE	= (SELECT BeginDate FROM tblCycleXlat AS xlat
WHERE @_TDATE BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @_CHKNO);
SET		@_ENDDATE	= (SELECT EndDate FROM tblCycleXlat AS xlat
WHERE @_TDATE BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @_CHKNO);

SELECT	@_BID 			AS BatchID
,@_CID 			AS CoreID
,ohd.AccountNo 	AS AccountNo
,@_TDATE 		AS TransDate
,@_OUTNO 		AS OutletNo
,@_PAYTID 		AS TransID
,@_REFNO 		AS RefNum
,@_CHKNO 		AS ChkNum


,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS TransTotal
,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS Sales1

,@_BADGENO 		AS BadgeNo


INTO	RESETS

FROM	tblDetail 		AS dtl
LEFT JOIN tblAccountOHD AS ohd ON dtl.AccountNo = ohd.AccountNo

WHERE	CHARINDEX(','+CAST(TransID as VARCHAR(50))+',',@_CHGTID) > 0 AND
CHARINDEX(','+CAST(ohd.AccountClassID AS VARCHAR(50))+',',@_ACID) > 0 AND
dtl.TransDate BETWEEN @_BEGINDATE AND @_ENDDATE

GROUP BY 	ohd.AccountNo
HAVING 		SUM(dtl.TransTotal) <> 0
ORDER BY 	dbo.LPad(RTRIM(ohd.AccountNo),19,'0')

)
------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
------------------------------------------------------------------------------------------------------------------


/*
------------------------------------------------------------------------------------------------------------------
[	SECOND SECTION OF BALANCE RESET QUERY   		]
------------------------------------------------------------------------------------------------------------------
*/


USE [GEMdb];
GO

UPDATE 	dbo.RESETS
SET		BadgeNo = d.BadgeNo

FROM 	(SELECT a.AccountNo, b.BadgeNo FROM tblAccountOHD AS a join tblBadgesOHD AS b on a.AccountNo = b.AccountNo) AS d
,RESETS AS c

WHERE 	c.AccountNo = d.AccountNo


------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
/*				UPDATE QUERIES																										*/
-------------------------------------------------------------------------------------------------------------------------------------



/*		UPDATE: Modify Badge Expiration Dates
=================================================*/
USE [GEMdb]
GO

DECLARE	@_NewExpDate datetime, @_OldExpDateBeg datetime, @_OldExpDateEnd datetime;

SET		@_OldExpDateBeg = '2055-01-01'
SET		@_OldExpDateEnd = '2055-12-31'

SET		@_NewExpDate = '2056-01-01 11:59:59 PM'


UPDATE	tblAccountTTL
SET 	ExpireDate = @_NewExpDate
WHERE 	ExpireDate BETWEEN @_OldExpDateBeg AND @_OldExpDateEnd

UPDATE	tblAccountOHD
SET 	ExpireDate = @_NewExpDate
WHERE 	ExpireDate BETWEEN @_OldExpDateBeg AND @_OldExpDateEnd

UPDATE 	tblBadgesOHD
SET 	ExpireDate = @_NewExpDate
WHERE 	ExpireDate BETWEEN @_OldExpDateBeg AND @_OldExpDateEnd

UPDATE 	cfgSIMxlat
SET 	ExpireDate = @_NewExpDate
WHERE 	ExpireDate BETWEEN @_OldExpDateBeg AND @_OldExpDateEnd

UPDATE	cfgOverhead
SET 	ExpireDays = 18250


------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
/*				ADD / CREATE QUERIES																								*/
-------------------------------------------------------------------------------------------------------------------------------------



/*		CREATE: AccountTTL By Account Class
=================================================*/


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_ID(N'[dbo].[CreateAccountTTLsByClass]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ad_Create_TTL_Manually]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE dbo.CreateAccountTTLsByClass

@TransClassID	int,
@AccountClassID	int = 0

AS

/*
Use this procedure to create new account TTLs for all accounts that do NOT already have the TTL specified (TransClassID).
If you also pass the AccountClass, only members of that class will get the new TTLs.
*/

If @AccountClassID > 0
Begin

INSERT INTO	tblAccountTTL (AccountNo, TransClassID)
SELECT 		AccountNo, @TransClassID
FROM		tblAccountOHD
WHERE		AccountNo NOT IN (SELECT AccountNo FROM tblAccountTTL WHERE TransClassID = @TransClassID) and AccountClassID = @AccountClassID
End
Else
Begin
INSERT INTO	tblAccountTTL (AccountNo, TransClassID)
SELECT 		AccountNo, @TransClassID
FROM		tblAccountOHD
WHERE		AccountNo NOT IN (SELECT AccountNo FROM tblAccountTTL WHERE TransClassID = @TransClassID)
End


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

------------------------------------------------------------------------------------




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


-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
/*				DATE/TIME FORMAT CALCULATIONS																						*/
-------------------------------------------------------------------------------------------------------------------------------------

/*	Standard Date Formats
=============================================================== */

--				Format DATE as:	Jan 1 2015 1:29PM  --  DEFAULT
SELECT			CONVERT(VARCHAR(20),GETDATE(), 100)

--				Format DATE as:	01/01/15  --  Standard: USA
SELECT			CONVERT(VARCHAR(8),GETDATE(), 1) AS [MM/DD/YY]

--				Format DATE as:	01/01/2015  --  Standard: USA
SELECT			CONVERT(VARCHAR(10),GETDATE(), 101) AS [MM/DD/YYYY]

--				Format DATE as:	15.01.01  --  Standard: ANSI
SELECT			CONVERT(VARCHAR(8),GETDATE(), 2) AS [YY.MM.DD]

--				Format DATE as:	2015.01.01  --  Standard: ANSI
SELECT			CONVERT(VARCHAR(10),GETDATE(), 102) AS [YYYY.MM.DD]

--				Format DATE as:	01/01/15  --  Standard: British/French
SELECT			CONVERT(VARCHAR(8),GETDATE(), 3) AS [DD/MM/YY]

--				Format DATE as:	01/01/2015  --  Standard: British/French
SELECT			CONVERT(VARCHAR(10),GETDATE(), 103) AS [DD/MM/YYYY]

--				Format DATE as:	01.01.15  --  Standard: German
SELECT			CONVERT(VARCHAR(8),GETDATE(), 4) AS [DD.MM.YY]

--				Format DATE as:	01.01.2015  --  Standard: German
SELECT			CONVERT(VARCHAR(10),GETDATE(), 104) AS [DD.MM.YYYY]

--				Format DATE as:	01-01-15  --  Standard: Italian
SELECT			CONVERT(VARCHAR(8),GETDATE(), 5) AS [DD-MM-YY]

--				Format DATE as:	01-01-2015  --  Standard: Italian
SELECT			CONVERT(VARCHAR(10),GETDATE(), 105) AS [DD-MM-YYYY]

--				Format DATE as:	01 Jan 15
SELECT			CONVERT(VARCHAR(9),GETDATE(), 6) AS [DD MON YY]

--				Format DATE as:	01 Jan 2015
SELECT			CONVERT(VARCHAR(11),GETDATE(), 106) AS [DD MON YYYY]

--				Format DATE as:	Jan 01, 15
SELECT			CONVERT(VARCHAR(10),GETDATE(), 7) AS [Mon DD, YY]

--				Format DATE as:	Jan 01, 2015
SELECT			CONVERT(VARCHAR(12),GETDATE(), 107) AS [Mon DD, YYYY]

--				Format DATE/TIME as:	Jan 01 2015 01:23:45:123PM
SELECT			CONVERT(VARCHAR(26),GETDATE(), 109)

--				Format DATE as:	01-01-15	--	Standard: USA
SELECT			CONVERT(VARCHAR(8),GETDATE(), 10) AS [MM-DD-YY]

--				Format DATE as:	01-01-2015	--	Standard: USA
SELECT			CONVERT(VARCHAR(10),GETDATE(), 110) AS [MM-DD-YYYY]

--				Format DATE as:	150101		--	Standard: ISO
SELECT			CONVERT(VARCHAR(6),GETDATE(), 12) AS [YYMMDD]

--				Format DATE as:	20150101		--	Standard: ISO
SELECT			CONVERT(VARCHAR(8),GETDATE(), 112) AS [YYYYMMDD]

--				Format DATE as:	2015-01-01 01:23:45	--	Standard: ODBC CANONICAL
SELECT			CONVERT(VARCHAR(19),GETDATE(), 120)

--				Format DATE as:	2015-01-01 01:23:45:123	--	Standard: ODBC CANONICAL MS
SELECT			CONVERT(VARCHAR(23),GETDATE(), 121)

--				Format DATE as:	01/15
SELECT			RIGHT(CONVERT(VARCHAR(8),GETDATE(), 3), 5) AS [MM/YY]
SELECT			SUBSTRING(CONVERT(VARCHAR(8), GETDATE(), 3), 4, 5) AS [MM/YY]

--				Format DATE as:	01/2015
SELECT			RIGHT(CONVERT(VARCHAR(10), GETDATE(), 103), 7) AS [MM/YYYY]

--				Format DATE as:	January 01, 2015
SELECT			DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(), 107), 9) AS [Month DD, YYYY]

--				Format DATE as:	Jan 2015
SELECT			SUBSTRING(CONVERT(VARCHAR(11), GETDATE(), 113), 4, 8) AS [Mon YYYY]

--				Format DATE as:	January 2015
SELECT			DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(), 107), 9) AS [Month DD, YYYY]

--				Format DATE as:	15 January
SELECT			CAST(DAY(GETDATE()) AS VARCHAR(2)) + ' ' + DATENAME(MM, GETDATE()) AS [DD Month]

--				Format DATE as: January 01
SELECT			DATENAME(MM, GETDATE()) + ' ' + CAST(DAY(GETDATE()) AS VARCHAR(2)) AS [Month DD]


/*	Standard Time Formats
=============================================================== */
--				Format TIME as:	01:23:45
SELECT			CONVERT(VARCHAR(10),GETDATE(), 108) AS [Mon DD, YY]


-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
/*				FILTERING & WHERE CLAUSES																							*/
-------------------------------------------------------------------------------------------------------------------------------------


/*
FILTER BY VARIABLE WITH COMMA-SEPARATED 'IN' VALUES
=============================================================== */

DECLARE			@_IDs VARCHAR(50);
SET 			@_IDs = ',1,2,3,4,5,6,544,';

SELECT 			*

FROM 			[someTable]

WHERE 			CHARINDEX(','+CAST(someColumn as VARCHAR(50))+',', @_IDs) > 0


-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------
/*				SQL MATH : SUM - AVG - MAX - MIN - ETC																																									*/
-------------------------------------------------------------------------------------------------------------------------------------


/*	SUM OVER : Running Totals ( gte SQL 2012)
=============================================================== */

SELECT a.id, a.account, a.deposit, SUM(a.deposit) OVER (ORDER BY a.id) AS 'total'
FROM #TestData a
ORDER BY a.id;


/*	SUM OVER : Running Totals - Separate Accts using PARTITION clause ( gte SQL 2012)
=============================================================== */

SELECT a.id, a.account, a.deposit, SUM(a.deposit) OVER (PARTITION BY a.account ORDER BY a.id) AS 'total'
FROM #TestData a
ORDER BY a.id;



-------------------------------------------------------------------------------------------------------------------------------------
/*	MICROS dbisql : Functions & Utilities																																													*/
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
/*	DEFAULT DBISQL ADMIN USER -- SIGN INTO MICROS DB
=============================================================== */
--	USERNAME:		dba
--	PASSWORD:		$upp0rt2
-------------------------------------------------------------------------------------------------------------------------------------


/*	UNLOCK DEFAULT CCENTS PASSWORD - Micros dbisql
=============================================================== */
UPDATE 	micros.emp_def
SET 		ob_account_disabled='F'
WHERE 	user_id = 'ccents'


/*	CLASSIC SECURITY ( TO RESET UNKNOWN CCENTS PASSWORD )
=============================================================== */
UPDATE 	micros.rest_def
SET 		ob_classic_security = ‘T’


/*  FORCE CLOSE ALL OPEN CHECKS ( ** WILL CLOSE ALL OPEN CHEKCS ** )
=============================================================== */
begin
declare @mychk int;
Set @mychk = (select chk_seq from micros.chk_dtl where chk_open = 'T');
call micros.sp_forcechkclose(@mychk);
end
