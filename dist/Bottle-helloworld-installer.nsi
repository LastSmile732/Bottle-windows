; Bottle-helloworld.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install Bottle-helloworld.nsi into a directory that the user selects,

;--------------------------------

; The name of the installer
Name "Bottle-helloworld"

; The file to write
OutFile "bottle-helloworld-installer.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Bottle-helloworld


; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Bottle-helloworld" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "Bottle-helloworld (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "Bottle-helloworld-installer.nsi"
  File /r ".\hello\*"

  ; Write the installation path into the registry
  SetRegView 64
  WriteRegStr HKLM SOFTWARE\Bottle-helloworld "Install_Dir" "$INSTDIR"
  
  ;SimpleSC::InstallService "Bottle-helloworld" "Bottle-helloworld" "16" "2" "$INSTDIR\hello.exe"
  ;StrCpy $R0 '"$SYSDIR\cmd.exe" /c "$INSTDIR\nssm-2.24\win64\nssm install Bottle-helloworld $INSTDIR\hello.exe"'
  ;nsExec::ExecToStack '$R0'

  ;StrCpy $R0 '"$SYSDIR\cmd.exe" /c "sc create Bottle-helloworld binpath="$INSTDIR\hello.exe" DisplayName=Bottle-helloworld start=auto"'
  ;nsExec::ExecToStack '$R0'
  ;Pop $R1
  ;Pop $R2
  StrCpy $0 "$INSTDIR\nssm-2.24\win64\nssm.exe"
  StrCpy $1 "Bottle-helloworld"
  StrCpy $2 "$INSTDIR\hello.exe"
  StrCpy $3 "$INSTDIR"
  Pop $0
  Pop $1
  Pop $2
  Pop $3
  DetailPrint "Install Service: $1"
  nsExec::Exec '"$0" install "$1" "$2"'
  nsExec::Exec '"$0" set "$1" AppDirectory "$3"'

  ; Write the uninstall keys for Windows
  SetRegView 64
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Bottle-helloworld" "DisplayName" "Bottle-helloworld"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Bottle-helloworld" "UninstallString" '"$INSTDIR\uninstall.exe"'
  ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "Bottle-helloworld" '"$INSTDIR\hello.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Bottle-helloworld" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Bottle-helloworld" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Bottle-helloworld"
  CreateShortcut "$SMPROGRAMS\Bottle-helloworld\hello.lnk" "$INSTDIR\hello.exe" "" "$INSTDIR\hello.exe" 0
  CreateShortcut "$SMPROGRAMS\Bottle-helloworld\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "$SMPROGRAMS\Bottle-helloworld\Bottle-helloworld (MakeNSISW).lnk" "$INSTDIR\Bottle-helloworld-installer.nsi" "" "$INSTDIR\Bottle-helloworld-installer.nsi" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  ;SimpleSC::ServiceIsRunning "Bottle-helloworld"
  ;Pop $0 ; returns an errorcode (<>0) otherwise success (0)
  ;SimpleSC::StopService "Bottle-helloworld" 1 30
  ;Pop $0 ; returns an errorcode (<>0) otherwise success (0)
  ;SimpleSC::RemoveService "Bottle-helloworld"
  ;Pop $0 ; returns an errorcode (<>0) otherwise success (0)

  ;StrCpy $R0 '"$SYSDIR\cmd.exe" /c "sc query Bottle-helloworld | FIND /C "RUNNING""'
  ;nsExec::ExecToStack '$R0'
  ;Pop $R1
  ;Pop $R2

  ;StrCpy $R3 '"$SYSDIR\cmd.exe" /c "sc stop Bottle-helloworld"'
  ;nsExec::ExecToStack '$R3'
  ;Pop $R4

  ;StrCpy $R6 '"$SYSDIR\cmd.exe" /c "sc delete Bottle-helloworld"'
  ;nsExec::ExecToStack '$R6'
  ;Pop $R7
  ;StrCpy $R3 '"$SYSDIR\cmd.exe" /c "$INSTDIR\nssm-2.24\win64\nssm remove Bottle-helloworld confirm"'
  ;nsExec::ExecToStack '$R3'
  StrCpy $0 "$INSTDIR\nssm-2.24\win64\nssm.exe"
  StrCpy $1 "Bottle-helloworld"
  Pop $0
  Pop $1
  DetailPrint "Uninstall Service: $1"
  nsExec::Exec '"$0" stop "$1"'
  nsExec::Exec '"$0" remove "$1" confirm'

  ; Remove registry keys
  SetRegView 64
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Bottle-helloworld"
  ;DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Run\Bottle-helloworld"
  DeleteRegKey HKLM SOFTWARE\Bottle-helloworld

  ; Remove files and uninstaller
  ; Delete $INSTDIR\Bottle-helloworld-installer.nsi
  Delete /REBOOTOK $INSTDIR\*.*
  Delete /REBOOTOK $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Bottle-helloworld\*.*"

  ; Remove directories used
  RMDir /r /REBOOTOK "$SMPROGRAMS\Bottle-helloworld"
  RMDir /r /REBOOTOK "$INSTDIR"

SectionEnd
