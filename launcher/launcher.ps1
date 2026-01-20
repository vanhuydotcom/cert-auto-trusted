# PowerShell Launcher Script
# This script is converted to .exe and serves as the entry point

# Get the directory where the launcher is located
$launcherDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Path to the main script and certificate files
$mainScript = Join-Path $launcherDir "Main.ps1"
$certsDir = Join-Path $launcherDir "certs"
$certPath = Join-Path $certsDir "cert.pem"
$keyPath = Join-Path $certsDir "key.pem"

# Check if Main.ps1 exists
if (-not (Test-Path $mainScript)) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show(
        "Main.ps1 not found at: $mainScript",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Check if certificate files exist
if (-not (Test-Path $certPath)) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show(
        "Certificate file not found: $certPath`n`nPlease ensure cert.pem is in the installation directory.",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Run the main script with certificate paths
& PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File $mainScript -CertPath $certPath -KeyPath $keyPath

