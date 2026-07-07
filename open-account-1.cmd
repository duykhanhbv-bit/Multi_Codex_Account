@echo off
setlocal
set "BUNDLE_DIR=%~dp0"
set "WORKSPACE=%~1"
if "%WORKSPACE%"=="" set "WORKSPACE=%CD%"
powershell.exe -ExecutionPolicy Bypass -File "%BUNDLE_DIR%scripts\Start-CodexPortableAccount.ps1" -Account 1 -Workspace "%WORKSPACE%"
endlocal
