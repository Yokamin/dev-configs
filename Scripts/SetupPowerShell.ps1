# Function to check if script is running as Admin
function Test-Admin {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Step 1: Ensure the script is running in PowerShell 7 as Admin
$PowerShell7 = Get-Command pwsh -ErrorAction SilentlyContinue

if ($PowerShell7) {
    if ($env:ReLaunched -ne "true") {
        Write-Host "PowerShell 7 is installed. Relaunching in PowerShell 7 as Administrator outside Windows Terminal..."

        # Set a flag to avoid relaunch loop
        $env:ReLaunched = "true"

        # Relaunch in PowerShell 7 as Administrator
        $scriptPath = $MyInvocation.MyCommand.Path
        $command = "Set-Location -Path (Split-Path `"$scriptPath`"); & `"$scriptPath`""  # Preserve script path
        Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-Command $command"
        exit
    }
} else {
    # Step 2: PowerShell 7 is not installed. Check for admin privileges in current session.
    Write-Host "PowerShell 7 is not installed. Checking admin privileges in current session..."

    if (!(Test-Admin)) {
        Write-Host "Current session is not running as Administrator. Relaunching in PowerShell 5 as Admin to install PowerShell 7..."

        # Relaunch current script in PowerShell 5 as Admin
        $scriptPath = $MyInvocation.MyCommand.Path
        $command = "Set-Location -Path (Split-Path `"$scriptPath`"); & `"$scriptPath`""  
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-Command $command"
        exit
    }

    # Step 3: Install PowerShell 7 in elevated session
    Write-Host "Installing PowerShell 7..."
    winget install --id Microsoft.Powershell --source winget --accept-source-agreements --accept-package-agreements
    Write-Host "Installation complete. Relaunching in PowerShell 7 as Administrator..."

    # Relaunch in PowerShell 7 as Administrator after installation
    $scriptPath = $MyInvocation.MyCommand.Path
    $command = "Set-Location -Path (Split-Path `"$scriptPath`"); & `"$scriptPath`""  
    Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-Command $command"
    exit
}

# Step 4: Close Windows Terminal if running to avoid conflicts
Write-Host "Checking if Windows Terminal is running..."
$terminalProcess = Get-Process -Name "WindowsTerminal" -ErrorAction SilentlyContinue
if ($terminalProcess) {
    Write-Host "Closing Windows Terminal to avoid conflicts with settings update..."
    Stop-Process -Name "WindowsTerminal" -Force
    Start-Sleep -Seconds 2  # Ensure the process is completely closed
}

# Step 5: Modify Windows Terminal settings.json
Write-Host "Configuring Windows Terminal settings..."
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $settingsPath) {
    $settings = Get-Content -Path $settingsPath | ConvertFrom-Json -Depth 100

    # Find or create a PowerShell 7 profile
    $pwshProfile = $settings.profiles.list | Where-Object { $_.commandline -match "pwsh" }
    if ($pwshProfile) {
        Write-Host "PowerShell 7 profile found. Configuring settings..."
        $pwshProfile.elevate = $true
        $settings.defaultProfile = "$($pwshProfile.guid)"
    } else {
        Write-Host "PowerShell 7 profile not found. Adding a new profile..."
        $newProfile = @{
            guid = "{$([guid]::NewGuid())}"
            name = "PowerShell 7"
            commandline = "pwsh.exe"
            startingDirectory = "%USERPROFILE%"
            elevate = $true
        }
        $settings.profiles.list += $newProfile
        $settings.defaultProfile = "$($newProfile.guid)"
    }

    # Save the updated settings with validation
    $jsonString = $settings | ConvertTo-Json -Depth 100
    try {
        $jsonString | ConvertFrom-Json | Out-Null  # Validate JSON
        $jsonString | Set-Content -Path $settingsPath -Force
        Write-Host "Windows Terminal settings updated successfully."
    } catch {
        Write-Host "Error: Invalid JSON format. Settings were not saved." -ForegroundColor Red
    }
} else {
    Write-Host "Windows Terminal settings.json not found. Skipping configuration."
}

# Step 6: Ensure custom modules folder is included in PowerShell path
$customModulesPath = Join-Path (Split-Path $PSScriptRoot -Parent) "PowerShell\Modules"
$env:PSModulePath = "$customModulesPath;" + $env:PSModulePath
Write-Host "PowerShell module path configured: $customModulesPath"

# Step 7: Load PowerShell profile from the repo
$ProfilePath = Join-Path (Split-Path $PSScriptRoot -Parent) "PowerShell\Profiles\Microsoft.PowerShell_profile.ps1"
if (Test-Path $ProfilePath) {
    . $ProfilePath
    Write-Host "PowerShell profile loaded from $ProfilePath"
}

# Step 8: Gather summary information and relaunch Windows Terminal
Write-Host "Setup complete. Relaunching Windows Terminal..."
$psVersion = (Get-Command pwsh).FileVersionInfo.ProductVersion
$isAdmin = (Test-Admin) -eq $true

# Build the summary message
$summaryMessage = @"
Write-Host 'Setup Complete!'
Write-Host '-------------------------------------'
Write-Host 'PowerShell Version: $psVersion'
Write-Host 'Running as Admin: $isAdmin'
Write-Host 'Default PowerShell: PowerShell 7'
Write-Host 'Default Profile Path: $ProfilePath'
Write-Host 'Custom Module Path: $customModulesPath'
Write-Host '-------------------------------------'
"@

# Launch Windows Terminal and display the summary message
Start-Process "wt.exe" -ArgumentList "-- pwsh", "-NoExit", "-Command", $summaryMessage
