@echo off
SetLocal EnableDelayedExpansion
set FilePath=%~dp0
set "oldVer=4.1.0"
set "newVer=4.2.0"
Title Hdiff Patcher !oldVer!-!newVer! by Tom
echo Checking if all necessary files to update the game from Patch !oldVer! to !newVer! are present...
timeout /nobreak /t 10 >nul

:SelectionY
set "audio_lang_14=GenshinImpact_Data\Persistent\audio_lang_14"
set "used_language="

type nul > "%audio_lang_14%"

if exist "GenshinImpact_Data\StreamingAssets\AudioAssets\Chinese" (
    set /p="Chinese" <nul >> "%audio_lang_14%"
    set "used_language=Chinese"
)
if exist "GenshinImpact_Data\StreamingAssets\AudioAssets\English(US)" (
    if defined used_language echo. >> "%audio_lang_14%"
    set /p="English(US)" <nul >> "%audio_lang_14%"
    set "used_language=English(US)"
)
if exist "GenshinImpact_Data\StreamingAssets\AudioAssets\Korean" (
    if defined used_language echo. >> "%audio_lang_14%"
    set /p="Korean" <nul >> "%audio_lang_14%"
    set "used_language=Korean"
)
if exist "GenshinImpact_Data\StreamingAssets\AudioAssets\Japanese" (
    if defined used_language echo. >> "%audio_lang_14%"
    set /p="Japanese" <nul >> "%audio_lang_14%"
    set "used_language=Japanese"
)

set PatchFinished=False
set FileMissing=False
set ChineseInstalled=False
set EnglishInstalled=False
set JapaneseInstalled=False
set KoreanInstalled=False
set CurrentLanguage=None
set LangCheck=None

for /F "usebackq delims=" %%i in ("!FilePath!GenshinImpact_Data\Persistent\audio_lang_14") do (
	if "%%i"=="Chinese" (
		set ChineseInstalled=True
		set CurrentLanguage=Chinese
	)
	if "%%i"=="English(US)" (
		set EnglishInstalled=True
		set CurrentLanguage=English
	)
	if "%%i"=="Japanese" (
		set JapaneseInstalled=True
		set CurrentLanguage=Japanese
	)
	if "%%i"=="Korean" (
		set KoreanInstalled=True
		set CurrentLanguage=Korean
	)
	
	if NOT exist "!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt" (
		echo "AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt" is missing.
		set FileMissing=True
		set CurrentLanguage=None
	)
)
if NOT exist "!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt" (
	echo "AudioPatch_Common_!oldVer!-!newVer!.txt" is missing.
	set FileMissing=True
)

if "%FileMissing%"=="True" (
	goto Retry
) else (
	goto MoveLang
)

