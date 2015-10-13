Set-Location D:\GEM\ImportExport\_Good-Records

$arcD = "D:\GEM\ImportExport\_Good-Records\Archive"

$date = Get-Date -format yyyy-MM-dd  # Variable for DateStamp in archived filename.
$limit = $date.AddDays(-30)


$exp = '([0-9]+?)(,"[0-9]+?",)'	# Variable for regular expression used in the -replace statement.


$cleanup = Get-Content D:\GEM\ImportExport\_Good-Records\GemPay-Nebraska-Demo.csv | %{ $_ -replace $exp,'"$1"$2' } | Out-File D:\GEM\ImportExport\_Good-Records\GemPay-Nebraska-Demo_TEST.csv -Force ascii


# Renaming and Moving Orginal .CSV to \Archive Directory
#----------------------------------------------------------
Rename-Item -Path GemPay-Nebraska-Demo.csv -NewName GemPay-Nebraska-Demo_$date.csv -Force
Move-Item -Path GemPay-Nebraska-Demo_$date.csv -Destination D:\GEM\ImportExport\_Good-Records\Archive

# Renaming Cleaned .CSV to Original Name for Import Process
#----------------------------------------------------------
Rename-Item -Path GemPay-Nebraska-Demo_TEST.csv -NewName GemPay-Nebraska-Demo.csv -Force



# Remove Oldest Archive
#----------------------------------------------------------
#gci $arcD | Sort LastWriteTime | Select -Last 1 | Remove-Item