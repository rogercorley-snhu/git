--FIND DIETS
---------------------------------------------------------------------------------------------------
SELECT *
FROM
	tblPatientDiet AS pd
		JOIN tblDietOHD AS d ON pd.DietID = d.DietID

WHERE
	pd.PatientVisitID = 'H00032993478'

ORDER BY
	pd.ActiveDate DESC
	, pd.PostDate DESC