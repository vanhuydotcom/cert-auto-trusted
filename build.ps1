# Build Script for Certificate Auto-Trust Tool
# Creates the .exe installer for Windows

param(
    [Parameter(Mandatory=$false)]
    [switch]$SkipPs2Exe,

    [Parameter(Mandatory=$false)]
    [switch]$SkipInnoSetup
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Building Certificate Auto-Trust Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running on Windows
if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne 'Win32NT') {
    Write-Host "ERROR: This build script must be run on Windows!" -ForegroundColor Red
    exit 1
}

# Check if cert.pem and key.pem exist in certs directory
if (-not (Test-Path "certs\cert.pem")) {
    Write-Host "ERROR: cert.pem not found in certs directory!" -ForegroundColor Red
    Write-Host "Please place your cert.pem file in the certs\ directory." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "certs\key.pem")) {
    Write-Host "WARNING: key.pem not found in certs directory!" -ForegroundColor Yellow
    Write-Host "The installer will be created without the private key file." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Found certificate files:" -ForegroundColor Green
Write-Host "  - certs\cert.pem: $(if (Test-Path 'certs\cert.pem') { 'OK' } else { 'MISSING' })" -ForegroundColor Cyan
Write-Host "  - certs\key.pem: $(if (Test-Path 'certs\key.pem') { 'OK' } else { 'MISSING' })" -ForegroundColor Cyan
Write-Host ""

# Create necessary directories
$directories = @("dist", "launcher")
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created directory: $dir" -ForegroundColor Green
    }
}

# Step 1: Convert PowerShell script to EXE using ps2exe
if (-not $SkipPs2Exe) {
    Write-Host ""
    Write-Host "Step 1: Converting PowerShell launcher to EXE..." -ForegroundColor Yellow
    
    # Check if ps2exe is installed
    $ps2exeInstalled = Get-Module -ListAvailable -Name ps2exe
    
    if (-not $ps2exeInstalled) {
        Write-Host "ps2exe module not found. Installing..." -ForegroundColor Yellow
        try {
            Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
            Write-Host "ps2exe installed successfully!" -ForegroundColor Green
        } catch {
            Write-Host "ERROR: Failed to install ps2exe module!" -ForegroundColor Red
            Write-Host "Please install manually: Install-Module -Name ps2exe" -ForegroundColor Yellow
            exit 1
        }
    }
    
    Import-Module ps2exe
    
    # Convert launcher script to EXE
    $launcherScript = ".\launcher\launcher.ps1"
    $launcherExe = ".\launcher\CertAutoTrust.exe"
    
    try {
        Invoke-ps2exe -inputFile $launcherScript -outputFile $launcherExe `
            -title "Certificate Auto-Trust Tool" `
            -description "Automatically generate and trust SSL certificates on Windows" `
            -company "Your Organization" `
            -version "1.0.0.0" `
            -copyright "Copyright 2026" `
            -requireAdmin `
            -noConsole:$false `
            -noOutput `
            -noError
        
        Write-Host "Launcher EXE created: $launcherExe" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to create launcher EXE!" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Skipping ps2exe conversion (use -SkipPs2Exe:$false to enable)" -ForegroundColor Yellow
}

# Step 2: Create installer using Inno Setup
if (-not $SkipInnoSetup) {
    Write-Host ""
    Write-Host "Step 2: Creating installer with Inno Setup..." -ForegroundColor Yellow
    
    # Find Inno Setup compiler
    $innoSetupPaths = @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles(x86)}\Inno Setup 5\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 5\ISCC.exe"
    )
    
    $iscc = $null
    foreach ($path in $innoSetupPaths) {
        if (Test-Path $path) {
            $iscc = $path
            break
        }
    }
    
    if (-not $iscc) {
        Write-Host "ERROR: Inno Setup not found!" -ForegroundColor Red
        Write-Host "Please download and install Inno Setup from: https://jrsoftware.org/isdl.php" -ForegroundColor Yellow
        Write-Host "Or use -SkipInnoSetup to skip this step" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "Found Inno Setup: $iscc" -ForegroundColor Cyan
    
    # Create placeholder files if they don't exist
    if (-not (Test-Path "LICENSE.txt")) {
        "MIT License - Add your license here" | Out-File "LICENSE.txt" -Encoding UTF8
    }
    
    if (-not (Test-Path "INSTALL_INFO.txt")) {
        @"
Certificate Auto-Trust Tool
============================

This tool will install the Certificate Auto-Trust application on your system.

Features:
- Generate self-signed SSL certificates for any domain
- Automatically trust certificates in Windows certificate store
- Simple interactive interface
- Command-line support for automation

Requirements:
- Windows 10 or later
- Administrator privileges

After installation, you can run the tool from the Start Menu or Desktop shortcut.
"@ | Out-File "INSTALL_INFO.txt" -Encoding UTF8
    }
    
    # Create a simple icon if it doesn't exist
    if (-not (Test-Path "installer\icon.ico")) {
        Write-Host "Note: No icon.ico found. Using default icon." -ForegroundColor Yellow
        # Create a minimal ICO file placeholder
        # In production, you should provide a proper .ico file
    }
    
    # Compile the installer
    $setupScript = ".\installer\setup.iss"
    
    try {
        & $iscc $setupScript
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Installer created successfully!" -ForegroundColor Green
            $installerPath = Get-ChildItem ".\dist\CertAutoTrust-Setup-*.exe" | Select-Object -First 1
            if ($installerPath) {
                Write-Host "Installer location: $($installerPath.FullName)" -ForegroundColor Cyan
            }
        } else {
            Write-Host "ERROR: Inno Setup compilation failed!" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "ERROR: Failed to create installer!" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Skipping Inno Setup compilation (use -SkipInnoSetup:$false to enable)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Test the installer in dist/ folder" -ForegroundColor White
Write-Host "2. Distribute the installer to users" -ForegroundColor White
Write-Host ""