:MoveLang
robocopy "!FilePath!GenshinImpact_Data\Persistent\AudioAssets" "!FilePath!GenshinImpact_Data\StreamingAssets\AudioAssets" /e /copy:DAT /dcopy:DAT /move
mkdir "!FilePath!GenshinImpact_Data\Persistent\AudioAssets"
for /L %%i in (1,1,4) do (
	if "%%i"=="1" (
		if "%ChineseInstalled%"=="True" (
			set CurrentLanguage=Chinese
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="2" (
		if "%EnglishInstalled%"=="True" (
			set CurrentLanguage=English
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="3" (
		if "%JapaneseInstalled%"=="True" (
			set CurrentLanguage=Japanese
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="4" (
		if "%KoreanInstalled%"=="True" (
			set CurrentLanguage=Korean
		) else (
			set CurrentLanguage=None
		)
	)
	if NOT "!CurrentLanguage!"=="None" (
		if "!CurrentLanguage!"=="English" (
			set "LangCheck=English(US)"
		) else (
			set LangCheck=!CurrentLanguage!
		)
		for /F "usebackq delims=" %%j in ("!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt") do (
			if NOT exist "!FilePath!%%j" (
				
				echo "!FilePath!%%j" is missing.
				set FileMissing=True
			)
			if NOT exist "!FilePath!%%j.hdiff" (
				echo "!FilePath!%%j.hdiff" is missing.
				set FileMissing=True
			)
		)
	)
)

for /F "usebackq delims=" %%i in ("!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt") do (
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

for /L %%i in (1,1,4) do (
	if "%%i"=="1" (
		if "%ChineseInstalled%"=="True" (
			set CurrentLanguage=Chinese
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="2" (
		if "%EnglishInstalled%"=="True" (
			set CurrentLanguage=English
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="3" (
		if "%JapaneseInstalled%"=="True" (
			set CurrentLanguage=Japanese
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="4" (
		if "%KoreanInstalled%"=="True" (
			set CurrentLanguage=Korean
		) else (
			set CurrentLanguage=None
		)
	)
	if NOT "!CurrentLanguage!"=="None" (
		for /F "usebackq delims=" %%j in ("!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt") do (
			attrib -R "!FilePath!%%j"
			"!FilePath!hpatchz.exe" -f "!FilePath!%%j" "!FilePath!%%j.hdiff" "!FilePath!%%j"
		)
	)
)
for /F "usebackq delims=" %%i in ("!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt") do (
	attrib -R "!FilePath!%%i"
	"!FilePath!hpatchz.exe" -f "!FilePath!%%i" "!FilePath!%%i.hdiff" "!FilePath!%%i"
)
set PatchFinished=True

for /L %%i in (1,1,4) do (
	if "%%i"=="1" (
		if "%ChineseInstalled%"=="True" (
			set CurrentLanguage=Chinese
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="2" (
		if "%EnglishInstalled%"=="True" (
			set CurrentLanguage=English
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="3" (
		if "%JapaneseInstalled%"=="True" (
			set CurrentLanguage=Japanese
		) else (
			set CurrentLanguage=None
		)
	)
	if "%%i"=="4" (
		if "%KoreanInstalled%"=="True" (
			set CurrentLanguage=Korean
		) else (
			set CurrentLanguage=None
		)
	)
	if NOT "!CurrentLanguage!"=="None" (
		for /F "usebackq delims=" %%k in ("!FilePath!AudioPatch_!CurrentLanguage!_!oldVer!-!newVer!.txt") do (
			if exist "!FilePath!%%k.hdiff" (
				del "!FilePath!%%k.hdiff"
			)
		)
	)
)

for /F "usebackq delims=" %%i in ("!FilePath!Cleanup_!oldVer!-!newVer!.txt") do (
		if exist "!FilePath!%%i" (
			attrib -R "!FilePath!%%i"
			del "!FilePath!%%i"
		)
	)
)

for /F "usebackq delims=" %%i in ("!FilePath!AudioPatch_Common_!oldVer!-!newVer!.txt") do (
	if exist "!FilePath!%%i.hdiff" (
		del "!FilePath!%%i.hdiff"
	)
)

for %%F in (
	driverError.log
    deletefiles.txt
	hdifffiles.txt
	hpatchz.exe
    hdiffz.exe
    Cleanup_!oldVer!-!newVer!.txt
    AudioPatch_Common_!oldVer!-!newVer!.txt
    AudioPatch_Chinese_!oldVer!-!newVer!.txt
    AudioPatch_English_!oldVer!-!newVer!.txt
    AudioPatch_Japanese_!oldVer!-!newVer!.txt
    AudioPatch_Korean_!oldVer!-!newVer!.txt
) do (
    if exist "!FilePath!%%F" del "!FilePath!%%F"
)

rd /S /Q "!FilePath!GenshinImpact_Data\StreamingAssets\Audio\" "!FilePath!GenshinImpact_Data\SDKCaches\" "!FilePath!GenshinImpact_Data\webCaches\" 2>nul 
echo.
echo Patch application is finished now. Enjoy your game :)
echo.
goto End

:End
pause
if "%PatchFinished%"=="True" (
	if exist "!FilePath!^Start.bat" (
		del "!FilePath!^Start.bat"
	)
)