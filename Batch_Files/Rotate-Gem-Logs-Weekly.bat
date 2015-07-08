::	Job Notes
::Configured Weekly GEM Log Rotations:
::Every Monday at 4:45 AM - Runs E:\GEM\_Gem-Toolbox\Batch-Files\Rotate-Gem-Logs-Weekly.bat
::Archives to E:\GEM\_Gem-Log-Archives
::Job Log file lives there for troubleshooting.


	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION

::========================================================================================================================================
:: Title:    Rotate GEMonline & GEMDaily Logs -- Weekly
::========================================================================================================================================
::
::	Author:		Roger Corley
::	Created:	May 14, 2015  11:39:53 AM
::............................................................
::
::	Version: 	1.30
::	Updated:	Roger Corley - June 11, 2015  2:29 PM
::
::========================================================================================================================================
:: Description:
::========================================================================================================================================
::
::	A log rotation batch file to be run on a weekly basis. This batch will rotate and archive
::	the 'gemonline.log' and 'GEMDaily.cp' log files stored on the system drive (C:\). Without
::	an archival process, these files continue to grow, which will eventually begin to slow any
::	transactions between Micros and GEMpay.
::
::
::---------------------------------------------------------------------------------------------------------------------------------------
:: ---[ Archives]---
::---------------------------------------------------------------------------------------------------------------------------------------
::
::	These logs are archived to a directory located on the C:\ drive named '_Gem-Log-Archives'.
::	The archive logs will be renamed and timestamped with the following nomenclature:
::
::.......................................................................................................................................
::
::	'gemonline' = 'C:\_Gem-Log-Archives\gemonline.<datetime>.log0<#>'
::------------------------------------------------------------------------
::	'GEMDaily.cp' = 'C:\_Gem-Log-Archives\GEMDaily.<datetime>.cp0<#>'
::
::.......................................................................................................................................
::
::	Each archived log will be stored for a maximum of twelve (12) weeks before being deleted
::	through the rotation process.
::
::
::---------------------------------------------------------------------------------------------------------------------------------------
::  ---[ Archive Location ]---
::---------------------------------------------------------------------------------------------------------------------------------------
::
::	If the directory 'C:\_Gem-Toolbox' with a subdirectory 'Batch-Files' doesn't exist, create
::	these directories first. Save this batch file as:
::
::.......................................................................................................................................
::		'C:\_Gem-Toolbox\Batch-Files\Rotate-Gem-Logs-Weekly.bat'
::.......................................................................................................................................
::
::
::---------------------------------------------------------------------------------------------------------------------------------------
:: ---[ Scheduled Task ]---
::---------------------------------------------------------------------------------------------------------------------------------------
::
::	Create a Scheduled Task named 'Rotate-Gem-Logs-Weekly' with the following properties:
::.......................................................................................................................................
::
::	[ GENERAL ]	Run whether user is logged on or not: 'selected'
::-------------------------------------------------------------------------------------------------
::			Run with highest privileges:    'checked'
::
::.......................................................................................................................................
::
::	[ TRIGGERS ]	Settings: Weekly -- Start:  (Following Monday) at 4:45 AM
::-------------------------------------------------------------------------------------------------
::			Recur every:  '1' weeks on 'Monday' -- 'checked'
::-------------------------------------------------------------------------------------------------
::			Adv Settings: Stop task if it runs longer than: '30 mins'
::-------------------------------------------------------------------------------------------------
::			Enabled:  'checked'
::
::.......................................................................................................................................
::
::	[ ACTIONS ]	Start A Program: 'C:\_Gem-Toolbox\Batch-Files\Rotate-Gem-Files-Weekly.bat'
::
::.......................................................................................................................................
::
::	[ SETTINGS ]	Allow task to be run on demand:   'checked'
::-------------------------------------------------------------------------------------------------
::			Stop the task if it runs longer than: '1 hour'
::
::.......................................................................................................................................
::
::
::
::
::========================================================================================================================================
:: DIRECTORY: Gem-Log-Archives Variable
::========================================================================================================================================
::
::-------------------------------------------------------------------------------------
:: ---[ **NOTE** ]---	'archD' MUST match the Drive Letter hosting the GEM directory
::			ALWAYS include the colon ( : ) after the drive letter!  e.g. D:
::-------------------------------------------------------------------------------------
::
	set "archD=C:"

	set "archP=%archD%\_Gem-Log-Archives"
