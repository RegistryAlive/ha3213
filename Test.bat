@echo off
setlocal enabledelayedexpansion

REM Get the script's directory
set "SCRIPT_DIR=%~dp0"

REM Check if curl is installed
where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo curl is not installed. Downloading...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://curl.se/download/curl-7.79.1-win64-mingw.zip', '%SCRIPT_DIR%curl.zip')"
    powershell -command "& { Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory('%SCRIPT_DIR%curl.zip', '%SCRIPT_DIR%') }"
    del "%SCRIPT_DIR%curl.zip"
)

REM Check if powershell execution policy is set to RemoteSigned
powershell -command "if ((Get-ExecutionPolicy) -ne 'RemoteSigned') { Set-ExecutionPolicy RemoteSigned -Force }"

echo Deleting SERVER.ini
del "%SCRIPT_DIR%SERVER.ini"

echo Downloading aLogin.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/aLogin.exe', '%SCRIPT_DIR%aLogin.exe')"

echo Downloading menu.zip
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/menu.zip', '%SCRIPT_DIR%menu.zip')"

echo Downloading data.zip
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/data.zip', '%SCRIPT_DIR%data.zip')"

echo Downloading unzip.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/RegistryAlive/4444/raw/main/unzip.exe', '%SCRIPT_DIR%unzip.exe')"

echo Extracting menu.zip
"%SCRIPT_DIR%unzip.exe" "%SCRIPT_DIR%menu.zip" -d "%SCRIPT_DIR%"

echo Extracting data.zip
"%SCRIPT_DIR%unzip.exe" "%SCRIPT_DIR%data.zip" -d "%SCRIPT_DIR%"

echo Cleanup - Deleting zip files and unzip.exe
del "%SCRIPT_DIR%menu.zip"
del "%SCRIPT_DIR%data.zip"
del "%SCRIPT_DIR%unzip.exe"

echo Patcher executed successfully.
