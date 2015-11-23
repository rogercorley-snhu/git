
	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION

::========================================================================================================================================
:: Title:    Rotate GEMonline & GEMDaily Logs -- Daily
::========================================================================================================================================
::
::	Author:	Roger Corley
::	Created:	November 19, 2015  12:53 PM
::............................................................
::
::	Version: 	1.10
::	Created:	November 19, 2015  12:53 PM
::
::
::========================================================================================================================================
:: Description:
::========================================================================================================================================
::
::	A log rotation batch file to be run on a daily basis. This batch will rotate and archive
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
::	Each archived log will be stored for a maximum of thirty (30) days before being deleted
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
::		'C:\_Gem-Toolbox\Batch-Files\Rotate-Gem-Logs-Daily.bat'
::.......................................................................................................................................
::
::
::---------------------------------------------------------------------------------------------------------------------------------------
:: ---[ Scheduled Task ]---
::---------------------------------------------------------------------------------------------------------------------------------------
::
::	Create a Scheduled Task named 'Rotate-Gem-Logs-Daily' with the following properties:
::.......................................................................................................................................
::
::	[ GENERAL ]	Run whether user is logged on or not: 'selected'
::-------------------------------------------------------------------------------------------------
::			Run with highest privileges:    'checked'
::
::.......................................................................................................................................
::
::	[ TRIGGERS ]	Settings: Daily -- Start:  4:45 AM
::-------------------------------------------------------------------------------------------------
::			Recur Daily
::-------------------------------------------------------------------------------------------------
::			Adv Settings: Stop task if it runs longer than: '10 Minutes'
::-------------------------------------------------------------------------------------------------
::			Enabled:  'Checked'
::
::.......................................................................................................................................
::
::	[ ACTIONS ]	Start A Program: 'C:\_Gem-Toolbox\Batch-Files\Rotate-Gem-Files-Daily.bat'
::
::.......................................................................................................................................
::
::	[ SETTINGS ]	Allow task to be run on demand:   'Checked'
::-------------------------------------------------------------------------------------------------
::			Stop the task if it runs longer than: '15 Minutes'
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
:: ---[ **NOTE** ]---	'sysD' MUST match the Drive Letter hosting the GEM directory
::			ALWAYS include the colon ( : ) after the drive letter!  e.g. D:
::-------------------------------------------------------------------------------------
::
	set "sysD=C:"

	set "archD=%sysD%\_Gem-Log-Archives"
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

	set "agofull=%archD%\%goname%.%logstamp%.%gotype%01"
	set "agdfull=%archD%\%gdname%.%logstamp%.%gdtype%01"

	set "ago=%archD%\gemonline.*.%gotype%"
	set "agd=%archD%\GEMDaily.*.%gdtype%"

::========================================================================================================================================
::FILES: Import Log File
::========================================================================================================================================
::
	set "log=%archD%\_Rotate-Gem-Logs-Daily.log"


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

