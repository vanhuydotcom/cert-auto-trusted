# PowerShell Launcher Script
# This script is converted to .exe and serves as the entry point

# Get the directory where the launcher is located
$launcherDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Path to the main script and Root CA file. Installer places rootCA.pem
# directly in the application directory (next to this launcher), so look
# there first and fall back to a certs/ subfolder for dev/local runs.
$mainScript = Join-Path $launcherDir "Main.ps1"
$certPath = Join-Path $launcherDir "rootCA.pem"
if (-not (Test-Path $certPath)) {
    $certPath = Join-Path (Join-Path $launcherDir "certs") "rootCA.pem"
}

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

# Check if Root CA file exists
if (-not (Test-Path $certPath)) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show(
        "Root CA file not found: $certPath`n`nPlease ensure rootCA.pem is in the installation directory.",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Run the main script with the Root CA path
& PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File $mainScript -CertPath $certPath

