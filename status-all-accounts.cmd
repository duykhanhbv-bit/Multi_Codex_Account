@echo off
setlocal
set "BUNDLE_DIR=%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "%BUNDLE_DIR%scripts\Show-CodexPortableAccountsStatus.ps1"
endlocal
