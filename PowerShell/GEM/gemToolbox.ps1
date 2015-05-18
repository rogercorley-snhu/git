#===============================================================================================================

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
Clear-Host

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
