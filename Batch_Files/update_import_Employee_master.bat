bbbbb  @echo off
  cls
  setlocal ENABLEDELAYEDEXPANSION


::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::                  [ ****      DO NOT MODIFY THIS SECTION         ****  ]
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
::  -- example - CORRECT:   %GEM_AIMP%employee.txt
::  -- example - INCORRECT: %GEM_AIMP%\employee.txt
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

::  'fileType' MUST match the demographic import file type.
::  'tmpType' is a constant used in funcRemoveHeader. DO NOT MODIFY.
::  -------------------------------------------------------------------------------------
  set "fileType=txt"
  set "tmpType=tmp"

::  'impFile' MUST match the demographic file name WITHOUT file extension.
::  'impFull' is the full filename of 'impFile' WITH file extension.
::  -------------------------------------------------------------------------------------
  set "impFile=employee"
  set "impFull=%impFile%.%fileType%"

::  'impPath' is the full path and file name of the demographic file WITH file extension.
::  'tmpPath' is the full path-filename of the temporary file created in funcRemoveHeader
::  -------------------------------------------------------------------------------------
  set "impPath=%GEM_IEX%%impFile%.%fileType%"
  set "tmpPath=%GEM_IEX%%impFile%.%tmpType%"

::  'archFull' is the variable for the full archive file name WITHOUT file extension.
::  'archPath' is the variable for the full path-filename of 'archFull' WITHOUT file extension
::  -------------------------------------------------------------------------------------
  set "archFull=%impFile%.%logstamp%"
  set "archPath=%GEM_AIMP%%archFull%"
  set "log=%GEM_AIMP%_%impFile%.log01"

::  'badfile' is the variable for the full corrupt file name WITHOUT file extension.
::  'badPath' is the variable for the full path-filename of 'badfile' WITHOUT file extension
::  -------------------------------------------------------------------------------------
  set "badFull=bad.%impFile%.%logstamp%"
  set "badPath=%GEM_BFILES%%badFull%"
  set "badLog=%GEM_BFILES%_%impFile%.log01"

::  Set 'exp_num_lines' value to the minimum number of expected lines in the demographic file.
::  -------------------------------------------------------------------------------------
  set "exp_num_lines=10"

::=======================================================================================================
::  /CONFIGURE VARIABLES : ENVIRONMENT : Filenames
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::=======================================================================================================
::  CONFIGURE VARIABLES : SQL SERVER : IMPORT SCRIPT
::=======================================================================================================

::  MUST match sModule in SQL table cfgScriptParams
::  -------------------------------------------------------------------------------------
  set "module=170"

::  "SQLNAME=sqlservername" MUST be enclosed wihtin double-quotes ( "SQLNAME=xxxxx" )
::  -------------------------------------------------------------------------------------
::  !! If using local for SQL Server name, set variable to "SQLNAME=(local)" - Parenthesis are REQUIRED !!
::-------------------------------------------------------------------------------------------------------
  set "sqlname=OK1568PCIDB"

::=======================================================================================================
::  /CONFIGURE VARIABLES : SQL SERVER : IMPORT SCRIPT
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



::-------------------------------------------------------------------------------------------------------
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
::                  [ ****  DO NOT MODIFY ANYTHING PAST THIS SECTION  ****  ]
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::-------------------------------------------------------------------------------------------------------
::
::
::=======================================================================================================
::  BEGIN BATCH TASKS
::=======================================================================================================
::
::
::=======================================================================================================
:Begin_Import_Job
::=======================================================================================================
    echo ============================================================================== >> %log%
    echo %fullstamp% : [ BEGIN ] Importing %impFull% >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%
    echo .............................................................................. >> %log%
    echo .............................................................................. >> %log%
    echo. >> %log%


::=======================================================================================================
:testImportFileExists
::=======================================================================================================
    echo ============================================================================== >> %log%
    echo %fullstamp% : [ CHECK ] BEGIN FUNCTION: CHECK FILES EXISTS >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%

  if exist %impPath% (
    echo !fullstamp! : [ CHECK ] : '!impFull!' found. >> !log!
    echo. >> !log!
    echo ============================================================================== >> !log!
    echo !fullstamp! : [ CHECK ] : CLOSE FUNCTION: CHECK FILES EXISTS  >> !log!
    echo ============================================================================== >> !log!
    echo. >> !log!
    echo .............................................................................. >> !log!
    echo .............................................................................. >> !log!
    echo. >> !log!
    goto funcRemoveHeader
    ) else (
    echo ============================================================================== >> !log!
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
    echo !fullstamp! : [ CHECK : ERROR ] : '!impFull!' NOT FOUND >> !log!
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
    echo ============================================================================== >> !log!
    echo. >> !log!
    )

  goto Done

