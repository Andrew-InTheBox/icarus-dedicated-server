<#
03-config.ps1
Write or copy server configuration (draft adapted from scripts.txt).
Creates a minimal ServerSettings.ini suitable for a dedicated server.
#>

param(
  [string]$UserDir,
  [string]$JoinPassword,
  [int]$MaxPlayers,
  [string]$AdminPassword,
  [string]$ResumeProspect,
  [string]$LastProspectName,
  [int]$ShutdownIfNotJoinedFor,
  [int]$ShutdownIfEmptyFor,
  [string]$AllowNonAdminsToLaunchProspects,
  [string]$AllowNonAdminsToDeleteProspects
)

$ErrorActionPreference = 'Stop'

# Load environment variables from .env file
. "$PSScriptRoot\Load-Env.ps1"

# Apply defaults from environment variables if parameters not provided
if (-not $PSBoundParameters.ContainsKey('UserDir')) { $UserDir = $env:USER_DIR }
if (-not $PSBoundParameters.ContainsKey('JoinPassword')) { $JoinPassword = $env:JOIN_PASSWORD }
if (-not $PSBoundParameters.ContainsKey('MaxPlayers')) {
  $MaxPlayers = if ($env:MAX_PLAYERS) { [int]$env:MAX_PLAYERS } else { 8 }
}
if (-not $PSBoundParameters.ContainsKey('AdminPassword')) { $AdminPassword = $env:ADMIN_PASSWORD }
if (-not $PSBoundParameters.ContainsKey('ResumeProspect')) {
  $ResumeProspect = if ($env:RESUME_PROSPECT) { $env:RESUME_PROSPECT } else { "True" }
}
if (-not $PSBoundParameters.ContainsKey('LastProspectName')) { $LastProspectName = $env:LAST_PROSPECT_NAME }
if (-not $PSBoundParameters.ContainsKey('ShutdownIfNotJoinedFor')) {
  $ShutdownIfNotJoinedFor = if ($env:SHUTDOWN_IF_NOT_JOINED_FOR) { [int]$env:SHUTDOWN_IF_NOT_JOINED_FOR } else { -1 }
}
if (-not $PSBoundParameters.ContainsKey('ShutdownIfEmptyFor')) {
  $ShutdownIfEmptyFor = if ($env:SHUTDOWN_IF_EMPTY_FOR) { [int]$env:SHUTDOWN_IF_EMPTY_FOR } else { -1 }
}
if (-not $PSBoundParameters.ContainsKey('AllowNonAdminsToLaunchProspects')) {
  $AllowNonAdminsToLaunchProspects = if ($env:ALLOW_NON_ADMINS_LAUNCH_PROSPECTS) { $env:ALLOW_NON_ADMINS_LAUNCH_PROSPECTS } else { "True" }
}
if (-not $PSBoundParameters.ContainsKey('AllowNonAdminsToDeleteProspects')) {
  $AllowNonAdminsToDeleteProspects = if ($env:ALLOW_NON_ADMINS_DELETE_PROSPECTS) { $env:ALLOW_NON_ADMINS_DELETE_PROSPECTS } else { "False" }
}

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

# NOTE: Section/key names based on official ICARUS ServerSettings.ini format
$ini = @"
[/Script/Icarus.DedicatedServerSettings]
JoinPassword=$JoinPassword
MaxPlayers=$MaxPlayers
AdminPassword=$AdminPassword
ShutdownIfNotJoinedFor=$ShutdownIfNotJoinedFor
ShutdownIfEmptyFor=$ShutdownIfEmptyFor
AllowNonAdminsToLaunchProspects=$AllowNonAdminsToLaunchProspects
AllowNonAdminsToDeleteProspects=$AllowNonAdminsToDeleteProspects
ResumeProspect=$ResumeProspect
LastProspectName=$LastProspectName
"@

Set-Content -Path $CfgFile -Value $ini -Encoding UTF8
Write-Host "Wrote config: $CfgFile"

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\03-config.ps1
# Reads from .env file, or override with parameters:
# powershell -ExecutionPolicy Bypass -File .\scripts\03-config.ps1 -JoinPassword "yourpass" -MaxPlayers 12 -AdminPassword "adminpass"