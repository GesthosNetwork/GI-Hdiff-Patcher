@echo off
SetLocal EnableDelayedExpansion
chcp 65001 >nul
set "oldVer=1.0.1"
set "newVer=1.1.0"
Title Cleanup obsolete files © 2024 GesthosNetwork

choice /C YN /M "Do you want to start extracting all ZIP files?"
if errorlevel 2 echo Extraction skipped. & goto Check
if not exist 7z.exe echo 7z.exe not found. & goto End

for %%f in (*.zip) do (
    echo Extracting "%%f"... Please wait, do not close the console^^!
    "7z.exe" x "%%f" -o"." -y & echo Done extracting "%%f" & echo.
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
  del 7z.exe *.bat *.zip *.dmp *.bak *.txt *.log
)