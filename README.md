# Certificate Auto-Trust Tool

![Build and Release](https://github.com/vanhuydotcom/cert-auto-trusted/workflows/Build%20and%20Release/badge.svg)
![Build Test](https://github.com/vanhuydotcom/cert-auto-trusted/workflows/Build%20Test/badge.svg)

A Windows installer that adds a self-signed Root CA (`rootCA.pem`) to the Windows Trusted Root Certification Authorities store. Any HTTPS server certificate signed by that Root CA will then be trusted automatically by Windows, Chrome, and Edge.

## Features

- ✅ Installs a Root CA into the Windows trust store (LocalMachine)
- 🖥️ Simple one-click installation
- 📦 Easy-to-use Windows installer (.exe)
- 🔒 Bundles ONLY the public Root CA — no private keys are shipped
- ⚡ Works with Chrome, Edge, and other browsers using Windows cert store

## Requirements

- Windows 10 or later
- Administrator privileges (required for trusting certificates)
- PowerShell 5.1 or later

## Installation

### Using the Installer

1. Download `CertAutoTrust-Setup-1.0.0.exe`
2. Right-click the installer and select "Run as Administrator"
3. Follow the installation wizard
4. When prompted, click "Yes" to install and trust the certificate
5. Done! Your certificate is now trusted by Windows

## Usage

After installation, the certificate will be automatically trusted in Windows. You can verify by:

1. Opening Chrome or Edge
2. Visiting your HTTPS site
3. The certificate should be trusted (no security warnings)

### Manual Trust (if needed)

If you need to trust the Root CA again or on another machine:

1. Run `CertAutoTrust.exe` from the installation directory as Administrator
2. The Root CA will be installed to Trusted Root Certification Authorities

### Command-Line Usage

```powershell
# Trust the bundled Root CA
.\Main.ps1 -CertPath ".\rootCA.pem"

# Trust a different Root CA
.\Main.ps1 -CertPath "C:\path\to\your\rootCA.pem"

# Silent mode (no prompts)
.\Main.ps1 -CertPath ".\rootCA.pem" -Silent
```

> The script refuses to install any certificate that is not a self-signed CA
> (Subject must equal Issuer and `BasicConstraints CA:TRUE` must be present).

## Building from Source

### Option 1: Automated Build (Recommended)

**Using GitHub Actions** - Automatically builds and creates releases:

1. **Push a version tag:**

   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin v1.0.1
   ```

2. **GitHub Actions will automatically:**
   - Build the installer on Windows
   - Create a GitHub Release
   - Upload the installer as a downloadable asset

3. **Download from Releases:**
   - Visit: `https://github.com/vanhuydotcom/cert-auto-trusted/releases`
   - Download `CertAutoTrust-Setup-{version}.exe`

See [.github/README.md](.github/README.md) for details.

---

### Option 2: Manual Build

**Prerequisites:**

1. **Your Root CA** - Place in `certs/` directory:
   - `certs/rootCA.pem` - Your self-signed Root CA (PUBLIC certificate only)

   If you use mkcert, copy it from `mkcert -CAROOT`. NEVER place
   `rootCA-key.pem` or any private key here.

2. **ps2exe** - PowerShell to EXE converter

   ```powershell
   Install-Module -Name ps2exe -Scope CurrentUser
   ```

3. **Inno Setup** - Installer creator
   - Download from: https://jrsoftware.org/isdl.php
   - Install to default location

### Build Steps

1. **Place the Root CA** in the `certs/` directory:

   ```
   cert auto trusted/
   ├── certs/
   │   └── rootCA.pem    <-- Your Root CA here (public cert only)
   └── ...
   ```

2. Open PowerShell as Administrator

3. Navigate to the project directory

4. Run the build script:

   ```powershell
   .\build.ps1
   ```

5. The installer will be created in the `dist` folder as `CertAutoTrust-Setup-1.0.0.exe`

### Build Options

```powershell
# Skip ps2exe conversion (if already done)
.\build.ps1 -SkipPs2Exe

# Skip Inno Setup compilation
.\build.ps1 -SkipInnoSetup
```

## Project Structure

```
cert-auto-trusted/
├── certs/
│   ├── rootCA.pem            # PUBLIC Root CA (place here before building)
│   └── README.md
├── src/
│   ├── Main.ps1              # Main application entry point
│   └── TrustCertificate.ps1  # Root CA trust automation
├── launcher/
│   ├── launcher.ps1          # PowerShell launcher script
│   └── CertAutoTrust.exe     # Compiled launcher (generated)
├── installer/
│   └── setup.iss             # Inno Setup configuration
├── dist/                     # Build output (generated)
├── build.ps1                 # Build script
└── README.md                 # This file
```

## How It Works

1. **Validation**: Loads `rootCA.pem` and refuses to proceed unless it is a self-signed CA (Subject == Issuer + `BasicConstraints CA:TRUE`)
2. **Trust Automation**: Adds the Root CA to Windows' Trusted Root Certification Authorities store (LocalMachine)
3. **Packaging**: Bundles ONLY the public Root CA, converts the PowerShell launcher to EXE via ps2exe, and creates an installer with Inno Setup

## Security Notes

⚠️ **Important Security Considerations:**

- This tool installs a Root CA into the **Trusted Root Certification Authorities** store; that CA can issue certificates trusted for ANY domain on the target machine
- Only install Root CAs you trust and control
- Administrator privileges are required to modify the Windows certificate store
- **No private keys** are bundled with the installer; the Root CA private key (`rootCA-key.pem`) must stay on the CA-owner machine only
- Server-side leaf certs (`server-cert.pem` + `server-key.pem`) live on the HTTPS server, not in this repo

## Troubleshooting

### "Script execution is disabled"

Run PowerShell as Administrator and execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Not running as Administrator"

Right-click the application and select "Run as Administrator"

### Certificate not trusted in browsers

- Restart your browser after installing the certificate
- Some browsers (like Firefox) use their own certificate store
- For Chrome/Edge, the Windows certificate store is used automatically

## License

MIT License - See LICENSE.txt for details

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For issues and questions, please open an issue on the GitHub repository.
