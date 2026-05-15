# 🚀 START HERE

Welcome to the Certificate Auto-Trust Tool! This guide will get you started quickly.

## 📖 Documentation Guide

Choose the guide that matches your needs:

### 🎯 **I want to build the installer** → Read this file (you're in the right place!)

### ⚡ **I want a quick overview** → [SUMMARY.md](SUMMARY.md)

### 📝 **I want detailed build instructions** → [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

### ✅ **I want a step-by-step checklist** → [CHECKLIST.md](CHECKLIST.md)

### 🏃 **I want to get started fast** → [QUICK_START.md](QUICK_START.md)

### 📚 **I want complete documentation** → [README.md](README.md)

---

## 🎯 Quick Build Guide (3 Steps)

### Step 1: Prepare Your Root CA

1. **Get your Root CA public certificate:**
   - `rootCA.pem` - Your self-signed Root CA (PUBLIC certificate only)

   If you use mkcert, get it from `mkcert -CAROOT`.
   ⚠️ NEVER include `rootCA-key.pem` or any other private key.

2. **Copy it to the `certs` directory**

   Your directory should look like:

   ```
   cert auto trusted/
   ├── certs/
   │   └── rootCA.pem    ← Your Root CA here (public cert only)
   ├── START_HERE.md     ← This file
   ├── build.ps1
   └── ...
   ```

### Step 2: Install Prerequisites (Windows Only)

Open PowerShell **as Administrator** and run:

```powershell
# Install ps2exe module
Install-Module -Name ps2exe -Scope CurrentUser -Force
```

Then download and install **Inno Setup**:

- Go to: https://jrsoftware.org/isdl.php
- Download the latest version (6.x recommended)
- Install with default settings

### Step 3: Build!

Open PowerShell **as Administrator** in this directory and run:

```powershell
.\build.ps1
```

**That's it!** Your installer will be created at:

```
dist/CertAutoTrust-Setup-1.0.0.exe
```

---

## 🧪 Quick Test (Without Building Full Installer)

Want to test if your Root CA installs correctly before building the full installer?

1. Place `rootCA.pem` in the `certs` directory
2. Right-click `install-cert.bat`
3. Select "Run as Administrator"
4. Your Root CA will be installed directly

---

## ❓ Common Questions

### Q: I'm not on Windows, can I still build this?

**A:** No, this must be built on Windows. You can use a Windows VM or a Windows machine.

### Q: What goes in `certs/`?

**A:** ONLY `rootCA.pem` (the PUBLIC Root CA certificate). The matching private key
(`rootCA-key.pem`) must NEVER be placed here or committed to git.

### Q: What if I don't have Inno Setup?

**A:** Download it from https://jrsoftware.org/isdl.php - it's free and required for building the installer.

### Q: Can I customize the installer?

**A:** Yes! Edit `installer/setup.iss` to change the app name, version, publisher, etc.

### Q: Is this safe?

**A:** The installer ships only the public Root CA. No private keys are bundled. End users
should still only install Root CAs from sources they trust, since a Root CA can issue
certificates trusted for any domain on their machine.

---

## 🎓 What Happens When You Build?

1. **build.ps1** checks for `certs/rootCA.pem`
2. **ps2exe** converts the PowerShell launcher to an .exe file
3. **Inno Setup** bundles the Root CA + launcher into a Windows installer
4. **Output:** A professional installer that users can run to trust the Root CA

---

## 📦 What Gets Created?

After building, you'll have:

```
dist/
└── CertAutoTrust-Setup-1.0.0.exe    ← Distribute this to users
```

Users just need to:

1. Right-click the installer
2. Select "Run as Administrator"
3. Follow the wizard
4. Click "Yes" to install the certificate
5. Done! Certificate is trusted

---

## 🆘 Need Help?

### Build fails with "rootCA.pem not found"

→ Make sure rootCA.pem is in the certs directory (certs/rootCA.pem)

### Build fails with "ps2exe not found"

→ Run: `Install-Module -Name ps2exe -Scope CurrentUser -Force`

### Build fails with "Inno Setup not found"

→ Install Inno Setup from https://jrsoftware.org/isdl.php

### Certificate not trusted after installation

→ Make sure you ran the installer as Administrator
→ Restart your browser
→ Check Windows Certificate Manager (certmgr.msc)

---

## 🎯 Next Steps

1. ✅ Follow Step 1-3 above to build your installer
2. ✅ Test the installer on your machine
3. ✅ Distribute to users who need the certificate trusted
4. ✅ Provide users with installation instructions

---

## 📚 More Information

- **Complete documentation:** [README.md](README.md)
- **Build checklist:** [CHECKLIST.md](CHECKLIST.md)
- **Detailed build guide:** [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
- **Quick start:** [QUICK_START.md](QUICK_START.md)
- **Project summary:** [SUMMARY.md](SUMMARY.md)

---

**Ready to build?** Follow the 3 steps above and you'll have your installer in minutes! 🚀
