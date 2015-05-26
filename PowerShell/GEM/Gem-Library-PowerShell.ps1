﻿#-----[ LIBRARY ] : Gem-PowerShell-Functions
#--------------------------------------------------------------------------------------------------------

#-----[ ALIASES ]
#.................................................................

    Set-Alias gemnew Gem-Start-New
    Set-Alias gemnewlog Gem-New-Logfiles

    Set-Alias gemtp Gem-Test-Path
    Set-Alias gemgetenv Gem-Get-Env
    Set-Alias gemcd Gem-Cd


    Set-Alias gemldt Gem-Log-DateTimeStamp
    Set-Alias gemcalcdate Gem-Calculate-Date
    Set-Alias stamp Gem-Stamp-Log
    Set-Alias gemdts Gem-Log-DateTime

    Set-Alias gemmon Gem-Online-Monitor
    Set-Alias geminfo Gem-Get-Info
    Set-Alias getinfo Gem-Get-Info 
    Set-Alias gemdrives Gem-Get-Drive-Info
    Set-Alias gemdisks Gem-Get-Disks

    Set-Alias gemrotate Gem-Rotate-Logs

    Set-Alias gemrestart Restart-Gem-Service

    Set-Alias gemlogin Gem-Web-AutoLogin



#-----[ FUNCTIONS ]
#.................................................................



