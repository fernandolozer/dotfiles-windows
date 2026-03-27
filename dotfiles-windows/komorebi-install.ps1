# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);

    exit
}

# Install komorebi
Write-Host "Installing komorebi..." -ForegroundColor Cyan
winget install LGUG2Z.komorebi
winget install LGUG2Z.whkd

setx PATH "$($env:Path);C:\Program Files\whkd\"

Refresh-Environment

Copy-Item -Path "./komorebi/komorebi.json" -Destination "$HOME" -Force
Copy-Item -Path "./komorebi/komorebi.bar.json" -Destination "$HOME" -Force
Copy-Item -Path "./komorebi/applications.json" -Destination "$HOME" -Force
Copy-Item -Path "./komorebi/whkdrc" -Destination "$HOME/.config/" -Force

# Configure auto-start
Write-Host "Configuring auto-start..." -ForegroundColor Cyan

komorebic enable-autostart --bar --whkd

taskkill /f /im whkd.exe; Start-Process whkd -WindowStyle hidden
taskkill /f /im komorebi-bar.exe; Start-Process komorebi-bar -WindowStyle hidden
komorebic start

Write-Host "Komorebi installation complete!" -ForegroundColor Green


$startup = [Environment]::GetFolderPath("Startup")
$scriptPath = Join-Path $startup "komorebi-start.cmd"

Remove-Item $scriptPath -ErrorAction SilentlyContinue
