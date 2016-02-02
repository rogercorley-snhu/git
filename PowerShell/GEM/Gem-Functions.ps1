#   LAST UPDATE:    01/22/2016  -- RC


$sysD = "$env:HOMEDRIVE"
$gemD = "$env:GEM"


$toolsD = "$sysD\_Gem-Toolbox"
$glaD = "$sysD\_Gem-Log-Archives"

$batD = "$toolsD\Batch-Files"

$psD = "$toolsD\PowerShell"
$psfD = "$psD\Functions"

$gdefD = "$gemD\Defs"
$glogD = "$gemD\Logs"

$ieD = "$gemD\ImportExport"
$ieaD = "$gemD\ImportExport\Archive"
$iempD = "$gemD\ImportExport\Archive\Import-Employees-Archive"

$iesD = "$gemD\ImportExport\_Scripts"
$iesgD = "$gemD\ImportExport\_Scripts\Good-Records"
$iesbD = "$gemD\ImportExport\_Scripts\Bad-Records"
$ieslD = "$gemD\ImportExport\_Scripts\_Logs"


#  Set-Aliases
#---------------------------------------------------------------------------------------------------------------

Set-Alias gemmonitor Gem-Monitor
Set-Alias gemmon Gem-Monitor
Set-Alias gmon Gem-Monitor
Set-Alias gemon Gem-Monitor
Set-Alias gemm Gem-Monitor
Set-Alias monitor Gem-Monitor

Set-Alias geminfo Gem-Info
Set-Alias ginfo Gem-Info
Set-Alias gemi Gem-Info
Set-Alias info Gem-Info

Set-Alias gdrives Gem-Drive-Info
Set-Alias gdrive Gem-Drive-Info
Set-Alias gdinfo Gem-Drive-Info
Set-Alias gdi Gem-Drive-Info
Set-Alias gemdrive Gem-Drive-Info
Set-Alias gemdrives Gem-Drive-Info
Set-Alias gemdi Gem-Drive-Info
Set-Alias driveinfo Gem-Drive-Info
Set-Alias dinfo Gem-Drive-Info
Set-Alias di Gem-Drive-Info

Set-Alias gcd Gem-Cd
Set-Alias gemcd Gem-Cd

Set-Alias refresh Gem-Refresh
Set-Alias grefresh Gem-Refresh
Set-Alias gemrefresh Gem-Refresh
Set-Alias gref Gem-Refresh
Set-Alias gemr Gem-Refresh
Set-Alias gfresh Gem-Refresh

Set-Alias gstart Gem-Check-Service
Set-Alias gemstart Gem-Check-Service
Set-Alias gem-start Gem-Check-Service
Set-Alias grestart Gem-Check-Service
Set-Alias gemrestart Gem-Check-Service
Set-Alias gem-restart Gem-Check-Service


#  Gem-Refresh-PowerShell
#---------------------------------------------------------------------------------------------------------------

