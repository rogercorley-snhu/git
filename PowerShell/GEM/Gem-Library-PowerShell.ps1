#-----[ LIBRARY ] : Gem-PowerShell-Functions
#--------------------------------------------------------------------------------------------------------

#-----[ ALIASES ]
#.................................................................

    Set-Alias gemnewlog Gem-New-Logfiles
    Set-Alias gemldt Gem-Log-DateTimeStamp
    Set-Alias gemdisks Gem-Get-Disks
    Set-Alias gemnew Gem-Start-New
    Set-Alias gemnewlogs Gem-New-LogFiles
    Set-Alias gemcalcdate Gem-Calculate-Date
    Set-Alias stamp Gem-Stamp-Log
    Set-Alias gemdts Gem-Log-DateTime
    Set-Alias gemtp Gem-Test-Path
    Set-Alias gemrotate Gem-Rotate-Logs



#-----[ FUNCTIONS ]
#.................................................................

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

#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------

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


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------


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


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------

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


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------

function Stamp-Log ( $StampType ) {

    Switch ($StampType) {
        date { Get-Date; break }
        dStamp { Get-Date -Format "yyyy-MM-dd"; break }
        time { Get-Date -Format "HH:mm:ss"; break }
        logStamp { Get-Date -Format "yyyy-MM-dd HH:mm:ss"; break }
    }
}  # -----[ END ]----- Stamp-Log


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------


function Gem-Log-DateTime {

    $ldt = Stamp-Log logstamp
    $ldt

}  # -----[ END ]----- Gem-Log-DateTimeStamp


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------


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


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------


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


#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------