::
::
::
::
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::========================================================================================================================================
::
::			----[[[ ****  DO NOT MODIFY THIS SCRIPT   ****  ]]]----
::
::========================================================================================================================================
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::
::
::
::========================================================================================================================================
:: EXTENSION: GEMonline
::========================================================================================================================================
::
::-------------------------------------------------------------------------------------
:: ---[ **NOTE** ]---	'gotype' MUST match the GEMonline log file extension in C:\
::			ALWAYS include the dot ( . ) before the type!
::-------------------------------------------------------------------------------------
::
	set "gotype=log"

::========================================================================================================================================
:: EXTENSION: GEMDaily
::========================================================================================================================================
::
::---------------------------------------------------------------------------------------
:: ---[ **NOTE** ]---	'gdtype' MUST match the GEMDaily log file extension in C:\
::			ALWAYS include the dot ( . ) before the type!
::---------------------------------------------------------------------------------------
::
	set "gdtype=cp"

::========================================================================================================================================
:: DATE CONSTANTS
::========================================================================================================================================
::
	for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set "dt=%%a"

	set "YYYY=%dt:~0,4%"
	set "MM=%dt:~4,2%"
	set "DD=%dt:~6,2%"
	set "HH=%dt:~8,2%"
	set "Min=%dt:~10,2%"
	set "Sec=%dt:~12,2%"

	set "datestamp=%YYYY%/%MM%/%DD%"
	set "timestamp=%HH%:%Min%:%Sec%"
	set "fullstamp=%datestamp% %timestamp%"
	set "logstamp=%YYYY%-%MM%-%DD%"

::========================================================================================================================================
:: FILES: GEMonline
::========================================================================================================================================
::
	set "goname=gemonline"
	set "gofile=%goname%.%gotype%"
	set "gopath=C:\%gofile%"

::========================================================================================================================================
::FILES: GEMDaily
::========================================================================================================================================
::
	set "gdname=GEMDaily"
	set "gdfile=%gdname%.%gdtype%"
	set "gdpath=C:\%gdfile%"

::========================================================================================================================================
::FILES: Archives
::========================================================================================================================================

	set "agofull=%archP%\%goname%.%logstamp%.%gotype%01"
	set "agdfull=%archP%\%gdname%.%logstamp%.%gdtype%01"

	set "ago=%archP%\*.%gotype%"
	set "agd=%archP%\*.%gdtype%"

::========================================================================================================================================
::FILES: Import Log File
::========================================================================================================================================
::
	set "log=%archP%\_Rotate-Gem-Logs-Weekly.log"


::========================================================================================================================================
::BEGIN BATCH ROTATIONS
::========================================================================================================================================
::
::
	goto FileRotations

::
::
::---------------------------------------------------------------------------------------------------------------------------------------
:FileRotations
::---------------------------------------------------------------------------------------------------------------------------------------
		echo. >> %log%
		echo ============================================================================== >> %log%
		echo %fullstamp% : [ ROTATE ] : GEMonline - GEMDaily Log Rotations >> %log%
		echo ============================================================================== >> %log%
		echo. >> %log%

		echo .............................................................................. >> %log%
		echo %fullstamp% : [ MSG ] : Starting Log Rotations >> %log%
		echo .............................................................................. >> %log%


	goto chkGO

::---------------------------------------------------------------------------------------------------------------------------------------
:chkGO
::---------------------------------------------------------------------------------------------------------------------------------------

	if exist %gopath% (
		echo .............................................................................. >> !log!
		echo !fullstamp! : [ CHECKFILE ] : Checking Exist : !gopath! >> !log!
		echo !fullstamp! : [ CHECKFILE ] : !gopath! found. >> !log!
		echo !fullstamp! : [ CHECKFILE ] : Starting GEMonline Log Rotations >> !log!
		echo .............................................................................. >> !log!


	goto rotateGO

	) else (
		echo ============================================================================== >> !log!
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		echo !fullstamp! : [ CHECK : ERROR ] : '!gopath!' NOT FOUND >> !log!
		echo !fullstamp! : [ CHECK : ERROR ] : Moving to Check GEMDaily >> !log!
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		echo ============================================================================== >> !log!
		echo. >> !log!
	)

	goto chkGD

