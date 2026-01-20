# Certificate Files Directory

## 📁 Place Your Certificate Files Here

This directory should contain your SSL certificate files:

- **cert.pem** - Your SSL certificate (required)
- **key.pem** - Your private key (optional but recommended)

## 📝 File Format

Both files should be in PEM format (text files). They should look like:

### cert.pem
```
-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAKJ...
(base64 encoded certificate data)
...
-----END CERTIFICATE-----
```

### key.pem
```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0...
(base64 encoded private key data)
...
-----END PRIVATE KEY-----
```

## ✅ Before Building

Make sure:
1. ✅ `cert.pem` exists in this directory
2. ✅ `key.pem` exists in this directory (optional)
3. ✅ Both files are valid PEM format
4. ✅ Certificate matches your domain

## 🔒 Security Note

⚠️ **Important:** These files will be bundled into the installer. The private key will be included in the distributable .exe file. Only distribute the installer to trusted users/systems.

## 🚀 Quick Check

To verify your files are in the right place, run from the project root:

```powershell
# Windows PowerShell
Test-Path certs\cert.pem
Test-Path certs\key.pem
```

Both should return `True` if files are present.

## 📖 Examples

See the example files in this directory:
- `cert.pem.example` - Template for certificate file
- `key.pem.example` - Template for private key file

Copy your actual certificate content into `cert.pem` and `key.pem` files.

