@echo off
setlocal EnableDelayedExpansion

:Admin
NET FILE > NUL 2>&1 || POWERSHELL -ex Unrestricted -Command "Start-Process -Verb RunAs -FilePath '%ComSpec%' -ArgumentList '/c \"%~fnx0\" %*'" && EXIT /b

:check_Permissions
echo Administrative permissions required. Detecting permissions...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    powershell write-host -fore Green Press Yes to run as Admin, the prompt will appear again.
    powershell write-host -fore Blue If you wish to exit simply press the X button.
    pause
    goto :Admin
)

echo Downloading files...

REM Define URLs and corresponding file names
set "urls[1]=https://github.com/RegistryAlive/ha3213/raw/main/Data.zip"
set "urls[2]=https://github.com/RegistryAlive/ha3213/raw/main/aLogin.exe"
set "urls[3]=https://github.com/RegistryAlive/ha3213/raw/main/SERVER.INI"
set "urls[4]=https://www.dropbox.com/scl/fi/gsci77pimiw293tkjn42q/pic.zip?rlkey=fkfvmir8iyh5turs64p8rbvm3&dl=1"
set "urls[5]=https://www.dropbox.com/scl/fi/spam7k1guiw6qdmrmz434/sty.zip?rlkey=hvrond1ugfeu3nnqtnuo9vblc&dl=1"
set "urls[6]=https://www.dropbox.com/scl/fi/yo3j9fyl18ddl6q8oxkbx/jma.zip?rlkey=qbch72cfsssc7dmgu6f00kuto&dl=1"
set "urls[7]=https://github.com/RegistryAlive/ha3213/raw/main/menu.zip"
set "urls[8]=http://stahlworks.com/dev/unzip.exe"

REM Define file names
set "files[1]=data.zip"
set "files[2]=aLogin.exe"
set "files[3]=SERVER.INI"
set "files[4]=pic.zip"
set "files[5]=sty.zip"
set "files[6]=jma.zip"
set "files[7]=menu.zip"
set "files[8]=unzip.exe"

REM Number of files
set "numFiles=8"

REM Loop through each file to download using multithreading
cd /d "%~dp0"
for /l %%i in (1, 1, %numFiles%) do (
    set "url=!urls[%%i]!"
    set "file=!files[%%i]!"
    echo Downloading !file! from !url!...
    start /B powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('!url!', '!file!')"
)

echo Waiting for downloads to complete...
REM Wait for all PowerShell instances to finish
:waitForDownloads
timeout /t 1 /nobreak >nul
tasklist | findstr /i powershell.exe >nul && goto :waitForDownloads

echo All files downloaded successfully.

echo Extraction started...
for %%i in (*.zip) do (
    echo Extracting %%i...
    unzip.exe -o -q "%%i"
)

echo Cleanup...
del /q data.zip
del /q menu.zip
del /q pic.zip
del /q sty.zip
del /q jma.zip
del /q unzip.exe

echo All files downloaded and extracted successfully.
echo You can now launch your game.

pause
