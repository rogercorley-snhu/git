;WITH cte AS(

	SELECT R.RoomNumber, R.RoomID, ROW_NUMBER() OVER (PARTITION BY PV.RoomID ORDER BY R.RoomNumber) AS RN

	FROM 	dbo.tblPatientVisit AS PV
		JOIN dbo.tblRoomOHD AS R ON PV.RoomID = R.RoomID

	WHERE
		PV.DischargeDate IS NULL
		AND PV.RoomID IS NOT NULL
		AND R.RoomNumber NOT LIKE 'ER%'
	)

SELECT
	PV.PatientVisitID,
	P.MedicalRecordID,
	PV.EntryDate,
	PV.LastUpdateDate,
	PV.LastUpdateBy,
	P.FullName,
	R.RoomNumbe,
	PV.Bed,
	L.Description

FROM 	dbo.tblPatientVisit AS PV
	JOIN dbo.tblPatientOHD AS P ON PV.PatientID = P.PatientID
	JOIN dbo.tblRoomOHD AS R ON PV.RoomID = R.RoomID
	JOIN dbo.tblLocationClass AS L ON R.LocationClassID = L.LocationClassID
	--JOIN cte AS A ON PV.RoomID = A.RoomID

WHERE
	R.RoomID IN (SELECT DISTINCT(RoomID) FROM cte WHERE RN >1)
	AND PV.DischargeDate IS NULL

ORDER BY
	R.RoomNumber,
	PV.LastUpdateDate DESC

	--R.RoomNumber, PV.LastUpdateDate DESC
