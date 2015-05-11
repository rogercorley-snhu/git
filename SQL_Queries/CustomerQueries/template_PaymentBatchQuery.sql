
/*=====================================================================================================
 ---[ TITLE ]---  GEMPAY MANUAL BALANCE RESETS BATCH QUERY - TEMPLATE
=======================================================================================================

---[ AUTHOR ]---  Roger Corley
---[ CREATED ]--- May 08, 2015

=======================================================================================================
---[ DESCRIPTION ]---   Set of SQL queries created to completed the following tasks:
=======================================================================================================


1.) Allows the technician to set a balance reset transaction date with @tdate.
----------------------------------------------------------------------------------------------
2.) Use @tdate to determine Cycle BeginDate and EndDate.
----------------------------------------------------------------------------------------------
3.) Assign BeginDate = @bdate and EndDate = @edate.
----------------------------------------------------------------------------------------------
4.) Use dates and following filters to caclulate all transactions for an account.
    a.) @payid  = Payment TransID - Must align with @ctid(s)
    b.) @ctid   = Charge TransID that are found in tblDetail.
    c.) @acid     = AccountClassID(s) for the accounts to be searched.
----------------------------------------------------------------------------------------------
5.) INSERTS results INTO a temporary table named RESETS with @badge NULL.
----------------------------------------------------------------------------------------------
6.) Second query matches all AccountNo(s) with corresponding BadgeNo(s) and
  then SETS corresponding row in RESETS with the correct BadgeNo.
----------------------------------------------------------------------------------------------
7.) Create a new GEMpay RESETS Batch
----------------------------------------------------------------------------------------------


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-------------------------------------------------------------------------------------------------------
*******************************************************************************************************
                  READ INSTRUCTIONS BELOW PRIOR TO RUNNING THIS SQL QUERY
*******************************************************************************************************
-------------------------------------------------------------------------------------------------------

---[ BEGIN ]--- [ INSTRUCTIONS ]
-------------------------------------------------------------------------------------------------------


1.)   Open VPN and log into GEMpay server.
-------------------------------------------------------------------------------------------------------

2.)   Log into GEMpay website, select 'MANAGEMENT', select 'ACCOUNT EDIT'
      a.) Enter a known account number, badge number or last name to check.
-------------------------------------------------------------------------------------------------------

3.)   Click 'TRANSACTIONS' and click the 'PREVIOUS CYCLE' button.
      a.) VERIFY that a payment didn't occur.
      b.) Click 'NEXT CYCLE', find 'BEGINNING CYCLE < DATE >'
      c.) Scroll down to [ PAYMENT POST DATE : YOU MUST MODIFY THIS : DATE ONLY - NOT TIME ]
      d.) Enter the date before the 'BEGINNING CYCLE < DATE >' as the value for @tdate
-------------------------------------------------------------------------------------------------------

=======================================================================================================
---[[[ NOTE : ONLY MODIFY THE DATE !! NOT THE TIME VALUE !! ]]]---
=======================================================================================================

-------------------------------------------------------------------------------------------------------

4.)   Open SQL Server Managment Studio and log in as 'gemuser'
      a.) Click the 'NEW QUERY' button at the top-left.
-------------------------------------------------------------------------------------------------------

5.) Copy this entire SQL script and paste it into the new SQL Query window.
-------------------------------------------------------------------------------------------------------

6.)   In the SQL Object Explorer on the left,
      a.) Expand Databases
      b.) Expand GEMdb
      c.) Expand Tables
-------------------------------------------------------------------------------------------------------

7.)   Look for a 'dbo.RESETS' table,
      a.) If it exists, select the 'dbo.RESETS' table
          i.)   MAKE SURE THAT ONLY THE 'dbo.RESETS' TABLE IS SELECTED/HIGHLIGHTED
          ii.)  Right-Click 'dbo.RESETS' (AGAIN - MAKE SURE ONLY THIS TABLE IS SELECTED)
          iii.) Click 'DELETE'
          iv.)  The 'DELETE OBJECT' window will appear
-------------------------------------------------------------------------------------------------------

=======================================================================================================
---[[[ NOTE:  VERIFY THAT OBJECT NAME LISTED IS 'RESETS' ]]]---
          IF NOT CLICK CANCEL - DO NOT CLICK OK!!
=======================================================================================================
---[[[ NOTE:  IF THE OBJECT NAME LISTED IS 'RESETS' ]]]---
          CLICK 'OK'
=======================================================================================================

8.)   Click inside the copied SQL Query window to activate the 'EXECUTE' button
      a.) Verify correct @transdate from step 3.
      b.) Click 'EXECUTE'
-------------------------------------------------------------------------------------------------------

9.)   If SQL Query runs successfully, you will see a MESSAGE below the window (# row(s) affected)
-------------------------------------------------------------------------------------------------------

10.)  In the SQL Object Explorer to the left,
      a.) Right-Click 'TABLES' to open context menu
      b.) Left-Click 'REFRESH'
      c.) You should now see the temporary table 'dbo.RESETS'
-------------------------------------------------------------------------------------------------------

11.)  Right-Click 'dbo.RESETS' to open context menu
      a.) Click 'SELECT TOP 1000 ROWS' to open the table
-------------------------------------------------------------------------------------------------------

12.)  Use this table to run SPOT CHECKS on minimum five (5) accounts
      a.) Left-Click an 'ACCOUNTNO' to select it
      b.) Right-Click the 'ACCOUNTNO' and click 'COPY' to place it in the clipboard
-------------------------------------------------------------------------------------------------------

13.)  Log back into the GEMpay website and navigate to the MANAGEMENT-->ACCOUNT EDIT
      a.) Paste the copied ACCOUNTNO into the Account Number field and click 'START SEARCH'
      b.) VERIFY that the Account Number shown in GEMpay matches the AccountNo from SQL
      c.) Click 'TRANSACTIONS' and click 'PREVIOUS CYCLE'

=======================================================================================================
---[[[ NOTE:  When balance reset is being run on a different previous cycle ]]]---
        Click  'PREVIOUS CYCLE' until you find the correct cycle date range.
=======================================================================================================

      d.) VERIFY that the 'CHARGE BALANCE' listed at the bottom of the page MATCHES the
          'TRANSTOTAL' listed in the row for this account number in your SQL Query return.
      e.) If it matches, proceed to next step.
-------------------------------------------------------------------------------------------------------

=======================================================================================================
---[[[ NOTE:  If balance and RESETS amounts don't match ]]]---
          Verify that you have the correct Cycle End Date
          for the @tdate variable value. Return to STEP 3.
=======================================================================================================

14.)  In the SQL Object Explorer on the left,
      a.) Scroll up until you see the main SQL Server icon
          i.)   This icon will have a green play image on it
          11.)  Naming convention could be either:
                --  (local)(SQL Server <version number> - gemuser)
                --  ServerHostName(SQL Server <version number> - gemuser)
-------------------------------------------------------------------------------------------------------

=======================================================================================================
---[[[ NOTE:  Make note of the ServerHostName being used ]]]--
          You will need it for the Import Wizard.
=======================================================================================================

15.)  In the SQL Object Explorer on the left,
      a.) Scroll until you see 'GEMdb'
      b.) Right-Click 'GEMdb' to open context menu
      c.) Click 'TASKS' then click 'IMPORT DATA'
-------------------------------------------------------------------------------------------------------

16.)  The SQL Server Import and Export Wizard opens
      a.) Click 'NEXT' and follow these steps:

.......................................................................................................
      I.    CHOOSE A DATA SOURCE
.......................................................................................................
      b.) In 'SERVER NAME', enter the ServerHostName you found in STEP 14
          i.) If (local), enter (local)  -- INCLUDE PARENTHESIS!!
          ii.)  If an actual ServerHostName, enter that name -- NO PARENTHESIS!!
      c.) Select 'USE SQL AUTHENTICAITON',
          i.)   Enter 'gemuser' for username
          ii.)  Enter password for gemuser in password field

=======================================================================================================
---[[[ NOTE:  This password is NOT the same password used
          to log into the Windows server !!
=======================================================================================================
---[[[ NOTE:  IF YOU HAVE DOUBTS ABOUT IT, ASK SOMEONE !! ]]]---
=======================================================================================================

      d.) Select 'GEMdb' in the dropdown for 'DATABASE'
      e.) Click 'NEXT'

.......................................................................................................
      II.   CHOOSE A DESTINATION
.......................................................................................................
      f.) Repeat STEPS B - E

.......................................................................................................
      III.    SPECIFY TABLE COPY OR QUERY
.......................................................................................................
      g.) Select 'COPY DATA FROM ONE OR MORE TABLES OR VIEWS'
      h.) Click 'NEXT'

.......................................................................................................
      IV.   SELECT SOURCE TABLES AND VIEWS
.......................................................................................................
      i.) Scroll down until you see 'dbo.RESETS' under the 'SOURCE' column
          --  Click the check-box for it
      j.) In the 'DESTINATION' column, click [dbo].[RESETS]
          --  Scroll down until you see [dbo].[tblBatch] and click it.
      k.) VERIFY that the Source column is [dbo].[RESETS] and the destination
          column is [dbo].[tblBatch]
      l.) Click 'NEXT'

.......................................................................................................
      V.    RUN PACKAGE
.......................................................................................................
      m.) VERIFY that 'Run Immediately' is checked

=======================================================================================================
---[[[ NOTE:  WHEN YOU CLICK NEXT, THE IMPORT WILL RUN IMMEDIATELY ]]]---
=======================================================================================================
---[[[ NOTE:  REVIEW IMPORT SETTINGS ]]]---
          IF YOU HAVE ANY DOUBTS BEFORE CLICKING NEXT !!
=======================================================================================================

      n.) Click 'NEXT'
      o.) Close Wizard
-------------------------------------------------------------------------------------------------------

17.)  Log back into GEMpay website and navigate to MANAGEMENT --> BATCH CREATE/EDIT/POST
      a.) Click the 'PIN' icon to POST RESETS batch to GEMpay
      b.) When presented with a calendar to select a post date, just click POST
      c.) Depending on the size of the batch, it may or may not post entire batch
          --  You may need to repeat this step until batch doesn't show up
-------------------------------------------------------------------------------------------------------

18.)  GEMpay Website -- Navigate to MANAGEMENT --> ACCOUNT EDIT
      a.) Use the accounts you used to spot check in STEP 12
      b.) VERIFY that RESETS now appear in their Transactions for this cycle
      c.) If they appear and are correct amounts, go to next step.
-------------------------------------------------------------------------------------------------------

=======================================================================================================
---[[[ NOTE:  If the RESETS don't appear or they are incorrect ]]---
          Contact Charles or Roger.
=======================================================================================================

19.)  In SQL Server Management Studio,
      a.) Repeat STEP 7 to delete the temporary dbo.RESETS table
-------------------------------------------------------------------------------------------------------


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-------------------------------------------------------------------------------------------------------
=======================================================================================================
              ---[[[    SQL QUERY  CONFIGURATIONS    ]]]---
=======================================================================================================
------------------------------------------------------------------------------------------------------- */


