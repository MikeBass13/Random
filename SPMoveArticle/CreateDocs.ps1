$tenantUrl = "https://TENANTX.sharepoint.com"
$sourceSiteUrl = "/sites/SITENAME"
$user1 = "<USERNAME_1>"
$pass1 = "<PASSWORD_FOR_USER_1>"
$user2 = "<USERNAME_2>"
$pass2 = "<PASSWORD_FOR_USER_2>"

$libUrl = "Shared Documents"
$sourceFolder = "Source"

$encpassword = convertto-securestring -String $pass1 -AsPlainText -Force
$username = $user1
$creds = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
Connect-PnPOnline -Url  $tenantUrl$sourceSiteUrl -Credentials $creds

for(($i=1);$i -lt 10; $i++)
{
	Write-Host "Processing Test Files: "$i
	$myFile = Add-PnPFile -Path ".\V1\SourceDocument.docx" -Folder "$libUrl/$sourceFolder/Test $i" -Values @{MyText="DOCX 1"; MyNum="1"}
	$myFile = Add-PnPFile -Path ".\V2\SourceDocument.docx" -Folder "$libUrl/$sourceFolder/Test $i" -Values @{MyText="DOCX 2"; MyNum="2"}
	$myFile = Add-PnPFile -Path ".\V3\SourceDocument.docx" -Folder "$libUrl/$sourceFolder/Test $i" -Values @{MyText="DOCX 3"; MyNum="3"}
	$myFile = Add-PnPFile -Path ".\V1\SourceTextFile.txt"  -Folder "$libUrl/$sourceFolder/Test $i" -Values @{MyText="TXT 1"; MyNum="1"}
	$myFile = Add-PnPFile -Path ".\V2\SourceTextFile.txt"  -Folder "$libUrl/$sourceFolder/Test $i" -Values @{MyText="TXT 2"; MyNum="2"}
	$myFile = Add-PnPFile -Path ".\V3\SourceTextFile.txt"  -Folder "$libUrl/$sourceFolder/Test $i" -Values @{MyText="TXT 3"; MyNum="3"}
}
Disconnect-PnPOnline


$encpassword = convertto-securestring -String $pass2 -AsPlainText -Force
$username = $user2
$creds = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
Connect-PnPOnline -Url $tenantUrl$sourceSiteUrl -Credentials $creds
for(($i=1);$i -lt 10; $i++)
{
	Write-Host "Updating Test Files: "$i
	$myFile = Get-PnPFile -Url "$sourceSiteUrl/$libUrl/$sourceFolder/Test $i/SourceDocument.docx" -AsListItem
	$myItem = Set-PnPListItem -List "Documents" -Identity $myFile -Values @{MyText="DOCX 4"; MyNum="4"}
	$myFile = Get-PnPFile -Url "$sourceSiteUrl/$libUrl/$sourceFolder/Test $i/SourceTextFile.txt" -AsListItem
	$myItem = Set-PnPListItem -List "Documents" -Identity $myFile -Values @{MyText="TXT 4"; MyNum="4"}
}
Disconnect-PnPOnline

