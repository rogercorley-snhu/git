
$sysD = "$env:HOMEPATH"
$gemD = "$env:GEM"


#  Set-Aliases
#---------------------------------------------------------------------------------------------------------------

Set-Alias np notepad.exe
Set-Alias serv services.msc
Set-Alias ex explorer
Set-Alias ch Clear-Host
Set-Alias tp Test-Path


#  Load Gem-Library-PowerShell.ps1
#---------------------------------------------------------------------------------------------------------------

. $sysD\_Gem-Toolbox\PowerShell\Functions\Gem-Tools.ps1



$sysD = "$env:HOMEPATH"
$gemD = "$env:GEM"


$toolsD = "$sysD\_Gem-Toolbox"
$garcD = "$sysD\_Gem-Log-Archives"

$batchD = "$toolsD\Batch-Files"


$powerD = "$sysD\PowerShell"
$psFuncD = "$powerD\Functions"


#  Set-Aliases
#---------------------------------------------------------------------------------------------------------------

Set-Alias np notepad.exe
Set-Alias serv services.msc
Set-Alias ex explorer
Set-Alias ch Clear-Host
Set-Alias tp Test-Path

Set-Alias gcd Gem-Cd
Set-Alias gemcd Gem-Cd






#  Gem-Refresh-PowerShell
#---------------------------------------------------------------------------------------------------------------

function Gem-Refresh {

    Set-Location C:\_Gem-Toolbox\PowerShell\Functions

    & ".\Gem-Tools.ps1"

}



#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#




#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------
function Gem-Cd ($dir) {


    $list = {
            'gologs = Gem-Log-Archives',
            'gem = GEM Directory',
            'gdef = GEM Defs Directory',
            'glogs = GEM Logs Directory',
            'imp = GEM ImportExport Directory',
            'iarc = GEM ImpExp Archive Directory',
            'iemp = GEM Import-Employees-Archives',
            'gtb = GEM-Toolbox',
            'gpshell = GEM PowerShell Directory',
            'gpsf = GEM PowerShell Functions',
            'gbf = GEM Batch-Files Directory',
            'user = Current UserProfile Directory',
            'desk = User Desktop',
            'docs = Current UserProfile Documents',
            'psprofile = Current User PowerShell Profile Directory'
            }

  Switch ($dir) {

    gologs { sl "$env:SystemDrive\_Gem-Log-Archives"; break }

    gem { sl "$env:GEM"; break }

    gdef { sl "$env:GEM\Defs"; break }
    glogs { sl "$env:GEM\Log"; break }


    imp { sl "$env:GEM\ImportExport"; break }
    iarc { sl "$env:GEM\ImportExport\Archive"; break }
    iemp { sl "$env:GEM\ImportExport\Archive\Import-Employees-Archives"; break }

    gtb { sl "$sysD\_Gem-Toolbox"; break }
    gpshell { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gpsf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    gbf { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }


    user { sl "$env:UserProfile"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    docs { sl "$env:UserProfile\Documents"; break }
    psprofile { sl "$env:UserProfile\Documents\WindowsPowershell"; break }

    default { $list; break }
  }
} #  [ END ] : Gem-Cd


#
#===============================================================================================================
#===============================================================================================================
#===============================================================================================================
#