USE [GEMdb];
GO


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


---[ BEGIN ]--- [ DECLARE QUERY VARIABLES ]
-------------------------------------------------------------------------------------------------------

=======================================================================================================
              ---[[[ DO NOT MODIFY DECLARE STATEMENTS ]]]---
======================================================================================================= */


DECLARE   @tdate datetime, @bdate datetime, @edate datetime;
DECLARE   @cid int, @outno int, @payid int;
DECLARE   @bid char(10), @refnum char(6), @chknum char(6);
DECLARE   @acid varchar(50), @ctid varchar(50);
DECLARE   @badge char(19);


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


---[ BEGIN ]--- [ SET  PAYMENT TRANSDATE ]
-------------------------------------------------------------------------------------------------------

=======================================================================================================
              ---[[[ MODIFY DATE  VALUE ONLY  : NOT TIME ]]]---
=======================================================================================================  */

  SET   @tdate   = '02-12-2015 23:59:59';
--------------------------------------------------------------------------------
--  The date MUST MATCH the LAST day of the cycle.
--  The last day of the cycle is the night before
--  the BeginDate of the next cycle.
--  Enclose with single quotes ('').



/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


---[ BEGIN ]--- [ CONFIGURE QUERY VARIABLES ]
-------------------------------------------------------------------------------------------------------

