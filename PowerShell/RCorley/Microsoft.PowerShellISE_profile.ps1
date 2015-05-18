Set-Location C:\PowerShell

$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=100
$size.height=60
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=1024
$size.height=5000
$Shell.BufferSize = $size

$Shell.BackgroundColor = "Black"
$Shell.ForegroundColor = "White"

$Shell.WindowTitle="the Brain"

New-Item alias:np -Value C:\Windows\System32\notepad.exe

. C:\PowerShell\Functions\Tools.ps1

Clear-Host

function Prompt
  { 
  $promptSpace = "  "
  $promptLine = "________________________________________________________________________________" 
    $promptString = "--[  " + $(Get-Location) + "  ]----|"
  Write-Host $promptSpace
  Write-Host $promptLine -ForegroundColor Yellow
  Write-Host $promptSpace
  Write-Host $promptString -NoNewLine -ForegroundColor Yellow
    Return " " 
  }