--SEARCH tblXLAT FOR ALLERGEN
---------------------------------------------------------------------------------------------------
SELECT *
FROM
	tblXLAT
WHERE
	xlatID = 'modifierallergenid'
	AND KeyIn = '< allergen name >'

