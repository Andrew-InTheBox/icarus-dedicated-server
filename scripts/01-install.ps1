<#
01-install.ps1
Install or validate ICARUS Dedicated Server via SteamCMD (draft adapted from scripts.txt).
Requires: `steamcmd.exe` available at ..\tools\steamcmd\steamcmd.exe
#>

$ErrorActionPreference = 'Stop'

$Root       = (Resolve-Path "$PSScriptRoot\..").Path
$SteamCmd   = Join-Path $Root "tools\steamcmd\steamcmd.exe"
$InstallDir = $Root
$AppId      = 2089300   # ICARUS Dedicated Server tool

if (-not (Test-Path $SteamCmd)) {
  throw "steamcmd.exe not found at: $SteamCmd"
}

Write-Host "Installing/validating ICARUS Dedicated Server to: $InstallDir"
& $SteamCmd +login anonymous +force_install_dir "$InstallDir" +app_update $AppId validate +quit
Write-Host "Done."

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\01-install.ps1
# .\scripts\01-install.ps1  # runs with project root as install directory
# Modify $AppId or paths at the top to customize behavior.