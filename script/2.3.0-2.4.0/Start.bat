@echo off
SetLocal EnableDelayedExpansion
chcp 65001 >nul
set "oldVer=2.3.0"
set "newVer=2.4.0"
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

set "path1=GenshinImpact_Data\StreamingAssets\Audio\GeneratedSoundBanks\Windows\Chinese"
set "path2=GenshinImpact_Data\StreamingAssets\Audio\GeneratedSoundBanks\Windows\English(US)"
set "path3=GenshinImpact_Data\StreamingAssets\Audio\GeneratedSoundBanks\Windows\Japanese"
set "path4=GenshinImpact_Data\StreamingAssets\Audio\GeneratedSoundBanks\Windows\Korean"

if not exist "Audio_Chinese_pkg_version" rd /s /q !path1! 2>nul
if not exist "Audio_English(US)_pkg_version" rd /s /q !path2! 2>nul
if not exist "Audio_Japanese_pkg_version" rd /s /q !path3! 2>nul
if not exist "Audio_Korean_pkg_version" rd /s /q !path4! 2>nul

set "audio_lang_14=GenshinImpact_Data\Persistent\audio_lang_14"
set "used_language="
md "GenshinImpact_Data\Persistent" > nul 2>&1 & type nul > "!audio_lang_14!"

if exist !path1! (
    set /p="Chinese" <nul >> !audio_lang_14!
    set "used_language=Chinese"
)
if exist !path2! (
    if defined used_language echo. >> !audio_lang_14!
    set /p="English(US)" <nul >> !audio_lang_14!
    set "used_language=English(US)"
)
if exist !path3! (
    if defined used_language echo. >> !audio_lang_14!
    set /p="Japanese" <nul >> !audio_lang_14!
    set "used_language=Japanese"
)
if exist !path4! (
    if defined used_language echo. >> !audio_lang_14!
    set /p="Korean" <nul >> !audio_lang_14!
    set "used_language=Korean"
)

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
  del 7z.exe hpatchz.exe *.bat *.zip *.dmp *.bak *.txt *.log
)