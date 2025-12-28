<#
09-logs.ps1
View ICARUS server logs
#>

param(
  [switch]$Tail,
  [int]$Lines = 50,
  [switch]$Open
)

$ErrorActionPreference = 'Stop'

# Load environment variables from .env file
. "$PSScriptRoot\Load-Env.ps1"

# Determine log directory
if (-not [string]::IsNullOrWhiteSpace($env:USER_DIR)) {
  $LogDir = Join-Path $env:USER_DIR "Saved\Logs"
} else {
  $LogDir = Join-Path $env:LOCALAPPDATA "Icarus\Saved\Logs"
}

$LogFile = Join-Path $LogDir "Icarus.log"

if (-not (Test-Path $LogFile)) {
  Write-Host "No log file found at: $LogFile" -ForegroundColor Yellow
  Write-Host "Server may not have started yet, or logs are in a different location."
  exit 1
}

if ($Open) {
  # Open log file in default text editor
  Write-Host "Opening log file: $LogFile" -ForegroundColor Cyan
  Start-Process $LogFile
} elseif ($Tail) {
  # Follow log file (like tail -f)
  Write-Host "Tailing log file: $LogFile" -ForegroundColor Cyan
  Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
  Write-Host ""
  Get-Content -Path $LogFile -Tail $Lines -Wait
} else {
  # Show last N lines
  Write-Host "Last $Lines lines of: $LogFile" -ForegroundColor Cyan
  Write-Host ""
  Get-Content -Path $LogFile -Tail $Lines
}

# Examples:
# .\scripts\09-logs.ps1                    # Show last 50 lines
# .\scripts\09-logs.ps1 -Lines 100         # Show last 100 lines
# .\scripts\09-logs.ps1 -Tail              # Follow log (like tail -f)
# .\scripts\09-logs.ps1 -Open              # Open in text editor
