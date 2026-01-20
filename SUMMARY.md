# Project Summary: Certificate Auto-Trust Installer

## What This Project Does

Creates a Windows installer (.exe) that automatically installs and trusts your existing SSL certificate (cert.pem and key.pem) in the Windows Trusted Root Certification Authorities store.

## Quick Start

### For Building the Installer:

1. **Place your certificate files** in the `certs` directory:
   - `certs/cert.pem` (required)
   - `certs/key.pem` (optional)

2. **On a Windows machine**, install prerequisites:
   ```powershell
   Install-Module -Name ps2exe -Scope CurrentUser -Force
   ```
   Download Inno Setup: https://jrsoftware.org/isdl.php

3. **Build the installer**:
   ```powershell
   .\build.ps1
   ```

4. **Get your installer** from:
   ```
   dist/CertAutoTrust-Setup-1.0.0.exe
   ```

### For Using the Installer:

1. Right-click `CertAutoTrust-Setup-1.0.0.exe`
2. Select "Run as Administrator"
3. Follow the wizard
4. Click "Yes" when prompted to install certificate
5. Done! Certificate is now trusted

## Project Structure

```
cert auto trusted/
├── certs/
│   ├── cert.pem                # YOUR CERTIFICATE (place here)
│   └── key.pem                 # YOUR PRIVATE KEY (place here)
│
├── src/
│   ├── Main.ps1                # Main application logic
│   └── TrustCertificate.ps1    # Windows cert store integration
│
├── launcher/
│   ├── launcher.ps1            # Entry point script
│   └── CertAutoTrust.exe       # Built launcher (generated)
│
├── installer/
│   └── setup.iss               # Inno Setup configuration
│
├── dist/                       # Build output directory (generated)
│   └── CertAutoTrust-Setup-1.0.0.exe  # Final installer
│
├── build.ps1                   # Main build script
├── install-cert.bat            # Quick test script
│
└── Documentation:
    ├── README.md               # Full documentation
    ├── QUICK_START.md          # Quick start guide
    ├── BUILD_INSTRUCTIONS.md   # Detailed build guide
    └── SUMMARY.md              # This file
```

## Key Files

| File | Purpose |
|------|---------|
| `certs/cert.pem` | Your SSL certificate (YOU PROVIDE) |
| `certs/key.pem` | Your private key (YOU PROVIDE) |
| `build.ps1` | Builds the installer |
| `install-cert.bat` | Quick test without building installer |
| `src/Main.ps1` | Loads and trusts the certificate |
| `src/TrustCertificate.ps1` | Windows certificate store API |
| `launcher/launcher.ps1` | Entry point (converted to .exe) |
| `installer/setup.iss` | Inno Setup installer configuration |

## How It Works

1. **Build Time**:
   - `build.ps1` converts `launcher.ps1` → `CertAutoTrust.exe` (using ps2exe)
   - Inno Setup bundles everything into `CertAutoTrust-Setup.exe`
   - Your cert.pem and key.pem are included in the installer

2. **Install Time**:
   - User runs the installer as Administrator
   - Files are copied to `C:\Program Files\Certificate Auto-Trust Tool\`
   - Installer prompts to trust the certificate
   - If yes, certificate is added to Windows Trusted Root CA store

3. **Runtime**:
   - Certificate is now trusted by Windows
   - Chrome, Edge, and other browsers trust it automatically
   - No more SSL warnings for your domain

## Requirements

### For Building:
- Windows 10 or later
- PowerShell 5.1+
- ps2exe module
- Inno Setup 5 or 6
- Your cert.pem and key.pem files

### For Installing:
- Windows 10 or later
- Administrator privileges

## Testing

### Quick Test (without building installer):

1. Place `cert.pem` in project root
2. Right-click `install-cert.bat` → "Run as Administrator"
3. Certificate will be installed directly

### Full Test (with installer):

1. Build the installer with `.\build.ps1`
2. Run `dist/CertAutoTrust-Setup-1.0.0.exe` as Administrator
3. Verify certificate in Windows Certificate Manager (certmgr.msc)
4. Test with your HTTPS website in Chrome/Edge

## Security Notes

⚠️ **Important:**
- The installer bundles your **private key** (key.pem)
- Only distribute to trusted users/systems
- Certificate will be trusted **system-wide**
- Users can remove it via Windows Certificate Manager

## Customization

Edit `installer/setup.iss` to change:
- Application name: `#define MyAppName "Your Name"`
- Version: `#define MyAppVersion "1.0.0"`
- Publisher: `#define MyAppPublisher "Your Company"`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "cert.pem not found" | Place cert.pem in certs directory |
| "ps2exe not found" | Run `Install-Module -Name ps2exe` |
| "Inno Setup not found" | Install from jrsoftware.org |
| "Not running as Administrator" | Right-click → "Run as Administrator" |
| Certificate not trusted | Restart browser, check certmgr.msc |

## Next Steps

1. ✅ Place your cert.pem and key.pem in certs directory
2. ✅ Install prerequisites (ps2exe, Inno Setup)
3. ✅ Run `.\build.ps1` on Windows
4. ✅ Test the installer
5. ✅ Distribute to users

## Support

See detailed documentation:
- **README.md** - Complete documentation
- **QUICK_START.md** - Quick start guide
- **BUILD_INSTRUCTIONS.md** - Detailed build instructions

