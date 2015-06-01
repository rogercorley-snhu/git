#  Gem-Web-AutoLogin
#---------------------------------------------------------------------------------------------------------------
$serverType = Read-Host "Enter Server Type"

# VARIABLE : URL Header
#-----------------------------------------------------------------------
$sHTTP = "http://localhost/"


# VARIABLES : GEM Product Site Pages
#-----------------------------------------------------------------------
$gem = "/GEM/Login.aspx"
$gserve = "/GEMserve4"
$gpay = "/GEMpay/logon.aspx"
$gpay3 = “/GEMpay3/logon.htm”


# ARGUMENT CONDITIONS : URL Ending Based Upon User Input
#-----------------------------------------------------------------------
Switch ($serverType) {
    gemserve {
                $fullurl = $sHTTP + $gserve


             }
    gserve { $fullurl = $sHTTP + $gserve }
    serve { $fullurl = $sHTTP + $gserve }
    gs { $fullurl = $sHTTP + $gserve }
    gempay3 { $fullurl = $sHTTP + $gpay3 }
    gpay3 { $fullurl = $sHTTP + $gpay3 }
    gp3 { $fullurl = $sHTTP + $gpay3 }
    gempay { $fullurl = $sHTTP + $gpay }
    gpay { $fullurl = $sHTTP + $gpay }
    gp { $fullurl = $sHTTP + $gpay }
    gem { $fullurl = $sHTTP + $gem }
}


# VARIABLES : Website Related
#-----------------------------------------------------------------------
$sitePW=Read-Host("Enter Site Password") -AsSecureString


# INVOKE INTERNET EXPLORER - Open URL and log into the site
#-----------------------------------------------------------------------
$IE = New-Object -Com internetexplorer.application;
$IE.visible = $true;
$IE.navigate($fullurl);


# Wait a few seconds and then launch the executable.
#----------------------------------------------------
While ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }


# Select & Enter Variables to Site Fields
#----------------------------------------------------

if ( $serverType -eq "gempay3" -or $serverType -eq "gpay3" -or $serverType -eq "gp3" ) {

$IE.Document.getElementById(“User”).value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID(“Password”).value = $pw
$IE.Document.getElementById(“SubmitBtn”).Click()
}

elseif ( $serverType -eq "gempay" -or $serverType -eq "gpay" -or $serverType -eq "gp" ) {
$IE.Document.getElementById(“User”).value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID(“Password”).value = $pw
$IE.Document.getElementById(“SubmitBtn”).Click()
}

elseif ( $serverType -eq "gemserve" -or $serverType -eq "gserve" -or $serverType -eq "serve" ) {
$IE.Document.getElementById("txtUserID").value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID("txtPassword").value = $pw
$IE.Document.getElementById("btnLogin").Click()
}

else {
$IE.Document.getElementById("txtUserID").value = "support"

$pw = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sitePW))

$IE.Document.getElementByID("txtPassword").value = $pw
$IE.Document.getElementById("btnLogin").Click()
}

While ($IE.Busy -eq $true) { Start-Sleep -Milliseconds 2000; }