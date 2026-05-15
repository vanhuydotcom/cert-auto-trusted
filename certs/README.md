# Root CA Files Directory

## 📁 What goes here

This directory ships **only the public Root CA** that the Windows installer will add to the
Trusted Root Certification Authorities store:

- **rootCA.pem** - Your Root CA public certificate (required)

> ❗ **NEVER** put `rootCA-key.pem`, `key.pem`, or any other private key in this folder.
> The `.gitignore` blocks `*-key.pem`, `*.key`, `key.pem`, etc., but you should still be
> careful. The Root CA private key must stay on a single trusted machine only.

## 🔧 How to obtain `rootCA.pem`

If you use [mkcert](https://github.com/FiloSottile/mkcert):

```bash
# On the machine that owns the Root CA
mkcert -CAROOT
# Copy the rootCA.pem from the printed path into this directory
```

The file should look like this:

```
-----BEGIN CERTIFICATE-----
MIIE...
-----END CERTIFICATE-----
```

## ✅ Validation rules enforced by the installer

The installer will REFUSE to install the file unless ALL of the following hold:

1. ✅ It is a valid X.509 PEM certificate.
2. ✅ It is **self-signed** (Subject == Issuer).
3. ✅ It carries `BasicConstraints: CA:TRUE`.

A leaf/server certificate (the one used by your gateway/server) MUST NOT be placed here —
it would never be trusted by modern Chrome / Edge / Windows even if installed into the Root
store.

## 🖥️ Where do leaf (server) certs live then?

Leaf certs (`server-cert.pem` + `server-key.pem`) belong on the **server** that serves HTTPS,
not in this installer repo. Generate them with mkcert against your Root CA, e.g.:

```bash
mkcert -cert-file server-cert.pem -key-file server-key.pem \
  rfid-service.tech 10.10.3.115 192.168.1.5 127.0.0.1
```

Then copy those two files to the server only.

## 🚀 Quick Check

```powershell
# Windows PowerShell
Test-Path certs\rootCA.pem    # must be True
```
