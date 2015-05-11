USE [GEMdb];
GO

IF OBJECT_ID(N'GEMdb..PAYMENTS') IS NULL
	BEGIN
		PRINT '[ ERROR ] : The temporary table PAYMENTS does not exist.'
	END
ELSE
	BEGIN
		PRINT '[ IMPORT ] : The temporary table PAYMENTS exists.'
		PRINT '[ IMPORT ] : Importing table data from PAYMENTS tables INTO BTEST.'

CREATE TABLE BTEST (
	 BatchID char(10)
	,CoreID int
	,AccountNo char(19)
	,TransDate datetime
	,OutletNo int
	,TransID int
	,RefNum char(6)
	,ChkNum char(6)
	,TransTotal money
	,Sales1 money
	,BadgeNo char(19)
	)

	INSERT INTO BTEST ( BatchID, CoreID, AccountNo, TransDate, OutletNo, TransID, RefNum, ChkNum, TransTotal, Sales1, BadgeNo )

	SELECT  BatchID, CoreID, AccountNo, TransDate, OutletNo, TransID, RefNum, ChkNum, TransTotal, Sales1, BadgeNo
	FROM  PAYMENTS

	END

GO
