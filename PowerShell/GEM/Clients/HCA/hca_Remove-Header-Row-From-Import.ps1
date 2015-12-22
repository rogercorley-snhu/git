#       REMOVE HEADER ROW - When it matches pattern
#---------------------------------------------------------------------------------------------

$file = "E:\GEM\ImportExport\CCDEMO.01533"


( Get-Content $file | Where-Object { $_ -notmatch '"FicaNbr","BadgeNbr","EmpStatus","LastName","FirstName"' } ) | Set-Content $file