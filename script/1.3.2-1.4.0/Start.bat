@echo off
SetLocal EnableDelayedExpansion
chcp 65001 >nul
set "oldVer=1.3.2"
set "newVer=1.4.0"
Title Cleanup obsolete files © 2024 GesthosNetwork

for %%f in (*.zip *.7z) do (
    echo Extracting "%%f"... Please wait, do not close the console^^!
    if /I "%%~xf"==".zip" (
        tar -xf "%%f" -C "." && echo Done extracting "%%f"
    ) else if /I "%%~xf"==".7z" (
        "7z.exe" x "%%f" -o"." -y && echo Done extracting "%%f"
    )
    echo.
)

:Check
echo Cleanup obsolete files starting...
timeout /nobreak /t 3 >nul

set "CleanupFinished=False"
set "FileMissing=False"

if NOT exist "Cleanup_!oldVer!-!newVer!.txt" (
    echo "Cleanup_!oldVer!-!newVer!.txt" is missing.
    set "FileMissing=True"
)

if "%FileMissing%"=="True" goto End

choice /C YN /M "Continue cleanup?"
if errorlevel 2 goto End

for /F "usebackq delims=" %%i in ("Cleanup_!oldVer!-!newVer!.txt") do (
    if exist "%%i" echo Deleting "%%i" & attrib -R "%%i" && del "%%i"
)

:Empty
set "E=0" & for /d /r "GenshinImpact_Data" %%i in (*) do (rd "%%i" 2>nul & if not exist "%%i" set "E=1")
if !E! equ 1 goto Empty

set "CleanupFinished=True"
echo. & echo Cleanup obsolete files completed^^!

:End
pause
if "%CleanupFinished%"=="True" (
  (
    echo [General]
    echo channel=1
    echo cps=mihoyo
    echo game_version=!newVer!
    echo sub_channel=0
  ) > "config.ini"

  rd /s /q blob_storage "GenshinImpact_Data\SDKCaches" "GenshinImpact_Data\webCaches" 2>nul
  del *.bat *.zip *.7z hpatchz.exe 7z.exe *.dmp *.bak *.txt *.log
)