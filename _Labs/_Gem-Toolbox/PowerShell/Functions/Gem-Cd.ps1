#  Gem-Cd
#---------------------------------------------------------------------------------------------------------------

function Gem-Cd ($dir) {

  Switch ($dir) {
    gimp { sl "$env:GEM\ImportExport"; break }
    gdefs { sl "$env:GEM\Defs"; break }
    glog { sl "$env:GEM\Log"; break }
    garc { sl "$env:GEM\ImportExport\Archive"; break }
    gemp { sl "$env:GEM\ImportExport\Archive\Import-Employees"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    gplog { sl "$env:SystemDrive\_Gem-Log-Archives"; break }
    gtb { sl "$env:GEM\_Gem-Toolbox"; break }
    gpsh { sl "$env:GEM\_Gem-Toolbox\PowerShell"; break }
    gpshf { sl "$env:GEM\_Gem-Toolbox\PowerShell\Functions"; break }
    gbf { sl "$env:GEM\_Gem-Toolbox\Batch-Files"; break }
    gem { sl "$env:GEM"; break }
    default { sl "$env:GEM"; break }
  }
} #  [ END ] : Gem-Cd