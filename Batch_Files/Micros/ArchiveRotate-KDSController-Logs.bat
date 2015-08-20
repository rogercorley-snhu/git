	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION


::===========================================================================================================
::
::-------[ TITLE 		]  :  BATCH SCRIPT : ARCHIVE & ROTATE : KDSController.log Files
::
::===========================================================================================================



::-----------------------------------------------------------------------------------------------------------
::
::-------[ AUTHOR		] : Roger Corley
::-------[ CREATED		] : August 20, 2015 11:23:15 AM
::-------[ COPYRIGHT		] : Common CENTS Solutions - 2015
::
::-----------------------------------------------------------------------------------------------------------



::========================================================================================================================================
:: Description:
::========================================================================================================================================
::
::	A log rotation batch file to be run daily. This batch file will archive
::	the current 'KDSController.log' file located in \MICROS\Res\KDS\Etc to \Res\KDS\Etc\Archive-KDS.
::	Without this archival process, this file continues to grow, which eventually causes the KDSController
::	to crash. The file is renamed 'KDSController_<yyyy-MM-dd>.log' during this process.
::
::	This batch file will also rotate any existing archived files. You can set the number
::	of archived files to keep by changing the 'skip' number in the FOR statement. Search this file
::	for ( for /f "skip= ). Copy everything starting with for and ending with the equals sign.
::
::	Once you find this statement, ONLY CHANGE THE NUMBER following the equals sign to the number of
::	days to keep archived files. DO NOT CHANGED ANYTHING ELSE IN THAT STATEMENT!
::
::	Be sure to check the drive letter where the MICROS directory is located. Match it to the
::	DRIVE LETTER in the set "microsDrive=C:\" variable below. ONLY CHANGE THE DRIVE LETTER IF NEEDED.
::
::	DO NOT MODIFY ANYTHING ELSE IN THIS SCRIPT OR IT WILL NOT WORK!
::
::	If you have any questions or problems with this script, contact Roger Corley at Common CENTS Solutions.





::===========================================================================================================
::-------[ ENVIRONMENT VARIABLES ] : Directories
::===========================================================================================================


::	##	Change the DRIVE LETTER to match the directory where MICROS is located.
::	##	ONLY CHANGE THE DRIVE LETTER - DO NOT REMOVE OR MODIFY THE ' :\ ''  IN THE DRIVE PATH!
::	----------------------------------------------------------------------------------------------

	SET "microsDrive=E:\"



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
::-------[ ****  DIRECTORY VARIABLES : DO NOT MODIFY  ****  ]
::===========================================================================================================

	SET "microsDir=%microsDrive%Micros"

	SET "logDir=%microsDir%\Res\KDS\Etc"
	SET "archiveDir=%microsDir%\Res\KDS\Etc\Archive-KDS"




::===========================================================================================================
::-------[ ****  SCRIPT START  ****  ]
::===========================================================================================================



	echo Beginning KDSController.log Archive and Rotation...




::-------[  DIRECTORY	] : Change to Target Directory
::---------------------------------------------------------------------------------------

	CD /d %archiveDir%




::-------[  COPY ORIGINAL ] : If Original File Exists, Copy to Archive Directory and Rename
::---------------------------------------------------------------------------------------

	if exist "%logDir%\KdsController.log" (

		move "!logDir!\KdsController.log" "!archiveDir!\KdsController!stamp!.log"

		goto Rotate

	) else (

		goto Done
	)




:ROTATE

::-------[  ROTATE SCRIPT ] : Rotate Archived Files
::---------------------------------------------------------------------------------------

	for /f "skip=7 eol=: delims=" %%F in ('dir /b /o-d KdsController_*') do @del "%%F"

	goto Done



:DONE

	echo KDSController.log Archive and Rotation completed...