function Gem-Refresh {

    Set-Location C:\_Gem-Toolbox\PowerShell\Functions

    & ".\Gem-Functions.ps1"

}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Monitor {

        Get-Content C:\gemonline.log -wait
}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------
function Gem-Cd ($dir) {


    $list = {
                    'gem = GEM Directory',
                    'glad = Gem-Log-Archives Directory',
                    'gdef = GEM Defs Directory',
                    'gdefs = GEM Defs Directory',
                    'defs = GEM Defs Directory',
                    'glog = GEM Logs Directory',
                    'imp = GEM ImportExport Directory',
                    'gimp = GEM ImportExport Directory',
                    'impexp = GEM ImportExport Directory',
                    'impexparc = GEM ImpExp Archive Directory',
                    'ixarc = GEM ImpExp Archive Directory',
                    'impemparc = GEM Import-Employees-Archives Directory',
                    'iearc = GEM Import-Employees-Archives Directory',
                    'gtb = GEM-Toolbox Directory',
                    'tools = GEM-Toolbox Directory',
                    'gemtools = GEM-Toolbox Directory',
                    'toolbox = GEM-Toolbox Directory',
                    'psd = GEM PowerShell Directory',
                    'gemps = GEM PowerShell Directory',
                    'gempsd = GEM PowerShell Directory',
                    'gps = GEM PowerShell Directory',
                    'gpsd = GEM PowerShell Directory',
                    'gempsf = GEM PowerShell Functions Directory',
                    'gpsfd = GEM PowerShell Functions Directory',
                    'psf = GEM PowerShell Functions Directory',
                    'psfd = GEM PowerShell Functions Directory',
                    'functions = GEM PowerShell Functions Directory',
                    'batd = GEM Batch-Files Directory',
                    'bat = GEM Batch-Files Directory',
                    'gembat = GEM Batch-Files Directory',
                    'gembatd = GEM Batch-Files Directory',
                    'user = Current UserProfile Directory',
                    'desk = User Desktop',
                    'docs = Current UserProfile Documents Directory',
                    'pspro = Current User PowerShell Profile Directory',
                    'psprofile = Current User PowerShell Profile Directory'
            }

  Switch ($dir) {

    gem { sl "$env:GEM"; break }

    gologs { sl "$env:SystemDrive\_Gem-Log-Archives"; break }
    glad { sl "$env:SystemDrive\_Gem-Log-Archives"; break }

    gdef { sl "$env:GEM\Defs"; break }
    gdefs { sl "$env:GEM\Defs"; break }
    def { sl "$env:GEM\Defs"; break }
    defs { sl "$env:GEM\Defs"; break }

    glog { sl "$env:GEM\Log"; break }
    gemlog { sl "$env:GEM\Log"; break }

    imp { sl "$env:GEM\ImportExport"; break }
    gimp { sl "$env:GEM\ImportExport"; break }
    impexp { sl "$env:GEM\ImportExport"; break }

    impemparc { sl "$env:GEM\ImportExport\Archive\Import-Employees-Archives"; break }
    iearc { sl "$env:GEM\ImportExport\Archive\Import-Employees-Archives"; break }

    gtb { sl "$sysD\_Gem-Toolbox"; break }
    tools { sl "$sysD\_Gem-Toolbox"; break }
    gemtools { sl "$sysD\_Gem-Toolbox"; break }
    toolbox { sl "$sysD\_Gem-Toolbox"; break }

    psd { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gemps { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gempsd { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gps { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gpsd { sl "$sysD\_Gem-Toolbox\PowerShell"; break }

    gempsf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    gpsf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    psf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    psfd { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    functions { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }

    bat { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }
    batd { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }
    gembat { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }
    gembatd { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }


    user { sl "$env:UserProfile"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    docs { sl "$env:UserProfile\Documents"; break }

    psprofile { sl "$env:UserProfile\Documents\WindowsPowershell"; break }
    pspro { sl "$env:UserProfile\Documents\WindowsPowershell"; break }

    default { $list; break }
  }
} #  [ END ] : Gem-Cd


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Info {

Clear-Host

#---------------------------------------------------------------------------------------------------------------
$mc = $ENV:COMPUTERNAME


# Header / Footer
#-------------------------------------------------------
$header = "-----------------------[ START GET INFOMATION ]---------------------------"
$footer = "-----------------------[  END GET INFOMATION  ]---------------------------"

# Formatting
#-------------------------------------------------------
$dash = "-------------------------------------------------------------------------"
$space = " "

#
#================================================================================================
#--CONSTANTS
#================================================================================================

# ComputerSystem Info
#-------------------------------------------------------
$CompInfo = Get-WmiObject Win32_ComputerSystem -comp $mc

#OS Info
#-------------------------------------------------------
$Os = Get-WmiObject Win32_OperatingSystem -comp $mc

#BIOS Info
#-------------------------------------------------------
$Bios = Get-WmiObject Win32_BIOS -comp $mc

#CPU Info
#-------------------------------------------------------
$Proc = Get-WmiObject Win32_Processor -comp $mc

# GEMpay Info
#-------------------------------------------------------
$gem = Get-WmiObject Win32_service | Where-Object { $_.name -like "GEMservice" }

#
#================================================================================================
#--OBJECTS
#================================================================================================
#

#Create Custom Objects
$myobj = "" | Select-Object Name,Domain,Model,MachineSN,OS,ServicePack,WindowsSN,Uptime,RAM,Disk,LastReboot

# Computer Name
#-------------------------------------------------------
$myobj.Name = $CompInfo.Name

# Domain Name
#-------------------------------------------------------
$myobj.Domain = $CompInfo.Domain


# Computer Model
#-------------------------------------------------------
$myobj.Model = $CompInfo.Model


# Computer Serial Number
#-------------------------------------------------------
$myobj.MachineSN = $Bios.SerialNumber

# Operating System Version
#-------------------------------------------------------
$myobj.OS = $Os.Caption

# Service Pack Version
#-------------------------------------------------------
$myobj.ServicePack = $Os.servicepackmajorversion

# Computer Uptime Calculations
#-------------------------------------------------------
$myobj.uptime = (Get-Date)-[System.DateTime]::ParseExact($Os.LastBootUpTime.Split(".")[0],'yyyyMMddHHmmss',$null)
$myobj.uptime = "$($myobj.uptime.Days) days, $($myobj.uptime.Hours) hours," + " $($myobj.uptime.Minutes) minutes"

# Computer Memory Calculations
#-------------------------------------------------------
$myobj.RAM = "{0:n2} GB" -f ($CompInfo.TotalPhysicalMemory/1gb)

# Computer Drive Info
#-------------------------------------------------------
$myobj.Disk = Gem-Drive-Info $mc

# Computer Last Reboot Date/Time
#-------------------------------------------------------
$myobj.LastReboot = Get-LastBootTime

#
#================================================================================================
#--SCREEN
#================================================================================================
#

# Clear Screen
#-------------------------------------------------------
#Clear-Host

# WRITE : Header
#-------------------------------------------------------
Write-Host $space
Write-Host $header -ForegroundColor Yellow
Write-Host $space
Write-Host $space

# WRITE : Computer / Network Info
#-------------------------------------------------------
Write-Host "Computer / Domain Info" -ForegroundColor Yellow
Write-Host "--------------------------------------------"
Write-Host "Server:`t`t" $myobj.Name
Write-Host "Domain:`t`t" $myobj.Domain
Write-Host "Server Model:`t" $myobj.Model
$space

# WRITE : Operating System Info
#-------------------------------------------------------
Write-Host "Operating System Info" -ForegroundColor Yellow
Write-Host "--------------------------------------------"
Write-Host "OS Version:`t" $myobj.OS
Write-Host "Service Pack:`t" $myobj.ServicePack
$space

# WRITE : Uptime Info
#-------------------------------------------------------
Write-Host "System Uptime Info" -ForegroundColor Yellow
Write-Host "--------------------------------------------"
Write-Host "Last Reboot:`t" $myobj.LastReboot
Write-Host "`t`t" $myobj.uptime
$space

# WRITE : RAM Info
#-------------------------------------------------------
Write-Host "System Memory Info" -ForegroundColor Yellow
Write-Host "--------------------------------------------"
Write-Host "Total RAM (GB):`t" $myobj.RAM
$space

# WRITE : Drive Info
#-------------------------------------------------------
Write-Host "System Disk Info" -ForegroundColor Yellow
Write-Host "--------------------------------------------"
$myobj.Disk
$space

# WRITE : GEM Application Info
#-------------------------------------------------------
Write-Host "GEM Application Info" -ForegroundColor Yellow
Write-Host "--------------------------------------------"
$space

Write-Host "Application: `t" $gem.Name -ForegroundColor Yellow
Write-Host "............................................" -ForegroundColor Yellow
$gemtext = "Logon As: `t {0} `nProcessID: `t {1} `nStartMode: `t {2} `nState: `t`t {3} `nStatus: `t {4}" -f $gem.StartName,
$gem.ProcessID,$gem.StartMode,
$gem.State,$gem.Status

$gemtext

$space

# WRITE : Footer
#-------------------------------------------------------
Write-Host $space
Write-Host $space
Write-Host $footer -ForegroundColor Yellow
Write-Host $space
Write-Host $space

$space
$space
Read-Host "Press the [ ENTER ] key to exit script."
$space
$space
#---------------------------------------------------------------------------------------------------------------
}  #End function Gem-Info



#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#



function Gem-Drive-Info {
#---------------------------------------------------------------------------------------------------------------
$comp = $ENV:COMPUTERNAME

# Get Disk Sizes
#-------------------------------------------------------
$logicalDisk = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $comp

# Calculate Disk Info
#-------------------------------------------------------
foreach ($disk in $logicalDisk)
{
    $diskObj = "" | Select-Object Disk,Size,FreeSpace,Percent
    $diskObj.Disk = $disk.DeviceID
    $diskObj.Size = "{0:n0} GB" -f (( $disk | Measure-Object -Property Size -sum).sum/1gb)
    $diskObj.FreeSpace = "{0:n0} GB" -f (( $disk | Measure-Object -Property FreeSpace -sum).sum/1gb)
    $diskObj.Percent = "{0:n0}%" -f ( $PercentFree = [Math]::round((($disk.FreeSpace/$disk.Size) * 100)) )


# Format Disk Info
#-------------------------------------------------------
    $text = "{0}`t[Drive Size]`t{1}`n`t[Free Space]`t{2}`n`t[Percent Free]`t{3}%`n" -f $diskObj.Disk,$diskObj.size,
$diskObj.FreeSpace,$PercentFree
    $msg += $text + [char]13 + [char]10
}

$msg
#---------------------------------------------------------------------------------------------------------------
}  #End function Gem-Drive-Info



#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#



function Gem-Check-Service{

    param($ServiceName)

        $arrService = Get-Service -Name $ServiceName

        $feq = "===================================================================="
        $fline = " --------------------------------------------------------------------"
        $fspace = "                        "


        $fspace
        $feq
        $fspace
        $fspace

#       CHECK SERVICE STATE AND EITHER START OR RESTART SERVICE
#---------------------------------------------------------------------


#       IF SERVICE IS STOPPED - START SERVICE
#---------------------------------------------------------------------
    if ($arrService.Status -ne "Running"){

        Write-Host "Checking $ServiceName State."
        $fline
        $fspace
        Write-Host "$ServiceName is stopped."


        $fspace
        $fspace
        Write-Host "Script Action"
        $fline
        $fspace
        Write-Host "Starting $ServiceName service"
        Start-Service $ServiceName


        $fspace
        $fspace
        Write-Host "Verify $ServiceName Current State."
        $fline
        $fspace
        "$ServiceName is running."

    }

#       IF SERVICE IS RUNNING -RESTART SERVICE
#---------------------------------------------------------------------

    if ($arrService.Status -eq "running"){

        Write-Host "Checking $ServiceName State."
        $fline
        $fspace
        Write-Host "$ServiceName service is running."


        $fspace
        $fspace
        Write-Host "Script Action"
        $fline
        $fspace
        Write-Host "Restarting $ServiceName"
        Restart-Service $ServiceName


        $fspace
        $fspace
        Write-Host "Verify $ServiceName Current State."
        $fline
        $fspace
        "$ServiceName has restarted and is running."

    }

    $fspace
    $fspace
    $feq
    $fspace
    $fspace

}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Get-LastBootTime {

    $cn = $ENV:COMPUTERNAME

    [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $cn | Select -ExpandProperty LastBootUpTime))

}



#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Rotate-Archives {

    param(  [parameter(Mandatory=$true)][string] $Folder,
            [parameter(Mandatory=$true)][int] $days
        )


    if (test-path $Folder)
    {
      dir -recurse $Folder | ? {$_.LastWriteTime -lt (get-date).AddDays(-$days)} | del -recurse

    }
}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Clean-Import {

    param(  [parameter(Mandatory=$true)][string]$FileName,
                    [parameter(Mandatory=$true)][string] $Extension,
                    [parameter(Mandatory=$true)][int]$KeepDays,
                    [parameter(Mandatory=$true)][int]$tring
        )

    $date = Get-Date -format yyyy-MM-dd #Variable for DateStamp in archived filename.

    $days = $KeepDays

                    $file = "$FileName"
                    $ext = "$Extension"
                    $dir = "$gemD\ImportExport"
                    $path = "$dir\$file.$ext"
                    $arc = "$dir\Archive\Import-Archives"
                    $arcOrg = "$arc\$file.$ext"
                    $arcNew = "{0}_{1}.{2}" -f $file, $date, $ext

                    $header = $tring



    if ( test-path "$path" ) {

        Copy-Item "$path" -destination "$arc\$arcNew"

  #      (  Get-Content "$path" | Where-Object { $_ -notmatch '"FicaNbr","BadgeNbr","EmpStatus","LastName","FirstName"' }  ) | Set-Content $path
            (  Get-Content "$path" | Where-Object { $_ -notmatch '"$header"' }  ) | Set-Content $path
    }

    Gem-Rotate-Archives "$arc" $days

}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#

function Gem-Archive-File {
    param(  [parameter(Mandatory=$true)][string]$DirName,
                    [parameter(Mandatory=$true)][string]$FileName,
                    [parameter(Mandatory=$true)][string] $Extension,
                    [parameter(Mandatory=$true)][string]$ArcName,
                    [parameter(Mandatory=$true)][int]$KeepDays
        )

    $date = Get-Date -format yyyy-MM-dd #Variable for DateStamp in archived filename.

    $days = $KeepDays

                    $file = "$FileName"
                    $ext = "$Extension"
                    $dir = "$DirName"
                    $path = "$dir\$file.$ext"
                    $arc = "$ArcName"
                    $arcOrg = "$arc\$file.$ext"
                    $arcNew = "{0}_{1}.{2}" -f $file, $date, $ext

    if ( test-path "$path" ) {

        Copy-Item "$path" -destination "$arc\$arcNew"
    }

    Gem-Rotate-Archives "$arc" $days

}

#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


