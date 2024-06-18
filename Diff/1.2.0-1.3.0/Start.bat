@echo off
SetLocal EnableDelayedExpansion
set FilePath=%~dp0
set "oldVer=1.2.0"
set "newVer=1.3.0"
Title Cleanup obsolete files !oldVer!-!newVer! by Tom
echo Cleanup obsolete files after update from !oldVer! to !newVer! starting...
echo.
timeout /nobreak /t 10 >nul

:SelectionY
set "FileMissing=False"

if NOT exist "!FilePath!Cleanup_!oldVer!-!newVer!.txt" (
    echo "Cleanup_!oldVer!-!newVer!.txt" is missing.
    set "FileMissing=True"
)

if NOT exist "!FilePath!^Start.bat" (
    echo "Start.bat" is missing.
    set "FileMissing=True"
)

if "%FileMissing%"=="True" (
    goto Retry
) else (
    goto Query
)

:Retry
echo.
echo At least one file is missing. Please extract/download the files listed above and try again.

:Query
echo Make sure you have copied all files from the 'game_!oldVer!-!newVer!_diff_sBM8DJZc'
echo and then replace to the '!oldVer!' game client directory.
set /P "selection=Continue cleanup? (y / n): "
for %%a in (Y N) do if /i "!selection!"=="%%a" goto :Selection%%a
echo Wrong input. Valid inputs: 'y' for continue and 'n' for abort.
goto Query

:SelectionN
echo Aborted application. Exiting after the next button press.
echo.
goto End

:SelectionY
for /F "usebackq delims=" %%i in ("!FilePath!Cleanup_!oldVer!-!newVer!.txt") do (
    if exist "!FilePath!%%i" (
        attrib -R "!FilePath!%%i"
        del "!FilePath!%%i"
    )
)
set "CleanupFinished=True"

rd /S /Q "!FilePath!GenshinImpact_Data\SDKCaches\" "!FilePath!GenshinImpact_Data\webCaches\" 2>nul 
echo.
echo Cleanup obsolete files after update from !oldVer! to !newVer! is finished now. Enjoy your game :)
echo.
goto End

:End
pause
if "%CleanupFinished%"=="True" (
    del "!FilePath!deletefiles.txt" "!FilePath!Cleanup_!oldVer!-!newVer!.txt" "!FilePath!^Start.bat" 2>nul
)
