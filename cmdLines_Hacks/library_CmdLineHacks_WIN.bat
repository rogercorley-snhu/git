
::-------------------------------------------------------------------------------------------------------------------------------------
::  LIBARARY :: WINDOWS :: COMMAND LINE TRICKS & TIPS                                                                                        */
::-------------------------------------------------------------------------------------------------------------------------------------

::  SYSTEM INFO : SYSTEM UP-TIME
::===============================================================
::  LTE : WIN 2003
::---------------------------------------
    system info | find "Up Time" 

::  GTE : WIN 2008
::---------------------------------------
    system info | find "Boot" 


::  NETWORKING : PATHPING
::===============================================================
::  
    pathping <xxx.xxx.xxx.xxx>



::  SERVICES : TASKLIST : GTE WIN 07
::===============================================================
::  TASKLIST -M 
::  -------------------------------------
::  -- Displays with all DLLs associated
::  -- with tasks.
::---------------------------------------
    tasklist -m

::  TASKLIST -SVC 
::  -------------------------------------
::  -- Displays with services that support
::  -- each task.
::---------------------------------------
    tasklist -svc


::  SERVICES : TASKKILL
::===============================================================
::  TASKKILL -PID
::  -------------------------------------
::  --  Kills a task by its PID
::---------------------------------------
    taskkill -pid <processID#>

::  TASKKILL -IM
::  -------------------------------------
::  --  Kills a task by its Image Name
::---------------------------------------
    taskkill -im <iexplore.exe>


::  ACTIVE DIRECTORY : SEE WHICH SERVER AUTHENTICATED LOGGED IN USER
::===============================================================
    echo %logonserver%


::  ACTIVE DIRECTORY : SEE SEC GROUPS LOGGED IN USER BELONGS TO
::===============================================================
    whoami /groups 

::  ACTIVE DIRECTORY : VIEW DOMAIN ACCOUNT POLICIES
::===============================================================
    net accounts


::  SYSTEM : GENERATE TEXT SUMMARY OF SYSTEM
::===============================================================
    systeminfo | more


::  NETWORKING : NETSTAT WITH FINDSTR : Find a specific connection
::===============================================================
    netstat -ano | findstr <xxx.xxx.xxx.xxx>


::  SYSTEM : REBOOT SERVER
::===============================================================
    shutdown -r -f -t 0 -m \\localhost


::  SYSTEM :  Create a text file that displays when files
::            last accessed. Use it to determine which files can 
::            be deleted or archived to free up space.
::===============================================================
    dir /t:a /s /od >> list.txt [enter]


::  FILES : RECOVER READABLE DATA FROM A CORRUPT FILE 
::===============================================================
  recover filename.ext


::  BATCH TRICK : Pause a batch job for a period of time.
::===============================================================
  ping -n 10 127.0.0.1 > NUL 2>&1


::  IIS : RESTART IIS
::===============================================================
  iisreset


::  SERVICES TRICK :  STOP - START A SERVICE
::===============================================================
::-------------------------------------
::  Create a batch file to run repeated restarts
::-------------------------------------
  net stop %1 && net start %1


::  CMD LINE TRICK :  PIPE COMMAND RETURNS TO CLIPBOARD
::===============================================================
::-------------------------------------
::  GTE WIN 07
::-------------------------------------
  <command> | clip 

::  CMD LINE TRICK :  OUTPUT CONTENTS OF FILE TO CLIPBOARD
::===============================================================
::-------------------------------------
  echo text | clip 
        OR 
  clip < filename.txt
        OR 
  type filename.txt | clip 