net stop "GEM Commander" && net start "GEM Commander"

ping 127.0.0.1 -n 3

net stop "HL7 Processor 4" && net stop "Corepoint Integration Engine" && net stop "Corepoint Integration Engine
Assured Availability" && net stop "Message Queuing"

ping 127.0.0.1 -n 3

net start "Message Queuing" && net start "Corepoint Integration Engine Assured Availability" && net start
"Corepoint Integration Engine" && net start "HL7 Processor 4"



		@echo off
		cls
		setlocal ENABLEDELAYEDEXPANSION



::===========================================================================================================
::-------[  BEGIN BATCH TASKS
::===========================================================================================================
::
::

		echo ==============================================================================
			echo %fullstamp% : [ BEGIN ] Checking Current Status of GEM Commander
		echo ==============================================================================
		echo.
		echo ..............................................................................
		echo ..............................................................................
		echo.


		for /F "tokens=3 delims=: " %%H in ('sc query "GEM Commander" ^| findstr "        STATE"') do (
  			if /I "%%H" NEQ "RUNNING" (

				echo ==============================================================================
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					echo !fullstamp! : [ STATUS] : "GEM Commander" IS STOPPED. Starting Service.
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				echo ==============================================================================
				echo.

   				sc start "GEM Commander"

  			) else (

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] "!gs!" is running. Stopping service.
				echo ------------------------------------------------------------------------------
				echo.


				sc stop "GEM Commander"

				timeout /T 3 /nobreak >NUL


				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Restarting service.
				echo ------------------------------------------------------------------------------
				echo.

				sc start "GEM Commander"

				timeout /T 3 /nobreak >NUL


			)
		)



::===========================================================================================================
::-------[  BEGIN BATCH TASKS
::===========================================================================================================
::
::

		echo ==============================================================================
			echo %fullstamp% : [ BEGIN ] Checking Current Status of HL7 Processor 4
		echo ==============================================================================
		echo.
		echo ..............................................................................
		echo ..............................................................................
		echo.

		SC query %1 | FIND "STATE" | FIND "STOPPED" >NUL
			IF errorlevel 0 IF NOT errorlevel 1 GOTO CheckCorepointIE

		SC query "HL7 Processor 4" | FIND "STATE" | FIND "RUNNING" >NUL
			IF errorlevel 0 IF NOT errorlevel 1 GOTO StopServiceHL7



		for /F "tokens=3 delims=: " %%H in ('sc query "HL7 Processor 4" ^| findstr "        STATE"') do (
  			if /I "%%H" NEQ "RUNNING" (

				echo ==============================================================================
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					echo !fullstamp! : [ STATUS] : "HL7 Processor 4" IS STOPPED.
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				echo ==============================================================================
				echo.

				GOTO CheckCorepointIE

  			) else (

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] HL7 Processor 4 is running. Stopping service.
				echo ------------------------------------------------------------------------------
				echo.

				sc stop "HL7 Processor 4"

				timeout /T 3 /nobreak >NUL

			)
		)


:CheckCorepointIE

		echo ==============================================================================
			echo %fullstamp% : [ BEGIN ] Checking Current Status of Corepoint Integration Engine
		echo ==============================================================================
		echo.
		echo ..............................................................................
		echo ..............................................................................
		echo.


		for /F "tokens=3 delims=: " %%H in ('sc query "Corepoint Integration Engine" ^| findstr "        STATE"') do (
  			if /I "%%H" NEQ "RUNNING" (

				echo ==============================================================================
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					echo !fullstamp! : [ STATUS] : "Corepoint Integration Engine" IS STOPPED.
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				echo ==============================================================================
				echo.

				GOTO CheckCorepointIEAA

  			) else (

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Corepoint Integration Engine is running. Stopping service.
				echo ------------------------------------------------------------------------------
				echo.

				sc stop "Corepoint Integration Engine"

				timeout /T 3 /nobreak >NUL

			)
		)


