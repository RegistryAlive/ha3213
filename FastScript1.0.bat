@setlocal DisableDelayedExpansion
@echo off

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

powershell write-host -fore blue Downloading WLRI Translation Files
Powershell -command "$ProgressPreference ='silentlyContinue'; Remove-Item SERVER.INI -Recurse -force"
Powershell write-host -fore red Downloading data files
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/Data.zip', 'data.zip')"
Powershell write-host -fore green data files downloaded
Powershell write-host -fore red Downloading aLogin
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/aLogin.exe', 'aLogin.exe')"
Powershell write-host -fore green aLogin.exe downloaded
Powershell write-host -fore red Downloading Server.ini
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/SERVER.INI', 'SERVER.INI')"
Powershell write-host -fore green SERVER.ini downloaded
Powershell write-host -fore red downloading menu please wait
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('http://stahlworks.com/dev/unzip.exe', 'unzip.exe')"
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://github.com/RegistryAlive/ha3213/raw/main/menu.zip', 'menu.zip')"
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
	powershell write-host -fore red menu.zip is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/0o181exfczn4sk0/data.zip?dl=1', 'data.zip')"
	powershell write-host -fore DarkGreen data.zip downloaded.
)

IF NOT EXIST "aLogin.exe" (
	powershell write-host -fore red menu.zip is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/r88srchgyjnf0ea/aLogin.exe?dl=1', 'aLogin.exe')"
	powershell write-host -fore DarkGreen aLogin.exe downloaded.
)

IF NOT EXIST "SERVER.INI" (
	powershell write-host -fore red menu.zip is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/gifrmanm5q1hvee/SERVER.INI?dl=1', 'SERVER.INI')"
	powershell write-host -fore DarkGreen SERVER.INI downloaded.
)

IF NOT EXIST "unzip.exe" (
	powershell write-host -fore red menu.zip is missing, proceeding to download from Server 1.
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://github.com/RegistryAlive/4444/raw/main/unzip.exe', 'unzip.exe')"
	powershell write-host -fore DarkGreen unzip.exe downloaded.
)

goto :CheckFIN

:CheckFIN
Powershell write-host -fore Blue Checks completed...
powershell write-host -fore Darkgreen extracting menu, please wait.
unzip.exe -o -q menu.zip
powershell write-host -fore Darkgreen extraction completed.
powershell write-host -fore Darkgreen extracting data, please wait.
unzip.exe -o -q data.zip
powershell write-host -fore Darkgreen extraction completed.
powershell -command "Remove-Item menu.zip -Recurse -force"
powershell -command "Remove-Item data.zip -Recurse -force"
powershell -command "Remove-Item unzip.exe -Recurse -force"
Powershell write-host -fore Darkred All files has been downloaded.
Powershell write-host -fore red You can now launch your game.
goto :END

:END
pause