#       REMOVE HEADER ROW - When it matches pattern
#---------------------------------------------------------------------------------------------

$file = "E:\GEM\ImportExport\<FILE-NAME>"

(  Get-Content $file | Where-Object { $_ -notmatch '"FicaNbr","BadgeNbr","EmpStatus","LastName","FirstName"' }  ) | Set-Content $file