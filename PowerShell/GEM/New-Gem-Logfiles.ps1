clear

$sys = "$env:HOMEDRIVE"

$sysTest = "$sys\_TEST-Gem-C"

$go = "$sysTest\gemonline.log"
$gd = "$sysTest\GEMDaily.cp"

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

