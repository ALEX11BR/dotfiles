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

winget install 7zip.7zip
winget install Microsoft.VisualStudioCode
winget install Qalculate.Qalculate
winget install valinet.ExplorerPatcher

foreach ($FontFile in (Get-ChildItem -Path $PSScriptRoot\..\iosevka-custom)) {
    if ($FontFile -like "*.ttf") {
	    InstallFont -FontPath $FontFile.FullName
    }
}

regedit /s "$PSScriptRoot\oktime.reg"
