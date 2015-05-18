
#=========================================================================================================
#-------[ TITLE     ] : POWERSHELL : MASTER : Import Employee Demographic File
#=========================================================================================================
#
#-------[ AUTHOR    ] : Roger Corley
#-------[ CREATED   ] : May 15, 2015 10:23:31 AM
#-------[ COPYRIGHT ] : Common CENTS Solutions - 2015
#
#---------------------------------------------------------------------------------------------------------


#=========================================================================================================
#-------[ DESCRIPTION ]
#=========================================================================================================
#
#  A PowerShell script created to import an employee demographic .CSV file and its objects intto a .TMP.CSV file
#  In the process of creating the new file, this script will strip the header row and any trailing spaces.
#  The script will create an object array to store each record's values and create an OutTXT string for each 
#  record. A new "employee.txt" will be created and each row's string will be added to that file. The old  
#  "employee.csv" file will be removed and "employee.txt" will be converted to "employee.csv" From there,
#  "RunScript.exe" will execute with the arguments assigned by the user. All employees will be imported 
#  into dbo.GEMdb.tblAccountImport and processed by SQL into GEMpay.


#-------[ VARIABLES ] : Path and File Names
#---------------------------------------------------------------------------------------------------------
	$dirGEMIE = "D:\GEM\ImportExport\"
	$dirIMPEM = "D:\GEM\ImportExport\Archive\ImportEmployees\"
	$dirORGIN = "D:\GEM\ImportExport\Archive\ImportEmployees\OrginalEmpFiles\"

	$fileIE = "employee.csv"
	$tempIE = "employee.tmp.csv"
	$textIE = "employee.txt"
	$fileLOG = "Import-Employee.log"

	$impExt = "*.csv"


#-------[ VARIABLES ] : Header Names
#---------------------------------------------------------------------------------------------------------

	$h0 = "EMPNO"
	$h1 = "LAST_NAME"
	$h2 = "FIRST_NAME"
	$h3 = "HID"
# 	$h4 = ""
# 	$h5 = ""
# 	$h6 = ""


#-------[ VARIABLES ] : RunScript Arguments
#---------------------------------------------------------------------------------------------------------

	$rsScript = "Import_v1_70.gsf"
	$rsPw = "gemie"
	$rsSvr = "ok1568pcidb"
	$rsCore = "1"
	$rsModule = "170"
	$rsInclude = "gsf.txt"




##########################################################################################################
#---------------------------------------------------------------------------------------------------------
#
#   ---{{{  *** DO NOT MODIFY SCRIPT BEYOND THIS POINT ***  }}}---
#
#---------------------------------------------------------------------------------------------------------
##########################################################################################################






#-------[ CONSTANTS ] : Full Path Names     
#---------------------------------------------------------------------------------------------------------

	$pathIPIE = $dirGEMIE + $fileIE
	$pathTEMP = $dirGEMIE + $tempIE
	$pathTEXT = $dirGEMIE + $textIE

	$impLOG = $dirIMPEM + $fileLOG


#-------[ CONSTANTS ] : Date Calculations
#---------------------------------------------------------------------------------------------------------

	$now = Get-Date
	$logNow = Get-Date -format "yyyy-MM-dd HH:mm:ss"
	$archNow = Get-Date -format "yyyy-MM-dd"
	$keepDays = 30
	$lastWrite = $now.AddDays(-$keepDays)


#-------[ CONSTANTS ] : Full Path Name : RunScript.exe
#---------------------------------------------------------------------------------------------------------

	$rs = "D:\GEM\runscript.exe"
	$rsArg = "script=$rsScript,pw=$rsPw,svr=$rsSvr,core=$rsCore,module=$rsModule,include=$rsInclude"



#---------------------------------------------------------------------------------------------------------
#-------[  BEGIN SCRIPT  ]--------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
	
	clear

	ac -Path $impLOG " "
	ac -Path $impLOG "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	ac -Path $impLOG "==============================================================================="
			ac -Path $impLOG "$lognow : [ BEGIN ] : Import Employee Demographic File"
	ac -Path $impLOG "==============================================================================="
	ac -Path $impLOG "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	ac -Path $impLOG " "
	

