# this code mainly from: https://www.checkyourlogs.net/powershell-updating-the-default-and-all-user-profiles-registry/


# Add in the .DEFAULT User Profile
$DefaultProfile = "" | Select-Object SID, UserHive
$DefaultProfile.SID = "test"
$DefaultProfile.Userhive = "C:\Users\Default\NTuser.dat"

Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE LOAD HKU\$($DefaultProfile.SID) $($DefaultProfile.UserHive)" -Wait -WindowStyle Hidden

# Manipulate the registry
# https://support.microsoft.com/en-us/help/325347/how-to-run-a-logon-script-one-time-when-a-new-user-logs-on-in-windows
$key = "Registry::HKEY_USERS\$($DefaultProfile.SID)\Software\Microsoft\Windows\CurrentVersion\RunOnce"
New-Item -Path $key -Force | Out-Null
New-ItemProperty -Path $key -Name "Logon Script" -Value "powershell.exe -exec bypass C:\Scripts\RunOnceLogonScript.ps1" -PropertyType STRING | Out-Null
 

# Unload NTuser.dat        
[gc]::Collect()
Start-Sleep 1
Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE UNLOAD HKU\$($DefaultProfile.SID)" -Wait -WindowStyle Hidden | Out-Null
