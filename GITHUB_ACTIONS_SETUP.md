# GitHub Actions Setup Guide

## 🔐 What gets committed vs. what stays secret

This installer ships **only the public Root CA** (`certs/rootCA.pem`). No private key is
ever committed, bundled, or uploaded as an artifact.

| File                                                                   | Where it lives                               | Commit to git? |
| ---------------------------------------------------------------------- | -------------------------------------------- | -------------- |
| `certs/rootCA.pem` (public Root CA cert)                               | This repo + inside the built `.exe`          | ✅ Yes         |
| `rootCA-key.pem` (private CA key)                                      | mkcert keystore on the CA-owner machine only | ❌ NEVER       |
| `server-cert.pem` / `server-key.pem` (leaf cert + key for the gateway) | The HTTPS server only                        | ❌ NEVER       |

The repository's `.gitignore` blocks `*-key.pem`, `*.key`, `key.pem`, `*.pfx`, etc., as a
safety net.

---

## ✅ Setup (one-time)

1. On the machine that owns the Root CA, locate the public cert:
   ```bash
   mkcert -CAROOT
   # prints the directory containing rootCA.pem and rootCA-key.pem
   ```
2. Copy ONLY `rootCA.pem` into this repo at `certs/rootCA.pem`. Do not copy the key.
3. Commit and push:
   ```bash
   git add certs/rootCA.pem certs/README.md .gitignore
   git commit -m "Add Root CA for installer"
   git push origin main
   ```

That's it — GitHub Actions has everything it needs. No secrets, no encryption, no key
management required, because the Root CA cert is public information by design.

---

## 🚀 Cutting a release

```bash
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

The `Build and Release` workflow (`.github/workflows/release.yml`) will:

1. Check out the repo on a Windows runner.
2. Verify `certs/rootCA.pem` exists.
3. Install `ps2exe` and Inno Setup.
4. Run `build.ps1` to compile `CertAutoTrust-Setup-<version>.exe`.
5. Create a GitHub Release for the tag and attach the installer.

After ~5-10 minutes the `.exe` will appear at:

```
https://github.com/<your-org>/<your-repo>/releases/tag/v1.0.1
```

---

## 🧪 Pull-request / push test build

`.github/workflows/build-test.yml` runs on every PR and push to `main`. It builds the
installer with whatever `rootCA.pem` is currently committed and uploads it as an artifact
named `test-installer` (kept for 7 days). No release is created.

---

## ❓ FAQ

### Q: Is it safe to commit `rootCA.pem` to a public repo?

**A:** The certificate itself is public by design (it is sent during every TLS handshake of
servers that use it). What you must protect is the matching `rootCA-key.pem`, which gives
the holder the power to mint new certificates trusted by every machine that has installed
this installer. Keep that key on a single, well-controlled machine and never commit it.

### Q: What if I accidentally committed `rootCA-key.pem`?

**A:**

1. Treat the Root CA as compromised and stop using it.
2. Generate a new Root CA (`mkcert -uninstall && mkcert -install` re-creates one).
3. Re-issue any leaf certificates against the new Root CA.
4. Push a new release of this installer with the new `rootCA.pem`.
5. Re-install on every Windows client.
6. Purge the leaked key from git history (e.g. `git filter-repo` or BFG).

### Q: Can I rotate the Root CA?

**A:** Yes. Replace `certs/rootCA.pem` with the new one, bump the version in
`installer/setup.iss`, tag a new release. End users re-run the installer to add the new
Root CA to their trust store. You may keep the old one trusted during a transition period.

---

**Questions?** Check the [.github/README.md](.github/README.md) or open an issue.
