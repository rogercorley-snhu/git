#  GEM-ROTATE-LOGS
#--------------------------------------------------------------------------------------------------------------

	$dc = 60

	$go = "$env:SystemDrive\gemonline.log"
	$gd = "$env:SystemDrive\GEMDaily.cp"

	$goName = "gemonline"
	$gdName = "GEMDaily"

	$logArc = "$env:SystemDrive\_Gem-Log-Archives"
	$golog = "$env:SystemDrive\_Gem-Log-Archives\_Rotate-Gem-Logs.log"
	
	$date = Get-Date
	$limit = (Get-Date).AddDays(-$dc)
	$stamp = Gem-Log-DateTime
	$nameStamp = Get-Date -Format "yyyy-MM-dd.HH-mm-ss"

	$line = "-------------------------------------------------------------------------------"
	$star = "*******************************************************************************"
	$dot = "..............................................................................."
	$space = " "

	Get-ChildItem -Path $logArc -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
		


	$deleteFiles = Get-ChildItem -Path $logArc -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit }

	foreach ($deleteFile in $deleteFiles) { 
		if ($deleteFile -ne $NULL) {

			$delMsg01 = "{0} : [ ROTATE ] : {1} is older than {2} days old." -f $stamp, $deleteFile, $dc
			$delMsg02 = "{0} : [ ROTATE ] : {1} has been deleted." -f $stamp, $deleteFile
		
				Out-FIle -FilePath $golog -Append -InputObject $space
				Out-FIle -FilePath $golog -Append -InputObject $line
				Out-FIle -FilePath $golog -Append -InputObject $star
				Out-FIle -FilePath $golog -Append -InputObject $line
				Out-FIle -FilePath $golog -Append -InputObject $space

			Out-File -FilePath $golog -Append -InputObject $delMsg01
				Out-FIle -FilePath $golog -Append -InputObject $dot
			Remove-Item -Force | Out-File -FilePath $golog -Append -InputObject $delMsg02
				Out-FIle -FilePath $golog -Append -InputObject $space
				Out-FIle -FilePath $golog -Append -InputObject $line
	
			$delMsg01
			$delMsg02

		}

		else {

			$delMsg03 = "{0} : [ ROTATE ] : All files are less than {2} days old." -f $stamp, $deleteFile, $dc
			$delMsg04 = "{0} : [ ROTATE ] : No files to delete!" -f $stamp

			$delMsg03
			$delMsg04

				Out-FIle -FilePath $golog -Append -InputObject $space
				Out-FIle -FilePath $golog -Append -InputObject $line
				Out-FIle -FilePath $golog -Append -InputObject $star
				Out-FIle -FilePath $golog -Append -InputObject $line
				Out-FIle -FilePath $golog -Append -InputObject $space

			Out-File -FilePath $golog -Append -InputObject $delMsg03
				Out-FIle -FilePath $golog -Append -InputObject $dot
			Out-File -FilePath $golog -Append -InputObject $delMsg04

				Out-FIle -FilePath $golog -Append -InputObject $space
				Out-FIle -FilePath $golog -Append -InputObject $line

		}
	}

	
	if ( !( Test-Path($go) ) ) {

				Out-FIle -FilePath $golog -Append -InputObject $line
				Out-FIle -FilePath $golog -Append -InputObject $space

		$goNotFound = "{0} : [ ERROR-NOT-FOUND ] : {1} does not exist." -f $stamp, $go | Out-File -FilePath $golog -Append
		$goNotFound

				Out-FIle -FilePath $golog -Append -InputObject $dot

	}

	else {

				Out-FIle -FilePath $golog -Append -InputObject $line
				Out-FIle -FilePath $golog -Append -InputObject $space

		$goFound = "{0} : [ MOVE-FILE ] : {1} exists. Moving to archive directory." -f $stamp, $go | Out-File -FilePath $golog -Append

		Move-Item -Path $go -Destination "$logArc\$goName.$nameStamp.log"

		$goFound

				Out-FIle -FilePath $golog -Append -InputObject $dot

	}
	

	if ( !( Test-Path($gd) ) ) {


		$gdNotFound = "{0} : [ ERROR-NOT-FOUND ] : {1} does not exist." -f $stamp, $gd | Out-File -FilePath $golog -Append
		$gdNotFound

	}

	else {


		$gdFound = "{0} : [ MOVE-FILE ] : {1} exists. Moving to archive directory." -f $stamp, $gd | Out-File -FilePath $golog -Append

		Move-Item -Path $gd -Destination "$logArc\$gdName.$nameStamp.cp"
		
		$gdFound

	}

 
