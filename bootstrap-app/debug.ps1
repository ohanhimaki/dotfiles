# Debug helper for dotfiles app
# Usage: .\debug.ps1 bootstrap --dry-run -v

$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot

try {
    Write-Host "Building..." -ForegroundColor Cyan
    dotnet build --nologo -v quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nRunning: dotfiles $args`n" -ForegroundColor Green
        & ".\bin\Debug\net10.0\dotfiles.exe" @args
    }
} finally {
    Pop-Location
}
