    $testD = "C:\Users\rcorley\Desktop\TestImport\GEM"
    $gimp = $testD + "\ImportExport"


    copy-item "$gimp\employee.csv.test" "$gimp\employee.csv"

clear


    $date = Get-Date -f "yyyy-MM-dd"



    #$gimp = "D:\GEM\ImportExport"
    $impCSV = $gimp + "\employee.csv"
    $txtCSV = $gimp + "\employee.txt.csv"
    $tempCSV =  $gimp + "\employee.temp.csv"

    $flg = $gimp + "\Archive\Import-Employees\_Logs\__ERROR__FLAG-Import-Employee-Job.log"
    $ErrorActionPreference = "stop"

    $rsScript = "Import_v1_70.gsf"
    $rsPw = "gemie"
    $rsSvr = "OK1568PCIDB"
    $rsCore = "1"
    $rsModule = "170"
    $rsInclude = "gsf.txt"


    $rs = "D:\GEM\runscript.exe"
    $rsArg = "script=$rsScript,pw=$rsPw,svr=$rsSvr,core=$rsCore,module=$rsModule,include=$rsInclude"

    if (! (test-path($impCSV)))
    {
        Write-Host "File Not Found. Exiting Script."
    } else {

        if (! (test-path($tempCSV)))
        {
            ni $tempCSV -type file
        } else {
            remove-item $tempCSV
            new-item $tempCSV -type file
        }

        copy-item $impCSV $tempCSV

        Gem-Clean-File



        #        remove-item $tempCSV

        #        & $rs $rsArg
    }

    Write-Host "End Script"



function Gem-Clean-File  {

    $path = "C:\Users\rcorley\Desktop\TestImport\GEM\ImportExport\employee.temp.csv"
    $oepath = "C:\Users\rcorley\Desktop\TestImport\GEM\ImportExport\employee.csv"

    ( gc $path ) | % { $_ -replace '"', "" } | out-file $path -fo -en ascii
    ( gc $path ) | % { $_ -replace ' *,',',' } | out-file $path -fo -en ascii
    ( gc $path  | select -Skip 1 ) | sc $oepath

}