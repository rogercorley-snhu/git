#	PowerShell Script to Strip Quotes from the Import File
#------------------------------------------------------------------------------------------------------------

(Get-Content <FULL_FILENAME_PATH> ) |
	% { $_ -replace '"','' } |
	out-file -FilePath <FULL_FILENAME_PATH> -Force -en ascii