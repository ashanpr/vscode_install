function Get-TimeStamp {
    return "[{0:MM/dd/yyyy} - {0:HH:mm:ss}]" -f (Get-Date)
}

New-Item "C:\Users\Public\Logs" -ItemType Directory -ErrorAction SilentlyContinue

Start-Transcript -Path "C:\Users\Public\Logs\VSCodeInstall.log" -Append

Write-Host "$(Get-TimeStamp) Script Name: Windows 11 VS Code Install Script"
Write-Host "$(Get-TimeStamp) Script Version: 1.0.1"
Write-Host "$(Get-TimeStamp) Script Date: 2023-03-27"
Write-Host "$(Get-TimeStamp) Script Author: Ashan Ranasinghe"
Write-Host "$(Get-TimeStamp) PowerShell Architecture: $Env:PROCESSOR_ARCHITECTURE"

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$Elevated = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host "$(Get-TimeStamp) Elevated: $Elevated"

$vsCodePath = Get-Item "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code" -ErrorAction SilentlyContinue

if ($null-ne $vsCodePath) {
    Write-Host "$(Get-TimeStamp) VS Code is already installed at $vsCodePath"
    Stop-Transcript
    exit 0 
} else {
    Write-Host "$(Get-TimeStamp) VS Code Not Installed"
    Write-Host "$(Get-TimeStamp) Downloading VS Code"

    # URL for the latest version of VS Code 
    $vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
 
    $installerPath = "$env:TEMP\vscode_installer.exe"

    Invoke-WebRequest -Uri $vscodeUrl -OutFile $installerPath

    if (Test-Path $installerPath) {
        
        Write-Host "$(Get-TimeStamp) VS Code installation started"
        $process = Start-Process $installerPath -ArgumentList "/verysilent", "/mergetasks=!runcode", "/suppressmsgboxes", "/norestart" -Wait -PassThru

        if ($process.ExitCode -eq 0) {
            Write-Host "$(Get-TimeStamp) VS Code is Successfully installed"
        } else {
            Write-Host "$(Get-TimeStamp) VS Code installation failed with exit code $($process.ExitCode)"
        }
    } else {
        Write-Host "$(Get-TimeStamp) Failed to download the installer file"
    }

}

Stop-Transcript 

Exit 0
