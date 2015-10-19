	@echo off
	cls
	setlocal ENABLEDELAYEDEXPANSION

	echo Beginning Import Processes....

	echo ................................

	echo Running Verify-Import Script....


::-------[ ****  Verify Import  ****  ]
::========================================================================================================================================

	cscript E:\GEM\ImportExport\_Scripts\Verify-ImportFile.vbs


	echo ................................

	echo Running StripQuotes Script....


::-------[ ****  Strip Quotes  ****  ]
::========================================================================================================================================

	Powershell.exe -executionpolicy remotesigned -File E:\GEM\ImportExport\_Scripts\StripQuotes.ps1



	echo ................................

	echo Excuting RunScript Import Processes....



::-------[ ****  Execute RunScript  ****  ]
::========================================================================================================================================

	E:\GEM\runscript script=Import_v1_71.gsf,user=gem_impexp,pw=gemie,svr=CRMCWPAPPGEM01,core=1,module=300,database=GEMdb,importfile=\_Scripts\_Good-Records\CCDEMO.06437.csv


