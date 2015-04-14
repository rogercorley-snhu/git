	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION

::-----------------------------------------------------------------------
::	Set Global Variables
::-----------------------------------------------------------------------

::	Set Date Variable
::-----------------------------------------------------------------------
	for /f "tokens=2-8 delims=.:/ " %%a in ("%date%") do set DATE=%%a-%%b-%%c

::	Configure Batch Variables
::	[ ** Modify AS NEEDED 						** ] 
::	[ ** Be Sure To Create Archive & ImportEmployees Directories 	** ]
::---------------------------------------------------------
	set _SYS_ROOT=C:
	set _DIR_ARCH=_GPayLogArchive


::	Configure Log File Variables
::	[ ** INSERT LOG FILE NAME WITHOUT FILE EXTENTION	** ]
::	[ ** KEEP LEADING UNDERSCORE  (e.g. _logfilename)	** ]
::	[ ** REMOVE BRACKETS					** ]
::---------------------------------------------------------
	set _GOnline_LOG_NAME=gemonline
	set _GDaily_LOG_NAME=GEMDaily
	set _IMPORT_LOG=C:\_GPayLogArchive\_RotateLogFiles.log
	set _GOnline_CHK=0
	set _GDaily_CHK=0

::-----------------------------------------------------------------------
:CHK_GOnline
::-----------------------------------------------------------------------
	if exist %_SYS_ROOT%\%_GOnline_LOG_NAME%.log (
		echo !DATE! : [ MSG ] : GEMonline.log found. >> !_IMPORT_LOG!
		goto RotateGOnlineLogs) 
	else (
		echo !DATE! : [ ERROR ] : GEMonline.log not found. >> !_IMPORT_LOG!
		goto CHK_GDAILY)

::-----------------------------------------------------------------------
:CHK_GDaily
::-----------------------------------------------------------------------
	if exist %_SYS_ROOT%\%_GDaily_LOG_NAME%.cp (
		echo !DATE! : [ MSG ] : GEMonline.log found. >> !_IMPORT_LOG!
		goto RotateGDailyLogs) 
	else (
		echo !DATE! : [ ERROR ] : GEMonline.log not found. >> !_IMPORT_LOG!
		goto DONE)


::-----------------------------------------------------------------------
:RotateGOnlineLogs
::-----------------------------------------------------------------------
	echo %DATE% : [JOB BEGIN] Beginning GEMOnline Log File Rotation Job >> %_IMPORT_LOG%
	echo .................................................................... >> %_IMPORT_LOG%

	del /Q %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log08
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log07 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log07 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log08
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log06 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log06 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log07
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log05 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log05 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log06
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log04 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log04 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log05
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log03 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log03 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log04
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log02 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log02 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log03
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log01 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log01 %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log02
	if exist %_SYS_ROOT%\%_GOnline_LOG_NAME%.log copy %_SYS_ROOT%\%_GOnline_LOG_NAME%.log %_SYS_ROOT%\%_DIR_ARCH%\%_GOnline_LOG_NAME%.log01
	del /Q %_SYS_ROOT%\%_GOnline_LOG_NAME%.log
	
	echo %DATE% : [JOB END] GEMDaily Log File Rotation Complete >> %_IMPORT_LOG%
	echo .................................................................... >> %_IMPORT_LOG%

	goto CHK_GDaily


::-----------------------------------------------------------------------
:RotateGDailyLogs
::-----------------------------------------------------------------------
	echo %DATE% : [JOB BEGIN] Beginning GEMOnline Log File Rotation Job >> %_IMPORT_LOG%
	echo .................................................................... >> %_IMPORT_LOG%

	del /Q %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp08
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp07 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp07 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp08
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp06 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp06 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp07
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp05 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp05 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp06
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp04 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp04 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp05
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp03 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp03 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp04
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp02 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp02 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp03
	if exist %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp01 copy %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp01 %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp02
	if exist %_SYS_ROOT%\%_GDaily_LOG_NAME%.cp copy %_SYS_ROOT%\%_GDaily_LOG_NAME%.cp %_SYS_ROOT%\%_DIR_ARCH%\%_GDaily_LOG_NAME%.cp01
	del /Q %_SYS_ROOT%\%_GDaily_LOG_NAME%.cp

	echo %DATE% : [JOB END] GEMDaily Log File Rotation Complete >> %_IMPORT_LOG%
	echo .................................................................... >> %_IMPORT_LOG%

	goto DONE

:DONE
