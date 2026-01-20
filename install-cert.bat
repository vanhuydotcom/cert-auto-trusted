@echo off
REM Quick installer script for testing without building full installer
REM Run this as Administrator to trust your cert.pem

echo ========================================
echo   Certificate Auto-Trust Tool
echo   Quick Install Script
echo ========================================
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script must be run as Administrator!
    echo Right-click this file and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

REM Check if cert.pem exists in certs directory
if not exist "certs\cert.pem" (
    echo ERROR: cert.pem not found in certs directory!
    echo Please place your cert.pem file in the certs\ folder and try again.
    echo.
    pause
    exit /b 1
)

echo Found certs\cert.pem
echo.
echo Installing certificate to Windows Trusted Root store...
echo.

REM Run PowerShell script to install certificate
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "src\Main.ps1" -CertPath "certs\cert.pem" -KeyPath "certs\key.pem"

echo.
echo ========================================
echo   Installation Complete
echo ========================================
echo.
pause

