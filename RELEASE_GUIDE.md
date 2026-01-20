# Release Guide

## 🚀 How to Create a New Release

This project uses **GitHub Actions** to automatically build and publish releases. No need to build manually on Windows!

---

## Quick Release Process

### 1️⃣ Prepare Your Changes

Make sure all your changes are committed and pushed:

```bash
# Check status
git status

# Add and commit changes
git add .
git commit -m "Your changes description"

# Push to main
git push origin main
```

### 2️⃣ Update Version (Optional)

If you want to change the installer version, update `installer/setup.iss`:

```ini
#define MyAppVersion "1.0.1"  ← Change this
```

Then commit:
```bash
git add installer/setup.iss
git commit -m "Bump version to 1.0.1"
git push origin main
```

### 3️⃣ Create and Push a Tag

```bash
# Create an annotated tag
git tag -a v1.0.1 -m "Release v1.0.1 - Description of changes"

# Push the tag to GitHub
git push origin v1.0.1
```

**Tag naming convention:** `v{major}.{minor}.{patch}`
- Example: `v1.0.0`, `v1.0.1`, `v2.0.0`

### 4️⃣ Wait for GitHub Actions

1. Go to: https://github.com/vanhuydotcom/cert-auto-trusted/actions
2. You'll see "Build and Release" workflow running
3. Wait ~5-10 minutes for completion

### 5️⃣ Release is Ready!

Once the workflow completes:

1. Visit: https://github.com/vanhuydotcom/cert-auto-trusted/releases
2. Your new release will be there with:
   - Release notes (auto-generated)
   - Installer file: `CertAutoTrust-Setup-{version}.exe`
3. Share the download link with users!

---

## 📋 What GitHub Actions Does Automatically

When you push a tag, the workflow:

1. ✅ Checks out your code
2. ✅ Verifies certificate files exist
3. ✅ Installs ps2exe module
4. ✅ Installs Inno Setup
5. ✅ Runs `build.ps1` to create installer
6. ✅ Creates a GitHub Release
7. ✅ Uploads the installer as a release asset
8. ✅ Generates release notes

**No manual building required!** 🎉

---

## 🔄 Release Workflow Diagram

```
You push tag (v1.0.1)
         ↓
GitHub Actions triggered
         ↓
Windows runner starts
         ↓
Install dependencies (ps2exe, Inno Setup)
         ↓
Build installer (build.ps1)
         ↓
Create GitHub Release
         ↓
Upload installer file
         ↓
✅ Release published!
```

---

## 📝 Example Release Process

### Scenario: Bug fix release

```bash
# 1. Fix the bug and commit
git add src/Main.ps1
git commit -m "Fix certificate validation bug"
git push origin main

# 2. Create release tag
git tag -a v1.0.2 -m "Release v1.0.2 - Fix certificate validation bug"
git push origin v1.0.2

# 3. Wait for GitHub Actions (check Actions tab)

# 4. Done! Release is at:
# https://github.com/vanhuydotcom/cert-auto-trusted/releases/tag/v1.0.2
```

### Scenario: Feature release

```bash
# 1. Develop feature and commit
git add .
git commit -m "Add support for multiple certificates"
git push origin main

# 2. Update version in installer/setup.iss to "1.1.0"
git add installer/setup.iss
git commit -m "Bump version to 1.1.0"
git push origin main

# 3. Create release tag
git tag -a v1.1.0 -m "Release v1.1.0 - Add support for multiple certificates"
git push origin v1.1.0

# 4. GitHub Actions builds and publishes automatically
```

---

## 🛠️ Troubleshooting

### Workflow fails with "cert.pem not found"

**Problem:** Certificate files are not in the repository.

**Solution:**
```bash
# Make sure cert.pem and key.pem are committed
git add certs/cert.pem certs/key.pem
git commit -m "Add certificate files"
git push origin main

# Then retry the release
git push origin v1.0.1 --force
```

### Tag already exists

**Problem:** You're trying to create a tag that already exists.

**Solution:**
```bash
# Delete the tag locally
git tag -d v1.0.1

# Delete the tag remotely
git push origin :refs/tags/v1.0.1

# Create the tag again
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

### Release created but no installer uploaded

**Problem:** Build succeeded but upload failed.

**Solution:**
- Check the Actions log for errors
- Verify the installer was created in the build step
- Re-run the workflow from GitHub Actions UI

### Want to test without creating a release?

**Solution:** Use the Build Test workflow:
1. Go to: https://github.com/vanhuydotcom/cert-auto-trusted/actions
2. Click "Build Test"
3. Click "Run workflow"
4. Select branch and run
5. Download the test artifact (available for 7 days)

---

## 📊 Monitoring Releases

### View all releases
https://github.com/vanhuydotcom/cert-auto-trusted/releases

### View workflow runs
https://github.com/vanhuydotcom/cert-auto-trusted/actions

### Check workflow status
Add badges to your README (already added):
```markdown
![Build and Release](https://github.com/vanhuydotcom/cert-auto-trusted/workflows/Build%20and%20Release/badge.svg)
```

---

## 🔒 Security Considerations

### Certificate Files in Repository

⚠️ The workflow expects `certs/cert.pem` and `certs/key.pem` to be in the repository.

**Options:**

1. **Public repository with non-sensitive certs:** Commit them directly
2. **Private repository:** Commit them (only collaborators can access)
3. **Use GitHub Secrets:** Store certs as secrets and create files in workflow

### Using GitHub Secrets (Advanced)

If you don't want to commit certificates:

1. Add secrets in GitHub:
   - Go to Settings → Secrets and variables → Actions
   - Add `CERT_PEM` with certificate content
   - Add `KEY_PEM` with key content

2. Modify `.github/workflows/release.yml`:
   ```yaml
   - name: Create certificate files
     shell: pwsh
     run: |
       New-Item -ItemType Directory -Force -Path "certs"
       "${{ secrets.CERT_PEM }}" | Out-File -FilePath "certs\cert.pem"
       "${{ secrets.KEY_PEM }}" | Out-File -FilePath "certs\key.pem"
   ```

---

## 📚 Additional Resources

- [GitHub Actions Documentation](.github/README.md)
- [Build Instructions](BUILD_INSTRUCTIONS.md)
- [Project Overview](PROJECT_OVERVIEW.md)

---

**Questions?** Open an issue or check the documentation!

