	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION


	echo Going to import the master file, ready...

	C:\GEM\runscript script=Import_v1_70.gsf,pw=gemie,svr=(local),core=1,module=300,include=gsf.txt



::===========================================================================================================
::-------[ ENVIRONMENT VARIABLES ] : Directories
::===========================================================================================================

	SET "originD=C:\GEM\ImportExport"
	SET "targetD=C:\GEM\ImportExport\Archive\Import-Employees-Archives"



::===========================================================================================================
::-------[ ****  DATE CONSTANTS : DO NOT MODIFY  ****  ]
::===========================================================================================================

	for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set "dt=%%a"

	set "YYYY=%dt:~0,4%"
	set "MM=%dt:~4,2%"
	set "DD=%dt:~6,2%"
	set "hh=%dt:~8,2%"
	set "min=%dt:~10,2%"
	set "ss=%dt:~12,2%"

	set "stamp=_%YYYY%-%MM%-%DD%"


::===========================================================================================================
::-------[ ****  COUNT VARIABLE : DO NOT MODIFY  ****  ]
::===========================================================================================================

	SET /a cnt=0



::===========================================================================================================
::-------[ ****  SCRIPT START  ****  ]
::===========================================================================================================




::-------[  DIRECTORY	] : Change to Target Directory
::---------------------------------------------------------------------------------------

	CD /d %targetD%




::-------[  COPY ORIGINAL ] : If Original File Exists, Copy to Archive Directory and Rename
::---------------------------------------------------------------------------------------

	if exist "%originD%\mprgedcsv" (

		copy "!originD!\mprgedcsv" "!targetD!\mprgedcsv!stamp!"

		goto Rotate

	) else (

		goto Done
	)




:ROTATE

::-------[  ROTATE SCRIPT ] : Rotate Archived Files
::---------------------------------------------------------------------------------------

	for /f "skip=12 eol=: delims=" %%F in ('dir /b /o-d mprgedcsv_*') do @del "%%F"





:DONE