
#  DEFAULT : MICROSOFT POWERSHELL $PROFILE : CONFIGURATIONS
#__________________________________________________________________

$GEM = "$env:GEM"

Set-Location $GEM

$GTB = "$GEM\_Gem-Toolbox"
$GBF = "$GTB\Batch-Files"
$GPS = "$GTB\PowerShell"
$GPF = "$GPS\Functions"

. "$GPS\Gem-Tools.ps1"

Clear

function Prompt {
  $promptSpace = "  "
  $promptLine = "________________________________________________________________________________"
        $promptString = "--[  " + $(Get-Location) + "  ]----|"
  Write-Host $promptSpace
  Write-Host $promptLine -ForegroundColor Yellow
  Write-Host $promptSpace
  Write-Host $promptString -NoNewLine -ForegroundColor Yellow

  Return " "
  }
