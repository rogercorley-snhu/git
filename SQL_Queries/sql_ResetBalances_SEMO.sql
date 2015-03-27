/*		SEMO BALANCE RESET QUERIES		*/

USE GEMdb
GO

DECLARE	@__TDATE datetime, @__OUTNO int, @__TID int, @__REFNO varchar(4), @__CHKNO varchar(6); 
DECLARE @__BEGINDATE datetime, @__ENDDATE datetime;
DECLARE @__BADGENO varchar(19);


SET		@__TDATE = '03-21-2015 23:59:00';


SET		@__OUTNO =	1000;
SET		@__TID =	501;
SET		@__REFNO = 'AUTO';
SET		@__CHKNO = 'BIWK';


SET		@__BEGINDATE =	(SELECT BeginDate FROM tblCycleXlat AS xlat WHERE @__TDATE BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @__CHKNO);
SET		@__ENDDATE =	(SELECT EndDate FROM tblCycleXlat AS xlat WHERE @__TDATE BETWEEN xlat.BeginDate AND xlat.EndDate AND xlat.xlatID = @__CHKNO);

--SET		@__BADGENO =	(SELECT b.badgeno from tblBadgesOHD as b left join tblDetail as d on d.accountno = b.accountno join tblAccountOHD as a on d.AccountNo = a.AccountNo where b.AccountNo = a.AccountNo); 


SELECT	'Payments' AS BatchID
		,'1' AS CoreID
		,ohd.AccountNo AS AccountNo

		,@__TDATE AS TransDate
		,@__OUTNO AS OutletNo
		,@__TID AS TransID
		,@__REFNO AS RefNum
		,@__CHKNO AS ChkNum
		
		
		,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS TransTotal
		,CASE WHEN SUM(dtl.TransTotal) < 0 THEN 0 ELSE SUM(dtl.TransTotal) END AS Sales1
		
		,@__BADGENO AS BadgeNo
		
INTO	RESETS

FROM	tblDetail AS dtl
		LEFT JOIN tblAccountOHD AS ohd ON dtl.AccountNo = ohd.AccountNo

WHERE	--dtl.TransID IN (1,2,3) AND 
		ohd.AccountClassID IN (10) AND
		dtl.TransDate BETWEEN @__BEGINDATE AND @__ENDDATE AND
		dtl.AccountNo NOT LIKE 1234

		
GROUP BY ohd.AccountNo

HAVING SUM(dtl.TransTotal) <> 0

ORDER BY dbo.LPad(RTRIM(ohd.AccountNo),19,'0')



USE GEMdb
GO

UPDATE dbo.RESETS

SET BadgeNo = d.badgeno

from (select a.accountno, b.badgeno from tblAccountOHD as a join tblBadgesOHD as b on a.AccountNo = b.AccountNo) as d, RESETS as c

where c.accountno = d.accountno