

clear

#  Variables : Required Drives & Directories
#..........................................................................

$sysd = "$env:HOMEDRIVE"
$sysdTest = "$env:TESTC"

$gemd = "$env:GEM"
$gemdTest = "$env:TESTD"

$gimp = "$gemdTest\ImportExport"
#$gimp = "$gemd\ImportExport"
$garc = "$gimp\Archive"

$gtb = "$gemdTest\_Gem-Toolbox"
#$gtb = "$gemd\_Gem-Toolbox"
$gbf = "$gtb\Batch-Files"
$gps = "$gtb\PowerShell"

$gpf = "$gps\Functions"

$gemp = "$garc\Import-Employees"
$gbad = "$gemp\Bad-Files"
$goef = "$gemp\Original-Emp-Files"

$loga = "$sysdTest\_Gem-Log-Archives"
#$loga = "$sysd\_Gem-Log-Archives"


#  Variables : Required Files
#..........................................................................

$log = "$gemp\Import-Employee.log"
$im = "$gimp\Import-Master.ps1"

$rotate = "$gbs\Rotate-Gem-Logs-Weekly.bat"

$gt = "$gps\Gem-Tools.ps1"
$gm = "$gpf\Gem-Online-Monitor.ps1"
$gi = "$gpf\Gem-Get-Info.ps1"
$fl = "$gpf\Gem-Function-List.ps1"



#  Array : Create Required Directories
#..........................................................................

$dir = @(
          "$sysTest",
          "$gemTest",
          "$gemp",
          "$gbad",
          "$goef",
          "$loga",
          "$gtb",
          "$gbs",
          "$gps",
          "$gpf"
        )

ForEach ($item in $dir) {
    if ( !( test-path($item) ) ) {
    New-Item -Path $item -ItemType directory
    }
    else {
            Write-Host "$item exists. Deleting $item"
            Remove-Item -Path $item -Recurse
            New-Item -Path $item -ItemType Directory
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
    if ( !( test-path($file) ) ) {
    New-Item -Path $file -ItemType file
  }
    else {
            Write-Host "$file exists. Deleting $file"
            Remove-Item -Path $file
            New-Item -Path $file -ItemType file
    }
}

Read-Host("Press [ ENTER ] to exit script")
