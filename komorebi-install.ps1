# Install komorebi
Write-Host "Installing komorebi..." -ForegroundColor Cyan
winget install --id LGUG2Z.komorebi

# Configure auto-start
Write-Host "Configuring auto-start..." -ForegroundColor Cyan
komorebic enable-autostart --bar --whkd

# Create symlink for config
$dotfilesPath = $PSScriptRoot
$komorebiConfig = "$env:USERPROFILE\.config\komorebi"

Write-Host "Creating config symlink..." -ForegroundColor Cyan
if (Test-Path $komorebiConfig) {
    Remove-Item $komorebiConfig -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $komorebiConfig -Target "$dotfilesPath\komorebi"

Write-Host "Komorebi installation complete!" -ForegroundColor Green
