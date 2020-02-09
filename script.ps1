param([string] $Password)

function Disable-OOBE {
    $p = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE"
    $n = "DisablePrivacyExperience"
    New-Item -Path $p -Force
    New-ItemProperty -Path $p -Name $n -Value 1 -Type DWORD -Force
}

function Add-DesktopShortCutsToDefaultProfile {
    $TargetFile = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    $ShortcutFile = "C:\Users\Default\Desktop\powershell.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.WorkingDirectory = "%HOMEDRIVE%%HOMEPATH%"
    $Shortcut.Save()
    
    $TargetFile = "$env:SystemRoot\System32\cmd.exe"
    $ShortcutFile = "C:\Users\Default\Desktop\command prompt.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.WorkingDirectory = "%HOMEDRIVE%%HOMEPATH%"
    $Shortcut.Save()
}

function Disable-NetworkDiscovery {
    Set-NetConnectionProfile -Name (Get-NetConnectionProfile).Name -NetworkCategory Public
}

function Add-ArtUser {
    net user art $Password /add /y
    net localgroup Administrators art /add
    net localgroup "Remote Desktop Users" art /add
}

Disable-OOBE
Add-DesktopShortCutsToDefaultProfile
Add-ArtUser
Disable-NetworkDiscovery