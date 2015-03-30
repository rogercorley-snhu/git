/*		BALANCE RESET QUERIES		*/

USE [GEMdb];
GO

DECLARE		@_TDATE datetime, @_BEGINDATE datetime, @_ENDDATE datetime;
DECLARE		@_CID int, @_OUTNO int, @_TID int; 
DECLARE		@_BID char(8), @_REFNO char(4), @_CHKNO char(6); 
DECLARE		@_BadgeNo char(19);


/*	---------------------------------------------------------------------------	
		[	 ***	MODIFY THE FOLLOWING VALUES ONLY	*** 	]
-------------------------------------------------------------------------------*/

SET			@_TDATE			= '03-26-2015 23:59:59';

SET			@_BID			= 'Payments';
SET			@_CID			= 1;
SET			@_OUTNO			= 1000;
SET			@_TID			= 501;
SET			@_REFNO			= 'AUTO';
SET			@_CHKNO			= 'BIWK';
SET			@_BadgeNo		= NULL;

-------------------------------------------------------------------------------



SET			@_BEGINDATE		= (SELECT BeginDate FROM tblCycleXlat AS xlat WHERE @_TDATE BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @_CHKNO);
SET			@_ENDDATE		= (SELECT EndDate FROM tblCycleXlat AS xlat WHERE @_TDATE BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @_CHKNO);

SELECT		 @_BID AS BatchID
			,@_CID AS CoreID
			,ohd.AccountNo AS AccountNo
			,@_TDATE AS TransDate
			,@_OUTNO AS OutletNo
			,@_TID AS TransID
			,@_REFNO AS RefNum
			,@_CHKNO AS ChkNum
			
			
			,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS TransTotal
			,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS Sales1
			
			,@_BADGENO AS BadgeNo

		
INTO		RESETS

FROM		tblDetail AS dtl
				LEFT JOIN tblAccountOHD AS ohd ON dtl.AccountNo = ohd.AccountNo
		
WHERE		dtl.TransID IN (1,2,4,15) AND 
			ohd.AccountClassID IN (10,40) AND
			dtl.TransDate BETWEEN @_BEGINDATE AND @_ENDDATE

GROUP BY 	ohd.AccountNo

HAVING 		SUM(dtl.TransTotal) <> 0

ORDER BY 	dbo.LPad(RTRIM(ohd.AccountNo),19,'0')




USE [GEMdb];
GO

UPDATE 		dbo.RESETS

SET			BadgeNo = d.BadgeNo

FROM 		(SELECT a.AccountNo, b.BadgeNo FROM tblAccountOHD AS a join tblBadgesOHD AS b on a.AccountNo = b.AccountNo) AS d, RESETS AS c

WHERE 		c.AccountNo = d.AccountNo