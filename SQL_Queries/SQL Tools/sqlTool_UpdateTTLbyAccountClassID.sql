
UPDATE	t1
SET		t1.< COLUMN > = < NEW VALUE >
FROM		tblAccountTTL AS t1
JOIN		tblAccountOHD AS a ON t1.AccountNo = a.AccountNo
WHERE		a.AccountClassID = < ACCOUNT CLASS ID >