#Google Cloud Paste Program
#Written by: André Flores - 08/30/23


#Warning for technician
Write-Host "ONLY RUN AFTER cloud_backup HAS COMPLETED"

#MEID variable assignment
$meid = Read-Host "Enter your MEID (ALL CAPS)"

#Download URLs variable assignment 

$google_Drive = "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe"
$7zip = "https://www.7-zip.org/a/7z2201-x64.exe"

#Download folder variable assignment
$dest = "C:\Users\$meid\Downloads\"


#Download and installation of Google Drive/7Zip
If (-not (get-package | where-Object { $_.Name -like '7-Zip*' })) 											#Checks for 7Zip
    { Write-Host "7Zip Not Installed" -ForegroundColor Red 
	Start-BitsTransfer -Source $7zip -Destination $dest 													#Downloads installation wizard
	& $dest\7z2201-x64.exe} Else {Write-Host "7Zip Installed" -ForegroundColor Green}						#Runs installation
If (-not (get-package | where-Object { $_.Name -like 'Google Drive*' }))
    { Write-Host "Google Drive Not Installed" -ForegroundColor Red 
	Start-BitsTransfer -Source $google_Drive -Destination $dest 
	& $dest\GoogleDriveSetup.exe} Else {Write-Host "Google Drive Installed" -ForegroundColor Green}

#Prompt for technician
Read-Host "Press ENTER after Google Sign-in and 7Zip install"



#Recalulates checksum and assigns to paste_sum 

cd "C:\Program Files\7-Zip"
& .\7z h -scrcsha256 'G:\My Drive\backup_test' > 'G:\My Drive\paste_checksum'

#Assigns checksum variable names
$copy_sum = Select-String -Path 'G:\My Drive\backup_checksum' -Pattern "SHA256 for data:" | Select-Object -ExpandProperty Line
$paste_sum = Select-String -Path 'G:\My Drive\paste_checksum' -Pattern "SHA256 for data:" | Select-Object -ExpandProperty Line

#If statement that evaluates the two cheksums won't let the user proceed if it fails
IF ($copy_sum -ne $paste_sum )
{
       Write-Host "Checksum Failed" -ForegroundColor Red
       Write-Host "Suggestion: Delete cloud backup file and run cloud_backup again" -ForegroundColor Red
       Exit
} else {Write-host "Checksum Validated" -ForegroundColor Green}

#User verification for paste
Read-Host "Press enter to proceed with paste"

#Copies data from Google Drive

robocopy "G:\My Drive\backup_test\Desktop"   C:\Users\$meid\Desktop\   /E
robocopy "G:\My Drive\backup_test\Downloads" C:\Users\$meid\Downloads\ /E
robocopy "G:\My Drive\backup_test\Documents" C:\Users\$meid\Documents\ /E
robocopy "G:\My Drive\backup_test\Pictures"  C:\Users\$meid\Pictures\  /E


#Verifies the process has been completed
Read-Host "Data has been copied sucessfully press Enter to quit"