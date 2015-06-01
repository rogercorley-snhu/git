	function Gem-Archive-File {
		
		param( [string] $fileName )

        $arcDir = "C:\_Archive\"
  		$date = Get-Date -Format "yyyyMMdd_hh.mm.sss"


        Get-Item $fileName | foreach { 
            $oldName = $_.Name;
            $oldFull = $_.FullName;
            $oldExt = $_.Extension;
            $oldDir = $_.DirectoryName;

            $newName = $_.Name -replace "$oldExt","_$date.txt";

            Rename-Item -Path "$oldFull" -NewName "$newName";
            Write-Output $("Renamed {0} to {1}" -f $oldName, $newName );
        }
        
        $lastest = Get-ChildItem $fileName.DirectoryName -Include ".txt" | Sort-Object CreationTime -Descending | Select -First 1
        Get-Item $lastest


       
        ni "C:\_Test\test.txt" -Type file -Force
		
	}	#-----[ END : function Gem-RenameMove-Item ]-----------------------------------------------
	