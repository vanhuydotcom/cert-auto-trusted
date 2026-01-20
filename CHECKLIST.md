# Build Checklist

Use this checklist to ensure you have everything ready to build the installer.

## Pre-Build Checklist

### ✅ Certificate Files

- [ ] I have my `cert.pem` file
- [ ] I have my `key.pem` file (optional but recommended)
- [ ] Both files are in PEM format (text files starting with `-----BEGIN`)
- [ ] I've copied `cert.pem` to the `certs` directory
- [ ] I've copied `key.pem` to the `certs` directory

### ✅ Windows Environment

- [ ] I'm on a Windows 10 or later machine
- [ ] I have Administrator access
- [ ] PowerShell is available (check: `powershell -version`)

### ✅ Prerequisites Installed

- [ ] ps2exe module is installed
  ```powershell
  # Check with:
  Get-Module -ListAvailable -Name ps2exe
  
  # Install if needed:
  Install-Module -Name ps2exe -Scope CurrentUser -Force
  ```

- [ ] Inno Setup is installed
  - [ ] Downloaded from https://jrsoftware.org/isdl.php
  - [ ] Installed to default location
  - [ ] Can find ISCC.exe at: `C:\Program Files (x86)\Inno Setup 6\ISCC.exe`

## Build Checklist

- [ ] Opened PowerShell as Administrator
- [ ] Navigated to project directory: `cd "cert auto trusted"`
- [ ] Verified cert.pem exists: `Test-Path certs\cert.pem` (should return True)
- [ ] Verified key.pem exists: `Test-Path certs\key.pem` (should return True)
- [ ] Run build script: `.\build.ps1`
- [ ] Build completed without errors
- [ ] Installer created at: `dist/CertAutoTrust-Setup-1.0.0.exe`

## Post-Build Checklist

### ✅ Testing

- [ ] Installer file exists and is not 0 bytes
- [ ] Right-clicked installer and selected "Run as Administrator"
- [ ] Installation completed successfully
- [ ] Certificate was installed when prompted
- [ ] Verified certificate in Windows Certificate Manager:
  ```
  Win + R → certmgr.msc → Trusted Root Certification Authorities → Certificates
  ```
- [ ] Tested HTTPS website in Chrome/Edge
- [ ] No SSL warnings appear

### ✅ Distribution

- [ ] Installer file is ready for distribution
- [ ] Created documentation for end users
- [ ] Tested on a clean Windows VM (recommended)
- [ ] Verified installer works on target Windows version

## Quick Test Checklist (Without Building Installer)

If you just want to test the certificate installation without building the full installer:

- [ ] Placed `cert.pem` in `certs` directory
- [ ] Placed `key.pem` in `certs` directory
- [ ] Right-clicked `install-cert.bat`
- [ ] Selected "Run as Administrator"
- [ ] Certificate installed successfully
- [ ] Verified in certmgr.msc
- [ ] Tested with HTTPS website

## Troubleshooting Checklist

If build fails, check:

- [ ] cert.pem is in the correct location (certs directory)
- [ ] cert.pem is a valid PEM certificate file
- [ ] Running PowerShell as Administrator
- [ ] ps2exe module is properly installed
- [ ] Inno Setup is installed in default location
- [ ] No antivirus blocking the build process
- [ ] Enough disk space in dist/ folder

## Security Checklist

Before distributing:

- [ ] Verified certificate is for the correct domain
- [ ] Confirmed certificate validity dates are correct
- [ ] Understood that private key is bundled in installer
- [ ] Only distributing to trusted users/systems
- [ ] Using secure distribution method (not public internet)
- [ ] Documented how users can remove the certificate if needed

## Customization Checklist (Optional)

If you want to customize the installer:

- [ ] Updated application name in `installer/setup.iss`
- [ ] Updated version number in `installer/setup.iss`
- [ ] Updated publisher name in `installer/setup.iss`
- [ ] Added custom icon at `installer/icon.ico` (optional)
- [ ] Updated README.md with your specific instructions
- [ ] Rebuilt installer after changes

## Final Checklist

- [ ] All tests passed
- [ ] Documentation is complete
- [ ] Installer is ready for distribution
- [ ] Users have instructions on how to install
- [ ] Support plan in place for user questions

---

## Quick Reference Commands

```powershell
# Install ps2exe
Install-Module -Name ps2exe -Scope CurrentUser -Force

# Check if cert files exist
Test-Path certs\cert.pem
Test-Path certs\key.pem

# Build the installer
.\build.ps1

# Quick test without building
.\install-cert.bat

# Open Certificate Manager
certmgr.msc
```

---

**Ready to build?** Start with the Pre-Build Checklist and work your way down!

