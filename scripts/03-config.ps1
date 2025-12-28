<#
03-config.ps1
Write or copy server configuration (draft adapted from scripts.txt).
Creates a minimal ServerSettings.ini suitable for a dedicated server.
#>

$ErrorActionPreference = 'Stop'

# Load environment variables from .env file
. "$PSScriptRoot\Load-Env.ps1"

param(
  [string]$UserDir = $env:USER_DIR,
  [string]$JoinPassword = $env:JOIN_PASSWORD,
  [int]$MaxPlayers = $(if ($env:MAX_PLAYERS) { [int]$env:MAX_PLAYERS } else { 8 }),
  [string]$AdminPassword = $env:ADMIN_PASSWORD
)

$Root = (Resolve-Path "$PSScriptRoot\..").Path

# Default ICARUS user dir if you don't use -UserDir
if ([string]::IsNullOrWhiteSpace($UserDir)) {
  $Base = Join-Path $env:LOCALAPPDATA "Icarus"
} else {
  $Base = $UserDir
}

$CfgDir  = Join-Path $Base "Saved\Config\WindowsServer"
$CfgFile = Join-Path $CfgDir "ServerSettings.ini"

New-Item -ItemType Directory -Force -Path $CfgDir | Out-Null

# NOTE: Section/key names are based on common UE ini style; adjust/extend as needed for your server behavior.
# Keep it simple: core access control + player cap.
$ini = @"
[ServerSettings]
JoinPassword=$JoinPassword
MaxPlayers=$MaxPlayers
AdminPassword=$AdminPassword
"@

Set-Content -Path $CfgFile -Value $ini -Encoding UTF8
Write-Host "Wrote config: $CfgFile"

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\03-config.ps1
# Reads from .env file, or override with parameters:
# powershell -ExecutionPolicy Bypass -File .\scripts\03-config.ps1 -JoinPassword "yourpass" -MaxPlayers 12 -AdminPassword "adminpass"