clear


#-----[ Script Variables ]
#-------------------------------------------------------------------------------------------------


#-----[ Set variable to drive letter hosting GEM Directory ]
#-----[ e.g. If D:\GEM, then set archD to D: ]
#     ------------------------------------------------------

$archD = "E:"


#-----[ Log File Location ]
#-------------------------------------------------------------------------------------------------

$log = "%archD%\_Gem-Log-Archives\_Restart-GEMService.log"



#-----[ Log Formatting ]
#-------------------------------------------------------------------------------------------------

$equals = "=============================================================================="
$spaces = " "
$dashes = "------------------------------------------------------------------------------"
$dots = ".............................................................................."
$plus = "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$stars = "******************************************************************************"


#-----[ Log Message Variables ]
#-------------------------------------------------------------------------------------------------

$msgBegin = Log-Stamp + " : [ BEGIN ] Checking Current Status of GEMService. "
$msgRunning = Log-Stamp + " : [ STATUS ] GEMService is running. Stopping service."
$msgRestarting = Log-Stamp + " : [ STATUS ] Restarting service."
$msgError = Log-Stamp + " : [ STATUS : ERROR ] : GEMService IS STOPPED. Starting Service."
$msgExit = Log-Stamp + " : [ END ] Exiting Restart GEMService."


#-------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------
#-----[ BEGIN SCRIPT ]----------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------

Out-File -FilePath $log -Append -InputObject $equals
Out-File -FilePath $log -Append -InputObject $msgBegin
Out-File -FilePath $log -Append -InputObject $equals
Out-File -FilePath $log -Append -InputObject $spaces
Out-File -FilePath $log -Append -InputObject $dots
Out-File -FilePath $log -Append -InputObject $dots
Out-File -FilePath $log -Append -InputObject $spaces


#-----[ Gather GEMService Information ]
#-------------------------------------------------------------------------------------------------
$gs = get-service GEMService


#-----[ Check Service Status and Start/Restart Actions ]
#-------------------------------------------------------------------------------------------------

if ($gs.Status -eq "Running") {

    Out-File -FilePath $log -Append -InputObject $spaces
    Out-File -FilePath $log -Append -InputObject $dashes
    Out-File -FilePath $log -Append -InputObject $msgRunning
    Out-File -FilePath $log -Append -InputObject $dashes
    Out-File -FilePath $log -Append -InputObject $spaces

    Write-Host "GEMService is running. Restarting service."

    Restart-Service GEMService
}

else {

    Out-File -FilePath $log -Append -InputObject $equals
    Out-File -FilePath $log -Append -InputObject $plus
    Out-File -FilePath $log -Append -InputObject $msgError
    Out-File -FilePath $log -Append -InputObject $plus
    Out-File -FilePath $log -Append -InputObject $equals
    Out-File -FilePath $log -Append -InputObject $spaces

    Write-Host "GEMService IS STOPPED. Starting service."

    Start-Service GEMService
}



    Out-File -FilePath $log -Append -InputObject $equals
    Out-File -FilePath $log -Append -InputObject $msgExit
    Out-File -FilePath $log -Append -InputObject $equals
    Out-File -FilePath $log -Append -InputObject $spaces
    Out-File -FilePath $log -Append -InputObject $spaces
    Out-File -FilePath $log -Append -InputObject $stars
    Out-File -FilePath $log -Append -InputObject $stars
    Out-File -FilePath $log -Append -InputObject $stars
    Out-File -FilePath $log -Append -InputObject $spaces
    Out-File -FilePath $log -Append -InputObject $spaces



#  *****  FUNCTIONS  *****
#------------------------------------------------------------------

function Gem-Stamp ( $StampType ) {

    Switch ($StampType) {
        date { Get-Date; break }
        dStamp { Get-Date -Format "yyyy-MM-dd"; break }
        time { Get-Date -Format "HH:mm:ss"; break }
        logStamp { Get-Date -Format "yyyy-MM-dd HH:mm:ss";break }
    }
}


function Log-Stamp {
    $ldt = Gem-Stamp logstamp
    $ldt
}