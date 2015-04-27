	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION

::-----------------------------------------------------------------------
::	Set Global Variables
::-----------------------------------------------------------------------

::	Set Date Variable
::-----------------------------------------------------------------------
	for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set "dt=%%a"
		set "YYYY=%dt:~0,4%"
		set "MM=%dt:~4,2%"
		set "DD=%dt:~6,2%"
		set "HH=%dt:~8,2%"
		set "Min=%dt:~10,2%"
		set "Sec=%dt:~12,2%"

		set datestamp=%YYYY%/%MM%/%DD%
		set timestamp=%HH%:%Min%:%Sec%
		set fullstamp=%datestamp% %timestamp%
		set logstamp=%YYYY%%MM%%DD%_%HH%%Min%%Sec%

::	Configure Batch Variables
::	[ ** Modify AS NEEDED 						** ] 
::	[ ** Be Sure To Create Archive & ImportEmployees Directories 	** ]
::---------------------------------------------------------
	set archive=C:\_GPayLogArchive


::	Configure Log File Variables
::	[ ** INSERT LOG FILE NAME WITHOUT FILE EXTENTION	** ]
::	[ ** KEEP LEADING UNDERSCORE  (e.g. _logfilename)	** ]
::	[ ** REMOVE BRACKETS					** ]
::---------------------------------------------------------
	set go=gemonline
	set gofull=gemonline.log
	set gopath=C:\gemonline.log

	set gd=GEMDaily
	set gdfull=GEMDaily.cp
	set gdpath=C:\GEMDaily.cp
	set log=C:\_GPayLogArchive\_rotate_GOlogs_GDlogs.log01

::-----------------------------------------------------------------------
:CHKgo
::-----------------------------------------------------------------------
	if exist %gopath% (
		echo --------------------------------------------------------------- >> !log!
		echo !fullstamp! : [ MSG ] : !gofull! found. >> !log!
		echo --------------------------------------------------------------- >> !log!
		goto RotateGO) 
	else (
		echo --------------------------------------------------------------- >> !log!
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		echo !fullstamp! : [ ERROR ] : !gofull! not found. >> !log! 
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		)
		goto CHKgd

::-----------------------------------------------------------------------
:CHKgd
::-----------------------------------------------------------------------
	if exist %gdpath% (
		echo --------------------------------------------------------------- >> !log!
		echo !fullstamp! : [ MSG ] : !gdfull! found. >> !log!
		echo --------------------------------------------------------------- >> !log!
		goto RotateGD)
	else (
		echo --------------------------------------------------------------- >> !log!
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		echo !fullstamp! : [ ERROR ] : !gdfull! not found. >> !log!
		echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		)
		goto DONE

::-----------------------------------------------------------------------
:RotateGO
::-----------------------------------------------------------------------
	echo %fullstamp% : [JOB BEGIN] Begin Rotate GEMonline Logs >> %log%

	if exist %archive%\%go%.log08 del /f /q %archive%\%go%.log08
	if exist %archive%\%go%.log07 copy %archive%\%go%.log07 %archive%\%go%.log08
	if exist %archive%\%go%.log06 copy %archive%\%go%.log06 %archive%\%go%.log07
	if exist %archive%\%go%.log05 copy %archive%\%go%.log05 %archive%\%go%.log06
	if exist %archive%\%go%.log04 copy %archive%\%go%.log04 %archive%\%go%.log05
	if exist %archive%\%go%.log03 copy %archive%\%go%.log03 %archive%\%go%.log04
	if exist %archive%\%go%.log02 copy %archive%\%go%.log02 %archive%\%go%.log03
	if exist %archive%\%go%.log01 copy %archive%\%go%.log01 %archive%\%go%.log02
	if exist %gopath% move %gopath% %archive%\%go%.log01

	
	echo %fullstamp% : [JOB END] End Rotate GEMonline Logs >> %log%
	echo --------------------------------------------------------------- >> %log%
	echo .............................................................................. >> %log%
	echo .............................................................................. >> %log%

	goto CHKgd


::-----------------------------------------------------------------------
:RotateGD
::-----------------------------------------------------------------------
	echo %fullstamp% : [JOB BEGIN] Begin Rotate GEMDaily Logs >> %log%

	if exist %archive%\%go%.log08 del /f /q %archive%\%gd%.log08
	if exist %archive%\%gd%.log07 copy %archive%\%gd%.log07 %archive%\%gd%.log08
	if exist %archive%\%gd%.log06 copy %archive%\%gd%.log06 %archive%\%gd%.log07
	if exist %archive%\%gd%.log05 copy %archive%\%gd%.log05 %archive%\%gd%.log06
	if exist %archive%\%gd%.log04 copy %archive%\%gd%.log04 %archive%\%gd%.log05
	if exist %archive%\%gd%.log03 copy %archive%\%gd%.log03 %archive%\%gd%.log04
	if exist %archive%\%gd%.log02 copy %archive%\%gd%.log02 %archive%\%gd%.log03
	if exist %archive%\%gd%.log01 copy %archive%\%gd%.log01 %archive%\%gd%.s02
	if exist %gdpath% move %gdpath% %archive%\%gd%.log01


	echo %fullstamp% : [JOB END] End Rotate GEMDaily Logs >> %log%
	echo --------------------------------------------------------------- >> !log!
	echo .............................................................................. >> %log%
	echo .............................................................................. >> %log%
	
	goto DONE

:DONE
	echo %fullstamp% : [ MSG ] Exiting Rotate Job >> %log% 
	echo ------------------------------------------------------------------------------ >> %log%
	echo ****************************************************************************** >> %log%
	echo ------------------------------------------------------------------------------ >> %log%