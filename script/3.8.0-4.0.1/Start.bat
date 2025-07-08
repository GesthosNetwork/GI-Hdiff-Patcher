@echo off
SetLocal EnableDelayedExpansion
chcp 65001 >nul
set "oldVer=3.8.0"
set "newVer=4.0.1"
Title GI Hdiff Patcher © 2024 GesthosNetwork

:Extract
choice /C YN /M "Do you want to start extracting all ZIP files?"
if errorlevel 2 echo Extraction skipped. & goto Check

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
echo Checking if all necessary files to update the game from Patch !oldVer! to !newVer! are present...
timeout /nobreak /t 3 >nul

set "path0=GenshinImpact_Data\StreamingAssets\AudioAssets"
set "path1=GenshinImpact_Data\StreamingAssets\AudioAssets\Chinese"
set "path2=GenshinImpact_Data\StreamingAssets\AudioAssets\English(US)"
set "path3=GenshinImpact_Data\StreamingAssets\AudioAssets\Japanese"
set "path4=GenshinImpact_Data\StreamingAssets\AudioAssets\Korean"

set hdiff=0
for %%i in (!path0!, !path1!, !path2!, !path3!, !path4!) do if exist "%%i\*.hdiff" set hdiff=1
if %hdiff%==0 (echo *.hdiff files not found. You must extract the ZIP files before proceeding. & goto Extract)

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

set PatchFinished=False
set FileMissing=False

for /F "usebackq delims=" %%i in ("AudioPatch_Common_!oldVer!-!newVer!.txt") do (
    if not exist "%%i" (
        echo "%%i" is missing.
        set FileMissing=True
    )
    if not exist "%%i.hdiff" (
        echo "%%i.hdiff" is missing.
        set FileMissing=True
    )
)

for %%l in (Chinese,English,Japanese,Korean) do (
    if %%l==Chinese set checkFile="Audio_Chinese_pkg_version"
    if %%l==English set checkFile="Audio_English(US)_pkg_version"
    if %%l==Japanese set checkFile="Audio_Japanese_pkg_version"
    if %%l==Korean set checkFile="Audio_Korean_pkg_version"
    if exist !checkFile! (
        for %%f in (AudioPatch_%%l_!oldVer!-!newVer!.txt AudioPatch_Common_!oldVer!-!newVer!.txt hpatchz.exe) do (
            if NOT exist %%~f (
                echo "%%~f is missing."
                set FileMissing=True
            )
        )
        for /F "usebackq delims=" %%j in ("AudioPatch_%%l_!oldVer!-!newVer!.txt") do (
            if NOT exist "%%j" (
                echo "%%j is missing."
                set FileMissing=True
            )
            if NOT exist "%%j.hdiff" (
                echo "%%j.hdiff is missing."
                set FileMissing=True
            )
        )
    )
)

if "%FileMissing%"=="True" goto End

choice /C YN /M "All necessary files are present. Apply patch now?"
if errorlevel 2 goto End

if exist "GenshinImpact_Data\Persistent\AudioAssets" robocopy "GenshinImpact_Data\Persistent\AudioAssets" "GenshinImpact_Data\StreamingAssets\AudioAssets" /e /copy:DAT /move

for %%l in (Chinese,English,Japanese,Korean) do (
    set "N=Audio_%%l_pkg_version"
    if "%%l"=="English" set "N=Audio_English(US)_pkg_version"
    if exist "!N!" (
        for /F "usebackq delims=" %%j in ("AudioPatch_%%l_!oldVer!-!newVer!.txt") do (
            attrib -R "%%j" && hpatchz.exe -f "%%j" "%%j.hdiff" "%%j"
        )
    )
)

for /F "usebackq delims=" %%i in ("AudioPatch_Common_!oldVer!-!newVer!.txt") do (
    attrib -R "%%i" && "hpatchz.exe" -f "%%i" "%%i.hdiff" "%%i"
)

for %%l in (Chinese,English,Japanese,Korean) do (
    for /F "usebackq delims=" %%i in ("AudioPatch_%%l_!oldVer!-!newVer!.txt") do (
			if exist "%%i.hdiff" echo Deleting "%%i.hdiff" && del "%%i.hdiff"
		)
)

for /F "usebackq delims=" %%i in ("AudioPatch_Common_!oldVer!-!newVer!.txt") do (
    if exist "%%i.hdiff" echo Deleting "%%i.hdiff" && del "%%i.hdiff"
)

for /F "usebackq delims=" %%i in ("Cleanup_!oldVer!-!newVer!.txt") do (
    if exist "%%i" echo Deleting "%%i" & attrib -R "%%i" && del "%%i"
)

:Empty
set "E=0" & for /d /r "GenshinImpact_Data" %%i in (*) do (rd "%%i" 2>nul & if not exist "%%i" set "E=1")
if !E! equ 1 goto Empty

set PatchFinished=True
echo. & echo Patch completed^^!

:End
pause
if "%PatchFinished%"=="True" (
  (
    echo [General]
    echo channel=1
    echo cps=hoyoverse
    echo game_version=!newVer!
    echo sub_channel=0
  ) > "config.ini"

  rd /s /q "GenshinImpact_Data\SDKCaches" "GenshinImpact_Data\webCaches" 2>nul
  del *.bat *.zip *.7z hpatchz.exe 7z.exe *.dmp *.bak *.txt *.log
)