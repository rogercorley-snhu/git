USE [GEMdb];
GO

IF OBJECT_ID(N'GEMdb..PAYMENTS') IS NULL
	BEGIN
		PRINT '[ ERROR ] : The temporary table PAYMENTS does not exist.'
	END
ELSE
	BEGIN
		PRINT '[ IMPORT ] : The temporary table PAYMENTS exists.'
		PRINT '[ IMPORT ] : Importing table data from PAYMENTS tables INTO tblBatch.'


		INSERT INTO tblBatch ( BatchID, CoreID, AccountNo, TransDate, OutletNo, TransID, RefNum, ChkNum, TransTotal, Sales1, BadgeNo )

		SELECT  BatchID, CoreID, AccountNo, TransDate, OutletNo, TransID, RefNum, ChkNum, TransTotal, Sales1, BadgeNo
		FROM  PAYMENTS

		END

GO