#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------
function Gem-Cd ($dir) {

  Switch ($dir) {
    gimp { sl "$env:GEM\ImportExport"; break }
    gdef { sl "$env:GEM\Defs"; break }
    gemlogs { sl "$env:GEM\Log"; break }
    garc { sl "$env:GEM\ImportExport\Archive"; break }
    gemp { sl "$env:GEM\ImportExport\Archive\Import-Employees"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    gologs { sl "$env:SystemDrive\_Gem-Log-Archives"; break }
    gtb { sl "$env:GEM\_Gem-Toolbox"; break }
    gps { sl "$env:GEM\_Gem-Toolbox\PowerShell"; break }
    gpf { sl "$env:GEM\_Gem-Toolbox\PowerShell\Functions"; break }
    gbf { sl "$env:GEM\_Gem-Toolbox\Batch-Files"; break }
    gem { sl "$env:GEM"; break }
    default { sl "$env:GEM"; break }
  }
} #  [ END ] : Gem-Cd


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Get-Disks {

    param( [parameter(Mandatory=$true)][String]$dtype )

    if ($dtype -eq 'sys') { $dtype = 'system' }
    elseif ($dtype -eq 'drive') { $dtype = 'drives' }
    else { $dtype }

    $drive = ""

    Switch ($dtype) {
        system { $drive = "$env:HOMEDRIVE" }
        drives { 
            $comp = "$env:COMPUTERNAME"
            $logicalDisk = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $comp

            foreach ($disk in $logicalDisk) {
                $diskObj = "" | Select Disk
                $diskObj.Disk = $disk.DeviceID
            }    

            $drive = $diskObj.Disk
        }
    }

    $drive
}  # -----[ END ]----- Gem-Get-Disks


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Get-Env {

    param( [parameter(Mandatory=$true)][String]$etype )

    if ($etype -eq "list") {
        Get-ChildItem env: | Sort Name
    }
    elseif ($etype = '') {
        Get-ChildItem env: | Sort Name
    }
    else {
        $gemEnv = Get-ChildItem env: | Select $gemEnv.Value | Where {$_.Name -eq $etype}

        $outEnv = $gemEnv.Value
        $outEnv
    }

}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Set-Env {

[string]$var = $args
  if ($var -eq "")
    { Get-ChildItem env: | Sort-Object Name }
   else
    {
    if ($var -match "^(\S*?)\s*=\s*(.*)$")
    {Set-Item -Force -Path "env:$($matches[1])" -Value $matches[2];}
    else
    {Write-Error "[ ERROR ] : Usage: VAR=VALUE"}
   }
}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Start-New {

    #  Variables : Required Drives & Directories
    #..........................................................................

    $sysd = "$env:HOMEDRIVE"

    #$gemd = "$env:GEM"

    $testC = "$env:TESTC"
    $testD = "$env:TESTD"
    $testGEM = "$testD\GEM"


    $gimp = "$testGEM\ImportExport"
    #$gimp = "$gemd\ImportExport"
    $garc = "$gimp\Archive"

    $gtb = "$testGEM\_Gem-Toolbox"
    #$gtb = "$gemd\_Gem-Toolbox"
    $gbf = "$gtb\Batch-Files"
    $gps = "$gtb\PowerShell"
    $gpf = "$gps\Functions"

    $gemp = "$garc\Import-Employees"
    $gbad = "$gemp\Bad-Files"
    $goef = "$gemp\Original-Emp-Files"

    $loga = "$testC\_Gem-Log-Archives"
    #$loga = "$sysd\_Gem-Log-Archives"


    #  Variables : Required Files
    #..........................................................................

    $log = "$gemp\Import-Employee.log"
    $im = "$gimp\Import-Master.ps1"

    $rotate = "$gbf\Rotate-Gem-Logs-Weekly.bat"

    $gt = "$gps\Gem-Tools.ps1"
    $gm = "$gpf\Gem-Online-Monitor.ps1"
    $gi = "$gpf\Gem-Get-Info.ps1"
    $fl = "$gpf\Gem-Function-List.ps1"



    #  Array : Create Required Directories
    #..........................................................................

    $dir = @(
              "$testC",
              "$testD",
              "$testGEM",
              "$gimp",
              "$garc",
              "$gemp",
              "$gbad",
              "$goef",
              "$loga",
              "$gtb",
              "$gbf",
              "$gps",
              "$gpf"
            )

    ForEach ($item in $dir) {
        if ( !(Test-Path($item))) {
            Write-Host "[ TEST-DIR ] : $item doesn't exist. Running New-Item."
            New-Item -Path $item -ItemType directory
        }
        else {
            Write-Host "[ TEST-DIR ] : $item exists."
            Write-Host "[ TEST-DIR ] : Deleting $item."
        }
        
    }

    #  Array : Create Required Files
    #..........................................................................

    $files = @(
                "$log",
                "$im",
                "$rotate",
                "$gt",
                "$gm",
                "$gi",
                "$fl"
            )

    ForEach ($file in $files) {
        if ( !(Test-Path($file))) {
            Write-Host "[ TEST-DIR ] : $file doesn't exist. Running New-Item."
            New-Item -Path $file -ItemType file
        }
        else {
            Write-Host "[ TEST-DIR ] : $file exists."
            Write-Host "[ TEST-DIR ] : Deleting $file."
        }
        
    }

    gemnewlog

    Read-Host("Press [ ENTER ] to exit script")

}  # -----[ END ]----- Gem-Start-New


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-New-LogFiles {

    $sys = "$env:HOMEDRIVE"
    $sysdTest = "$env:TESTC"

    $go = "$sysdTest\gemonline.log"
    $gd = "$sysdTest\GEMDaily.cp"

    $files = @( "$go","$gd" )

    $stamp = Get-Date

    foreach ($file in $files) {
        if ( Test-Path ($file) ) {
                Write-Host "$file exists. Deleting $file"
                Remove-Item $file
                New-Item $file -ItemType File
        }
        else {
            New-Item $file -ItemType File
        }

        foreach ($count in $c) {
            Add-Content $file -Value "$stamp"
        }
    }

}  # -----[ END ]----- Gem-New-LogFiles


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Calculate-Date {
    param( [parameter(Mandatory=$true)][String]$dateIn )

    $date = Get-Date

    $dayCount = 84
    $lastWrite = $date.AddDays(-$dayCount)

    Switch ($dateIn) {
        dayCount { $outDate = "$dayCount"; break }
        lastWrite { $outDate = "$lastWrite"; break }
        date { $outDate = "$date"; break }
    }

    Return $outDate

}  # -----[ END ]----- Gem-Calculate-Date


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Stamp-Log ( $StampType ) {

    Switch ($StampType) {
        date { Get-Date; break }
        dStamp { Get-Date -Format "yyyy-MM-dd"; break }
        time { Get-Date -Format "HH:mm:ss"; break }
        logStamp { Get-Date -Format "yyyy-MM-dd HH:mm:ss"; break }
    }
}  # -----[ END ]----- Stamp-Log


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Log-DateTime {

    $ldt = Stamp-Log logstamp
    $ldt

}  # -----[ END ]----- Gem-Log-DateTimeStamp


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Test-Path {

    param( [parameter(Mandatory=$true)][String]$file )

    $tpath = Test-Path($file)

    Switch ($tpath) {
        $true { $out = "{0} : [ TEST ] : {1} exists." -f $ldt,$file }
        $false { $out = "{0} : [ TEST-ERROR ] : {1} does not exist." -f $ldt,$file }
    }

    $out
    Add-Content -Path $log -Value $out

}  # -----[ END ]----- Gem-Test-Path


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Rotate-Logs {

    $stamp = Ldt
    $lw = Gem-Calculate-Date lastWrite
    $dc = Gem-Calculate-Date dayCount

    $logs = gci $logArc -Recurse |
        Where { $_.lastWrite -le "$lw" }

        foreach ( $file in $logs ) {
            if ($file -ne $NULL) {

                $delMsg01 = "{0} : [ ROTATE ] : {1} is older than {2} days old." -f $stamp,$file,$dc
                $delMsg02 = "{0} : [ ROTATE ] : {1} has been deleted." -f $stamp,$file

                $delMsg01
                $delMsg02

                Out-File -FilePath $log -Append -InputObject $delMsg01
                Out-File -FilePath $log -Append -InputObject $delMsg02

                Remove-Item $file.FullName | Out-Null
            }

            else {

                $delMsg03 = "{0} : [ ROTATE ] : All files are less than {2} days old." -f $stamp,$file,$dc
                $delMsg04 = "{0} : [ ROTATE ] : No files to delete!" -f $stamp

                $delMsg03
                $delMsg04

                Out-File -FilePath $log -Append -InputObject $delMsg03
                Out-File -FilePath $log -Append -InputObject $delMsg04

            }
        }
}  # -----[ END ]----- Gem-Rotate-Logs


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  Gem-Online-Monitor
#--------------------------------------------------------------------------------------------------------

function Gem-Online-Monitor {

    Clear
    Get-Content C:\gemonline.log -wait

}


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  Restart-Gem-Service
#--------------------------------------------------------------------------------------------------------

function Restart-Gem-Service {

  Restart-Service -Name GEMService -fo

} #  [ END ] : Restart-Gem-Service


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  Gem-Get-Info
#---------------------------------------------------------------------------------------------------------------

function Gem-Get-Info {

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
$gem = Get-WmiObject Win32_service | Where-Object { $_.name -like "GEM*" }

#
#================================================================================================
#--OBJECTS
#================================================================================================
#

#Create Custom Objects
$myobj = "" | Select-Object Name,Domain,Model,MachineSN,OS,ServicePack,WindowsSN,Uptime,RAM,Disk

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
$myobj.uptime = (Get-Date) - [System.DateTime]::ParseExact($Os.LastBootUpTime.Split(".")[0],'yyyyMMddHHmmss',$null)
$myobj.uptime = "$($myobj.uptime.Days) days, $($myobj.uptime.Hours) hours," +`
  " $($myobj.uptime.Minutes) minutes"

# Computer Memory Calculations
#-------------------------------------------------------
$myobj.RAM = "{0:n2} GB" -f ($CompInfo.TotalPhysicalMemory/1gb)

# Computer Drive Info
#-------------------------------------------------------
$myobj.Disk = Gem-Get-Drive-Info $mc

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
Write-Host "Last Reboot:`t" $myobj.uptime
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
$gemtext = "Logon As: `t {0} `nProcessID: `t {1} `nStartMode: `t {2} `nState: `t`t {3} `nStatus: `t {4}" -f $gem.StartName,$gem.ProcessID,$gem.StartMode,
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
} #  [ END ] : Gem-Get-Info


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


function Gem-Get-Drive-Info {
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
    $diskObj.Size = "{0:n0} GB" -f (( $disk | Measure-Object -Property Size -SUm).sum/1gb)
    $diskObj.FreeSpace = "{0:n0} GB" -f (( $disk | Measure-Object -Property FreeSpace -Sum).sum/1gb)
    $diskObj.Percent = "{0:n0}%" -f ( (( $disk | 
        Measure-Object -Property FreeSpace -Sum).sum/1gb) / ((( $disk | Measure-Object -Property Size -SUm).sum/1gb)*100) )
# Format Disk Info
#-------------------------------------------------------
    $text = "{0} [Drive Size]-- {1}    [Free Space]-- {2}    [Percent Free]-- {3}" -f $diskObj.Disk,$diskObj.size,
$diskObj.FreeSpace,$diskObj.Percent
    $msg += $text + [char]13 + [char]10
}

$msg
#---------------------------------------------------------------------------------------------------------------
}  #End function Gem-Get-Drive-Info


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  Gem-Web-AutoLogin
#---------------------------------------------------------------------------------------------------------------
function Gem-Web-AutoLogin ( $serverType ) {

# VARIABLE : URL Header
#-----------------------------------------------------------------------
$sHTTP = "http://localhost/"


# VARIABLES : GEM Product Site Pages
#-----------------------------------------------------------------------
$gem = "/GEM/Login.aspx"
$gserve = "/GEMserve4"
$gpay = "/GEMpay/logon.aspx"
$gpay3 = “/GEMpay3/logon.htm”


# ARGUMENT CONDITIONS : URL Ending Based Upon User Input
#-----------------------------------------------------------------------
Switch ($serverType) {
    gemserve { $fullurl = $sHTTP + $gserve }
    gserve { $fullurl = $sHTTP + $gserve }
    serve { $fullurl = $sHTTP + $gserve }
    gs { $fullurl = $sHTTP + $gserve }
    gempay3 { $fullurl = $sHTTP + $gpay3 }
    gpay3 { $fullurl = $sHTTP + $gpay3 }
    gp3 { $fullurl = $sHTTP + $gpay3 }
    gempay { $fullurl = $sHTTP + $gpay }
    gpay { $fullurl = $sHTTP + $gpay }
    gp { $fullurl = $sHTTP + $gpay }
    gem { $fullurl = $sHTTP + $gem }
}


# VARIABLES : Website Related
#-----------------------------------------------------------------------
$sitePW=Read-Host("Enter Site Password") -AsSecureString


# INVOKE INTERNET EXPLORER - Open URL and log into the site
#-----------------------------------------------------------------------
$IE = New-Object -Com internetexplorer.application;
$IE.visible = $true;
$IE.navigate($fullurl);


# Wait a few seconds and then launch the executable.
#----------------------------------------------------
While ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }


# Select & Enter Variables to Site Fields
#----------------------------------------------------

if ( $serverType -eq "gempay3" -or $serverType -eq "gpay3" -or $serverType -eq "gp3" ) {

$IE.Document.getElementById(“User”).value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID(“Password”).value = $pw
$IE.Document.getElementById(“SubmitBtn”).Click()
}

elseif ( $serverType -eq "gempay" -or $serverType -eq "gpay" -or $serverType -eq "gp" ) {
$IE.Document.getElementById(“User”).value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID(“Password”).value = $pw
$IE.Document.getElementById(“SubmitBtn”).Click()
}

elseif ( $serverType -eq "gemserve" -or $serverType -eq "gserve" -or $serverType -eq "serve" ) {
$IE.Document.getElementById("txtUserID").value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID("txtPassword").value = $pw
$IE.Document.getElementById("btnLogin").Click()
}

else {
$IE.Document.getElementById("txtUserID").value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID("txtPassword").value = $pw
$IE.Document.getElementById("btnLogin").Click()
}

While ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }


} #exit Function Gem-Web-AutoLogin


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


