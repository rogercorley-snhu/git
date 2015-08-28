IF EXISTS
	(
		select * from dbo.sysobjects
		where id = object_id(N'[dbo].[CreateAccountTTLsByClass]') and OBJECTPROPERTY(id, N'IsProcedure') = 1
	)

drop procedure [dbo].[ad_Create_TTL_Manually]

GO
SET QUOTED_IDENTIFIER ON

GO
SET ANSI_NULLS ON

GO


CREATE PROCEDURE dbo.CreateAccountTTLsByClass

@transClassID		int,
@AccountClassID	int = 0

AS

/*
Use this procedure to create new account TTLs for all accounts that do NOT already have the TTL specified (transClassID).
If you also pass the account class, only members of that class will get the new TTLs.
*/

If @AccountClassID > 0
Begin

	INSERT INTO	tblAccountTTL (AccountNo, TransClassID)
	SELECT 		AccountNo, @TransClassID
	FROM		tblAccountOHD
	WHERE		AccountNo NOT IN
	(
				SELECT AccountNo
				FROM tblAccountTTL
				WHERE TransClassID = @TransClassID) and AccountClassID = @AccountClassID
End
Else
Begin
	INSERT INTO	tblAccountTTL (AccountNo, TransClassID)
	SELECT 		AccountNo, @TransClassID
	FROM		tblAccountOHD
	WHERE		AccountNo NOT IN (
				SELECT AccountNo
				FROM tblAccountTTL
				WHERE TransClassID = @TransClassID
	)

End


GO

SET QUOTED_IDENTIFIER OFF

GO
SET ANSI_NULLS ON

GO

