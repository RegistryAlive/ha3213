@echo off
setlocal enabledelayedexpansion

REM Get the script's directory
set "SCRIPT_DIR=%~dp0"

set DOWNLOAD_URL_SERVER_INI=https://github.com/RegistryAlive/ha3213/raw/main/SERVER.INI
set DOWNLOAD_URL_ALOGIN_EXE=https://github.com/RegistryAlive/ha3213/raw/main/aLogin.exe
set DOWNLOAD_URL_MENU_ZIP=https://github.com/RegistryAlive/ha3213/raw/main/menu.zip
set DOWNLOAD_URL_DATA_ZIP=https://github.com/RegistryAlive/ha3213/raw/main/data.zip
set DOWNLOAD_URL_UNZIP_EXE=https://github.com/RegistryAlive/4444/raw/main/unzip.exe

REM Function to download file with bitsadmin
:downloadFile
bitsadmin /transfer "DownloadJob" %1 "%2"

REM Check if the download was successful
IF NOT %ERRORLEVEL% EQU 0 (
    echo File download failed: %1
    exit /b %ERRORLEVEL%
)

REM Downloading aLogin.exe
call :downloadFile %DOWNLOAD_URL_ALOGIN_EXE% "%SCRIPT_DIR%aLogin.exe"

REM Downloading menu.zip
call :downloadFile %DOWNLOAD_URL_MENU_ZIP% "%SCRIPT_DIR%menu.zip"

REM Downloading data.zip
call :downloadFile %DOWNLOAD_URL_DATA_ZIP% "%SCRIPT_DIR%data.zip"

REM Downloading unzip.exe
call :downloadFile %DOWNLOAD_URL_UNZIP_EXE% "%SCRIPT_DIR%unzip.exe"

echo Extracting menu.zip
"%SCRIPT_DIR%unzip.exe" "%SCRIPT_DIR%menu.zip" -d "%SCRIPT_DIR%"

echo Extracting data.zip
"%SCRIPT_DIR%unzip.exe" "%SCRIPT_DIR%data.zip" -d "%SCRIPT_DIR%"

echo Cleanup - Deleting zip files and unzip.exe
del "%SCRIPT_DIR%menu.zip"
del "%SCRIPT_DIR%data.zip"
del "%SCRIPT_DIR%unzip.exe"

echo Patcher executed successfully.
