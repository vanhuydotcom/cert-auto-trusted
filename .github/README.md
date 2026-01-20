# GitHub Actions Workflows

This directory contains automated CI/CD workflows for the Certificate Auto-Trust Installer project.

## 📋 Workflows

### 1. Build and Release (`release.yml`)

**Trigger:** When you push a version tag (e.g., `v1.0.0`, `v2.1.3`)

**What it does:**
- ✅ Checks for certificate files in `certs/` directory
- ✅ Installs ps2exe and Inno Setup on Windows runner
- ✅ Builds the installer using `build.ps1`
- ✅ Creates a GitHub Release automatically
- ✅ Uploads the installer as a release asset
- ✅ Generates release notes

**Usage:**
```bash
# Create and push a tag
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1

# GitHub Actions will automatically:
# 1. Build the installer
# 2. Create a release
# 3. Upload CertAutoTrust-Setup-1.0.1.exe
```

**Output:**
- GitHub Release at: `https://github.com/vanhuydotcom/cert-auto-trusted/releases`
- Installer file: `CertAutoTrust-Setup-{version}.exe`

---

### 2. Build Test (`build-test.yml`)

**Trigger:** 
- Pull requests to `main` branch
- Pushes to `main` branch
- Manual trigger via GitHub UI

**What it does:**
- ✅ Tests the build process
- ✅ Creates dummy certificates if needed (for testing)
- ✅ Verifies all build steps work correctly
- ✅ Uploads test installer as artifact

**Usage:**
- Automatically runs on every PR and push to main
- Manual trigger: Go to Actions tab → Build Test → Run workflow

**Output:**
- Build artifact available for 7 days
- Build status visible in PR checks

---

## 🚀 How to Use

### Creating a New Release

1. **Update version** in `installer/setup.iss` if needed:
   ```ini
   #define MyAppVersion "1.0.1"
   ```

2. **Commit your changes:**
   ```bash
   git add .
   git commit -m "Prepare release v1.0.1"
   git push origin main
   ```

3. **Create and push a tag:**
   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1 - Bug fixes and improvements"
   git push origin v1.0.1
   ```

4. **Wait for GitHub Actions:**
   - Go to: `https://github.com/vanhuydotcom/cert-auto-trusted/actions`
   - Watch the "Build and Release" workflow run
   - Takes ~5-10 minutes

5. **Release is ready!**
   - Visit: `https://github.com/vanhuydotcom/cert-auto-trusted/releases`
   - Download the installer
   - Share with users

---

## 🔧 Workflow Configuration

### Required Files

Both workflows require:
- ✅ `certs/cert.pem` - Your SSL certificate
- ✅ `certs/key.pem` - Your private key (optional)
- ✅ `build.ps1` - Build script
- ✅ `installer/setup.iss` - Inno Setup configuration

### Secrets

No additional secrets required! The workflows use:
- `GITHUB_TOKEN` - Automatically provided by GitHub Actions

### Runner

- **OS:** `windows-latest` (Windows Server 2022)
- **PowerShell:** Built-in
- **Installed during workflow:**
  - ps2exe module
  - Inno Setup 6

---

## 📊 Workflow Status

You can check workflow status:
- **Actions tab:** `https://github.com/vanhuydotcom/cert-auto-trusted/actions`
- **Badge:** Add to README.md:
  ```markdown
  ![Build and Release](https://github.com/vanhuydotcom/cert-auto-trusted/workflows/Build%20and%20Release/badge.svg)
  ![Build Test](https://github.com/vanhuydotcom/cert-auto-trusted/workflows/Build%20Test/badge.svg)
  ```

---

## 🐛 Troubleshooting

### Build fails with "cert.pem not found"

**For release.yml:**
- Ensure `certs/cert.pem` is committed to the repository
- Check the file is not in `.gitignore`

**For build-test.yml:**
- This workflow creates dummy certificates automatically
- Should not fail due to missing certificates

### Inno Setup installation fails

- The workflow downloads from `jrsoftware.org`
- If the site is down, the build will fail
- Wait and retry, or update the download URL

### Release creation fails

- Check you have permission to create releases
- Ensure the tag doesn't already exist
- Verify `GITHUB_TOKEN` has correct permissions

### Wrong version in installer name

- Update version in `installer/setup.iss`:
  ```ini
  #define MyAppVersion "X.Y.Z"
  ```
- The workflow extracts version from the git tag

---

## 🔒 Security Notes

### Certificate Files

⚠️ **Important:** The workflows expect certificate files to be in the repository.

**Options:**

1. **Commit certificates** (if they're not sensitive):
   ```bash
   git add certs/cert.pem certs/key.pem
   git commit -m "Add certificates"
   ```

2. **Use GitHub Secrets** (for sensitive certificates):
   - Add certificates as secrets
   - Modify workflow to create files from secrets:
   ```yaml
   - name: Create certificate files
     run: |
       echo "${{ secrets.CERT_PEM }}" > certs/cert.pem
       echo "${{ secrets.KEY_PEM }}" > certs/key.pem
   ```

3. **Use encrypted files**:
   - Encrypt with `gpg` or similar
   - Decrypt in workflow using secret passphrase

---

## 📝 Customization

### Change release notes format

Edit `release.yml` → `Create Release` step → `body` section

### Add more build steps

Add steps before the "Build installer" step in either workflow

### Change artifact retention

Edit `build-test.yml` → `retention-days: 7` (change to desired days)

### Add notifications

Add a notification step at the end:
```yaml
- name: Notify on success
  uses: some-notification-action
```

---

## 📚 Learn More

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Creating Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)

---

**Questions?** Check the main [README.md](../README.md) or open an issue.

