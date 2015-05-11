USE [GEMdb];
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
