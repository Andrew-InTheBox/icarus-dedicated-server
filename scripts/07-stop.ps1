<#
07-stop.ps1
Stop the ICARUS dedicated server
#>

$ErrorActionPreference = 'Stop'

$process = Get-Process -Name "IcarusServer-Win64-Shipping" -ErrorAction SilentlyContinue

if ($process) {
  Write-Host "Stopping ICARUS Server (PID: $($process.Id))..." -ForegroundColor Yellow
  Stop-Process -Name "IcarusServer-Win64-Shipping" -Force
  Start-Sleep -Seconds 2

  $stillRunning = Get-Process -Name "IcarusServer-Win64-Shipping" -ErrorAction SilentlyContinue
  if ($stillRunning) {
    Write-Host "Server is still running. Forcing termination..." -ForegroundColor Red
    Stop-Process -Id $stillRunning.Id -Force
  } else {
    Write-Host "Server stopped successfully." -ForegroundColor Green
  }
} else {
  Write-Host "ICARUS Server is not running." -ForegroundColor Yellow
}

# Examples:
# powershell -ExecutionPolicy Bypass -File .\scripts\07-stop.ps1