::=======================================================================================================
::  /CHK_ImportFileExist
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::=======================================================================================================
:funcRemoveHeader
::=======================================================================================================

    echo ============================================================================== >> %log%
    echo %fullstamp% : [ HEADER ] BEGIN FUNCTION: REMOVE HEADER >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%

  for /f "skip=1 delims=*" %%a in (%impPath%) do (
    echo %%a >> %tmpPath%
  )

  xcopy %tmpPath% %impPath% /y
  del %tmpPath% /f /q

    echo. >> %log%
    echo %fullstamp% : [ HEADER ] Header row removed from %impFull%. >> %log%
    echo. >> %log%

    echo ============================================================================== >> %log%
    echo %fullstamp% : [ HEADER ] END FUNCTION: REMOVE HEADER >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%

goto funcLineCount

::=======================================================================================================
::  /funcRemoveHeader
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



::=======================================================================================================
:funcLineCount
::=======================================================================================================

    echo ============================================================================== >> %log%
    echo %fullstamp% : [ COUNT ] BEGIN : FUNCTION: Line Count >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%

    echo %fullstamp% : [ COUNT ] Counting Number Of Lines In '%impFull%' >> %log%

  set /p =COUNT: < nul
  for /f %%C in ('Find /V /C "" ^< %impPath%') do set COUNT=%%C

    echo %fullstamp% : [ COUNT ] %impFull% has %COUNT% lines. >> %log%

  if %COUNT% GTR %exp_num_lines% (
    echo. >> !log!
    echo ============================================================================== >> !log!
    echo !fullstamp! : [ COUNT ] END : FUNCTION: Line Count >> !log!
    echo ============================================================================== >> !log!
    echo. >> !log!
    echo .............................................................................. >> !log!
    echo .............................................................................. >> !log!

    goto funcSQLImport
    ) else (

    echo. >> !log!
    echo ============================================================================== >> !log!
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
    echo !fullstamp! [ BADFILE ] : IMPORT FILE : LINE COUNT >> !log!
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> !log!
    echo ============================================================================== >> !log!
    echo. >> !log!
    echo !fullstamp! : [ BADFILE ] : Line Count Test - FAILED. >> !log!
    echo !fullstamp! : [ BADFILE ] : '!impFull!' contains !COUNT! lines. >> !log!
    echo !fullstamp! : [ BADFILE ] : Expecting !exp_num_lines! lines minimum. >> !log!
    echo !fullstamp! : [ BADFILE ] : Archiving to '\ImportEmployees\badarch' >> !log!
    echo. >> !log!
    )

  goto funcBadFile

::=======================================================================================================
::  /funcLineCount
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::=======================================================================================================
:funcSQLImport
::=======================================================================================================
    echo. >> %log%
    echo ============================================================================== >> %log%
    echo %fullstamp% : [ IMPORT ] Begin SQL Import Module : '%impFull%' >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%

    echo %fullstamp% : [ IMPORT ] Starting SQL Import >> %log%



::  %GEM%runscript script=Import_v1_70.gsf,pw=gemie,svr=%sqlname%,core=1,module=%module%,include=gsf.txt

    echo %fullstamp% : [ IMPORT ] SQL Import successful. >> %log%
    echo.>> %log%


    echo ============================================================================== >> %log%
    echo %fullstamp% : [ IMPORT ] Exiting SQL Import Module >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%
    echo .............................................................................. >> %log%
    echo .............................................................................. >> %log%
    echo. >> %log%
  goto funcArchive

::=======================================================================================================
::  /funcSQLImport
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::=======================================================================================================
:funcArchive
::=======================================================================================================
    echo ============================================================================== >> %log%
    echo %fullstamp% : [ ARCHIVE ] Begin Archive File Rotations >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%


  if exist %GEM_AIMP%.d08 del /Q %GEM_AIMP%.d08
  if exist %GEM_AIMP%*.d07 copy %GEM_AIMP%*.d07 %GEM_AIMP%*.d08
  if exist %GEM_AIMP%*.d06 copy %GEM_AIMP%*.d06 %GEM_AIMP%*.d07
  if exist %GEM_AIMP%*.d05 copy %GEM_AIMP%*.d05 %GEM_AIMP%*.d06
  if exist %GEM_AIMP%*.d04 copy %GEM_AIMP%*.d04 %GEM_AIMP%*.d05
  if exist %GEM_AIMP%*.d03 copy %GEM_AIMP%*.d03 %GEM_AIMP%*.d04
  if exist %GEM_AIMP%*.d02 copy %GEM_AIMP%*.d02 %GEM_AIMP%*.d03
  if exist %GEM_AIMP%*.d01 copy %GEM_AIMP%*.d01 %GEM_AIMP%*.d02


    echo %fullstamp% : [ ARCHIVE ] Archived Files Rotated Successfully >> %log%


  move %impPath% %archPath%.d01

    echo %fullstamp% : [ ARCHIVE ] '%impFull%' -- '%archFull%' >> %log%
    echo. >> %log%

    echo ============================================================================== >> %log%
    echo %fullstamp% : [ ARCHIVE ] : Employee File Archive Complete >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%
    echo .............................................................................. >> %log%
    echo .............................................................................. >> %log%
    echo. >> %log%
  goto Done

