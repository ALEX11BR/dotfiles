function CopyConfig {
    param (
        [String]$Source,
        [String]$Destination
    )
    Copy-Item -Path "$PSScriptRoot\..\$Source" -Destination "$Destination" -Recurse -Force
}

Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList @("-ExecutionPolicy", "Bypass", "-File", "$PSScriptRoot\admin_part.ps1")

CopyConfig -Source "Code" -Destination "$env:APPDATA"
CopyConfig -Source "qalculate" -Destination "$env:LOCALAPPDATA"
