function CheckOpsActive
{
    $OpsActive = Get-Process ops -ErrorAction SilentlyContinue

    Clear-Host

    if ( $OpsActive -eq $null )
    {
        Write-Host "[  ERROR  ] : OPS is not running."
        Start-Process E:\MICROS\Res\Pos\Bin\ops.exe -ErrorAction Stop
    }
    else 
    {
        Write-Host "[ RUNNING ] : OPS is currently running.`n"
    }
}