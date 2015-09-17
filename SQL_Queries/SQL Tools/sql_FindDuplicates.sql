SELECT
	 i.AccountNo
	,c.dupeCount

FROM
	tblAccountImport AS i

INNER JOIN (

		SELECT AccountNo, COUNT(*) AS dupeCount
		FROM tblAccountImport
		GROUP BY AccountNo
		HAVING COUNT(*) > 1

	) c ON i.AccountNo = c.AccountNo