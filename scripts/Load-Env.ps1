<#
.SYNOPSIS
    Loads environment variables from a .env file

.DESCRIPTION
    Reads a .env file and sets environment variables for the current PowerShell session.
    Supports basic .env syntax: KEY=VALUE
    Lines starting with # are treated as comments and ignored.
    Empty lines are ignored.

.PARAMETER EnvFilePath
    Path to the .env file. Defaults to .env in the project root.

.EXAMPLE
    . .\scripts\Load-Env.ps1
    Loads variables from .env file in project root
#>

param(
    [string]$EnvFilePath = ""
)

if ([string]::IsNullOrWhiteSpace($EnvFilePath)) {
    $Root = (Resolve-Path "$PSScriptRoot\..").Path
    $EnvFilePath = Join-Path $Root ".env"
}

if (-not (Test-Path $EnvFilePath)) {
    Write-Warning ".env file not found at: $EnvFilePath"
    Write-Warning "Copy .env.example to .env and configure your settings."
    return
}

Write-Host "Loading environment from: $EnvFilePath" -ForegroundColor Cyan

Get-Content $EnvFilePath | ForEach-Object {
    $line = $_.Trim()

    # Skip comments and empty lines
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) {
        return
    }

    # Parse KEY=VALUE
    if ($line -match '^([^=]+)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()

        # Remove surrounding quotes if present
        if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") {
            $value = $matches[1]
        }

        # Set environment variable for current session
        Set-Item -Path "env:$key" -Value $value
        Write-Host "  Set $key" -ForegroundColor Green
    }
}

Write-Host "Environment loaded successfully." -ForegroundColor Green
