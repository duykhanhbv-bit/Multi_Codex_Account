@echo off
setlocal

set "PROJECT_PATH=%~1"
if defined PROJECT_PATH shift
if not defined PROJECT_PATH (
    set /p "PROJECT_PATH=Nhap duong dan du an: "
)

if not defined PROJECT_PATH exit /b 1

for %%I in ("%PROJECT_PATH%") do set "PROJECT_PATH=%%~fI"

if not exist "%PROJECT_PATH%\." (
    echo Thu muc khong ton tai: "%PROJECT_PATH%"
    pause
    exit /b 1
)

pushd "%PROJECT_PATH%" || exit /b 1
call "%~dp0codex1.cmd" "%PROJECT_PATH%" %*
set "EXIT_CODE=%ERRORLEVEL%"
popd

exit /b %EXIT_CODE%
