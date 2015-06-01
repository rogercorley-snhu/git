	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION


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


	set "ie1505=C:\GEM\ImportExport\ccded.1505"
	set "ieSav=C:\Gem\ImportExport\ccded.sav"

	set "arcSav=C:\GEM\ImportExport\archive\Archived-CCDED.1505\ccded.%logstamp%.sav"

	set "ftpSav=C:\iFtpSvc\mcdhdbsgems01\users\medcity\CCents\ccded.sav"
	set "ftp1505=C:\iFtpSvc\mcdhdbsgems01\users\medcity\CCents\ccded.1505"


	set "log=C:\GEM\ImportExport\DeliverExport.log"


	set "dots=.............................................................................."
	set "dashs=------------------------------------------------------------------------------------------------------------------------------------------------------------"
	set "ats=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

::========================================================================================================================================
::BEGIN BATCH PROCESSES
::========================================================================================================================================
::

::---------------------------------------------------------------------------------------------------------------------------------------
:testExist-Files
::---------------------------------------------------------------------------------------------------------------------------------------

	if not exist %ie1505% (
		goto msgError-FileNotFound
	)
	else (
		echo !dots! >> !log!
		echo !fullstamp! : [ CHECKFILE ] : Checking Exist : !ftpSav! >> !log!

		if exist !ftpSav! erase !ftpSav!
			goto msgFileFound-DeleteFile

:testExist-ftp1505
		echo !dots! >> !log!
		echo !fullstamp! : [ CHECKFILE ] : Checking Exist : !ftp1505! >> !log!

		if exist !ftp1505! ren !ftp1505! !ftpSav!
			goto msgFileFound-RenameFile-ftp1505
	)

	goto functionCopy-CCDED

::---------------------------------------------------------------------------------------------------------------------------------------
:functionCopy-CCDED
::---------------------------------------------------------------------------------------------------------------------------------------

 	copy %ie1505% C:\iFtpSvc\mcdhdbsgems01\users\medcity\CCents\ /y
		if errorlevel 1 goto msgError-FileCopyFailed

	goto testExist-CCDED

::---------------------------------------------------------------------------------------------------------------------------------------
:testExist-CCDED
::---------------------------------------------------------------------------------------------------------------------------------------
	if exist %ieSav% ren %arcSav%
::	 if exist c:\Gem\ImportExport\ccded.sav erase c:\Gem\ImportExport\ccded.sav

	goto functionRename-CCDED-1505

::---------------------------------------------------------------------------------------------------------------------------------------
:functionRename-CCDED-1505
::---------------------------------------------------------------------------------------------------------------------------------------
	 ren %ie1505% %ieSav%

::---------------------------------------------------------------------------------------------------------------------------------------
:finalCheck-CCDED-SAV
::---------------------------------------------------------------------------------------------------------------------------------------

	 if not exist %ieSav% (
		echo !dashs! >> !log!
		echo !ats! >> !log!
			echo !fullstamp! : [ FINAL-CHECKS : ERROR ] : '!ieSav!' NOT FOUND >> !log!
			echo !fullstamp! : [ FINAL-CHECKS : ERROR ] : Troubleshoot this issue. >> !log!
		echo !ats! >> !log!
		echo !dashs! >> !log!
		echo. >> !log!
	 )
	 else ( goto finalCheck-CCDED-1505-FTP)
	 else if not exist %ftp1505%(
		echo !dashs! >> !log!
		echo !ats! >> !log!
			echo !fullstamp! : [ FINAL-CHECKS : ERROR ] : '!ftp1505!' NOT FOUND >> !log!
			echo !fullstamp! : [ FINAL-CHECKS : ERROR ] : Troubleshoot this issue. >> !log!
		echo !ats! >> !log!
		echo !dashs! >> !log!
		echo. >> !log!
	 )

	 goto done

:msgSuccess
	echo %dashs% >> %log%
	echo %dashs% >> %log%
		echo %fullstamp% : [ SUCCESS ] : %ie1505% successfully delivered to iFtpSvc. >> %log%
		echo %fullstamp% : [ SUCCESS ] : Closing script processes. >> %log%
	echo %dashs% >> %log%
	echo %dashs% >> %log%

:msgError-FileCopyFailed
	echo %dashs% >> %log%
	echo %ats% >> %log%
		echo !fullstamp! : [ ERROR ] :  Failed to deliver %ie1505% file. Please troubleshoot issue. >> %log%
	echo %ats% >> %log%
	echo %dashs% >> %log%
	echo. >> %log%

	 goto done

:msgError-FileNotFound
	echo %dashs% >> %log%
	echo %ats% >> %log%
		echo %fullstamp% : [ TEST-EXIST : ERROR ] : '%file%' NOT FOUND >> %log%
		echo %fullstamp% : [ TEST-EXIST : ERROR ] : Ending script processes. >> %log%
	echo %ats% >> %log%
	echo %dashs% >> %log%
	echo. >> %log%

	goto done

:msgFileFound-DeleteFile
	echo %dots% >> %log%
		echo %fullstamp% : [ TEST-EXIST : ftpSav ] : '%ftpSav%' found. >> %log%
		echo %fullstamp% : [ TEST-EXIST : ftpSav ] : Deleting %ftpSav% >> %log%
	echo %dots% >> %log%

	goto testExist-ftp1505

:msgFileFound-RenameFile-ftp1505
	echo %dots% >> %log%
		echo %fullstamp% : [ TEST-EXIST : ftp1505 ] : '%ftp1505%' found. >> %log%
		echo %fullstamp% : [ TEST-EXIST : ftp1505 ] : Renaming %ftp1505% - %ftpSav% >> %log%
	echo %dots% >> %log%
	echo. >> %log%

	goto functionCopy-CCDED

:msgCopy-ie1505
	echo %dots% >> %log%
		echo %fullstamp% : [ IE1505 ] : Copying %ie1505% - %ftp1505% >> %log%
	echo %dots% >> %log%
	echo. >> %log%

	goto functionCopy-CCDED

:done
	 echo Bye Bye :)


