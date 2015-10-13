
Function MDSHost-Push ($destination, $overwritePrompt)
{

	$source= 'C:\MICROS\Common\Etc\MDSHost.xml'
	$name = 'MDSHosts.xml'


	$ws5a = 'C:\MICROS\Res\CAL\WS5A\Files\CF\Micros\ETC'
	$ws5 = 'C:\MICROS\Res\CAL\WS5\Files\CF\Micros\ETC'
	$ws4lx = 'C:\MICROS\Res\CAL\WS4LX\Files\CF\Micros\ETC'
	$ws4 = 'C:\MICROS\Res\CAL\WS4\Files\CF\Micros\ETC'


	$paramlist = {
		'Enter MDSHost-Push with the parameters listed below.'
		'-------------------------------------------------------------------------------'
		'First Parameter: ---- File Copy Destination ----'
		'                                                                               .'
		'----  Use "all" to push MDSHosts file to all Workstation ETC directories.',
		'----  Use "5a" to push the MDSHosts file to the WS5a ETC directory only.',
		'----  Use "5" to push the MDSHosts file to the WS5 ETC directory only.',
		'----  Use "4lx" to push the MDSHosts file to the WS4LX ETC directory only.',
		'----  Use "4" to push the MDSHosts file to the WS4 ETC directory only.'
		'==============================================================================='
		'Second Parameter: ---- OverWrite Confirmation ----'
		'                                                                               .'
		'----  Type "y" to confirm any file overwrites.'
		'----  Type "n" to force any overwrite prompts.'
		'----  Leaving this paramter blank will default to Confirm OverWrites.'
		'==============================================================================='
		'                                                                               .'
		'****  EXAMPLES:  ****'
		'-------------------------------------------------------------------------------'
		'                                                                               .'
		'MDSHost-Push ws5a y --- Copies the current MDSHosts file to the WS5A ETC'
		'directory and will confirm overwrites.'
		'                                                                               .'
		'MDSHost-Push all n --- Copies the current MDSHosts file to ALL workstation'
		'ETC directories and forces overwrites.'


	}

	Switch ($destination) {
		all { $destination = 'all'; break }
		ws5a { $destination = $ws5a; break }
		ws5 { $destination = $ws5; break }
		ws4lx { $destination = $ws4lx; break }
		ws4 { $destination = $ws4; break }
		default { $destination = ''; break }
	}

	clear-host

	if ( test-path (!$source ) )  { echo "Invalid source path provided." }

	if ( !$destination  ) { $paramlist }

	if ( $destination -eq 'all' ) {
			if ( $overwritePrompt -eq 'n' ) {
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS4\Files\CF\Micros\ETC -Force;
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS4LX\Files\CF\Micros\ETC -Force;
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS5\Files\CF\Micros\ETC -Force;
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS5A\Files\CF\Micros\ETC -Force;
				}	else {
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS4\Files\CF\Micros\ETC -Confirm;
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS4LX\Files\CF\Micros\ETC -Confirm;
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS5\Files\CF\Micros\ETC -Confirm;
						copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination C:\MICROS\Res\CAL\WS5A\Files\CF\Micros\ETC -Confirm;
					}

			}

	if ( ( $destination ) -and ( $destination -ne 'all'  ) ) {
		$fullname =  '{0}' -f $destination
		if ( $overwritePrompt -eq 'n' ) { copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination $fullname -Force }
		else { copy-item -path C:\MICROS\Common\Etc\MDSHost.xml -destination $fullname -Confirm }
	}
}

