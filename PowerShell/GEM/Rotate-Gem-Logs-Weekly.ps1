clear

sal gtp Gem-Test-Path

$sysD="$env:HOMEDRIVE"
$logArc = "$sysD\_Gem-Log-Archives"
$log = "$logArc\Rotate-Gem-Logs.log"

Set-Location $sysD

$go = @{
    "Name" = "gemonline";
    "Ext" = "log";
    "Path" = "$sysD\gemonline.log";
}

$gd = @{
    "Name" = "GEMDaily";
    "Ext" = "cp";
    "Path" = "$sysD\GEMDaily.cp";
}

$fileName = @($go.Name;$gd.Name)
$fileExt = @($go.Ext;$gd.Ext)
$filePath = @($go.Path;$gd.Path)

#  Check Log Files Exists On C:\
#------------------------------------------------------------------
foreach ($i in $filePath) {
    Gem-Test-Path $i
}


#  Check Log Files Exists On C:\
#------------------------------------------------------------------
foreach ($j in $fileName) {
    Gem-Rotate $logArc 80
}



#  *****  FUNCTIONS  *****
#------------------------------------------------------------------

function Gem-Move-File {

    Gem-Test-Path ( $sysD\gemonline.log ) {
        Rename-Item
    }
}

function Stamp-Log ( $StampType ) {

    Switch ($StampType) {
        date { Get-Date; break }
        dStamp { Get-Date -Format "yyyy-MM-dd"; break }
        time { Get-Date -Format "HH:mm:ss"; break }
        logStamp { Get-Date -Format "yyyy-MM-dd HH:mm:ss";break }
    }
}

function Ldt {
    $ldt = Stamp-Log logstamp
    $ldt
}

function Gem-Test-Path {
    param( [parameter(Mandatory=$true)][String]$file )

    $tpath = Test-Path($file)

    Switch ($tpath) {
        $true { $out = "{0} : [ TEST ] : {1} exists." -f $ldt,$file }
        $false { $out = "{0} : [ TEST-ERROR ] : {1} does not exist." -f $ldt,$file }
    }

    $out
    Add-Content -Path $log -Value $out
}


function Gem-Rotate {

    param( [string] $Folder, [int] $days )

    "Deleting log files from $Folder older than $days days"

    if (test-path $Folder)
    {
      dir -recurse $Folder | ? {$_.LastWriteTime -lt (get-date).AddDays(-$days)} | del -recurse -whatif
      # To delete for real, remove -whatif in the line above
    }
}