# Set the current location to the script directory
Set-Location $PSScriptRoot

# Delete existing SERVER.INI
Remove-Item -Path ".\SERVER.INI" -ErrorAction SilentlyContinue

# Download the config.json file
$configUrl = "https://github.com/RegistryAlive/ha3213/raw/main/config.json"
$configPath = ".\config.json"
Invoke-WebRequest -Uri $configUrl -OutFile $configPath

# Load config.json
$config = Get-Content -Path $configPath | ConvertFrom-Json

# Prompt user for output directory
$outputDirectory = Read-Host "Enter the output directory path"

# Prompt user to select the server (GitHub/Dropbox/Backblaze)
Write-Host "Select a server:"
$serverSelection = $config.Server | ForEach-Object { "$_ - $config.Server.IndexOf($_)" }
$selectedServerIndex = (Read-Host "$serverSelection (Enter the index)").Trim()
$selectedServer = $config.Server[$selectedServerIndex]

# Iterate through the files in the selected server
foreach ($fileType in @("Server", "aLogin", "Menu", "Data")) {
    $fileUrls = $config.$fileType
    $selectedUrl = $fileUrls | ForEach-Object { "$_ - $fileUrls.IndexOf($_)" }
    
    # Download the file
    Invoke-WebRequest -Uri $selectedUrl -OutFile "$outputDirectory\$fileType.zip"

    # Check if the file is downloaded successfully
    if (Test-Path "$outputDirectory\$fileType.zip") {
        # Extract the zip file
        Expand-Archive -Path "$outputDirectory\$fileType.zip" -DestinationPath $outputDirectory -Force
        Write-Host "$fileType files downloaded and extracted successfully."
    } else {
        # If download fails, try alternative links
        Write-Host "Failed to download $fileType from the selected link. Trying alternative links."

        foreach ($altUrl in $fileUrls) {
            Invoke-WebRequest -Uri $altUrl -OutFile "$outputDirectory\$fileType.zip"
            
            # Check if the file is downloaded successfully
            if (Test-Path "$outputDirectory\$fileType.zip") {
                # Extract the zip file
                Expand-Archive -Path "$outputDirectory\$fileType.zip" -DestinationPath $outputDirectory -Force
                Write-Host "$fileType files downloaded and extracted successfully using alternative link."
                break
            }
        }
    }
}

Write-Host "Script execution completed."
