sal gemcd Gem-Cd -Option ReadOnly

function GEM-Cd ($dir) {

  switch ($dir) {
    gimp { sl "$env:GEM\ImportExport"; break }
    gdefs { sl "$env:GEM\Defs"; break }
    glogs { sl "$env:GEM\Log"; break }
    archive { sl "$env:GEM\ImportExport\Archive"; break }
    gimpemp { sl "$env:GEM\ImportExport\Archive\ImportEmployees"; break }
    desk { sl "$env:UserProfile\Desktop"; break }
    gplog { sl "$env:SystemDrive\_GPayLogArchives"; break }
    toolbox { sl "$env:SystemDrive\_gemToolbox"; break }
    ps { sl "$env:SystemDrive\_gemToolbox\PowerShell"; break }
    func { sl "$env:SystemDrive\_gemToolbox\PowerShell\Functions"; break }
    batch { sl "$env:SystemDrive\_gemToolbox\BatchScripts"; break }
    gem { sl "$env:GEM"; break }
    default { sl "$env:GEM" }
  }
}
