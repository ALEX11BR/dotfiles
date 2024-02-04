#Requires -RunAsAdministrator

function InstallFont {
    param (
        [String]$FontPath
    )

    $FontName = [System.IO.Path]::GetFileNameWithoutExtension($FontPath)

    Copy-Item "$FontPath" "$env:WINDIR\Fonts"
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "$FontName (TrueType)" /t REG_SZ /d "$FontName.ttf" /f
}

Set-ExecutionPolicy Bypass

Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe

winget install --id 7zip.7zip
winget install --id clsid2.mpc-hc
winget install --id Git.Git
winget install --id Microsoft.VisualStudioCode
winget install --id Qalculate.Qalculate
winget install --id qBittorrent.qBittorrent
winget install --id valinet.ExplorerPatcher
wsl --install

foreach ($FontFile in (Get-ChildItem -Path $PSScriptRoot\..\iosevka-custom)) {
    if ($FontFile -like "*.ttf") {
	    InstallFont -FontPath $FontFile.FullName
    }
}

regedit /s "$PSScriptRoot\ExplorerPatcher.reg"
regedit /s "$PSScriptRoot\HoverToFocus.reg"
regedit /s "$PSScriptRoot\oktime.reg"