=======================================================================================================
          ---[[[[ MODIFY ONLY IF NEEDED ]]]---
=======================================================================================================  */


SET @outno    = 1000;
--------------------------------------------------------------------------------
-- MODIFY ONLY IF REQUIRED.
--------------------------------------------------------------------------------

SET @payid    = 501;
--------------------------------------------------------------------------------
-- This value MUST MATCH THE CORRECT
-- Payment TransID for any charge TransID(s)
-- listed in the WHERE clause. ( e.g. '501' <--> '10' )
--------------------------------------------------------------------------------

SET @refnum   = 'AUTO';
--------------------------------------------------------------------------------
--  Enclose with single quotes ('').
--  MODIFY ONLY IF REQUIRED.
--------------------------------------------------------------------------------

SET @chknum   = 'BIWK';
--------------------------------------------------------------------------------
--  Enclose with single quotes ('').
--  This value MUST MATCH THE CORRECT XLATID
--  for this payment type.  ( e.g. 'BIWK'; 'BIWK2'; 'MTH' )
--------------------------------------------------------------------------------

SET @ctid   = ',1,2,4,15,';
--------------------------------------------------------------------------------
--  Enclose with single quotes ('').
--  MUST BEGIN AND END with commas (,1,2,3,)
--------------------------------------------------------------------------------

SET @acid   = ',10,40,';
--------------------------------------------------------------------------------
--  Enclose with single quotes ('').
--  MUST BEGIN AND END with commas (,10,20,30,)
--------------------------------------------------------------------------------



/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================================
          ---[[[    DO NOT MODIFY ANYTHING PAST THIS SECTION    ]]]---
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



---[ BEGIN ]---   [ CHECK TABLE RESETS ]
-------------------------------------------------------------------------------------------------------

=======================================================================================================
          ---[[[ IF RESETS EXISTS, DROP RESETS TABLE ]]]---
          ---[[[ DO NOT MODIFY CHECK  STATEMENTS ]]]---
=======================================================================================================  */


IF OBJECT_ID(N'GEMdb..RESETS') IS NOT NULL
  BEGIN
    PRINT 'RESETS exists'
    DROP TABLE RESETS
    PRINT 'RESETS table dropped.'
  END
ELSE
  BEGIN
    PRINT 'RESETS does not exist'
    PRINT 'Beginning RESETS Script'
  END




---[ SCRIPT CONSTANTS ]---
-------------------------------------------------------------------------------------------------------

/*=====================================================================================================
              ---[[[ DO NOT MODIFY CONSTANTS ]]]---
=======================================================================================================  */


SET @bdate  = (SELECT BeginDate FROM tblCycleXlat AS xlat
          WHERE @tdate BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @chknum);
------------------------------------------------------------

SET @edate  = (SELECT EndDate FROM tblCycleXlat AS xlat
          WHERE @tdate BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @chknum);
------------------------------------------------------------

SET @bid  = 'RESETS';
------------------------------------------------------------

SET @cid    = 1;
------------------------------------------------------------

SET @badge  = NULL;
------------------------------------------------------------


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=======================================================================================================
                ---[[[ BEGIN SQL QUERY ]]]---
=======================================================================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  */


SELECT
-----------------------------------------------------------------------------------------
   @bid       AS [BatchID]
  ,@cid       AS [CoreID]
  ,ohd.AccountNo  AS [AccountNo]
  ,@tdate     AS [TransDate]
  ,@outno     AS [OutletNo]
  ,@payid     AS [TransID]
  ,@refnum      AS [RefNum]
  ,@chknum      AS [ChkNum]


  ,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS [TransTotal]
  ,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS [Sales1]

  ,@badge     AS [BadgeNo]


INTO RESETS
-----------------------------------------------------------------------------------------


FROM
-----------------------------------------------------------------------------------------
  tblDetail AS dtl
  LEFT JOIN tblAccountOHD AS ohd ON dtl.AccountNo = ohd.AccountNo



WHERE
-----------------------------------------------------------------------------------------
  CHARINDEX(','+CAST(TransID as VARCHAR(50))+',',@ctid) > 0
  AND CHARINDEX(','+CAST(ohd.AccountClassID AS VARCHAR(50))+',',@acid) > 0
  AND dtl.TransDate BETWEEN @bdate AND @edate



GROUP BY
-----------------------------------------------------------------------------------------
  ohd.AccountNo



HAVING
-----------------------------------------------------------------------------------------
  SUM(dtl.TransTotal) <> 0



ORDER BY
-----------------------------------------------------------------------------------------
  dbo.LPad(RTRIM(ohd.AccountNo),19,'0')



/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


========================================================================================
---[ BEGIN ]--- [ Insert BadgeNo INTO RESETS Temporary Table ]
========================================================================================  */

USE [GEMdb];
GO

-----------------------------------------------------------------------------------------
UPDATE   dbo.RESETS
SET      BadgeNo = d.BadgeNo

-----------------------------------------------------------------------------------------

FROM
-----------------------------------------------------------------------------------------
  (SELECT
      a.AccountNo, b.BadgeNo

   FROM tblAccountOHD AS a
      join tblBadgesOHD AS b ON a.AccountNo = b.AccountNo) AS d, RESETS AS c

-----------------------------------------------------------------------------------------

WHERE
-----------------------------------------------------------------------------------------
 c.AccountNo = d.AccountNo

 -----------------------------------------------------------------------------------------


GO


/*
========================================================================
---[ END ]---   [   RESETS BATCH QUERY    ]
========================================================================
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  */
