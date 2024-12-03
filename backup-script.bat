@echo off
setlocal enabledelayedexpansion

:: Set backup location
set backup_location=D:\Backup

:: Set source files and folders
set source_files=C:\Users\YourUsername\Documents
set source_folders=C:\Users\YourUsername\Pictures,C:\Users\YourUsername\Videos

:: Set backup frequency (daily, weekly, monthly)
set backup_frequency=daily

:: Set compression option (yes/no)
set compress=yes

:: Set encryption option (yes/no)
set encrypt=yes

:: Set encryption password
set encrypt_password=your_password

:: Create backup folder
mkdir "%backup_location%\%backup_frequency%"

:: Copy files and folders to backup location
xcopy /s /y "%source_files%" "%backup_location%\%backup_frequency%\"
for %%f in (%source_folders%) do xcopy /s /y "%%f" "%backup_location%\%backup_frequency%\"

:: Compress backup files
if /i "%compress%"=="yes" (
    powershell -Command "Compress-Archive -Path '%backup_location%\%backup_frequency%' -DestinationPath '%backup_location%\%backup_frequency%.zip'"
)

:: Encrypt backup files
if /i "%encrypt%"=="yes" (
    powershell -Command "Protect-CmsMessage -Path '%backup_location%\%backup_frequency%.zip' -To 'your_email_address' -OutFile '%backup_location%\%backup_frequency%.zip.pfx'"
)

:: Display success message
echo Backup complete!

:: Send email notification
powershell -Command "Send-MailMessage -From 'your_email_address' -To 'recipient_email_address' -Subject 'Backup Complete' -Body 'Your backup is complete.' -SmtpServer '(link unavailable)' -Port 587 -UseSsl -Credential (New-Object System.Management.Automation.PSCredential ('your_email_address', (ConvertTo-SecureString 'your_email_password' -AsPlainText -Force))))"

:: Clean up
del /f /q "%backup_location%\%backup_frequency%\*.*"
rmdir /s /q "%backup_location%\%backup_frequency%"

exit /b 0
