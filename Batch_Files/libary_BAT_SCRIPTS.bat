::-------------------------------------------------------------------------------------------------------------------------------------
::				BATCH : Set TimeStamp																								
::-------------------------------------------------------------------------------------------------------------------------------------

@ECHO OFF
setlocal EnableDelayedExpansion

for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set "dt=%%a"
set "YYYY=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%"
set "Min=%dt:~10,2%"
set "Sec=%dt:~12,2%"

set datestamp=%YYYY%%MM%%DD%
set timestamp=%HH%%Min%%Sec%
set fullstamp=%YYYY%/%MM%/%DD% %HH%:%Min%:%Sec%
echo datestamp: "%datestamp%"
echo timestamp: "%timestamp%"
echo fullstamp: "%fullstamp%"

pause


::-------------------------------------------------------------------------------------------------------------------------------------
::				BATCH : Set DateTimeStamp (GTE WIN07)																								
::-------------------------------------------------------------------------------------------------------------------------------------
@ECHO OFF
setlocal EnableDelayedExpansion

set "datetime=%date% %time%"

echo %datetime%

pause

::-------------------------------------------------------------------------------------------------------------------------------------
::				BATCH : MASTER : RotateGEMLogs (GTE WIN07)																								
::-------------------------------------------------------------------------------------------------------------------------------------

	@ECHO OFF
	cls
	setlocal ENABLEDELAYEDEXPANSION

::-----------------------------------------------------------------------
::	Set Global Variables
::-----------------------------------------------------------------------

::	Set Date Variable
::-----------------------------------------------------------------------
	set "datetime=[ %date% %time% ] "

::	Configure Batch Variables
::	[ ** Modify AS NEEDED 						** ] 
::	[ ** Be Sure To Create Archive & ImportEmployees Directories 	** ]
::---------------------------------------------------------
	set _SYS_ROOT=C:
	set _ARCHIVE=_GPayLogArchive


::	Configure Log File Variables
::	[ ** INSERT LOG FILE NAME WITHOUT FILE EXTENTION	** ]
::	[ ** KEEP LEADING UNDERSCORE  (e.g. _logfilename)	** ]
::	[ ** REMOVE BRACKETS					** ]
::---------------------------------------------------------
	set _GOnline=gemonline
	set _GDaily=GEMDaily
	set _IMPORT_LOG=C:\_GPayLogArchive\_RotateLogFiles.log
	set _GOnline_CHK=0
	set _GDaily_CHK=0

::-----------------------------------------------------------------------
:CHK_GOnline
::-----------------------------------------------------------------------
	if exist %_SYS_ROOT%\%_GOnline%.log (
		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		
		echo !datetime! : [ MSG ] : !_GOnline!.log found. >> !_IMPORT_LOG!
		
		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		goto RotateGOnlineLogs) 
	else (
		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !_IMPORT_LOG!
		
		echo !datetime! : [ ERROR ] : !_GOnline!.log not found. >> !_IMPORT_LOG! 
		
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !_IMPORT_LOG!
		
		)
		goto CHK_GDaily

::-----------------------------------------------------------------------
:CHK_GDaily
::-----------------------------------------------------------------------
	if exist %_SYS_ROOT%\%_GDaily%.cp (
		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		
		echo !datetime! : [ MSG ] : !_GDaily!.cp found. >> !_IMPORT_LOG!
		
		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		goto RotateGDailyLogs)
	else (
		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !_IMPORT_LOG!
		
		echo !datetime! : [ ERROR ] : !_GDaily!.cp not found. >> !_IMPORT_LOG!
		
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !_IMPORT_LOG!

		echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
		
		)
		goto DONE

::-----------------------------------------------------------------------
:RotateGOnlineLogs
::-----------------------------------------------------------------------
	echo %datetime% : [JOB BEGIN] Begin Rotate GEMonline Logs >> %_IMPORT_LOG%
	

	del /Q %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log08
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log07 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log07 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log08
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log06 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log06 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log07
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log05 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log05 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log06
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log04 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log04 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log05
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log03 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log03 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log04
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log02 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log02 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log03
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log01 copy %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log01 %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log02
	if exist %_SYS_ROOT%\%_GOnline%.log copy %_SYS_ROOT%\%_GOnline%.log %_SYS_ROOT%\%_ARCHIVE%\%_GOnline%.log01
	del /Q %_SYS_ROOT%\%_GOnline%.log
	
	echo %datetime% : [JOB END] End Rotate GEMonline Logs >> %_IMPORT_LOG%
	
	echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
	
	echo .............................................................................. >> %_IMPORT_LOG%
	echo .............................................................................. >> %_IMPORT_LOG%
	

	goto CHK_GDaily


::-----------------------------------------------------------------------
:RotateGDailyLogs
::-----------------------------------------------------------------------
	echo %datetime% : [JOB BEGIN] Begin Rotate GEMDaily Logs >> %_IMPORT_LOG%
	

	del /Q %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp08
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp07 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp07 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp08
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp06 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp06 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp07
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp05 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp05 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp06
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp04 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp04 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp05
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp03 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp03 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp04
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp02 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp02 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp03
	if exist %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp01 copy %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp01 %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp02
	if exist %_SYS_ROOT%\%_GDaily%.cp copy %_SYS_ROOT%\%_GDaily%.cp %_SYS_ROOT%\%_ARCHIVE%\%_GDaily%.cp01
	del /Q %_SYS_ROOT%\%_GDaily%.cp

	echo %datetime% : [JOB END] End Rotate GEMDaily Logs >> %_IMPORT_LOG%
	
	echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
	
	echo .............................................................................. >> %_IMPORT_LOG%
	echo .............................................................................. >> %_IMPORT_LOG%
	
	
	goto DONE

:DONE
	echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!
	echo %datetime% : [ MSG ] Exiting Rotate Job >> %_IMPORT_LOG% 
	echo ------------------------------------------------------------------------- >> !_IMPORT_LOG!

	echo ------------------------------------------------------------------------------ >> %_IMPORT_LOG%
	echo ****************************************************************************** >> %_IMPORT_LOG%
	echo ------------------------------------------------------------------------------ >> %_IMPORT_LOG%


	