: CheckCorepointIEAA

		echo ==============================================================================
			echo %fullstamp% : [ BEGIN ] Checking Current Status of Corepoint Integration Engine Assured Availability
		echo ==============================================================================
		echo.
		echo ..............................................................................
		echo ..............................................................................
		echo.


		for /F "tokens=3 delims=: " %%H in ('sc query "Corepoint Integration Engine Assured Availability" ^| findstr "        STATE"') do (
  			if /I "%%H" NEQ "RUNNING" (

				echo ==============================================================================
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					echo !fullstamp! : [ STATUS] : "Corepoint Integration Engine Assured Availability" IS STOPPED.
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				echo ==============================================================================
				echo.

				GOTO CheckMessageQueuing

  			) else (

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Corepoint Integration Engine Assured Availability is running. Stopping service.
				echo ------------------------------------------------------------------------------
				echo.

				sc stop "Corepoint Integration Engine Assured Availability"

				timeout /T 3 /nobreak >NUL

			)
		)



:CheckMessageQueuing


		echo ==============================================================================
			echo %fullstamp% : [ BEGIN ] Checking Current Status of Message Queuing
		echo ==============================================================================
		echo.
		echo ..............................................................................
		echo ..............................................................................
		echo.


		for /F "tokens=3 delims=: " %%H in ('sc query "Message Queuing" ^| findstr "        STATE"') do (
  			if /I "%%H" NEQ "RUNNING" (

				echo ==============================================================================
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					echo !fullstamp! : [ STATUS] : "Message Queuing" IS STOPPED.
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				echo ==============================================================================
				echo.

				GOTO StartServices

  			) else (

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Message Queuing is running. Stopping service.
				echo ------------------------------------------------------------------------------
				echo.

				sc stop "Message Queuing"

				timeout /T 3 /nobreak >NUL

			)
		)


:StartServices

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Starting Message Queuing.
				echo ------------------------------------------------------------------------------
				echo.

				sc start "Message Queuing"

				timeout /T 3 /nobreak >NUL



				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Starting Corepoint Integration Engine Assured Availability.
				echo ------------------------------------------------------------------------------
				echo.

				sc start "Corepoint Integration Engine Assured Availability"

				timeout /T 3 /nobreak >NUL


				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Starting HL7 Processor 4.
				echo ------------------------------------------------------------------------------
				echo.

				sc start "Corepoint Integration Engine"

				timeout /T 3 /nobreak >NUL


				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Starting HL7 Processor 4.
				echo ------------------------------------------------------------------------------
				echo.

				sc start "HL7 Processor 4"

				timeout /T 3 /nobreak >NUL

::===========================================================================================================
::-------[ TITLE 		]  : BATCH SCRIPT : MASTER : Restart GEMService - Weekly
::===========================================================================================================
::
::-------[ AUTHOR		]  : Roger Corley
::-------[ CREATED		]  : June 11, 2015 11:55:31 AM
::-------[ COPYRIGHT		]  : Common CENTS Solutions - 2015
::
::-------[ VERSION		]  : 1.10
::
::-----------------------------------------------------------------------------------------------------------
::
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

		set "gs=GEMService"


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
::
::
::===========================================================================================================
::-------[  BEGIN BATCH TASKS
::===========================================================================================================
::
::

		echo ==============================================================================
			echo %fullstamp% : [ BEGIN ] Checking Current Status of "%gs%"
		echo ==============================================================================
		echo.
		echo ..............................................................................
		echo ..............................................................................
		echo.


		for /F "tokens=3 delims=: " %%H in ('sc query "!gs!" ^| findstr "        STATE"') do (
  			if /I "%%H" NEQ "RUNNING" (

				echo ==============================================================================
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					echo !fullstamp! : [ STATUS] : "!gs!" IS STOPPED. Starting Service.
				echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				echo ==============================================================================
				echo.

   				sc start "!gs!"

  			) else (

				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] "!gs!" is running. Stopping service.
				echo ------------------------------------------------------------------------------
				echo.


				sc stop "!gs!"

				timeout /T 3


				echo.
				echo ------------------------------------------------------------------------------
					echo !fullstamp! : [ STATUS ] Restarting service.
				echo ------------------------------------------------------------------------------
				echo.

				sc start "!gs!"

				timeout /T 3


			)
		)

::=========================================================================================================
:Done
::=========================================================================================================


		echo ==============================================================================
			echo %fullstamp% : [ END ] Exiting Restart GEMService - Weekly
		echo ==============================================================================
		echo.
		echo.
		echo ******************************************************************************
		echo ******************************************************************************
		echo ******************************************************************************
		echo.
		echo.



