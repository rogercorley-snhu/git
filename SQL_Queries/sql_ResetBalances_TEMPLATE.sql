/*
------------------------------------------------------------------------------------------------------------------
[	BALANCE RESET QUERIES - TEMPLATE				]
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
------------------------------------------------------------------------------------------------------------------

Author:		Roger Corley
Created:		March 31, 2015

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

SET	@_TDATE	= '07-11-2015 23:59:59';
/*			MODIFY DATE VALUE ONLY!! DO NOT MODIFY TIME VALUE!!
			-- The date MUST MATCH the LAST day of the cycle.
			-- The last day of the cycle is the night before
			-- the BeginDate of the next cycle.

			Enclose with single quotes ('').				*/


SET 	@_CHGTID 	= ',1,2,';
/*			Enclose with single quotes ('').
			MUST BEGIN AND END with commas (,1,2,3,).		*/

SET 	@_ACID	= ',10,';
/*			Enclose with single quotes ('').
			MUST BEGIN AND END with commas (,10,20,30,).		*/


------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
------------------------------------------------------------------------------------------------------------------



SET	@_BID 		= 'Payments';
/*		 	 !! DO NOT MODIFY !!						*/


SET	@_CID		= 1;
/* 			!! DO NOT MODIFY !!						*/


SET	@_OUTNO	= 1000;
/*			No single quotes ('').
			MODIFY ONLY IF REQUIRED. 					*/


SET	@_PAYTID	= 501;
/*			No single quotes ('').

			This value MUST MATCH THE CORRECT
			-- Payment TransID for any charge TransID(s)
			-- listed in the WHERE clause.
			-- ( e.g. '501' <--> '10'; '502' <--> '20' )				*/


SET	@_REFNO	= 'AUTO';
/*			Enclose with single quotes ('').
			MODIFY ONLY IF REQUIRED. 					*/


SET	@_CHKNO	= 'BIWK';
/* 			Enclose with single quotes ('').
			This value MUST MATCH THE CORRECT XLATID
			for this payment type.
			( e.g. 'BIWK'; 'BIWK2'; 'MTH' ) 					*/


SET	@_BadgeNo	= NULL;
/*			!! DO NOT MODIFY !! EVER !!!					*/



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

SELECT		 @_BID 		AS BatchID
		,@_CID 		AS CoreID
		,ohd.AccountNo 	AS AccountNo
		,@_TDATE 		AS TransDate
		,@_OUTNO 		AS OutletNo
		,@_PAYTID 		AS TransID
		,@_REFNO 		AS RefNum
		,@_CHKNO 		AS ChkNum


		,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS TransTotal
		,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS Sales1

		,@_BADGENO 	AS BadgeNo


INTO		RESETS

FROM		tblDetail 		AS dtl
		LEFT JOIN tblAccountOHD AS ohd ON dtl.AccountNo = ohd.AccountNo

WHERE	 	bCHARINDEX(','+CAST(TransID as VARCHAR(50))+',',@_CHGTID) > 0 AND
		CHARINDEX(','+CAST(ohd.AccountClassID AS VARCHAR(50))+',',@_ACID) > 0 AND
		dtl.TransDate BETWEEN @_BEGINDATE AND @_ENDDATE

GROUP BY 	ohd.AccountNo
HAVING 	SUM(dtl.TransTotal) <> 0
ORDER BY 	dbo.LPad(RTRIM(ohd.AccountNo),19,'0')


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


/*
------------------------------------------------------------------------------------------------------------------
[	IMPORT RESETS INTO tblBATCH   		]
------------------------------------------------------------------------------------------------------------------
*/


GO

IF OBJECT_ID(N'GEMdb..RESETS') IS NULL
	BEGIN
		PRINT '[ ERROR ] : The temporary table RESETS does not exist.'
	END
ELSE
	BEGIN
		PRINT '[ IMPORT ] : The temporary table RESETS exists.'
		PRINT '[ IMPORT ] : Importing table data from RESETS tables INTO tblBatch.'


		INSERT INTO tblBatch ( BatchID, CoreID, AccountNo, TransDate, OutletNo, TransID, RefNum, ChkNum, TransTotal, Sales1, BadgeNo )

		SELECT  BatchID, CoreID, AccountNo, TransDate, OutletNo, TransID, RefNum, ChkNum, TransTotal, Sales1, BadgeNo
		FROM  RESETS

		END

GO
