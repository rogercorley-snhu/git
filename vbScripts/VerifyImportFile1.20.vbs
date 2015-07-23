'==========================================================================================================================================
'  =====[[[ VerifyImportFile.vbs ]]]=====
'==========================================================================================================================================
'
'  Author: Richard Beverly
'  Date: 04-Jan-11
'..........................................................................................................................................
'
'   This software is protected under copyright law.  It is forbidden to copy use or distrubute this software without the express,
'     written, permission of Common CENTS Solutions.  No warranties are expressed or implied.  Use of this software is at the
'     risk of the user and Common CENTS Solutions is not libabe for any loss or damage resulting from its use.
'
'   ...................................................................................................................................
'   License to use this software is granted to the user having a valid, paid, software maintenance agreement in effect for a
'     qualifying GEM product.
'   ....................................................................................................................................
'
'   (c) Copyright 2015, Common CENTS Solutions, Inc -- All rights reserved
'
'==========================================================================================================================================
'  -----[[ Description ]]-----
'==========================================================================================================================================
'
'   This script runs verification checks on each field of an import file to verify the fields meet specific criteria.
'     Depending on the settings in the "Settings" area below, this script will create a "Good" import
'     file containing all rows whose fields passed the verifications and also create a "Bad" import file
'     containing only those rows for whom at least one field did NOT pass. If specified, the script will
'     add a new field to the end of all rows in the "Bad" file explaining which field failed and the reason.
'   ....................................................................................................................................
'
'   The "Config Array" variables should contain relevant values for each field (column) in the import file.
'     Each array element will correspond to the same ordinal field in each line (i.e. element 1 = field1, etc.).
'     In other words each array variable should have the same number of elements as the expected number of fields,
'     even if you aren't checking each field. Failure to do so will result in an early script termination.
'   ....................................................................................................................................
'
'   All Errors, including one that cause the script to halt execution, will be logged in the specified log
'     file unless a log file name isn't specified.
'
'------------------------------------------------------------------------------------------------------------------------------------------
'
'==========================================================================================================================================
'  -----[[ Developer Notes ]]-----
'==========================================================================================================================================
'
'    A developer can add new verifications to this script by adding functions to the verification functions section
'     and calls to those functions within the "RunLineVerifications" procedure and also a Constant or an array
'     varaible to define parameters for each field in each row. Inspect existing functions, calls and constants
'     to see how it is done.
'   '...................................................................................................................................
'
'   *NOTE 1: All verification functions should return a boolean specifying if ALL fields in the line pass verification.
'     Actually, If a field fails verification, the function should call the "ProcessLine" procedure, passing error info,
'     setting the function to return False and exiting the function. If all field checks pass, the function should return TRUE.
'   '...................................................................................................................................
'
'   *NOTE 2: Be sure to include calls to the "HandleError" and "ConfirmArrLen" subprocedures to properly handle unforseen problems
'
'
'==========================================================================================================================================
'  ----[[ Verifications performed in this script ]]----   (For specific info, see comments by each variable):
'==========================================================================================================================================
'
'------------------------------------------------------------------------------------------------------------------------------------------
'  Name       Config Array to use   Description
'------------------------------------------------------------------------------------------------------------------------------------------
'
'  * Minimum number of lines: none        There must be at least this number of lines in the file.
'                           **Use the MIN_NUMBER_OF_LINES constant to set this minimum
'..........................................................................................................................................
'  * Expected number of fields: none        Each line must have the specified number of fields
'..........................................................................................................................................
'  * Max Field Length:    MaxLengthArray      Length of each field in each line must be less than or equal to the specified
'               length as defined in the config array
'..........................................................................................................................................
'  * Min Field Length:    MinLengthArray      Length of each field in each line must be greater than or equal to the specified
'               length as defined in the config array
'..........................................................................................................................................
'  * Numeric Field Only:    NumericOnlyArray    Each field can be checked to be only numeric data or not checked.
'..........................................................................................................................................
'  * Must contain value:    MustContainValueArray   Each field can be compared to be one of several exact values (not case sensitive).
'..........................................................................................................................................
'  * Must NOT contain value:  MustNotContainValueArray  Each field can be compared to NOT be one of several exact values (not case sensitive).
'..........................................................................................................................................
'
'
'==========================================================================================================================================
'  ----[[ Revision History ]]----
'==========================================================================================================================================
'
'
'  Version 1.00   Initial Writing   04-Jan-11 Richard Beverly
'..........................................................................................................................................
'
'  Version 1.10         19-Feb-15 Richard Beverly
'..........................................................................................................................................
'  Feature:	The first version required that any test be fully defined for all fields, using some "do not test" value to bypass the test.
'		Now, if the test "Array" isn't defined (because it doesn't exist, or is commented out, the test will not run. Currently, this
'		is implemented in each test "Function", by returning the boolean value [True] if the expected config array isn't an array.
'		This means that the expected array should be an undefined, null, or non-existant variable. This also means that any custom
'		Functions need to implement this methodology, or the behavior will not work as intended. In fact, outside of this change to
'		each function, this version is identical to version 1.00.
'
'..........................................................................................................................................
'
'  Version 1.20         19-Mar-15 Richard Beverly
'..........................................................................................................................................
'  Feature:	A minimum number of lines must exist in the file, otherwise the Good file will be archived and a new "good file" will be
'		created as an empty file. Use the MIN_NUMBER_OF_LINES constant to set this minimum. This will always be evaluated, so set
'		a realistic value. That is, if you don't care to check set to a very low number. If you KNOW there will be at least (for instance)
'		1,500 employees in the file everytime, and it would be an incorrect file if it were less, then this number should be 1500
'		(do not use the comma thousands seperator)
'
'..........................................................................................................................................
'
'  Version 1.21         21-July-15 Roger Corley
'..........................................................................................................................................
'   ISSUE:   	When configuring the MinLengthArray array and running the script, it appears that the script is not using the MinLengthArray.
'
'   FIX:		In the subroutine, Sub RunLineVerifications, didn't contain a reference to MinLengthArray. When I added it and tested
' 		the script against a file with a known field under the MinLengthArray setting, the script added it to the BadRecords file and
'		removed it from the GoodRecords file. Submitted to QA for testing on 2015-07-21
'
'==========================================================================================================================================
'  ----[[ Array Variables to be used below ]]----
'==========================================================================================================================================

Dim MaxLengthArray
Dim MinLengthArray
Dim NumericOnlyArray
Dim MustContainValueArray
Dim MustNotContainValueArray
Dim fso
Dim Result
Dim InFile
Dim BadFile
Dim GoodFile
Dim ErrNum
Dim ErrText
Dim LineCount
Dim LineCountInvalid
Dim GoodFileBackup
'..........................................................................................................................................


LineCountInvalid = False
'..........................................................................................................................................


'.............................................
'some ado constants ** DO NOT CHANGE THESE **
'.............................................
Const FOR_READING = 1
Const FOR_APPENDING = 8


'==========================================================================================================================================
'  ----[[ START Script Settings ]]----
'==========================================================================================================================================

'............................................................................
'Change the following constants to values you need for your import file, etc.
'............................................................................

'............................................................................
	 Const FILE_DIRECTORY     = "F:\GEM\ImportExport"
'
'  DO NOT include a '\' at end. empty string means current dir
'............................................................................


	 Const INPUT_FILE_NAME    = "meds.csv"

	 Const BAD_FILE_NAME      = "_BadRecords\BadRecords-301-Meds.csv"

	 Const GOOD_FILE_NAME     = "_GoodRecords\GoodRecords-301-Meds.csv"

	 Const LOG_FILE_NAME      = "_Logs\ERROR_VerifyImport-301-Meds.log"

	 Const FIELD_DELIMITER    = ","

	 Const INCLUDE_EXPLAINATION_FIELD   = True

	 Const EXPECTED_NUMBER_OF_FIELDS    = 4

'............................................................................
	 Const MIN_NUMBER_OF_LINES    = 10
'
'  Must be set to a minimum number. if the number of lines in the file are
'  less than this, a backup is created and the "Good File" will be an empty
'  file that should be refused for import in the import sproc. The Bad File
'  will contain a line describing the failure
'............................................................................


'------------------------------------------------------------------------------------------------------------------------------------------
'  ----[ Test Config Arrays ]----
'------------------------------------------------------------------------------------------------------------------------------------------

'  * Uncomment (remove LEADING apostrophe) from each line of test arrays you
'    need to use.
'  * Add an apostrophe to the BEGINNING of any test array line that you do not
'    wish to test.
'  * Format: Array(value, value, value, value). A comma must separate each value.
'    No comma at the end of the value list.
'  * The number of values in the array must match the number of fields in each
'    line of the file
'  * Each array has a commented description at the end of the line.
'    i.e. '<-- comments... The apostrophe MUST be in front of the description,
'    or the script will error.
'  * String (text) values must be surrounded by double quotes ("my text")
'  * Boolean (true, false) values must be capitolized (True,False) and NOT
'    surrounded by quotes
'  * Numeric values must NOT be surrounded by quotes, unless the entire array is
'    intended to be text values
'------------------------------------------------------------------------------------------------------------------------------------------


'------------------------------------------------------------------------------------------------------------------------------------------
'  ----[[ BEGIN Test Config Arrays ]]----
'------------------------------------------------------------------------------------------------------------------------------------------

	MaxLengthArray  = Array(10, 5, 999, 999)      '<-- Numeric - to NOT test the max length,
												'    use a high number like 999
'............................................................................

	MinLengthArray  = Array(10, 4, 2, 2)        '<-- Numeric - to NOT test the min length,
												'    use 0 (the number zero)
'............................................................................

	NumericOnlyArray  = Array(False, True, False, False)    '<-- Boolean - True = Must contain only numeric
												'    characters, False = Don't test field
'............................................................................

	MustContainValueArray = Array("", "", "", "")       '<-- Text - provide empty string for fields not
									'    being tested, Pipe char as delimiter
									'    (i.e. "Employee|Department|Admin")
'............................................................................

	MustNotContainValueArray  = Array("", "", "", "")     '<-- Text - provide empty string for fields not
									'    being tested, Pipe char as delimiter


'==========================================================================================================================================
'  ----[[ END Script Settings ]]----
'==========================================================================================================================================


'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


'==========================================================================================================================================
'  ----[[ RUN Program ]]----
'==========================================================================================================================================

Main


'------------------------------------------------------------------------------------------------------------------------------------------
'  -----[ Verification Functions ]-----
'------------------------------------------------------------------------------------------------------------------------------------------

Function HasExpectedNumOfFields(NumFields, LineString)
	On Error Resume Next

	If NumFields <> EXPECTED_NUMBER_OF_FIELDS Then
		WriteLineToBadFile LineString,"ERR: Wrong Number Of Fields"
		HasExpectedNumOfFields = False
	Else
		HasExpectedNumOfFields = True
	End If

	HandleError "[Trying determine # of fields in a line from import file]", False
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function FieldMaxLength(FieldArray, LineString)
	On Error Resume Next

	FieldMaxLength = True
	If Not IsArray(MaxLengthArray) Then Exit Function

	ConfirmArrLen "MaxLengthArray", FieldArray, MaxLengthArray

	'loop through the fields and compare the same ordinal position in the requirements array
	For i = 0 To UBound(FieldArray)
		If Len(StripNonData(FieldArray(i))) > MaxLengthArray(i) Then
			WriteLineToBadFile LineString, "ERR: Max length - Field " & (i + 1)
			FieldMaxLength = False
			Exit Function
		End If
	Next

	HandleError "[Trying to test max length]", False
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function FieldMinLength(FieldArray, LineString)
	On Error Resume Next

	FieldMinLength = True
	If Not IsArray(MinLengthArray) Then Exit Function

	ConfirmArrLen "MaxLengthArray", FieldArray, MinLengthArray

	'loop through the fields and compare the same ordinal position in the requirements array
	For i = 0 To UBound(FieldArray)
		If Len(StripNonData(FieldArray(i))) < MinLengthArray(i) Then
			WriteLineToBadFile LineString, "ERR: Min length - Field " & (i + 1)
			FieldMinLength = False
			Exit Function
		End If
	Next

	HandleError "[Trying to test min length]", False
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function NumericOnly(FieldArray, LineString)
	On Error Resume Next

	NumericOnly = True
	If Not IsArray(NumericOnlyArray) Then Exit Function

	ConfirmArrLen "MaxLengthArray", FieldArray, NumericOnlyArray

	'........................................................................................
	'loop through the fields and compare the same ordinal position in the requirements array
	'........................................................................................
	For i = 0 To UBound(FieldArray)
		If NumericOnlyArray(i) Then
			If Not IsNumeric(StripNonData(FieldArray(i))) Then
				WriteLineToBadFile LineString, "ERR: Numeric Only - Field " & (i + 1)
				NumericOnly = False
				Exit Function
			End If
		End If
	Next

	HandleError "[Trying to test Numeric Only]", False
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function MustContainValue(FieldArray, LineString)
	On Error Resume Next

	MustContainValue = True
	If Not IsArray(MustContainValueArray) Then Exit Function

	ConfirmArrLen "MaxLengthArray", FieldArray, MustContainValueArray

	Dim ValsArray, s, InArray

	'........................................................................................
	'Loop through all fields
	'........................................................................................
	For i = 0 To UBound(FieldArray)

		'................................................................................
		'If a required values list is defined for this field, check it out
		'................................................................................
		If MustContainValueArray(i) <> "" Then
			ValsArray = Split(MustContainValueArray(i), "|")
			InArray = False

			'........................................................................
			'loop through the required values list to see if the field equals one of them
			'........................................................................
			For s = 0 To UBound(ValsArray)
				If UCase(StripNonData(FieldArray(i))) = UCase(ValsArray(s)) Then
					InArray = True
					Exit For
				End If
			Next

			'........................................................................
			'field was not in values list, so process the line and get out
			'........................................................................
			If Not InArray Then
				WriteLineToBadFile LineString, "ERR: Required Value - Field " & (i + 1)
				MustContainValue = False
				Exit Function
			End If
		End If
	Next

	HandleError "[Trying to test (must contain value)]", False
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function MustNotContainValue(FieldArray, LineString)
	On Error Resume Next

	MustNotContainValue = True
	If Not IsArray(MustNotContainValueArray) Then Exit Function

	ConfirmArrLen "MaxLengthArray", FieldArray, MustNotContainValueArray

	Dim ValsArray, s, NotInArray

	'........................................................................................
	'Loop through all fields
	'........................................................................................
	For i = 0 To UBound(FieldArray)
		'If a required values list is defined for this field, check it out
		If MustNotContainValueArray(i) <> "" Then
			ValsArray = Split(MustNotContainValueArray(i), "|")
			NotInArray = True

			'........................................................................
			'loop through the values list to see if the field equals one of them,
			'if so, the test fails, no point in going further.
			'........................................................................
			For s = 0 To UBound(ValsArray)
				If UCase(StripNonData(FieldArray(i))) = UCase(ValsArray(s)) Then
					NotInArray = False
					Exit For
				End If
			Next

			'........................................................................
			'field was not in values list, so process the line and get out
			'........................................................................
			If Not NotInArray Then
				WriteLineToBadFile LineString, "ERR: Not approved value - Field " & (i + 1)
				MustNotContainValue = False
				Exit Function
			End If
		End If
	Next

	HandleError "[Trying to test (must not contain value)]", False
End Function


'------------------------------------------------------------------------------------------------------------------------------------------
'  ----[[ Program Routines ]]----
'------------------------------------------------------------------------------------------------------------------------------------------

'........................................................................................
'Add any calls to new verification functions to this procedure ONLY.
'........................................................................................
Sub RunLineVerifications(InputLine)
	On Error Resume Next

	Dim FieldArray, i, ErrText
	FieldArray = Split(InputLine, FIELD_DELIMITER)
	HandleError "[Trying split a line from import file]", False

	'........................................................................................
	'If any function returns false, it means a field failed verification. In this case the Function
	'will write the invalid line to the "bad" file and this line should be considered done, so leave the procedure.
	'........................................................................................
	If Not HasExpectedNumOfFields(UBound(FieldArray) + 1, InputLine) Then Exit Sub
	If Not FieldMaxLength(FieldArray, InputLine) Then Exit Sub
	If Not FieldMinLength(FieldArray, InputLine) Then Exit Sub
	If Not NumericOnly(FieldArray, InputLine) Then Exit Sub
	If Not MustContainValue(FieldArray, InputLine) Then Exit Sub
	If Not MustNotContainValue(FieldArray, InputLine) Then Exit Sub

	HandleError "[Running Line Verifications]", True

	'........................................................................................
	'if ALL fields passed verification on this line, write this line to the "good" file
	'........................................................................................
	WriteLineToGoodFile InputLine
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub WriteLineToGoodFile(InputLine)
	On Error Resume Next

	If GOOD_FILE_NAME <> "" Then
		If Not IsObject(GoodFile) Then
			Set GoodFile = fso.CreateTextFile(GetFilePath(GOOD_FILE_NAME), True)
			HandleError "[Trying to create good file]", True
		End If

		GoodFile.WriteLine(InputLine)
		HandleError "[Trying to write a line to the good file]", True
	End If
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub WriteLineToBadFile(InputLine, ErrorFieldText)
	On Error Resume Next

	If BAD_FILE_NAME <> "" Then
		Dim e

		If Not IsObject(BadFile) Then
			Set BadFile = fso.CreateTextFile(GetFilePath(BAD_FILE_NAME), True)
			HandleError "[Trying to create bad file]", True
		End If

		'........................................................................................
		'if specified, add a field to the end of the line containing the error desc
		'........................................................................................
		e = iif(INCLUDE_EXPLAINATION_FIELD, FIELD_DELIMITER & ErrorFieldText, "")

		BadFile.WriteLine(InputLine & e)
		HandleError "[Trying to write a line to the good file]", True
	End If
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Function iif(ConditionBool, TrueRtnVal, FalseRtnVal)
	If ConditionBool Then
		iif = TrueRtnVal
	Else
		iif = FalseRtnVal
	End If
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function GetFilePath(FileName)
	GetFilePath = iif(FILE_DIRECTORY = "", ".", FILE_DIRECTORY) & "\" & FileName
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function GetRenamedFileName(OldName, RevisionText)
	Dim BaseName
	BaseName = fso.GetBaseName(OldName)
	GetRenamedFileName = BaseName & RevisionText & "." & fso.GetExtensionName(OldName)
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Function StripNonData(val)
	Dim rtn
	rtn = Trim(val)
	rtn = iif(Left(rtn,1) = Chr(34), Right(rtn, Len(rtn) -1), rtn)
	rtn = iif(Right(rtn,1) = Chr(34), Left(rtn, Len(rtn) -1), rtn)
	StripNonData = rtn
End Function
'------------------------------------------------------------------------------------------------------------------------------------------

Sub HandleError(PlaceID, bLogAndQuit)

	'........................................................................................
	'only handle error if this is truly an error
	'........................................................................................
	If Err.Number <> 0 Then
		LOGIT_EX PlaceID, "", bLogAndQuit

		If bLogAndQuit Then
			WScript.Quit
		End If
	End If
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub LOGIT_EX(PlaceID, sMsg, bAppWillQuit)
	Dim ID, sQuitting

	If bAppWillQuit Then
		sQuitting = vbCrLf & "** Script execution halted **"
	Else
		sQuitting = ""
	End If

	If PlaceID <> "" Then
		ID = "Error happened: " & PlaceID
	End If

	If LOG_FILE_NAME <> "" Then

		'........................................................................................
		'if msg is not empty, only write the msg, else write error info
		'........................................................................................
		If sMsg <> "" Then
			LogFile GetFilePath(LOG_FILE_NAME), ID & sMsg & sQuitting, False
		Else
			LogFile GetFilePath(LOG_FILE_NAME), ID & sMsg & sQuitting, False
		End If
	Else
		Wscript.Echo "Logging turned off. Info not logged: " & sMsg
	End If
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub LogFile(FileName, AdditionalInfo, owrt)
	Dim subFSO, lgFileOpen, o, ErrDescr, ErrNum

'"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
'  This procedure will create a new log file or append to an existing log file. The parameters passed should be
'...................................................................................................................
'
'  * FileName   - The FULL path and name of log file to be created or appended ie. "C:\GEM\Log\MyLogfile.txt"
'  * AdditionalInfo - Pass any other text you wish to log or pass an empty string ("")
'  * owrt   - If true, overwrites file each call
'"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

ErrDescr = Err.Description
ErrNum = Err.Number
Err.Clear

On Error Resume next

	set subFSO = Wscript.CreateObject("Scripting.FileSystemObject")

	If not subFSO.FileExists(FileName) then
		subFSO.CreateTextFile(FileName)
	End If

	If owrt = True then ' Set overwrite bit
		o = 2
	Else
		o = 8
	End If

	Err.Clear

	set lgFileOpen = subFSO.OpenTextFile(FileName,o)

	If Err.Number<> 0 Then
		WScript.Echo "Cannot open Log File: " & FileName
		Exit Sub
	End If

	lgFileOpen.WriteLine(Date & " @ " & Time)

	'........................................................................................
	'if there was an error writting to the logfile:
	'........................................................................................
	If Err.Number <> 0 Then
		WScript.Echo "Error writing message to logfile. Message: " & ErrDescr
		WScript.Echo AdditionalInfo
		Exit Sub
	End If

	'........................................................................................
	'If the original error number isn't 0, write error info to log file.
	'........................................................................................
	If ErrNum <> 0 Then
		lgFileOpen.WriteLine("Script Error Info: [" & ErrNum & "] " & ErrDescr)
	End If

	'........................................................................................
	' Use this parameter for additional info
	'........................................................................................
	If AdditionalInfo = "" Then
		If owrt <> True Then  ' Only write dashed line if file is to be appended to
			lgFileOpen.WriteLine("-------------------------------------------")
		End If
	Else
		lgFileOpen.WriteLine(AdditionalInfo)

		If owrt <> True Then
			lgFileOpen.WriteLine("-------------------------------------------")
		End If
	End If

	lgFileOpen.Close
	Set subFSO = Nothing
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub wrt(msg)
	Wscript.Echo msg
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub ConfirmArrLen(PlaceId, FieldArray, ConfigArray)
	If UBound(FieldArray) > UBound(ConfigArray) Then
		LOGIT_EX PlaceId, " doesn't have enough elements", True
		Wscript.Quit
	End If
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------

Sub Main()
	On Error Resume Next
	Dim line

	Set fso = createobject("Scripting.FileSystemObject")
	HandleError "[Trying to create File System Object]", True

	'........................................................................................
	'don't worry about catching errors when deleting, these files may not exist and
	'a thrown error is ok in that case.
	'........................................................................................
	fso.DeleteFile(GetFilePath(BAD_FILE_NAME))
	fso.DeleteFile(GetFilePath(GOOD_FILE_NAME))
	Err.Clear

	Set InFile = fso.OpenTextFile(GetFilePath(INPUT_FILE_NAME), FOR_READING)
	HandleError "[Trying to get input file]", True

	Do While Not InFile.AtEndOfStream
		line = InFile.ReadLine
		HandleError "[Trying to read a line from the input file]", True

		RunLineVerifications line
		LineCount = LineCount + 1
	Loop

	InFile.Close
	HandleError "[Trying to close the input file]", False
	Set InFile = Nothing

	If LineCount < MIN_NUMBER_OF_LINES Then
		WriteLineToBadFile "Number of lines in file less that minimum.", "ERR: Min Lines Enforced: " & MIN_NUMBER_OF_LINES & " - Lines in file: " & LineCount
		LineCountInvalid = True
	End If

	If IsObject(GoodFile) Then
		GoodFile.Close
		HandleError "[Trying to close the good file]", False
		Set GoodFile = Nothing

		If LineCountInvalid Then

			'........................................................................................
			'rename the new processed file to invalid, so there is a backup of the original
			'........................................................................................
			fso.MoveFile GOOD_FILE_NAME, GetRenamedFileName(GOOD_FILE_NAME, "_INVALID")
			HandleError "[Trying to rename the goodfile]", False

			'........................................................................................
			'only continue if the file was successfully renamed
			'........................................................................................
			If Not fso.FileExists(GOOD_FILE_NAME) Then
				'create an empty Good File
				Set GoodFileBackup = fso.CreateTextFile(GOOD_FILE_NAME, True)
				GoodFileBackup.Close
				Set GoodFile = Nothing
			End If
		End If
	End If

	If IsObject(BadFile) Then
		BadFile.Close
		HandleError "[Trying to close the bad file]", False
		Set BadFile = Nothing
	End If

End Sub
'------------------------------------------------------------------------------------------------------------------------------------------
'==========================================================================================================================================
'  ----[[ END Program ]]----
'==========================================================================================================================================

'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


