<#
02-update.ps1
Update the installed ICARUS server via SteamCMD (draft adapted from scripts.txt).
#>

$ErrorActionPreference = 'Stop'

$Root       = (Resolve-Path "$PSScriptRoot\..").Path
$SteamCmd   = Join-Path $Root "tools\steamcmd\steamcmd.exe"
$InstallDir = $Root
$AppId      = 2089300

if (-not (Test-Path $SteamCmd)) { throw "steamcmd.exe not found at: $SteamCmd" }

Write-Host "Updating server in $InstallDir"
& $SteamCmd +force_install_dir "$InstallDir" +login anonymous  +app_update $AppId +quit
Write-Host "Update complete."

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\02-update.ps1
# Run this regularly to pull server updates from Steam.