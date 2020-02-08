param([string] $name)
Write-Host $name
#New-Item -Path (Join-Path ([Environment]::GetFolderPath("Desktop")) "youdidit.txt") -ItemType File