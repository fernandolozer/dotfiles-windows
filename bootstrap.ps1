$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"

New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./home/** -Destination $home -Include **
Copy-Item -Path ./home/fastfetch.config.jsonc -Destination $home/.config/fastfetch/config.jsonc
Copy-Item -Path ./nvim/** -Destination $home/.config/nvim -Recurse -Force

Remove-Variable componentDir
Remove-Variable profileDir
