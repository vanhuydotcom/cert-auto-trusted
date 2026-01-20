# GitHub Actions Setup Guide

## 🔐 Certificate Files for GitHub Actions

GitHub Actions needs access to your `cert.pem` and `key.pem` files to build the installer. You have **3 options**:

---

## ✅ Option 1: Commit Certificate Files (Recommended for Most Cases)

**Best for:**
- Internal/private repositories
- Non-sensitive certificates
- Development/testing certificates
- When you control who has access to the repo

### Steps:

1. **Update `.gitignore`** (already done):
   ```bash
   # The cert files are now NOT ignored
   ```

2. **Commit the certificate files:**
   ```bash
   git add certs/cert.pem certs/key.pem
   git commit -m "Add certificate files for GitHub Actions"
   git push origin main
   ```

3. **Done!** GitHub Actions can now access the files.

### ✅ Pros:
- Simple and straightforward
- No extra configuration needed
- Works immediately

### ⚠️ Cons:
- Certificate and private key are in git history
- Anyone with repo access can see them

---

## 🔒 Option 2: Use GitHub Secrets (Most Secure)

**Best for:**
- Public repositories
- Sensitive/production certificates
- When you want maximum security

### Steps:

#### 1. Add Secrets to GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add two secrets:

   **Secret 1:**
   - Name: `CERT_PEM`
   - Value: (paste entire content of `cert.pem`)
   ```
   -----BEGIN CERTIFICATE-----
   MIIDXTCCAkWgAwIBAgIJAKJ...
   (all the certificate content)
   ...
   -----END CERTIFICATE-----
   ```

   **Secret 2:**
   - Name: `KEY_PEM`
   - Value: (paste entire content of `key.pem`)
   ```
   -----BEGIN PRIVATE KEY-----
   MIIEvQIBADANBgkqhkiG9w0...
   (all the key content)
   ...
   -----END PRIVATE KEY-----
   ```

#### 2. Update GitHub Actions Workflow

Edit `.github/workflows/release.yml` and add this step **before** "Check certificate files":

```yaml
      - name: Create certificate files from secrets
        shell: pwsh
        run: |
          Write-Host "Creating certificate files from GitHub Secrets..."
          New-Item -ItemType Directory -Force -Path "certs" | Out-Null
          
          $certContent = @"
          ${{ secrets.CERT_PEM }}
          "@
          $certContent | Out-File -FilePath "certs\cert.pem" -Encoding ASCII -NoNewline
          
          $keyContent = @"
          ${{ secrets.KEY_PEM }}
          "@
          $keyContent | Out-File -FilePath "certs\key.pem" -Encoding ASCII -NoNewline
          
          Write-Host "✓ Certificate files created from secrets"
```

#### 3. Also update `.github/workflows/build-test.yml`

Add the same step to the test workflow.

#### 4. Keep `.gitignore` as is

```bash
# Certificate files stay ignored
certs/cert.pem
certs/key.pem
```

### ✅ Pros:
- Maximum security
- Certificates never in git history
- Safe for public repositories
- Only repo admins can see secrets

### ⚠️ Cons:
- More setup required
- Need to update secrets if certificates change

---

## 📦 Option 3: Encrypted Files in Repository

**Best for:**
- When you want version control of certificates
- But also want them encrypted

### Steps:

1. **Encrypt your certificates:**
   ```bash
   # Install GPG if needed
   brew install gpg  # macOS
   
   # Encrypt files
   gpg --symmetric --cipher-algo AES256 certs/cert.pem
   gpg --symmetric --cipher-algo AES256 certs/key.pem
   
   # This creates cert.pem.gpg and key.pem.gpg
   ```

2. **Commit encrypted files:**
   ```bash
   git add certs/cert.pem.gpg certs/key.pem.gpg
   git commit -m "Add encrypted certificates"
   git push origin main
   ```

3. **Add decryption passphrase as GitHub Secret:**
   - Go to Settings → Secrets → Actions
   - Add secret: `GPG_PASSPHRASE` with your encryption password

4. **Update workflow to decrypt:**
   ```yaml
   - name: Decrypt certificate files
     shell: pwsh
     run: |
       gpg --quiet --batch --yes --decrypt --passphrase="${{ secrets.GPG_PASSPHRASE }}" --output certs/cert.pem certs/cert.pem.gpg
       gpg --quiet --batch --yes --decrypt --passphrase="${{ secrets.GPG_PASSPHRASE }}" --output certs/key.pem certs/key.pem.gpg
   ```

### ✅ Pros:
- Certificates in version control (encrypted)
- Secure even in public repos
- Can track certificate changes

### ⚠️ Cons:
- Most complex setup
- Need to manage encryption keys

---

## 🎯 Which Option Should You Choose?

| Scenario | Recommended Option |
|----------|-------------------|
| **Private repository** | Option 1 (Commit files) |
| **Internal company use** | Option 1 (Commit files) |
| **Public repository** | Option 2 (GitHub Secrets) |
| **Production certificates** | Option 2 (GitHub Secrets) |
| **Need version control of certs** | Option 3 (Encrypted files) |
| **Quick and simple** | Option 1 (Commit files) |
| **Maximum security** | Option 2 (GitHub Secrets) |

---

## 🚀 Quick Start (Option 1 - Recommended)

Since I've already updated `.gitignore` for you, just run:

```bash
# 1. Commit certificate files
git add certs/cert.pem certs/key.pem .gitignore
git commit -m "Add certificate files for GitHub Actions"
git push origin main

# 2. Commit GitHub Actions workflows
git add .github/ RELEASE_GUIDE.md README.md CHANGES.md certs/README.md
git commit -m "Add GitHub Actions for automated build and release"
git push origin main

# 3. Create a release
git tag -a v1.0.1 -m "Release v1.0.1 - Add automated build pipeline"
git push origin v1.0.1

# 4. Wait 5-10 minutes and check:
# https://github.com/vanhuydotcom/cert-auto-trusted/releases
```

---

## 🔍 Verify Setup

After committing, verify the files are in the repository:

```bash
# Check what's tracked
git ls-files certs/

# Should show:
# certs/README.md
# certs/cert.pem          ← Should be here now!
# certs/cert.pem.example
# certs/key.pem           ← Should be here now!
# certs/key.pem.example
# certs/openssl.cnf
```

---

## ❓ FAQ

### Q: Is it safe to commit certificates to a private repository?
**A:** Yes, if only trusted people have access. Private repos are only visible to collaborators you invite.

### Q: What if I accidentally committed to a public repo?
**A:** 
1. Immediately revoke/regenerate the certificates
2. Remove from git history: `git filter-branch` or use BFG Repo-Cleaner
3. Use Option 2 (GitHub Secrets) going forward

### Q: Can I use different certificates for different releases?
**A:** Yes! Just update the files and create a new tag. Each release will use the certificates that were in the repo at that tag.

### Q: Do I need to commit the private key?
**A:** The installer bundles both cert and key. If you only commit cert.pem, the installer will work but won't include the private key.

---

## 📚 Next Steps

1. Choose your option (I recommend Option 1 for private repos)
2. Follow the steps above
3. Test with a release tag
4. Check the [RELEASE_GUIDE.md](RELEASE_GUIDE.md) for creating releases

---

**Questions?** Check the [.github/README.md](.github/README.md) or open an issue!

