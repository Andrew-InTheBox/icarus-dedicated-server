<#
08-restart.ps1
Restart the ICARUS dedicated server
#>

$ErrorActionPreference = 'Stop'

Write-Host "Restarting ICARUS Server..." -ForegroundColor Cyan

# Stop the server if running
$process = Get-Process -Name "IcarusServer-Win64-Shipping" -ErrorAction SilentlyContinue
if ($process) {
  Write-Host "Stopping running server..." -ForegroundColor Yellow
  & "$PSScriptRoot\07-stop.ps1"
  Start-Sleep -Seconds 3
}

# Start the server
Write-Host "Starting server..." -ForegroundColor Green
& "$PSScriptRoot\05-run.ps1"

Write-Host "Server restart initiated." -ForegroundColor Green
Write-Host "Check status with: .\07-status.ps1"

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\08-restart.ps1
