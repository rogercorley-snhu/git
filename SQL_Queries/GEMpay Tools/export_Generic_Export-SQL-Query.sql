DECLARE   @tdate datetime, @bdate datetime, @edate datetime, @datesearch datetime;
DECLARE   @edateno int, @dateadj int, @cid int;
DECLARE   @acid varchar(50), @ctid varchar(50), @chknum char(6);
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

SET @dateadj = 8;

----------------------------------------------------------------------------------------------------------------------------------------------------------
SET @chknum	= 'BIWK';
--  **NOTE:
-------------------------------------------------------------------------------------------------
--  MUST match the XlatID of the pay cycle for this query

----------------------------------------------------------------------------------------------------------------------------------------------------------
SET @acid	= ',10,';
--  **NOTE:
-------------------------------------------------------------------------------------------------
--  AccountClassIDs MUST begin and end with a comma, with ALL
--  AccountClassIDs  and commas contained inside a set of single quotes.

----------------------------------------------------------------------------------------------------------------------------------------------------------
SET @ctid	= ',1,2,3,4,';
--  **NOTE:
-------------------------------------------------------------------------------------------------
--  TransIDs MUST begin and end with a comma, with ALL
--  TransIDs  and commas contained inside a set of single quotes.

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

--  TO SEARCH BY A DATE IN A CYCLE:
-------------------------------------------------------------------------------------------------------
--  SET @datesearch = '2016-02-22';


--  TO SEARCH BY TODAY'S DATE MINUS THE @dateadj VARIABLE:
-------------------------------------------------------------------------------------------------------
  SET @datesearch = GETDATE()-@dateadj;



/*
========================================================================================
*************		DO NOT MODIFY PAST THIS POINT
========================================================================================
*/


----------------------------------------------------------------------------------------------------------------------------------------------------------
SET @bdate	= (SELECT BeginDate FROM tblCycleXlat AS xlat
		WHERE @datesearch BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @chknum);
----------------------------------------------------------------------------------------------------------------------------------------------------------
SET @edate	= (SELECT EndDate FROM tblCycleXlat AS xlat
		WHERE @datesearch BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @chknum);

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT
	A.AccountNo [AccountNo],
	SUM(D.TransTotal) [Total]

FROM
	tblDetail AS D
	LEFT JOIN tblAccountOHD AS A ON D.AccountNo = A.AccountNo

WHERE
	CHARINDEX(','+CAST(D.TransID as VARCHAR(50))+',',@ctid) > 0
	AND CHARINDEX(','+CAST(A.AccountClassID AS VARCHAR(50))+',',@acid) > 0
	AND D.TransDate BETWEEN @bdate AND @edate

GROUP BY
	A.AccountNo

ORDER BY
	A.AccountNo