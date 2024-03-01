@echo off
setlocal enabledelayedexpansion

:Admin
NET FILE > NUL 2>&1 || POWERSHELL -ex Unrestricted -Command "Start-Process -Verb RunAs -FilePath '%ComSpec%' -ArgumentList '/c \"%~fnx0\" %*'" && EXIT /b
set "Error1=echo: &echo ==== ERROR ==== &echo:"
pushd %~dp0
goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
    ) else (
     %Error1%   
     echo This script requires administrator privileges.
     powershell write-host -fore Green Press Yes to run as Admin, the prompt will appear again.
     powershell write-host -fore Blue If you wish to exit simply press the X button.
    pause
    goto :Admin
    )

powershell write-host -fore Blue Please wait, downloading files...

REM Define URLs and corresponding file names
set "urls[1]=https://github.com/RegistryAlive/ha3213/raw/main/Data.zip"
set "urls[2]=https://github.com/RegistryAlive/ha3213/raw/main/aLogin.exe"
set "urls[3]=https://github.com/RegistryAlive/ha3213/raw/main/SERVER.INI"
set "urls[4]=https://github.com/RegistryAlive/ha3213/raw/main/menu.zip"
set "urls[5]=http://stahlworks.com/dev/unzip.exe"

REM Define file names
set "files[1]=data.zip"
set "files[2]=aLogin.exe"
set "files[3]=SERVER.INI"
set "files[4]=menu.zip"
set "files[5]=unzip.exe"

REM Number of files
set "numFiles=5"

REM Loop through each file to download using multithreading
cd /d "%~dp0"
for /l %%i in (1, 1, %numFiles%) do (
    set "url=!urls[%%i]!"
    set "file=!files[%%i]!"
    powershell write-host -fore DarkGreen Downloading please wait !file! from !url!...
    start /B powershell -Command "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('!url!', '!file!')"
)

powershell write-host -fore Blue Waiting for downloads to complete...
REM Wait for all PowerShell instances to finish
:waitForDownloads
timeout /t 1 /nobreak >nul
tasklist | findstr /i powershell.exe >nul && goto :waitForDownloads

powershell write-host -fore Magenta All files downloaded successfully.
powershell write-host -fore blue Checking for any missing files, please wait.
IF EXIST "menu.zip" IF EXIST "data.zip" IF EXIST "aLogin.exe" IF EXIST "SERVER.INI" IF EXIST "unzip.exe" (
    powershell write-host -fore blue All files exist, check completed.
    goto :CheckFIN
) ELSE (
    powershell write-host -fore red One or more files are missing.
    goto :Download
)

:Download
IF NOT EXIST "menu.zip" (
	powershell write-host -fore red menu.zip is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/uqmvyimyyzxlh62/menu.zip?dl=1', 'menu.zip')"
	powershell write-host -fore DarkGreen menu.zip downloaded.
)

IF NOT EXIST "data.zip" (
	powershell write-host -fore red data.zip is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/0o181exfczn4sk0/Data.zip?dl=1', 'data.zip')"
	powershell write-host -fore DarkGreen data.zip downloaded.
)

IF NOT EXIST "aLogin.exe" (
	powershell write-host -fore red aLogin.exe is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/r88srchgyjnf0ea/aLogin.exe?dl=1', 'aLogin.exe')"
	powershell write-host -fore DarkGreen aLogin.exe downloaded.
)

IF NOT EXIST "SERVER.INI" (
	powershell write-host -fore red SERVER.INI is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/gifrmanm5q1hvee/SERVER.INI?dl=1', 'SERVER.INI')"
	powershell write-host -fore DarkGreen SERVER.INI downloaded.
)

IF NOT EXIST "unzip.exe" (
	powershell write-host -fore red unzip.exe is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://github.com/RegistryAlive/4444/raw/main/unzip.exe', 'unzip.exe')"
	powershell write-host -fore DarkGreen unzip.exe downloaded.
)

goto :CheckFIN

:CheckFIN
Powershell write-host -fore Blue Checks completed...
powershell write-host -fore Darkgreen extracting, please wait.
echo Extraction started...
for %%i in (*.zip) do (
    powershell write-host -fore Blue Extracting %%i...
    unzip.exe -o -q "%%i"
)
powershell write-host -fore Darkgreen Extraction completed.
powershell -command "Remove-Item menu.zip -Recurse -force"
powershell -command "Remove-Item data.zip -Recurse -force"
powershell -command "Remove-Item unzip.exe -Recurse -force"
Powershell write-host -fore Darkred All files has been downloaded.
Powershell write-host -fore red You can now launch your game.

:END
pause
