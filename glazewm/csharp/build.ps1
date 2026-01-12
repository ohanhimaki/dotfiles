# Build script for GlazeWM C# Scripts

Write-Host "Building GlazeWM C# Scripts..." -ForegroundColor Cyan

# Clean previous builds
Write-Host "`nCleaning previous builds..." -ForegroundColor Yellow
Remove-Item -Path "GlazeWM.Scripts\bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "GlazeWM.Scripts\obj" -Recurse -Force -ErrorAction SilentlyContinue

# Build Debug
Write-Host "`n=== Building Debug ===" -ForegroundColor Green
dotnet build GlazeWM.Scripts\GlazeWM.Scripts.csproj -c Debug

if ($LASTEXITCODE -ne 0) {
    Write-Host "Debug build failed!" -ForegroundColor Red
    exit 1
}

# Build Release (standard optimized)
Write-Host "`n=== Building Release (Optimized) ===" -ForegroundColor Green
dotnet publish GlazeWM.Scripts\GlazeWM.Scripts.csproj -c Release

if ($LASTEXITCODE -ne 0) {
    Write-Host "Release build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Build Success! ===" -ForegroundColor Green
Write-Host "Output location: GlazeWM.Scripts\bin\Release\net8.0\win-x64\publish\" -ForegroundColor Cyan

# List output files
Write-Host "`nOutput files:" -ForegroundColor Yellow
Get-ChildItem -Path "GlazeWM.Scripts\bin\Release\net8.0\win-x64\publish\" | Select-Object Name, Length | Format-Table -AutoSize

