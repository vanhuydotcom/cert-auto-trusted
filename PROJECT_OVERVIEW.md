# Project Overview: Certificate Auto-Trust Installer

## 🎯 Purpose

This project creates a Windows installer that automatically installs and trusts your SSL certificate (cert.pem and key.pem) in the Windows Trusted Root Certification Authorities store.

**Problem it solves:** Users visiting your HTTPS website get "Your connection is not private" warnings because your certificate isn't trusted.

**Solution:** Distribute a simple installer that automatically trusts your certificate on their Windows machine.

---

## 📁 Complete File Structure

```
cert auto trusted/
│
├── 📄 Documentation (Start Here!)
│   ├── START_HERE.md              ⭐ NEW USER? START HERE!
│   ├── QUICK_START.md             Quick start guide
│   ├── SUMMARY.md                 Project summary
│   ├── BUILD_INSTRUCTIONS.md      Detailed build guide
│   ├── CHECKLIST.md               Build checklist
│   ├── README.md                  Complete documentation
│   └── PROJECT_OVERVIEW.md        This file
│
├── 🔐 Your Certificate Files (YOU PROVIDE THESE)
│   └── certs/
│       ├── cert.pem               Your SSL certificate
│       └── key.pem                Your private key
│
├── 🛠️ Build Scripts
│   ├── build.ps1                  Main build script
│   └── install-cert.bat           Quick test script
│
├── 💻 Source Code
│   ├── src/
│   │   ├── Main.ps1               Main application logic
│   │   └── TrustCertificate.ps1   Windows cert store integration
│   │
│   ├── launcher/
│   │   ├── launcher.ps1           Entry point script
│   │   └── CertAutoTrust.exe      Built launcher (generated)
│   │
│   └── installer/
│       └── setup.iss              Inno Setup configuration
│
├── 📦 Build Output (Generated)
│   └── dist/
│       └── CertAutoTrust-Setup-1.0.0.exe  ← Final installer
│
└── 📋 Supporting Files
    ├── LICENSE.txt                MIT License
    ├── INSTALL_INFO.txt           Installer info screen
    └── .gitignore                 Git ignore rules
```

---

## 🔄 Complete Workflow

### Phase 1: Preparation (You)
1. You have cert.pem and key.pem
2. Place them in project root
3. Install prerequisites (ps2exe, Inno Setup)

### Phase 2: Build (You)
1. Run `build.ps1` on Windows
2. ps2exe converts launcher.ps1 → CertAutoTrust.exe
3. Inno Setup bundles everything → CertAutoTrust-Setup-1.0.0.exe
4. Installer is created in `dist/` folder

### Phase 3: Distribution (You)
1. Copy installer to target machines
2. Share with users who need trusted certificate

### Phase 4: Installation (End Users)
1. User runs installer as Administrator
2. Follows installation wizard
3. Clicks "Yes" to install certificate
4. Certificate is added to Windows Trusted Root CA

### Phase 5: Verification (End Users)
1. User opens Chrome/Edge
2. Visits your HTTPS website
3. No SSL warnings - certificate is trusted!

---

## 🎓 Key Technologies

| Technology | Purpose | Required? |
|------------|---------|-----------|
| **PowerShell** | Scripting language for Windows automation | ✅ Yes (built into Windows) |
| **ps2exe** | Converts PowerShell scripts to .exe files | ✅ Yes (install via PowerShell) |
| **Inno Setup** | Creates professional Windows installers | ✅ Yes (download from website) |
| **Windows Certificate Store API** | Manages trusted certificates | ✅ Yes (built into Windows) |

---

## 📊 File Purposes

### Documentation Files
- **START_HERE.md** - Best starting point for new users
- **QUICK_START.md** - Fast guide for builders and installers
- **SUMMARY.md** - High-level project overview
- **BUILD_INSTRUCTIONS.md** - Step-by-step build guide
- **CHECKLIST.md** - Checkbox-style build checklist
- **README.md** - Complete reference documentation
- **PROJECT_OVERVIEW.md** - This file - comprehensive overview

### Certificate Files (You Provide)
- **certs/cert.pem** - Your SSL certificate (required)
- **certs/key.pem** - Your private key (optional but recommended)

### Build Scripts
- **build.ps1** - Main build script (builds the installer)
- **install-cert.bat** - Quick test without building full installer

### Source Code
- **src/Main.ps1** - Loads cert.pem and trusts it
- **src/TrustCertificate.ps1** - Windows cert store integration
- **launcher/launcher.ps1** - Entry point (converted to .exe)
- **installer/setup.iss** - Inno Setup configuration

### Supporting Files
- **LICENSE.txt** - MIT License
- **INSTALL_INFO.txt** - Shown during installation
- **.gitignore** - Git ignore rules

---

## 🚀 Quick Commands Reference

```powershell
# Install prerequisites
Install-Module -Name ps2exe -Scope CurrentUser -Force

# Build the installer
.\build.ps1

# Quick test (without building installer)
.\install-cert.bat

# Open Certificate Manager (to verify)
certmgr.msc
```

---

## ✅ Success Criteria

You know it's working when:
- ✅ Build completes without errors
- ✅ Installer file exists in `dist/` folder
- ✅ Installer runs and completes successfully
- ✅ Certificate appears in Windows Certificate Manager
- ✅ HTTPS website shows no SSL warnings in Chrome/Edge

---

## 🔒 Security Considerations

⚠️ **Important:**
- The installer bundles your **private key** (key.pem)
- Only distribute to **trusted users/systems**
- Use **secure distribution channels**
- Certificate will be trusted **system-wide**
- Users can remove via Windows Certificate Manager

---

## 🎨 Customization Options

Edit `installer/setup.iss` to customize:
- Application name
- Version number
- Publisher/company name
- Installation directory
- Desktop/Start Menu shortcuts
- Custom icon

---

## 📞 Support & Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| "cert.pem not found" | Place cert.pem in certs directory |
| "ps2exe not found" | `Install-Module -Name ps2exe` |
| "Inno Setup not found" | Install from jrsoftware.org |
| "Not Administrator" | Right-click → "Run as Administrator" |
| Certificate not trusted | Restart browser, check certmgr.msc |

---

## 📈 Next Steps

1. **New to this project?** → Read [START_HERE.md](START_HERE.md)
2. **Ready to build?** → Follow [QUICK_START.md](QUICK_START.md)
3. **Need detailed steps?** → See [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
4. **Want a checklist?** → Use [CHECKLIST.md](CHECKLIST.md)
5. **Need complete docs?** → Read [README.md](README.md)

---

**Questions?** Check the documentation files above or review the troubleshooting section.

**Ready to build?** Start with [START_HERE.md](START_HERE.md)! 🚀

