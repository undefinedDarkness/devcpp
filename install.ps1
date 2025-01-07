param(
    [switch]$SkipInstall
)


# Hotfix since Powershel 5.1 doesn't have ConvertFrom-Markdown
# Meant to print formatted text in the console
function Print-Markdown {
    param(
        [string]$Message
    )

    $ansiEscape = [char]27 + "["
    $reset = "${ansiEscape}0m"
    $boldWhite = "${ansiEscape}1;37m"

    $formattedMessage = $Message -replace "\*\*(.*?)\*\*", "${boldWhite}`$1${reset}"
    Write-Host $formattedMessage
}

# Start Docker if not running
function Start-Docker {
    if (-not (Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue)) {
        Print-Markdown "Starting **Docker Desktop**:"
    } else {
        Print-Markdown "**Docker Desktop** is already running."
        return
    }
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
}

# Ensure winget is installed
function Ensure-Winget {
    Print-Markdown "Checking for **winget**:"
    try {
        (winget --version) > $null
        Print-Markdown "**winget** installed YES"
    }
    catch {
        Write-Host "Winget not present / outdated, Installing..."
        # Get the download URL of the latest winget installer from GitHub:
        $API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url |
        Where-Object { $_.EndsWith(".msixbundle") }
    
        # Download the installer:
        Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing
    
        # Install winget:
        Add-AppxPackage winget.msixbundle
    
        # Remove the installer:
        Remove-Item winget.msixbundle
    }
}

Set-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Set-Location .\env
if (!$SkipInstall) {
    Print-Markdown "**DEVC++**: A simplified C++ development environment for Windows"
    Print-Markdown "This script will install the following tools:"
    Write-Host ""
    Print-Markdown "- **Visual Studio Code**: A lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux."
    Write-Host ""
    Print-Markdown "- **Docker Desktop**: Docker Desktop is an easy-to-install application for your Mac or Windows environment that enables you to build and share containerized applications and microservices."
    Write-Host ""
    Ensure-Winget
    Write-Host ""
    Print-Markdown "Installing **Visual Studio Code**:"
    winget install --no-upgrade -e --id Microsoft.VisualStudioCode
    Print-Markdown "**Visual Studio Code** installed YES"
    Write-Host ""
    Print-Markdown "Installing **Docker Desktop**:"
    winget install --no-upgrade -e --id Docker.DockerDesktop
    Print-Markdown "**Docker Desktop** installed YES"
    Write-Host ""
    Print-Markdown "Installing **Remote Containers** for Visual Studio Code:"
    code --install-extension ms-vscode-remote.remote-containers
    Print-Markdown "**Remote Containers** installed YES"
    Write-Host ""
}
Start-Docker
Print-Markdown "Opening project directory"
Add-Type -AssemblyName "System.Windows.Forms"
[System.Windows.Forms.MessageBox]::Show("To start the project, open the project directory in Visual Studio Code and press **F1** and select **Remote-Containers: Reopen in Container** or click yes in the popup for the same","How to start") > $null
code .

Set-Location ..