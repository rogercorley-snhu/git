		@echo off
		cls
		setlocal ENABLEDELAYEDEXPANSION

::-----------------------------------------------------------------------
::		Set Global Variables
::-----------------------------------------------------------------------

	::	Set DATE CONSTANT  [ **	DO NOT MODIFY ** ]
	::-----------------------------------------------------------------------


	::	Configure Environment Variables
	::	[**	Modify AS NEEDED **] 
	::	[** Be Sure To Create Both Archive & ImportEmployees Directories **	]
	::---------------------------------------------------------
		set DIR_IMPEXP=D:\GEM\ImportExport
		set DIR_ARCH=D:\GEM\ImportExport\Archive\ImportEmployees

		::set FILE_NAME=[  INSERT FILE NAME ** FULL PATH HERE ** REMOVE BRACKETS	]
		set LOG_NAME=D:\GEM\ImportExport\Archive\ImportEmployees\__ImportEmployees.log01
		set EXP_NUM_LINES=10

		::set ARCH_NAME=[ INSERT FILE NAME ONLY ** REMOVE BRACKETS 	]

	::	Configure Import Script Variables
	::	[	**	Modify AS NEEDED	**	] 
	::	---------------------------------------------------
		set DIR_ROOT=D:\GEM

		
	::	[ ** ENCLOSE "SQLNAME=VARIABLE" WITH DOUBLE-QUOTES ** ]
	::	---------------------------------------------------
		set "SQLNAME=(local)"

		set MODULE=400


::-----------------------------------------------------------------------
::		FUNCTION : Search For Master Employee File
::-----------------------------------------------------------------------
	if not exist %DIR_IMPEXP%\%FILE_NAME% goto ERROR_FILE_NOT_EXIST

	echo %DATE% : [SEARCH] Master Employee File Found >> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%


::-----------------------------------------------------------------------
::		FUNCTION : Count Number Of Lines In Master Employee File
::-----------------------------------------------------------------------
	echo %DATE% : [COUNT] Testing Expected Number Of Lines In File >> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%

	set /p =COUNT: < nul
	for /f %%C in ('Find /V /C "" ^< %DIR_IMPEXP%\%FILE_NAME%') do set COUNT=%%C

	echo %DATE% : [COUNT] The Import File has %COUNT% lines. >> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%
	goto ERROR_COUNT_FAIL


::-----------------------------------------------------------------------
:Import
::-----------------------------------------------------------------------
	echo %DATE% : [IMPORT] Begin Import Module of Master Employee File >> %LOG_NAME%

	%DIR_ROOT%\runscript script=Import_v1_70.gsf,pw=gemie,svr=%SQLNAME%,core=1,module=%MODULE%,include=gsf.txt
	
	echo %DATE% : [IMPORT] Exiting Import Module >> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%
	goto Archive


::-----------------------------------------------------------------------
:ERROR_FILE_NOT_EXIST
::-----------------------------------------------------------------------
	echo %DATE% : [ERROR: FILENOTEXIST] Expected Master File does not exist in %DIR_IMPEXP% >> %LOG_NAME%
	echo .............................................................. >> %LOG_NAME%
	goto Done


::-----------------------------------------------------------------------
:ERROR_COUNT_FAIL
::-----------------------------------------------------------------------
	if %COUNT% GTR %EXP_NUM_LINES% goto Import
	echo %DATE% : [ERROR: EXP_NUM_LINES] IMPORT JOB FAILED >> %LOG_NAME%
	echo %DATE% : ------ DID NOT PASS LINE COUNT TEST ------ >> %LOG_NAME%
	echo %DATE% : ------ EXPECTED NUMBER OF LINES: %EXP_NUM_LINES% ------ >> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%
	goto Archive


::-----------------------------------------------------------------------
:Archive
::-----------------------------------------------------------------------

	if exist %DIR_ARCH%\%ARCH_NAME%.d08 del /Q %DIR_ARCH%\%ARCH_NAME%.d08
	if exist %DIR_ARCH%\%ARCH_NAME%.d07 copy %DIR_ARCH%\%ARCH_NAME%.d07 %DIR_ARCH%\%ARCH_NAME%.d08
	if exist %DIR_ARCH%\%ARCH_NAME%.d06 copy %DIR_ARCH%\%ARCH_NAME%.d06 %DIR_ARCH%\%ARCH_NAME%.d07
	if exist %DIR_ARCH%\%ARCH_NAME%.d05 copy %DIR_ARCH%\%ARCH_NAME%.d05 %DIR_ARCH%\%ARCH_NAME%.d06
	if exist %DIR_ARCH%\%ARCH_NAME%.d04 copy %DIR_ARCH%\%ARCH_NAME%.d04 %DIR_ARCH%\%ARCH_NAME%.d05
	if exist %DIR_ARCH%\%ARCH_NAME%.d03 copy %DIR_ARCH%\%ARCH_NAME%.d03 %DIR_ARCH%\%ARCH_NAME%.d04
	if exist %DIR_ARCH%\%ARCH_NAME%.d02 copy %DIR_ARCH%\%ARCH_NAME%.d02 %DIR_ARCH%\%ARCH_NAME%.d03
	if exist %DIR_ARCH%\%ARCH_NAME%.d01 copy %DIR_ARCH%\%ARCH_NAME%.d01 %DIR_ARCH%\%ARCH_NAME%.d02

	echo %DATE% : [ARCHIVE] Archived Files In %DIR_ARCH% Rotated Successfully >> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%

	move %DIR_IMPEXP%\%FILE_NAME% %DIR_ARCH%\%ARCH_NAME%.d01

	echo %DATE% : [ARCHIVE] Master File Archived In %DIR_ARCH%>> %LOG_NAME%
	echo .................................................................... >> %LOG_NAME%
	goto Done


::-----------------------------------------------------------------------
:Done
::-----------------------------------------------------------------------
	echo %DATE% : Exiting Import Job [END]>> %LOG_NAME%
	echo ==================================================================== >> %LOG_NAME%
	echo -------------------------------------------------------------------- >> %LOG_NAME%
	echo ==================================================================== >> %LOG_NAME%

