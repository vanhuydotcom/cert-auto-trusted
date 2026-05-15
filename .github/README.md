# GitHub Actions Workflows

This directory contains automated CI/CD workflows for the Certificate Auto-Trust Installer project.

## 📋 Workflows

### 1. Build and Release (`release.yml`)

**Trigger:** When you push a version tag (e.g., `v1.0.0`, `v2.1.3`)

**What it does:**

- ✅ Checks for `certs/rootCA.pem` (and validates it is a self-signed CA)
- ✅ Refuses to build if any private key file is present in the repo
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

- ✅ Tests the build process end-to-end
- ✅ Validates `certs/rootCA.pem` is present and is a self-signed CA
- ✅ Verifies no private key files are accidentally committed
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

- ✅ `certs/rootCA.pem` - PUBLIC Root CA certificate (self-signed, CA:TRUE)
- ✅ `build.ps1` - Build script
- ✅ `installer/setup.iss` - Inno Setup configuration

> Private keys (`*-key.pem`, `*.key`, `key.pem`, `*.pfx`, `*.p12`) MUST NOT be present
> in the repo. The workflows fail the build if any are detected.

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

### Build fails with "rootCA.pem not found"

- Ensure `certs/rootCA.pem` is committed to the repository
- Check the file is not in `.gitignore`
- For mkcert users: copy from `mkcert -CAROOT`

### Build fails with "rootCA.pem is not self-signed" or "BasicConstraints CA:TRUE"

- The file in `certs/rootCA.pem` is a leaf certificate, not a Root CA
- Replace it with the correct Root CA file (e.g. mkcert's `rootCA.pem`)

### Build fails with "Private key files detected in repository"

- A `*-key.pem`, `*.key`, `key.pem`, `*.pfx`, or `*.p12` file is checked into the repo
- Remove the file, then `git rm` it. The `.gitignore` should prevent this in the future.

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

### What's in the repo and the installer

- ✅ `certs/rootCA.pem` (PUBLIC Root CA) - committed and bundled into the `.exe`
- ❌ `rootCA-key.pem` (private CA key) - NEVER committed; lives only on the
  CA-owner machine (e.g. mkcert's `-CAROOT` directory on macOS/Linux)
- ❌ Server leaf cert + key (`server-cert.pem`, `server-key.pem`) - NEVER committed;
  lives only on the HTTPS server (e.g. the RFID gate)

The Root CA public certificate is, by design, public information. It is shipped during
every TLS handshake of every server that uses it. Committing it to the repo is safe.
The matching private key is what must be guarded; if it leaks, the CA must be rotated.

For full setup details see [GITHUB_ACTIONS_SETUP.md](../GITHUB_ACTIONS_SETUP.md).

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
