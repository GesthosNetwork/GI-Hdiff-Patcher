@echo off
SetLocal EnableDelayedExpansion
set FilePath=%~dp0
set "oldVer=2.5.0"
set "newVer=2.6.0"
Title Hdiff Patcher !oldVer!-!newVer! by Tom
echo Checking if all necessary files to update the game from Patch !oldVer! to !newVer! are present...
timeout /nobreak /t 10 >nul

:SelectionY
set PatchFinished=False
set FileMissing=False
for /F "usebackq delims=" %%i in ("!FilePath!GamePatch_!oldVer!-!newVer!.txt") do (
    if NOT exist "!FilePath!%%i" (
        echo "!FilePath!%%i" is missing.
        set FileMissing=True
    )
    if NOT exist "!FilePath!%%i.hdiff" (
        echo "!FilePath!%%i.hdiff" is missing.
        set FileMissing=True
    )
)
if NOT exist "!FilePath!hpatchz.exe" (
    echo "!FilePath!hpatchz.exe" is missing.
    set FileMissing=True
)

if "%FileMissing%"=="True" (
    goto Retry
) else (
    goto ApplyPatch
)

:Retry
echo.
echo At least one file is missing. Please extract/download the necessary files listed above and try again.

:Query
set /P selection=Retry patch application now? (y / n): 
for %%a in (Y N) do if /i '%selection%'=='%%a' goto :Selection%%a
echo Wrong input. Valid inputs: 'y' for retry and 'n' for abort.
goto Query

:SelectionN
echo Aborted patch application. Exiting after next button press.
echo.
goto End

:ApplyPatch
echo All necessary files are present. Applying patch now...
echo.
timeout /nobreak /t 10 >nul

for /F "usebackq delims=" %%i in ("!FilePath!GamePatch_!oldVer!-!newVer!.txt") do (
    "!FilePath!hpatchz.exe" -f "!FilePath!%%i" "!FilePath!%%i.hdiff" "!FilePath!%%i"
)
set PatchFinished=True

for /F "usebackq delims=" %%i in ("!FilePath!Cleanup_!oldVer!-!newVer!.txt") do (
	if exist "!FilePath!%%i" (
        attrib -R "!FilePath!%%i"
        del "!FilePath!%%i"
    )
)

for /F "usebackq delims=" %%i in ("!FilePath!GamePatch_!oldVer!-!newVer!.txt") do (
    del "!FilePath!%%i.hdiff"
)

for %%F in (
	deletefiles.txt
	hdifffiles.txt
	hpatchz.exe
	hdiffz.exe
	GamePatch_!oldVer!-!newVer!.txt
	Cleanup_!oldVer!-!newVer!.txt
) do (
    if exist "!FilePath!%%F" del "!FilePath!%%F"
)

rd /S /Q "!FilePath!GenshinImpact_Data\SDKCaches\" "!FilePath!GenshinImpact_Data\webCaches\" 2>nul
echo.
echo Patch application is finished now. Enjoy your game :)
echo.
goto End

:End
pause
if "%PatchFinished%"=="True" (
    del "!FilePath!^Start.bat"
)