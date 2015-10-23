	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION



::===========================================================================================================
::
::-------[ TITLE 		]  :  BATCH SCRIPT : ARCHIVE : Employee Demographic Files
::
::===========================================================================================================
::
::-------[ AUTHOR		] : Roger Corley
::-------[ CREATED		] : October 23, 2015 4:23:31 PM
::-------[ COPYRIGHT		] : Common CENTS Solutions - 2015
::
::-----------------------------------------------------------------------------------------------------------




::========================================================================================================================================
:: Description:
::========================================================================================================================================
::
::	A batch file that tests if a Employee Demographic file exists and archives the file if exist is true.
::
::----------------------------------------------------------------------------------------------------------------------------------------
::
::	VARIABLES TO CONFIGURE
::----------------------------------------------------------------------------------------------------------------------------------------
::
::	SET "fileName="		Enter the Import filename with extension.
::
::	SET "archExt="		Enter the desired extension for the archived imported file.
::				**  If no specific extension is required, do not modify.
::
::	SET "gemDRIVE=E:\"	Enter the DRIVE LETTER when the GEM directory is located
::				**  ONLY CHANGE THE DRIVE LETTER! DO NOT MODIFY OR REMOVE THE ' :\ '
::
::	This batch file will also rotate any existing archived Import files. You can set the number
::	of archived files to keep by changing the 'skip' number in the FOR statement towards the end of this script.
::	Search this file for ( for /f "skip= ). Copy everything starting with for and ending with the equals sign.
::
::	Once you find the FOR statement, ONLY CHANGE THE NUMBER following the equals sign.
::	This wil be the number of days to keep archived files. DO NOT CHANGED ANYTHING ELSE IN THIS STATEMENT!
::
::-----------------------------------------------------------------------------------------------------------
::
::	***	The default amount of files to keep is six ( 6 ).	***
::
::-----------------------------------------------------------------------------------------------------------
::
::	DO NOT MODIFY ANYTHING ELSE IN THIS SCRIPT OR IT WILL NOT WORK!
::
::	If you have any questions or problems with this script, contact Roger Corley at Common CENTS Solutions.
::
::
::========================================================================================================================================
::========================================================================================================================================




::========================================================================================================================================
::
::-------[ ENVIRONMENT VARIABLES ] : Directories & FileNames
::========================================================================================================================================

	SET "fileName=<FILE-NAME>.csv"
	SET "archExt=.SAV"

::	## If a System Environmental Variable for the GEM Directory location is not set,
::	##  uncomment the SET "gemDRIVE=<DRIVELETTER>:\" and SET "gemDIR=%gemDRIVE%\GEM"
::	##  statements by removing the two colons ( :: ) at the start of the line.  Change the <DRIVELETTER>
::	##  to match the drive where the GEM directory is located. ** ONLY CHANGE THE DRIVELETTER **

::	SET "gemDRIVE=E:\"
::	SET "gemDIR=%gemDRIVE%\GEM"


::-----------------------------------------------------------------------------------------------------------
::	##  If a SYSTEM ENVIRONMENTAL VARIABLE for the GEM Directory has been configured on this
::	##  machine, keep the two SETs for gemDRIVE and gemDIR commented and uncomment the
::	##  SET "gemDIR=%GEM%" statement. ** DO NOT MODIFY THIS STATEMENT **

	SET "gemDIR=%GEM%"

::-----------------------------------------------------------------------------------------------------------
::
::	##  To configure a SYSTEM ENVIRONMENTAL VARIABLE for the GEM Directory, right-click COMPUTER on
::	##  the Desktop --> Click 'Advanced System Settings' -->  Click the 'Environmental Variables' button
::	##  Under 'User variables for gemuser', click the 'New' button .
::	##  In the 'New User Variable' pop-up box, enter 'GEM' for the Variable Name and the path of the
::	##  GEM directory on this machine. For example, if the GEM directory is located on the E:\ drive,
::	##  enter E:\GEM  --  ** DO NOT ENTER A BACK-SLASH ' \ ' AFTER GEM **
::	##  Click 'OK' --> Click 'OK' -->  Click 'APPLY' --> Click 'OK' to close SYSTEM PROPERTIES
::
::	##  You can verify the ENVIRONMENTAL VARIABLE exists by opening a Command Line window
::	##  and typing ECHO %GEM% -- If the Variable exists, the command should return the path to GEM.
::
::-----------------------------------------------------------------------------------------------------------




::========================================================================================================================================
::========================================================================================================================================
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::----------------------------------------------------------------------------------------------------------------------------------------
::
::	*****	DO NOT MODIFY ANYTHING PAST THIS POINT	*****
::
::----------------------------------------------------------------------------------------------------------------------------------------
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::========================================================================================================================================
::========================================================================================================================================






::========================================================================================================================================
::
::-------[ ****  DATE CONSTANTS : DO NOT MODIFY  ****  ]
::========================================================================================================================================

	for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set "dt=%%a"

	set "YYYY=%dt:~0,4%"
	set "MM=%dt:~4,2%"
	set "DD=%dt:~6,2%"
	set "hh=%dt:~8,2%"
	set "min=%dt:~10,2%"
	set "ss=%dt:~12,2%"

	set "stamp=_%YYYY%-%MM%-%DD%"


::========================================================================================================================================
::
::-------[ ****  COUNT CONSTANT : DO NOT MODIFY  ****  ]
::========================================================================================================================================

	SET /a cnt=0


::========================================================================================================================================
::
::-------[ ****  ENVIRONMENT CONSTANTS : DO NOT MODIFY  ****  ]
::========================================================================================================================================

	SET "ieDIR=%gemDIR%\ImportExport"
	SET "arcDIR=%ieDIR%\Archive\Import-Archives"



::========================================================================================================================================
::
::-------[ ****  SCRIPT START  ****  ]
::========================================================================================================================================


	echo Beginning Rotate Import Archive Files and Archive Employee Demographic File ...



::-------[  TEST-FILE-EXISTS ] : Import File
::----------------------------------------------------------------------------------------------------------------------------------------

	if not exist %ieDIR%\%fileName% goto NOFILE



::-------[  DIRECTORY	] : Change to Target Directory
::----------------------------------------------------------------------------------------------------------------------------------------

	CD /d %arcDIR%



::-------[  COPY ORIGINAL ] : If Original File Exists, Copy to Archive Directory and Rename
::----------------------------------------------------------------------------------------------------------------------------------------

	if exist "%ieDIR%\%fileName%" (

		copy "!ieDIR!\!fileName!" "!arcDIR!\!fileName!!stamp!!archExt!"

		goto Rotate

	) else (

		goto Done
	)



::========================================================================================================================================

:ROTATE
::========================================================================================================================================


::-------[  ROTATE SCRIPT ] : Rotate Archived Files
::----------------------------------------------------------------------------------------------------------------------------------------

	for /f "skip=6 eol=: delims=" %%F in ('dir /b /o-d %fileName%_*') do @del "%%F"




::========================================================================================================================================

:NOFILE
::========================================================================================================================================




::========================================================================================================================================

:DONE
::========================================================================================================================================
	echo Rotate Import Archive Files and Archive Employee Demographic File Complete...


