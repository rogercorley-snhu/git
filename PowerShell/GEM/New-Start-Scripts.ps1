clear

#  Variables : Required Drives & Directories
#..........................................................................

$sysd = gci env:HOMEDRIVE
$sys = $sysd.Value
$groot = "F:"
$gem = "$groot\GEM"

$gimp = "$gem\ImportExport"
$garc = "$gimp\Archive"

$gtb = "$gem\_Gem-Toolbox\"
$gbs = "$gtb\Batch-Files"
$gpsh = "$gtb\PowerShell"

$gpsf = "$gpsh\Functions"

$gemp = "$garc\Import-Employees"
$gbad = "$gemp\Bad-Files"
$goef = "$gemp\Original-Emp-Files"

$loga = "$sys\_Gem-Log-Archives"


#  Variables : Required Files
#..........................................................................

$log = "$gemp\Import-Employee.log"
$im = "$gimp\Import-Master.ps1"

$rotate = "$gbs\Rotate-GOGD-Logs-WEEKLY.bat"

$gt = "$gpsh\Gem-Tools.ps1"
$gm = "$gpsf\Gem-Online-Monitor.ps1"
$gi = "$gpsf\Gem-Get-Info.ps1"
$fl = "$gpsf\Gem-Function-List.ps1"



#  Array : Create Required Directories
#..........................................................................

$dir = @( 
          "$gemp",
          "$gbad",
          "$goef",
          "$loga",
          "$gtb",
          "$gbs",
          "$gpsh",
          "$gpsf"
        )
        
ForEach ($item in $dir) {
    if ( !( test-path($item) ) ) {
    New-Item -Path $item -ItemType directory
    }
    else { Write-Host "$item exists" }
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
    if ( !( test-path($file) ) ) {
    New-Item -Path $file -ItemType file
  }
    else { Write-Host "$file exists" }
}

Read-Host("Enter Key")