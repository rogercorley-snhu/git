#  Set-Aliases
#---------------------------------------------------------------------------------------------------------------

sal geminfo Gem-Get-Info
sal gemdisk Gem-Get-Drive-Info
sal gemcd Gem-Cd
sal gemrs Restart-Gem-Service
sal gemlogin Gem-Web-AutoLogin

sal np notepad.exe
sal serv services.msc
sal ex explorer
sal ch Clear-Host
sal tp Test-Path


#  Restart-Gem-Service
#---------------------------------------------------------------------------------------------------------------
function Restart-Gem-Service {

  Restart-Service -Name GEMService -fo

} #  [ END ] : Restart-Gem-Service


#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------
function Gem-Cd ($dir) {

  Switch ($dir) {
    gimp { sl "$env:GEM\ImportExport"; break }
    gdefs { sl "$env:GEM\Defs"; break }
    glog { sl "$env:GEM\Log"; break }
    garc { sl "$env:GEM\ImportExport\Archive"; break }
    gemp { sl "$env:GEM\ImportExport\Archive\Import-Employees"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    gplog { sl "$env:SystemDrive\_Gem-Log-Archives"; break }
    gtb { sl "$env:GEM\_Gem-Toolbox"; break }
    gpsh { sl "$env:GEM\_Gem-Toolbox\PowerShell"; break }
    gpshf { sl "$env:GEM\_Gem-Toolbox\PowerShell\Functions"; break }
    gbf { sl "$env:GEM\_Gem-Toolbox\Batch-Files"; break }
    gem { sl "$env:GEM"; break }
    default { sl "$env:GEM"; break }
  }
} #  [ END ] : Gem-Cd


<#
#  Gem-Get-Info
#---------------------------------------------------------------------------------------------------------------
function Gem-Get-Info {
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


#  Gem-Get-Drive-Info
#---------------------------------------------------------------------------------------------------------------

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
    $diskObj.Percent = "{0:n0}%" -f (((( $disk | Measure-Object -Property FreeSpace -Sum).sum/1gb) / (( $disk | Measure-Object -Property Size -SUm).sum/1gb)
)*100)

# Format Disk Info
#-------------------------------------------------------
    $text = "{0} [Drive Size]-- {1}    [Free Space]-- {2}    [Percent Free]-- {3}" -f $diskObj.Disk,$diskObj.size,$diskObj.FreeSpace,$diskObj.Percent
    $msg += $text + [char]13 + [char]10
}

$msg
#---------------------------------------------------------------------------------------------------------------
} #  [ END ] : Gem-Get-Drive-Info

#>

#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  Gem-Get-Help
#---------------------------------------------------------------------------------------------------------------
function Gem-Get-Help {


} #  [ END ] : Gem-Get-Help


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
