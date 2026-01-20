# Build Instructions

## Overview

This project creates a Windows installer (.exe) that automatically trusts your existing SSL certificate (cert.pem and key.pem) in the Windows certificate store.

## Prerequisites

### 1. Your Certificate Files

You need to have:
- `cert.pem` - Your SSL certificate file
- `key.pem` - Your private key file (optional but recommended)

### 2. Windows Environment

This must be built on a Windows machine (Windows 10 or later).

### 3. Required Software

#### A. PowerShell Module: ps2exe

Install via PowerShell (run as Administrator):

```powershell
Install-Module -Name ps2exe -Scope CurrentUser -Force
```

#### B. Inno Setup

Download and install from: https://jrsoftware.org/isdl.php

Choose the latest version (6.x recommended) and install to the default location.

## Build Process

### Step 1: Prepare Certificate Files

1. Copy your `cert.pem` to the `certs` directory
2. Copy your `key.pem` to the `certs` directory

Your directory should look like:

```
cert auto trusted/
├── certs/
│   ├── cert.pem      <-- Your certificate
│   └── key.pem       <-- Your private key
├── build.ps1
├── src/
├── launcher/
└── installer/
```

### Step 2: Run the Build Script

1. Open PowerShell as Administrator
2. Navigate to the project directory:
   ```powershell
   cd "C:\path\to\cert auto trusted"
   ```
3. Run the build script:
   ```powershell
   .\build.ps1
   ```

### Step 3: Collect the Installer

The installer will be created at:

```
dist/CertAutoTrust-Setup-1.0.0.exe
```

This is your distributable installer file.

## What the Build Script Does

1. **Validates** that cert.pem and key.pem exist
2. **Converts** launcher.ps1 to CertAutoTrust.exe using ps2exe
3. **Compiles** the Inno Setup script to create the installer
4. **Bundles** all files (scripts, certificate, exe) into one installer

## Build Options

### Skip ps2exe Conversion

If you've already built the launcher.exe and just want to rebuild the installer:

```powershell
.\build.ps1 -SkipPs2Exe
```

### Skip Inno Setup

If you just want to build the launcher.exe:

```powershell
.\build.ps1 -SkipInnoSetup
```

## Testing Without Building

For quick testing, you can use the batch script:

1. Place `cert.pem` and `key.pem` in the `certs` directory
2. Right-click `install-cert.bat` and select "Run as Administrator"
3. The certificate will be installed directly without creating an installer

## Troubleshooting

### "ps2exe module not found"

```powershell
# Reinstall the module
Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
```

### "Inno Setup not found"

- Make sure Inno Setup is installed
- Check installation path: `C:\Program Files (x86)\Inno Setup 6\ISCC.exe`
- If installed elsewhere, update the path in build.ps1

### "cert.pem not found"

- Ensure cert.pem is in the certs directory (certs/cert.pem)
- Check the filename is exactly "cert.pem" (lowercase)
- Verify it's a valid PEM format certificate

### Build succeeds but installer doesn't work

- Make sure you ran build.ps1 as Administrator
- Check that cert.pem is a valid certificate file
- Try running install-cert.bat first to test the certificate

## Distribution

Once built, you can distribute `CertAutoTrust-Setup-1.0.0.exe` to users.

Users should:
1. Right-click the installer
2. Select "Run as Administrator"
3. Follow the installation wizard
4. Click "Yes" when prompted to install the certificate

## Security Considerations

⚠️ **Important:**

- The installer bundles your private key (key.pem)
- Only distribute to trusted users/systems
- Consider if you really need to bundle the private key
- Users will trust this certificate system-wide
- Ensure secure distribution channels

## Customization

### Change Application Name

Edit `installer/setup.iss`:
```ini
#define MyAppName "Your App Name"
```

### Change Version

Edit `installer/setup.iss`:
```ini
#define MyAppVersion "1.0.0"
```

### Add Custom Icon

1. Create or obtain an .ico file
2. Save as `installer/icon.ico`
3. Rebuild

## Next Steps After Building

1. Test the installer on a clean Windows VM
2. Verify the certificate is trusted after installation
3. Test with your HTTPS application
4. Document any specific requirements for your users
5. Create a distribution package with instructions

