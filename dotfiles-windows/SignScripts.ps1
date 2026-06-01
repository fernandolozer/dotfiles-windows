# PowerShell Script to Create a Self-Signed Certificate and Sign All Scripts in a Folder (Excluding Itself)
# Run this script as Administrator

# Set the folder containing the scripts to sign (Modify this path)
$scriptFolder = "C:\Users\Fernando\Documents\dotfiles-windows"

# Get the current script path to exclude it from signing
$selfScriptPath = $MyInvocation.MyCommand.Path

# Validate folder exists
if (-Not (Test-Path $scriptFolder)) {
    Write-Host "Error: Folder not found at $scriptFolder. Please update the path." 
    exit
}

Write-Host "Creating a Self-Signed Code-Signing Certificate..."

# Create a new self-signed certificate for code signing
$cert = New-SelfSignedCertificate -Type CodeSigningCert -Subject "CN=PowerShell Code Signing" `
    -KeyUsage DigitalSignature -CertStoreLocation Cert:\CurrentUser\My

Write-Host "Certificate created successfully!" 

# Move the certificate to Trusted Root (Optional - prevents warnings)
Write-Host "Adding the certificate to Trusted Root Certification Authorities..." 
$certThumbprint = $cert.Thumbprint
Move-Item -Path "Cert:\CurrentUser\My\$certThumbprint" -Destination "Cert:\CurrentUser\Root" -Force

Write-Host "Certificate added to Trusted Root." 

# Get all .ps1 files in the folder (excluding this script)
$scriptFiles = Get-ChildItem -Path $scriptFolder -Filter "*.ps1" | Where-Object { $_.FullName -ne $selfScriptPath }

if ($scriptFiles.Count -eq 0) {
    Write-Host "No PowerShell scripts found in $scriptFolder." 
    exit
}

# Sign each script
Write-Host "Signing scripts in folder: $scriptFolder ..." 

foreach ($script in $scriptFiles) {
    Write-Host "Signing: $($script.FullName)" 
    Set-AuthenticodeSignature -FilePath $script.FullName -Certificate $cert -TimestampServer "http://timestamp.digicert.com"

    # Verify the signature
    $signature = Get-AuthenticodeSignature -FilePath $script.FullName

    if ($signature.Status -eq "Valid") {
        Write-Host " Successfully signed: $($script.FullName)" 
    } else {
        Write-Host "Failed to sign: $($script.FullName)"
    }
}

# Set execution policy to allow signed scripts (optional)
Write-Host "Setting Execution Policy to 'AllSigned'..." 
Set-ExecutionPolicy AllSigned -Scope CurrentUser -Force

Write-Host "Done! All scripts in the folder have been signed." 
