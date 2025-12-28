<#
04-firewall.ps1
Add/remove Windows Firewall rules for ICARUS server ports (draft adapted from scripts.txt).
#>

param(
  [int]$GamePort,
  [int]$QueryPort
)

$ErrorActionPreference = 'Stop'

# Load environment variables from .env file
. "$PSScriptRoot\Load-Env.ps1"

# Apply defaults from environment variables if parameters not provided
if (-not $PSBoundParameters.ContainsKey('GamePort')) {
  $GamePort = if ($env:GAME_PORT) { [int]$env:GAME_PORT } else { 17777 }
}
if (-not $PSBoundParameters.ContainsKey('QueryPort')) {
  $QueryPort = if ($env:QUERY_PORT) { [int]$env:QUERY_PORT } else { 27025 }
}

$rule1 = "ICARUS Dedicated Server - GamePort $GamePort"
$rule2 = "ICARUS Dedicated Server - QueryPort $QueryPort"

# Remove existing rules with same names (safe re-run)
Get-NetFirewallRule -DisplayName $rule1 -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue
Get-NetFirewallRule -DisplayName $rule2 -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue

New-NetFirewallRule -DisplayName $rule1 -Direction Inbound -Action Allow -Protocol UDP -LocalPort $GamePort
New-NetFirewallRule -DisplayName $rule2 -Direction Inbound -Action Allow -Protocol UDP -LocalPort $QueryPort

Write-Host "Firewall rules added for UDP $GamePort and UDP $QueryPort."

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\04-firewall.ps1
# Reads from .env file, or override: -GamePort 17777 -QueryPort 27015
# Run with admin privileges to apply the rules.