::---------------------------------------------------------------------------------------------------------------------------------------
:rotateGO
::---------------------------------------------------------------------------------------------------------------------------------------

	if exist %ago%12 del /f /q %ago%12
	if exist %ago%11 copy %ago%07 %ago%12
	if exist %ago%10 copy %ago%07 %ago%11
	if exist %ago%09 copy %ago%07 %ago%10
	if exist %ago%08 copy %ago%08 %ago%09
	if exist %ago%07 copy %ago%07 %ago%08
	if exist %ago%06 copy %ago%06 %ago%07
	if exist %ago%05 copy %ago%05 %ago%06
	if exist %ago%04 copy %ago%04 %ago%05
	if exist %ago%03 copy %ago%03 %ago%04
	if exist %ago%02 copy %ago%02 %ago%03
	if exist %ago%01 copy %ago%01 %ago%02

	if exist %gopath% move %gopath% %agofull%

		echo .............................................................................. >> %log%
		echo !fullstamp! : [ ROTATE ] : GEMonline Log Rotations Complete. >> %log%
		echo !fullstamp! : [ ROTATE ] : Moving to Check GEMDaily. >> %log%
		echo .............................................................................. >> %log%


	goto chkGD

::---------------------------------------------------------------------------------------------------------------------------------------
:chkGD
::---------------------------------------------------------------------------------------------------------------------------------------

	if exist %gdpath% (
		echo .............................................................................. >> !log!
		echo !fullstamp! : [ CHECKFILE ] : Checking Exist : !gdpath! >> !log!
		echo !fullstamp! : [ CHECKFILE ] : !gdpath! found. >> !log!
		echo !fullstamp! : [ CHECKFILE ] : Starting GEMDaily Log Rotations >> !log!
		echo .............................................................................. >> !log!


	goto rotateGD

	) else (
		echo ============================================================================== >> !log!
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		echo !fullstamp! : [ CHECK : ERROR ] : '!gdpath!' NOT FOUND >> !log!
		echo !fullstamp! : [ CHECK : ERROR ] : Ending Log Rotation Script >> !log!
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
		echo ============================================================================== >> !log!
		echo. >> !log!
	)

	goto done

::---------------------------------------------------------------------------------------------------------------------------------------
:rotateGD
::---------------------------------------------------------------------------------------------------------------------------------------

	if exist %agd%12 del /f /q %agd%12
	if exist %agd%11 copy %agd%07 %agd%12
	if exist %agd%10 copy %agd%07 %agd%11
	if exist %agd%09 copy %agd%07 %agd%10
	if exist %agd%08 copy %agd%08 %agd%09
	if exist %agd%07 copy %agd%07 %agd%08
	if exist %agd%06 copy %agd%06 %agd%07
	if exist %agd%05 copy %agd%05 %agd%06
	if exist %agd%04 copy %agd%04 %agd%05
	if exist %agd%03 copy %agd%03 %agd%04
	if exist %agd%02 copy %agd%02 %agd%03
	if exist %agd%01 copy %agd%01 %agd%02

	if exist %gdpath% move %gdpath% %agdfull%

		echo .............................................................................. >> %log%
		echo !fullstamp! : [ ROTATE ] : GEMDaily Log Rotations Complete. >> %log%
		echo !fullstamp! : [ ROTATE ] : Ending Log Rotation Script. >> %log%
		echo .............................................................................. >> %log%


	goto done

::---------------------------------------------------------------------------------------------------------------------------------------
:done
::---------------------------------------------------------------------------------------------------------------------------------------

		echo. >> %log%
		echo ============================================================================== >> %log%
		echo %fullstamp% : [ ROTATE ] : GEMonline - GEMDaily Log Rotations Completed >> %log%
		echo ============================================================================== >> %log%
		echo. >> %log%
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
		echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ >> %log%
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
		echo. >> %log%
