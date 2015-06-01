function Stamp-File {

    param( [string] $fileName )

    if ( !(Test-Path $fileName)) { break }

    "Original Filename: $filename"

    $fileObj = get-item $fileName

    $date = Get-Date -Format "yyyy-MM-dd_hh.mm.ss"

    $ext = $fileObj.Extension

    if ($ext.Length -eq 0) {
        $name = $fileObj.Name
        Rename-Item "$fileObj" "$name-$date"
    }

    else {
        $name = $fileObj.Name.Replace( $fileObj.Extension,'')
        Rename-Item "$fileName" "$name-$date"
    }

    "New Filename: $name-$date$ext"
}