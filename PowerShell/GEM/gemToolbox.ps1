#===============================================================================================================

function GetInfo {
#---------------------------------------------------------------------------------------------------------------
$mc = $ENV:COMPUTERNAME


# Header / Footer
#-------------------------------------------------------
$header = "------------------[ START GET INFOMATION ]------------------"
$footer = "------------------[  END GET INFOMATION  ]------------------"

# Formatting
#-------------------------------------------------------
$dash = "---------------------------------------------------"
$space = " "

#
#
#================================================================================================
#
#


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
$Gpay = Get-Service 

#
#
#================================================================================================
#
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
	" $($myobj.uptime.Minutes) minutes, $($myobj.uptime.Seconds) seconds"

# Computer Memory Calculations
#-------------------------------------------------------
$myobj.RAM = "{0:n2} GB" -f ($CompInfo.TotalPhysicalMemory/1gb)

# Computer Drive Info
#-------------------------------------------------------
$myobj.Disk = GetDriveInfo $mc

#
#
#================================================================================================
#
#

# Clear Screen
#-------------------------------------------------------
Clear-Host

# WRITE : Header
#-------------------------------------------------------
Write-Host $space
Write-Host $header
Write-Host $space
$space
$dash

# WRITE : Computer / Network Info
#-------------------------------------------------------
Write-Host "Server:" $myobj.Name
Write-Host "Domain:" $myobj.Domain
$space
$dash

# WRITE : Model / Serial Number Info
#-------------------------------------------------------
Write-Host "Server Model:" $myobj.Model
Write-Host "Serial Number:" $myobj.MachineSN
$space
$dash

# WRITE : Operating System Info
#-------------------------------------------------------
Write-Host "OS Version:" $myobj.OS
Write-Host "Service Pack:" $myobj.ServicePack
$space
$dash

# WRITE : Uptime Info
#-------------------------------------------------------
Write-Host "Last Reboot:" $myobj.uptime
$space
$dash

# WRITE : RAM Info
#-------------------------------------------------------
Write-Host "Total RAM (GB):" $myobj.RAM
$space
$dash

# WRITE : Drive Info
#-------------------------------------------------------
Write-Host "Drive Info:`n"
$myobj.Disk
Write-Host $space
Write-Host $dash

# WRITE : Footer
#-------------------------------------------------------
Write-Host $space
Write-Host $space
Write-Host $footer
Write-Host $space
Write-Host $space

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
    $diskObj = "" | Select-Object Disk,Size,FreeSpace
    $diskObj.Disk = $disk.DeviceID
    $diskObj.Size = "{0:n0} GB" -f (( $disk | Measure-Object -Property Size -SUm).sum/1gb)
    $diskObj.FreeSpace = "{0:n0} GB" -f (( $disk | Measure-Object -Property FreeSpace -Sum).sum/1gb)

# Format Disk Info
#-------------------------------------------------------
    $text = "{0}  {1}  Free: {2}" -f $diskObj.Disk,$diskObj.size,$diskObj.FreeSpace
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
