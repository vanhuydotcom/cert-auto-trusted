# Trust Root CA in Windows Certificate Store
# Adds a self-signed Root CA to Trusted Root Certification Authorities

param(
    [Parameter(Mandatory=$false)]
    [string]$CertPath,
    
    [Parameter(Mandatory=$false)]
    [string]$Thumbprint,
    
    [Parameter(Mandatory=$false)]
    [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator to trust certificates!" -ForegroundColor Red
    Write-Host "Please right-click and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

try {
    # Load certificate based on input
    if ($Certificate) {
        $cert = $Certificate
    } elseif ($Thumbprint) {
        $cert = Get-ChildItem -Path "Cert:\CurrentUser\My\$Thumbprint" -ErrorAction Stop
    } elseif ($CertPath) {
        if (-not (Test-Path $CertPath)) {
            Write-Host "ERROR: Certificate file not found: $CertPath" -ForegroundColor Red
            exit 1
        }
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)
    } else {
        Write-Host "ERROR: Must provide either -CertPath, -Thumbprint, or -Certificate parameter" -ForegroundColor Red
        exit 1
    }
    
    # Reject leaf certificates (must be a self-signed CA)
    if ($cert.Subject -ne $cert.Issuer) {
        Write-Host "ERROR: Refusing to install. Certificate is not self-signed (Subject != Issuer)." -ForegroundColor Red
        Write-Host "Only self-signed Root CAs may be added to the Trusted Root store." -ForegroundColor Yellow
        exit 1
    }
    $bc = $cert.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.19' }
    if (-not $bc -or -not $bc.CertificateAuthority) {
        Write-Host "ERROR: Refusing to install. Certificate does not have BasicConstraints CA:TRUE." -ForegroundColor Red
        exit 1
    }

    Write-Host "Adding Root CA to Trusted Root Certification Authorities..." -ForegroundColor Green
    Write-Host "Subject: $($cert.Subject)" -ForegroundColor Cyan
    Write-Host "Thumbprint: $($cert.Thumbprint)" -ForegroundColor Cyan
    
    # Open the Trusted Root store
    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store(
        [System.Security.Cryptography.X509Certificates.StoreName]::Root,
        [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
    )
    
    $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
    
    # Check if certificate already exists
    $existingCert = $store.Certificates | Where-Object { $_.Thumbprint -eq $cert.Thumbprint }
    
    if ($existingCert) {
        Write-Host "Certificate already exists in Trusted Root store!" -ForegroundColor Yellow
    } else {
        # Add certificate to store
        $store.Add($cert)
        Write-Host "Certificate successfully added to Trusted Root Certification Authorities!" -ForegroundColor Green
    }
    
    $store.Close()
    
    Write-Host "`nCertificate is now trusted by Windows!" -ForegroundColor Green
    return $true
    
} catch {
    Write-Host "ERROR: Failed to trust certificate!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

