<#
07-status.ps1
Check if the ICARUS dedicated server is running
#>

$process = Get-Process -Name "IcarusServer-Win64-Shipping" -ErrorAction SilentlyContinue

if ($process) {
  Write-Host "ICARUS Server is RUNNING" -ForegroundColor Green
  Write-Host ""
  $process | Select-Object Id, ProcessName, @{Name="CPU(s)";Expression={$_.CPU}}, @{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet64/1MB,2)}}, StartTime | Format-Table -AutoSize
  Write-Host "To stop the server, run: .\07-stop.ps1"
} else {
  Write-Host "ICARUS Server is NOT running" -ForegroundColor Yellow
  Write-Host "To start the server, run: .\05-run.ps1"
}
