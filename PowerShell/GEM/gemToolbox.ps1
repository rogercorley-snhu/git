Set-Location "$env:GEM"

#  Set-Aliases
#---------------------------------------------------------------------------------------------------------------

sal gemcd Gem-Cd -Option ReadOnly
sal gemrs Restart-GemService -Option ReadOnly
sal geminfo GetInfo -Option ReadOnly
sal gemdisk GetDriveInfo -Option ReadOnly
sal gemlogin Gem-AutoLogin -Option ReadOnly

sal np notepad.exe -Option ReadOnly



#  Restart-GemService
#---------------------------------------------------------------------------------------------------------------
function Restart-GemService {

  Restart-Service -Name GEMService -fo
}


#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------
function Gem-Cd ($dir) {

  switch ($dir) {
    gimp { sl "$env:GEM\ImportExport"; break }
    gdefs { sl "$env:GEM\Defs"; break }
    glogs { sl "$env:GEM\Log"; break }
    archive { sl "$env:GEM\ImportExport\Archive"; break }
    gimpemp { sl "$env:GEM\ImportExport\Archive\ImportEmployees"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    gplog { sl "$env:SystemDrive\_GPayLogArchives"; break }
    toolbox { sl "$env:SystemDrive\_gemToolbox"; break }
    ps { sl "$env:SystemDrive\_gemToolbox\PowerShell"; break }
    func { sl "$env:SystemDrive\_gemToolbox\PowerShell\Functions"; break }
    batch { sl "$env:SystemDrive\_gemToolbox\BatchScripts"; break }
    gem { sl "$env:GEM"; break }
    default { sl "$env:GEM" }
  }
}



#  GetInfo
#---------------------------------------------------------------------------------------------------------------
function GetInfo {
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
$myobj.Disk = GetDriveInfo $mc

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
}  #End function GetInfo

#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  GetDriveInfo
#---------------------------------------------------------------------------------------------------------------

function GetDriveInfo {
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
}  #End function GetDriveInfo

#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#


#  GemHelp
#---------------------------------------------------------------------------------------------------------------
function GemHelp {


}


#  Gem-AutoLogin
#---------------------------------------------------------------------------------------------------------------
function Gem-AutoLogin ( $serverType, $sIP, $caseNo ) {

# VARIABLES
#-----------------------------------------------------------------------
$sHTTP = "http://"



# USER INPUT : IP Address of Server Hosting GEM Product
#-----------------------------------------------------------------------
$sIP = Read-Host "Enter server IP address: "


# Different GEM Product URL Endings
#-----------------------------------------------------------------------
$gemURL = "/GEM/Login.aspx"
$gpayURL = "/gempay/logon.aspx"
$gpay3URL = “/gempay3/logon.htm”



# ARGUMENT CONDITIONS : URL Ending Based Upon User Input
#-----------------------------------------------------------------------
if ($serverType -eq "gem") { $fullurl = $sHTTP + $sIP + $gemURL }
elseif ($serverType -eq "gpay") { $fullurl = $sHTTP + $sIP + $gpayURL }
else { $fullurl = $sHTTP + $sIP + $gpay3URL }


# VARIABLES : Website Related
#-----------------------------------------------------------------------
$Username=”support”
$Password=Read-Host("Enter GEMpay Password")


# OPEN NOTEPAD - Append DateTimeStamp for Start & End Work Times
#                               This can be used to take notes while working on the sites
#-----------------------------------------------------------------------
$Executable = "c:\windows\system32\notepad.exe"


# INVOKE INTERNET EXPLORER - Open URL and log into the site
#-----------------------------------------------------------------------
$IE = New-Object -com internetexplorer.application;
$IE.visible = $true;
$IE.navigate($fullurl);


# Wait a few seconds and then launch the executable.
#----------------------------------------------------
while ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }


# Select & Enter Variables to Site Fields
#----------------------------------------------------
$IE.Document.getElementById(“User”).value = $Username
$IE.Document.getElementByID(“Password”).value=$Password
$IE.Document.getElementById(“SubmitBtn”).Click()

while ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }


} #exit Function Gem-AutoLogin