#-------[ Test-Path: Employee.csv = $true ]-------------------------------------
#...............................................................................

	if ( Test-Path $pathIPIE ) {

		ac -Path $impLOG "..............................................................................."
			ac -Path $impLOG "$lognow : [ TEST ] : $fileIE exists. Testing path for $tempIE."


#-------[ Test-Path : Employee.tmp.csv = $true ]--------------------------------
#...............................................................................

	if ( Test-Path $pathTEMP ) {

			ac -Path $impLOG "$lognow : [ TEST ] : $tempIE exists. Deleting old file."

		rd $pathTEMP

	} #-----END Test-Path Employee.tmp.csv


#-------[ Test-Path : Employee.txt = $true ]------------------------------------
#...............................................................................

	if ( Test-Path $pathTEXT ) {
		ac -Path $impLOG " "
			ac -Path $impLOG "$lognow : [ TEST ] : $pathTEXT exists. Deleting old file."
		ac -Path $impLOG " "

		rd $pathTEXT | Out-Null

	} #-----END Test-Path  Employee.txt

	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$lognow : [ SCRIPT ] : Starting import script processes."
	ac -Path $impLOG "-------------------------------------------------------------------------------"

	ni $pathTEXT -type file

		ac -Path $impLOG "$lognow : [ FILE ] : $pathTEXT created."

	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$logNow : [ TASK ] : Removing trailing whitespace from objects."
	ac -Path $impLOG "-------------------------------------------------------------------------------"

	ipcsv $pathIPIE | 
	Convertto-Csv -NoTypeInformation | 
	% { $_ -replace ' *",', '",'} | 
	Out-File $pathTEMP -fo -en ascii


#-------[ Import-Csv : $pathTEMP ]----------------------------------------------
#...............................................................................

		ac -Path $impLOG "$logNow : [ CSV ] : Importing .CSV file."
	ac -Path $impLOG "-------------------------------------------------------------------------------"

	$csvTMP = ipcsv $pathTEMP


#-------[ Loop : Create myObj Object Array ]------------------------------------
#...............................................................................

	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$logNow : [ ARRAY ] : Creating Object Array."
		ac -Path $impLOG "$logNow : [ ARRAY ] : Creating Object String."

	% ($row in $csvTMP) {

		#Construct Object Array
		#-----------------------------------
		$myObj = "" | Select EMPNO,LAST_NAME,FIRST_NAME,HID

		#Fill Object Array
		#-----------------------------------
		$myObj.EMPNO = $row.EMPNO
		$myObj.LAST_NAME = $row.LAST_NAME
		$myObj.FIRST_NAME = $row.FIRST_NAME
		$myObj.HID = $row.HID

		#Add Object to the array
		$outTXT = "{0},{1},{2},{3}" -f $myObj.EMPNO,$myObj.LAST_NAME,$myObj.FIRST_NAME,$myObj.HID

		$outTXT | ac $pathTEXT

	} # end foreach Loop : myObj

	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$logNow : [ CONTENT ] : Adding records to .TXT file."
		ac -Path $impLOG "$logNow : [ CONVERT ] : Converting .TXT file to .CSV file."
	ac -Path $impLOG " "

	Convertto-Csv -inputobject $pathTEXT -delimiter "," -notypeinformation -fo -en ascii


#-------[ Rename Files ]--------------------------------------------------------
#...............................................................................


	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$logNow : [ CLEANUP ] : Cleaning up temporary files."
	ac -Path $impLOG "-------------------------------------------------------------------------------"
	ac -Path $impLOG " "

	$orgItem = "{0}{1}.{2}.csv" -f $dirORGIN,$fileIE,$archNow
	mv -path $pathIPIE -destination $orgItem

	ren -Path $pathTEXT -NewName $pathIPIE
	rd $pathTEMP | Out-Null


#-------[ RunScript ]-----------------------------------------------------------
#...............................................................................

	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$logNow : [ RUNSCRIPT ] : Starting RunScript.exe"

	& $rs $rsArg

		ac -Path $impLOG "$logNow : [ RUNSCRIPT ] : Import completed."
	ac -Path $impLOG "-------------------------------------------------------------------------------"
	ac -Path $impLOG " "

	

#-------[ Archive Clean Up ]----------------------------------------------------
#...............................................................................

	$files = gci $dirIMPEM -Include $impExt -Recurse | 
		? {$_.lastWriteTime -le "$lastWrite"}

	% ($file in $files) {
		if ($file -ne $NULL) {

			ac -Path $impLOG "==============================================================================="
			ac -Path $impLOG "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
			ac -Path $impLOG " "
				ac -Path $impLOG "$logNow : [ CLEANUP ] : $file is older than $keepDays days."
				ac -Path $impLOG "$logNow : [ CLEANUP ] : $file has been deleted."
			ac -Path $impLOG " "
			ac -Path $impLOG "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
			ac -Path $impLOG "==============================================================================="

			rm $file.FullName | Out-Null
		}

		else {
			ac -Path $impLOG " "
			ac -Path $impLOG "==============================================================================="
			ac -Path $impLOG " "
				ac -Path $impLOG "$logNow : [ CLEANUP ] : All files are less than $keepDays days old."
				ac -Path $impLOG "$logNow : [ CLEANUP ] : No files to delete!"
			ac -Path $impLOG " "
			ac -Path $impLOG "==============================================================================="
			ac -Path $impLOG " "
		}
	}



#-------[ Archive Import File ]-------------------------------------------------
#...............................................................................
	
	ac -Path $impLOG "-------------------------------------------------------------------------------"
		ac -Path $impLOG "$logNow : [ ARCHIVE ] : Moving $fileIE to $dirIMPEM."
	ac -Path $impLOG " "

	$archItem = "{0}{1}.{2}.csv" -f $dirIMPEM,$fileIE,$archNow

	mv -path $pathIPIE -destination $archItem
	
		ac -Path $impLOG "$logNow : [ ARCHIVE ] : $fileIE archive completed."
	ac -Path $impLOG "-------------------------------------------------------------------------------"
	ac -Path $impLOG " "
	
#-------[ END SCRIPT ]----------------------------------------------------------
#...............................................................................

	ac -Path $impLOG " "
	ac -Path $impLOG "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	ac -Path $impLOG "==============================================================================="
		ac -Path $impLOG "$lognow : [ END ] : Import Employee Demographic File"
	ac -Path $impLOG "==============================================================================="
	ac -Path $impLOG "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	ac -Path $impLOG " "

	} #----- end Test-Path $fileIE = $true


#-------[ Else : Test-Path $false ]---------------------------------------------
#...............................................................................

	else {
	
		#Ending Script
		#...............................................................
		ac -Path $impLOG "==============================================================================="
		ac -Path $impLOG "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		ac -Path $impLOG " "
			ac -Path $impLOG "$logNow : [ ERROR ] : $fileIE does not exist. Closing script."
		ac -Path $impLOG " "
		ac -Path $impLOG "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
		ac -Path $impLOG "==============================================================================="


	} #----- end Test-Path $fileIE = $false


#---------------------------------------------------------------------------------------------------------
#-------[ END SCRIPT ]------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
