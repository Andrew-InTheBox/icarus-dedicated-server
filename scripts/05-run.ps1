<#
05-run.ps1
Start the ICARUS dedicated server (draft adapted from scripts.txt).
Customize ServerName, ports, and optional UserDir.
#>

param(
  [string]$ServerName,
  [int]$GamePort,
  [int]$QueryPort,
  [string]$UserDir
)

$ErrorActionPreference = 'Stop'

# Load environment variables from .env file
. "$PSScriptRoot\Load-Env.ps1"

# Apply defaults from environment variables if parameters not provided
if (-not $PSBoundParameters.ContainsKey('ServerName')) {
  $ServerName = if ($env:SERVER_NAME) { $env:SERVER_NAME } else { "My ICARUS Server" }
}
if (-not $PSBoundParameters.ContainsKey('GamePort')) {
  $GamePort = if ($env:GAME_PORT) { [int]$env:GAME_PORT } else { 17777 }
}
if (-not $PSBoundParameters.ContainsKey('QueryPort')) {
  $QueryPort = if ($env:QUERY_PORT) { [int]$env:QUERY_PORT } else { 27015 }
}
if (-not $PSBoundParameters.ContainsKey('UserDir')) { $UserDir = $env:USER_DIR }

$Root = (Resolve-Path "$PSScriptRoot\..").Path

$Exe = Join-Path $Root "Icarus\Binaries\Win64\IcarusServer-Win64-Shipping.exe"
if (-not (Test-Path $Exe)) { throw "Server EXE not found at: $Exe" }

$args = @(
  "-SteamServerName=`"$ServerName`""
  "-PORT=$GamePort"
  "-QueryPort=$QueryPort"
)

if (-not [string]::IsNullOrWhiteSpace($UserDir)) {
  $args += "-UserDir=`"$UserDir`""
}

Write-Host "Starting: $Exe $($args -join ' ')"
Start-Process -FilePath $Exe -ArgumentList $args -WorkingDirectory (Split-Path $Exe)

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\05-run.ps1
# Reads from .env file, or override with parameters:
# powershell -ExecutionPolicy Bypass -File .\scripts\05-run.ps1 -ServerName "My Server" -GamePort 17777
# Add -UserDir "D:\IcarusData" to change save location.