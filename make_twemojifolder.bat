@echo off
SETLOCAL EnableDelayedExpansion
cd /D %~dp0

REM Set PATH only if you arent added inkscape already
SET PATH=%PATH%;C:\Program Files\Inkscape\

REM Folder where emojis are stored (git repository)
REM e.g.:<path to your Twemoji folder>\2\svg
set /p emoji_dir=Enter emoji dir path: 

REM Folder where you extracted the standard Windows folder icon
set baseicons_dir=%~dp0\src\folder
REM Temp dir
set temp_dir=%~dp0\tmp
REM The dir where the finished icons are stored
set final_dir=%~dp0\bin\folder

mkdir %final_dir%

for /f %%f in ('dir /b /O:N %emoji_dir%') do (
	echo %%f
	REM Pasta temporária
	mkdir %temp_dir%\%%~nf
	cd /D %temp_dir%\%%~nf
	
	REM Processa svg do emoji
	inkscape %emoji_dir%\%%f --export-png="emoji_256.png" -w120 -h120 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_64.png" -w32 -h32 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_48.png" -w24 -h24 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_40.png" -w20 -h20 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_32.png" -w16 -h16 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_24.png" -w12 -h12 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_20.png" -w10 -h10 --without-gui
	inkscape %emoji_dir%\%%f --export-png="emoji_16.png" -w16 -h16 --without-gui
	
	REM Composite the folder icon
	magick %baseicons_dir%\256.png emoji_256.png -gravity SouthEast -geometry +16+29 -composite "compositeicon_256.png"
	magick %baseicons_dir%\64.png emoji_64.png -gravity SouthEast -geometry +4+6 -composite "compositeicon_64.png"
	magick %baseicons_dir%\48.png emoji_48.png -gravity SouthEast -geometry +3+6 -composite "compositeicon_48.png"
	magick %baseicons_dir%\40.png emoji_40.png -gravity SouthEast -geometry +2+5 -composite "compositeicon_40.png"
	magick %baseicons_dir%\32.png emoji_32.png -gravity SouthEast -geometry +3+3 -composite "compositeicon_32.png"
	magick %baseicons_dir%\24.png emoji_24.png -gravity SouthEast -geometry +1+3 -composite "compositeicon_24.png"
	magick %baseicons_dir%\20.png emoji_20.png -gravity SouthEast -geometry +2+2 -composite "compositeicon_20.png"
	xcopy /Y emoji_16.png compositeicon_16.png*
	
	REM Make the .ico	
	magick compositeicon_256.png compositeicon_64.png compositeicon_48.png compositeicon_40.png compositeicon_32.png compositeicon_24.png compositeicon_20.png compositeicon_16.png %final_dir%\%%~nf.ico

	REM Clear screen
	cls
)

cd /D %~dp0\bin
rmdir /s /q %temp_dir%

pause

