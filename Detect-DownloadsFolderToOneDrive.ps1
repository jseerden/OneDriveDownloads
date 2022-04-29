if (((New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path) -like "*\OneDrive - %OrgName%\Downloads") {
    if(Test-Path "$($env:USERPROFILE)\OneDrive - %OrgName%\Downloads" -PathType Container) {
		Write-Output "Downloads folder is moved to OneDrive"
    } else {
        Write-Error "Downloads folder is missing, Downloads were not moved to OneDrive"
    }
} else {
    Write-Error "Downloads folder is not moved to OneDrive"
}
