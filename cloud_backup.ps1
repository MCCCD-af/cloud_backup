#Google Cloud Backup Program
#Written by: André Flores - 08/30/23


#MEID variable assignment
$meid = Read-Host "Enter your MEID (ALL CAPS)"


#Download URLs variable assignment 

$google_Drive = "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe"
$7zip = "https://www.7-zip.org/a/7z2201-x64.exe"

#Download folder variable assignment
$dest = "C:\Users\$meid\Downloads\"

#Downloads files and prompts for install
If (-not (get-package | where-Object { $_.Name -like '7-Zip*' })) 											#Checks for 7Zip
    { Write-Host "7Zip Not Installed" -ForegroundColor Red 
	Start-BitsTransfer -Source $7zip -Destination $dest 													#Downloads installation wizard
	& $dest\7z2201-x64.exe} Else {Write-Host "7Zip Installed" -ForegroundColor Green}						#Runs installation
If (-not (get-package | where-Object { $_.Name -like 'Google Drive*' }))
    { Write-Host "Google Drive Not Installed" -ForegroundColor Red 
	Start-BitsTransfer -Source $google_Drive -Destination $dest 
	& $dest\GoogleDriveSetup.exe} Else {Write-Host "Google Drive Installed" -ForegroundColor Green}

<#
Start-BitsTransfer -Source $google_Drive -Destination $dest
Start-BitsTransfer -Source $7zip -Destination $dest
cd C:\Users\$user\Downloads
& '.\GoogleDriveSetup.exe'
& '.\7z2201-x64.exe'
#>

#User verification for backup
Read-Host "Press enter to proceed with copy"

rm "C:\Users\$meid\Documents\My Pictures"
rm "C:\Users\$meid\Documents\My Music"
rm "C:\Users\$meid\Documents\My Videos"

#Copies data to Google Drive

robocopy C:\Users\$meid\Desktop    "G:\My Drive\backup_test\Desktop"   /E 
robocopy C:\Users\$meid\Downloads  "G:\My Drive\backup_test\Downloads" /E
robocopy C:\Users\$meid\Documents  "G:\My Drive\backup_test\Documents" /E
robocopy C:\Users\$meid\Pictures   "G:\My Drive\backup_test\Pictures"  /E

#Calculates SHA-256 checksum for file integrity and creates file for user verification

cd "C:\Program Files\7-Zip"
& .\7z h -scrcsha256 'G:\My Drive\backup_test' > 'G:\My Drive\backup_checksum'

#Verifies the process has completed
Read-Host "Data has been copied sucessfully press Enter to quit"

