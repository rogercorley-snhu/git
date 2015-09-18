--FIND DUPLICATE ACCOUNTNOs in tblACCOUNTIMPORT
--------------------------------------------------------------------------------------------------

SELECT
	 i.AccountNo
	, c.DupeCount

FROM tblAccountImport AS i
	INNER JOIN (

		SELECT
			accountno
			, COUNT(*) AS DupeCount
		FROM tblAccountImport

		GROUP BY AccountNo
		HAVING COUNT(*) > 1

	) c ON i.AccountNo = c.AccountNo