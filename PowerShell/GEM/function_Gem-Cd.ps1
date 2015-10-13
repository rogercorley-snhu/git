#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------
function Gem-Cd ($dir) {


    $list = {
        'gem = GEM Directory',
        'glad = Gem-Log-Archives Directory',
        'gdef = GEM Defs Directory',
        'glog = GEM Logs Directory',
        'imp = GEM ImportExport Directory',
        'gimp = GEM ImportExport Directory',
        'impexp = GEM ImportExport Directory',
        'impexparc = GEM ImpExp Archive Directory',
        'ixarc = GEM ImpExp Archive Directory',
        'impemparc = GEM Import-Employees-Archives Directory',
        'iearc = GEM Import-Employees-Archives Directory',
        'gtb = GEM-Toolbox Directory',
        'tools = GEM-Toolbox Directory',
        'gemtools = GEM-Toolbox Directory',
        'toolbox = GEM-Toolbox Directory',
        'psd = GEM PowerShell Directory',
        'gemps = GEM PowerShell Directory',
        'gempsd = GEM PowerShell Directory',
        'gps = GEM PowerShell Directory',
        'gpsd = GEM PowerShell Directory',
        'gempsf = GEM PowerShell Functions Directory',
        'gpsfd = GEM PowerShell Functions Directory',
        'psf = GEM PowerShell Functions Directory',
        'psfd = GEM PowerShell Functions Directory',
        'functions = GEM PowerShell Functions Directory',
        'batd = GEM Batch-Files Directory',
        'bat = GEM Batch-Files Directory',
        'gembat = GEM Batch-Files Directory',
        'gembatd = GEM Batch-Files Directory',
        'user = Current UserProfile Directory',
        'desk = User Desktop',
        'docs = Current UserProfile Documents Directory',
        'pspro = Current User PowerShell Profile Directory',
        'psprofile = Current User PowerShell Profile Directory'
            }

  Switch ($dir) {

    gem { sl "$env:GEM"; break }

    gologs { sl "$env:SystemDrive\_Gem-Log-Archives"; break }
    glad { sl "$env:SystemDrive\_Gem-Log-Archives"; break }

     gdef { sl "$env:GEM\Defs"; break }

    glog { sl "$env:GEM\Log"; break }
    gemlog { sl "$env:GEM\Log"; break }

    imp { sl "$env:GEM\ImportExport"; break }
    gimp { sl "$env:GEM\ImportExport"; break }
    impexp { sl "$env:GEM\ImportExport"; break }

    impemparc { sl "$env:GEM\ImportExport\Archive\Import-Employees-Archives"; break }
    iearc { sl "$env:GEM\ImportExport\Archive\Import-Employees-Archives"; break }

    gtb { sl "$sysD\_Gem-Toolbox"; break }
    tools { sl "$sysD\_Gem-Toolbox"; break }
    gemtools { sl "$sysD\_Gem-Toolbox"; break }
    toolbox { sl "$sysD\_Gem-Toolbox"; break }

    psd { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gemps { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gempsd { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gps { sl "$sysD\_Gem-Toolbox\PowerShell"; break }
    gpsd { sl "$sysD\_Gem-Toolbox\PowerShell"; break }

    gempsf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    gpsf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    psf { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    psfd { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }
    functions { sl "$sysD\_Gem-Toolbox\PowerShell\Functions"; break }

    bat { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }
    batd { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }
    gembat { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }
    gembatd { sl "$sysD\_Gem-Toolbox\Batch-Files"; break }


    user { sl "$env:UserProfile"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    docs { sl "$env:UserProfile\Documents"; break }

    psprofile { sl "$env:UserProfile\Documents\WindowsPowershell"; break }
    pspro { sl "$env:UserProfile\Documents\WindowsPowershell"; break }

    default { $list; break }
  }
} #  [ END ] : Gem-Cd