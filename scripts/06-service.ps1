<#
06-service.ps1
Placeholder: Install or manage the server as a Windows Service.

Notes:
- There are multiple ways to run the server as a service. Common approaches:
  * Use NSSM (Non-Sucking Service Manager) to wrap the server exe
  * Use built-in Scheduled Task (runs at startup)
  * Write a small Windows Service wrapper

Example (NSSM-style placeholder):
# nssm install IcarusServer "C:\path\to\IcarusServer.exe" "-PORT=17777"

This file is a placeholder — tell me how you'd like the service to behave (auto-restart, logging, user account), and I'll implement it.
#>