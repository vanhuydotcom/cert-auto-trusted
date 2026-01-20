# Quick Start Guide

## For Users (Installing the Certificate)

1. **Download** the installer: `CertAutoTrust-Setup-1.0.0.exe`

2. **Right-click** the installer and select **"Run as Administrator"**

3. **Follow** the installation wizard

4. When prompted **"Do you want to install and trust the certificate now?"**, click **Yes**

5. **Done!** Your certificate is now trusted by Windows

### Verify Installation

1. Open Chrome or Edge browser
2. Visit your HTTPS website
3. You should see a secure padlock (no warnings)

---

## For Developers (Building the Installer)

### Step 1: Prepare Your Certificates

Place your certificate files in the `certs` directory:

```
cert auto trusted/
├── certs/
│   ├── cert.pem    <-- Place your certificate here
│   └── key.pem     <-- Place your private key here
```

### Step 2: Install Prerequisites (Windows only)

Open PowerShell as Administrator:

```powershell
# Install ps2exe
Install-Module -Name ps2exe -Scope CurrentUser -Force

# Download and install Inno Setup
# https://jrsoftware.org/isdl.php
```

### Step 3: Build the Installer

```powershell
# Navigate to project directory
cd "cert auto trusted"

# Run build script
.\build.ps1
```

### Step 4: Get Your Installer

The installer will be created at:
```
dist/CertAutoTrust-Setup-1.0.0.exe
```

Distribute this file to users who need to trust your certificate.

---

## Troubleshooting

### "This app can't run on your PC"
- Make sure you're running on Windows 10 or later
- Right-click and select "Run as Administrator"

### "Windows protected your PC"
- Click "More info"
- Click "Run anyway"
- This is normal for unsigned executables

### Certificate not trusted after installation
- Restart your browser
- Check if you ran the installer as Administrator
- Firefox uses its own certificate store (not Windows)

### Build fails with "cert.pem not found"
- Make sure cert.pem is in the certs directory (certs/cert.pem)
- Check the file name is exactly "cert.pem" (lowercase)

---

## What Gets Installed

- **Installation Directory**: `C:\Program Files\Certificate Auto-Trust Tool\`
- **Files Installed**:
  - `CertAutoTrust.exe` - Main application
  - `Main.ps1` - PowerShell script
  - `TrustCertificate.ps1` - Trust automation script
  - `cert.pem` - Your certificate
  - `key.pem` - Your private key
  - `README.md` - Documentation

- **Certificate Store**: Trusted Root Certification Authorities (Local Machine)

---

## Uninstalling

1. Open **Settings** > **Apps** > **Apps & features**
2. Find **"Certificate Auto-Trust Tool"**
3. Click **Uninstall**

**Note**: This removes the application but does NOT remove the certificate from Windows certificate store.

To remove the certificate:
1. Press `Win + R`, type `certmgr.msc`, press Enter
2. Navigate to **Trusted Root Certification Authorities** > **Certificates**
3. Find your certificate and delete it

