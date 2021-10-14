
Import-Module posh-git 
Import-module ZLocation

function goCoding {
    Set-Location c:\coding
    Get-ChildItem | Sort-object LastWriteTime
}

New-Alias koodailut goCoding
function goDocuments {
    Set-Location 'C:\Users\OlliHanhimäki\OneDrive - Oiwa Solutions Oy\AADokumentointeja'
    Get-ChildItem | Sort-object LastWriteTime
    code .
}

New-Alias dokut goDocuments

function goSerres {
    Set-Location 'C:\Users\OlliHanhimäki\OneDrive - Oiwa Solutions Oy\AADokumentointeja\serres'
    Get-ChildItem | Sort-object LastWriteTime
    code .
}

New-Alias serres goSerres

function goAtria {
    Set-Location 'C:\Users\OlliHanhimäki\OneDrive - Oiwa Solutions Oy\AADokumentointeja\atria'
    Get-ChildItem | Sort-object LastWriteTime
    code .
}

New-Alias atria goAtria


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
