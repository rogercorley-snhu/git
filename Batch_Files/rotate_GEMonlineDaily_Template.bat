	@echo off
  cls
  setlocal ENABLEDELAYEDEXPANSION


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
::                  [ ****       DATE CONSTANTS : DO NOT MODIFY       ****  ]
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
::
::
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
::  -- example - CORRECT:   %GIMPEXP%employee.txt
::  -- example - INCORRECT: %GIMPEXP%\employee.txt
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
::  setx GIMPEXP %~dp0ImportExport\
::  setx GARCH %~dp0ImportExport\Archive\
::  setx GIMPEMP %~dp0ImportExport\Archive\ImportEmployees\
::  setx GBAD %~dp0ImportExport\Archive\ImportEmployees\BadFiles\
::  setx GSCRIPTS %~dp0ImportExport\_Scripts\
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
::  %GIMPEXP% = 'currentDrive\GEM\ImportExport\'
::  %GARCH% = 'currentDrive\GEM\ImportExport\Archive\'
::  %GIMPEMP% = 'currentDrive\GEM\ImportExport\Archive\ImportEmployees\'
::  %GBAD% = 'currentDrive\GEM\ImportExport\Archive\ImportEmployees\BadFiles\'
::  %GSCRIPTS% = 'currentDrive\GEM\ImportExport\_Scripts\'
::
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

::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::                  [ ****  MODIFY VARIABLE VALUES AS NEEDED          ****  ]
::                  [ ****  READ ALL INSTRUCTIONS BEFORE MODIFYING    ****  ]
::                  [ ****  DO NOT REORDER VARIABLE POSITIONS         ****  ]
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::-------------------------------------------------------------------------------------------------------
::
::
::=======================================================================================================
::  CONFIGURE VARIABLES : ENVIRONMENT : Filenames
::=======================================================================================================

::  'Gtype' MUST match the GEMonline log file type, located in C:\ 
::  'Dtype' MUST match the Daily log file type, located in C:\
::  -------------------------------------------------------------------------------------
  set "glog=gemonline"
  set "gpath=%HOMEDRIVE%%glog%.log"

  set "dlog=daily"  
  set "dpath=%HOMEDRIVE%%dlog%.cp"

  set "apath=%HOMEDRIVE%_GEMlogs\"

::-----------------------------------------------------------------------
:FileRotations
::-----------------------------------------------------------------------
		if exist %apath%*.log08 del /f /q %apath%*.log08
		if exist %apath%*.log07 copy %apath%*.log07 %apath%*.log08
		if exist %apath%*.log06 copy %apath%*.log06 %apath%*.log07
		if exist %apath%*.log05 copy %apath%*.log05 %apath%*.log06
		if exist %apath%*.log04 copy %apath%*.log04 %apath%*.log05
		if exist %apath%*.log03 copy %apath%*.log03 %apath%*.log04
		if exist %apath%*.log02 copy %apath%*.log02 %apath%*.log03
		if exist %apath%*.log01 copy %apath%*.log01 %apath%*.log02

		if exist %gpath% move %gpath% %apath%%glog%.log01


		if exist %apath%*.cp08 del /f /q %apath%*.cp08
		if exist %apath%*.cp07 copy %apath%*.cp07 %apath%*.cp08
		if exist %apath%*.cp06 copy %apath%*.cp06 %apath%*.cp07
		if exist %apath%*.cp05 copy %apath%*.cp05 %apath%*.cp06
		if exist %apath%*.cp04 copy %apath%*.cp04 %apath%*.cp05
		if exist %apath%*.cp03 copy %apath%*.cp03 %apath%*.cp04
		if exist %apath%*.cp02 copy %apath%*.cp02 %apath%*.cp03
		if exist %apath%*.cp01 copy %apath%*.cp01 %apath%*.cp02

		if exist %dpath% move %dpath% %apath%%dlog%.cp01

