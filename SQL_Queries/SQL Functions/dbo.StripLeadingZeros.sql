--	IF ( @StripZeros = 1 )
--		BEGIN
--			UPDATE tblBadgesOHD
--			SET BadgeNo = CASE
--					WHEN LEFT( BadgeNo, 1 ) = '0' THEN dbo.StripLeadingZeros(BadgeNo)
--					ELSE BadgeNo
--		END
--	END



USE [GEMdb]
GO
/****** Object:  UserDefinedFunction [dbo].[StripLeadingZeros]    Script Date: 10/19/2015 10:57:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



ALTER  FUNCTION [dbo].[StripLeadingZeros] (@sString varchar(50))
RETURNS varchar(50)
AS
BEGIN
	WHILE LEFT(@sString,1) = '0'
	BEGIN
		SET @sString = RIGHT(RTRIM(@sString), LEN(RTRIM(@sString)) - 1)
	END

	RETURN @sString
END
