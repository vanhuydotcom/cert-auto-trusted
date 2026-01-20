# Recent Changes

## ✅ Updated: Certificate Files Location

**Date:** 2026-01-20

### What Changed

All scripts and documentation have been updated to look for certificate files in the `/certs` directory instead of the project root.

### Changes Made

#### 📁 File Structure
- Certificate files now go in `certs/` directory
- Example files moved to `certs/cert.pem.example` and `certs/key.pem.example`
- Added `certs/README.md` with instructions

#### 🔧 Scripts Updated
- ✅ `build.ps1` - Now checks for `certs/cert.pem` and `certs/key.pem`
- ✅ `src/Main.ps1` - Default paths updated to `certs/cert.pem` and `certs/key.pem`
- ✅ `launcher/launcher.ps1` - Looks for certificates in `certs/` directory
- ✅ `installer/setup.iss` - Bundles files from `certs/` directory
- ✅ `install-cert.bat` - Updated to use `certs/cert.pem`

#### 📚 Documentation Updated
- ✅ `START_HERE.md` - Updated all references to certs directory
- ✅ `QUICK_START.md` - Updated certificate file paths
- ✅ `BUILD_INSTRUCTIONS.md` - Updated preparation steps
- ✅ `CHECKLIST.md` - Updated all checklist items
- ✅ `SUMMARY.md` - Updated file structure and paths
- ✅ `PROJECT_OVERVIEW.md` - Updated file structure diagram
- ✅ `README.md` - Already correct

#### 🔒 Security
- ✅ `.gitignore` - Updated to ignore `certs/cert.pem` and `certs/key.pem`
- ✅ Example files preserved for reference

### Migration Guide

If you had files in the old location (project root), move them:

```powershell
# Windows PowerShell
Move-Item cert.pem certs/cert.pem
Move-Item key.pem certs/key.pem
```

Or manually:
1. Copy `cert.pem` to `certs/cert.pem`
2. Copy `key.pem` to `certs/key.pem`
3. Delete old files from project root (optional)

### New Directory Structure

```
cert auto trusted/
├── certs/                      ← Certificate files go here
│   ├── cert.pem                ← Your certificate
│   ├── key.pem                 ← Your private key
│   ├── cert.pem.example        ← Example/template
│   ├── key.pem.example         ← Example/template
│   └── README.md               ← Instructions
├── src/
├── launcher/
├── installer/
└── ...
```

### Verification

To verify your setup is correct:

```powershell
# Check if files exist in correct location
Test-Path certs\cert.pem    # Should return True
Test-Path certs\key.pem     # Should return True

# Build the installer
.\build.ps1
```

### Benefits

✅ **Better organization** - Certificate files are now in a dedicated directory
✅ **Clearer structure** - Easier to understand where files go
✅ **Git-friendly** - Easier to ignore sensitive files
✅ **Professional** - Follows common project structure patterns

### No Breaking Changes

All functionality remains the same. Only the file locations have changed. The installer works exactly as before.

---

**Status:** ✅ All updates complete and tested
**Impact:** Low - Only file paths changed
**Action Required:** Place your cert.pem and key.pem in the `certs/` directory

