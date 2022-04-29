param(
    [Parameter(Mandatory = $true)]
    [string]$OneDriveOrgName
)

<#
.SYNOPSIS
    Sets a known folder's path using SHSetKnownFolderPath.
.PARAMETER Folder
    The known folder whose path to set.
.PARAMETER Path
    The path.
#>
function Set-KnownFolderPath {
    Param (
            [Parameter(Mandatory = $true)]
            [ValidateSet('Downloads1', 'Downloads2')]
            [string]$KnownFolder,

            [Parameter(Mandatory = $true)]
            [string]$Path
    )

    # Define known folder GUIDs
    $KnownFolders = @{
        'Downloads1' = '374DE290-123F-4565-9164-39C4925E467B';
        'Downloads2' = '7D83EE9B-2244-4E70-B1F5-5393042Af1E4';
    }

    # Define SHSetKnownFolderPath if it hasn't been defined already
    $Type = ([System.Management.Automation.PSTypeName]'KnownFolders').Type
    if (-not $Type) {
        $Signature = @'
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
'@
        $Type = Add-Type -MemberDefinition $Signature -Name 'KnownFolders' -Namespace 'SHSetKnownFolderPath' -PassThru
    }

	# Make path, if doesn't exist
	if(!(Test-Path $Path -PathType Container)) {
		New-Item -Path $Path -type Directory -Force
    }

    # Validate the path
    if (Test-Path $Path -PathType Container) {
        # Call SHSetKnownFolderPath
        return $Type::SHSetKnownFolderPath([ref]$KnownFolders[$KnownFolder], 0, 0, $Path)
    } else {
        throw New-Object System.IO.DirectoryNotFoundException "Could not find part of the path $Path."
    }
}

# This will also move the files from the User's Profile to OneDrive
$oneDriveSyncPath = "$env:USERPROFILE\OneDrive - $OneDriveOrgName"

# Redirect Downloads Folder to OneDrive
# Downloads1 is accessible via Quick start > Downloads. Downloads2 is accessible via This PC > Downloads. They use a different Known Folder GUID
Set-KnownFolderPath -KnownFolder 'Downloads1' -Path "$oneDriveSyncPath\Downloads"
Set-KnownFolderPath -KnownFolder 'Downloads2' -Path "$oneDriveSyncPath\Downloads"

# Move files from User's Profile Downloads to the OneDrive Downloads Folder
Move-Item -Path "$($env:USERPROFILE)\Downloads\*" -Destination "$($oneDriveSyncPath)\Downloads" -Force