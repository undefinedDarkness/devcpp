param(
    [switch]$SkipInstall
)


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
    Print-Markdown "Installing **Auto Run** extension for Visual Studio Code:"
    code --install-extension gabrielgrinberg.auto-run-command
    Print-Markdown "**Auto Run** installed YES"
    Write-Host ""
}
Print-Markdown "Opening project directory"
code .

Set-Location ..