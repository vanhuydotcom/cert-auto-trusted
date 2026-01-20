# Main Certificate Auto-Trust Application
# Trusts existing SSL certificates on Windows

param(
    [Parameter(Mandatory=$false)]
    [string]$CertPath = ".\certs\cert.pem",

    [Parameter(Mandatory=$false)]
    [string]$KeyPath = ".\certs\key.pem",

    [Parameter(Mandatory=$false)]
    [switch]$Silent
)

# Set script location as working directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

if (-not $Silent) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Certificate Auto-Trust Tool" -ForegroundColor Cyan
    Write-Host "  Install SSL Certificate to Windows" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This application must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host ""
    if (-not $Silent) {
        Read-Host "Press Enter to exit"
    }
    exit 1
}

# Check if certificate file exists
if (-not (Test-Path $CertPath)) {
    Write-Host "ERROR: Certificate file not found: $CertPath" -ForegroundColor Red
    Write-Host ""
    if (-not $Silent) {
        Read-Host "Press Enter to exit"
    }
    exit 1
}

if (-not $Silent) {
    Write-Host "Certificate file: $CertPath" -ForegroundColor Cyan
    if (Test-Path $KeyPath) {
        Write-Host "Key file: $KeyPath" -ForegroundColor Cyan
    }
    Write-Host ""
}

try {
    # Load the certificate
    Write-Host "Loading certificate..." -ForegroundColor Green

    # Try to load as X509Certificate2
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)

    Write-Host "Certificate loaded successfully!" -ForegroundColor Green
    Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Cyan
    Write-Host "  Issuer: $($cert.Issuer)" -ForegroundColor Cyan
    Write-Host "  Valid From: $($cert.NotBefore)" -ForegroundColor Cyan
    Write-Host "  Valid To: $($cert.NotAfter)" -ForegroundColor Cyan
    Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Cyan
    Write-Host ""

    # Trust the certificate
    Write-Host "Installing certificate to Trusted Root Certification Authorities..." -ForegroundColor Green

    $trustScript = Join-Path $scriptPath "TrustCertificate.ps1"
    $result = & $trustScript -Certificate $cert

    if ($result) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "  Certificate Installed Successfully!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "The certificate is now trusted by Windows." -ForegroundColor Green
        Write-Host "Browsers using Windows certificate store (Chrome, Edge) will trust this certificate." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Note: Firefox uses its own certificate store and requires separate configuration." -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host "ERROR: Failed to install certificate!" -ForegroundColor Red
        exit 1
    }

} catch {
    Write-Host "ERROR: Failed to process certificate!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    if (-not $Silent) {
        Read-Host "Press Enter to exit"
    }
    exit 1
}

# Keep window open
if (-not $Silent) {
    Read-Host "Press Enter to exit"
}

