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
}  #End function Gem-Drive-Info