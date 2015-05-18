function autogem ($serverType) {

# VARIABLES
#-----------------------------------------------------------------------
$now = Get-Date
$sHTTP = "http://"
$sStamp = "[ START ] : "


# USER INPUT : IP Address of Server Hosting GEM Product
#-----------------------------------------------------------------------
$sIP = Read-Host "Enter server IP address: "


# Different GEM Product URL Endings
#-----------------------------------------------------------------------
$gemURL = "/GEM/Login.aspx"
$gpayURL = "/gempay/logon.aspx"
$gpay3URL = “/gempay3/logon.htm”



# ARGUMENT CONDITIONS : URL Ending Based Upon User Input
#-----------------------------------------------------------------------
switch ($serverType) {
    gp3 { $fullurl = $sHTTP + $sIP + $gpay3URL; break }
    gp { $fullurl = $sHTTP + $sIP + $gpayURL; break }
    gs { $fullurl = $sHTTP + $sIP + $gemURL; break }
    default { $fullurl = $sHTTP + $sIP + $gpay3URL; break }
}



# VARIABLES : Website Related
#-----------------------------------------------------------------------
$Username=”support”
$Password=Read-Host('Enter Site Password') -AsSecureString


# OPEN NOTEPAD - Append DateTimeStamp for Start & End Work Times
#      This can be used to take notes while working on the sites
#-----------------------------------------------------------------------
$np = "c:\windows\system32\notepad.exe"


# INVOKE INTERNET EXPLORER - Open URL and log into the site
#-----------------------------------------------------------------------
$IE = New-Object -com internetexplorer.application;
$IE.visible = $true;
$IE.navigate($fullurl);


# Wait a few seconds and then launch the executable.
#----------------------------------------------------
while ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }


# Select & Enter Variables to Site Fields
#----------------------------------------------------
$IE.Document.getElementById(“User”).value = $Username
$IE.Document.getElementByID(“Password”).value=$Password
$IE.Document.getElementById(“SubmitBtn”).Click()

while ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }

Invoke-Item $np
Add-Content $np "$sStamp $now `t$sIP"

} #exit Function
