# The downloads will remain in OneDrive, but the known folder will be redirected to the downloads folder in the user's profile. 

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

# Redirect Downloads Folder to User's Profile
# Downloads1 is accessible via Quick start > Downloads. Downloads2 is accessible via This PC > Downloads. They use a different Known Folder GUID
Set-KnownFolderPath -KnownFolder 'Downloads1' -Path "$($env:USERPROFILE)\Downloads"
Set-KnownFolderPath -KnownFolder 'Downloads2' -Path "$($env:USERPROFILE)\Downloads"