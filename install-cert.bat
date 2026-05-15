@echo off
REM Quick installer script for testing without building full installer
REM Run this as Administrator to trust your rootCA.pem

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

REM Check if rootCA.pem exists in certs directory
if not exist "certs\rootCA.pem" (
    echo ERROR: rootCA.pem not found in certs directory!
    echo Please place your rootCA.pem file in the certs\ folder and try again.
    echo.
    pause
    exit /b 1
)

echo Found certs\rootCA.pem
echo.
echo Installing Root CA to Windows Trusted Root store...
echo.

REM Run PowerShell script to install Root CA
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "src\Main.ps1" -CertPath "certs\rootCA.pem"

echo.
echo ========================================
echo   Installation Complete
echo ========================================
echo.
pause

