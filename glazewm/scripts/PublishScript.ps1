param(
    [string]$ProjectPath = '.\GlazeWmScripts.GlazeWm.Scripts\GlazeWmScripts.GlazeWm.Scripts.csproj',
    [string]$OutputPath = '.\publish',
    [string]$Configuration = 'Release',
    [string]$Runtime = 'win-x64',
    [string]$ExecutableName = 'GlazeWmScripts.GlazeWm.Scripts.exe',
    [string]$DestinationPath = 'C:\projects\bin\GlazeWmScripts.GlazeWm.Scripts.exe',
    [switch]$CopyToBin,
    [switch]$NoCopy
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    return [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath $Path))
}

if ($CopyToBin.IsPresent -and $NoCopy.IsPresent) {
    throw 'Use either -CopyToBin or -NoCopy, not both.'
}

$resolvedProjectPath = Resolve-FullPath -Path $ProjectPath
$resolvedOutputPath = Resolve-FullPath -Path $OutputPath

Write-Host 'Starting publish script...'

New-Item -ItemType Directory -Path $resolvedOutputPath -Force | Out-Null

$publishArguments = @(
    'publish'
    $resolvedProjectPath
    '-c'
    $Configuration
    '--self-contained'
    'true'
    '-r'
    $Runtime
    '/p:PublishSingleFile=true'
    '/p:PublishReadyToRun=true'
    '/p:PublishTrimmed=true'
    '-o'
    $resolvedOutputPath
)

& dotnet @publishArguments

if ($LASTEXITCODE -ne 0) {
    throw "dotnet publish failed with exit code $LASTEXITCODE."
}

Write-Host 'Publish script completed.'

$shouldCopy = $CopyToBin.IsPresent

if (-not $CopyToBin.IsPresent -and -not $NoCopy.IsPresent) {
    $response = Read-Host 'Do you want to copy the published executable to C:\projects\bin\? (y/n)'
    $shouldCopy = $response.Trim().Equals('y', [System.StringComparison]::OrdinalIgnoreCase)
}

if (-not $shouldCopy) {
    Write-Host 'Executable copy skipped.'
    return
}

$sourceFile = Join-Path -Path $resolvedOutputPath -ChildPath $ExecutableName

if (-not (Test-Path -Path $sourceFile -PathType Leaf)) {
    throw "Published executable was not found: $sourceFile"
}

$destinationDirectory = Split-Path -Path $DestinationPath -Parent
if ($destinationDirectory) {
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
}

Copy-Item -Path $sourceFile -Destination $DestinationPath -Force
Write-Host "Executable copied successfully to $DestinationPath"
