'GEM Version 0.0.40
'        Title: Import_v1_70.gsf
'       OnMenu: NO
'     Security: Add=0, Edit=0, View=0, Delete=0
'       Author: rbishop, Version=1.00
'  Last Update: 1/19/2004 4:47:07 AM, Editor=rbishop, Revision=214
'
'	Changes: 
'			*	Surrounded the code that processes each line of the input file
'				with an "IF" statement to prevent processing empty lines - RBeverly - 4-18-2006
'===========================================================================

'*************
'Include files
'*************
@@##scriptdirectory##Quotes.gsf
@@##scriptdirectory##ADOInit.gsf

'***********
'Script code
'***********
Sub Main()
    Dim cnGem, cdGem, sSQLString, sPutAway
    Dim sTemp, oFileSystem, oFile, sArray, ImportFile
    Dim sImportView, iDelimiter, iFieldType
    Dim sIFields, sFields, sVFields, sVueFields
    Dim sModule

    Const ForReading = 1, ForWriting=2, ForAppending=8, adOpenDynamic = 2, adLockOptimistic = 3, adCmdText = 1, adInteger = 3, adParamInput = 1, adVarChar = 200

    sModule = "##module##"
    ImportFile = "##impexpdirectory##" & "##importfile##"
    sImportView = "##importview##"
    iDelimiter = ##importdelimiter##
    sPutAway = "##importpostproc##"
    
'****************************************************************************
    'Get the import fields and the key fields
    'The retrieved values are the field numbers to import in comma-delimited format
    
'****************************************************************************
    sIFields = "##importfields##"
    sD = Chr(iDelimiter)
    sFields = Split(sIFields, ",")
    sVFields = "##importvuefields##"
    sVueFields = Split(sVFields, ",")

    '*******************************************
    'Create ADO objects & open the DB connection
    '*******************************************
    Set cdGem = CreateObject("ADODB.Command")
    Set rsGem = CreateObject("ADODB.Recordset")

    cdGem.ActiveConnection = InitADO

    sSQLString = "SELECT * FROM " & sImportView

    rsGem.Open sSQLString, InitADO, adOpenDynamic, adLockOptimistic, adCmdText

    '********************
    'Open the import file
    '********************
    Set oFileSystem = CreateObject("Scripting.FileSystemObject")
    Set oFile = oFileSystem.OpenTextFile(ImportFile,ForReading)

    '******************
    'Get data to import
    '******************
    Do While Not oFile.AtEndofStream

        sTemp = oFile.ReadLine
		'don't attempt to read blank lines
		If sTemp <> "" Then
		   ' Remove Single quotes from our source line...
			sTemp = Replace( sTemp , "'" , " ")
	
			sArray = SplitLine(sTemp, ",")
	
			rsGem.AddNew
	
			'***********************************
			'Update the fields and the recordset
			'***********************************
			On Error Resume Next
	
			For iCount = 0 to UBound(sFields)
			If sArray(eval(sFields(iCount))) <> "" Then
					iFieldType = rsGem.Fields(eval(sVueFields(iCount))).Type
	
					If iFieldType = adInteger Then
						If sArray(eval(sFields(iCount))) = "" Then
							rsGem.Fields(eval(sVueFields(iCount))).Value = 0
						Else
							rsGem.Fields(eval(sVueFields(iCount))).Value = StripQuotes(sArray(eval(sFields(iCount))))
						End If
					Else
	'msgbox iCount & "-" & rsGem.Fields(eval(sVueFields(iCount))).Name & "=" & rsGem.Fields(eval(svueFields(iCount))).Value
	'msgbox StripQuotes(sArray(eval(sFields(iCount))))
						rsGem.Fields(eval(sVueFields(iCount))).Value = StripQuotes(sArray(eval(sFields(iCount))))
					End If
	'msgbox iCount & "-" & rsGem.Fields(eval(sVueFields(iCount))).Name & "=" & rsGem.Fields(eval(svueFields(iCount))).Value
			End If
	
			Next
			If Err.Number = 0 Then
				rsGem.Update
		End If
			Err.Clear
		End If						
    Loop

    oFile.Close

    Set oFile=Nothing
    Set oFileSystem=Nothing

    '***********************************************
    'NOTE: This function puts away all imported
    'items in the tblAccountImport table
    '***********************************************
'msgbox sPutAway

  If sPutAway <> "" Then
       With cdGem
            .CommandType = 4
            .CommandText = Chr(34) & sPutAway & Chr(34)
            .Parameters.Append .CreateParameter("@Module", adVarChar,adParamInput, 100, sModule)

           .Execute
        End With
    End If

    Set cdGem=Nothing
End Sub

'Remove commas
Function SplitLine(Temp, sDelimiter)
    Dim iCount, iFound, iStart, sTemp, sTempArray(50)

    iStart = 1
    Do
        iFound = InStr(iStart, Temp, sDelimiter)
        If iFound > 0 Then
            sTemp = Mid(Temp, iStart, iFound - iStart)
            iStart = iFound + 1
            If Left(sTemp, 1) = Chr(34) And Right(sTemp, 1) <> Chr(34) Then
                iFound = InStr(iStart, Temp, sDelimiter)
                If iFound > 0 Then
                    sTemp = sTemp & sDelimiter & Mid(Temp, iStart, iFound - iStart)
                    iStart = iFound + 1
                Else
                    sTemp = sTemp & sDelimiter & Mid(Temp, iStart, Len(Temp) - iStart + 1)
                    sTempArray(iCount) = StripQuotes(sTemp)
                    Exit Do
                End If
            End If
        Else
            sTemp = Mid(Temp, iStart, Len(Temp) - iStart + 1)
            sTempArray(iCount) = StripQuotes(sTemp)
            Exit Do
        End If
        sTempArray(iCount) = StripQuotes(sTemp)
        iCount = iCount + 1
        sTemp = ""
    Loop
    SplitLine=sTempArray
End Function












