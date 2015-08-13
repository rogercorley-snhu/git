DECLARE @PatientVisitID  varchar(50),
  @PatientID   int,
  @IncludeDiet  bit,
  @IncludePatientNotes bit,
  @IncludeOrderInfo bit,
  @IncludePatientLog  bit

 SET @PatientVisitID = '11693552'
 SET @IncludeDiet = 1
 SET @IncludePatientNotes = 1
 SET @IncludeOrderInfo = 1
 SET @IncludePatientLog = 1

 IF (@PatientVisitID = '')
  GOTO Finish

 --Get the Patient Information
 SELECT PV.PatientVisitID,
   PV.PatientID,
   PC.Description AS PatientClass,
   P.MedicalRecordID,
   P.FullName,
   R.RoomNumber,
   PV.Bed,
   PV.EntryDate,
   PV.DischargeDate,
   P.Notes
 FROM dbo.tblPatientVisit AS PV
 JOIN dbo.tblPatientOHD AS P ON PV.PatientID = P.PatientID
 JOIN dbo.tblRoomOHD AS R ON PV.RoomID = R.RoomID
 JOIN dbo.tblPatientClass AS PC ON PV.PatientClassID = PC.PatientClassID
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

 --Get the order information
 IF (@IncludeOrderInfo = 1)
  SELECT *
  FROM dbo.tblOrderOHD
  WHERE PatientVisitID = @PatientVisitID
  ORDER BY OrderID DESC

 IF (@IncludePatientLog = 1)
 BEGIN
  SELECT @PatientID = PatientID
  FROM dbo.tblPatientVisit
  WHERE PatientVisitID = @PatientVisitID

  SELECT *
  FROM dbo.tblPatientLog
  WHERE PatientID = @PatientID
  ORDER BY Date DESC
 END


 Finish: