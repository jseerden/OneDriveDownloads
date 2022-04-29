# OneDriveDownloads
Package source to IntuneWin with the Microsoft Win32 Content Prep Tool: https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool

## %OrgName%
Make sure to modify `%OrgName%` to the OneDriveOrgName of your organization in the `Move-DownloadsFolderToOneDrive.ps1` install script and `Detect-DownloadsFolderToOneDrive.ps1` detection script.

## Package cmdlet
IntuneWinAppUtil.exe -c 'Source' -s 'Source\Move-DownloadsFolderToOnedrive.ps1' -o 'Package'

# Intune Win32 App install commands
Install command: PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Move-DownloadsFolderToOnedrive.ps1" -OneDriveOrgName "%OrgName%"
Uninstall cmdlet: PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Move-DownloadsFolderToUserProfile.ps1"

Replace "%OrgName%" with your organization's OneDriveOrgName. for example: -OneDriveOrgName "Contoso".

## Detection rules
Custom detection script: Detect-DownloadsFolderToOneDrive.ps1

Modify the detection script and replace "%OrgName%" with your organization's OneDriveOrgName.