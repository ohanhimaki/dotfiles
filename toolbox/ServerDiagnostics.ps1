# ServerDiagnostics.ps1
# Selvitysfunktioita palvelimille. Itsenäinen: ei riippuvuuksia muihin dotfiles-tiedostoihin,
# joten tiedoston voi ladata suoraan palvelimelle (ks. toolbox/README.md).

function Get-FolderSizes {
    <#
    .SYNOPSIS
    Listaa kansion alikansioiden koot suurimmasta pienimpään.

    .DESCRIPTION
    Laskee jokaisen alikansion tiedostojen yhteiskoon rekursiivisesti. Kansion omat
    tiedostot näkyvät rivillä "(tiedostot)". Kansiot, joihin ei ole pääsyä, ohitetaan hiljaa.

    .PARAMETER Path
    Tutkittava kansio. Oletus: nykyinen kansio.

    .EXAMPLE
    Get-FolderSizes D:\Data

    .EXAMPLE
    Get-FolderSizes | Select-Object -First 10
    #>
    param(
        [string]$Path = (Get-Location).Path
    )

    $rows = @(
        Get-ChildItem $Path -Directory -Force -ErrorAction SilentlyContinue |
        ForEach-Object {
            $size = (
                Get-ChildItem $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue |
                Measure-Object Length -Sum
            ).Sum
            [PSCustomObject]@{ Folder = $_.Name; Bytes = [double]$size }
        }
    )

    $rootSize = (
        Get-ChildItem $Path -File -Force -ErrorAction SilentlyContinue |
        Measure-Object Length -Sum
    ).Sum
    if ($rootSize) {
        $rows += [PSCustomObject]@{ Folder = '(tiedostot)'; Bytes = [double]$rootSize }
    }

    $rows |
    Sort-Object Bytes -Descending |
    Select-Object Folder,
        @{ Name = 'SizeGB'; Expression = { [math]::Round($_.Bytes / 1GB, 2) } },
        @{ Name = 'SizeMB'; Expression = { [math]::Round($_.Bytes / 1MB, 1) } }
}
