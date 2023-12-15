# Specify the name of the IIS application pool and the path of the application directory
$appName = "testapp"
$site = "Default Web Site"
$appPoolName = "DefaultAppPool"
$appDirectoryPath = "C:\inetpub\wwwroot\testapp"

# Specify the target path for the compacted file
$targetPath = "C:\Users\patrickreinan\git\backup"

# Specify the log file path
$logFilePath = "C:\Users\patrickreinan\git\log.txt"

mkdir $targetPath -Force
# Function to log messages to both console and file
function Log-Message {
    param(
        [string]$message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"

    # Log to console
    Write-Host $logEntry

    # Log to file
    Add-Content -Path $logFilePath -Value $logEntry
}

# Log the start of the script
Log-Message "Script started."

# Check if the IIS application is stopped
$appStatus = Get-WebAppPoolState -Name $appPoolName

if ($appStatus.Value -eq 'Stopped') {
    Log-Message "The IIS application is stopped. Removing the application from IIS."

    # Remove the IIS application
    Remove-WebApplication -Site $site -Name $appName

    # Compact the application directory
    $compactFileName = "$appPoolName-$(Get-Date -Format 'yyyyMMdd-HHmmss').zip"
    Compress-Archive -Path $appDirectoryPath -DestinationPath "$targetPath\$compactFileName"

    Log-Message "Application removed, directory compacted, and file copied to $targetPath."

    # Remove the application directory
    Remove-Item -Path $appDirectoryPath -Recurse -Force
} else {
    Log-Message "The IIS application is not stopped. No action needed."
}

# Log the end of the script
Log-Message "Script completed."
