#	PowerShell Script to Strip Quotes from the Import File
#------------------------------------------------------------------------------------------------------------

(Get-Content E:\GEM\ImportExport\_Scripts\_Good-Records\CCDEMO.06437.csv ) |
	% { $_ -replace '"','' } |
	out-file -FilePath E:\GEM\ImportExport\_Scripts\_Good-Records\CCDEMO.06437.csv -Force -en ascii