cd C:\_Gem-Log-Archives

	if exist gemonline.*.log30 del /f /q gemonline.*.log30
	if exist gemonline.*.log29 rename gemonline.*.log29 gemonline.*.log30
	if exist gemonline.*.log28 rename gemonline.*.log28 gemonline.*.log29
	if exist gemonline.*.log27 rename gemonline.*.log27 gemonline.*.log28
	if exist gemonline.*.log26 rename gemonline.*.log26 gemonline.*.log27
	if exist gemonline.*.log25 rename gemonline.*.log25 gemonline.*.log26
	if exist gemonline.*.log24 rename gemonline.*.log24 gemonline.*.log25
	if exist gemonline.*.log23 rename gemonline.*.log23 gemonline.*.log24
	if exist gemonline.*.log22 rename gemonline.*.log22 gemonline.*.log23
	if exist gemonline.*.log21 rename gemonline.*.log21 gemonline.*.log22
	if exist gemonline.*.log20 rename gemonline.*.log20 gemonline.*.log21
	if exist gemonline.*.log19 rename gemonline.*.log19 gemonline.*.log20
	if exist gemonline.*.log18 rename gemonline.*.log18 gemonline.*.log19
	if exist gemonline.*.log17 rename gemonline.*.log17 gemonline.*.log18
	if exist gemonline.*.log16 rename gemonline.*.log16 gemonline.*.log17
	if exist gemonline.*.log15 rename gemonline.*.log15 gemonline.*.log16
	if exist gemonline.*.log14 rename gemonline.*.log14 gemonline.*.log15
	if exist gemonline.*.log13 rename gemonline.*.log13 gemonline.*.log14
	if exist gemonline.*.log12 rename gemonline.*.log12 gemonline.*.log13
	if exist gemonline.*.log11 rename gemonline.*.log11 gemonline.*.log12
	if exist gemonline.*.log10 rename gemonline.*.log10 gemonline.*.log11
	if exist gemonline.*.log09 rename gemonline.*.log09 gemonline.*.log10
	if exist gemonline.*.log08 rename gemonline.*.log08 gemonline.*.log09
	if exist gemonline.*.log07 rename gemonline.*.log07 gemonline.*.log08
	if exist gemonline.*.log06 rename gemonline.*.log06 gemonline.*.log07
	if exist gemonline.*.log05 rename gemonline.*.log05 gemonline.*.log06
	if exist gemonline.*.log04 rename gemonline.*.log04 gemonline.*.log05
	if exist gemonline.*.log03 rename gemonline.*.log03 gemonline.*.log04
	if exist gemonline.*.log02 rename gemonline.*.log02 gemonline.*.log03
	if exist gemonline.*.log01 rename gemonline.*.log01 gemonline.*.log02

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


	if exist GEMDaily.*.cp30 del /f /q GEMDaily.*.cp30
	if exist GEMDaily.*.cp29 rename GEMDaily.*.cp29 GEMDaily.*.cp30
	if exist GEMDaily.*.cp28 rename GEMDaily.*.cp28 GEMDaily.*.cp29
	if exist GEMDaily.*.cp27 rename GEMDaily.*.cp27 GEMDaily.*.cp28
	if exist GEMDaily.*.cp26 rename GEMDaily.*.cp26 GEMDaily.*.cp27
	if exist GEMDaily.*.cp25 rename GEMDaily.*.cp25 GEMDaily.*.cp26
	if exist GEMDaily.*.cp24 rename GEMDaily.*.cp24 GEMDaily.*.cp25
	if exist GEMDaily.*.cp23 rename GEMDaily.*.cp23 GEMDaily.*.cp24
	if exist GEMDaily.*.cp22 rename GEMDaily.*.cp22 GEMDaily.*.cp23
	if exist GEMDaily.*.cp21 rename GEMDaily.*.cp21 GEMDaily.*.cp22
	if exist GEMDaily.*.cp20 rename GEMDaily.*.cp20 GEMDaily.*.cp21
	if exist GEMDaily.*.cp19 rename GEMDaily.*.cp19 GEMDaily.*.cp20
	if exist GEMDaily.*.cp18 rename GEMDaily.*.cp18 GEMDaily.*.cp19
	if exist GEMDaily.*.cp17 rename GEMDaily.*.cp17 GEMDaily.*.cp18
	if exist GEMDaily.*.cp16 rename GEMDaily.*.cp16 GEMDaily.*.cp17
	if exist GEMDaily.*.cp15 rename GEMDaily.*.cp15 GEMDaily.*.cp16
	if exist GEMDaily.*.cp14 rename GEMDaily.*.cp14 GEMDaily.*.cp15
	if exist GEMDaily.*.cp13 rename GEMDaily.*.cp13 GEMDaily.*.cp14
	if exist GEMDaily.*.cp12 rename GEMDaily.*.cp12 GEMDaily.*.cp13
	if exist GEMDaily.*.cp11 rename GEMDaily.*.cp11 GEMDaily.*.cp12
	if exist GEMDaily.*.cp10 rename GEMDaily.*.cp10 GEMDaily.*.cp11
	if exist GEMDaily.*.cp09 rename GEMDaily.*.cp09 GEMDaily.*.cp10
	if exist GEMDaily.*.cp08 rename GEMDaily.*.cp08 GEMDaily.*.cp09
	if exist GEMDaily.*.cp07 rename GEMDaily.*.cp07 GEMDaily.*.cp08
	if exist GEMDaily.*.cp06 rename GEMDaily.*.cp06 GEMDaily.*.cp07
	if exist GEMDaily.*.cp05 rename GEMDaily.*.cp05 GEMDaily.*.cp06
	if exist GEMDaily.*.cp04 rename GEMDaily.*.cp04 GEMDaily.*.cp05
	if exist GEMDaily.*.cp03 rename GEMDaily.*.cp03 GEMDaily.*.cp04
	if exist GEMDaily.*.cp02 rename GEMDaily.*.cp02 GEMDaily.*.cp03
	if exist GEMDaily.*.cp01 rename GEMDaily.*.cp01 GEMDaily.*.cp02

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