::=======================================================================================================
::  /funcArchive
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::=======================================================================================================
:funcBadFile
::=======================================================================================================

::-------------------------------------------------------------------------------------------------------
::  ERROR MSG : BAD LOG FILE
::-------------------------------------------------------------------------------------------------------

    echo ============================================================================== >> %badLog%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %badLog%
    echo %fullstamp% : ERROR : IMPORT FILE : LINE COUNT >> %badLog%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %badLog%
    echo ============================================================================== >> %badLog%
    echo. >> %badLog%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %badLog%
    echo %fullstamp% : [ BADFILE ] : Line Count Test - FAILED. >> %badLog%
    echo %fullstamp% : [ BADFILE ] : '%impFull%' contains %COUNT% lines. >> %badLog%
    echo %fullstamp% : [ BADFILE ] : Expecting %exp_num_lines% lines minimum. >> %badLog%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %badLog%
    echo. >> %badLog%


::-------------------------------------------------------------------------------------------------------

    echo ------------------------------------------------------------------------------ >> %log%
    echo %fullstamp% : [ BADFILE ] Begin Archived Corrupt File Rotations >> %log%
    echo ------------------------------------------------------------------------------ >> %log%
    echo. >> %log%

    ::-----------------------------------------------------------------------------------------------

    echo ------------------------------------------------------------------------------ >> %badLog%
    echo %fullstamp% : [ BADFILE ] Begin Archived Corrupt File Rotations >> %badLog%
    echo ------------------------------------------------------------------------------ >> %badLog%
    echo. >> %badLog%

::-------------------------------------------------------------------------------------------------------

  if exist %badPath%*.d08 del /Q %badPath%*.d08
  if exist %badPath%*.d07 copy %badPath%*.d07 %badPath%*.d08
  if exist %badPath%*.d06 copy %badPath%*.d06 %badPath%*.d07
  if exist %badPath%*.d05 copy %badPath%*.d05 %badPath%*.d06
  if exist %badPath%*.d04 copy %badPath%*.d04 %badPath%*.d05
  if exist %badPath%*.d03 copy %badPath%*.d03 %badPath%*.d04
  if exist %badPath%*.d02 copy %badPath%*.d02 %badPath%*.d03
  if exist %badPath%*.d01 copy %badPath%*.d01 %badPath%*.d02

::-------------------------------------------------------------------------------------------------------

    echo %fullstamp% : [ BADFILE ] Archived corrupt files rotation successful. >> %log%

    ::-----------------------------------------------------------------------------------------------

    echo %fullstamp% : [ BADFILE ] Archived corrupt files rotation successful. >> %badLog%

::-------------------------------------------------------------------------------------------------------

  move %impPath% %badPath%.d01

::-------------------------------------------------------------------------------------------------------


    echo %fullstamp% : [ BADFILE ] Archived corrupt %impFull%. >> %log%
    echo. >> %log%
    echo ------------------------------------------------------------------------------ >> %badLog%

    ::-----------------------------------------------------------------------------------------------

    echo %fullstamp% : [ BADFILE ] Archived corrupt %impFull%. >> %badLog%
    echo. >> %badLog%
    echo ------------------------------------------------------------------------------ >> %badLog%
    echo. >> %badLog%

::-------------------------------------------------------------------------------------------------------

    echo ============================================================================== >> %log%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
    echo %fullstamp% : [ BADFILE ] Exiting Bad File Processes  >> %log%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%
    echo .............................................................................. >> %log%
    echo .............................................................................. >> %log%
    echo. >> %log%


::-------------------------------------------------------------------------------------------------------

    echo ============================================================================== >> %badLog%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %badLog%
    echo %fullstamp% : [ BADFILE ] Exiting Bad File Processes >> %badLog%
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %badLog%
    echo ============================================================================== >> %badLog%
    echo. >> %badLog%
    echo .............................................................................. >> %badLog%
    echo .............................................................................. >> %badLog%
    echo. >> %badLog%

  goto Done

::=======================================================================================================
::  /funcBadFile
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


::=======================================================================================================
:Done
::=======================================================================================================
    echo ============================================================================== >> %log%
    echo %fullstamp% : [ END ] Exiting Master Employee Import Job >> %log%
    echo ============================================================================== >> %log%
    echo. >> %log%
    echo. >> %log%
    echo ****************************************************************************** >> %log%
    echo ****************************************************************************** >> %log%
    echo ****************************************************************************** >> %log%
    echo. >> %log%
    echo. >> %log%

::=======================================================================================================
::  /Done
::=======================================================================================================
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



::=======================================================================================================
::  /BEGIN BATCH TASKS
::=======================================================================================================

