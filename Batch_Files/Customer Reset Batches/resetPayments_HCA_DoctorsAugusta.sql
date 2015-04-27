/*=====================================================================================================
BALANCE RESET QUERIES - TEMPLATE					   
=======================================================================================================

Author:			Roger Corley
Created:		April 28, 2015
Description:	Set of SQL queries created to completed the following tasks:

----------------------------------------------------------------------------------------------
1.)	Allow the technician to set a payment post transaction date @tdate.
----------------------------------------------------------------------------------------------
2.)	Use @tdate to determine Cycle BeginDate and EndDate.
----------------------------------------------------------------------------------------------
3.)	Assign BeginDate = @bdate and EndDate = @edate.
----------------------------------------------------------------------------------------------
4.)	Use dates and following filters to caclulate all transactions for an account.
		a.)	@payid 	= Payment TransID - Must align with @ctid(s)
		b.)	@ctid 	= Charge TransID that are found in tblDetail.
		c.)	@acid 		= AccountClassID(s) for the accounts to be searched.
----------------------------------------------------------------------------------------------
5.)	INSERTS results INTO a temporary table named RESETS with @badge NULL.
----------------------------------------------------------------------------------------------
6.)	Second query matches all AccountNo(s) with corresponding BadgeNo(s) and
	then SETS corresponding row in RESETS with the correct BadgeNo.
----------------------------------------------------------------------------------------------
7.)	Perform spot checks on minimum 5 accounts to verify payment matches transaction balance
----------------------------------------------------------------------------------------------
8.)	Technician can then perform a Database Tasks - Import with the following parameters:
		a.) Select Import From Table : dbo.RESETS
		b.) Select Import To Table : dbo.Batches
		c.) Finish Import
----------------------------------------------------------------------------------------------
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


/*=====================================================================================================
[ BEGIN ] : DECLARE QUERY VARIABLES
=====================================================================================================*/

USE [GEMdb];
GO

------------------------------------------------------------
DECLARE		@tdate datetime, @bdate datetime, @edate datetime;
DECLARE		@cid int, @outno int, @payid int; 
DECLARE		@bid char(8), @refnum char(4), @chknum char(6); 
DECLARE		@acid varchar(50), @ctid varchar(50);
DECLARE		@badge char(19);
------------------------------------------------------------


/*=====================================================================================================
[ END ] : DECLARE QUERY VARIABLES
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


/*
=======================================================================================================
[ BEGIN ] : CONFIGURE QUERY VARIABLES
======================================================================================================*/

-------------------------------------------------------------------------------------------------------
--	PAYMENT POST DATE : YOU MUST MODIFY THIS : DATE ONLY - NOT TIME
-------------------------------------------------------------------------------------------------------

SET		@tdate		= '07-29-2015 23:59:59';
--	The date MUST MATCH the LAST day of the cycle.
--	The last day of the cycle is the night before 
--	the BeginDate of the next cycle.
--	Enclose with single quotes ('').
------------------------------------------------------------


-------------------------------------------------------------------------------------------------------
--	CONFIGURE VARIABLES : MODIFY ONLY IF NEEDED  ( e.g. @ctid or @acid )
-------------------------------------------------------------------------------------------------------

SET	@outno		= 1000;		
-- MODIFY ONLY IF REQUIRED. 
------------------------------------------------------------

SET	@payid	= 501;
-- This value MUST MATCH THE CORRECT 
-- Payment TransID for any charge TransID(s) 
-- listed in the WHERE clause. ( e.g. '501' <--> '10' )
------------------------------------------------------------

SET	@refnum		= 'AUTO';		
--	Enclose with single quotes ('').
--	MODIFY ONLY IF REQUIRED. 
------------------------------------------------------------

SET	@chknum		= 'BIWK';		
--	Enclose with single quotes ('').
--	This value MUST MATCH THE CORRECT XLATID
--	for this payment type.  ( e.g. 'BIWK'; 'BIWK2'; 'MTH' ) 
------------------------------------------------------------

SET	@ctid 	= ',1,2,4,15,';
--	Enclose with single quotes ('').
--	MUST BEGIN AND END with commas (,1,2,3,)
------------------------------------------------------------

SET	@acid		= ',10,40,';
--	Enclose with single quotes ('').
--	MUST BEGIN AND END with commas (,10,20,30,)
------------------------------------------------------------

/*-----------------------------------------------------------------------------------------------------
=======================================================================================================
[	****	CONSTANTS : DO NOT MODIFY	****	]
======================================================================================================= 
-----------------------------------------------------------------------------------------------------*/

SET	@bdate	= (SELECT BeginDate FROM tblCycleXlat AS xlat 
					WHERE @tdate BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @chknum);
------------------------------------------------------------

SET	@edate	= (SELECT EndDate FROM tblCycleXlat AS xlat 
					WHERE @tdate BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @chknum);
------------------------------------------------------------

SET	@bid	= 'Payments';					
------------------------------------------------------------

SET	@cid	= 1; 								
------------------------------------------------------------

SET	@badge	= NULL;			
------------------------------------------------------------


/*-----------------------------------------------------------------------------------------------------
=======================================================================================================
[	****	DO NOT MODIFY ANYTHING PAST THIS SECTION	****	]
======================================================================================================= 
-----------------------------------------------------------------------------------------------------*/

/*=====================================================================================================
[ BEGIN ] : Build RESETS Temporary Table
=====================================================================================================*/

SELECT		 
-----------------------------------------------------------------------------------------
   @bid				AS [BatchID]  
  ,@cid 			AS [CoreID]  
  ,dtl.AccountNo 	AS [AccountNo]
  ,@tdate 			AS [TransDate]
  ,@outno 			AS [OutletNo]
  ,@payid			AS [TransID]
  ,@refnum 			AS [RefNum]
  ,@chknum 			AS [ChkNum]
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
  ,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS [TransTotal]
  ,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS [Sales1]
-----------------------------------------------------------------------------------------
			
-----------------------------------------------------------------------------------------
  ,@badge			AS [BadgeNo]
-----------------------------------------------------------------------------------------
		
INTO RESETS

FROM
  tblDetail	AS dtl
  LEFT JOIN tblAccountOHD AS ohd ON dtl.AccountNo = ohd.AccountNo
		
WHERE
  CHARINDEX(','+CAST(TransID as VARCHAR(50))+',',@ctid) > 0 
  AND CHARINDEX(','+CAST(ohd.AccountClassID AS VARCHAR(50))+',',@acid) > 0 
  AND dtl.TransDate BETWEEN @bdate AND @edate

GROUP BY 	
  dtl.AccountNo

HAVING
  SUM(dtl.TransTotal) <> 0

ORDER BY
  dbo.LPad(RTRIM(ohd.AccountNo),19,'0')


/*=====================================================================================================
[ END ] : Build RESETS Temporary Table
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


=======================================================================================================
[ BEGIN ] : Insert BadgeNo Into RESETS Table
=====================================================================================================*/

USE [GEMdb];
GO

UPDATE	dbo.RESETS
Set 	BadgeNo = d.BadgeNo

FROM
  (SELECT 
  		a.AccountNo, b.BadgeNo 

   FROM tblAccountOHD AS a 
   		join tblBadgesOHD AS b ON a.AccountNo = b.AccountNo) AS d, RESETS AS c

WHERE
 c.AccountNo = d.AccountNo

/*=====================================================================================================
[ END ] : Insert BadgeNo Into RESETS Table
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/