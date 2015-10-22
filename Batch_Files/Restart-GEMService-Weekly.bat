	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION


::===========================================================================================================
::
::-------[ TITLE 		]  :  BATCH SCRIPT : Restart GEMservice
::
::===========================================================================================================
::
::-------[ AUTHOR		] : Roger Corley
::-------[ CREATED		] : October 21, 2015 12:26:31 PM
::-------[ COPYRIGHT		] : Common CENTS Solutions - 2015
::-------[ VERSION             		] : 2.0.0
::
::-----------------------------------------------------------------------------------------------------------



::===========================================================================================================
:: Description:
::===========================================================================================================
::
::
::	This script will check the current state of GEMservice and restart the service safely.
::
::-----------------------------------------------------------------------------------------------------------


::===========================================================================================================
::-------[ ****  DATE CONSTANTS : DO NOT MODIFY  ****  ]
::===========================================================================================================

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



::===========================================================================================================
::-------[ CONFIGURE VARIABLES ] : ENVIRONMENT : Archive Directory Drive
::===========================================================================================================

::		** Set variable to drive letter hosting GEM Directory
::		** ( e.g. If D:\GEM, then set archD to D: )
::		------------------------------------------------------
		set "archD=C:"


::===========================================================================================================
::-------[ CONFIGURE VARIABLES ] : ENVIRONMENT : Service Name
::===========================================================================================================

		set "serVar=GEMService"


::===========================================================================================================
::-------[ CONFIGURE VARIABLES ] : ENVIRONMENT : Script Log File
::===========================================================================================================

		set "log=%archD%\_Gem-Log-Archives\_Restart-GEMService.log"


::-----------------------------------------------------------------------------------------------------------
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
::
::-------[ ****  DO NOT MODIFY ANYTHING PAST THIS SECTION  ****  ]
::
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
::-----------------------------------------------------------------------------------------------------------

SET "sVar=%1"

:Parameter Check
::---------------------------------------------------------------
if [%1]==[help] GOTO usage
if [%1]==[] SET "sVar=%serVar%"

	echo %fullstamp% : [ BEGIN ] Checking Current Status of %sVar% ...

	echo ============================================================================== >> %log%
	echo %fullstamp% : [ BEGIN ] Checking Current Status of %sVar% >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%
	echo .............................................................................. >> %log%
	echo .............................................................................. >> %log%
	echo. >> %log%


SC query %sVar% | FIND "STATE" >NUL
	IF errorlevel 1 GOTO SystemOffline


:ResolveInitialState
::---------------------------------------------------------------
SC query %sVar% | FIND "STATE" | FIND "RUNNING" >NUL
	IF errorlevel 0 IF NOT errorlevel 1 GOTO StopService


SC query %sVar% | FIND "STATE" | FIND "STOPPED" >NUL
	IF errorlevel 0 IF NOT errorlevel 1 GOTO StartService

	echo %fullstamp% : [ STATE ] : Service State is changing.
	echo %fullstamp% : [ STATE ] : Waiting for service to resolve its state before making other changes...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATE ] : Service State is changing.
	echo %fullstamp% : [ STATE ] : Waiting for service to resolve its state before making other changes... >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

SC query %sVar% | FIND "STATE"
	timeout /t 3 /nobreak >NUL

GOTO ResolveInitialState



::  STOPPING SERVICE PROCESSES
::---------------------------------------------------------------


:StopService
::---------------------------------------------------------------
	echo %fullstamp% : [ STATUS ] : Stopping %sVar%...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATUS ] : Stopping %sVar%. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

SC stop %sVar% >NUL

timeout /t 5 /nobreak >NUL

GOTO StoppingService


:StoppingServiceDelay
::---------------------------------------------------------------
	echo %fullstamp% : [ STATUS ] : Waiting for %sVar% to stop...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATUS ] : Waiting for %sVar% to stop. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

timeout /t 10 /nobreak >NUL


:StoppingService
::---------------------------------------------------------------
SC query %sVar% | FIND "STATE" | FIND "STOPPED" >NUL
	IF errorlevel 1 GOTO StoppingServiceDelay


:StoppedService
::---------------------------------------------------------------
	echo %fullstamp% : [ STATE ] : %sVar% has stopped...

timeout /t 3 /nobreak >NUL

GOTO VerifyStoppedService


:VerifyStoppedService
::---------------------------------------------------------------
	echo %fullstamp% : [ CHECK-STATE ] : Verifying %sVar% has stopped...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATUS ] : Waiting for %sVar% to stop. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

SC query %sVar% | FIND "STATE" | FIND "STOPPED" >NUL
	IF errorlevel 1 GOTO StopService

timeout /t 3 /nobreak >NUL

GOTO StartService

::  STARTING SERVICE PROCESSES
::---------------------------------------------------------------

:StartService
::---------------------------------------------------------------
	echo %fullstamp% : [ STATUS ] : Starting %sVar%...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATUS ] : Starting %sVar%. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

SC start %sVar% >NUL

timeout /t 10 /nobreak >NUL

GOTO StartingService



:StartingServiceDelay
::---------------------------------------------------------------
	echo %fullstamp% : [ STATUS ] : Waiting for %sVar% to start...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATUS ] : Waiting for %sVar% to start. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

timeout /t 3 /nobreak >NUL



:StartingService
::---------------------------------------------------------------
SC query %sVar% | FIND "STATE" | FIND "RUNNING" >NUL
	IF errorlevel 1 GOTO StartingServiceDelay



:StartedService
::---------------------------------------------------------------
	echo %fullstamp% : [ STATE ] : %sVar% has started...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ STATE ] : %sVar% has started. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%


::  VERIFY SERVICE STATE
::---------------------------------------------------------------


:VerifyServiceStart
::---------------------------------------------------------------
	echo %fullstamp% : [ CHECK-STATE ] : Verifying %sVar% is running...

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ CHECK-STATE ] : Verifying %sVar% is running. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%

SC query %sVar% | FIND "STATE" | FIND "RUNNING" >NUL
	IF errorlevel 1 GOTO StartService

	echo %fullstamp% : [ END ] :  %sVar% is running. Ending Service Restart script.

	echo ============================================================================== >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo %fullstamp% : [ END ] :  %sVar% is running. Ending Service Restart script. >> %log%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
	echo ============================================================================== >> %log%
	echo. >> %log%


GOTO:eof



:usage
::---------------------------------------------------------------
	echo This script will restart a service, waiting for the service to stop/start (if necessary)
	echo.
	echo %0 { optional Service Name }
	echo Example: %0 %sVar%
	echo.
	echo.

GOTO:eof