@echo off
setlocal enabledelayedexpansion

:: Debug Mode (set to 1 to enable)
set "DEBUG=0"

:: Check if curl is installed
where curl >nul 2>&1
if errorlevel 1 (
    echo ERROR: curl is not installed or not in PATH.
    pause
    exit /b 1
)

:: Check if a file argument is provided
if "%~1"=="" (
    echo ERROR: No file specified!
    echo Usage: %~nx0 file_to_upload
    pause
    exit /b 1
)

:: Check if the file exists
set "FILE=%~1"
if not exist "%FILE%" (
    echo ERROR: File "%FILE%" not found!
    pause
    exit /b 1
)

:: Generate a bin name (based on timestamp)
set "BIN=uupdump_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "BIN=%BIN: =0%"

:: Debug: Show bin name
if "%DEBUG%"=="1" (
    echo Filebin bin: %BIN%
)

echo Uploading file to filebin.net, please wait...

:: Upload file to Filebin
curl --progress-bar ^
     -X POST ^
     -H "Content-Type: application/octet-stream" ^
     --data-binary "@%FILE%" ^
     "https://filebin.net/%BIN%/%~nx1" >nul

if errorlevel 1 (
    echo ERROR: Upload failed.
    pause
    exit /b 1
)

:: Construct download link
set "LINK=https://filebin.net/%BIN%/%~nx1"

echo.
echo Upload successful! Download link:
echo %LINK%
pause
