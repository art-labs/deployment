Get-LocalUser -Name "art" | Enable-LocalUser
$fn = join-path  ([Environment]::GetFolderPath("Desktop")) "youdidit.txt"
New-Item -Path $fn -ItemType File