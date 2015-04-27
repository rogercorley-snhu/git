	  @echo off
	  cls
	  setlocal ENABLEDELAYEDEXPANSION


::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::	BATCH FILE:		impEmployees_Master.bat
::
::=======================================================================================================
::
::  AUTHOR:       Roger Corley
::  CREATED:      04/24/2015  12:20 PM
::
::=======================================================================================================
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::-------------------------------------------------------------------------------------------------------


::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::             [ ****      			DO NOT MODIFY 'goto funcCONSTANTS'       			****  ]
::             [ ****  READ ALL INSTRUCTIONS BEFORE RUNNING BATCH FILE    		****  ]
::             [ ****  INSTRUCTIONS LOCATED IN funcCONTSTANTS AT END OF PAGE	****  ]
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::-------------------------------------------------------------------------------------------------------


::-------------------------------------------------------------------------------------------------------
::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::                  [ ****      DO NOT MODIFY IN THIS SECTION         ****  ]
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::-------------------------------------------------------------------------------------------------------
::
::
::=======================================================================================================
::	DATE CONSTANTS 
::=======================================================================================================

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

::=======================================================================================================
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::	'impfile' is the filename of the Import File WITHOUT the file extension.
::  -------------------------------------------------------------------------------------
	set "impfile=employee"
	set "archfile=%impfile%.%logstamp%" 
::
::  'log' is the variable for the full path-filename of the Import Job Log File. 
::  -------------------------------------------------------------------------------------
  set "log=%GEM_AIMP%_%impfile%.log01"
  set "logarch=%GEM_AIMP%LogArchives\"


::=======================================================================================================
::  ENVIRONMENT VARIABLES : Directories 
::=======================================================================================================
::  VERIFY all required Environment Variables have been created in System Properties
::  -- To verify, right-click 'My Computer', click 'Properties', select 'Advanced' tab ...
::  -- and click 'Environment Variables'. If they exist, you will see them in 'User variables for'.
::
::  IF ENVIRONMENT VARIABLES FOR GEM DON'T EXIST...
::  -- Create a batch file (.bat) named 'setEnvVar.bat'. Copy the set variables listed below
::  -- and paste them into the new .bat file. Save the .bat file in the GEM directory.
::  !! YOU MUST SAVE AND RUN THIS .BAT FILE FROM THE GEM ROOT DIRECTORY.
::  -- Run 'setEnvVar.bat' and click 'space' within the command line screen when prompted.
::  -- Verify that GEM environment variables now exist. 
::
::  -- You may now use the environment variables in place of the full path in this script.
::  !! When referencing a path using these variables, DO NOT PLACE A TRAILING SLASH ' \ ' in the script.
::  !! Using the trailing slash ' \ ' will cause an error!
::
::  -- example - CORRECT:   %GEM_IEX%employee.txt
::  -- example - INCORRECT: %GEM_IEX%\employee.txt
::
::-------------------------------------------------------------------------------------------------------
::  TO CREATE '.\GEM\setEnvVar.bat' 
::-------------------------------------------------------------------------------------------------------
::  -- Use this code to create the required batch file.
::  !! REMEMBER TO SAVE AND RUN THIS BATCH FILE FROM THE GEM DIRECTORY !!
::-------------------------------------------------------------------------------------------------------
::  
::  @echo off
::  
::  setx GEM %~dp0
::  setx GEM_IEX %~dp0ImportExport\
::  setx GEM_ARC %~dp0ImportExport\Archive\
::  setx GEM_AIMP %~dp0ImportExport\Archive\ImportEmployees\
::  setx GEM_BFILES %~dp0ImportExport\Archive\ImportEmployees\BadFiles\
::  
::  pause
::
::-------------------------------------------------------------------------------------------------------
::  ENVIRONMENT VARIABLES  
::-------------------------------------------------------------------------------------------------------
::  You may now reference these variables with the following.
::  Only use the %...% variable. Anything past the last % is just a reference to the directory.
::-------------------------------------------------------------------------------------------------------
::
::  %GEM% = 'currentDrive\GEM\'
::  %GEM_IEX% = 'currentDrive\GEM\ImportExport\'
::  %GEM_ARC% = 'currentDrive\GEM\ImportExport\Archive\'
::  %GEM_AIMP% = 'currentDrive\GEM\ImportExport\Archive\ImportEmployees\'
::  %GEM_BFILES% = 'currentDrive\GEM\ImportExport\Archive\ImportEmployees\BadFiles\'
::  
::=======================================================================================================
::  /ENVIRONMENT VARIABLES : Directories
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::
::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::                  [ ****       END DO NOT MODIFY SECTION            ****  ]
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::-------------------------------------------------------------------------------------------------------


::-----------------------------------------------------------------------
:scriptROTATIONS
::-----------------------------------------------------------------------

    echo ============================================================================== >> %log%
    echo %fullstamp% : [ ROTATELOGS ] BEGIN IMPORT LOG ROTATIONS >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%


		if exist %logarch%*.d08 del /f /q %logarch%*.d08
		if exist %logarch%*.log07 copy %logarch%*.log07 %logarch%*.log08
		if exist %logarch%*.log06 copy %logarch%*.log06 %logarch%*.log07
		if exist %logarch%*.log05 copy %logarch%*.log05 %logarch%*.log06
		if exist %logarch%*.log04 copy %logarch%*.log04 %logarch%*.log05
		if exist %logarch%*.log03 copy %logarch%*.log03 %logarch%*.log04
		if exist %logarch%*.log02 copy %logarch%*.log02 %logarch%*.log03


    echo %fullstamp% : [ ROTATELOGS ] Import Log Files Rotated Successfully >> %log%
    echo. >> %log%
  	echo %fullstamp% : [ ROTATELOGS ] %impfile%.log01 moved to \LogArchives. >> %log%
  	echo. >> %log%

    echo ============================================================================== >> %log%
    echo %fullstamp% : [ ROTATELOGS ] : IMPORT LOG ROTATIONS COMPLETE >> %log% 
    echo ============================================================================== >> %log%  
    echo. >> %log%
    echo .............................................................................. >> %log%
    echo .............................................................................. >> %log%
    echo. >> %log%


::=======================================================================================================
:Done
::=======================================================================================================
    echo ============================================================================== >> %log%
    echo %fullstamp% : [ ROTATELOGS ] Exiting Import Log Rotation Job >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%
    echo. >> %log%
    echo ****************************************************************************** >> %log%
    echo ****************************************************************************** >> %log%
    echo ****************************************************************************** >> %log%
    echo. >> %log%
    echo. >> %log%


  move %log% %GEM_AIMP%LogArchives\_%impfile%%logstamp%.log02

    echo. >> %log%
    echo %fullstamp% : [ NEWLOG ] New Import Log File Created. >> %log%
    echo. >> %log%
  

::=======================================================================================================
::  /Done
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



::=======================================================================================================
::  /BATCH
::=======================================================================================================
