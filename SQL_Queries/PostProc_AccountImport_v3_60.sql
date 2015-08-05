USE [GEMdb]
GO

DECLARE	@return_value int

EXEC		@return_value = [dbo].[ie_AccountImport_v3_60]
		@Module = N'300'

SELECT		'Return Value' = @return_value

GO