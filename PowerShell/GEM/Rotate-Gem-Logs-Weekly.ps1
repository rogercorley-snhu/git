clear

sal gtp Gem-Test-Path

$sys="$env:HOMEDRIVE"
$sysTest="$sys\_TEST-Gem-C"
$logArc = "$sysTest\_Gem-Log-Archives"
$log = "$logArc\Rotate-Gem-Logs.log"

Set-Location $sysTest

$go = @{
    "Name" = "gemonline";
    "Ext" = "log";
    "Path" = "$sysTest\gemonline.log";
}

$gd = @{
    "Name" = "GEMDaily";
    "Ext" = "cp";
    "Path" = "$sysTest\GEMDaily.cp";
}

$fileName = @($go.Name;$gd.Name)
$fileExt = @($go.Ext;$gd.Ext)
$filePath = @($go.Path;$gd.Path)

#  Check Log Files Exists On C:\
#------------------------------------------------------------------
foreach ($i in $filePath) {
    gtp $i
}


#  Check Log Files Exists On C:\
#------------------------------------------------------------------
foreach ($j in $fileName) {
    Gem-Rotate $j
}



#  *****  FUNCTIONS  *****
#------------------------------------------------------------------

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


}
