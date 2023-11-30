Import-Module posh-git
Import-Module ZLocation
Import-Module PSFzf

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-Alias -Name vim -value nvim

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


Push-Location (Split-Path -parent $profile)
"aliases" | Where-Object { Test-Path "$_.ps1" } | ForEach-Object -process { Invoke-Expression ". .\$_.ps1" }
Pop-Location

function do-easyopp-start-api {
  Push-Location C:\coding\easyopp-app\easyopp-app\Aiddo.Aw
  dotnet watch run --project .\EasyOpp.Api\EasyOpp.Api.csproj --property:SolutionDir=$PWD
}
Set-Alias easyopp-start-api do-easyopp-start-api


function do-easyopp-start {
  Push-Location C:\coding\easyopp-app\easyopp-app\Aiddo.Aw
  dotnet watch run --project .\Aiddo.Aw.Web\Aiddo.Aw.Web.csproj --property:SolutionDir=$PWD
}
Set-Alias easyopp-start do-easyopp-start


function do-easyopp-start-mobile {
  Push-Location C:\coding\easyopp-app\easyopp-app\Aiddo.Aw
  dotnet watch run --project .\Aiddo.Aw.Mobile\Aiddo.Aw.Mobile.csproj --property:SolutionDir=$PWD
}
Set-Alias easyopp-start-mobile do-easyopp-start-mobile

function print-my-logs {
  $today = Get-Date -Format "yyyy-MM-dd"
  git log --all --branches --since="$today 00:00" --author="Olli Hanhimäki" --no-merges --pretty=format:"%s"
}

Set-Alias printmylogs print-my-logs