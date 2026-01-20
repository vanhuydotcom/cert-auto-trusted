; Inno Setup Script for Certificate Auto-Trust Tool
; This creates a Windows installer (.exe) for the certificate generation tool

#define MyAppName "Certificate Auto-Trust Tool"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Your Organization"
#define MyAppURL "https://yourwebsite.com"
#define MyAppExeName "CertAutoTrust.exe"

[Setup]
; Application information
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; Installation directories
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes

; Output configuration
OutputDir=..\dist
OutputBaseFilename=CertAutoTrust-Setup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes

; Windows version requirements
MinVersion=10.0
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

; UI configuration
WizardStyle=modern
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}

; License and info files
LicenseFile=..\LICENSE.txt
InfoBeforeFile=..\INSTALL_INFO.txt

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
; Main application files
Source: "..\src\Main.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\src\TrustCertificate.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\launcher\CertAutoTrust.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion isreadme
; Certificate files (user should place cert.pem and key.pem in certs folder before building)
Source: "..\certs\cert.pem"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\certs\key.pem"; DestDir: "{app}"; Flags: ignoreversion; AfterInstall: SetFilePermissions

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Comment: "Generate and trust SSL certificates"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; Comment: "Generate and trust SSL certificates"
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  if not IsAdminInstallMode then
  begin
    MsgBox('This application requires Administrator privileges to install and run properly.' + #13#10 +
           'Please run the installer as Administrator.', mbError, MB_OK);
    Result := False;
  end;
end;

procedure SetFilePermissions();
var
  KeyFile: String;
begin
  // Restrict access to key.pem file
  KeyFile := ExpandConstant('{app}\key.pem');
  // Note: Additional security can be added here using icacls or similar
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  AppPath: String;
begin
  if CurStep = ssPostInstall then
  begin
    AppPath := ExpandConstant('{app}');

    // Automatically run the certificate trust tool after installation
    if MsgBox('Do you want to install and trust the certificate now?', mbConfirmation, MB_YESNO) = IDYES then
    begin
      Exec(ExpandConstant('{app}\CertAutoTrust.exe'), '', AppPath, SW_SHOW, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;

