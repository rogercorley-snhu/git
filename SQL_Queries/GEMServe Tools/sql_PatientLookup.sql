USE GEMserve4
-- USE GEMserve3

GO


DECLARE @PatientVisitID  varchar(50),
  @PatientID   int,
  @IncludeDiet  bit,
  @IncludePatientNotes bit,
  @IncludePatientAllergens bit,
  @IncludeOrderInfo bit,
  @IncludePatientLog bit

 SET @PatientVisitID = 'Y25002601818'
 SET @IncludeDiet = 0
 SET @IncludePatientNotes = 0
 SET @IncludePatientAllergens = 0
 SET @IncludeOrderInfo = 0
 SET @IncludePatientLog = 1

 IF (@PatientVisitID = '')
  GOTO Finish

 --Get the Patient ID
 SELECT @PatientID = PatientID
 FROM dbo.tblPatientVisit
 WHERE PatientVisitID = @PatientVisitID

 --Get the Patient Information
 SELECT PV.PatientVisitID,
   PV.PatientID,
   PC.Description AS PatientClass,
   P.MedicalRecordID,
   P.FullName,
   R.RoomNumber,
   PV.Bed,
   R2.RoomNumber AS PreviousRoom,
   PV.PreviousBed,
   PV.EntryDate,
   PV.DischargeDate,
   P.Notes
 FROM dbo.tblPatientVisit AS PV
 JOIN dbo.tblPatientOHD AS P ON PV.PatientID = P.PatientID
 JOIN dbo.tblRoomOHD AS R ON PV.RoomID = R.RoomID
 JOIN dbo.tblPatientClass AS PC ON PV.PatientClassID = PC.PatientClassID
 LEFT JOIN dbo.tblRoomOHD AS R2 ON PV.PreviousRoomID = R2.RoomID
 WHERE PV.PatientVisitID = @PatientVisitID

 IF (@@ROWCOUNT = 0)
  GOTO Finish

 --Get the diet information
 IF (@IncludeDiet = 1)
  SELECT D.DietID, D.Description, PD.*
  FROM dbo.tblPatientDiet AS PD
  JOIN dbo.tblDietOHD AS D ON PD.DietID = D.DietID
  WHERE PD.PatientVisitID = @PatientVisitID
  ORDER BY PD.ActiveDate DESC, PD.PostDate DESC

 IF (@IncludePatientNotes = 1)
  SELECT * FROM dbo.tblPatientNotes
  WHERE PatientVisitID = @PatientVisitID
  ORDER BY ActiveDate DESC, PostDate DESC

 --Get the patient allergens
 IF (@IncludePatientAllergens = 1)
  SELECT PA.AllergenID, A.Description AS Allergy
  FROM dbo.tblPatientAllergens AS PA
  JOIN dbo.cfgAllergens AS A ON PA.AllergenID = A.AllergenID
  WHERE PatientID = @PatientID

 --Get the order information
 IF (@IncludeOrderInfo = 1)
  SELECT *
  FROM dbo.tblOrderOHD
  WHERE PatientVisitID = @PatientVisitID
  ORDER BY OrderID DESC

 IF (@IncludePatientLog = 1)
 BEGIN
  SELECT *
  FROM dbo.tblPatientLog
  WHERE PatientID = @PatientID
  ORDER BY Date DESC
 END

 Finish: