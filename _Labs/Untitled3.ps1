$a = "C:\_Test\test.txt"

$date = Get-Date -Format "yyyyMMdd_hh.mm.ss"

Get-Item $a | foreach { 
    $oldN = $_.Name;
    $oldFull = $_.FullName;
    $newN = $_.Name -replace 'txt',"$date.txt";
    Rename-Item -Path "$oldFull" -NewName "$newN";
    Write-Output $("Renamed {0} to {1}" -f $oldN, $newN );
 }

 ni $a -ItemType file -Force