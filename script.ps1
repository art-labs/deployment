Get-LocalUser -Name "art" | Enable-LocalUser
New-Item -Path "C:\Users\art\Desktop\youdidit.txt" -ItemType File
$p = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OOBE"
$n = "DisablePrivacyExperience"
New-Item -Path $p –Force
New-ItemProperty -Path $p -Name $n -Value 1 -Type DWORD -Force