#----------------------------------------------------------------------------------------------------------------
#   PowerShell Example :: Bulk Rename of Files
#----------------------------------------------------------------------------------------------------------------

#   rename old GEMdaily.cp & gemonline.log Files
#----------------------------------------------------------------------------------------------------------------
Get-ChildItem GEMdaily.* | Rename-Item -newname { $_.name -replace '\.cp','.log0' }
Get-ChildItem gemonline.* | Rename-Item -newname { $_.name -replace '\.log','.log0' }