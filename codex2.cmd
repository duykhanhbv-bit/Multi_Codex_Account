@echo off
setlocal
set "BUNDLE_DIR=%~dp0"
set "WORKSPACE=%~1"
if "%WORKSPACE%"=="" if defined PROJECT_PATH set "WORKSPACE=%PROJECT_PATH%"
if "%WORKSPACE%"=="" (
    echo.
    echo Account 2
    set /p "WORKSPACE=Nhap duong dan du an ^(de trong de dung thu muc hien tai^): "
    if "%WORKSPACE%"=="" set "WORKSPACE=%CD%"
)
set "WORKSPACE=%WORKSPACE:"=%"
if not exist "%WORKSPACE%" (
    echo.
    echo Duong dan khong ton tai: "%WORKSPACE%"
    pause
    exit /b 1
)
powershell.exe -ExecutionPolicy Bypass -File "%BUNDLE_DIR%scripts\Start-CodexPortableAccount.ps1" -Account 2 -Workspace "%WORKSPACE%" -Inner
endlocal
